param(
  [Parameter(Mandatory = $true)]
  [string]$ManifestPath,

  [string]$OutputRoot = "C:\Users\wsk71.DKO\Desktop\Frontend Developer\design-memory\reference-bank",

  [string]$SnapshotRoot = "C:\Users\wsk71.DKO\Desktop\Frontend Developer\design-memory\harvested",

  [string]$PlaywrightCli,

  [switch]$CaptureScreenshots,

  [switch]$OverwriteMarkdown,

  [int]$MaxItems = 0,

  [int]$DesktopWidth = 1440,
  [int]$DesktopHeight = 2200,
  [int]$MobileWidth = 390,
  [int]$MobileHeight = 844
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Get-Slug {
  param([string]$Value)

  $slug = $Value.ToLowerInvariant()
  $slug = [regex]::Replace($slug, "[^a-z0-9]+", "-")
  $slug = $slug.Trim("-")

  if ([string]::IsNullOrWhiteSpace($slug)) {
    throw "Could not create a slug from '$Value'."
  }

  return $slug
}

function New-ReferenceMarkdown {
  param(
    [pscustomobject]$Reference,
    [pscustomobject]$Metadata,
    [string]$DesktopShot,
    [string]$MobileShot,
    [string]$FetchError,
    [string]$ScreenshotError
  )

  $borrowLines = @()
  foreach ($item in $Reference.borrow) {
    $borrowLines += "- $item"
  }

  $avoidLines = @()
  foreach ($item in $Reference.avoid) {
    $avoidLines += "- $item"
  }

  $screenshotLines = @()
  if ($DesktopShot) {
    $screenshotLines += "- Desktop: $DesktopShot"
  }
  if ($MobileShot) {
    $screenshotLines += "- Mobile: $MobileShot"
  }
  if ($screenshotLines.Count -eq 0) {
    $screenshotLines += "- Not captured yet"
  }

  $statusLines = @()
  if ($FetchError) {
    $statusLines += "- Fetch note: $FetchError"
  }
  if ($ScreenshotError) {
    $statusLines += "- Screenshot note: $ScreenshotError"
  }
  if ($statusLines.Count -eq 0) {
    $statusLines += "- No harvest warnings"
  }

  $content = @()
  $content += "# Reference Entry"
  $content += ""
  $content += "- Name: $($Reference.name)"
  $content += "- URL or source: $($Metadata.final_url)"
  $content += "- Product type: $($Reference.product_type)"
  $content += "- Bucket: $($Reference.bucket)"
  $content += "- Category: $($Reference.category)"
  $content += "- Date reviewed: $($Metadata.fetched_at)"
  $content += "- Page title: $($Metadata.page_title)"
  $content += ""
  $content += "## First impression"
  $content += ""
  $content += "- Strong: $($Reference.strong)"
  $content += "- Weak: $($Reference.weak)"
  $content += ""
  $content += "## What to borrow"
  $content += ""
  $content += $borrowLines
  $content += ""
  $content += "## What not to borrow"
  $content += ""
  $content += $avoidLines
  $content += ""
  $content += "## Why this matters"
  $content += ""
  $content += "- $($Reference.why_this_matters)"
  $content += ""
  $content += "## Reusable lesson"
  $content += ""
  $content += "- $($Reference.reusable_lesson)"
  $content += ""
  $content += "## Harvest artifacts"
  $content += ""
  $content += $screenshotLines
  $content += ""
  $content += "## Harvest status"
  $content += ""
  $content += $statusLines

  return ($content -join "`r`n")
}

if (-not (Test-Path -LiteralPath $ManifestPath)) {
  throw "Manifest not found: $ManifestPath"
}

$manifest = Get-Content -LiteralPath $ManifestPath -Raw | ConvertFrom-Json
$runDate = Get-Date -Format "yyyy-MM-dd"
$runRoot = Join-Path $SnapshotRoot $runDate
New-Item -ItemType Directory -Force -Path $runRoot | Out-Null

$items = @($manifest)
if ($MaxItems -gt 0) {
  $items = $items | Select-Object -First $MaxItems
}

$playwrightAvailable = $false
if ($CaptureScreenshots) {
  if ([string]::IsNullOrWhiteSpace($PlaywrightCli)) {
    throw "CaptureScreenshots was set but no PlaywrightCli was provided."
  }

  if (-not (Test-Path -LiteralPath $PlaywrightCli)) {
    throw "Playwright CLI not found: $PlaywrightCli"
  }

  $playwrightAvailable = $true
}

$summary = @()
$headers = @{
  "User-Agent" = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.0.0 Safari/537.36"
  "Accept-Language" = "en-US,en;q=0.9"
}

foreach ($reference in $items) {
  $slug = if ($reference.slug) { $reference.slug } else { Get-Slug -Value $reference.name }
  $bucketDir = Join-Path $OutputRoot $reference.bucket
  $artifactDir = Join-Path $runRoot $slug
  $markdownPath = Join-Path $bucketDir "$slug.md"
  $metadataPath = Join-Path $artifactDir "metadata.json"
  $desktopShot = Join-Path $artifactDir "desktop.png"
  $mobileShot = Join-Path $artifactDir "mobile.png"
  $fetchError = $null
  $screenshotError = $null
  $pageTitle = "Unknown"
  $finalUrl = $reference.url

  New-Item -ItemType Directory -Force -Path $bucketDir | Out-Null
  New-Item -ItemType Directory -Force -Path $artifactDir | Out-Null

  Write-Host "Harvesting $($reference.name)..." -ForegroundColor Cyan

  try {
    $response = Invoke-WebRequest -Uri $reference.url -MaximumRedirection 5 -TimeoutSec 45 -Headers $headers

    if ($response.Content -match "<title[^>]*>(.*?)</title>") {
      $pageTitle = [System.Net.WebUtility]::HtmlDecode($matches[1]).Trim()
    }

    if ($response.BaseResponse) {
      $baseResponseMembers = $response.BaseResponse | Get-Member

      if ($baseResponseMembers.Name -contains "ResponseUri") {
        $finalUrl = $response.BaseResponse.ResponseUri.AbsoluteUri
      }
      elseif (($baseResponseMembers.Name -contains "RequestMessage") -and $response.BaseResponse.RequestMessage.RequestUri) {
        $finalUrl = $response.BaseResponse.RequestMessage.RequestUri.AbsoluteUri
      }
    }
  }
  catch {
    $fetchError = $_.Exception.Message
  }

  if ($playwrightAvailable) {
    try {
      & $PlaywrightCli screenshot --browser=chromium --viewport-size="$DesktopWidth,$DesktopHeight" $finalUrl $desktopShot | Out-Null
      & $PlaywrightCli screenshot --browser=chromium --viewport-size="$MobileWidth,$MobileHeight" $finalUrl $mobileShot | Out-Null
    }
    catch {
      $screenshotError = $_.Exception.Message
    }
  }

  if (-not (Test-Path -LiteralPath $desktopShot)) {
    $desktopShot = $null
  }
  if (-not (Test-Path -LiteralPath $mobileShot)) {
    $mobileShot = $null
  }

  $metadata = [pscustomobject]@{
    slug = $slug
    name = $reference.name
    requested_url = $reference.url
    final_url = $finalUrl
    page_title = $pageTitle
    bucket = $reference.bucket
    category = $reference.category
    fetched_at = $runDate
    fetch_error = $fetchError
    screenshot_error = $screenshotError
  }

  $metadata | ConvertTo-Json -Depth 6 | Set-Content -LiteralPath $metadataPath -Encoding utf8

  if ($OverwriteMarkdown -or -not (Test-Path -LiteralPath $markdownPath)) {
    $markdown = New-ReferenceMarkdown -Reference $reference -Metadata $metadata -DesktopShot $desktopShot -MobileShot $mobileShot -FetchError $fetchError -ScreenshotError $screenshotError
    Set-Content -LiteralPath $markdownPath -Value $markdown -Encoding utf8
  }

  $status = "ok"
  if ($fetchError -or $screenshotError) {
    $status = "partial"
  }

  $summary += [pscustomobject]@{
    name = $reference.name
    bucket = $reference.bucket
    file = $markdownPath
    artifact_dir = $artifactDir
    status = $status
    fetch_error = $fetchError
    screenshot_error = $screenshotError
  }

  if ($fetchError) {
    Write-Warning "Fetch note for $($reference.name): $fetchError"
  }
  if ($screenshotError) {
    Write-Warning "Screenshot note for $($reference.name): $screenshotError"
  }
}

$summaryPath = Join-Path $runRoot "summary.json"
$summary | ConvertTo-Json -Depth 6 | Set-Content -LiteralPath $summaryPath -Encoding utf8

Write-Host ""
Write-Host "Harvest complete." -ForegroundColor Green
Write-Host "Summary: $summaryPath"

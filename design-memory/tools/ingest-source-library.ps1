param(
    [Parameter(Mandatory = $true)]
    [string]$ManifestPath,
    [switch]$CloneRepos,
    [switch]$OverwriteMarkdown,
    [int]$MaxItems = 0,
    [string]$CloneRoot
)

$ErrorActionPreference = "Stop"

$designMemoryRoot = Split-Path -Path $PSScriptRoot -Parent
$sourceLibraryRoot = Join-Path $designMemoryRoot "source-library"
$harvestRoot = Join-Path (Join-Path $designMemoryRoot "harvested") (Join-Path "source-code" (Get-Date -Format 'yyyy-MM-dd'))

if (-not $CloneRoot) {
    $CloneRoot = Join-Path $sourceLibraryRoot "clones"
}

$userAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) CodexSourceLibrary/1.0"

function New-DirectoryIfMissing {
    param([string]$Path)

    if (-not (Test-Path -LiteralPath $Path)) {
        New-Item -ItemType Directory -Path $Path -Force | Out-Null
    }
}

function Invoke-SafeRequest {
    param([string]$Url)

    if ([string]::IsNullOrWhiteSpace($Url)) {
        return [ordered]@{
            ok = $false
            status = "missing"
            final_url = $null
            title = $null
            content_length = 0
            error = "No URL provided."
        }
    }

    try {
        $response = Invoke-WebRequest -Uri $Url -Headers @{ "User-Agent" = $userAgent } -MaximumRedirection 10 -TimeoutSec 30
        $title = $null
        $finalUrl = $Url

        if ($response.Content -match "<title[^>]*>(.*?)</title>") {
            $title = (($Matches[1] -replace "\s+", " ").Trim())
        }

        if ($response.BaseResponse -and $response.BaseResponse.ResponseUri) {
            $finalUrl = $response.BaseResponse.ResponseUri.AbsoluteUri
        }

        return [ordered]@{
            ok = $true
            status = "ok"
            final_url = $finalUrl
            title = $title
            content_length = $response.Content.Length
            error = $null
        }
    }
    catch {
        return [ordered]@{
            ok = $false
            status = "error"
            final_url = $Url
            title = $null
            content_length = 0
            error = $_.Exception.Message
        }
    }
}

function Format-BulletList {
    param([object[]]$Items)

    if (-not $Items -or $Items.Count -eq 0) {
        return "- None recorded yet."
    }

    return (($Items | ForEach-Object { "- $_" }) -join "`r`n")
}

function Build-Markdown {
    param(
        [pscustomobject]$Entry,
        [object]$DocsMeta,
        [object]$RepoMeta,
        [string]$MetadataPath,
        [string]$ClonePath
    )

    $teaches = Format-BulletList -Items $Entry.teaches
    $inspect = Format-BulletList -Items $Entry.inspect
    $avoid = Format-BulletList -Items $Entry.avoid

    $cloneBlock = if ($ClonePath) {
        "- Local clone target: $ClonePath"
    }
    else {
        "- Local clone target: not created in this run"
    }

    return @"
# $($Entry.name)

## Snapshot

- Bucket: $($Entry.bucket)
- Focus: $($Entry.focus)
- Product type: $($Entry.product_type)
- Docs: $($Entry.docs_url)
- Repo: $($Entry.repo_url)

## What This Teaches

$teaches

## What To Inspect First

$inspect

## What Not To Copy Blindly

$avoid

## Why This Matters

$($Entry.why_this_matters)

## Reusable Lesson

$($Entry.reusable_lesson)

## Harvest Metadata

- Metadata snapshot: $MetadataPath
- Docs check: $($DocsMeta.status)
- Docs final URL: $($DocsMeta.final_url)
- Repo check: $($RepoMeta.status)
- Repo final URL: $($RepoMeta.final_url)
$cloneBlock
"@
}

New-DirectoryIfMissing -Path $sourceLibraryRoot
New-DirectoryIfMissing -Path $CloneRoot
New-DirectoryIfMissing -Path $harvestRoot

$manifest = Get-Content -LiteralPath $ManifestPath -Raw | ConvertFrom-Json

if ($MaxItems -gt 0) {
    $manifest = $manifest | Select-Object -First $MaxItems
}

$summary = @()

foreach ($entry in $manifest) {
    $bucketPath = Join-Path $sourceLibraryRoot $entry.bucket
    $entryPath = Join-Path $bucketPath "$($entry.slug).md"
    $metadataDir = Join-Path $harvestRoot $entry.slug
    $metadataPath = Join-Path $metadataDir "metadata.json"
    $clonePath = Join-Path $CloneRoot $entry.slug

    New-DirectoryIfMissing -Path $bucketPath
    New-DirectoryIfMissing -Path $metadataDir

    $docsMeta = Invoke-SafeRequest -Url $entry.docs_url
    $repoMeta = Invoke-SafeRequest -Url $entry.repo_url

    $cloneExists = Test-Path -LiteralPath $clonePath
    $cloneStatus = if ($cloneExists) { "exists" } else { "skipped" }

    if ($CloneRepos) {
        if ($cloneExists) {
            $cloneStatus = "exists"
        }
        else {
            try {
                git clone --depth 1 --filter=blob:none $entry.repo_url $clonePath | Out-Null
                $cloneStatus = "cloned"
                $cloneExists = $true
            }
            catch {
                $cloneStatus = "clone_failed: $($_.Exception.Message)"
            }
        }
    }

    $metadata = [ordered]@{
        name = $entry.name
        slug = $entry.slug
        generated_at = (Get-Date).ToString("o")
        bucket = $entry.bucket
        docs = $docsMeta
        repo = $repoMeta
        clone_status = $cloneStatus
        manifest_entry = $entry
    }

    $metadata | ConvertTo-Json -Depth 10 | Set-Content -LiteralPath $metadataPath -Encoding UTF8

    if ($OverwriteMarkdown -or -not (Test-Path -LiteralPath $entryPath)) {
        $resolvedClonePath = if ($cloneExists) { $clonePath } else { $null }
        $markdown = Build-Markdown -Entry $entry -DocsMeta $docsMeta -RepoMeta $repoMeta -MetadataPath $metadataPath -ClonePath $resolvedClonePath
        Set-Content -LiteralPath $entryPath -Value $markdown -Encoding UTF8
    }

    $summary += [ordered]@{
        name = $entry.name
        slug = $entry.slug
        bucket = $entry.bucket
        docs_ok = $docsMeta.ok
        repo_ok = $repoMeta.ok
        clone_status = $cloneStatus
        entry_path = $entryPath
        metadata_path = $metadataPath
    }
}

$summaryPath = Join-Path $harvestRoot "summary.json"
$summary | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath $summaryPath -Encoding UTF8

Write-Host ""
Write-Host "Source library ingestion complete."
Write-Host "Manifest: $ManifestPath"
Write-Host "Summary:  $summaryPath"
Write-Host ""

[CmdletBinding()]
param(
    [switch]$AsJson
)

$ErrorActionPreference = "Stop"
$machinePath = [System.Environment]::GetEnvironmentVariable("Path", "Machine")
$userPath = [System.Environment]::GetEnvironmentVariable("Path", "User")
$env:Path = "$machinePath;$userPath"

$results = New-Object System.Collections.Generic.List[object]

function Invoke-FirstLine {
    param(
        [Parameter(Mandatory = $true)]
        [scriptblock]$ScriptBlock
    )

    try {
        $output = & $ScriptBlock 2>$null
        if ($null -eq $output) {
            return ""
        }

        $first = if ($output -is [System.Array]) {
            $output |
                ForEach-Object { [string]$_ } |
                Where-Object { $_.Trim() } |
                Select-Object -First 1
        } else {
            [string]$output
        }

        return (($first -replace "`0", "").Trim())
    } catch {
        return ""
    }
}

function Add-Result {
    param(
        [string]$Category,
        [string]$Item,
        [bool]$Installed,
        [bool]$Optional = $false,
        [string]$Scope = "",
        [string]$Version = "",
        [string]$Details = ""
    )

    $status = if ($Installed) {
        "OK"
    } elseif ($Optional) {
        "OPTIONAL-MISSING"
    } else {
        "MISSING"
    }

    $results.Add([pscustomobject]@{
        Category = $Category
        Item     = $Item
        Status   = $status
        Scope    = $Scope
        Version  = $Version
        Details  = $Details
    })
}

function Add-CommandCheck {
    param(
        [string]$Category,
        [string]$Item,
        [string]$Command,
        [scriptblock]$VersionBlock,
        [bool]$Optional = $false,
        [string]$Scope = "Windows"
    )

    $cmd = Get-Command $Command -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($cmd) {
        $version = if ($VersionBlock) { Invoke-FirstLine $VersionBlock } else { "" }
        Add-Result -Category $Category -Item $Item -Installed $true -Optional $Optional -Scope $Scope -Version $version -Details $cmd.Source
    } else {
        Add-Result -Category $Category -Item $Item -Installed $false -Optional $Optional -Scope $Scope -Details "Command not found"
    }
}

function Add-NpmPackageCheck {
    param(
        [string]$Category,
        [string]$Item,
        [string]$Package,
        [bool]$Optional = $false
    )

    if ($script:NpmPackages.ContainsKey($Package)) {
        Add-Result -Category $Category -Item $Item -Installed $true -Optional $Optional -Scope "npm -g" -Version $script:NpmPackages[$Package] -Details "Global npm package"
    } else {
        Add-Result -Category $Category -Item $Item -Installed $false -Optional $Optional -Scope "npm -g" -Details "Global npm package missing"
    }
}

function Add-AppCheck {
    param(
        [string]$Category,
        [string]$Item,
        [string]$Pattern,
        [bool]$Optional = $false
    )

    $match = $script:InstalledApps |
        Where-Object { $_.DisplayName -match $Pattern } |
        Select-Object -First 1

    if ($match) {
        $detail = $match.DisplayName
        if ($match.InstallLocation) {
            $detail = "$detail | $($match.InstallLocation)"
        }

        Add-Result -Category $Category -Item $Item -Installed $true -Optional $Optional -Scope "Windows app" -Version $match.DisplayVersion -Details $detail
    } else {
        Add-Result -Category $Category -Item $Item -Installed $false -Optional $Optional -Scope "Windows app" -Details "App not found in uninstall registry"
    }
}

function Invoke-WslFirstLine {
    param(
        [string]$CommandText
    )

    if (-not $script:UbuntuDistro) {
        return ""
    }

    try {
        $output = wsl -d $script:UbuntuDistro -- bash -lc $CommandText 2>$null
        if ($null -eq $output) {
            return ""
        }

        $first = if ($output -is [System.Array]) {
            $output |
                ForEach-Object { [string]$_ } |
                Where-Object { $_.Trim() } |
                Select-Object -First 1
        } else {
            [string]$output
        }

        return (($first -replace "`0", "").Trim())
    } catch {
        return ""
    }
}

function Add-WslCheck {
    param(
        [string]$Category,
        [string]$Item,
        [string]$ProbeCommand,
        [string]$VersionCommand,
        [bool]$Optional = $false
    )

    if (-not $script:UbuntuDistro) {
        Add-Result -Category $Category -Item $Item -Installed $false -Optional $Optional -Scope "WSL" -Details "Ubuntu WSL distro not found"
        return
    }

    $probe = Invoke-WslFirstLine $ProbeCommand
    if ($probe) {
        $version = if ($VersionCommand) { Invoke-WslFirstLine $VersionCommand } else { "" }
        Add-Result -Category $Category -Item $Item -Installed $true -Optional $Optional -Scope "WSL:$($script:UbuntuDistro)" -Version $version -Details $probe
    } else {
        Add-Result -Category $Category -Item $Item -Installed $false -Optional $Optional -Scope "WSL:$($script:UbuntuDistro)" -Details "Command not found"
    }
}

$wslDistros = @()
try {
    $wslDistros = wsl -l -q 2>$null |
        ForEach-Object { ($_ -replace "`0", "").Trim() } |
        Where-Object { $_ }
} catch {
    $wslDistros = @()
}

$script:UbuntuDistro = $wslDistros |
    Where-Object { $_ -like "Ubuntu*" } |
    Sort-Object -Descending |
    Select-Object -First 1

$script:NpmPackages = @{}
try {
    $npmRaw = npm list -g --depth=0 --json 2>$null | Out-String
    $npmData = $npmRaw | ConvertFrom-Json
    if ($npmData.dependencies) {
        foreach ($property in $npmData.dependencies.PSObject.Properties) {
            $script:NpmPackages[$property.Name] = $property.Value.version
        }
    }
} catch {
    $script:NpmPackages = @{}
}

$uninstallPaths = @(
    "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*",
    "HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*",
    "HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*"
)

$script:InstalledApps = @(
    foreach ($path in $uninstallPaths) {
        Get-ItemProperty $path -ErrorAction SilentlyContinue
    }
) | Where-Object { $_.DisplayName }

$categoryOrder = @(
    "Core Dev Tools",
    "Version Control Tools",
    "JavaScript / Frontend Runtime Tools",
    "Python / AI / Automation Tools",
    "Native Build / Windows Compatibility Tools",
    "Containers / Local Services",
    "Fast Terminal Utilities",
    "Frontend App Tools",
    "Backend App Tools",
    "Database Tools",
    "API Testing / Debugging Tools",
    "Testing / QA Tools",
    "Quality / Lint / Format Tools"
)

Add-CommandCheck -Category "Core Dev Tools" -Item "Codex CLI" -Command "codex" -VersionBlock { codex --version }
Add-CommandCheck -Category "Core Dev Tools" -Item "VS Code" -Command "code" -VersionBlock { code --version | Select-Object -First 1 }
Add-CommandCheck -Category "Core Dev Tools" -Item "PowerShell" -Command "pwsh" -VersionBlock { pwsh --version }
Add-Result -Category "Core Dev Tools" -Item "WSL2" -Installed ([bool](Get-Command wsl -ErrorAction SilentlyContinue)) -Scope "Windows" -Version (Invoke-FirstLine { wsl --version | Select-Object -First 1 }) -Details $(if ($wslDistros) { $wslDistros -join ", " } else { "No distros found" })
Add-Result -Category "Core Dev Tools" -Item "Ubuntu" -Installed ([bool]$UbuntuDistro) -Scope "WSL" -Version $UbuntuDistro -Details $(if ($UbuntuDistro) { "Installed WSL distro" } else { "Ubuntu distro not found" })

Add-CommandCheck -Category "Version Control Tools" -Item "Git" -Command "git" -VersionBlock { git --version }
Add-CommandCheck -Category "Version Control Tools" -Item "GitHub CLI (gh)" -Command "gh" -VersionBlock { gh --version | Select-Object -First 1 }
Add-CommandCheck -Category "Version Control Tools" -Item "GitLab CLI (glab)" -Command "glab" -VersionBlock { glab --version | Select-Object -First 1 } -Optional $true

Add-CommandCheck -Category "JavaScript / Frontend Runtime Tools" -Item "Node.js" -Command "node" -VersionBlock { node --version }
Add-CommandCheck -Category "JavaScript / Frontend Runtime Tools" -Item "npm" -Command "npm" -VersionBlock { npm --version }
Add-CommandCheck -Category "JavaScript / Frontend Runtime Tools" -Item "npx" -Command "npx" -VersionBlock { npx --version }
Add-CommandCheck -Category "JavaScript / Frontend Runtime Tools" -Item "pnpm" -Command "pnpm" -VersionBlock { pnpm --version }
Add-CommandCheck -Category "JavaScript / Frontend Runtime Tools" -Item "yarn" -Command "yarn" -VersionBlock { yarn --version }
Add-CommandCheck -Category "JavaScript / Frontend Runtime Tools" -Item "Bun" -Command "bun" -VersionBlock { bun --version }

Add-CommandCheck -Category "Python / AI / Automation Tools" -Item "Python" -Command "python" -VersionBlock { python --version }
Add-CommandCheck -Category "Python / AI / Automation Tools" -Item "Python Launcher (py)" -Command "py" -VersionBlock { py --version }
Add-CommandCheck -Category "Python / AI / Automation Tools" -Item "pip" -Command "pip" -VersionBlock { pip --version }
Add-Result -Category "Python / AI / Automation Tools" -Item "venv" -Installed ([bool](Invoke-FirstLine { python -m venv --help; "ok" })) -Scope "Windows" -Version (Invoke-FirstLine { python --version }) -Details "python -m venv"
Add-CommandCheck -Category "Python / AI / Automation Tools" -Item "uv" -Command "uv" -VersionBlock { uv --version }
Add-CommandCheck -Category "Python / AI / Automation Tools" -Item "pipx" -Command "pipx" -VersionBlock { pipx --version } -Optional $true
Add-CommandCheck -Category "Python / AI / Automation Tools" -Item "Jupyter" -Command "jupyter-lab" -VersionBlock { jupyter-lab --version } -Optional $true

$vswhere = "C:\Program Files (x86)\Microsoft Visual Studio\Installer\vswhere.exe"
$buildToolsName = ""
$buildToolsVersion = ""
$buildToolsPath = ""
if (Test-Path $vswhere) {
    $buildToolsName = Invoke-FirstLine { & $vswhere -latest -products * -property displayName }
    $buildToolsVersion = Invoke-FirstLine { & $vswhere -latest -products * -property installationVersion }
    $buildToolsPath = Invoke-FirstLine { & $vswhere -latest -products * -property installationPath }
}
Add-CommandCheck -Category "Native Build / Windows Compatibility Tools" -Item "CMake" -Command "cmake" -VersionBlock { cmake --version | Select-Object -First 1 }
Add-Result -Category "Native Build / Windows Compatibility Tools" -Item "Visual Studio Build Tools" -Installed ([bool]$buildToolsName) -Scope "Windows" -Version $buildToolsVersion -Details $(if ($buildToolsPath) { $buildToolsPath } else { "Build Tools not found" })
$clPath = Get-ChildItem "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Tools\MSVC" -Recurse -Filter "cl.exe" -ErrorAction SilentlyContinue |
    Select-Object -First 1 -ExpandProperty FullName
Add-Result -Category "Native Build / Windows Compatibility Tools" -Item "MSVC / cl.exe" -Installed ([bool]$clPath) -Scope "Windows" -Details $(if ($clPath) { $clPath } else { "cl.exe not found" })
$sdkPath = Get-ChildItem "C:\Program Files (x86)\Windows Kits\10\Include" -ErrorAction SilentlyContinue |
    Sort-Object Name -Descending |
    Select-Object -First 1 -ExpandProperty FullName
Add-Result -Category "Native Build / Windows Compatibility Tools" -Item "Windows SDK" -Installed ([bool]$sdkPath) -Scope "Windows" -Details $(if ($sdkPath) { $sdkPath } else { "Windows SDK not found" })
Add-CommandCheck -Category "Native Build / Windows Compatibility Tools" -Item "make" -Command "make" -VersionBlock { make --version | Select-Object -First 1 }
$windowsGcc = Get-Command gcc -ErrorAction SilentlyContinue | Select-Object -First 1
$windowsGpp = Get-Command g++ -ErrorAction SilentlyContinue | Select-Object -First 1
if ($windowsGcc -and $windowsGpp) {
    Add-Result -Category "Native Build / Windows Compatibility Tools" -Item "gcc / g++" -Installed $true -Optional $true -Scope "Windows" -Version (Invoke-FirstLine { gcc --version | Select-Object -First 1 }) -Details $windowsGcc.Source
} else {
    $wslGcc = Invoke-WslFirstLine "command -v gcc"
    $wslGpp = Invoke-WslFirstLine "command -v g++"
    Add-Result -Category "Native Build / Windows Compatibility Tools" -Item "gcc / g++" -Installed ([bool]($wslGcc -and $wslGpp)) -Optional $true -Scope "WSL:$UbuntuDistro" -Version (Invoke-WslFirstLine "gcc --version | head -n 1") -Details $(if ($wslGcc -and $wslGpp) { "$wslGcc | $wslGpp" } else { "gcc/g++ not found" })
}

Add-CommandCheck -Category "Containers / Local Services" -Item "Docker" -Command "docker" -VersionBlock { docker --version }
Add-CommandCheck -Category "Containers / Local Services" -Item "Docker Compose" -Command "docker-compose" -VersionBlock { docker-compose version --short }
$dockerDesktopDistros = $wslDistros | Where-Object { $_ -like "docker-desktop*" }
Add-Result -Category "Containers / Local Services" -Item "Docker WSL integration" -Installed ([bool]$dockerDesktopDistros) -Scope "WSL" -Details $(if ($dockerDesktopDistros) { $dockerDesktopDistros -join ", " } else { "docker-desktop distro not found" })

Add-CommandCheck -Category "Fast Terminal Utilities" -Item "ripgrep (rg)" -Command "rg" -VersionBlock { rg --version | Select-Object -First 1 }
Add-CommandCheck -Category "Fast Terminal Utilities" -Item "fd" -Command "fd" -VersionBlock { fd --version } -Optional $true
Add-CommandCheck -Category "Fast Terminal Utilities" -Item "fzf" -Command "fzf" -VersionBlock { fzf --version } -Optional $true
Add-CommandCheck -Category "Fast Terminal Utilities" -Item "jq" -Command "jq" -VersionBlock { jq --version } -Optional $true
Add-CommandCheck -Category "Fast Terminal Utilities" -Item "bat" -Command "bat" -VersionBlock { bat --version | Select-Object -First 1 } -Optional $true
Add-CommandCheck -Category "Fast Terminal Utilities" -Item "curl" -Command "curl" -VersionBlock { curl --version | Select-Object -First 1 }
Add-CommandCheck -Category "Fast Terminal Utilities" -Item "wget" -Command "wget" -VersionBlock { wget --version | Select-Object -First 1 } -Optional $true

Add-NpmPackageCheck -Category "Frontend App Tools" -Item "React" -Package "react"
Add-NpmPackageCheck -Category "Frontend App Tools" -Item "Next.js" -Package "next"
Add-NpmPackageCheck -Category "Frontend App Tools" -Item "Vite" -Package "vite"
Add-NpmPackageCheck -Category "Frontend App Tools" -Item "TypeScript" -Package "typescript"
Add-NpmPackageCheck -Category "Frontend App Tools" -Item "Tailwind CSS" -Package "tailwindcss"
Add-NpmPackageCheck -Category "Frontend App Tools" -Item "ESLint" -Package "eslint"
Add-NpmPackageCheck -Category "Frontend App Tools" -Item "Prettier" -Package "prettier"

Add-NpmPackageCheck -Category "Backend App Tools" -Item "Express" -Package "express"
Add-NpmPackageCheck -Category "Backend App Tools" -Item "Fastify" -Package "fastify"
Add-NpmPackageCheck -Category "Backend App Tools" -Item "NestJS" -Package "@nestjs/cli"
Add-CommandCheck -Category "Backend App Tools" -Item "Flask" -Command "flask" -VersionBlock { flask --version | Select-Object -First 1 }
Add-CommandCheck -Category "Backend App Tools" -Item "FastAPI" -Command "fastapi" -VersionBlock { fastapi --version }
Add-CommandCheck -Category "Backend App Tools" -Item "Django" -Command "django-admin" -VersionBlock { django-admin --version }

Add-WslCheck -Category "Database Tools" -Item "PostgreSQL" -ProbeCommand "command -v psql" -VersionCommand "psql --version"
Add-WslCheck -Category "Database Tools" -Item "MySQL" -ProbeCommand "command -v mysql" -VersionCommand "mysql --version"
Add-CommandCheck -Category "Database Tools" -Item "SQLite" -Command "sqlite3" -VersionBlock { sqlite3 --version }
Add-WslCheck -Category "Database Tools" -Item "Redis" -ProbeCommand "command -v redis-server" -VersionCommand "redis-server --version"
Add-CommandCheck -Category "Database Tools" -Item "Prisma" -Command "prisma" -VersionBlock { prisma --version | Select-Object -First 1 }
Add-NpmPackageCheck -Category "Database Tools" -Item "Drizzle" -Package "drizzle-orm"
Add-AppCheck -Category "Database Tools" -Item "DBeaver" -Pattern "^DBeaver" -Optional $true
Add-AppCheck -Category "Database Tools" -Item "TablePlus" -Pattern "^TablePlus" -Optional $true

Add-AppCheck -Category "API Testing / Debugging Tools" -Item "Postman" -Pattern "^Postman"
Add-AppCheck -Category "API Testing / Debugging Tools" -Item "Insomnia" -Pattern "^Insomnia"
Add-AppCheck -Category "API Testing / Debugging Tools" -Item "Bruno" -Pattern "^Bruno"
Add-CommandCheck -Category "API Testing / Debugging Tools" -Item "curl" -Command "curl" -VersionBlock { curl --version | Select-Object -First 1 }
Add-CommandCheck -Category "API Testing / Debugging Tools" -Item "jq" -Command "jq" -VersionBlock { jq --version }

Add-CommandCheck -Category "Testing / QA Tools" -Item "Playwright" -Command "playwright" -VersionBlock { playwright --version }
Add-CommandCheck -Category "Testing / QA Tools" -Item "Cypress" -Command "cypress" -VersionBlock { cypress --version | Select-Object -First 1 }
Add-CommandCheck -Category "Testing / QA Tools" -Item "Vitest" -Command "vitest" -VersionBlock { vitest --version }
Add-CommandCheck -Category "Testing / QA Tools" -Item "Jest" -Command "jest" -VersionBlock { jest --version }
Add-CommandCheck -Category "Testing / QA Tools" -Item "Pytest" -Command "pytest" -VersionBlock { pytest --version }

Add-CommandCheck -Category "Quality / Lint / Format Tools" -Item "ESLint" -Command "eslint" -VersionBlock { eslint --version }
Add-CommandCheck -Category "Quality / Lint / Format Tools" -Item "Prettier" -Command "prettier" -VersionBlock { prettier --version }
Add-CommandCheck -Category "Quality / Lint / Format Tools" -Item "TypeScript compiler (tsc)" -Command "tsc" -VersionBlock { tsc --version }
Add-CommandCheck -Category "Quality / Lint / Format Tools" -Item "Ruff" -Command "ruff" -VersionBlock { ruff --version }
Add-CommandCheck -Category "Quality / Lint / Format Tools" -Item "Black" -Command "black" -VersionBlock { black --version }
Add-CommandCheck -Category "Quality / Lint / Format Tools" -Item "isort" -Command "isort" -VersionBlock { isort --version | Select-Object -First 1 }
Add-CommandCheck -Category "Quality / Lint / Format Tools" -Item "mypy" -Command "mypy" -VersionBlock { mypy --version }

if ($AsJson) {
    $results | ConvertTo-Json -Depth 4
    exit 0
}

$requiredInstalled = ($results | Where-Object { $_.Status -eq "OK" }).Count
$requiredMissing = ($results | Where-Object { $_.Status -eq "MISSING" }).Count
$optionalMissing = ($results | Where-Object { $_.Status -eq "OPTIONAL-MISSING" }).Count

Write-Host ""
Write-Host "Dev Stack Audit"
Write-Host "Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss zzz')"
Write-Host "Ubuntu WSL distro: $(if ($UbuntuDistro) { $UbuntuDistro } else { 'not found' })"
Write-Host ""
Write-Host "Summary"
Write-Host "OK: $requiredInstalled"
Write-Host "Missing: $requiredMissing"
Write-Host "Optional missing: $optionalMissing"

foreach ($category in $categoryOrder) {
    $group = $results | Where-Object { $_.Category -eq $category }
    if (-not $group) {
        continue
    }

    Write-Host ""
    Write-Host $category
    $group |
        Select-Object Item, Status, Scope, Version, Details |
        Format-Table -Wrap -AutoSize
}

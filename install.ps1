$ErrorActionPreference = "Stop"

$PackageDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$SourceDir = Join-Path $PackageDir "lanlan"
$CodexRoot = if ($env:CODEX_HOME) { $env:CODEX_HOME } else { Join-Path $env:USERPROFILE ".codex" }
$PetsDir = Join-Path $CodexRoot "pets"
$TargetDir = Join-Path $PetsDir "lanlan"
$Timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$BackupDir = $null

function Assert-Sha256 {
    param(
        [string]$Path,
        [string]$Expected
    )

    $Actual = (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash.ToLowerInvariant()
    if ($Actual -ne $Expected) {
        throw "校验失败：$Path"
    }
}

$PetJson = Join-Path $SourceDir "pet.json"
$Spritesheet = Join-Path $SourceDir "spritesheet.png"

if (-not (Test-Path -LiteralPath $PetJson -PathType Leaf) -or -not (Test-Path -LiteralPath $Spritesheet -PathType Leaf)) {
    throw "安装包不完整：找不到 lanlan/pet.json 或 lanlan/spritesheet.png。"
}

Assert-Sha256 -Path $PetJson -Expected "cd04aa9d97274fbbcb82294c5a5860f46453899d21a5046806d208eef657c0ba"
Assert-Sha256 -Path $Spritesheet -Expected "a7f35a2f888b943fe175d142ec4435f7959e2f5d9a93942fc272ff606175417c"

New-Item -ItemType Directory -Path $PetsDir -Force | Out-Null

if (Test-Path -LiteralPath $TargetDir) {
    $BackupDir = "$TargetDir.backup-$Timestamp"
    Move-Item -LiteralPath $TargetDir -Destination $BackupDir
}

try {
    New-Item -ItemType Directory -Path $TargetDir | Out-Null
    Copy-Item -LiteralPath $PetJson -Destination (Join-Path $TargetDir "pet.json")
    Copy-Item -LiteralPath $Spritesheet -Destination (Join-Path $TargetDir "spritesheet.png")
}
catch {
    if (Test-Path -LiteralPath $TargetDir) {
        Move-Item -LiteralPath $TargetDir -Destination "$TargetDir.failed-$Timestamp"
    }
    if ($BackupDir -and (Test-Path -LiteralPath $BackupDir)) {
        Move-Item -LiteralPath $BackupDir -Destination $TargetDir
    }
    throw
}

Write-Host "lanlan 已安装到：$TargetDir"
if ($BackupDir) {
    Write-Host "旧版本备份在：$BackupDir"
}
Write-Host "请在桌面应用的 Settings > Pets 中选择 Refresh，然后选择‘懒懒’。"

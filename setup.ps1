# Assemble Reliability Copilot from the public pre-event baseline + this event patch.
# Usage: .\setup.ps1 [-Force] [-Target app]
param(
    [switch]$Force,
    [string]$Target = "app"
)
$ErrorActionPreference = "Stop"

$Upstream = "https://github.com/prasannaba/reliability-ai-agent.git"
$Pin = "688b1c7e1c04d1cd50886a81278a5a5d174e3203"
$Root = Split-Path -Parent $MyInvocation.MyCommand.Path
$Patch = Join-Path $Root "patches\reliability-copilot-event.patch"
$TargetPath = Join-Path $Root $Target

if (-not (Get-Command git -ErrorAction SilentlyContinue)) { throw "git not found. Install Git first." }
if (-not (Test-Path $Patch)) { throw "Patch not found at $Patch" }

if (Test-Path $TargetPath) {
    if (-not $Force) {
        throw "Target '$TargetPath' already exists. Delete it or re-run with -Force."
    }
    Write-Host "Removing existing $TargetPath ..."
    Remove-Item $TargetPath -Recurse -Force
}

Write-Host "Cloning pre-event baseline $Upstream ..."
git clone $Upstream $TargetPath
if ($LASTEXITCODE -ne 0) { throw "git clone failed." }

Write-Host "Checking out pinned baseline $Pin ..."
git -C $TargetPath checkout --detach $Pin
if ($LASTEXITCODE -ne 0) { throw "git checkout of pinned baseline failed." }

$Actual = (git -C $TargetPath rev-parse HEAD).Trim()
if ($Actual -ne $Pin) { throw "Baseline mismatch: expected $Pin, got $Actual" }

Write-Host "Applying event patch ..."
git -C $TargetPath apply --check --binary --whitespace=nowarn $Patch
if ($LASTEXITCODE -ne 0) { throw "Event patch does not apply cleanly to the pinned baseline." }
git -C $TargetPath apply --binary --whitespace=nowarn $Patch
if ($LASTEXITCODE -ne 0) { throw "Applying event patch failed." }

Write-Host ""
Write-Host "Assembled app at: $TargetPath"
Write-Host "Next steps:"
Write-Host "  cd $Target"
Write-Host "  copy .env.example .env   # set LLM_API_BASE + LLM_API_KEY, never commit .env"
Write-Host "  docker compose up --build -d"
Write-Host "  curl http://localhost:8000/health"

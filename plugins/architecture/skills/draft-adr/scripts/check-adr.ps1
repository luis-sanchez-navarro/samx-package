# Usage: powershell -File scripts/check-adr.ps1 <path-to-adr-file>
param([Parameter(Mandatory)][string]$File)

if (-not (Test-Path -LiteralPath $File -PathType Leaf)) {
    Write-Output "ERROR: File not found: $File"
    exit 1
}

$errors = 0
$content = [string](Get-Content -LiteralPath $File -Raw)

$requiredSections = @("Status", "Context", "Decision", "Consequences")
foreach ($section in $requiredSections) {
    if ($content -notmatch "(?im)^## $section") {
        Write-Output "ERROR: Missing section '## $section'"
        $errors++
    }
}

if ($content -notmatch "(?im)^(Proposed|Accepted|Deprecated|Superseded)") {
    Write-Output "ERROR: Status must be one of Proposed, Accepted, Deprecated, Superseded"
    $errors++
}

$wordCount = ($content -split '\s+' | Where-Object { $_ -ne "" }).Count
if ($wordCount -lt 100) {
    Write-Output "ERROR: ADR appears too short ($wordCount words). Minimum is 100."
    $errors++
}

if ($errors -eq 0) {
    Write-Output "OK"
    exit 0
}
exit 1

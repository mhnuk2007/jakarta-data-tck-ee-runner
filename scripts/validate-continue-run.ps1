$ErrorActionPreference = 'Stop'

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$reportDir = Join-Path $repoRoot 'target\surefire-reports'
New-Item -ItemType Directory -Path $reportDir -Force | Out-Null

$passReport = Join-Path $reportDir 'TEST-ee.jakarta.tck.data.web.async.AsyncTests.xml'
$failReport = Join-Path $reportDir 'TEST-ee.jakarta.tck.data.web.persistence.PersistenceTests.xml'

@'
<testsuite name="ee.jakarta.tck.data.web.async.AsyncTests" tests="1" failures="0" errors="0" skipped="0"></testsuite>
'@ | Set-Content -Path $passReport

@'
<testsuite name="ee.jakarta.tck.data.web.persistence.PersistenceTests" tests="1" failures="1" errors="0" skipped="0"></testsuite>
'@ | Set-Content -Path $failReport

$output = & (Join-Path $PSScriptRoot 'continue-run.ps1') -Test 'ee.jakarta.tck.data.web.async.AsyncTests,ee.jakarta.tck.data.web.persistence.PersistenceTests' -DryRun 2>&1

if ($LASTEXITCODE -ne 0) {
    Write-Error "continue-run.ps1 exited with code $LASTEXITCODE"
    $output | Out-String | Write-Error
    exit $LASTEXITCODE
}

$outputText = ($output | Out-String).Trim()
if ($outputText -notmatch 'Running remaining tests: ee\.jakarta\.tck\.data\.web\.persistence\.PersistenceTests') {
    Write-Error "Expected the helper to select the remaining failed test, but output was: $outputText"
    exit 1
}

Write-Output 'continue-run helper validation passed.'

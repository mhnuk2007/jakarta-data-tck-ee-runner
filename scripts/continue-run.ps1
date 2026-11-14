param(
    [Parameter(Mandatory = $true)]
    [string]$Test,
    [string]$LibertyInstallDirectory,
    [switch]$DryRun,
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$ExtraArgs
)

# Helper: resume a previous TCK run by re-running only the tests that have not previously passed.
# - Test: comma-separated list of test classes (for example: ee.jakarta.tck.data.web.async.AsyncTests)
# - LibertyInstallDirectory: optional, passed through to Maven as -Dliberty.installDirectory
# - ExtraArgs: additional mvn CLI args, for example: -Dsome.prop=value

$reportDir = Join-Path -Path $PSScriptRoot -ChildPath "..\target\surefire-reports"
if (Test-Path $reportDir) {
    $reportDir = (Resolve-Path $reportDir).ProviderPath
}
else {
    $reportDir = $null
}

$passed = @()
if ($reportDir -and (Test-Path $reportDir)) {
    Get-ChildItem -Path $reportDir -Filter "TEST-*.xml" -File -ErrorAction SilentlyContinue | ForEach-Object {
        try {
            $xml = [xml](Get-Content -Path $_.FullName -Raw)
            $suite = $xml.testsuite
            if ($suite -and $suite.name) {
                $failures = 0
                $errors = 0
                if ($suite.failures) { $failures = [int]$suite.failures }
                if ($suite.errors) { $errors = [int]$suite.errors }

                if ($failures -eq 0 -and $errors -eq 0) {
                    $passed += $suite.name
                }
            }
        }
        catch {
            # Ignore malformed report files and continue scanning.
        }
    }
    $passed = $passed | Sort-Object -Unique
}

$requested = $Test -split ',' | ForEach-Object { $_.Trim() } | Where-Object { $_ }
if ($requested.Count -eq 0) {
    Write-Error "No tests specified. Use -Test with a comma-separated list of test classes or patterns."
    exit 1
}

$remaining = @($requested | Where-Object { $_ -notin $passed })
if ($remaining.Count -eq 0) {
    Write-Output "No remaining tests to run. All requested tests appear to have passed previously: $($passed -join ', ')"
    exit 0
}

$testArg = $remaining -join ','

$mvnArgs = @('clean', 'verify', "-Dtest=$testArg")
if ($LibertyInstallDirectory) {
    $mvnArgs += "-Dliberty.installDirectory=$LibertyInstallDirectory"
}
if ($ExtraArgs) {
    $mvnArgs += $ExtraArgs
}

Write-Output "Resuming run. Previously passed tests: $($passed -join ', ')"
Write-Output "Running remaining tests: $testArg"
Write-Output "mvn $($mvnArgs -join ' ')"

if ($DryRun) {
    exit 0
}

&mvn @mvnArgs
exit $LASTEXITCODE

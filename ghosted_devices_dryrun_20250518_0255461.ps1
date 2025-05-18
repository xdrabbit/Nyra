# Ghosted Device Scanner - DRY RUN ONLY
# Safe and Verifiable - 20250518_025546
# No device removal occurs

$classes = @("HIDClass", "USB", "Bluetooth", "Ports", "Media", "System", "AudioEndpoint")
$ghostedDevices = @()
$report = @()

Write-Host "`n🔍 Scanning for ghosted devices (Status ≠ OK)..."

foreach ($class in $classes) {
    $devices = Get-PnpDevice -Class $class | Where-Object { $_.Status -ne "OK" }
    if ($devices.Count -gt 0) {
        foreach ($dev in $devices) {
            $report += [PSCustomObject]@{
                Class = $class
                FriendlyName = $dev.FriendlyName
                InstanceId = $dev.InstanceId
                Status = $dev.Status
            }
        }
    }
}

if ($report.Count -eq 0) {
    Write-Host "`n✅ No ghosted devices found."
} else {
    $csvPath = Join-Path -Path $env:USERPROFILE -ChildPath "Desktop\ghosted_devices_dryrun_20250518_025546.csv"
    $report | Export-Csv -Path $csvPath -NoTypeInformation
    Write-Host "`n📄 Ghosted devices detected: $($report.Count)"
    Write-Host "📝 Report saved to: $csvPath"
}

# Removed the extra closing brace from here

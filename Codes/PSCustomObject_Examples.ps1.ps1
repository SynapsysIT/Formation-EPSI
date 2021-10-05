
$OSInfo = (Get-CimInstance win32_operatingSystem)
$ComputerInfo = Get-CimInstance win32_computerSystem
$DiskInfo = Get-CimInstance win32_logicalDisk | Where-Object { $_.name -eq $OsInfo.SystemDrive }

[PSCustomObject]@{
    ComputerName         = $computer
    OSVersion            = $OsInfo.Version
    BuildOS              = $OsInfo.Caption
    Model                = $ComputerInfo.Model
    NumOfProcessors      = $ComputerInfo.NumberOfProcessors
    RamMemory            = $ComputerInfo.TotalPhysicalMemory
    SystemDrive          = $OsInfo.SystemDrive
    SystemDriveFreeSpace = $DiskInfo.freespace/1GB -as [int]
    Status               = "OK"
}
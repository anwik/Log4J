$Computer = $ENV:ComputerName
$DT = Get-Date -Format 'G'
$Disks = Get-WmiObject –Query "SELECT * from win32_logicaldisk where DriveType = '3'" | Select-Object DeviceID

param([string]$PathToExe = "")

try {
	if ($PathToExe -eq "" ) { $PathToExe = read-host "Enter path to directory tree" }

	Get-ChildItem -path $PathToExe -recurse | Select-Object FullName
	exit 0 # success
} catch {
	"⚠️ Error: $($Error[0]) ($($MyInvocation.MyCommand.Name):$($_.InvocationInfo.ScriptLineNumber))"
	exit 1
}


foreach ($disk in $disks) {

    $log = \\liv.se\system\PkgSource\Log4Java-Scanner\1.6.1\log4j2-scan.exe "$($disk.DeviceID)\" | findstr '[*] Found Completed'

    [PSCustomObject]@{

        Time   = $dt

        Hostname = $env:computername

        Disk   = $disk.DeviceID

        Result = "$log"

    } | Export-Csv -Path \\liv.se\system\PkgSource\Log4Java-Scanner\Results\log4j.csv -NoClobber -Encoding UTF8 -Append -Delimiter ';' -NoTypeInformation


 

    Write-Host "$computer $($disk.DeviceID) was scanned"


 

}
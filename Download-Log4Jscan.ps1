<#
.SYNOPSIS
	Download the latest Log4J2-scan release from https://github.com/logpresso/CVE-2021-44228-Scanner
.DESCRIPTION
	This script download the latest release of Log4j2-scan from GitHub and extract the exe-file to a subfolder named after the release number.
         
.PARAMETER FolderPath
	Specifies the folder path to the shared folder where you want to put log4j2-scan.exe 
.EXAMPLE
	PS> .\Download-Latest-Release.ps1 \\server\share\Log4J
.NOTES
	Author: Andreas Wikström
.LINK
	https://github.com/anwik/Log4J
#>

param([string]$FolderName = '')

try {
    if ($FolderName -eq '' ) { $FolderName = Read-Host 'Enter path to shared folder' }

    $URL = 'https://github.com/logpresso/CVE-2021-44228-Scanner/releases/latest'
    $Request = [System.Net.WebRequest]::Create($url)
    $Response = $Request.GetResponse()
    $realTagUrl = $Response.ResponseUri.OriginalString
    $Version = $realTagUrl.split('/')[-1].Trim('v')
    $FileName = "logpresso-log4j2-scan-$Version-win64.zip"
    $realDownloadUrl = $realTagUrl.Replace('tag', 'download') + '/' + $FileName
    
    Write-Host Downloading latest
    Invoke-WebRequest -Uri $realDownloadUrl -OutFile "$env:TEMP\$FileName"


    Write-Host Unblocking zip file
    Unblock-File "$env:TEMP\$FileName"

    Write-Host Creating folder for version
    New-Item -Path $FolderName\$Version -ItemType Directory

    Write-Host Extracting release files
    Expand-Archive -Path "$env:TEMP\$FileName" -DestinationPath $FolderName\$Version -Force
    exit 0 # success
} catch {
    "⚠️ Error: $($Error[0]) ($($MyInvocation.MyCommand.Name):$($_.InvocationInfo.ScriptLineNumber))"
    exit 1
}
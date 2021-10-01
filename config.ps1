# ---------------------------------------
# Config auditbeat, start logging & output
# Author: Li Jiawei
# Windows 10 x64 education Passed
# ---------------------------------------

# output folder name
$folder = "output"
# your auditbeat install path
$beat_path = "C:\Users\DaweiX\Desktop\audit\auditbeat"

# The script must be launched by admin (root)!
function Test-Administrator {  
    $user = [Security.Principal.WindowsIdentity]::GetCurrent()
    (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)  
}

if(-not (Test-Administrator)) {
    Write-Error "This script must be executed as Administrator"
    exit 1
}

If (-not (Test-Path $folder)) {
    $null = New-Item -Path $folder -ItemType Directory
} Else {
    $char = Read-Host ("The output folder <" + $folder + "> already exists. Overwrite anyway? (y/n)")
    If (-not ($char -match "y")) {
        Write-Host "Bye"
        exit 1
    }
}

Start-Service auditbeat -ErrorVariable err
if ($err) {
    exit 1
}

Write-Host "Service started" -ForegroundColor Green

While (1) {
    $char = Read-Host ("Press S to stop collect")

    If ($char -match "s") {
        # Stop collecting
        Stop-Service auditbeat
        Write-Host "Service stopped." -ForegroundColor Green

        Get-ChildItem $folder\* -Recurse | Remove-Item -Recurse
        $delay = 2
        While (1) {
            Write-Host ("Move raw logs to <" + $folder + ">") -ForegroundColor Gray
            Move-Item -Path $beat_path\auditbeat\* -Destination $folder -Force -ErrorVariable err
            If (-not $err) {
                Write-Host ("Raw logs outputed in <" + $folder + ">") -ForegroundColor Green
                Break
            } Else {
                Write-Verbose ("File locked, trying again in " + $delay)
                Start-Sleep -seconds $delay 
            }
        }
        Remove-Item $beat_path\auditbeat\*
        Break
    }
}

# ProcInfo
python3 .\parse_json.py ($folder + "\auditbeat")
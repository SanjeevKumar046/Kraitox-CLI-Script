## Check if the script is running with administrative privileges
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Run this script as an Administrator." -ForegroundColor Red
    Write-Host "exiting..." -ForegroundColor Red
    Start-Sleep -Seconds 3
    exit
}

$apps = @{
    11 = "Brave.Brave"
    12 = "Mozilla.Firefox"
    13 = "Google.Chrome"

    21 = "9NKSQGP7F2NH"
    22 = "Telegram.TelegramDesktop"
    23 = "Zoom.Zoom"

    31 = "VideoLAN.VLC"
    32 = "CodecGuide.K-LiteCodecPack.Standard"

    41 = "qBittorrent.qBittorrent"
    42 = "File-New-Project.EarTrumpet"
    43 = "Microsoft.PowerToys"
    44 = "REALiX.HWiNFO"
    45 = "GeekUninstaller.GeekUninstaller"
    46 = "7zip.7zip"
    47 = "CodeSector.TeraCopy"
    48 = "JAMSoftware.TreeSize.Free"

    51 = "Adobe.Acrobat.Reader.64-bit"
    52 = "Notepad++.Notepad++"

    X  = ""

}

function Install-Windows-Apps {
    Write-Host "`nThis script will install or update the following apps:" -ForegroundColor DarkCyan

    $categories = @{
        1 = "Web Browsers"
        2 = "Messaging"
        3 = "Media & Entertainment"
        4 = "Utilities"
        5 = "Documents & editing"
        6 = "Exit"
    }

    function Show-Menu {
        Write-Host "`n----MENU----" -ForegroundColor DarkCyan
    
        foreach ($category in $categories.Keys | Sort-Object) {
            Write-Host ""
            Write-Host "$($categories[$category]):" -ForegroundColor DarkCyan
            foreach ($key in $apps.Keys | Where-Object { $_ -match "^$category" } | Sort-Object) {
                $appId = $key
                $appName = $apps[$appId]
    
                # Retrieve and display the actual app name using winget query
                $queryCommand = "winget show --id $appName"
                $appInfo = Invoke-Expression $queryCommand -ErrorAction SilentlyContinue
                
                if ($null -ne $appInfo) {
                    $displayName = ""
    
                    # Try to extract the app name from the output
                    foreach ($line in $appInfo -split "`n") {
                        if ($line -match '^Found ([^\[]+)') {
                            $displayName = $Matches[1].Trim()
                            break
                        }
                    }
    
                    if ($displayName -ne "") {
                        Write-Host "$appId. $displayName"
                    }
                    else {
                        Write-Host "$appId. $appName"
                    }
                }
                else {
                    # If winget show fails, display the app ID
                    Write-Host "$appId. $appName"
                }
            }
        }
    }    
    
    function Install-Apps {
        param(
            [string]$selectedApps,
            [hashtable]$apps
        )
    
        if ($selectedApps -eq "X" -or $selectedApps -eq "x") {
            Write-Host "Exiting the script..." -ForegroundColor Red
            exit
        }
    
        while ($true) {
            # Split the selected apps into an array
            $selectedAppIds = $selectedApps -split ',' | ForEach-Object { $_.Trim() }
            
            # Validate selected app numbers and get app names
            $invalidApps = @()
            $selectedAppNames = @()
            foreach ($appId in $selectedAppIds) {
                if ($apps.ContainsKey([int]$appId)) {
                    $selectedAppNames += $apps[[int]$appId]
                }
                else {
                    $invalidApps += $appId
                }
            }
        
            if ($invalidApps.Count -gt 0) {
                Write-Host "Invalid app number(s): $($invalidApps -join ', '). Refer to the list above." -ForegroundColor Red
                Write-Host "`nPlease enter the numbers of the apps to install or update (separated by comma)." -ForegroundColor DarkCyan
                $selectedApps = Read-Host "For example 11, 31 to install Brave and VLC"
            }
            else {
                # Prompt for confirmation
                if ($selectedAppNames.Count -gt 0) {
                    Write-Host "`nThis script will install or update the following apps:" -ForegroundColor DarkCyan
                    foreach ($appId in $selectedAppIds) {
                        if ($apps.ContainsKey([int]$appId)) {
                            $appName = $apps[[int]$appId]
        
                            # Retrieve and display the actual app name using winget query
                            $queryCommand = "winget show --id $appName"
                            $appInfo = Invoke-Expression $queryCommand -ErrorAction SilentlyContinue
                            
                            if ($null -ne $appInfo) {
                                $displayName = ""
        
                                # Try to extract the app name from the output
                                foreach ($line in $appInfo -split "`n") {
                                    if ($line -match '^Found ([^\[]+)') {
                                        $displayName = $Matches[1].Trim()
                                        break
                                    }
                                }
        
                                if ($null -ne $displayName) {
                                    Write-Host "- $displayName"
                                }
                                else {
                                    Write-Host "- $appName"
                                }
                            }
                            else {
                                # If winget show fails, display the app ID
                                Write-Host "- $appName"
                            }
                        }
                    }
                }

                $confirmationMessage = "Do you want to continue?"
                $confirmation = $host.ui.PromptForChoice("Confirmation", $confirmationMessage, @("&Yes", "&No"), 1)
        
                if ($confirmation -eq 0) {
                    foreach ($appId in $selectedAppIds) {
                        if ($apps.ContainsKey([int]$appId)) {
                            $appName = $apps[[int]$appId]
                            Write-Host "Installing $appName..."
                            $installCommand = "winget install -e --id '$appName'"
                            Invoke-Expression $installCommand
                        }
                    }
                    break  # Exit the loop if installation proceeds
                }
                else {
                    Write-Host "`nOperation canceled." -ForegroundColor Red
                    break  # Exit the loop if operation is canceled
                }
            }
        }
    }
                
    Show-Menu

    Write-Host "`nEnter the numbers of the apps to install or update (separated by comma)." -ForegroundColor DarkCyan
    $selectedApps = Read-Host "For example 11, 31 to install Brave and VLC"

    Install-Apps -selectedApps $selectedApps -apps $apps
}

Clear-Host

Write-Host "  ______ _______ ______  ______      ______ _______ ______  ______ _______ " -ForegroundColor DarkCyan
Write-Host " / _____|_______|_____ \(_____ \    / _____|_______|_____ \(_____ (_______)" -ForegroundColor DarkCyan
Write-Host "( (____  _____   _____) )_____) )  ( (____  _       _____) )_____) )  _    " -ForegroundColor DarkCyan
Write-Host " \____ \|  ___) |  __  /|  ____/    \____ \| |     |  __  /|  ____/  | |   " -ForegroundColor DarkCyan
Write-Host " _____) ) |_____| |  \ \| |         _____) ) |_____| |  \ \| |       | |   " -ForegroundColor DarkCyan
Write-Host "(______/|_______)_|   |_|_|        (______/ \______)_|   |_|_|       |_|   " -ForegroundColor DarkCyan

Install-Windows-Apps

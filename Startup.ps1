## Check if the script is running with administrative privileges
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Run this script as an Administrator." -ForegroundColor Red
    Write-Host "exiting..." -ForegroundColor Red
    Start-Sleep -Seconds 3
    exit
}

## Essential apps
$apps = @{
    11 = "Brave.Brave"
    12 = "Mozilla.Firefox"
    13 = "Google.Chrome"

    21 = "9NKSQGP7F2NH"
    22 = "Telegram.TelegramDesktop"
    23 = "Zoom.Zoom"

    31 = "VideoLAN.VLC"
    32 = "CodecGuide.K-LiteCodecPack.Standard"

    41 = "CodeSector.TeraCopy"
    42 = "JAMSoftware.TreeSize.Free"

    51 = "Microsoft.PowerToys"
    52 = "REALiX.HWiNFO"
    53 = "GeekUninstaller.GeekUninstaller"
    54 = "File-New-Project.EarTrumpet"
    55 = "7zip.7zip"

    61 = "qBittorrent.qBittorrent"
    62 = "SoftDeluxe.FreeDownloadManager"

    71 = "Adobe.Acrobat.Reader.64-bit"
    72 = "Notepad++.Notepad++"
    73 = "TheDocumentFoundation.LibreOffice"
    
    81 = "Malwarebytes.Malwarebytes"
    82 = "Bitdefender.Bitdefender"

    91 = "AnyDeskSoftwareGmbH.AnyDesk"

}

function Install-Windows-Apps {
    Write-Host "`nThis script will install or update the following apps:" -ForegroundColor DarkYellow

    $categories = @{
        1 = "Web Browsers"
        2 = "Messaging & Communication"
        3 = "Media & Entertainment"
        4 = "File Management"
        5 = "System Utilities"
        6 = "Network & Internet"
        7 = "PDF & Documents"
        8 = "Security and Privacy"
        9 = "Others"
    }

    function Show-Menu {
        Write-Host "`n----MENU----" -ForegroundColor DarkYellow
    
        foreach ($category in $categories.Keys | Sort-Object) {
            Write-Host ""
            Write-Host "$($categories[$category]):" -ForegroundColor DarkYellow
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
                Write-Host "`nPlease enter the numbers of the apps to install or update (separated by comma)." -ForegroundColor DarkYellow
                Write-Host "For example 11, 31 to install Brave and VLC: " -NoNewline -ForegroundColor Red
                $selectedApps = Read-Host
            }
            else {
                # Prompt for confirmation
                if ($selectedAppNames.Count -gt 0) {
                    Write-Host "`nThis script will install or update the following apps:" -ForegroundColor DarkYellow
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

    Write-Host "`nEnter the numbers of the apps to install or update (separated by comma)." -ForegroundColor DarkYellow
    Write-Host "For example 11, 31 to install Brave and VLC: " -NoNewline -ForegroundColor DarkGray
    $selectedApps = Read-Host

    Install-Apps -selectedApps $selectedApps -apps $apps
}

Clear-Host
Write-Host @"
   __ __         _ __             ____        _      __ 
  / //_/______ _(_) /____ __ __  / __/_______(_)__  / /_
 / ,< / __/ _ ` / / __/ _ \\ \ / _\ \/ __/ __/ / _ \/ __/
/_/|_/_/  \_,_/_/\__/\___/_\_\ /___/\__/_/ /_/ .__/\__/ 
                                            /_/         
"@ -ForegroundColor DarkYellow

Install-Windows-Apps

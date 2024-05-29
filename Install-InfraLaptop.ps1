#Requires -RunAsAdministrator
# Requires administrative privileges to execute.
function provision-computer {
    param(
        # Flag to decide whether to install default packages.
        [bool]$defaultPackages,

        # Flag to decide whether to install Visual Studio Code extensions.
        [bool]$vsCodeExtensions,

        # Optional flag for installing Azure development tools like Postman and Fiddler.
        [Parameter(Mandatory = $false, HelpMessage = "DevelopmentTools (Postman, Fiddler etc.)")]
        [bool]$azureTools,

        # Optional flag for installing additional PowerShell modules like PRTG and SNMP.
        [Parameter(Mandatory = $false, HelpMessage = "Extra PS modules (PRTG, TopDesk, SNMP etc)")]        
        [bool]$powershellModules,

        # Optional security settings such as disabling PowerShell 2.0 and Windows Script Host.
        [Parameter(Mandatory = $false, HelpMessage = "Remove PS2.0, Disable Windows Script Host and allow more frequent laptop snapshots/checkpoints (Shadowcopy)")]    
        [bool]$ExtraSecurityOptions
    
    )
    begin {
        # Check if the Chocolatey package manager is installed.
        if (-not (Test-Path -Path "$env:Programdata\chocolatey\bin\choco.exe")) {
            $prompt = Read-Host "Chocolatey is currently not installed, but it's required to run script. Install it for you? [Y/n]."
            if ($prompt -eq 'y') {
                Write-Host "Installing Chocolatey"
                Set-ExecutionPolicy Bypass -Scope Process -Force; 
                [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; 
                # Download and run the Chocolatey installation script from their official website.
                Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
                Write-Host "Chocolatey installed, please restart script to continue."
                Pause
            }
            else {
                exit
            }
        }
    }
    process {
        $chocoPackages = @()
        # Add default packages if the flag is set.
        if ($defaultPackages) {
            $chocoPackages += @(
                "7zip",
                "7zip.install",
                "powershell-core",
                "python"
                "filezilla",
                "firefox",
                "git",
                "googlechrome",
                "lockhunter",
                "nmap",
                "notepadplusplus",
                "notepadplusplus.install",
                "openhardwaremonitor",
                "putty.install",
                "sysinternals",
                "vlc",
                "vscode",
                "vscode.install",
                "wireshark",
                "spotify",
                "jabra-direct",
                "mremoteng",
                "github-desktop"

            )
        }
        # Add Azure tools if the flag is set.
        if ($azureTools) {
            $chocoPackages += "azure-cli", "microsoftazurestorageexplorer",  "azure-pipelines-agent"
        }

        # Install all specified Chocolatey packages.
        if ($chocoPackages) {
            $chocoPackages | ForEach-Object {
                Write-Host "Installing Chocolatey package $_"
                choco install $_ -y
            }
        }

        # Install Visual Studio Code extensions if the flag is set.
        $VscodeExtensionNames = @(
            "aaron-bond.better-comments",
            "eamodio.gitlens",
            "esbenp.prettier-vscode",
            "formulahendry.code-runner",
            "ironmansoftware.powershellprotools",
            "liximomo.sftp",
            "ms-dotnettools.vscode-dotnet-runtime",
            "ms-vscode-remote.remote-wsl",
            "ms-vscode.azure-account",
            "ms-vscode.notepadplusplus-keybindings",
            "ms-vscode.powershell",
            "yzhang.markdown-all-in-one",
            "ms-vsliveshare.vsliveshare"
        )
        if ($vsCodeExtensions) {
            $VscodeExtensionNames | code --install-extension $_ --force
        }
        
        # Implement extra security options if the flag is set.
        if ($ExtraSecurityOptions) {
            Write-Host "Disabling PowerShell v2 engine, prevents downgrade attacks"
            Disable-WindowsOptionalFeature -Online -FeatureName MicrosoftWindowsPowerShellV2Root

            # Disable Windows Script Host to block Visual Basic script execution.
            Write-Host "Disabling Visual Basic Engine"
            Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows Script Host\Settings"  | Set-ItemProperty -Name Enabled -Value 0

            Write-Host "Setting up Windows to create a system restore point every 10 days."
            Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore" | Set-ItemProperty -Name SystemRestorePointCreationFrequency -Value "000000f0"
        }

        # Install additional useful PowerShell modules if the flag is set.
        if ($powershellModules) {
            $moduleNames = @(
                "ImportExcel",
                "Microsoft.Graph",
                "Microsoft.Graph.Authentication",
                "PSDocs",
                "PSMermaid",
                "PSScriptAnalyzer",
                "PowerShell-yaml",
                "PrtgAPI",
                "SNMP",
                "VMware.Vim",
                "platyPS",
                "posh-git",
                "ExchangeOnlineManagement" 
            )
            $moduleNames | ForEach-Object {
                Install-Module -Name $_ -Scope currentuser
            }
        }
    }
    end {
    }
}

# Configuration dictionary for function parameters.
$config = @{
    defaultPackages       = 1
    vsCodeExtensions      = 0
    azureTools            = 0 # Azure DevOps Tools
    powershellModules     = 0 # Extra PS modules (PRTG, TopDesk, SNMP etc)
    ExtraSecurityOptions  = 0 # Remove PS2.0, Disable Windows Script Host and allow more frequent laptop snapshots/checkpoints (Shadowcopy)
}

# Run the function with the specified configuration.
provision-computer @config

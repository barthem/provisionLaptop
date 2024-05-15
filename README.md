# Infra Specialist Laptop Provisioning Script

## Introduction
This PowerShell script is designed to automate the setup of a new InfraSpecialist laptop. It can install a predefined list of software packages, Visual Studio Code extensions, additional PowerShell modules, and apply extra security configurations. The script leverages Chocolatey, a package manager for Windows, to handle software installations.

## Features
- **Software Installation**: Installs a set of default software packages using Chocolatey.
- **VS Code Extensions**: Installs predefined Visual Studio Code extensions.
- **Azure Tools**: Optional installation of Azure-related tools for development.
- **PowerShell Modules**: Installs additional PowerShell modules that can be useful for various tasks.
- **Extra Security Options**: Applies security settings such as disabling PowerShell 2.0 and the Windows Script Host, and configuring system restore point frequency.

## Requirements
- **Windows PowerShell**: Must be run with PowerShell.
- **Administrative Privileges**: Requires administrative rights to execute.
- **Internet Connection**: Needed to download packages and scripts.
- **Chocolatey**: The script checks for Chocolatey and offers to install it if not present.

## Usage

To use this script, you can either clone this repository or copy the script into a PowerShell file locally. 

1. **open script**, edit the $config variable on line 144 to select what you want to install. 
2. **save and close script**
3. **Open PowerShell as Administrator**: Right-click PowerShell and select "Run as administrator".
4. **Execute the Script**:
   ```powershell
   # Navigate to the directory containing the script
   cd path\to\script
   # Execute the script
   .\provision-computer.ps1

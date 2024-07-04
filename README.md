# Kraitox CLI Script

A PowerShell script for installing essential apps via Winget after a fresh Windows install, offering a selectable list of must-have applications.

[Report Bug](https://github.com/SanjeevKumar046/Kraitox-Script/issues/new?labels=bug&template=bug-report---.md) | [Request Feature](https://github.com/SanjeevKumar046/Kraitox-Script/issues/new?labels=enhancement&template=feature-request---.md)


## About The Project

![Product Screenshot](https://imgur.com/J9YjoSh.png)

This PowerShell script is designed to streamline the setup process after a fresh Windows installation by automating the installation of essential applications. It provides a user-friendly menu to select and install/update various categories of applications using Windows Package Manager (winget).

## Built With

- [Powershell](https://learn.microsoft.com/en-us/powershell/)

## Getting Started

To get started with using this script, follow these steps:
`Run powershell as admin before you run the script`

**Review Application Categories:** The script categorizes applications into different groups such as Web Browsers, Messaging & Communication, Media & Entertainment, etc.

**Select Applications:** From each category, choose the applications you want to install or update by entering their corresponding numbers separated by commas.

**Confirm Installation:** After selecting the applications, the script will prompt you to confirm the installation. Review the list of selected applications and proceed with installation or cancel if needed.

## Usage

### Menu Navigation:
- Upon running the script, you will see a menu listing various application categories.
- Each category displays numbered options for applications available in that category.

### Select Applications:
- Enter the numbers of the applications you wish to install/update, separated by commas.
- If you make a mistake or want to cancel, entering 'X' or 'x' will exit the script.

### Confirmation:
- After selecting applications, the script will display a list of chosen applications for confirmation.
- Choose 'Yes' to proceed with installation or 'No' to cancel.

### Installation Progress:
- The script will proceed to install each selected application using winget.
- Progress and installation status will be displayed in the console.

### Completion:
- Once all selected applications are installed, the script will conclude.

### Example Usage:

**Scenario:** You want to install Brave browser, VLC media player, and Notepad++.
```
11, 31, 72
```
- Enter the above numbers when prompted for application selection.
- Confirm the installation when prompted.
- The script will install Brave, VLC, and Notepad++.

This structured approach will help users understand how to interact with your script effectively and make the most out of its capabilities. Adjust the details and instructions as necessary based on any updates or changes to the script functionality.

. $PSScriptRoot/ToolManager.ps1

function Install-MobaXterm()
{
    Write-Host 'Installing MobaXterm...'
    Install-Tool 'mobaxterm'
}

function Install-7Zip()
{
    Write-Host 'Installing 7Zip...'
    Install-Tool '7zip'
}

function Install-Utilities
{
    param (
        [bool]$installMobaXterm,
        [bool]$install7zip
    )

    if ($installMobaXterm)
    {
        Install-MobaXterm
    }

    if ($install7zip)
    {
        Install-7Zip
    }
}
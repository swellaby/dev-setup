. $PSScriptRoot/ToolManager.ps1

function Install-DotnetCore
{
    Write-Host 'Installing .NET Core SDK...'
    Install-Tool 'dotnetcore-sdk'
}

function Install-DotnetFramework
{
    Write-Host 'Installing .NET Framework 4.7.1...'
    Install-Tool 'dotnet4.7.1'
}

function Install-Nodejs
{
    Write-Host 'Installing Node.js...'
    Install-Tool 'nodejs'
    npm i -g yo
}

function Install-Golang
{
    Write-Host 'Installing Golang...'
    Install-Tool 'golang'
}

function Install-Python()
{

}

function Install-OpenJDK([ValidateSet(8,10,11)][int]$jdkVersion)
{
    $uri = ''
    $jdkFileName = ''
    $destination = 'C:\Program Files\Java\'

    if ($jdkVersion -eq 8)
    {
        Write-Host = 'You requested Open JDK 8, but that is not available on Windows. Will install the Open JDK 10 instead.'
        $jdkVersion = 10
    }

    if ($jdkVersion -eq 11)
    {
        $uri = 'https://download.java.net/java/early_access/jdk11/28/GPL/openjdk-11+28_windows-x64_bin.zip'
        $jdkFileName = 'openjdk-11_preview_windows-x64_bin.tar'
        $destination += 'jdk1.11.0_preview'
    }
    else
    {
        $uri = 'https://download.java.net/java/GA/jdk10/10.0.2/19aef61b38124481863b1413dce1855f/13/openjdk-10.0.2_windows-x64_bin.tar.gz'
        $jdkFileName = 'openjdk-10.0.2_windows-x64_bin.tar'
        $destination += 'jdk1.10.0_2'
    }

    $outPath = Join-Path -Path $env:TEMP -ChildPath $jdkFileName
    Invoke-WebRequest -Uri $uri -OutFile $outPath

    if (-NOT (Get-Command '7z' -ErrorAction SilentlyContinue))
    {
        Write-Host '7zip not found. Install PowerShell Package...'

        if (-NOT (Get-Command Expand-7Zip -ErrorAction Ignore))
        {
            Install-Package -Scope CurrentUser -Force 7Zip4PowerShell > $null
        }

        Expand-7Zip $outPath $destination
    }
    else
    {
        7z x "$outPath" -o "$destination"
    }

    $currentMachinePath = [Environment]::GetEnvironmentVariable("Path", "Machine")
    [Environment]::SetEnvironmentVariable("Path", $currentMachinePath + ";$destination\bin", [System.EnvironmentVariableTarget]::Machine)
    [Environment]::SetEnvironmentVariable("JAVA_HOME", $destination, [System.EnvironmentVariableTarget]::Machine)

    [Environment]::SetEnvironmentVariable("Path", $env:Path + ";$destination\bin", [System.EnvironmentVariableTarget]::User)
    [Environment]::SetEnvironmentVariable("JAVA_HOME", $destination, [System.EnvironmentVariableTarget]::User)

    RefreshEnv
}

function Install-OracleJDK([ValidateSet(8,10,11)][int]$jdkVersion)
{
    $installMessage = ''
    $jdkPackageArgs = ''

    if ($jdkVersion -gt 8)
    {
        $jdkPackageArgs = 'jdk10 -params "source=false"'

        if ($jdkVersion -eq 11)
        {
            $installMessage = 'You requested Oracle JDK 11, but that is not available on Windows.'
        }

        $installMessage += ' Installing Oracle JDK 10...'
    }
    else
    {
        $installMessage += ' Installing Oracle JDK 8...'
        $jdkPackageArgs = 'jdk8 -params "source=false"'
    }

    Write-Host $installMessage
    Install-Tool $jdkPackageArgs
}

function Install-Java
{
    param (
        [bool]$installOpenJDK,
        [ValidateSet(8,10,11)][int]$jdkVersion,
        [bool]$installMaven,
        [bool]$installGradle
    )

    if ($installOpenJDK)
    {
        Install-OpenJDK $jdkVersion
    }
    else
    {
        Install-OracleJDK $jdkVersion
    }

    if ($installMaven)
    {
        Write-Host 'Installing Maven...'
        Install-Tool 'maven'
    }

    if ($installGradle)
    {
        Write-Host 'Installing Gradle...'
        Install-Tool 'gradle'
    }
}

function Install-ProgrammingFrameworks
{
    param (
        [bool]$installDotnetCore,
        [bool]$installDotnetFramework,
        [bool]$installGolang,
        [bool]$installJava,
        [bool]$installOpenJDK,
        [ValidateSet(8,10,11)][int]$jdkVersion,
        [bool]$installMaven,
        [bool]$installGradle,
        [bool]$installNodejs,
        [bool]$installPython
    )

    if ($installDotnetCore)
    {
        Install-DotnetCore
    }

    if ($installDotnetFramework)
    {
        Install-DotnetFramework
    }

    if ($installGolang)
    {
        Install-Golang
    }

    if ($installJava)
    {
        Install-Java $installOpenJDK $jdkVersion $installMaven $installGradle
    }

    if ($installNodejs)
    {
        Install-Nodejs
    }

    if ($installNodejs)
    {
        Install-Nodejs
    }
}

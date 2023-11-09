<# :
  @echo off
  rem PowerShell code inside batch file
  rem https://stackoverflow.com/a/57572270
  rem Hide CMD window
  rem https://stackoverflow.com/a/507372
    start powershell /nologo /noprofile /command ^
        "&{[ScriptBlock]::Create((cat """%~f0""") -join [Char[]]10).Invoke(@(&{$args}%*))}"
  exit /b
#>

# Installer for Weasel
# Copyright (C) 2023  Xuesong Peng <pengxuesong.cn@gmail.com>

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.

# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

function Get-RimeUserDir {
    $dir = ""
    $registry_root = "HKCU:\SOFTWARE\Rime\Weasel"
    if (Test-Path -Path $registry_root) {
        $dir = (Get-ItemProperty -Path $registry_root).RimeUserDir
    }
    if (!$dir) {
        $dir = "$Env:APPDATA\Rime"
    }

    return $dir
}

function Get-WeaselRoot {
    $registry_root = if ([Environment]::Is64BitOperatingSystem) {
        "HKLM:\SOFTWARE\WOW6432Node\Rime\Weasel"
    } else {
        "HKLM:\SOFTWARE\Rime\Weasel"
    }
    if (Test-Path -Path $registry_root) {
        return (Get-ItemProperty -Path $registry_root).WeaselRoot
    } else {
        return ""
    }
}

function Get-DownloadUrl {
    param(
        [string]$Owner = "amorphobia",
        [string]$Repo = "rime-jiandao",
        [switch]$Gitee
    )
    $query_url = if ($Gitee) {
        "https://gitee.com/api/v5/repos/$Owner/$Repo/releases/latest"
    } else {
        "https://api.github.com/repos/$Owner/$Repo/releases/latest"
    }
    $tag = (Invoke-WebRequest $query_url | ConvertFrom-Json).tag_name
    $zip = "jiandao-$tag.zip"

    if ($Gitee) {
        return "https://gitee.com/$Owner/$Repo/releases/download/$tag/$zip"
    } else {
        return "https://github.com/$Owner/$Repo/releases/download/$tag/$zip"
    }
}

function Start-Deployment {
    param (
        [switch]$Deploy
    )
    $dir = Get-WeaselRoot
    if ($Deploy) {
        $opt = "/deploy"
    }
    if ($dir -and (Test-Path "$dir\WeaselDeployer.exe")) {
        & "$dir\WeaselDeployer.exe" $opt
        return $true
    } else {
        return $false
    }
}

function Get-GuiXAML {
    [xml]$XAML = @"
<Window xmlns = "http://schemas.microsoft.com/winfx/2006/xaml/presentation" Height = "232" Width = "384" ResizeMode = "NoResize">
    <Grid Name = "XMLGrid">
        <TextBlock Name = "Source" FontSize = "16" Height = "26" Width = "340" HorizontalAlignment="Left" VerticalAlignment="Top" Margin = "16,8,0,0" Text = "Select source" />
        <RadioButton Name = "GitHub" FontSize = "16" Height = "26" Width = "80" HorizontalAlignment = "Left" VerticalAlignment = "Top" Margin = "14,38,0,0" GroupName="Source" Content="GitHub" IsChecked = "True" />
        <RadioButton Name = "Gitee" FontSize = "16" Height = "26" Width = "80" HorizontalAlignment = "Left" VerticalAlignment = "Top" Margin = "194,38,0,0" GroupName="Source" Content="Gitee" />
        <CheckBox Name = "OverwriteDict" FontSize = "16" Width="340" HorizontalAlignment="Left" VerticalAlignment="Top" Margin = "14,76,0,0" Content = "Overwrite User Dict (jiandao.user.dict.yaml)" />
        <CheckBox Name = "OverwriteConf" FontSize = "16" Width="340" HorizontalAlignment="Left" VerticalAlignment="Top" Margin = "14,114,0,0" Content = "Overwrite User Default Config (default.custom.yaml)" />
        <Button Name = "Confirm" FontSize = "16" Height = "26" Width = "160" HorizontalAlignment = "Left" VerticalAlignment = "Top" Margin = "14,146,0,0" Content = "Confirm" />
        <Button Name = "Cancel" FontSize = "16" Height = "26" Width = "160" HorizontalAlignment = "Left" VerticalAlignment = "Top" Margin = "194,146,0,0" Content = "Cancel" />
    </Grid>
</Window>
"@
    return $XAML
}

# From https://www.powershellgallery.com/packages/IconForGUI/1.5.2
# Copyright (C) 2016 Chris Carter. All rights reserved.
# License: https://creativecommons.org/licenses/by-sa/4.0/
function ConvertTo-ImageSource {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
        [System.Drawing.Icon]$Icon
    )

    Process {
        foreach ($i in $Icon) {
            [System.Windows.Interop.Imaging]::CreateBitmapSourceFromHIcon(
                $i.Handle,
                (New-Object System.Windows.Int32Rect -Args 0,0,$i.Width, $i.Height),
                [System.Windows.Media.Imaging.BitmapSizeOptions]::FromEmptyOptions()
            )
        }
    }
}

function Add-Dependancies {
    # WPF GUI support From https://github.com/pbatard/Fido
    # Copyright (C) 2019-2023 Pete Batard <pete@akeo.ie>
    # License: https://github.com/pbatard/Fido/blob/master/LICENSE.txt
    $Drawing_Assembly = "System.Drawing"
    # PowerShell 7 altered the name of the Drawing assembly...
    if ($host.version -ge "7.0") {
        $Drawing_Assembly += ".Common"
    }
    $Signature = @{
        Namespace            = "WinAPI"
        Name                 = "Utils"
        Language             = "CSharp"
        UsingNamespace       = "System.Runtime", "System.IO", "System.Text", "System.Drawing", "System.Globalization"
        ReferencedAssemblies = $Drawing_Assembly
        ErrorAction          = "Stop"
        WarningAction        = "Ignore"
        MemberDefinition     = @"
            [DllImport("shell32.dll", CharSet = CharSet.Auto, SetLastError = true, BestFitMapping = false, ThrowOnUnmappableChar = true)]
            internal static extern int ExtractIconEx(string sFile, int iIndex, out IntPtr piLargeVersion, out IntPtr piSmallVersion, int amountIcons);

            [DllImport("user32.dll")]
            public static extern bool ShowWindow(IntPtr handle, int state);
            // Extract an icon from a DLL
            public static Icon ExtractIcon(string file, int number, bool largeIcon) {
                IntPtr large, small;
                ExtractIconEx(file, number, out large, out small, 1);
                try {
                    return Icon.FromHandle(largeIcon ? large : small);
                } catch {
                    return null;
                }
            }
"@
    }

    if (!("WinAPI.Utils" -as [type])) {
        Add-Type @Signature
    }
    Add-Type -AssemblyName PresentationFramework
}

function Install-Jiandao {
    param(
        [switch]$Gitee,
        [switch]$OverwriteDict,
        [switch]$OverwriteConf
    )

    $download_url = Get-DownloadUrl -Gitee:$Gitee
    $tmp = New-TemporaryFile
    $zip = Move-Item -Path (Convert-Path $tmp.PSPath) -Destination ((Convert-Path $tmp.PSParentPath) + "\" + ([uri]$download_url).Segments[-1]) -PassThru -Force
    $dest_path = "$env:TEMP\" + [io.path]::GetFileNameWithoutExtension($zip)

    Write-Host "$([char]0x6b63)$([char]0x5728)$([char]0x4e0b)$([char]0x8f7d)$([char]0x952e)$([char]0x9053)$([char]0x2026)"
    Invoke-WebRequest $download_url -Out $zip

    Write-Host "$([char]0x6b63)$([char]0x5728)$([char]0x89e3)$([char]0x538b)$([char]0x2026)"
    Expand-Archive -Path $zip -Destination $dest_path -Force

    $rime_user_dir = Get-RimeUserDir

    if (!$OverwriteDict -and (Test-Path "$rime_user_dir\jiandao.user.dict.yaml")) {
        Remove-Item -Force "$dest_path\jiandao.user.dict.yaml"
    }

    if ($OverwriteConf -or !(Test-Path "$rime_user_dir\default.custom.yaml")) {
        $DefaultContent = @"
patch:
  schema_list:
    - schema: jiandao
"@
        [IO.File]::WriteAllLines("$dest_path\default.custom.yaml", $DefaultContent)
    }

    Write-Host "$([char]0x6b63)$([char]0x5728)$([char]0x590d)$([char]0x5236)$([char]0x6587)$([char]0x4ef6)$([char]0x2026)"
    Copy-Item -Force -Recurse "$dest_path\*" "$rime_user_dir\"

    Write-Host "$([char]0x6b63)$([char]0x5728)$([char]0x6e05)$([char]0x7406)$([char]0x4e34)$([char]0x65f6)$([char]0x6587)$([char]0x4ef6)$([char]0x2026)"
    Remove-Item -Recurse -Force $zip
    Remove-Item -Recurse -Force $dest_path

    $Deploy = [System.Windows.MessageBox]::Show("$([char]0x91cd)$([char]0x65b0)$([char]0x90e8)$([char]0x7f72)$([char]0xff1f)", "$([char]0x5b89)$([char]0x88c5)$([char]0x5b8c)$([char]0x6bd5)", "OKCancel")

    if ($Deploy -eq "OK") {
        $success = Start-Deployment -Deploy
        if ($success) {
            Write-Host "$([char]0x5f00)$([char]0x59cb)$([char]0x90e8)$([char]0x7f72)$([char]0x2026)"
        } else {
            Write-Error "$([char]0x90e8)$([char]0x7f72)$([char]0x5931)$([char]0x8d25)"
        }
    }
}

$Str = @{
    confirm = "$([char]0x786e)$([char]0x5b9a)"
    cancel = "$([char]0x53d6)$([char]0x6d88)"
    source = "$([char]0x9009)$([char]0x62e9)$([char]0x6e90)"
    overwritedict = "$([char]0x8986)$([char]0x76d6)$([char]0x7528)$([char]0x6237)$([char]0x8bcd)$([char]0x5178) (jiandao.user.dict.yaml)"
    overwriteconf = "$([char]0x8986)$([char]0x76d6)$([char]0x7528)$([char]0x6237)$([char]0x914d)$([char]0x7f6e) (default.custom.yaml)"
}

function Start-MainGui {
    try {
        [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
    } catch {}

    Add-Dependancies

    # Hide the powershell window: https://stackoverflow.com/a/27992426/1069307
    [WinAPI.Utils]::ShowWindow(([System.Diagnostics.Process]::GetCurrentProcess() | Get-Process).MainWindowHandle, 0) | Out-Null

    $XAML = Get-GuiXAML
    $XMLForm = [Windows.Markup.XamlReader]::Load((New-Object System.Xml.XmlNodeReader $XAML))
    $XAML.SelectNodes("//*[@Name]") | ForEach-Object {
        Set-Variable -Name ($_.Name) -Value $XMLForm.FindName($_.Name) -Scope Script
    }
    $XMLForm.Title = "$([char]0x5b89)$([char]0x88c5)$([char]0x952e)$([char]0x9053)"
    $XMLForm.Icon = [WinAPI.Utils]::ExtractIcon("shell32.dll", 43, $true) | ConvertTo-ImageSource

    if (!(Test-Connection "raw.githubusercontent.com" -Quiet -Count 1)) {
        $Gitee.IsChecked = "True"
    }

    $Confirm.Content = $Str.confirm
    $Cancel.Content = $Str.cancel
    $Source.Text = $Str.source
    $OverwriteDict.Content = $Str.overwritedict
    $OverwriteConf.Content = $Str.overwriteconf

    $Cancel.add_click({
        $XMLForm.Close()
    })

    $Confirm.add_click({
        Install-Jiandao -Gitee:$Gitee.IsChecked -OverwriteDict:$OverwriteDict.IsChecked -OverwriteConf:$OverwriteConf.IsChecked
        $XMLForm.Close()
    })

    $XMLForm.Add_Loaded({$XMLForm.Activate()})
    $XMLForm.ShowDialog() | Out-Null
}

Start-MainGui

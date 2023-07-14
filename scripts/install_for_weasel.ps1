# Install for Weasel
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

<#
.SYNOPSYS
    Rime schema installer
.DESCRIPTION
    Install rime-jiandao for Weasel
.LINK
    https://github.com/amorphobia/rime-jiandao
#>

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
    $registry_root = "HKLM:\SOFTWARE\WOW6432Node\Rime\Weasel"
    if (Test-Path -Path $registry_root) {
        return (Get-ItemProperty -Path $registry_root).WeaselRoot
    } else {
        return ""
    }
}

function Get-DownloadUrl {
    $query_url = "https://api.github.com/repos/amorphobia/rime-jiandao/releases/latest"
    $tag = (Invoke-WebRequest $query_url | ConvertFrom-Json).tag_name
    $zip = "jiandao-$tag.zip"

    return "https://github.com/amorphobia/rime-jiandao/releases/download/$tag/$zip"
}

function Start-Deployment {
    param (
        [switch] $deploy
    )
    $dir = Get-WeaselRoot
    if ($deploy) {
        $opt = "/deploy"
    }
    if ($dir -and (Test-Path "$dir\WeaselDeployer.exe")) {
        & "$dir\WeaselDeployer.exe" $opt
    }
}

$download_url = Get-DownloadUrl
$tmp = New-TemporaryFile
$zip = Move-Item -Path (Convert-Path $tmp.PSPath) -Destination ((Convert-Path $tmp.PSParentPath) + "\" + ([uri]$download_url).Segments[-1]) -PassThru -Force
$dest_path = "$env:TEMP\" + [io.path]::GetFileNameWithoutExtension($zip)

Write-Host "Downloading latest Jiandao schema ..."
Invoke-WebRequest $download_url -Out $zip

Write-Host "Expanding zip archive ..."
Expand-Archive -Path $zip -DestinationPath $dest_path -Force

$rime_user_dir = Get-RimeUserDir

if (Test-Path "$rime_user_dir\jiandao.user.dict.yaml") {
    Remove-Item -Force "$dest_path\jiandao.user.dict.yaml"
}

Write-Host "Copying files to rime user data directory ..."
Copy-Item -Force -Recurse "$dest_path\*" "$rime_user_dir\"

Write-Host "Cleaning up downloaded files ..."
Remove-Item -Recurse -Force $zip
Remove-Item -Recurse -Force $dest_path

if (!(Test-Path "$rime_user_dir\default.custom.yaml" -PathType Leaf)) {
    Set-Content -Path "$rime_user_dir\default.custom.yaml" -Value "patch:`n  schema_list:`n    - schema: jiandao"
}

Write-Host "Choose the schemas you desired in the popping up dialog."
Start-Deployment

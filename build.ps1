$o = New-Item -Path "TSMMPackage/plugins" -ItemType Directory -Force
Copy-Item "icon.png" -Destination "./TSMMPackage" -Force
Copy-Item "README.md" -Destination "./TSMMPackage" -Force
Copy-Item "manifest.json" -Destination "./TSMMPackage" -Force
Copy-Item "translation.tsv" -Destination "./TSMMPackage/plugins" -Force

$buildResult = [string[]](dotnet build .)
if ($LASTEXITCODE -eq 0){
	Write-Host "compile success"
}
$dll = $buildResult[5].Split('>')[1].Trim()
Copy-Item $dll -Destination "./TSMMPackage/plugins" -Force

Write-Host "generating thunderstore mod package"
Compress-Archive -Path "./TSMMPackage/*" -DestinationPath "TSMMPackage.zip" -Force

$pluginsPath = "$env:APPDATA\Thunderstore Mod Manager\DataFolder\Stacklands\profiles\Default\BepInEx\plugins"
$pluginManifest = Get-Content -Raw .\manifest.json | ConvertFrom-Json
$pluginFolderName = "local-$($pluginManifest.name)"
$pluginFolder = "$pluginsPath\$pluginFolderName"
$o = New-Item -Path "$pluginFolder" -ItemType Directory -Force
Write-Host "syncing folder"
Copy-Item "icon.png" -Destination "$pluginFolder" -Force
Copy-Item "README.md" -Destination "$pluginFolder" -Force
Copy-Item "manifest.json" -Destination "$pluginFolder" -Force
Copy-Item "translation.tsv" -Destination "$pluginFolder" -Force
Copy-Item $dll -Destination "$pluginFolder" -Force
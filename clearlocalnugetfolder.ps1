param([string]$LocalNugetFolder)

function processCachePackage {
    param($cachePackageFolder, [string]$localNugetFolder)
    
    Get-ChildItem -Path $localNugetFolder -File | ForEach-Object {
        if ($_.Name.StartsWith($cachePackageFolder.Name, 'InvariantCultureIgnoreCase')) {
            #write-host $cachePackageFolder.FullName, $_.FullName
            $packageNameWithVersion = [System.IO.Path]::GetFileNameWithoutExtension($_.Name)
            $packageVersion = $packageNameWithVersion.Substring($cachePackageFolder.Name.Length + 1)
            $cachePackageVersionFolder = [System.IO.Path]::Combine($cachePackageFolder.FullName, $packageVersion)
            if ([System.IO.Directory]::Exists($cachePackageVersionFolder)) {
                write-host $cachePackageVersionFolder
                [System.IO.Directory]::Delete($cachePackageVersionFolder, $true)
                [System.IO.File]::Delete($_.FullName)
            }
        }
    }
}

function clearLocalNugetFolder {
    param([string]$officialCacheFolder, [string]$localNugetFolder)

    Get-ChildItem -Path $officialCacheFolder -Directory | ForEach-Object {
        processCachePackage -cachePackageFolder $_ -localNugetFolder $localNugetFolder
    }
}

$OfficialCacheFolder = [System.IO.Path]::Combine($env:userprofile, '.nuget', 'packages')

clearLocalNugetFolder -officialCacheFolder $OfficialCacheFolder -localNugetFolder $LocalNugetFolder
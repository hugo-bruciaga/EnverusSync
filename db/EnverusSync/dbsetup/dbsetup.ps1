param(
    [Parameter(Mandatory = $true)][string]$db_server
)

try {
    $db_name = "EnverusSync"
    $db_version = "0.0.1729283820"

    Write-Host "Starting $db_name v$db_version Installation ($db_server)"
    Write-Host "--------------------------------------------"


    # ----------------------------------------------------------------------------------
    # Extract sqlpackage
    # ----------------------------------------------------------------------------------
    Write-Host "Extracting sqlpackage"
    Add-Type -assembly "system.io.compression.filesystem"
    $cwd = (Get-Location).path
    $sqlpackage_zip = $cwd+"\sqlpackage.zip"
    $sqlpackage_dest = $cwd+"\sqlpackage"
    [io.compression.zipfile]::ExtractToDirectory($sqlpackage_zip, $sqlpackage_dest)


    # ----------------------------------------------------------------------------------
    # Deploy Database
    # ----------------------------------------------------------------------------------
    Write-Host "Deploying $db_name"
    $dacpac_file = "$db_name.dacpac"

    .\sqlpackage\sqlpackage.exe `
        /a:Publish `
        /sf:$dacpac_file `
        /tsn:$db_server `
        /tdn:$db_name `
        /dsp:"$db_name.dbsetup.sql" `
        /drp:"$db_name.dbsetup.xml" `
        /p:CompareUsingTargetCollation=$true `
        /p:BlockOnPossibleDataLoss=$false `
        /p:IgnoreColumnOrder=$true `
        /p:DropObjectsNotInSource=$true `
        /p:DropPermissionsNotInSource=$false `
        /p:DropRoleMembersNotInSource=$false `
        /p:DropExtendedPropertiesNotInSource=$false `
        /p:DoNotDropObjectTypes="Users;Logins;RoleMembership;Permissions" `
        /p:GenerateSmartDefaults=$true `
        /p:IgnoreNotForReplication=$true `
        /p:IncludeCompositeObjects=$true `

    Write-Host "sqlpackage exited with code (" + $LastExitCode + ")"
}

catch {
    Throw $_
}

Finally {
    Write-Host "Removing extracted sqlpackage"
    Remove-Item -path $sqlpackage_dest -Recurse

    Write-Host "$db_name Installation Completed"
}
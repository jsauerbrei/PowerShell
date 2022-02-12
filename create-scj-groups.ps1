$credentials = Get-Credential
$url = "https://scj-admin.sharepoint.com"
Connect-PnPOnline -Url $url -Credentials $credentials
# Map local or mapped CSV file to create sites in SCJ SharePoint Online Production Tenant
$siteCollectionFile = "C:\scripts\newsitematerials\security.csv"


$sites = Import-Csv $siteCollectionFile
foreach ($site in $sites) {
    try {
        # Map local or mapped CSV file to create sites in SCJ SharePoint Online Production Tenant
        Set-PnPTraceLog -On -LogFile 'C:\scripts\newsitematerials\Log-Create-SCJ-Create-Group3.txt' -Level Error -Delimiter ","
        $context = New-Object Microsoft.SharePoint.Client.ClientContext($site.Url)
        Connect-PnPOnline -Url $site.Url -Credentials $credentials

        
        $ownerGroup = Get-PnPGroup -AssociatedOwnerGroup

        $roleDefinition = Add-PnPRoleDefinition -RoleName "SCJ Owner" -Clone "Full Control" -Exclude ManageSubwebs, CreateSSCSite, CreateGroups, ManagePermissions
        $group = New-PnPGroup -Title "SCJ Owners" -Owner $ownerGroup.LoginName
         Set-PnPGroup -Identity "SCJ Owners" -AddRole "SCJ Owner"
    
        $roleDefinition = Add-PnPRoleDefinition -RoleName "SCJ Design" -Clone "Design" -Exclude CancelCheckout, CreateSSCSite
        $group = New-PnPGroup -Title "SCJ Designers" -Owner $ownerGroup.LoginName
        Set-PnPGroup -Identity "SCJ Designers" -AddRole "SCJ Design"

        $roleDefinition = Add-PnPRoleDefinition -RoleName "SCJ Contribute" -Clone "Contribute" -Exclude CreateSSCSite
        $group = New-PnPGroup -Title "SCJ Contributors" -Owner $ownerGroup.LoginName
        Set-PnPGroup -Identity "SCJ Contributors" -AddRole "SCJ Contribute"

        $roleDefinition = Add-PnPRoleDefinition -RoleName "SCJ Contribute (No Delete)" -Clone "Contribute" -Exclude DeleteListItems, DeleteVersions, CreateSSCSite
        $group = New-PnPGroup -Title "SCJ Contributors (No Delete)" -Owner $ownerGroup.LoginName
        Set-PnPGroup -Identity "SCJ Contributors (No Delete)" -AddRole "SCJ Contribute (No Delete)"

        $roleDefinition = Add-PnPRoleDefinition -RoleName "SCJ Read" -Clone "Read" -Exclude CreateSSCSite
        $group = New-PnPGroup -Title "SCJ Readers" -Owner $ownerGroup.LoginName
        Set-PnPGroup -Identity "SCJ Readers" -AddRole "SCJ Read"
    }
    catch {
        Write-Host "Site not found"
    }
}
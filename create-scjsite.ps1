$credentials =  Get-Credential
$url = "https://scj-admin.sharepoint.com"
Connect-PnPOnline -Url $url -Credentials $credentials
# Map local or mapped CSV file to create sites in SCJ SharePoint Online Production Tenant
$siteCollectionFile =  "C:\scripts\NewSiteMaterials\newSites.csv"
 

$sites = Import-Csv $siteCollectionFile
foreach ($site in $sites) {
    try {
        # Set TraceLog to local or mapped direcctory and update file name
        Set-PnPTraceLog -On -LogFile 'C:\Mediumlarge\medium-large-wave-creationlog.txt' -Level Error -Delimiter ","
        New-PnPTenantSite -Title $site.name -Url $site.Url -Owner $site.Owner -Template $site.Template -TimeZone $site.TimeZone
        #New-PnPSite -Type TeamSite -Title $site.name -Url $site.Url -Owner $site.Owner -Template $site.Template -TimeZone $site.TimeZone
        Write-Output "New Site Created: " $site.Url
    }
    catch {
        Write-Host "Site not found"
    }
}
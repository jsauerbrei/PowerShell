$credentials = Get-Credential
$url = "https://scj-admin.sharepoint.com"
Connect-PnPOnline -Url $url -Credentials $credentials
# Map local or mapped CSV file to create sites in SCJ SharePoint Online Production Tenant
$siteCollectionFile = "C:\scripts\NewSiteMaterials\security.csv"
$sites = Import-Csv $siteCollectionFile
#$prompt = Read-Host "Did we connect okay? "

foreach ($site in $sites) {
    try {
        # Map local or mapped CSV file to create sites in SCJ SharePoint Online Production Tenant
        ##Set-PnPTraceLog -On -LogFile 'C:\S10Mig\Log-Create-SCJ-Activate-Features3.txt' -Level Error -Delimiter ","
        Connect-PnPOnline -Url $site.Url -Credentials $credentials
        Write-Host Connected to $site.Url

        Disable-PnPFeature -Scope Site -Identity f6924d36-2fa8-4f0b-b16d-06b7250180fa

        Disable-PnPFeature -Scope Web -Identity 94c94ca6-b32f-4da9-a9e3-1f3d343d7ecb

    }
    catch {
        Write-Host "Site not found"
    }
}
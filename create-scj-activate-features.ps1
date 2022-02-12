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
        
        Write-Host Enabling Standar Site Feature b21b090c-c796-4b0f-ac0f-7ef1659c20ae
        Enable-PnPFeature -Scope Site -Identity b21b090c-c796-4b0f-ac0f-7ef1659c20ae
        Write-Host Base Site Feature Enabled b21b090c-c796-4b0f-ac0f-7ef1659c20ae

        Write-Host Enabling Enterprise Feature 8581a8a7-cf16-4770-ac54-260265ddb0b2
        Enable-PnPFeature -Scope Site -Identity 8581a8a7-cf16-4770-ac54-260265ddb0b2
        Write-Host Publishing Site Feature Enabled 8581a8a7-cf16-4770-ac54-260265ddb0b2

        Write-Host Enabling Publishing Site Feature f6924d36-2fa8-4f0b-b16d-06b7250180fa
        Enable-PnPFeature -Scope Site -Identity f6924d36-2fa8-4f0b-b16d-06b7250180fa
        Write-Host Publishing Site Feature Enabled f6924d36-2fa8-4f0b-b16d-06b7250180fa

        Write-Host Enabling Base Web Feature 99fe402e-89a0-45aa-9163-85342e865dc8
        Enable-PnPFeature -Scope Web -Identity 99fe402e-89a0-45aa-9163-85342e865dc8
        Write-Host Base Web Feature Enabled 99fe402e-89a0-45aa-9163-85342e865dc8

        Write-Host Enabling Enterprise Web Feature 0806d127-06e6-447a-980e-2e90b03101b8
        Enable-PnPFeature -Scope Web -Identity 0806d127-06e6-447a-980e-2e90b03101b8
        Write-Host Enterprise Web Feature Enabled 0806d127-06e6-447a-980e-2e90b03101b8

        Write-Host Enabling Publishing Web Feature 94c94ca6-b32f-4da9-a9e3-1f3d343d7ecb
        Enable-PnPFeature -Scope Web -Identity 94c94ca6-b32f-4da9-a9e3-1f3d343d7ecb
        Write-Host Base Publishing Feature Enabled 94c94ca6-b32f-4da9-a9e3-1f3d343d7ecb
    }
    catch {
        Write-Host "Site not found"
    }
}
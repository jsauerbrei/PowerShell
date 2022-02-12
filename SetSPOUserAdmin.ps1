Import-Module Microsoft.Online.SharePoint.PowerShell

$credentials = Get-Credential
$url = "https://peopleagainstdirty-admin.sharepoint.com"

#$username = "F315694@scj.com"
#$username = "G315695@scj.com"

#$username = "c:0t.c|tenant|bc6e7cf9-ac6a-4f4c-8130-6b53d7bcefbc" #ADMIN_ROLE
#$username = "c:0t.c|tenant|0e6a8cf3-9a5b-4ac0-9159-860e46d694bc" # IT_ROLE

$username = "QuestEssentials@peopleagainstdirty.com"

Connect-SPOService -Url $url

#$siteCollectionFile = "C:\scripts\NewSiteMaterials\security.csv"
#$sites = Import-Csv $siteCollectionFile

#foreach ($site in $sites) {
#    try {

        Set-SPOUser -Site https://peopleagainstdirty-my.sharepoint.com/personal/questtest_peopleagainstdirty_com -LoginName $username -IsSiteCollectionAdmin $true

#        Set-SPOUser -Site $sites -LoginName $username -IsSiteCollectionAdmin $true
#    }
#    catch {
#        Write-Host "Site not found"
#    }
#}

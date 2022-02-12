$credentials = Get-Credential
$url = "https://peopleagainstdirty-admin.sharepoint.com"
Connect-SPOService -Url $url
$site = Get-SPOSite "https://peopleagainstdirty.sharepoint.com/sites/Commercialization"
#$web = $site.OpenWeb()
$groups = $web.sitegroups
 
foreach ($grp in $groups) {
    "Group: " + $grp.name;
    $groupName = $grp.name
    write-host "Group: " $groupName   -foregroundcolor green
    foreach ($user in $grp.users) {
            "User: " + $user.name
            write-host "User " $user.UserLogin   -foregroundcolor red
    }
}

Export-Csv C:\Scripts\NewSiteMaterials\UserOutput.csv -NoTypeInformation
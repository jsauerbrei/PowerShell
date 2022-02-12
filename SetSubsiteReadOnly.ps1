#PowerShell to Reset Subsite Permissions to Read-Only:
#Here is the SharePoint PowerShell to make subsite read only

Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue
 
#Parameters
$SubsiteURL = "https://peopleagainstdirty.sharepoint.com/sites/AE-Test/Subsite-Test"
 
#Get the Subsite
$Web = Get-SPWeb $SubsiteURL
 
#Break Permission Inheritance, if not already
If(!$Web.HasUniqueRoleAssignments)
{
    $Web.BreakRoleInheritance($true)
}
 
#Get Required Permission Levels
$ReadPermission = $web.RoleDefinitions["Read"]
$ViewOnlyPermission = $web.RoleDefinitions["View Only"]
$LimitedAccessPermission = $web.RoleDefinitions["Limited Access"]
 
#Add Read Permission to Role Assignment, if not added already
ForEach ($RoleAssignment in $Web.RoleAssignments)
{
    $RoleDefinitionBindings = $RoleAssignment.RoleDefinitionBindings
    If(!($RoleDefinitionBindings.Contains($ReadPermission) -or $RoleDefinitionBindings.Contains($ViewOnlyPermission) -or $RoleDefinitionBindings.Contains($LimitedAccessPermission)))
    {
        $RoleAssignment.RoleDefinitionBindings.Add($ReadPermission)
        $RoleAssignment.Update()
        Write-host "Added Read Permissions to '$($RoleAssignment.Member.Name)'" -ForegroundColor Green
    }
}
 
#Remove All permissions other than Read or Similar
#ForEach ($RoleAssignment in $Web.RoleAssignments)
#{
#    $RoleDefinitionBindings = $RoleAssignment.RoleDefinitionBindings
#    For($i=$RoleAssignment.RoleDefinitionBindings.Count-1; $i -ge 0; $i--)
#    {
#        $RoleDefBinding = $RoleAssignment.RoleDefinitionBindings[$i]
#        If( ($RoleDefBinding.Name -eq "Read") -or ($RoleDefBinding.Name -eq "View Only") -or ($RoleDefBinding.Name -eq "Limited Access") )
#        {
#            Continue;
#        }
#        Else
#        {
#            $RoleAssignment.RoleDefinitionBindings.Remove($RoleAssignment.RoleDefinitionBindings[$i])
#            $RoleAssignment.Update()
#            Write-host "Removed '$($RoleDefBinding.Name)' Permissions from '$($RoleAssignment.Member.Name)'" -ForegroundColor Yellow
#        }
#    }
#}

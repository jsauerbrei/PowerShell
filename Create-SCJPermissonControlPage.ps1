$credentials = Get-Credential
$url = "https://scj-admin.sharepoint.com"
 
Connect-PnPOnline -Url $url -Credentials $credentials

$siteCollectionFile = "C:\scripts\newsitematerials\security.csv"
$sites = Import-Csv $siteCollectionFile

$SourceDocumentLib = "Pages"
$Sourceurl = "https://scj.sharepoint.com/sites/template_collaboration"


#$prompt = Read-Host "Did we connect okay? "


  Connect-PnPOnline -Url $Sourceurl -Credentials "F315694@scj.com"
  
  Get-PnPFile -Url /sites/template_collaboration/SitePages/permissions.aspx -Path c:\temp -FileName permissions.aspx -force -AsFile
 

  Set-PnPTraceLog -On -LogFile 'C:\S2Mig\Pages' -Level Error -Delimiter ","
  
#  $prompt = Read-Host "Did we connect okay? "

    
foreach ($site in $sites) {
    try {
     
   Connect-PnPOnline -Url $site.url -Credentials $credentials
  
  
  $site.url
  $navigationurl = ("{0}/SitePages/Permissions.aspx" -f $site.URL)
 
  $webs = Get-PnPWeb 
  
   
  
  $nodes = Get-PnPNavigationNode
       

#        list.EnableMinorVersions = true;

         Write-Host Disabling Feature Site pages
                
        $disable =  Disable-PnPFeature -Identity  b6917cb1-93a0-4b97-a84d-7cf49975d4ec -scope Web  -force 
         Write-Host Enabling Feature Site pages
          Start-Sleep -s 60
        
        $enable = Enable-PnPFeature -Identity  b6917cb1-93a0-4b97-a84d-7cf49975d4ec -scope Web -force 

        Write-Host Base Site Pages Feature Enabled 
       
        Write-Host "Adding Permission Page to $($site.url) "
        $file1 = Add-PnpFile -Folder "SitePages" -Path C:\Temp\Permissions.aspx -Publish
          
         Write-Host "Adding Navigaton $($site.url) "
    
         $navigation = Add-PnPNavigationNode -Title "Permissions" -Location "QuickLaunch" -URL $navigationurl


  
  #Remove these files found in Pages

  Write-Host Removing unneccessary pages
   $Files= Find-PnPFile -List "Pages" -Match *
   
         foreach($file in  $Files)
           {
               $UniqueFileName = $file.Name
               $UniqueFileName
              
               if ($UniqueFileName -eq "Permissions-UserDetails.aspx")
                {
                  $navigationurl2 = ("{0}/Pages/Permissions-UserDetails.aspx" -f $web.RelativeURL) 
                  
                     
                  Write-Host "Removing $($UniqueFileName) " 
                               
                  Remove-PNPFile -SiteRelativeUrl $navigationurl2 -Force -Recycle
                 }
  
 
                if ($UniqueFileName -eq "Permissions-Users.aspx")
                 {
                   $navigationurl3 = ("{0}/Pages/Permissions-Users.aspx" -f $web.RelativeURL) 
                    Write-Host "Removing $($UniqueFileName) " 
                     Remove-PNPFile -SiteRelativeUrl $navigationurl3 -Force -Recycle                           
                                 
                 }              
               if ($UniqueFileName -eq  "Permissions-Roles.aspx")
                {
                   $navigationurl4 =  ("{0}/Pages/Permissions-Roles.aspx" -f $web.RelativeURL)
                      Write-Host "Removing $($UniqueFileName) "                                 
                     Remove-PNPFile -SiteRelativeUrl $navigationurl4 -Force -Recycle
                           
                  }

               if ($UniqueFileName -eq "DocumentExpiration.aspx")
                 {
                  $navigationurl5 =  ("{0}/Pages/DocumentExpiration.aspx" -f $web.RelativeURL) 
                      Write-Host "Removing $($UniqueFileName) "                       
                     Remove-PNPFile -SiteRelativeUrl $navigationurl5 -Force -Recycle
                        
                 }

               if ($UniqueFileName -eq  "SCJ_SearchResults.aspx")
                {
                 $navigationurl6 =  ("{0}/Pages/SCJ_SearchResults.aspx" -f $web.RelativeURL)
                   Write-Host "Removing $($UniqueFileName) "
                                
                  Remove-PNPFile -SiteRelativeUrl $navigationurl6 -Force -Recycle
 
                    }
   
  
       #          Disconnect-PnPOnline
 
      
           }
          foreach($node in  $nodes) {
        if ($node.title -eq "Site Maintenance")
                                 {
          Write-Host "Removing Navigation $($node.Title)"
           Remove-PnPNavigationNode -Identity $node.id -Force
                    } 
                                   } 
  
    
    }
    catch { 
            Write-Host "Site not found"
    }
 }



   
               

 # Disconnect-PnPOnline

write-host "Copying of Permission Page and Removing old pages complete"

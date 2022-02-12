<#
.Description
This script moves files from one location to another (cut and paste). As a first step, the source folder structure is recreate on the destination root path to keep a consistent user experience.
Folders and Files are sorted by the Source Path column and processes in accordance.

    Note: If the source file exists on the destination path, this script will override the existing file with the source file.

.PARAMETER DriveLetter
Determines which drive letter to reference in connection to the Input file.
 
.PARAMETER InputFile
Determines the location of the input file.
 
.PARAMETER ArchivePath
Determines the location of the root archive path.
 
.PARAMETER LogPath
Determines the location of the log file path.

.EXAMPLE
PS> .\archive-files -InputFile C:\temp\InputFile.csv -ArchivePath C:\apps\Migrated -DriveLetter M -LogPath C:\apps\Logs

.SYNOPSIS
Used to move migrated files from identified drive location to identified archive location.
#>

Param($InputFile, $ArchivePath, $DriveLetter, $LogPath)

$DriveLetter = $DriveLetter + ":"

$NQArchivePath = Split-Path -Path $ArchivePath -NoQualifier

$LogFileName = $LogPath + "\LogFile_" + $(Get-Date -Format 'yyyy_MM_dd_HHmmsss') + ".csv"

$ProcessTime = Get-Date -Format "MM/dd/yyyy HH:mm:ss"

$ErrorFileName = $LogPath + "\ErrorTemp.csv"

Write-Host "Drive Letter: " $DriveLetter
Write-Host "Input File: " $InputFile
Write-Host "Archive Path: " $ArchivePath
Write-Host "Log Path: " $LogPath
Write-Host ""

#Creating folder structure to match Source Path
Write-Host "Creating Folders..."
Write-Host ""

$FolderCount = 0
#Importing Input File (specified in Parameter) and filtering to process any record that has value 'Folder' in column Type. Then all results are sorted by the Source Path.
Import-Csv -Path $InputFile | Where-Object {$_.Type -eq "Folder"} | Sort-Object $_.'Source Path' |
ForEach-Object {

                $NonQualifierPath = Split-Path -Path $_.'Source Path' -NoQualifier

                $DestinationPath = $DriveLetter + $NQArchivePath + $NonQualifierPath

    #If folder does not exist, create it, else ignore
    if ( -not(Test-Path -Path $DestinationPath))
             {
            try {

                New-Item -Path $ArchivePath -Name $NonQualifierPath -ItemType "directory"

                $FolderCount = $FolderCount +1

               }
            catch {
                    Write-Host "Failed to create folder" $DestinationPath
                  }
             }
             else
                {
                Write-Host "Folder" $DestinationPath "already exists" -ForegroundColor Red
                }
      }

Write-Host ""
Write-Host "Total Folders Created: $($FolderCount)" -ForegroundColor Green -BackgroundColor DarkGreen
Write-Host ""

#Beginning of file archiving
Write-Host "Files Moving to Archive..."
Write-Host ""

$FileCount = 0

$ArchivedCount = 0

#Importing Input File (specified in Parameter) and filtering to process any record that has value 'File' in column Type. Then all results are sorted by Source Path.
Import-Csv -Path $InputFile | Where-Object {($_.Type -eq "File") -and ($_.Status -ne "Error")} | Sort-Object $_.'Source Path' |
ForEach-Object {
                $NonQualifierPath = Split-Path -Path $_.'Source Path' -NoQualifier

                $SourcePath = $DriveLetter + $NonQualifierPath

                $DestinationFilePath = $ArchivePath + $NonQualifierPath

            try {

                Move-Item -Path $SourcePath -Destination $DestinationFilePath -PassThru -ErrorAction SilentlyContinue

                #if move command was successful
                if ($?)

                    {
                        $FileCount = $FileCount +1
                        
                        $ArchivedCount = $ArchivedCount +1

                        $ErrorOutput = ""

                        $ProcessTime = Get-Date -Format "MM/dd/yyyy HH:mm:ss"

                        Write-Host $($FileCount), $($_.Title), $(Get-Date -Format "MM/dd/yyyy HH:mm:ss"), $($SourcePath), $($DestinationFilePath) -Separator "`t" -ForegroundColor Green
                    }

                    #if move command was unsuccessful
                    else

                        {
                            $FileCount = $FileCount +1

                            $ProcessTime = Get-Date -Format "MM/dd/yyyy HH:mm:ss"

                            Write-Output "$($FileCount)|Error: $($Error[0])" `n | Out-File -FilePath $ErrorFileName -NoNewline -Append -Force

                            Write-Host $($FileCount), $($_.Title), $ProcessTime, "Error: $($Error[0])" -Separator "`t" -ForegroundColor Red
                        }

                }

            catch
                    {
                        throw "Exception: $($PSItem.ToString())"
                    }

            } | Select-Object -Property @{ n='File ID'; e={ $($FileCount+1)}}, @{ n='Timestamp'; e={ $($ProcessTime)}}, @{ n='File Name'; e='Name'}, @{ n='Source Path'; e={ $($SourcePath)}}, @{ n='Destination Path'; e='FullName'} | Export-Csv -Path $LogFileName -NoTypeInformation -Append -Force

Write-Host ""
Write-Host "Total Files Moved to Archive: $($ArchivedCount)" -ForegroundColor Green -BackgroundColor DarkGreen

#Append Error Output to Standard Output
if (Test-Path -Path $ErrorFileName -PathType Leaf)
    {
    $CaptureErrors = Get-Content -Path $ErrorFileName
    
    Add-Content -Path $LogFileName -Value $CaptureErrors
    
    Remove-Item $ErrorFileName
    }
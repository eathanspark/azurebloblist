$azStorageAccountName = "xxxxxx" # Name of your storage account 
$azStorageAccountKey = "xxxxxxx" # Access key for your storage account

$azContainerName = "xxxxxxxxxxx" # Container name to list your blobs
$outputfile = 'output.csv'       # CSV file for export list

$connectionContext = New-AzStorageContext -StorageAccountName $azStorageAccountName -StorageAccountKey $azStorageAccountKey
# Get a list of containers in a storage account

#Get-AzStorageContainer -Name $azContainerName -Context $connectionContext | Select Name  

# Get a list of blobs in a container 
$allblob = Get-AzStorageBlob -Container $azContainerName -Context $connectionContext 


$processrows = [System.Collections.ArrayList]@()


foreach ($item in $allblob)
{
   
 
        $filetype = ($item.Name.Split("."))[-1]
        #Get the File Size
        [long]$Length = $item.Length
 
        #Format the File size based on size
        If ($Length -ge 1TB) {
          $sz = "{0:N2} TB" -f ($Length / 1TB)
        }
        elseif ($Length -ge 1GB) { 
          $sz = "{0:N2} GB" -f ($Length / 1GB)
        }
        elseif ($Length -ge 1MB) {
          $sz = "{0:N2} MB" -f ($Length / 1MB)
        }
        elseif ($Length -ge 1KB) {
          $sz = "{0:N2} KB" -f ($Length / 1KB)
        }
        else {
          $sz = "$($Length) bytes"
        }
        
        $i = @{
            "Name" = $item.Name
            "FileType" = $filetype        
            "Size" = $sz
            "LastModified" = $item.LastModified
            "ContentType" = $item.ContentType
        }
        $newrow = New-Object Psobject -Property $i
        $processrows.Add($newrow)
    
}

$processrows | Export-Csv $outputfile -Append -Delimiter '|' -Force -NoTypeInformation
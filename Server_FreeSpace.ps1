# The output filename
$dstamp = get-date -format 'MMM-dd-yyyy-hh-mm-sstt'
$outputfile = ("Servers_DiskSpace_"+$dstamp+".txt")
echo $outputfile
Get-Date > $outputfile

# List of Servers 
$servs = @("MCKNSERV2","MCKNSERV3","MCKNSERV4","MCKNSERV5","MCKNSERV6","MCKNSERV7","MCKNSERV8","MCKNSERV9","MCKNSERV10")


foreach ($server in $servs) {
    if(Test-Connection -Cn $server -BufferSize 16 -Count 1 -ea 0 -quiet){
        echo "`t Disk Space For: $server" >> $outputfile
        Get-WmiObject win32_logicaldisk -computer $server | 
        select-object DeviceID, 
            @{Name="Total Size"; 
            Expression={-join ([Math]::Round($_.Size/1GB)," GB")}},@{Name="FreeSpace";
            Expression={-join ([Math]::Round($_.FreeSpace/1GB)," GB")}}, @{Name="PCTFreeSpace";
            Expression={-join ([Math]::Round($_.FreeSpace/$_.Size*100),"%")}} | 
        Format-Table >> $outputfile
        }
    else { echo "`t $server - Offline" >> $outputfile }
    }



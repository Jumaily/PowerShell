cls

# Get Modality name to view logs.
$Modality = Read-Host -Prompt 'Input Modality Names'
$Modality = $Modality.Trim()

# McKesson PACS Apps Servers
$servers = @("PrdRadMckApp01","PrdRadMckApp02","PrdRadMckApp03","PrdRadMckApp04","PrdRadMckApp05")

$logs = @("")
foreach ($server in $servers){
    # Make sure server is up
    if(Test-Connection -Cn $server -BufferSize 16 -Count 1 -ea 0 -quiet){
        $logs += Get-ChildItem "\\$server\i$\ali\site\log\igen_$Modality`_importer_*.log" | Sort -Property LastWriteTime | `
                   select @{Name="Server";Expression={$server}}, Name, LastWriteTime, @{Name="Kbytes";Expression={[Math]::Round($_.Length/1Kb)}}
        }
    else{ echo "Server: $server - Offline" }
    }


if($logs.Count -ge 2){
    # Display all logs after sort by last write time... 
    $logs = $logs | Sort LastWritetime
    foreach($a in $logs){ $a }

    $lserver = $logs[$logs.Count-2].Server
    $llogfile = $logs[$logs.Count-2].Name
    $ldate = $logs[$logs.Count-2].LastWriteTime.DateTime

    echo "`n`tModality: $Modality"
    echo "`tLast Server Used to Import: $lserver"
    echo "`tLast Logfile Write To: $llogfile"
    echo "`tTime/Date: $ldate"
    echo "`tPath to file: \\$lserver\i$\ali\site\log\$llogfile"

    echo "`n`nNOTE: If you want to read log file as imports coming in, copy and paste:"
    echo "Get-Content \\$lserver\i$\ali\site\log\$llogfile -Wait"
    }
else{ echo "Could not locate logs for the modality: $Modality" }

exit

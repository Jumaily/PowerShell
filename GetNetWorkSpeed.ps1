echo (get-date)`n > 'WorkStationSpeeds.txt'

# this function is to get Host's speed
function getspeed($hostname){
  Get-WmiObject -ComputerName $hostname -Class Win32_NetworkAdapter |
    Where-Object { $_.Speed -ne $null -and $_.MACAddress -ne $null } |
    Format-Table -Property NetConnectionID, @{Label="$hostname (MB)"; Expression = {[math]::truncate($_.Speed/1000000)}}
  }


# Create hosts list of Online Server/Workstations & Speed
$basename='MCKNWKS'
for($i=0;$i -le 5; $i++){
  $n = $basename+$i

  # Check if Host is online
  if(Test-Connection -Cn $n -BufferSize 16 -Count 1 -ea 0 -quiet){
    echo "$n - Online"

    # If so, grab the network speed
    echo ("* Getting Network Information for: $n") >> 'WorkStationSpeeds.txt'
    getspeed $n >> 'WorkStationSpeeds.txt'
    }
  else {echo "$n - Offline" }
  }

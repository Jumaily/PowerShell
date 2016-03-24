echo (get-date) > 'WorkStationSpeeds.txt'

# this function is to get Host's speed
function getspeed($hostname){
  Get-WmiObject -ComputerName $hostname -Class Win32_NetworkAdapter |
    Where-Object { $_.Speed -ne $null -and $_.MACAddress -ne $null } |
    Format-Table -Property NetConnectionID, @{Label="$hostname (MB)"; Expression = {[math]::truncate($_.Speed/1000000)}}
  }


# Create hosts list of Online Server/Workstations
$basename='MCKNWKS'
$hosts=@()
for($i=0;$i -le 125; $i++){
  $n = $basename+$i
  if(Test-Connection -Cn $n -BufferSize 16 -Count 1 -ea 0 -quiet){
    $hosts+=$n
    echo "$n - Online"
    }
  else {echo "$n - Offline" }
  }


# Get Speed for each Host on line
Foreach($h in $hosts){
  getspeed $h >> 'WorkStationSpeeds.txt' - Append
  echo "Getting speed of $h"
  }

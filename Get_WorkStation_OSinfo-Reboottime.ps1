$outputfile = "WorkStation_OSinfo.txt"

echo (get-date)`n > $outputfile

# this function is to get Workstation OS version & last reboot time
function GetOSinfo($hostname){
  Get-WMIObject Win32_OperatingSystem -ComputerName $hostname |
  select-object CSName, Caption, @{LABEL='LastBootUpTime';EXPRESSION={$_.ConverttoDateTime($_.lastbootuptime)}}
  }


# Create hosts list of Online Server/Workstations & run the above function
$basename='MCKNWKS'
for($i=0;$i -le 125; $i++){
  $n = $basename+$i

  # Check if Host is online
  if(Test-Connection -Cn $n -BufferSize 16 -Count 1 -ea 0 -quiet){
    echo "$n - Online"

    # If so, Get OS info/Last Reboot time
    GetOSinfo $n >> $outputfile
    }
  else {
    echo "$n - Offline"
    echo `n "* $n - Offline" >> $outputfile
    }
  }

# the out put file
$outputfile = "WorkStation_OS_info.csv"

# this function is to get Workstation OS version & other information
function GetOSinfo($hostname){
  $computerNetSpeed = Get-WmiObject Win32_NetworkAdapter -ComputerName $hostname |
                       Where-Object { $_.Speed -ne $null -and $_.MACAddress -ne $null }

  $computerSystem = get-wmiobject Win32_ComputerSystem -Computer $hostname
  $computerBIOS = get-wmiobject Win32_BIOS -Computer $hostname
  $computerOS = get-wmiobject Win32_OperatingSystem -Computer $hostname
  $computerCPU = get-wmiobject Win32_Processor -Computer $hostname

  #Build the CSV file
  $WorkstationInfo = New-Object PSObject @{
      'PCName' = $computerSystem.Name
      'Manufacturer' = $computerSystem.Manufacturer
      'Model' = $computerSystem.Model
      'SerialNumber' = $computerBIOS.SerialNumber
      'RAM' = "{0:N2}" -f ($computerSystem.TotalPhysicalMemory/1GB)
      'CPU' = $computerCPU.Name
      'OS' = $computerOS.caption
      'SP' = $computerOS.ServicePackMajorVersion
      'User' = $computerSystem.UserName
      'BootTime' = $computerOS.ConvertToDateTime($computerOS.LastBootUpTime)
      'NetSpeed' = ([math]::truncate($computerNetSpeed.Speed/1000000))
      }

    # Return Array w\ information
    return $WorkstationInfo
  }


# Create information list from the above function
#$header = @('PCName', 'OS', 'Manufacturer', 'Model', 'SerialNumber', 'RAM (GB)', 'CPU', 'Last Login', 'Uptime Since', 'NetSpeed (MB)') -encoding ASCII
$header = 'PCName,OS,Manufacturer,Model,SerialNumber,RAM (GB),CPU,Last Login,Uptime Since,NetSpeed (MB)'
$header | set-content $outputfile


$basename='MCKNWKS'
for($i=0;$i -le 125; $i++){
  $n = $basename+$i

  # Check if Host is online
  if(Test-Connection -Cn $n -BufferSize 16 -Count 1 -ea 0 -quiet){
    echo "$n - Online"

    # If so, Get OS info/Last Reboot time
    $v = GetOSinfo $n
    $c = $v["PCName"]+","+$v["OS"]+","+$v["Manufacturer"]+","+$v["Model"]+","+$v["SerialNumber"]+","+
         $v["RAM"]+","+$v["CPU"]+","+$v["User"]+","+$v["BootTime"]+","+$v["NetSpeed"]

    # Append file output
    $c >> $outputfile
    }
  else {
    echo "$n - Offline"
    echo "$n (Off Line)" >> $outputfile
    }
  }

echo `n`n(get-date) >> $outputfile

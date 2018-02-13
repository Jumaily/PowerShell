$app1 = 'McKesson Radiology Station'
$app2 = 'McKesson Radiology Station Force Logoff'
$OutputFile = "Radio_App_Version.txt"

Get-Content .\WorkStations.txt | ForEach {
   echo "Getting info for $_ "
   $a = Get-WmiObject Win32_Product -Filter "Name='$app1'" -ComputerName $_
   $b = Get-WmiObject Win32_Product -Filter "Name='$app2'" -ComputerName $_
   echo "$_" >> $OutputFile
   $a >> $OutputFile
   $b >> $OutputFile
   }
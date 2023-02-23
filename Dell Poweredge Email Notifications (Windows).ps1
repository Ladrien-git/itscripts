#Creates directory path in C Drive
New-Item -Path c:\ITScripts -ItemType directory -Force 

#Move to directory
cd C:\ITScripts

#Creates script file in new directory for OMSA to call when an error occurs
New-Item -Name OMAlert.ps1 -ItemType file -Force -Value @'

param ([switch]$configure)

#initialize variables

$ScriptPath = "C:\ITScripts\OMAlert.ps1"
$Date = Get-Date
$Server = Get-Content env:computername
$EmailFrom = "example@example.com"
$EmailTo = "example@example.com"
$Subject = "Hardware Alert from $Server $Date"
$SMTPServer = "example.com"
$SmtpPort = "587"
$SMTPClient = New-Object Net.Mail.SmtpClient($SmtpServer, $SmtpPort)
$SMTPClient.EnableSsl = $true 
$SMTPClient.Credentials = New-Object System.Net.NetworkCredential("", "")

$Body=$args[0]

#If -configure is set, then modifies all OMSA event actions to email

if ($configure -eq $true) {

& omconfig system alertaction event=powersupply execappath="powershell $ScriptPath 'Power Supply Failure'"
& omconfig system alertaction event=powersupplywarn execappath="powershell $ScriptPath 'Power Supply Warning'"
& omconfig system alertaction event=tempwarn execappath="powershell $ScriptPath 'Temperature Warning'"
& omconfig system alertaction event=tempfail execappath="powershell $ScriptPath 'Temperature Failure'"
& omconfig system alertaction event=fanwarn execappath="powershell $ScriptPath 'Fan Warning'" 
& omconfig system alertaction event=fanfail execappath="powershell $ScriptPath 'Fan Failure'" 
& omconfig system alertaction event=voltwarn execappath="powershell $ScriptPath 'Voltage Warning'" 
& omconfig system alertaction event=voltfail execappath="powershell $ScriptPath 'Voltage Failure'" 
& omconfig system alertaction event=intrusion execappath="powershell $ScriptPath 'Chassis Intrusion Detected'" 
& omconfig system alertaction event=redundegrad execappath="powershell $ScriptPath 'System Redundancy Degraded'" 
& omconfig system alertaction event=redunlost execappath="powershell $ScriptPath 'System Redundancy Lost'"
& omconfig system alertaction event=memprefail execappath="powershell $ScriptPath 'Memory Pre-Fail'" 
& omconfig system alertaction event=memfail execappath="powershell $ScriptPath 'Memory Failure'"
& omconfig system alertaction event=processorwarn execappath="powershell $ScriptPath 'Processor Warning'" 
& omconfig system alertaction event=processorfail execappath="powershell $ScriptPath 'Processor Failure'"
& omconfig system alertaction event=watchdogasr execappath="powershell $ScriptPath 'Automatic System Recovery'" 
& omconfig system alertaction event=batteryfail execappath="powershell $ScriptPath 'Battery Failure'"
& omconfig system alertaction event=systempowerwarn execappath="powershell $ScriptPath 'System Power Warning'"
& omconfig system alertaction event=systempowerfail execappath="powershell $ScriptPath 'System Power Failure'" 
& omconfig system alertaction event=systempeakpower execappath="powershell $ScriptPath 'System Power'" 
& omconfig system alertaction event=storagesyswarn execappath="powershell $ScriptPath 'Storage Warning'" 
& omconfig system alertaction event=storagesysfail execappath="powershell $ScriptPath 'Storage Failure'" 
& omconfig system alertaction event=storagectrlwarn execappath="powershell $ScriptPath 'Storage Controller Warning'" 
& omconfig system alertaction event=storagectrlfail execappath="powershell $ScriptPath 'Storage Controller Failure'"  
& omconfig system alertaction event=pdiskfail execappath="powershell $ScriptPath 'Physical Disk Failure'" 
& omconfig system alertaction event=vdiskwarn execappath="powershell $ScriptPath 'Virtual Disk Warning'" 
& omconfig system alertaction event=vdiskfail execappath="powershell $ScriptPath 'Virtual Disk Failure'" 
& omconfig system alertaction event=enclosurewarn execappath="powershell $ScriptPath 'System Enclosure Warning'" 
& omconfig system alertaction event=enclosurefail execappath="powershell $ScriptPath 'System Enclosure Failure'"  
& omconfig system alertaction event=storagectrlbatteryfail execappath="powershell $ScriptPath 'RAID Battery'"
}

else{$SMTPClient.Send($EmailFrom, $EmailTo, $Subject, $Body)}
#end PS script
'@

#Run script that was just made to configure OMSA
.\OMAlert.ps1 -configure
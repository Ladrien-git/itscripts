#Creates directory path in C Drive
New-Item -Path c:\ITScripts -ItemType directory -Force 

#Move to directory
cd C:\ITScripts

#Creates script file in new directory for Hyper-V
New-Item -Name ReplicaNotifier.ps1 -ItemType file -Force -Value @'

$ServerName = Get-Content env:computername
$SMTPServer = "example@example.com"
$SMTPPort = "587"
$Username = "example@example.com"
$Password = ""
$to = "example@example.com"



#Checks to see if replication is in a warning or error state and sends an email accordingly
if ((Get-VMReplication | select-string -inputobject {$_.Health} -pattern "Warning") -like "Warning")
{

$subject = "Replica WARNING error on $ServerName"
$message = New-Object System.Net.Mail.MailMessage
$message.subject = $subject
$message.to.add($to)
$message.from = $username
$smtp = New-Object System.Net.Mail.SmtpClient($SMTPServer, $SMTPPort);
$smtp.EnableSSL = $true
$smtp.Credentials = New-Object System.Net.NetworkCredential($Username, $Password);
$smtp.send($message)
}
elseif ((Get-VMReplication | select-string -inputobject {$_.Health} -pattern "Critical") -like "Critical")
{
$subject = "Replica CRITICAL error on  $ServerName'@'$Company"
$message = New-Object System.Net.Mail.MailMessage
$message.subject = $subject
$message.to.add($to)
$message.from = $username
$smtp = New-Object System.Net.Mail.SmtpClient($SMTPServer, $SMTPPort);
$smtp.EnableSSL = $true
$smtp.Credentials = New-Object System.Net.NetworkCredential($Username, $Password);
$smtp.send($message)
}
'@

#Creating scheduled task
$action = New-ScheduledTaskAction -Execute 'C:\ITScripts\ReplicaNotifier.ps1'

$trigger = New-ScheduledTaskTrigger -Daily -At 4am

Register-ScheduledTask -Action $action -Trigger $trigger -Verbose -ErrorAction Stop -Description "This script checks for Hyper-V Replica's that are in Warning or Critical status. Upon finding any issue an email will be sent to $to." -TaskName 'Hyper-V Replica Notifier' -RunLevel Highest -User System
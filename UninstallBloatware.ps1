#/////////Remove Bloatware/////////

#List of apps to uninstall
$apps =  "Dell Digital Delivery","Express", "Dell Power", "Optimizer", "Dell Update", "Dell Per", "McAfee", "Microsoft 365 - es", "Microsoft 365 - fr", "Dell Pair"

#List of Microsoft Store apps to uninstall
$StoreApps = "delldig","dellpower", "DellOptimizer", "partner","bing","solitaire","skype","alexa", "dellpremier", "dellcust", "dellper", "Dell Pair","xboxapp", "xboxgameoverlay","xboxgamingoverlay", "xboxidentityprovider", "xboxspeech", "xbox.tcui", "microsoft.todos", "microsoft.people", "onenote", "gamingapp", "windowsmaps", "microsoft.wallet", "mydell", "MixedReality.Portal", "MicrosoftTeams", "Clipchamp"

function Uninstall-App 
{
  
  [CmdletBinding()]
    param (
    [Parameter(Mandatory)]$Program
    )

  #Appends wildcard symbols
  $program = "*" + $program + "*"
  
  #Gets registry entries for installed programs
  $Programs64 = Get-ChildItem "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall"
  $Programs32 = Get-ChildItem "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall"
  
  #Combines entries into 1 variable
  $AllPrograms = @($Programs64) + @($Programs32)
  
  #Looks in the registry to find the list of installed programs
  foreach($obj in $AllPrograms) 
  {
    $dname = $obj.GetValue("DisplayName")
    if ($dname -like $program) 
    {
      $uninstString = $obj.GetValue("UninstallString")
      foreach ($line in $uninstString) 
      {
        $found = $line -match '(\{.+\}).*'
        if ($found) 
        {
          switch -Wildcard ($dname)
          {
             '*Microsoft 365 - es*'
            {
              #Uninstalls the Spanish Microsoft365
              $argument = "scenario" + $uninstString.TrimStart('"C:\Program Files\Common Files\Microsoft Shared\ClickToRun\OfficeClickToRun.exe" ') + " DisplayLevel=False"
   
              Write-Output "Uninstalling Microsoft 365 - es"
              Start-Process "C:\Program Files\Common Files\Microsoft Shared\ClickToRun\OfficeClickToRun.exe" -ArgumentList $argument -Wait
              continue
            }
             '*Microsoft 365 - fr*'
            {
              #Uninstalls the French Microsoft365
              $argument = "scenario" + $uninstString.TrimStart('"C:\Program Files\Common Files\Microsoft Shared\ClickToRun\OfficeClickToRun.exe" ') + " DisplayLevel=False"
         
              Write-Output "Uninstalling Microsoft 365 - fr"
              Start-Process "C:\Program Files\Common Files\Microsoft Shared\ClickToRun\OfficeClickToRun.exe" -ArgumentList $argument -Wait
              continue
            }
             '*.exe*'
            {
              Write-Output "Uninstalling $($program)"
              $appid = $matches[1]
              Write-Output $appid
        
              $uninstall = $uninstString.TrimEnd("/","u","n","i","n","s","t","a","l").Trim().Trim('"')
              Start-Process -FilePath $uninstall -ArgumentList "/uninstall /s" -Wait
              continue
            }
            default
            {
              #Uninstalls the program using the .msi method
              Write-Output "Uninstalling $($program)"
              $appid = $matches[1]
              Write-Output $appid
              Start-Process "msiexec.exe" -ArgumentList "/X $appid /qn /norestart" , PASSWORD="INSERTPASSWORDHERE" -Wait
              continue
            }
          }    
        }
      }
    }
  }
}

foreach ($a in $apps)
{

Uninstall-App -Program $a

}


#Obtains information for all provisioned packages on the workstation
$Packages = Get-AppxProvisionedPackage -online

#Removes packages including ones that install for new users
foreach ($obj in $StoreApps)
{
  $obj = "*" + $obj + "*"
  
  foreach ($p in $Packages)
  {
    if ($p.DisplayName -like $obj)
    {
      Write-Output "Removing $obj"
      Remove-AppxProvisionedPackage -Online -PackageName $p.PackageName -AllUsers | Out-Host
    }
  }
}

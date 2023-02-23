Add-WindowsCapability -Online -Name ServerCore.AppCompatibility~~~~0.0.1.0

Install-WindowsFeature WOW64-Support

netsh firewall set service fileandprint enable
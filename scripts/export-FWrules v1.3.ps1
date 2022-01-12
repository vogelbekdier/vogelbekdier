param(

    [Parameter(Mandatory = $false)]
    [String]$server



)



write-host "This script is useful for reading the Windows Firewall rules on a Remote computer." -foregroundcolor Cyan
write-host "Author: Eric Vogel" -foregroundcolor Cyan
write-host ""



$teller = 0

Try {
    Write-host "Reading FW rules of server: $server, $env:COMPUTERNAME" -ForegroundColor Green
    $rules = Get-NetFirewallRule | ? { $_.DisplayName -like "*" } 

    Write-Host "total found:" 
    $rules.Count

    Write-host "Name;Displayname;Protocol;Profile;Direction;EdgeTraversalPolicy;localport;remoteport;action"

    foreach ($rule in $rules) {

        $teller++
        $name = $rule.name
        $disp = $rule.displayname
        $action = $rule.action
        $Profile = $rule.Profile
        $direction = $rule.direction
        $EdgeTraversalPolicy = $rule.EdgeTraversalPolicy
        $protocol = ($rule | Get-NetFirewallPortFilter).Protocol
        $remoteport = ($rule | Get-NetFirewallPortFilter).Remoteport
        $localport = ($rule | Get-NetFirewallPortFilter).LocalPort

        Write-Host "$name;$disp;$protocol;$Profile;$direction;$EdgeTraversalPolicy;$localport;$remoteport;$action" -ForegroundColor Yellow

    }

    Start-Sleep 3


}
catch {
    Write-warning "Unable to connect to remote server $server."
    ($Error[1].InvocationInfo).InvocationName
    $Error[0].Exception.Message
    exit
}




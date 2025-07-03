[System.Console]::WindowHeight = 30
[System.Console]::WindowWidth = 70


<#
$loopvar = "n"

do {
if ($loopvar -eq 'y') {	
	$loopvar = read-host "Would you like to process another request? [y or n]"
} else {
$loopvar = "y"
}


if ($loopvar -eq 'y') {
#>
clear-host



$portsArray = @()

# Query TCP
$getTCP = Get-NetTCPConnection | Select-Object LocalAddress, LocalPort, OwningProcess, @{name="TCPUDP";expression={"TCP"}}


# Query UDP
$getUDP = Get-NetUDPEndpoint | Select-Object LocalAddress, LocalPort, OwningProcess, @{name="TCPUDP";expression={"UDP"}}


$portsArray += $getTCP
$portsArray += $getUDP

if (test-path "$env:temp/ports.txt") {remove-item "$env:temp/ports.txt"}
if (test-path "$env:temp/importlist.txt") {remove-item "$env:temp/importlist.txt"}

$portsArray | select LocalPort, OwningProcess, TCPUDP | sort LocalPort -unique | Out-File $env:temp/ports.txt
$portsArray | select LocalPort | sort LocalPort -unique | Out-File $env:temp/portsonly.txt

$userchoice = read-host "Would you like to lookup one port number or a list? [1, list]?"

if ($userchoice -eq "list") {
	#if (-not(test-path "$env:userprofile/desktop/list.txt")) {
		start-process $env:temp/portsonly.txt
		new-item $env:temp/importlist.txt > $null
		start-process $env:temp/importlist.txt -wait
		$importports = get-content $env:temp/importlist.txt
#}
}

if ($userchoice -eq "1") {
start-process $env:temp/ports.txt
$portnum = read-host "What is the port number to lookup?"
write-host "`n`n"
}


if ($userchoice -eq "list") {
start-transcript > $null
foreach ($prt in $importports) {
$finalSearchVar = $portsArray | select LocalPort, OwningProcess | sort LocalPort -unique | where-object {$_.LocalPort -eq $prt}

if ($finalSearchVar -ne $null) {
write-host "";write-host "";write-host ""
write-host "results for $prt"
tasklist /svc /fi "pid eq $($finalSearchVar.OwningProcess)"
} else {
write-host "";write-host "";write-host ""
write-host "results for $prt"
write-host "nothing returned to look up"
}
}
}

if ($userchoice -eq "1") {
$finalSearchVar = $portsArray | select LocalPort, OwningProcess | sort LocalPort -unique | where-object {$_.LocalPort -eq $portnum}


if ($finalSearchVar -ne $null) {
write-host "results for $portnum"
tasklist /svc /fi "pid eq $($finalSearchVar.OwningProcess)"

} else {
write-host "results for $portnum"
write-host "nothing returned to look up"
}
}



if ($userchoice -eq "list") {
stop-transcript > $null
start-process "$env:userprofile/Documents"
}

<#
}
} until ($loopvar -eq 'n')
#>

write-host "`n`n`n"
write-host "Done. Closing script."
start-sleep 10

<# This PS script is based on these old CMD tools:
netstat -ano | findstr :<port number>
tasklist /svc /fi "pid eq <PID # from port number result>"
#>


#blank line

#Requires -RunAsAdministrator
<#
.SYNOPSIS
	List all running SQL services, saves a list of them, then stops and disables startup 
.DESCRIPTION
	Saves list of running SQL services to .\running-SQL.csv
.NOTES
	Author: Nicolas Redfern
	Date: 2026-04-30
	Version: 1.0
	No AI was used in the creation of this script.
.LINK
	Use Enable-SQL.ps1 to re-enable SQL services
#>
"_____________________________________________________________________"
$SQL_services = Get-Service *SQL*
"SQL services on "+$env:COMPUTERNAME

$SQL_services
$running_SQL_services = $SQL_services | Where-Object Status -eq 'running'
$number_to_stop = $running_SQL_services.count

if ($number_to_stop -eq 0){
	"NO SQL SERVICES TO STOP. Were they already stopped?"
} elseif ($number_to_stop -In 1..20){
	
	""
	Write-Host("Would you like to disable the following " + $number_to_stop + " running services")
	$running_SQL_services
	$confirmation = Read-Host("(y/N)?")

	if ($confirmation -eq 'y'){
		$running_SQL_services| Export-Csv .\running-SQL.csv
		"Disabling SQL services:"
		Get-Service -Name $running_SQL_services.Name | Stop-Service -Force -PassThru
		Get-Service -Name $running_SQL_services.Name | Set-Service -StartupType Disabled
	} else {
		"No action taken"
	}
} else {
	"TOO MANY SERVICES, either something went wrong or server has vast number of instances. Double check services to be stopped and count, and manually change the -In 1.20 line if larger range required"
}

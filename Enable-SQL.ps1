#Requires -RunAsAdministrator
<#
.SYNOPSIS
	Starts and enables automatic startup for previously stopped SQL services.
.DESCRIPTION
	Uses list from .\running-SQL.csv
.NOTES
	Author: Nicolas Redfern
	Date: 2026-04-30
	Version: 1.0
	No AI was used in the creation of this script.
.LINK
	Use Disable-SQL.ps1 to disable SQL services
#>
"_____________________________________________________________________`n"
$SQL_services = Get-Service *SQL*
"SQL services on "+$env:COMPUTERNAME
$SQL_services

$previous_SQL_services = Import-Csv -Path ".\running-SQL.csv"

$number_to_start=$previous_SQL_services.Name.count
if ($number_to_start -eq 0){
	"NO SERVICES TO START"
}elseif ($number_to_start -In 1..20){
	Write-Host("Would you like to enable the previous " + $number_to_start + " running services")
	$previous_SQL_services.Name
	$confirmation = Read-Host("(y/N)?")

	if ($confirmation -eq 'y'){
		"Enabling previously running SQL services:"
		Get-Service -Name $previous_SQL_services.Name | Set-Service -StartupType Automatic
		Get-Service -Name $previous_SQL_services.Name | Start-Service -PassThru
		"SQL services enabled."
	} else {
		"No action taken"
	}
}else {
	"TOO MANY SERVICES, either something went wrong or server has vast number of instances. Double check services to be stopped and count, and manually change the -In 1.20 line if larger range required"
}

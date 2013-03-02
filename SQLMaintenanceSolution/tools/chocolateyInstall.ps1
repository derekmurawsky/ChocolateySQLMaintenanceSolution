$packageName = 'SQLMaintenanceSolution'
$url = 'http://ola.hallengren.com/scripts/MaintenanceSolution.sql'
$FileName = 'MaintenanceSolution.sql'
$url64 = $url

try {
	# Tests  
	if ((Get-Service MSSQLSERVER).status -ne "Running") {
    	Write-ChocolateyFailure "$packageName" "SQL Server not started"
  		throw
	}
	if ((Get-Service SQLSERVERAGENT).status -ne "Running"){
    	Write-ChocolateyFailure "$packageName" "SQL Server Agent not started"
  		throw
	}
	if ( (Get-PSSnapin -Name sqlserverprovidersnapin100 -ErrorAction SilentlyContinue) -eq $null ){
		try {
			Add-PsSnapin sqlserverprovidersnapin100
		} catch {
			Write-ChocolateyFailure "$packageName" "$($_.Exception.Message)"
			throw
		}
	}
	if ( (Get-PSSnapin -Name sqlservercmdletsnapin100 -ErrorAction SilentlyContinue) -eq $null ){
		try {
			Add-PsSnapin sqlservercmdletsnapin100
		} catch {
			Write-ChocolateyFailure "$packageName" "$($_.Exception.Message)"
			throw
		}
	}
	# If tests passed, initialize path, download, and install. 
	$scriptPath = $(Split-Path $MyInvocation.MyCommand.Path)
	$nodePath = Join-Path $scriptPath $FileName
	Get-ChocolateyWebFile "$packageName" "$nodePath" "$url" "$url64"

	invoke-sqlcmd -InputFile "$nodePath"

	Write-ChocolateySuccess "$packageName"
} catch {
	Write-ChocolateyFailure "$packageName" "$($_.Exception.Message)"
	throw 
}
$packageName = 'SQLMaintenanceSolution'
$url = 'http://ola.hallengren.com/scripts/MaintenanceSolution.sql'
$FileName = 'MaintenanceSolution.sql'
$url64 = $url

try { #error handling is only necessary if you need to do anything in addition to/instead of the main helpers
  # other helpers - using any of these means you want to uncomment the error handling up top and at bottom.
  # downloader that the main helpers use to download items
  $scriptPath = $(Split-Path $MyInvocation.MyCommand.Path)
  $nodePath = Join-Path $scriptPath $FileName
  Get-ChocolateyWebFile "$packageName" "$nodePath" "$url" "$url64"
  
  # Test if SQL server is running
  if ((Get-Service MSSQLSERVER).status -ne "Running") {
    Write-ChocolateyFailure "$packageName" "SQL Server not started"
  	throw
  }
  if ((Get-Service SQLSERVERAGENT).status -ne "Running"){
    Write-ChocolateyFailure "$packageName" "SQL Server Agent not started"
  	throw
  }
 
	invoke-sqlcmd -InputFile "$nodePath"

  # the following is all part of error handling
  Write-ChocolateySuccess "$packageName"
} catch {
  Write-ChocolateyFailure "$packageName" "$($_.Exception.Message)"
  throw 
}
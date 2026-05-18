Write-Host '=== Services ==='
Get-Service | Where-Object { $_.Name -match 'Oracle' -or $_.DisplayName -match 'Oracle' } | Select Name,Status,DisplayName | Format-Table -AutoSize

Write-Host '=== Env ==='
Write-Host "ORACLE_HOME: $env:ORACLE_HOME"
Write-Host "ORACLE_SID: $env:ORACLE_SID"
Write-Host "PATH contains oracle? " + ($env:PATH -match 'oracle')

Write-Host '=== Commands ==='
Get-Command sqlplus, lsnrctl, tnsping -ErrorAction SilentlyContinue | Select Name,Source,Version | Format-Table -AutoSize

Write-Host '=== where ==='
foreach ($c in @('sqlplus','lsnrctl','tnsping')) {
  try { Write-Host ($c + ': ' + (where.exe $c -ErrorAction Stop | Out-String)) } catch { Write-Host ($c + ': not found') }
}

Write-Host '=== Registry x64 ==='
Get-ChildItem HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall -Recurse | Get-ItemProperty -ErrorAction SilentlyContinue | Where-Object { $_.DisplayName -like '*Oracle*' } | Select DisplayName, DisplayVersion | Format-Table -AutoSize

Write-Host '=== Registry Wow6432Node ==='
Get-ChildItem HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall -Recurse | Get-ItemProperty -ErrorAction SilentlyContinue | Where-Object { $_.DisplayName -like '*Oracle*' } | Select DisplayName, DisplayVersion | Format-Table -AutoSize

Write-Host '=== ORACLE registry keys ==='
Get-ChildItem HKLM:\SOFTWARE\ORACLE -ErrorAction SilentlyContinue | Format-List
Get-ChildItem HKLM:\SOFTWARE\Wow6432Node\ORACLE -ErrorAction SilentlyContinue | Format-List

Write-Host '=== Listener status ==='
if (Get-Command lsnrctl -ErrorAction SilentlyContinue) { lsnrctl status } else { Write-Host 'lsnrctl not found in PATH' }

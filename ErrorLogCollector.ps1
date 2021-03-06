
$date = (get-date).Addhours(-24)
$root = "D:\LogCollector\"
$configFile = ($root + "conf\server.csv")
$serverArray = Import-CSV "$configFile"

$report = ($root + "reports_" + $(Get-Date -f yyyyMMdd_HHmmss) + ".htm")
#Clear-Content $report

 Add-Content $report "<html>"
 Add-Content $report "<head>"
 Add-Content $report "<meta http-equiv='Content-Type' content='text/html; charset=iso-8859-1'>"
 Add-Content $report '<title>Error Log Report for Server</title>'
 add-content $report '<STYLE TYPE="text/css">'
 add-content $report "<!--"
 add-content $report "td {"
 add-content $report "font-family: Tahoma;"
 add-content $report "font-size: 11px;"
 add-content $report "border-top: 1px solid #999999;"
 add-content $report "border-right: 1px solid #999999;"
 add-content $report "border-bottom: 1px solid #999999;"
 add-content $report "border-left: 1px solid #999999;"
 add-content $report "padding-top: 0px;"
 add-content $report "padding-right: 0px;"
 add-content $report "padding-bottom: 0px;"
 add-content $report "padding-left: 0px;"
 add-content $report "}"
 add-content $report "body {"
 add-content $report "margin-left: 5px;"
 add-content $report "margin-top: 5px;"
 add-content $report "margin-right: 0px;"
 add-content $report "margin-bottom: 10px;"
 add-content $report ""
 add-content $report "table {"
 add-content $report "border: thin solid #000000;"
 add-content $report "}"
 add-content $report "-->"
 add-content $report "</style>"
 Add-Content $report "</head>"
 Add-Content $report "<body>"
	
# Write error log to file
foreach ($server in $serverArray) {
	$systemName = $server.System
	$serverName = $server.Name
	$PATH = "\\" + $server.Name + "\" + $server.Path

 	$progress = "."
    

 	add-content $report "<table width='100%'>"
 	add-content $report "<tr bgcolor='#CCCCCC'>"
 	add-content $report "<td colspan='7' height='25' align='center'>"
 	add-content $report "<font face='tahoma' color='#003399' size='4'><strong>Error Logs Collection From $systemName Server <a href='$PATH'>$serverName</a></strong></font>"
 	add-content $report "</td>"
 	add-content $report "</tr>"
 	add-content $report "</table>"

 	add-content $report "<table width='100%'>"
 	Add-Content $report "<tr bgcolor=#CCCCCC>"
 	Add-Content $report "<td width='95%' align='center'>Message</td>"	
 	Add-Content $report "</tr>"

  
  	write-host "`n`nCollection Error Logs from Computer $serverName" -foregroundcolor yellow -backgroundcolor black
  

	# Log parsing
	$logs = Get-ChildItem -Path $PATH -Recurse | ? {$_.LastWriteTime -ge $date} | 
								Select-String -Pattern 'ERROR|failed|deadlock|timeout' |
								Foreach-Object {$_.Line +'<br>'}

    # Highlight keyword
	$logs = $logs -replace "deadlock", "<font color=red>deadlock</font>"
	$logs = $logs -replace "timeout", "<font color=red>timeout</font>"
	
	
	Write-host "Processing" -foregroundcolor yellow -backgroundcolor black

  	Add-Content $report "<tr>"
  	Add-Content $report "<td>$logs</td>"
  	Add-Content $report "</tr>"


	Add-content $report "</table>"

}

Add-Content $report "</body>"
Add-Content $report "</html>"



## Send Email
$smtp = "SMTP_Server"
$to = "test@test.com"
$from = "test@test.com"
$subject = "Event Log Report for Production Server" 

$reportData = Get-Content $report
$body= ""
foreach ($line in $reportData)
{
    $body +=  $line
}

#### Now send the email using \> Send-MailMessage 
send-MailMessage -SmtpServer $smtp -To $to -From $from -Subject $subject -Body $body -BodyAsHtml


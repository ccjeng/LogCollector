# Error Log Collector 
This tool is only for Windows platform.

Language:PowerShell

##  Introduction
Parse error keyword on log files form multiple Windows servers, and send out html format error report.
You can define keyword on script file, define server and log file path on \conf\server.csv

server configuration file: \conf\server.csv

## Prerequest
- Domain service account which has read access promission on target servers' log folder.
- Domain service account should access target servers' log folder on network via \\\server\\log.

## Server configuration file
- Location: \conf\server.csv
- Format: server name, the full path of server log folder

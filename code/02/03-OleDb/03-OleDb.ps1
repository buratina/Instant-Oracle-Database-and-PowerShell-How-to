# System.Data is loaded by default in PowerShell so there is nothing to load.

$conn = New-Object System.Data.OleDb.OleDbConnection
"Created empty connection object. State is {0}" -f $conn.State

# See http://sev17.com/2010/03/querying-oracle-from-powershell-part-2/ for more information on using OLE DB
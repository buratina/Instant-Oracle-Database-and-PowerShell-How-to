[System.Reflection.Assembly]::Load("System.Data.OracleClient, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089")
$conn = New-Object System.Data.OracleClient.OracleConnection
"Created empty connection object. State is {0}" -f $conn.State

# See http://tiredblogger.wordpress.com/2009/09/01/querying-oracle-using-powershell/ for more information on using System.Data.OracleClient
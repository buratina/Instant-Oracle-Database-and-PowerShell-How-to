[void][System.Reflection.Assembly]::Load("Oracle.DataAccess, Version=2.112.3.0, Culture=neutral, PublicKeyToken=89b483f429c47342")

function Connect-Oracle([string] $connectionString = $(throw "connectionString is required"))
{
    $conn= New-Object Oracle.DataAccess.Client.OracleConnection($connectionString)
    $conn.Open()    
    Write-Output $conn
}

function Get-ConnectionString($user, $pass, $hostName, $port, $sid)
{
    $dataSource = ("(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST={0})(PORT={1}))(CONNECT_DATA=(SERVICE_NAME={2})))" -f $hostName, $port, $sid)
    Write-Output ("Data Source={0};User Id={1};Password={2};Connection Timeout=10" -f $dataSource, $user, $pass)
}

$conn = Connect-Oracle (Get-ConnectionString HR pass localhost 1521 XE)
# TODO: use connection
"Connection state is {0}, Server Version is {1}" -f $conn.State, $conn.ServerVersion
$conn.Close()
"Connection state is {0}" -f $conn.State
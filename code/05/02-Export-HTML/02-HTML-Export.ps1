[void][System.Reflection.Assembly]::Load("Oracle.DataAccess, Version=2.112.3.0, Culture=neutral, PublicKeyToken=89b483f429c47342")

function Connect-Oracle([string] $connectionString = $(throw "connectionString is required"))
{
    $conn= New-Object Oracle.DataAccess.Client.OracleConnection($connectionString)
    $conn.Open()    
    Write-Output $conn
}

function Get-ConnectionString
{
    $dataSource = "(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=localhost)(PORT=1521))(CONNECT_DATA=(SERVICE_NAME=xe)))"
    Write-Output ("Data Source={0};User Id=HR;Password=pass;Connection Timeout=10" -f $dataSource)
}

function Get-DataTable 
{
Param(
    [Parameter(Mandatory=$true)]
    [Oracle.DataAccess.Client.OracleConnection]$conn, 
    [Parameter(Mandatory=$true)]
    [string]$sql
)
    $cmd = New-Object Oracle.DataAccess.Client.OracleCommand($sql,$conn)
    $da = New-Object Oracle.DataAccess.Client.OracleDataAdapter($cmd)
    $dt = New-Object System.Data.DataTable
    [void]$da.Fill($dt)    
    # Prevent unrolling enumerable with ",$dt" if you want a DataTable returned
    return ,$dt
}

function Get-ScriptDirectory
{ 
    if (Test-Path variable:\hostinvocation) 
    {
        $FullPath=$hostinvocation.MyCommand.Path
    }
    else
    {
        $FullPath=(get-variable myinvocation -scope script).value.Mycommand.Definition
    }
    if (Test-Path $FullPath)
    { 
        return (Split-Path $FullPath) 
    }
    else
    { 
        $FullPath=(Get-Location).path
        Write-Warning ("Get-ScriptDirectory: Powershell Host <" + $Host.name `
            + "> may not be compatible with this function, the current directory <" `
            + $FullPath + "> will be used.")
        return $FullPath
    }
}

$conn = Connect-Oracle (Get-ConnectionString)

$sql = @"
SELECT e.employee_id, 
       e.first_name || ' ' || e.last_name employee, 
       j.job_title, e.hire_date,
       m.first_name || ' ' || m.last_name manager 
FROM   employees e 
       JOIN jobs j 
         ON e.job_id = j.job_id 
       JOIN employees m 
         ON e.manager_id = m.employee_id
"@

$dt = Get-DataTable $conn $sql
$conn.Close()

$filename = join-path (Get-ScriptDirectory) Employees.html
if (Test-Path($filename)) {Remove-Item $filename -force}

$head = @"
<style>
table { font-family: "Lucida Sans Unicode", "Lucida Grande", Sans-Serif;
    font-size: 12px; background: #fff; margin: 45px; border-collapse: collapse;
	text-align: left; }
th { font-size: 14px; font-weight: normal; color: #039; padding: 10px 8px;
	border-bottom: 2px solid #6678b1; }
td { border-bottom: 1px solid #ccc; color: #669; padding: 6px 8px; }
tbody tr:hover td { color: #009; }
</style>
"@

$dt | ConvertTo-HTML -head $head `
    -Property employee_id, employee, job_title, hire_date, manager `
    | Out-File $filename
Invoke-Item $filename

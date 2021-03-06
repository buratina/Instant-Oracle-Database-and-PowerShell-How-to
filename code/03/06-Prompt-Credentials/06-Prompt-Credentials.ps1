function Get-Password
{
    $securePass = Read-Host "Enter Password" -AsSecureString
    $bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($securePass)
    $pass = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr)
    [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr)
    return $pass
}

$user = read-host "Enter username"
$pass = Get-Password
$connectString = "Data Source=LOCALDEV;User Id={0};Password={1};Connection Timeout=10" -f $user, $pass
Write-Output $connectString
$Name = "tristorm"
$User = Get-ADUser -LDAPFilter "(sAMAccountName=$Name)"
If ($User -eq $Null) {"User does not exist in AD"}
Else {"User found in AD"}
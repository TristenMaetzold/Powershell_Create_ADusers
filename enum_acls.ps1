# Targets current directory
$directory = $PSScriptRoot

# Goes through every entry
foreach ($item in $directory) {
Get-ChildItem 
Get-Acl 
}
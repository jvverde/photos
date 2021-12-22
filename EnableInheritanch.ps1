param (
	[Parameter(Mandatory)]$dir,
	$action=$True
)
$isProtected = !$action
$allFolders=Get-ChildItem -Path "$dir" -Directory -Recurse
foreach ($Folder in $allFolders){
	$Permission=get-acl -Path $Folder.FullName
	$Permission.SetAccessRuleProtection($isProtected,$True)
	Set-Acl -Path $Folder.FullName -AclObject $Permission
}
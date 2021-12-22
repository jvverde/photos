param (
	[Parameter(Mandatory)]$dir
)
$Folders=Get-ChildItem -Path "$dir" -Recurse | where { $_.PSIsContainer -ne $false }
foreach ($Folder in $Folders) {
	$acl=Get-Acl -Path $Folder.FullName
    foreach ($access in $acl.access) { 
        if ($access.isinherited -eq $false) { 
            $acl.RemoveAccessRule($access) 
        }
    } 
    Set-Acl -path $Folder.fullname -aclObject $acl
}
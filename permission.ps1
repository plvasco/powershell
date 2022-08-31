<#

    fetch the SID user a user
    apply the SID to a particular folder in a windows Vm
    on that folder also remove inheritance and authenticated users

#>
#user input folder name
$dir = Read-Host "Enter a Directory path"

#check if user input is empty
if($dir.Length -eq 0){
    Write-Host "Directory name cannot be empty" -ForegroundColor Red
    break script
}

#check if directory exists
if (Test-Path "$dir"){
    
    #get logged in user name
    $username = $env:USERNAME

    #get SID of user
    $SID = ((get-aduser "$username"  -Properties * | select SID).SID).value

    #get ACL
    $acl = Get-Acl "$dir"
    # set Owner
    #$acl.SetOwner([System.Security.Principal.NTAccount] $env:USERNAME)

    #set inhertance to false
    $acl.SetAccessRuleProtection($true,$false)

    $sddl ="O:$SID"
    $acl.SetSecurityDescriptorSddlForm($sddl)

    $acl | Set-Acl $dir

}
else{
    Write-Host "Could not find '$dir'" -ForegroundColor Red
}
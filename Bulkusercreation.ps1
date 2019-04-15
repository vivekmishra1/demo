# Import active directory module for running AD cmdlets
Start-Transcript
Import-Module activedirectory
#below domain name will be used just for display purpose
$DomainName = test domain
#Store the data from ADUsers.csv in the $ADUsers variable
$ADUsers = Import-csv "path of .csv file"

#Loop through each row containing user details in the CSV file 
foreach ($User in $ADUsers)
{
	#Read user data from each field in each row and assign the data to a variable as below
		
	$Username = $User.username
	$OU = $User.ou #This field refers to the OU the user account is to be created in
    	$description = $User.description
	$email = $User.email
    	$Password = $User.password
	$AdGroup = $User.memberof
    	$AdGroup1 = $User.memberof1


	#Check to see if the user already exists in AD
	if (Get-ADUser -F {SamAccountName -eq $Username})
	{
		 #If user does exist, give a warning
		 Write-Warning "A user account with username $Username already exist in Active Directory."
	}
	else
	{
		#User does not exist then proceed to create the new user account
		
        #Account will be created in the OU provided by the $OU variable read from the CSV file
	New-ADUser `
            -SamAccountName $Username `
            -UserPrincipalName "$yourdomain.com" `
            -Name $Username `
            -GivenName $Username `
            -Enabled $True `
            -DisplayName $Username `
            -Description $description `
	    -EmailAddress $email `
            -AccountPassword (convertto-securestring $Password -AsPlainText -Force) `
            -Verbose
	        
            If ($AdGroup) 
            { 
                Add-ADGroupMember "$AdGroup" $Username -Verbose 
            } 
           
            If ($AdGroup1) 
            { 
                Add-ADGroupMember "$AdGroup1" $Username -Verbose 
            } 
            
	Write-Host "$DomainName domain user account for $Username has been created on $(Get-Date) and added it into $AdGroup $AdGroup1 AD Groups"
    }
}

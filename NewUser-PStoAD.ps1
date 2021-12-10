param(

    [Parameter(ValueFromPipeline=$true,HelpMessage="Enter CSV path(s)")]
    [String[]]$Path = $null
)

if($Path -eq $null) {

    Add-Type -AssemblyName System.Windows.Forms

    $Dialog = New-Object System.Windows.Forms.OpenFileDialog
    $Dialog.InitialDirectory = "$InitialDirectory"
    $Dialog.Title = "Select CSV File(s)"
    $Dialog.Filter = "CSV File(s)|*.csv"        
    $Dialog.Multiselect=$true
    $Result = $Dialog.ShowDialog()

    if($Result -eq 'OK') {

        Try {
    
            $Path = $Dialog.FileNames
        }

        Catch {

            $Path = $null
            Break
        }
    }

    else {

        #Shows upon cancellation of Save Menu
        Write-Host -ForegroundColor Yellow "Notice: No file(s) selected."
        Break
    }
}
$ADUsers = Import-Csv $Path
#Loop through each row containing user details in the CSV file 
foreach ($User in $ADUsers)
{
	#Read user data from each field in each row and assign the data to a variable as below
		
	$Username 	= $User.username
	$Password 	= $User.password
	$Firstname 	= $User.firstname
	$Lastname 	= $User.lastname
	$OU 		= $User.ou #This field refers to the OU the user account is to be created in
    	$email      = $User.email
	$streetaddress = $User.streetaddress
	$city       = $User.city
	$zipcode    = $User.zipcode
	$state      = $User.state
	$country    = $User.country
	$telephone  = $User.telephone
	$jobtitle   = $User.jobtitle
    	$company    = $User.company
	$department = $User.department


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
            #Don’t forget to change the domain.
            -UserPrincipalName "$Username@domain.org" `
            -Name "$Firstname $Lastname" `
            -GivenName $Firstname `
            -Surname $Lastname `
            -Enabled $True `
            -DisplayName "$Lastname, $Firstname" `
            -Path $OU `
            -City $city `
            -Company $company `
            -State $state `
            -StreetAddress $streetaddress `
            -OfficePhone $telephone `
            -EmailAddress $email `
            -Title $jobtitle `
            -Department $department `
            #Change settings below to adhere to department policies.
            -AccountPassword (convertto-securestring $Password -AsPlainText -Force) -ChangePasswordAtLogon $False -CannotChangePassword $true -PasswordNeverExpires $true
            
	}
}
© 2021 GitHub, Inc.
Terms
Privacy
Security
Status
Docs
Contact GitHub
Pricing
API
Training
Blog
About

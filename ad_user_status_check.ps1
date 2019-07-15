$users = import-csv "C:\temp\Users_with_ITIL_05092019.csv"
$header = "User,Email,User_ID,Role,State,Ad_Status"
$header | Out-File "C:\temp\ad_user_status.csv" -Encoding utf8
$nouser_status = "NOTINAD"

# Checking process starts
Write-Host `n"status checking starts here:"`n
Write-Host "-----------------------------------------------------------------------------------------"`n 

foreach ($user in $users){
    try{
        $status = Get-ADUser $user.User_ID -Properties Enabled
        $output = "$($user.User),$($user.Email),$($user.User_ID),$($user.Role),$($user.State),$($status.Enabled)"
    }
    catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException]{
        Write-Host "The user $($user.User) -- user_id: $($user.User_ID) is not in Active Directory" `n
        $output = "$($user.User),$($user.Email),$($user.User_ID),$($user.Role),$($user.State),$($nouser_status)"
    }
    catch {
        "An error occurred that could not be resolved."
    }   
     
    finally {
        $output | Out-FIle "C:\temp\ad_user_status.csv" -Encoding utf8 -Append
    }
}

# Script Completed
Write-Host "-----------------------------------------------------------------------------------------"`n 
Write-Host "status checking finished"`n


Add-Type -AssemblyName System.Web

# Tenant and Application Information 
$tenant_id ='2389e607-63ba-4c1e-b798-51fd9a24a113'
$client_id = 'e3aac8ac-0e5f-48e2-b316-f4b6a0cac5f7'
$client_Secret = 'nvlxMS9?]vxpYBRFV4085|_'
$URLEncodedSecret = [System.Web.HttpUtility]::UrlEncode($client_Secret)

# Resource - Microsoft Graph API
$resource = 'https://graph.microsoft.com'

# Authority and Token Endpoint
$authority = 'https://login.microsoftonline.com/' + $tenant_id
$tokenEndpointUri = $authority + '/oauth2/token'

# Build out the content for the request body
$content = 'grant_type=client_credentials&client_id=' + $client_id + '&client_secret=' + $URLEncodedSecret + '&resource=' + $resource

# Execute the request and retrieve a response
$response = Invoke-WebRequest -Uri $tokenEndpointUri -Body $content -Method Post -UseBasicParsing

# Execute the request and retrieve a response
#$response = Invoke-WebRequest -Uri $tokenEndpointUri -Body $content -Method Post -UseBasicParsing

# Convert the response to JSON Format
$responseBody = $response.Content | ConvertFrom-JSON

# If you want to see the JSON results, uncomment the next line
#$responseBody

# Retrieve the access token from the response
$access_token = $responseBody.access_token

# If you want to see the access token, uncommment the next line
#$access_token

# $users = Import-Csv -Path "C:\Users\A-wut6\Desktop\azure_guest_users.csv" 
#$users = Import-Csv -Path "C:\temp\azure_guest_users.csv" 

# Test the access token to see if it can retrieve users
$Uri = 'https://graph.microsoft.com/beta/users?' + '$' + "filter=externalUserState eq 'Accepted'"
$headers = @{'Authorization' = 'Bearer ' + $access_token}
$params = @{
Uri = $Uri
Headers = $headers
ContentType = 'application/json'
Method = 'GET'}
    
#Invoke-RestMethod @params | Format-List
$result = Invoke-RestMethod @params
 
# If you want to see the results from the user query, uncomment the next line
foreach ($val in $result)
{
    $counter = 0

    while ( $counter -lt $result.value.Count )
    {
        Write-Host $val.value[$counter].displayName
        Write-Host $val.value[$counter].userPrincipalName
        Write-Host $val.value[$counter].externalUserState
        Write-Host $val.value[$counter].externalUserStateChangeDateTime
        Write-Host "=================================================================="
        $counter++
    }
}

    

# Script completed
Write-Host "Finished!"

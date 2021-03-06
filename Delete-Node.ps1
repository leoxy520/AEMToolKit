function Delete-Node {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipelineByPropertyName = $True)]
        [String]
        $ServerName,

        [Parameter(ValueFromPipelineByPropertyName = $True)]
        [String]
        $Path
    )
        
    begin {
            
    }
        
    process {
        
        $server = $aemEnv | Where-Object -Property name -Value $ServerName -eq

        if ($server -eq $null) {
            Write-Error -Message "ServerName $ServerName is not found."
            return;
        }
        
        $headers = @{
            Authorization  = Get-BasicAuthorizationValue -Username $server.username -Password $server.password;
            "Content-Type" = "application/x-www-form-urlencoded";
            "User-Agent"   = "curling"
        }
        
        $forms = @{ 
            ":operation" = "delete"
        };
        
        
        $obj = New-Object -TypeName psobject
        $obj | Add-Member -MemberType NoteProperty -Name ServerName -Value $ServerName
        $obj | Add-Member -MemberType NoteProperty -Name Path -Value $Path
        
        try {
            $url = $server.url
            $res = Invoke-WebRequest -Uri "$url$Path" -Method Post -Headers $headers -Body $forms
            $obj | Add-Member -MemberType NoteProperty -Name Deletd -Value $True
        }
        catch {
            $obj | Add-Member -MemberType NoteProperty -Name Deletd -Value $False
        }
        
        Write-Output $obj
    }
        
    end {
    }
}   

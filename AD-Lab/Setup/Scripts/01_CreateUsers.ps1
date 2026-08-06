Import-Module ActiveDirectory

$Password = ConvertTo-SecureString "P@ssw0rd123!" -AsPlainText -Force

$Users = @(
    @{Name="Terry Colby"; Sam="tcolby"},
    @{Name="Elliot Alderson"; Sam="elliot"},
    @{Name="Angela Moss"; Sam="angela"},
    @{Name="Philip Price"; Sam="pprice"},
    @{Name="Susan Jacobs"; Sam="sjacobs"},
    @{Name="Darlene Alderson"; Sam="darlene"},
    @{Name="Cisco Ramirez"; Sam="cramirez"},
    @{Name="Leon"; Sam="leon"},
    @{Name="Web Service"; Sam="WebService"},
    @{Name="Backup Service"; Sam="BackupSvc"},
    @{Name="Jenkins Service"; Sam="JenkinsSvc"}
)

foreach ($User in $Users)
{
    if (-not (Get-ADUser -Filter "SamAccountName -eq '$($User.Sam)'" -ErrorAction SilentlyContinue))
    {
        New-ADUser `
            -Name $User.Name `
            -SamAccountName $User.Sam `
            -UserPrincipalName "$($User.Sam)@evil.corp" `
            -AccountPassword $Password `
            -Enabled $true `
            -ChangePasswordAtLogon $false

        Write-Host "[+] Created $($User.Sam)" -ForegroundColor Green
    }
    else
    {
        Write-Host "[=] $($User.Sam) already exists" -ForegroundColor Yellow
    }
}

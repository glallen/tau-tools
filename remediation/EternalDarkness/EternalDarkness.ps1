<#
.SYNOPSIS
    This detects and mitigates if systems are vulnerable to CVE-2020-0796 EternalDarkness

.DESCRIPTION
    This Module will check OS version and if any shares are enabled.  If OS version matches and shares are enabled 
    it will check HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameter\DisableCompression to determine if the host system is vulnerable.
    If the host system is vulnerable and -mitigate is used it will set DisableCompression to 1

.PARAMETER mitigate 
    The parameter mitigate is used to apply the recommenced mitigation's.
    https://portal.msrc.microsoft.com/en-US/security-guidance/advisory/ADV200005

.EXAMPLE
    The example below mitigates the system if vulnerable to CVE-2020-0796 EternalDarkness, Requires running as Admin
    PS C:\> Import-Module  EternalDarkness.ps1
    PS C:\> EternalDarkness -mitigate

.EXAMPLE
    The example below checks if the system is vulnerable to CVE-2020-0796 EternalDarkness
    PS C:\> Import-Module EternalDarkness.ps1
    PS C:\> EternalDarkness

.NOTES
    Author: Casey Parman
    Last Edit: 2020-03-11
    Version 1.0 - initial release
#>

function EternalDarkness 
{

    param
    (
        [switch]$mitigate
    )

    If ([environment]::OSVersion.Version.Major -eq 10) 
    {
        If ([environment]::OSVersion.Version.Build -eq 18363 -or [environment]::OSVersion.Version.Build -eq 18362) 
        {
            If (Get-ItemProperty -Path HKLM:\System\CurrentControlSet\Services\LanmanServer\Shares) 
            {
                If ((Get-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters").PSObject.Properties.Name -contains "DisableCompression") 
                {
                    ##Here we'll check to see the value,
                   If ((Get-ItemPropertyValue -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" -name DisableCompression) -eq 0) 
                   {
                        If ($mitigate) 
                        {
                            If (([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
                            {
                                Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" DisableCompression -Type DWORD -Value 1 -Force
                                Write-Host -ForegroundColor Green "--------------------"
                                Write-Host -ForegroundColor Green "--System Mitigated--"
                                Write-Host -ForegroundColor Green "--------------------"
                         
                            } Else
                            {
                                Write-Host -ForegroundColor Red "Run in elevated prompt"
                            }
                        } Else
                        {
                            Write-Host -ForegroundColor Red "--------------"
                            Write-Host -ForegroundColor Red "--Vulnerable--"
                            Write-Host -ForegroundColor Red "--------------------------------"
                            Write-Host -ForegroundColor Red "mitigate with -mitigate argument"
                            Write-Host -ForegroundColor Red "--------------------------------"
                        }
                   } Else 
                   {
                        Write-Host -ForegroundColor Green "------------------"
                        Write-Host -ForegroundColor Green "--Not Vulnerable--"
                        Write-Host -ForegroundColor Green "------------------"
                   }

                 } Else 
                 {
                     If ($mitigate) 
                      {
                            If (([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
                            {
                                Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" DisableCompression -Type DWORD -Value 1 -Force
                                Write-Host -ForegroundColor Green "--------------------"
                                Write-Host -ForegroundColor Green "--System Mitigated--"
                                Write-Host -ForegrounFUCKdColor Green "--------------------"
                            } Else
                            {
                                Write-Host -ForegroundColor Red "Run in elevated prompt"
                            }
                      } Else
                      {
                        Write-Host -ForegroundColor Red "--------------"
                        Write-Host -ForegroundColor Red "--Vulnerable--"
                        Write-Host -ForegroundColor Red "--------------------------------"
                        Write-Host -ForegroundColor Red "mitigate with -mitigate argument"
                        Write-Host -ForegroundColor Red "--------------------------------"
                      }
                 }
            } Else 
            {
                Write-Host -ForegroundColor Green "------------------"
                Write-Host -ForegroundColor Green "--Not Vulnerable--"
                Write-Host -ForegroundColor Green "------------------"
            }
        }Else 
        {
            Write-Host -ForegroundColor Green "------------------"
            Write-Host -ForegroundColor Green "--Not Vulnerable--"
            Write-Host -ForegroundColor Green "------------------"
        } 
    } Else {
        Write-Host -ForegroundColor Green "------------------"
        Write-Host -ForegroundColor Green "--Not Vulnerable--"
        Write-Host -ForegroundColor Green "------------------"

    } 

}

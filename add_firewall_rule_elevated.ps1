<#
  add_firewall_rule_elevated.ps1
  One-click elevating script:
  - Requests UAC elevation
  - Creates or replaces an inbound TCP firewall rule for port (default 5000)

  Usage:
    - Double-click `run_add_firewall.bat` in the same folder
    - Or run directly:
      powershell -NoProfile -ExecutionPolicy Bypass -File .\add_firewall_rule_elevated.ps1 -Port 5000 -RuleName "NCMIS 5000" -Profile Private
#>

param(
    [Parameter(Position=0)]
    [int]$Port = 5000,

    [Parameter(Position=1)]
    [string]$RuleName = "",

    [Parameter(Position=2)]
    [ValidateSet("Private","Public","Domain","Any")]
    [string]$Profile = "Private"
)

if ([string]::IsNullOrWhiteSpace($RuleName)) {
    $RuleName = "NCMIS $Port"
}

# Self-elevate if not running as Administrator
$principal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    $argList = @("-NoProfile","-ExecutionPolicy","Bypass","-File",$PSCommandPath,"-Port",$Port,"-RuleName",$RuleName,"-Profile",$Profile)
    Start-Process -FilePath "powershell.exe" -ArgumentList $argList -Verb RunAs
    exit
}

try {
    $existing = Get-NetFirewallRule -DisplayName $RuleName -ErrorAction SilentlyContinue
    if ($existing) {
        Write-Host "Removing existing firewall rule '$RuleName'..." -ForegroundColor Yellow
        Remove-NetFirewallRule -DisplayName $RuleName -Confirm:$false -ErrorAction Stop
    }
    Write-Host "Creating firewall rule '$RuleName' for TCP port $Port (Profile: $Profile)..." -ForegroundColor Green
    New-NetFirewallRule -DisplayName $RuleName -Direction Inbound -LocalPort $Port -Protocol TCP -Action Allow -Profile $Profile -Description "Created by add_firewall_rule_elevated.ps1" -ErrorAction Stop
    Write-Host "Done: firewall rule created." -ForegroundColor Green
} catch {
    Write-Host "Error creating firewall rule: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

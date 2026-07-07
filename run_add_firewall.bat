@echo off
REM One-click wrapper to run the PowerShell script with elevation
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0add_firewall_rule_elevated.ps1" %*

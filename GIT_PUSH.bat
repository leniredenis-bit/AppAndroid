@echo off
cd /d "%~dp0"
powershell -ExecutionPolicy Bypass -File "git_push.ps1"

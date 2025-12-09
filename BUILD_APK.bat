@echo off
cd /d "%~dp0"
powershell -ExecutionPolicy Bypass -File "build_apk.ps1"

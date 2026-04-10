@echo off
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0tools\audit-dev-stack.ps1" %*

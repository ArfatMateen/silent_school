@echo off
del /s /f /q C:\Windows\Temp\*.*
rd /s /q C:\Windows\Temp
md C:\Windows\Temp
del /s /f /q C:\Windows\Prefetch
del /s /f /q %temp%\*.*
rd /s /q %temp%
md %temp%
cls

@echo off
cd C:\Windows\System32\Macromed\Flash\
if exist *ActiveX.exe (
echo Updating Flash Player Plugin for Internet Explorer
for /f "tokens=*" %%f in ('dir /b *ActiveX.exe') do set last=%%f
)
if defined last (
%last% -update plugin
set last=
echo Complete!
)
if exist *Plugin.exe (
echo Updating Flash Player Plugin for Firefox, Safari, Opera
for /f "tokens=*" %%f in ('dir /b *Plugin.exe') do set last=%%f
)
if defined last (
%last% -update plugin
echo Complete!
)
pause

##Manual run
C:\Windows\System32\Macromed\Flash\FlashUtil_ActiveX.exe -update plugin

##Purge Win updates

net stop wuauserv

cd /d %windir%

rd /s SoftwareDistribution

net start wuauserv

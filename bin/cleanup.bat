@echo off
color 4

cd \
dir /s
cls
diskperf -N
cls
COMPACT /U /S /A /I /F C:\*.*
del /s /f /q c:\windows\temp\*.*
rd /s /q c:\windows\temp
md c:\windows\temp
del /s /f /q C:\WINDOWS\Prefetch
del /s /f /q %temp%\*.*
rd /s /q %temp%
md %temp%
COMPACT /U /S /A /I /F C:\*.*
del /s /f /q C:\Users\%username%\AppData\Local\Temp
del /s /f /q C:\Users\%username%\AppData\Roaming\Microsoft\Windows\Recent
del /s /f /q C:\Windows\Prefetch
cls
cd C:/ & del *.log /a /s /q /f
del /s /f /q c:windowstemp*.*
rd /s /q c:windowstemp
md c:windowstemp
del /s /f /q C:WINDOWSPrefetch
del /s /f /q %temp%*.*
rd /s /q %temp%
md %temp%
for /F " tokens=*" %%G in ('wevtutil.exe el') DO (call :do_clear "%%G")
ipconfig /flushdns
rd /s /q "%userprofile%Recycle Bin"
md "%userprofile%Recycle Bin"
compact /c /s C: 
compact /c /s "%systemdrive%"
reg delete "HKLM\Software\Microsoft\Windows\CurrentVersion\HotStart" /f >NUL 2>&1
reg delete "HKLM\Software\Microsoft\Windows\CurrentVersion\Sidebar" /f >NUL 2>&1
reg delete "HKLM\Software\Microsoft\Windows\CurrentVersion\Telephony" /f >NUL 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Screensavers" /f >NUL 2>&1
reg delete "HKCU\Printers" /f >NUL 2>&1
reg delete "HKLM\SYSTEM\ControlSet001\Control\Print" /f >NUL 2>&1
reg delete "HKLM\SYSTEM\ControlSet002\Control\Print" /f >NUL 2>&1
reg delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Font Drivers" /v "Adobe Type Manager" /f >NUL 2>&1
reg delete "HKLM\System\ControlSet001\Control\Terminal Server\Wdsrdpwd" /v "StartupPrograms" /f >NUL 2>&1
DISM /Online /Remove-Capability /CapabilityName:Browser.InternetExplorer~~0.0.11.0 /norestart /quiet >NUL 2>&1
DISM /Online /Remove-Capability /CapabilityName:MathRecognizer0.0.1.0 /norestart /quiet >NUL 2>&1
DISM /Online /Remove-Capability /CapabilityName:Microsoft.Windows.PowerShell.ISE0.0.1.0 /norestart /quiet >NUL 2>&1
DISM /Online /Remove-Capability /CapabilityName:OneCoreUAP.OneSync~~0.0.1.0 /norestart /quiet >NUL 2>&1
del /s /f /q "%windir%temp*.*" >NUL 2>&1
rd /s /q "%windir%temp" >NUL 2>&1
md "%windir%temp" >NUL 2>&1
del /s /f /q "%temp%*.*" >NUL 2>&1
rd /s /q "%temp%" >NUL 2>&1
md "%temp%" >NUL 2>&1
del /s /f /q "%windir%*.log" >NUL 2>&1
for %%F in ("%SystemRoot%SoftwareDistributionDownload*") do (
    del "%%F" /q /f >NUL 2>&1
    rd "%%F" /s /q >NUL 2>&1
) >NUL 2>&1
for %%A in ("%localappdata%MicrosoftWindowsINetCacheIE*") do (
    del "%%A" /q /f >NUL 2>&1
    rd "%%A" /s /q >NUL 2>&1
) >NUL 2>&1
del /s /f /q "%LOCALAPPDATA%IconCache.db" >NUL 2>&1
del /s /f /q "%LOCALAPPDATA%MicrosoftWindowsExplorericoncache*" >NUL 2>&1
del /s /f /q "%LOCALAPPDATA%MicrosoftWindowsExplorerthumbcache*" >NUL 2>&1
powershell Clear-RecycleBin -Force >NUL 2>&1
del /s /f /q c:windowstemp*.*
rd /s /q c:windowstemp
md c:windowstemp
del /s /f /q C:WINDOWSPrefetch
del /s /f /q %temp%*.*
rd /s /q %temp%
md %temp%
COMPACT /U /S /A /I /F C:*.*
pause

@echo off

::	Title:		Install_VTSecureBrowser10.4-2018-08-02.bat
::	Version:	1.0
::	Build Date:	04/03/2019
::	Author:		Steven DeZalia

:: This installs the necessary components for VT Secure Browser 10.4-2018-08-02
:: This also install the VT Julie M16-SAPI5 Voice pack
:: Detected the OS type (x86 vs x64) and copies license file to needed directory
:: Finally this also launches Speech Properties to set the VW Julie voice pack

:sanity_check
:: checks if Julie Voice Pack is installed, closes if detected, continues if not
echo Checking if Julie Voice Pack is Installed
if exist "%ProgramFiles(x86)%\VW\VT\Julie\M16-SAPI5\data-julie" goto detected
	goto not_detected64
		:detected
		echo Julie detected, uninstall Julie Voice Pack and start again
		msg * "Julie Detected, Please uninstall and start again"
		exit

		:not_detected64
		echo Julie x64 not detected,
		goto check_x86

			:check_x86
			echo Checking if x86 Julie Installed
			if exist "%ProgramFiles%\VW\VT\Julie\M16-SAPI5\data-julie" goto detected
			goto not_detected86

			:not_detected86
			echo Julie x86 not detected, Installation will continue
			goto start

:start

:install_sbac
:: Silently Installs SBAC VT Secure Browser with no restart
echo Installing SBAC VT Secure Browser
call msiexec /i "%~dp0VTSecureBrowser\VTSecureBrowser10.4-2018-08-02.msi" /qn /norestart

:install_julie
:: Silently Installs Julie Voice Pack using setup.iss file in the same dir
echo Installing Julie Voice Pack
call "%~dp020120224_VT-SAPI5_Julie_M16_570_win_v3.11.3.1\setup.exe" /s|rem

:julie_license
:: Detects x86 or x64 and Copies License File to Where Julie Checks
echo Detecting Windows x64 or x86
if exist "C:\Program Files (x86)" goto 64bit
	goto 32bit
		:32bit
		echo Windows x86 Detected, Copying License file
		copy "%~dp0Julie License File\verification.txt" "%ProgramFiles%\VW\VT\Julie\M16-SAPI5\data-common\verify\"
		:64bit
		echo Windows x64 Detected, Copying License file
		copy "%~dp0Julie License File\verification.txt" "%ProgramFiles(x86)%\VW\VT\Julie\M16-SAPI5\data-common\verify\"

:launch_speech_properties
:: Launching Speech Properties to Change Voice to Julie
"%WINDIR%\SysWOW64\Speech\SpeechUX\sapi.cpl"
msg * "Change Voice Selection to VW Julie"

pause

:launch_sbac
:: Detects x86 or x64 and Launches SBAC to test functionality
echo Detecting Windows x64 or x86
if exist "C:\Program Files (x86)" goto 64bit
	goto 32bit
		:32bit
		echo Windows x86 Detected, Launching SBAC
		call "%ProgramFiles%\VTSecureBrowser\VTSecureBrowser.exe"
		:64bit
		echo Windows x64 Detected, Launching SBAC
		call "%ProgramFiles(x86)%\VTSecureBrowser\VTSecureBrowser.exe"

pause

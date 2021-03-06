@echo off
setlocal
set OLDDIR=%cd%
rem cd /d %~dp0

SET SHHLACK_HOME=%USERPROFILE%\.shhlack
SET SHHLACK_PACKAGE=package.json
SET SHHLACK_FILE=shhlack.js
SET SHHLACK_PATCHER_FILE=patch.js

SET WIN_DEFAULT_LOCATION=%LOCALAPPDATA%\slack

rem Creates SHHLACK home Directory
if not exist %SHHLACK_HOME%\NUL (
  mkdir %SHHLACK_HOME%
)

rem Copy package.json and shhlack.js
xcopy /Y %~dp0%SHHLACK_PACKAGE% %SHHLACK_HOME%
xcopy /Y %~dp0%SHHLACK_FILE% %SHHLACK_HOME%

rem Check for default location
if exist %WIN_DEFAULT_LOCATION% (
  CD %WIN_DEFAULT_LOCATION%\app-*\resources\app.asar.unpacked\src\static
  find "PATCHED" ssb-interop.js >nul|| goto notfound
rem Found, It's already Patched
  if exist ssb-interop.js.bak (
   rem found the patch and the backup, let's convert back to the original!
    xcopy /Y ssb-interop.js.bak ssb-interop.js
  ) else (
  rem no backup fie found. Exit.
    @echo on
    echo "Backup File ssb-interop.js.bak not found, you'll have to do it manually"
    @echo off
  goto done
  )
rem OK, Not Patched
:notfound
  rem Creating Backup
  @echo on
  @echo "creating backup file ssb-interop.js.bak"
  @echo off
  xcopy /Y ssb-interop.js ssb-interop.js.bak
  rem PAtching it
  @echo on
  @echo "Patching file ssb-interop.js"
  @echo off
  type %~dp0%SHHLACK_PATCHER_FILE% >> ssb-interop.js
goto done
) else (
    @echo on
    @echo "Slack Directory not found!"
    @echo off
    pause
)
:done

CD %OLDDIR%
@echo on
    @echo "Done! Press Any Key to Exit"
@echo off
pause
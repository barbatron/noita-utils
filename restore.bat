@echo off

if not defined noita_root set noita_root=%userprofile%\AppData\LocalLow\Nolla_Games_Noita
set noita_backup_root=%noita_root%\backups
set noita_save_dir=%noita_root%\save00

set noita_backup_dir=
set prompt_user=y

if "%1" == "" (
  rem ### Default mode w/ prompt
  call :find_latest
) else if "%1" == "auto" (
  rem ### Auto mode - restore latest created
  echo Auto mode
  set prompt_user=n
  call :find_latest
) else if "%1" == "ls" (
  rem ### List backups
  dir %noita_backup_root% /b /od
  call :find_latest
  exit /b
) else if not "%1" == "" (
  rem ### Some argument not yet handled - assumed to be name of backup directory under %noita_backup_root%
  set noita_backup_dir=%1
)

rem ### Verify and produce full path
if not defined noita_backup_dir (
  echo No backup selected - aborting.
  goto :end
)
if not exist %noita_backup_root%\%noita_backup_dir% (
  echo Backup "%noita_backup_dir%" not found under %noita_backup_root% - aborting.
  goto :end
)

set noita_last_backup_attempt=%noita_backup_root%\%noita_backup_dir%

if not "%prompt_user%" == "n" (
  call :do_prompt %noita_last_backup_attempt%
  if errorlevel 1 (
    echo Aborted by user...  
    goto :end
  )
)

rem ### Keep any existing game, for safety
if exist %noita_save_dir% call :backup_current

rem ### Restore backup files
if not exist %noita_save_dir% mkdir %noita_save_dir%
echo Copying files...
xcopy "%noita_last_backup_attempt%\*.*" "%noita_save_dir%" /e /y /i /q

rem ### Restore complete
echo Restored "%noita_backup_dir%" OK at %DATE% %TIME%

:find_latest
set noita_backup_dir=
for /f "tokens=*" %%a in ('dir %noita_backup_root% /b /od') do set "noita_backup_dir=%%a"
if "%noita_backup_dir%" == "" (
  echo No backups found!
  exit /b 2
)
echo Latest is: %noita_backup_dir%
exit /b

:backup_current
echo Copying existing save00 to save00.old... 
if exist %noita_save_dir%.old rmdir %noita_save_dir%.old /s /q
mkdir %noita_save_dir%.old
xcopy %noita_save_dir%\*.* %noita_save_dir%.old /e /y /i /q
echo Current game backup OK
exit /b

:do_prompt
set noita_restore_ok=n
set /P noita_restore_ok=Restore backup "%1"? (y/[n]) 
if "%noita_restore_ok%" == "n" exit /b 1
exit /b

:end
exit /b

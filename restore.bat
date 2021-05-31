@echo off

if not defined noita_root set noita_root=%userprofile%\AppData\LocalLow\Nolla_Games_Noita

set noita_backup_root=%noita_root%\backups
set noita_game_folder=%noita_root%\save00

set backupdir=
set prompt_user=y

if "%1" == "auto" (
  rem ### Auto mode
  echo Auto mode
  set prompt_user=n
  call :find_latest
) else if "%1"=="" (
  rem ### Default mode w/ prompt
  call :find_latest
) else if not "%1"=="" (
  rem ### Some argument that is not "auto" = name of backup directory under %noita_backup_root%
  set backupdir=%1
)

rem ### Verify and produce full path
if not defined backupdir (
  echo No backup selected - aborting.
  goto end
)
if not exist %noita_backup_root%\%backupdir% (
  echo Backup "%backupdir%" not found under %noita_backup_root% - aborting.
  goto end
)

set noita_last_backup_attempt=%noita_backup_root%\%backupdir%

if "%prompt_user%" NEQ "n" (
  call :do_prompt %noita_last_backup_attempt%
  if errorlevel 1 ( 
    echo Aborted by user...  
    call :cleanup
    exit /b -1
  )
)

rem ### Keep any existing game
if exist %noita_game_folder% call :backup_current

rem ### Restore backup files
if not exist %noita_game_folder% mkdir %noita_game_folder%
echo Copying files...
xcopy %noita_last_backup_attempt%\*.* %noita_game_folder% /e /y /i /q

rem ### Restore complete
echo Restored "%backupdir%" OK at %DATE% %TIME%

:cleanup
set backupdir=
set prompt_user=y
exit /b

:end
call :cleanup
exit /b

:find_latest
echo Finding most recent backup...
set backupdir=
for /f "tokens=*" %%a in ('dir %noita_backup_root%\2* /b /od') do set backupdir=%%a
if "%backupdir%"=="" (
  echo No backups found!
  exit /b 1
)
exit /b

:backup_current
echo Copying existing save00 to save00.old... 
if exist %noita_game_folder%.old rmdir %noita_game_folder%.old /s /q
mkdir %noita_game_folder%.old
xcopy %noita_game_folder%\*.* %noita_game_folder%.old /e /y /i /q
echo Current game backup OK
exit /b

:do_prompt
set noita_restore_ok=n
set /P noita_restore_ok=Restore save from %1 (y/[n])? 
if /I "%noita_restore_ok%" NEQ "y" exit /B 1
exit /b

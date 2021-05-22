@echo off
set noita_backup_root=%userprofile%\AppData\LocalLow\Nolla_Games_Noita\backups
set noita_last_backup=%noita_backup_root%\%DATE%-%RANDOM%

echo Backing up to %noita_last_backup%...

if exist %noita_last_backup% (
  echo Deleting existing...
  rmdir %noita_last_backup% /s /q
)

echo Copying files...
xcopy %userprofile%\AppData\LocalLow\Nolla_Games_Noita\save00\*.* %noita_last_backup%\*.* /e /y /i /q

echo OK

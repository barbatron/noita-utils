@echo off

rem local date time in predictable/orderable format yyyy-MM-dd
rem https://stackoverflow.com/questions/203090/how-do-i-get-current-date-time-on-the-windows-command-line-in-a-suitable-format
for /F "usebackq tokens=1,2 delims==" %%i in (`wmic os get LocalDateTime /VALUE 2^>NUL`) do if '.%%i.'=='.LocalDateTime.' set ldt=%%j
set ldt=%ldt:~0,4%-%ldt:~4,2%-%ldt:~6,2%

set noita_backup_root=%userprofile%\AppData\LocalLow\Nolla_Games_Noita\backups
set noita_last_backup=%noita_backup_root%\%ldt%-%RANDOM%

echo Backing up to %noita_last_backup%...

if exist %noita_last_backup% (
  echo Deleting existing...
  rmdir %noita_last_backup% /s /q
)

echo Copying files...
xcopy %userprofile%\AppData\LocalLow\Nolla_Games_Noita\save00\*.* %noita_last_backup%\*.* /e /y /i /q

echo OK

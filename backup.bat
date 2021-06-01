@echo off

if not defined noita_root set noita_root=%userprofile%\AppData\LocalLow\Nolla_Games_Noita
if not defined noita_desc (
  if not "%1"=="-" ( 
    set noita_desc=%*
    echo Using description "%noita_desc%"
  )
)

setlocal
set noita_backup_root=%noita_root%\backups
set noita_save_dir=%noita_root%\save00

rem local date time in predictable/orderable format yyyyMMdd_HHmm - not globally safe but ok
rem https://stackoverflow.com/questions/203090/how-do-i-get-current-date-time-on-the-windows-command-line-in-a-suitable-format
for /F "usebackq tokens=1,2 delims==" %%i in (`wmic os get LocalDateTime /VALUE 2^>NUL`) do if '.%%i.'=='.LocalDateTime.' set ldt=%%j
set noita_backup_dir=save00-%ldt:~0,4%%ldt:~4,2%%ldt:~6,2%-%ldt:~8,2%%ldt:~10,2%%ldt:~12,2%

rem ### Allow passing description, e.g.
if not "%noita_desc%"=="" (
  set noita_backup_dir=%noita_backup_dir%-%noita_desc%
)

set noita_last_backup=%noita_backup_root%\%noita_backup_dir%

echo Backing up to "%noita_last_backup%"...

if exist %noita_last_backup% (
  echo Deleting existing...
  rmdir %noita_last_backup% /s /q
)

echo Copying files...
xcopy "%noita_save_dir%\*.*" "%noita_last_backup%" /e /y /i /q

echo OK

@echo off
set USERNAME=root
set PASSWORD=parthasarthyroyy
set DATABASE=bookstore
set BACKUP_DIR=C:\Users\mogan\OneDrive\Desktop\DCSAssg1\backup
set DATE=%date:~10,4%-%date:~4,2%-%date:~7,2%

mysqldump -u %USERNAME% -p%PASSWORD% %DATABASE% > %BACKUP_DIR%\%DATABASE%_%DATE%.sql

REM Optional: Delete backups older than 7 days
forfiles -p %BACKUP_DIR% -s -m *.sql -d -7 -c "cmd /c del @file"

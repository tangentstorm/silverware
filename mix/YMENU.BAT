@echo off
cls
if exist ytemp.bat del ytemp.bat
c:
cd \
YMEN %1 %2
if exist ytemp.bat ytemp
rem The next lines are in case YTEMP.BAT isn't there (ie, the user quits)
c:
cd \
cls


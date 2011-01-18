@echo off
REM Delete link on Desktop
echo Deleting Desktop shortcut...
del "%USERPROFILE%\Desktop\Watir Robot.lnk"
REM Rename the wr-gems.jar file back to original
echo Renaming files affected during installation...
cd lib\ruby
ren wr-gems-unpacked.jar wr-gems.jar
pause
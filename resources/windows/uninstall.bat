@echo off
REM Delete link on Desktop
del "%USERPROFILE%\Desktop\Watir Robot.lnk"
REM Rename the wr-gems.jar file back to original
ren lib\ruby\wr-gems-unpacked.jar lib\ruby\wr-gems.jar
pause
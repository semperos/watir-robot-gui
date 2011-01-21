@echo off
set WR_PROJECT_HOME=%CD%
REM Create desktop shortcuts
echo Creating Desktop Shortcuts...
wscript %WR_PROJECT_HOME%\resources\create_shortcuts.vbs
echo Shortcut created successfully!
echo Installation complete! See the README for more instructions.
pause
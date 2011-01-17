@echo off
echo Creating Desktop Shortcuts...
wscript %CD%\resources\create_shortcuts.vbs
echo Shortcut created successfully!
echo Installation complete! See the README for more instructions.
pause
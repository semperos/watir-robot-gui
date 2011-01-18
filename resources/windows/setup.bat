@echo off
set WR_PROJECT_HOME=%CD%
REM Create desktop shortcuts
echo Creating Desktop Shortcuts...
wscript %WR_PROJECT_HOME%\resources\create_shortcuts.vbs
echo Shortcut created successfully!
REM Unpack jar file with Gem dependencies
set WR_GEM_DIR="%WR_PROJECT_HOME%\lib\ruby\wr-gems"
echo Making gem directory...
mkdir %WR_GEM_DIR%
echo Copying jar file...
xcopy "%WR_PROJECT_HOME%\lib\ruby\wr-gems.jar" %WR_GEM_DIR%
cd %WR_GEM_DIR%
echo Extracting jar contents...
jar xf wr-gems.jar
del wr-gems.jar
cd "%WR_PROJECT_HOME%\lib\ruby"
ren wr-gems.jar wr-gems-unpacked.jar
echo Installation complete! See the README for more instructions.
pause
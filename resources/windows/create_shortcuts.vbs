set oShell = WScript.CreateObject("WScript.Shell" )

strDesktop = oShell.ExpandEnvironmentStrings("%USERPROFILE%\Desktop")
projectHome = CreateObject("Scripting.FileSystemObject").GetAbsolutePathName(".")

set watirRobotLink = oShell.CreateShortcut(strDesktop & "\Watir Robot.lnk" )
watirRobotLink.TargetPath = projectHome & "\start.bat"
watirRobotLink.WindowStyle = 1
watirRobotLink.IconLocation = projectHome & "\resources\watir_robot_gui.ico"
watirRobotLink.Description = "Shortcut to Run Watir Robot GUI"
watirRobotLink.WorkingDirectory = projectHome
watirRobotLink.Save

REM set remoteServerLink = oShell.CreateShortcut(strDesktop & "\Remote Server.lnk" )
REM remoteServerLink.TargetPath = projectHome & "\bin\wr-run-server.bat"
REM remoteServerLink.WindowStyle = 1
REM remoteServerLink.IconLocation = projectHome & "\resources\remote_server.ico"
REM remoteServerLink.Description = "Shortcut to Run Watir Robot Remote Server"
REM remoteServerLink.WorkingDirectory = projectHome
REM remoteServerLink.Save
set oShell = WScript.CreateObject("WScript.Shell" )

strDesktop = oShell.ExpandEnvironmentStrings("%USERPROFILE%\Desktop")
projectHome = CreateObject("Scripting.FileSystemObject").GetAbsolutePathName(".")

set watirRobotLink = oShell.CreateShortcut(strDesktop & "\Watir Robot.lnk" )
watirRobotLink.TargetPath = projectHome & "\watir-robot-gui.jar"
watirRobotLink.WindowStyle = 1
watirRobotLink.IconLocation = projectHome & "\conf\watir_robot.ico"
watirRobotLink.Description = "Shortcut to Run Watir Robot GUI"
watirRobotLink.WorkingDirectory = projectHome
watirRobotLink.Save

set remoteServerLink = oShell.CreateShortcut(strDesktop & "\Remote Server.lnk" )
remoteServerLink.TargetPath = projectHome & "\bin\wr-run-server.bat"
remoteServerLink.WindowStyle = 1
remoteServerLink.IconLocation = projectHome & "\conf\remote_server.ico"
remoteServerLink.Description = "Shortcut to Run Watir Robot Remote Server"
remoteServerLink.WorkingDirectory = projectHome
remoteServerLink.Save
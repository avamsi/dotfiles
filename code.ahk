#SingleInstance Force

!`::
	if WinActive("ahk_exe Code.exe") {
		SendInput {Alt Up}
		SendInput ^!t
	} else if WinExist("ahk_exe Code.exe") {
		WinActivate ahk_exe Code.exe
	}
return

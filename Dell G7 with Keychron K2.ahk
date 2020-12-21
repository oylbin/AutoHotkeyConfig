; I use Mac and PC at the same time. I want the shortcuts on both OS map to the same key position.

; 	!	alt key（command key on macOS）
; 	#	win key（option key on macOS）
; 	^	ctrl key
;	+	shift key

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.



; refer: https://github.com/Vonng/Configuration/blob/master/app/ahk/CapsLock.ahk
SetCapsLockState AlwaysOff

; I don't use capslock
Capslock::Ctrl

; cursor movement as in Emacs

CapsLock & n:: Send, {Down}
CapsLock & p:: Send, {Up}
CapsLock & a:: Send, {Home}
CapsLock & e:: Send, {End}
CapsLock & f:: Send, {Right}
CapsLock & b:: Send, {Left}

; kill to line end as in Emacs
CapsLock & k:: 
if WinActive("ahk_exe WindowsTerminal.exe") or WinActive("ahk_exe mintty.exe")
{
Send, ^k
}
else
{
Send, {Shift down}{end}{Shift up}{BackSpace}
}
return

; delete character at the right of the cursor 
CapsLock & d:: Send, {delete}

; enable these settings if you want use capslock+{} to simulate copy, cut, paste, save
;CapsLock & c:: Send, ^c
;CapsLock & v:: Send, ^v
;CapsLock & s:: Send, ^s
;CapsLock & x:: Send, ^x



; 2020-12-18, I give up wox and use system default search function.
; CapsLock & Space:: Send, {Ctrl down}{Space}{ctrl up}
CapsLock & Space:: Send, #q


; same key position as on macOS: copy, paste, cut, undo, select all, save, search
!c::Send, ^c
;!v::Send, ^v
!x::Send, ^x
!z::Send, ^z
!a::Send, ^a
!s::Send, ^s
!f::Send, ^f

!v::
if  WinActive("ahk_exe mintty.exe")
{
    ;MsgBox "close tab"
    Send +{insert}
}
else
{
    Send ^v
}
return

; clipboard history
; I use alfred on macOS, and clipboard history shortcut is option + command + c.
; map the shortcut to the same key position.
;#!c::SendInput, #v

!#c::
sleep, 500
Send, #v
return

; reload AutoHotkey config file
^+!h::Reload

; I use command +w to close tabs on macOS
!w::
if WinActive("ahk_exe sublime_text.exe") 
    or WinActive("ahk_class MozillaWindowClass")
    or WinActive("ahk_exe chrome.exe")
    or WinActive("ahk_exe msedge.exe")
    or WinActive("ahk_exe Code.exe")
{
    Send ^w
}
else if WinActive("ahk_exe idea64.exe")
{
   Send ^{f4}
}
else
{
    Send !{f4}
}
return

!l::
if WinActive("ahk_exe chrome.exe") or WinActive("ahk_exe msedge.exe")
{
    Send ^l
} else {
    Send !l
}
return

!1::
if WinActive("ahk_exe chrome.exe") {
    send ^1
} else {
    send !1
}
return

!2::
if WinActive("ahk_exe chrome.exe") {
    send ^2
} else {
    send !2
}
return

!3::
if WinActive("ahk_exe chrome.exe") {
    send ^3
} else {
    send !3
}
return

!t::
if WinActive("ahk_exe chrome.exe") {
    send ^t
} else {
    send !t
}
return

; refer: https://autohotkey.com/board/topic/7129-run-a-program-or-switch-to-an-already-running-instance/page-2
; refer: https://gist.github.com/leachdaniel/4b9c9511bcb3ae4eb8efeac9f51dbf4b#file-wintoggleorrun-ahk-L4

RunOrActivate(matchExpression, fullPath)
{
	IfWinExist, %matchExpression%
	{
		WinActivate
		;WinMaximize
	}
	else
	{
		Run, %fullPath%
	}
}


; win + G will start "Xbox Game Bar" by default.
; I have to turn it off in "Settings - Game - Xbox Game Bar".
#g::RunOrActivate("ahk_exe chrome.exe","C:\Program Files\Google\Chrome\Application\chrome.exe")

#e::RunOrActivate("ahk_exe TOTALCMD64.EXE", "C:\totalcmd\TOTALCMD64.EXE")

;#s::RunOrActivate("ahk_exe sublime_text.exe","C:\Program Files\Sublime Text 3\sublime_text.exe")
#s::
if FileExist("C:\Users\oylb\AppData\Local\Programs\Microsoft VS Code\Code.exe") {
    RunOrActivate("ahk_exe Code.exe", "C:\Users\oylb\AppData\Local\Programs\Microsoft VS Code\Code.exe")
}else if FileExist("C:\Users\oylbin\AppData\Local\Programs\Microsoft VS Code\Code.exe") {
    RunOrActivate("ahk_exe Code.exe", "C:\Users\oylbin\AppData\Local\Programs\Microsoft VS Code\Code.exe")
}else if FileExist("C:\Program Files\Microsoft VS Code\Code.exe") {
    RunOrActivate("ahk_exe Code.exe", "C:\Program Files\Microsoft VS Code\Code.exe")
} else {
    MsgBox, "Please install vscode first."
}
return




#w::
exePath = C:\Users\%A_UserName%\AppData\Local\Programs\WorkFlowy\WorkFlowy.exe
RunOrActivate("ahk_exe WorkFlowy.exe", exePath)
return


; 在chrome浏览器里把 alt + 鼠标左键 映射 为 ctrl + 鼠标左键
!LButton::
if WinActive("ahk_exe chrome.exe")
    or WinActive("ahk_exe msedge.exe")
{
    ;MsgBox "link in browser"
    Send {Ctrl down}{Click Left}{Ctrl up}
}
else
{
	Send {Alt down}{Click Left}{Alt up}
	;MsgBox "alt + left click"
}
return

; 在 workflowy 里把 alt+enter 映射为 ctrl + enter
!Enter::
if WinActive("ahk_exe WorkFlowy.exe"){
    send {ctrl down}{enter}{ctrl up}
}else{
    send {alt down}{enter}{alt up}
}
return

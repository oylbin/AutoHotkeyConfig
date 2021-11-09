; 我同时使用MacOS和Windows工作，快捷键设置的主要目的是让两个系统的快捷键在键盘上的位置保持一致。
; 这样切换系统敲击键盘时，我不需要调整我的肌肉记忆。

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

;======================================================================================================================
;==== 函数定义 
;======================================================================================================================

; 检查是否是命令行终端程序
isTerminalWindow() {
    return WinActive("ahk_exe WindowsTerminal.exe") 
        or WinActive("ahk_exe mintty.exe")
}
isEmacsLikeIDE(){
    ;return WinActive("ahk_exe pycharm64.exe")
    return 0
}
isJetbrainIDE(){
    return WinActive("ahk_exe pycharm64.exe") 
        or WinActive("ahk_exe idea64.exe") 
        or WinActive("ahk_exe clion64.exe")
        or WinActive("ahk_exe goland64.exe")
}

; 如果进程存在，那么切换到这个进程；如果进程不存在，那么启动一个新进程。
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

getTextEditorFullPath(){

    local path := "C:\Program Files\Sublime Text\sublime_text.exe"
    if FileExist(path) 
        return path

    path := A_WinDir . "\system32\notepad.exe"
    return path 
}


;======================================================================================================================
;==== AutoHotkey相关操作 
;======================================================================================================================

; Reload当前的配置文件
^+!h::Reload

; 用编辑器打开当前的配置文件
^+!e::
path := getTextEditorFullPath()
Run,  %path% "%A_ScriptFullPath%"
return



;======================================================================================================================
;  全局映射  
;======================================================================================================================


; I don't use capslock
Capslock::Ctrl


; enable these settings if you want use capslock+{} to simulate copy, cut, paste, save
; 2021-10-31 我为什么不打开这些开关？因为mac上习惯都是 cmd +c/x/v/s，对应windows按键应该是 alt + c/x/v/s
;CapsLock & c:: Send, ^c
;CapsLock & v:: Send, ^v
;CapsLock & s:: Send, ^s
;CapsLock & x:: Send, ^x


; same key position as on macOS: copy, paste, cut, undo, select all, save, search

; 如果需要视情况进行不同的操作，可以在“特定软件相关的快捷键”部分单独设置。
!c::Send, ^c
!v::Send, ^v
!x::Send, ^x
!z::Send, ^z
!a::Send, ^a
!s::Send, ^s
!f::Send, ^f


; 2020-12-18, I give up wox and use system default search function.
; CapsLock & Space:: Send, {Ctrl down}{Space}{ctrl up}
CapsLock & Space:: Send, #q


; clipboard history
; I use alfred on macOS, and clipboard history shortcut is option + command + c.
; map the shortcut to the same key position.
;#!c::SendInput, #v
; 2021-10-31 快捷键里有win键（#），必须先sleep一下才能正常工作，否则窗口闪一下就消失了。
; 而且实测发行sleep时间还要稍微长一点，比如 sleep 100，也是闪一下就消失。
!#c::
sleep, 500
Send, #v
return

; switch monitor input source
^!Right:: Run "C:\Users\oylbin\SynologyDrive\AppDataSync\controlmymonitor\ControlMyMonitor.exe" /SetValue Primary 60 15


;======================================================================================================================
;  类似于 Emacs的编辑体验 
;======================================================================================================================
; cursor movement as in Emacs

CapsLock & n:: Send, {Down}
CapsLock & p:: Send, {Up}
CapsLock & a:: Send, {Home}
CapsLock & e:: Send, {End}
; delete character at the right of the cursor 
CapsLock & d:: Send, {delete}
CapsLock & f:: Send, {Right}
CapsLock & b:: Send, {Left}
CapsLock & k:: Send, {Shift down}{end}{Shift up}{BackSpace}

;======================================================================================================================
;  启动软件  
;======================================================================================================================

; win + G will start "Xbox Game Bar" by default.
; I have to turn it off in "Settings - Game - Xbox Game Bar".


#g::
if FileExist("C:\Program Files\Google\Chrome\Application\chrome.exe") {
    RunOrActivate("ahk_exe chrome.exe"
        ,"C:\Program Files\Google\Chrome\Application\chrome.exe")
} else if FileExist(Format("C:\Users\{1}\AppData\Local\Google\Chrome\Application\chrome.exe",A_UserName)) {
    RunOrActivate("ahk_exe chrome.exe"
        ,Format("C:\Users\{1}\AppData\Local\Google\Chrome\Application\chrome.exe",A_UserName))
} else {
    RunOrActivate("ahk_exe msedge.exe"
        ,"C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe")
}
return


;#e::RunOrActivate("ahk_exe TOTALCMD64.EXE", "C:\totalcmd\TOTALCMD64.EXE")
#e::RunOrActivate("ahk_exe fman.exe"
        , Format("C:\Users\{1}\AppData\Local\fman\fman.exe", A_UserName))

#s::RunOrActivate("ahk_exe sublime_text.exe"
        , "C:\Program Files\Sublime Text\sublime_text.exe")

#x::
RunOrActivate("ahk_exe XMind.exe", "C:\Program Files (x86)\XMind\XMind.exe")
return


#w::RunOrActivate("ahk_exe WorkFlowy.exe"
        , Format("C:\Users\{1}\AppData\Local\Programs\WorkFlowy\WorkFlowy.exe", A_UserName))



;======================================================================================================================
;  特定软件相关的快捷键
;======================================================================================================================

; 软件相关的快捷键定义方式有两种
; 方式1
;       快捷键 :: 用WinActive判断，根据不同软件定义不同的行为。
; 方式2
;       #if 用WinActive判断软件
;           快捷键 :: 行为
;       #if
;
; 方式1的定义，快捷键是全局生效的。
; 方式2的定义，快捷键指针对满足对应条件的软件生效。

; 以在 workflowy 里把 alt+enter 映射为 ctrl + enter 举例
; 方式1，这种定义方式，会需要写一个else，而且可能影响到其他的程序快捷键，能用方式2的地方建议不再使用这种方式。
;!Enter::
;if WinActive("ahk_exe WorkFlowy.exe"){
;    send {ctrl down}{enter}{ctrl up}
;}else{
;    send {alt down}{enter}{alt up}
;}
;return
;
; 方式2，这种定义更优。因为不会定义一个 alt+enter的全局快捷键。
;#if WinActive("ahk_exe WorkFlowy.exe")
;!Enter::send {ctrl down}{enter}{ctrl up}
;#if

;======================================================================================================================
;  特定软件相关的快捷键
;======================================================================================================================

; 命令行软件相关定义
#if isTerminalWindow()
!c::Send ^{insert}
!v::Send +{insert}
CapsLock & f::Send ^f
CapsLock & b::Send ^b
CapsLock & k::Send ^k
CapsLock & c::Send ^c
#if


; 类似于Emacs的文本编辑器的快捷键定义
#if isEmacsLikeIDE()
!c::Send ^{insert}
!v::Send +{insert}
#if


; WorkFlowy.exe相关操作
#if WinActive("ahk_exe WorkFlowy.exe")

; 在 workflowy 里把 alt+v 映射为 ctrl + shift + v，粘贴时去掉格式。
!v::send {ctrl down}{shift down}v{shift up}{ctrl up}
; 在 workflowy 里把 alt+enter 映射为 ctrl + enter
!Enter::send {ctrl down}{enter}{ctrl up}
; alt+b -> ctrl+b
!b::Send, ^b

#if


; 浏览器里的定义
#if WinActive("ahk_exe chrome.exe") or WinActive("ahk_exe msedge.exe")

;把 alt + 鼠标左键 映射 为 ctrl + 鼠标左键
!LButton::
Sleep, 500
Send, {Ctrl down}{Click Left}{Ctrl up}
return

; 新开一个tab，alt + t 映射为 ctrl + t
!t::Send ^t
; 输入焦点切换到地址栏, alt + l 映射为 ctrl + l
!l::Send ^l

; 切换标签，alt+数字 映射为 ctrl+数字
!1::Send ^1
!2::Send ^2
!3::Send ^3
!4::Send ^4
!5::Send ^5

; 放大 缩小
!=::Send ^{+}
!-::Send ^{-}

#if

; Jetbrain 系列IDE快捷键设置
; IDE使用默认的名称为“Windows”的Keymap配置文件
; 用AutoHotKey做映射的好处是：1. 可以自动同步；2. 不用每个IDE都配置一遍。
#if isJetbrainIDE()

; 关闭文件标签
!w::Send ^{f4}

; Navigate - backward
![::Send ^!{Left}

; Navigate - forward
!]::Send ^!{Right}

; Goto File
+!o::Send ^+N

; Goto Declaration or Usages
!LButton::Send ^{LButton}

; format file
#!l::Send ^!l

; run
CapsLock & r:: Send, +{f10}

#if


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
else
{
    Send !{f4}
}
return

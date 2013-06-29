#SingleInstance,force
#Persistent

menu,tray,icon,mTray.ico
;menu,tray,Click,1
menu,tray,NoStandard
menu,tray,add,Status,status
menu,tray,add,Exit,exit

gui,1:new
gui,1:add,listbox,vcLB1 w200 h80
gui,1:add,button,ggBtn1 w200,Reload
gui,1:add,button,ggBtn2 w200,Terminate
gui,1:add,button,ggBtn3 w200,Reset
gui,1:add,button,ggBtn4 w200,Edit List
gui,1:add,button,ggBtn5 w200,Refresh
gui,1:show,hide,mTray

gosub main
return

exit:
  ExitApp
	
main:
	dll:={}
	FileRead,ScriptList,mTray.txt
	loop,parse,ScriptList,`n,`r
	{
		path:=A_ScriptDir "\" A_LoopField "\" A_LoopField ".ahk"
		IfExist,%path%
			dll[A_LoopField]:=AhkDllThread()
			,dll[A_LoopField].ahkDll(path)
	}
return

status:
	lb:=""
	for k,v in dll
		if v.ahkReady()
			lb.="|" k
	if !lb
		lb:="|"
	GuiControl,,cLB1,%lb%
	gui,1:show
return

gBtn1:
	GuiControlGet,lb,,cLB1
	if lb {
		dll[lb].ahkReload()
		gosub,status
	}
return

gBtn2:
	GuiControlGet,lb,,cLB1
	if lb {
		dll[lb].ahkTerminate()
		dll.remove(lb)
		gosub,status
	}
return

gBtn3:
	for k,v in dll
		v.ahkTerminate()
		,v.remove(k)
	gosub main
	gosub status
return

gBtn4:
	Run,notepad mTray.txt
return

gBtn5:
	gosub status
return

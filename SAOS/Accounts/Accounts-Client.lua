Accounts = {
	Login = {},
	Register = {}
}

function Accounts.Initialize()
	if not localPlayer:getData("account") then
		local resX,resY = guiGetScreenSize()
		Accounts.Login.Window = guiCreateWindow(resX/2-200,resY/2-140,400,280,Utils.GetL10N("ACCOUNTS_TITLE"),false)
		guiWindowSetSizable(Accounts.Login.Window,false)
		Accounts.Login.UsernameLabel = guiCreateLabel(0,50,100,20,Utils.GetL10N("ACCOUNTS_USERNAME"),false,Accounts.Login.Window)
		guiLabelSetHorizontalAlign(Accounts.Login.UsernameLabel,"right")
		Accounts.Login.PasswordLabel = guiCreateLabel(0,100,100,20,Utils.GetL10N("ACCOUNTS_PASSWORD"),false,Accounts.Login.Window)
		guiLabelSetHorizontalAlign(Accounts.Login.PasswordLabel,"right")
		Accounts.Login.UsernameEdit = guiCreateEdit(110,45,250,30,"",false,Accounts.Login.Window)
		guiEditSetMaxLength(Accounts.Login.UsernameEdit,32)
		Accounts.Login.PasswordEdit = guiCreateEdit(110,95,250,30,"",false,Accounts.Login.Window)
		guiEditSetMasked(Accounts.Login.PasswordEdit,true)
		Accounts.Login.RememberPassword = guiCreateCheckBox(110,135,250,30,Utils.GetL10N("ACCOUNTS_REMEMBER"),false,false,Accounts.Login.Window)
		Accounts.Login.LoginButton = guiCreateButton(20,175,175,30,Utils.GetL10N("ACCOUNTS_LOGIN"),false,Accounts.Login.Window)
		Accounts.Login.RegisterButton = guiCreateButton(205,175,175,30,Utils.GetL10N("ACCOUNTS_REGISTER"),false,Accounts.Login.Window)
		Accounts.Login.RecoveryButton = guiCreateButton(20,225,360,30,Utils.GetL10N("ACCOUNTS_RECOVERY"),false,Accounts.Login.Window)
		showCursor(true)
		showChat(false)
		addEventHandler("onClientRender",root,Accounts.RenderBackground)
		guiBringToFront(Accounts.Login.UsernameEdit)
	end
end

function Accounts.RenderBackground()
	local resX,resY = guiGetScreenSize()
	dxDrawImage(0,0,resX,resY,"Accounts/Background.jpg")
	dxDrawRectangle(0,0,resX,resY,tocolor(0,0,0,100))
	dxDrawText("SAOS RPG",4,0,resX,resY/4+4,tocolor(0,0,0),2,"bankgothic","center","center")
	dxDrawText("SAOS RPG",0,0,resX,resY/4,tocolor(255,255,255),2,"bankgothic","center","center")
	local playersText = string.format(Utils.GetL10N("ACCOUNTS_PLAYERS"),#getElementsByType("player"))
	dxDrawText(playersText,4,resY/4*3,resX,resY+4,tocolor(0,0,0),1.5,"bankgothic","center","center")
	dxDrawText(playersText,0,resY/4*3,resX,resY,tocolor(255,255,255),1.5,"bankgothic","center","center")
end
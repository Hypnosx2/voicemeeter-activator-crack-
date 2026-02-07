#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <StaticConstants.au3>
#include <MsgBoxConstants.au3>
#AutoIt3Wrapper_Icon=icon.ico
#AutoIt3Wrapper_Res_ProductVersion=1.0.0
#AutoIt3Wrapper_Res_FileVersion=1.0.0.0
#AutoIt3Wrapper_Res_ProductName=Fast
#AutoIt3Wrapper_Res_Description=Voicemeeter Lisans
#AutoIt3Wrapper_Res_CompanyName=Hypnos

Global $LANG = "EN"

If @OSLang = "041F" Then ; Türkçe
    $LANG = "TR"
EndIf

If $LANG = "TR" Then
    $TXT_TITLE      = "VoiceMeeter Lisans"
    $TXT_INFO       = "Voicemeeter yüklüyse kaldir ve yükleyip açmadan önce lisansla butonuna bas."
    $BTN_LICENSE    = "VoiceMeeter Lisansla"
    $BTN_CLOSE      = "Programi Kapat"
    $BTN_INSTALL    = "VoiceMeeter Indir"
    $BTN_REMOVE     = "VoiceMeeter Kaldir"
    $MSG_SUCCESS_T  = "Basarili"
    $MSG_SUCCESS_C  = "Voicemeeter lisanslandi."
Else
    $TXT_TITLE      = "VoiceMeeter License"
    $TXT_INFO       = "If Voicemeeter is installed, uninstall it and click license before opening after reinstall."
    $BTN_LICENSE    = "License VoiceMeeter"
    $BTN_CLOSE      = "Close Program"
    $BTN_INSTALL    = "Download VoiceMeeter"
    $BTN_REMOVE     = "Uninstall VoiceMeeter"
    $MSG_SUCCESS_T  = "Success"
    $MSG_SUCCESS_C  = "Voicemeeter has been licensed."
EndIf

Global $VM_Path = "C:\Program Files (x86)\VB\Voicemeeter\voicemeeter8.exe"
Global $VM_Uninstall = "C:\Program Files (x86)\VB\Voicemeeter\VoicemeeterPotatoSetup.exe"  ; Eğer farklıysa regedit'ten bak veya manuel değiştir

Opt("GUIOnEventMode", 0)

$width = 380
$height = 240

$gui = GUICreate($TXT_TITLE, $width, $height, -1, -1, _
        BitOR($WS_CAPTION, $WS_SYSMENU))


GUISetIcon("icon.ico")


GUICtrlCreateLabel($TXT_INFO, 0, 15, $width, 28, _
        BitOR($SS_CENTER, $SS_CENTERIMAGE))


$btnOpenVM   = GUICtrlCreateButton($BTN_LICENSE, 30, 60, 150, 38)
$btnCloseApp = GUICtrlCreateButton($BTN_CLOSE, 200, 60, 150, 38)


$btnInstall = GUICtrlCreateButton($BTN_INSTALL, 30, 130, 150, 38)
$btnRemove  = GUICtrlCreateButton($BTN_REMOVE, 200, 130, 150, 38)

GUISetState(@SW_SHOW)

While 1
    Switch GUIGetMsg()
        Case $GUI_EVENT_CLOSE
            Exit

        Case $btnOpenVM
			ProcessClose("VoicemeeterPotato.exe")
  			ProcessClose("Voicemeeter.exe")  ; 
    		Sleep(3000)  ; 
            RegWrite("HKEY_CURRENT_USER\VB-Audio\VoiceMeeter", "code", "REG_DWORD", 0x00123456)
			MsgBox($MB_ICONNONE, $MSG_SUCCESS_T, $MSG_SUCCESS_C)
			If FileExists($VM_Path) Then
			    Run('"' & $VM_Path & '" -r')  ; -r engine restart eder
			    MsgBox($MB_ICONINFORMATION, $MSG_SUCCESS_T, $MSG_SUCCESS_C & @CRLF & "Eğer challenge çıkarsa sistemi yeniden başlatmayı dene.")
			Else
			    MsgBox($MB_ICONERROR, "Hata", "Voicemeeter Potato bulunamadı. Path: " & $VM_Path)
			EndIf
        Case $btnCloseApp
            Exit

        Case $btnInstall
            ShellExecute("https://vb-audio.com/Voicemeeter/potato.htm")

        Case $btnRemove
            UninstallVoiceMeeter()
    EndSwitch
WEnd


Func RunVoiceMeeter()
    Local $path = "C:\Program Files (x86)\VB\Voicemeeter\voicemeeter.exe"
    If FileExists($path) Then
        Run('"' & $path & '"')
    Else
        MsgBox($MB_ICONERROR, "Hata", "VoiceMeeter bulunamadi.")
    EndIf
EndFunc

Func UninstallVoiceMeeter()
    Local $uninstall = _
        "C:\Program Files (x86)\VB\Voicemeeter\Voicemeeter8Setup.exe"

    If FileExists($uninstall) Then
        Local $ans = MsgBox(BitOR($MB_YESNO, $MB_ICONWARNING), _
            "Onay", "VoiceMeeter kaldirilacak. Devam edilsin mi?")

        If $ans = $IDYES Then
            Run('"' & $uninstall & '" /S')
        EndIf
    Else
        MsgBox($MB_ICONERROR, "Hata", "Kaldirici bulunamadi.")
    EndIf
EndFunc




#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.5
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

#include <MsgBoxConstants.au3>
#include <Array.au3>
#include <FileConstants.au3>
#include <File.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>

#include <ButtonConstants.au3>
#include <StaticConstants.au3>

#include <GuiEdit.au3>
HotKeySet("{ESC}", "HotKeyPressed")
HotKeySet("{a}", "HotKeyPressed")
HotKeySet("{z}", "HotKeyPressed")
HotKeySet("{s}", "HotKeyPressed")
HotKeySet("{c}", "HotKeyPressed")
HotKeySet("{n}", "HotKeyPressed")
Global $sizeTab = 10000
Global $postab[$sizeTab][2]
Global $currSize = 0

func addPoint($x,$y)

;~    ConsoleWrite($currSize & @CRLF)
   $postab[$currSize][0] = $x
   $postab[$currSize][1] = $y
   $currSize=$currSize+1
EndFunc


func buyOil()
;~    _ArrayDisplay($postab,"$postab")
   while 1
	  for $i = 0 to $currSize - 1
		 MouseClick($MOUSE_CLICK_LEFT,$postab[$i][0],$postab[$i][1],1,10)
		 ConsoleWrite( $i & @CRLF)
;~ 		 MouseMove($postab[$i][0],$postab[$i][1],10)
		 local $a = MouseGetPos()
		 ConsoleWrite( "pos actuelle : " & $a[0] & " " & $a[1] & @CRLF)
;~ ConsoleWrite(1)
		 Sleep(1000)
	  Next
   WEnd
EndFunc
;~ sleep(5000)
;~ buyOil()
while 1
   sleep(20)
WEnd


func loadSeq()

   local $installKitList = _FileListToArray(@ScriptDir & "/mesSequences/", "*" , $FLTA_FILES, true)
   local $listToComboString = ""
   _ArraySort($installKitList, 0)
   for $i = 1 to UBound($installKitList) - 1
;~ 	  _msgbox(StringInStr($installKitList[$i],"\",0,-1))
;~ 	  _msgbox("'"&StringMid($installKitList[$i], StringInStr($installKitList[$i],"\",0,-1) + 1)&"'")
	  $listToComboString &= StringMid($installKitList[$i], StringInStr($installKitList[$i],"\",0,-1) + 1) & "|"
   Next


   local $fenetre = GUICreate( "Sequence à chargée", 300, 100)
   local $myCombo = GUICtrlCreateCombo("", 0,10,150,50)
   GUICtrlSetData($myCombo, $listToComboString)
   local $btOK = GUICtrlCreateButton("ok", 0, 60)
   GUISetState(@SW_SHOW)
   Local $aMsg = 0

   Do
	 ; Assigne à $aMsg les messages GUI avancés.
	 $aMsg = GUIGetMsg(1)

	 ; Selon la GUI
	 Switch $aMsg[1]
	 Case $fenetre
		 Switch $aMsg[0]
		 Case $btOK
			local $fileToTransfert = GUICtrlRead($myCombo)
;~ 			local $fileToTransfert = "testTransfert.txt" ;pour test

;~ 			_msgbox("EnvoieFtp("&@ScriptDir & "\"&$fileToTransfert&","& $fileToTransfert&")")
			if StringLen($fileToTransfert) > 0 then
			   parseSeqFromFile($fileToTransfert)
			EndIf

			GUIDelete($fenetre)
;~ 			exit
		 EndSwitch

	 EndSwitch

   Until $aMsg[0] = $GUI_EVENT_CLOSE
;~    _ArrayDisplay($installKitList,"$installKitList")
EndFunc
func parseSeqFromFile($file)
   Global $postab[$sizeTab][2] ;vide le tableau
   $currSize = 0 ;remet la taille reelle a 0
   $file = @ScriptDir & "/mesSequences/"& $file
   local $filehandler = FileOpen($file)
   local $fileContent = FileRead($filehandler)
   ConsoleWrite($file)
   ConsoleWrite($fileContent)
   local $lines = StringSplit($fileContent, @crlf)
;~    _ArrayDisplay($lines, "$lines")
   for $i = 1 to UBound($lines) - 1

	  if StringLen($lines[$i] ) < 3 Then
		 ContinueLoop
	  EndIf
	  local $coords = StringSplit($lines[$i], ";")
;~ 	  _ArrayDisplay($coords, $lines[$i])
	  addPoint($coords[1],$coords[2])
   Next
EndFunc
func saveSequence()
   local $dossierSequence = @ScriptDir & "/mesSequences/"
   DirCreate($dossierSequence)
   Local $sAnswer = InputBox("Sauvegarder la sequence", "nom de la sequence (vide=annuler)", "", "", -1, -1, 0, 0)
   if StringLen($sAnswer) = 0 Then
	  Return
   EndIf
   if FileExists($dossierSequence & $sAnswer) Then
	  local $ecraser = MsgBox($MB_YESNO, "Ecraser ?", "La sequence " & $sAnswer & " éxiste déjà voulez vous la remplacer ?")
	  if $ecraser = $IDNO Then
		 return saveSequence()
	  EndIf
   EndIf
   Local $hFileOpen = FileOpen($dossierSequence & $sAnswer, $FO_OVERWRITE)
   local $content = ""
   for $i = 0 to $currSize - 1
	  $content = $content & $postab[$i][0] & ";" & $postab[$i][1] & @CRLF
   Next
   ConsoleWrite($content & @crlf)
   FileWrite($hFileOpen, $content)
EndFunc
func HotKeyPressed()
   ConsoleWrite(@HotKeyPressed&@CRLF)
   local $x = 0
   local $y = 0
   Switch @HotKeyPressed ; Le dernier raccourci utilisé.
        Case "{ESC}" ; la chaîne est le raccourci {PAUSE}.
			saveSequence()
			exit
		 Case "{a}" ; la chaîne est le raccourci {PAUSE}.
			ConsoleWrite("a"&@crlf)
			   local $a = MouseGetPos()
			   addPoint($a[0],$a[1])

		 Case "{z}" ; la chaîne est le raccourci {PAUSE}.
			buyOil()
			exit
		 Case "{s}" ; la chaîne est le raccourci {PAUSE}.
			saveSequence()
		 Case "{c}" ; la chaîne est le raccourci {PAUSE}.
			loadSeq()
		 Case "{n}" ; la chaîne est le raccourci {PAUSE}.
			Global $postab[$sizeTab][2] ;vide le tableau
			$currSize = 0 ;remet la taille reelle a 0




		 EndSwitch
EndFunc

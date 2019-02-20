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
HotKeySet("{ESC}", "HotKeyPressed")
HotKeySet("{a}", "HotKeyPressed")
HotKeySet("{z}", "HotKeyPressed")
HotKeySet("{s}", "HotKeyPressed")
Global $sizeTab = 10000
Global $postab[$sizeTab][2]
Global $currSize = 0

func addPoint($x,$y)

;~    ConsoleWrite($currSize & @CRLF)
   $postab[$currSize][0] = $x
   $postab[$currSize][1] = $y
   $currSize=$currSize+1
EndFunc

;~ addPoint(630,468)
;~ addPoint(499,342)
;~ addPoint(206,467)
;~ addPoint(909,369)
;~ addPoint(811,539)
;~ addPoint(810,589)
;~ addPoint(810,589)
;~ addPoint(846,649)
;~ addPoint(791,510)
;~ addPoint(791,510)
;~ addPoint(1402,88)
;~ addPoint(1302,596)
;~ addPoint(408,230)
;~ addPoint(1039,303)
;~ addPoint(845,353)
;~ addPoint(797,514)
;~ addPoint(730,476)
;~ addPoint(906,398)
;~ addPoint(745,468)
;~ addPoint(742,526)
;~ addPoint(894,476)
;~ addPoint(865,486)
;~ addPoint(862,697)
;~ addPoint(852,473)
;~ addPoint(862,697)
;~ addPoint(852,473)
;~ addPoint(1399,91)
;~ addPoint(3,4)
;~ _ArrayDisplay($postab,"$postab")
func buyOil()
   while 1
	  for $i = 0 to $currSize - 1
		 MouseClick($MOUSE_CLICK_LEFT,$postab[$i][0],$postab[$i][1],1,10)
		 ConsoleWrite( $i & @CRLF)
;~ 		 MouseMove($postab[$i][0],$postab[$i][1],10)
;~ 		 local $a = MouseGetPos()
;~ 		 ConsoleWrite( "pos actuelle : " & $a[0] & " " & $a[1] & @CRLF)
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

   Global $postab[$sizeTab][2] ;vide le tableau
   $currSize = 0 ;remet la taille reelle a 0
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




		 EndSwitch
EndFunc

#Persistent  ; Keep this script running until the user explicitly exits it.
#InstallKeybdHook
#SingleInstance force
Menu, Tray, Icon , controller.ico
SetTimer, WatchAxis, 5

;; -- this is the main object that contains all the button mapping and functions
global mainData                                                         := Object()
mainData["default"]                                                     := Object()
mainData["default"]["default"]                                          := Object()
mainData["default"]["default"]["a"]                                     := ["Enter",        "key", "slow", "Enter / Confirm"]
mainData["default"]["default"]["b"]                                     := ["Escape",       "key", "slow", "Escape / Back"]
mainData["default"]["default"]["x"]                                     := ["x",            "key", "slow", "Auto Explore"]
mainData["default"]["default"]["y"]                                     := ["i",            "key", "slow", "Inventory Mode", "inventory_mode"]
mainData["default"]["default"]["start"]                                 := ["M",            "key", "slow", "Log"]
mainData["default"]["default"]["back"]                                  := ["?",            "key", "slow", "Help", "help_mode"]
mainData["default"]["default"]["xbox"]                                  := ["D",            "key", "slow", "Discovered Items"]
mainData["default"]["default"]["right_shoulder_button"]                 := ["Z",            "key", "slow", "Rest Once"]
mainData["default"]["default"]["left_shoulder_button"]                  := ["z",            "key", "slow", "Rest 100"]
mainData["default"]["default"]["hat_up"]                                := ["<",            "key", "slow", "Up Stairs"]
mainData["default"]["default"]["hat_down"]                              := [">",            "key", "slow", "Down Stairs"]
mainData["default"]["default"]["hat_left"]                              := ["s",            "key", "slow", "Search"]
mainData["default"]["default"]["left_stick_up"]                         := ["Up",           "key", "slow", "Move Up"]
mainData["default"]["default"]["left_stick_down"]                       := ["Down",         "key", "slow", "Move Down"]
mainData["default"]["default"]["left_stick_left"]                       := ["Left",         "key", "slow", "Move Left"]
mainData["default"]["default"]["left_stick_right"]                      := ["Right",        "key", "slow", "Move Right"]
mainData["default"]["default"]["right_stick_up"]                        := ["Up",           "key", "fast", "Move Up Fast"]
mainData["default"]["default"]["right_stick_down"]                      := ["Down",         "key", "fast", "Move Down Fast"]
mainData["default"]["default"]["right_stick_left"]                      := ["Left",         "key", "fast", "Move Left Fast"]
mainData["default"]["default"]["right_stick_right"]                     := ["Right",        "key", "fast", "Move Right Fast"]
mainData["default"]["shift"]                                            := Object()
mainData["default"]["shift"]["a"]                                       := ["y",            "key", "slow", "Yes"]
mainData["default"]["shift"]["b"]                                       := ["n",            "key", "slow", "Nott"]
mainData["default"]["shift"]["start"]                                   := ["n",            "key", "slow", "Log"]
mainData["default"]["shift"]["hat_up"]                                  := ["a",            "key", "slow", "Shortcut A"]
mainData["default"]["shift"]["hat_down"]                                := ["c",            "key", "slow", "Shortcut B"]
mainData["default"]["shift"]["hat_left"]                                := ["d",            "key", "slow", "Shortcut C"]
mainData["default"]["shift"]["hat_right"]                               := ["b",            "key", "slow", "Shortcut D"]
mainData["default"]["shift"]["left_stick_up"]                           := ["Numpad9",      "key", "slow", "North East"]
mainData["default"]["shift"]["left_stick_down"]                         := ["Numpad1",      "key", "slow", "South West"]
mainData["default"]["shift"]["left_stick_left"]                         := ["Numpad7",      "key", "slow", "South East"]
mainData["default"]["shift"]["left_stick_right"]                        := ["Numpad3",      "key", "slow", "North West"]
mainData["default"]["shift"]["right_stick_up"]                          := ["^Up",          "key", "fast", "Move Up Fast"]
mainData["default"]["shift"]["right_stick_down"]                        := ["^Down",        "key", "fast", "Move Down Fast"]
mainData["default"]["shift"]["right_stick_left"]                        := ["^Left",        "key", "fast", "Move Left Fast"]
mainData["default"]["shift"]["right_stick_right"]                       := ["^Right",       "key", "fast", "Move Right Fast"]
mainData["inventory_mode"]                                              := Object()
mainData["inventory_mode"]["default"]                                   := Object()
mainData["inventory_mode"]["default"]["a"]                              := ["a",            "key", "slow", "Apply", "exit"]
mainData["inventory_mode"]["default"]["b"]                              := ["Escape",       "key", "slow", "Exit", "exit"]
mainData["inventory_mode"]["default"]["x"]                              := ["e",            "key", "slow", "Equip", "exit"]
mainData["inventory_mode"]["default"]["y"]                              := ["r",            "key", "slow", "Remove", "exit"]
mainData["inventory_mode"]["default"]["hat_up"]                         := ["c",            "key", "slow", "Call", "exit"]
mainData["inventory_mode"]["default"]["hat_down"]                       := ["d",            "key", "slow", "Drop", "exit"]
mainData["inventory_mode"]["default"]["right_shoulder_trigger"]         := ["t",            "key", "slow", "Throw", "exit"]
mainData["inventory_mode"]["default"]["right_shoulder_button"]          := ["R",            "key", "slow", "Relabel", "exit"]
mainData["inventory_mode"]["default"]["left_stick_up"]                  := ["Up",           "key", "slow", "Move Up"]
mainData["inventory_mode"]["default"]["left_stick_down"]                := ["Down",         "key", "slow", "Move Down"]
mainData["inventory_mode"]["default"]["left_stick_left"]                := ["Left",         "key", "slow", "Move Left"]
mainData["inventory_mode"]["default"]["left_stick_right"]               := ["Right",        "key", "slow", "Move Right"]
mainData["inventory_mode"]["default"]["right_stick_up"]                 := ["Up",           "key", "fast", "Move Up Fast"]
mainData["inventory_mode"]["default"]["right_stick_down"]               := ["Down",         "key", "fast", "Move Down Fast"]
mainData["inventory_mode"]["default"]["right_stick_left"]               := ["Left",         "key", "fast", "Move Left Fast"]
mainData["inventory_mode"]["default"]["right_stick_right"]              := ["Right",        "key", "fast", "Move Right Fast"]
mainData["help_mode"]                                                   := Object()
mainData["help_mode"]["default"]                                        := Object()
mainData["help_mode"]["default"]["b"]                                   := ["Escape",       "key", "slow", "Exit", "exit"]
mainData["help_mode"]["default"]["a"]                                   := ["Escape",       "key", "slow", "Exit", "exit"]

; Auto-detect the joystick number if called for:
if JoystickNumber <= 0
{
  Loop 16  ; Query each joystick number to find out which ones exist.
  {
      GetKeyState, JoyName, %A_Index%JoyName
      if JoyName <>
      {
          JoystickNumber = %A_Index%
          break
      }
  }
  if JoystickNumber <= 0
  {
      MsgBox The system does not appear to have any joysticks.
      ExitApp
  }
}

; the button function has to be routed through labels unfortunatly
Hotkey, %JoystickNumber%Joy1, myjoy1
Hotkey, %JoystickNumber%Joy2, myjoy2
Hotkey, %JoystickNumber%Joy3, myjoy3
Hotkey, %JoystickNumber%Joy4, myjoy4
Hotkey, %JoystickNumber%Joy5, myjoy5
Hotkey, %JoystickNumber%Joy6, myjoy6
Hotkey, %JoystickNumber%Joy7, myjoy7
Hotkey, %JoystickNumber%Joy8, myjoy8
Hotkey, %JoystickNumber%Joy9, myjoy9
Hotkey, %JoystickNumber%Joy10, myjoy10
Hotkey, %JoystickNumber%Joy11, myjoy11

; these track the mode states
global shiftmode := 0
global currentmode

;; ---------------------------------------  end of autoexec --------------------------------------------
return

;; -- this is the main function that powers the non analog buttons and their logic
buttonFunction(buttonName){

  ; if we are currently in a mode use the mode name in variable
	if (currentmode != "") {

		; account for shift mode
    if (shiftmode = 1){
      buttonToSend := mainData[currentmode]["shift"][buttonName][1]
    } else {
      buttonToSend := mainData[currentmode]["default"][buttonName][1]
    }
    
    ; check if the button stipulates it exits the mode
    exitCheck := mainData[currentmode]["default"][buttonName][5]
    if(exitCheck = "exit"){
      currentmode =
    }

  ; if we are in shift mode use the default shift mode assignment
  } else if (shiftmode = 1){
    buttonToSend := mainData["default"]["shift"][buttonName][1]

  ; if no modes are active use the default assignment
  } else {
	  buttonToSend := mainData["default"]["default"][buttonName][1]
	}

  ; if we pressed a button that enters a mode, we need to set that as the current mode
  modeCheck := mainData["default"]["default"][buttonName][5]
  if(modeCheck){
    currentmode := modeCheck
  } 

  ; send the actual button press
	Send {%buttonToSend%}
}

;; This is the main function that watches for analog control changes
;;------------------------------------------------------------------------
WatchAxis:
	GetKeyState, 2JoyX, %JoystickNumber%JoyX  ; Get position of X axis.
	GetKeyState, 2JoyY, %JoystickNumber%JoyY  ; Get position of Y axis.
	GetKeyState, 2JoyU, %JoystickNumber%JoyU  ; Get position of Y axis.
	GetKeyState, 2JoyV, %JoystickNumber%JoyV  ; Get position of Y axis.
	GetKeyState, 2JoyR, %JoystickNumber%JoyR  ; Get position of Y axis.
	GetKeyState, 2JoyZ, %JoystickNumber%JoyZ  ; Get position of Y axis.
	GetKeyState, 2JoyPOV, %JoystickNumber%JoyPOV  ; Get position of Y axis.
	KeyToHoldDownPrev = %KeyToHoldDown%  ; Prev now holds the key that was down before (if any).

  ; shift mode is global so lets just track it here like this
	if 2JoyZ > 20 ; ------------------------------------------------------------------------- left trigger
		shiftmode = 1
	else
		shiftmode = 0

  ; here we just load the variable that tracks which control has been activated
	if (2JoyX > 70) { ; --------------------------------------------------------------------- left_stick_right
		;MsgBox, test
    pressedButton := "left_stick_right"
	} else if (2JoyX < 30) { ; -------------------------------------------------------------- left_stick_left
    pressedButton := "left_stick_left"
	} else if (2JoyY > 70) { ; -------------------------------------------------------------- left_stick_down
    pressedButton := "left_stick_down"
	} else if (2JoyY < 30) { ; -------------------------------------------------------------- left_stick_up
    pressedButton := "left_stick_up"
	} else if (2JoyV > 70) { ; -------------------------------------------------------------- right_stick_right
    pressedButton := "right_stick_right"
	} else if (2JoyV < 30) { ; -------------------------------------------------------------- right_stick_left
    pressedButton := "right_stick_left"
	} else if (2JoyU > 70) { ; -------------------------------------------------------------- right_stick_down
    pressedButton := "right_stick_down"
	} else if (2JoyU < 30) { ; -------------------------------------------------------------- right_stick_up
    pressedButton := "right_stick_up"
	} else if (2JoyR > 40) { ; -------------------------------------------------------------- right_shoulder_trigger
    pressedButton := "right_shoulder_trigger"
	} else if (2JoyPOV > -1 and 2JoyPOV < 8999) { ; ----------------------------------------- hat_up
    pressedButton := "hat_up"
	} else if (2JoyPOV > 8999 and 2JoyPOV < 17999) { ; -------------------------------------- hat_right
    pressedButton := "hat_right"
	} else if (2JoyPOV > 17999 and 2JoyPOV < 26999) { ; ------------------------------------- hat_down
    pressedButton := "hat_down"
	} else if (2JoyPOV > 26999) { ; --------------------------------------------------------- hat_left
    pressedButton := "hat_left"
	} else {
		pressedButton =
	}

  ; if we pressed a button we need to run through potential modes
	if (pressedButton != ""){

		; if we are in a mode currently
		if (currentmode != "") {

			; account for shift mode
			if(shiftmode = 1){
	      KeyToHoldDown := mainData[currentmode]["shift"][pressedButton][1]
	      gofast := mainData[currentmode]["shift"][pressedButton][3]
			} else {
		    KeyToHoldDown := mainData[currentmode]["default"][pressedButton][1]
	      gofast := mainData[currentmode]["default"][pressedButton][3]			
			}
    
    ; if we are in shift mode
	  } else if(shiftmode = 1){
	    KeyToHoldDown := mainData["default"]["shift"][pressedButton][1]
	    gofast := mainData["default"]["shift"][pressedButton][3]

	  ; if no modes are active
		} else {
		  KeyToHoldDown := mainData["default"]["default"][pressedButton][1]
		  gofast := mainData["default"]["default"][pressedButton][3]
		}
	} else {
		KeyToHoldDown =
		gofast =
	}


	; here we test to see if the keypress should be a rapidly repeated keypress or just pressed once
	if(gofast = "fast"){
		if KeyToHoldDown = %KeyToHoldDownPrev%  ; The correct key is already down (or no key is needed).
		{
			if KeyToHoldDown
				SetKeyDelay 100
				Send, {%KeyToHoldDown% down}  ; Auto-repeat the keystroke.
			return
		}
	} else {
		if KeyToHoldDown = %KeyToHoldDownPrev%  ; The correct key is already down (or no key is needed).
			return  ; Do nothing.
	}

	; Otherwise, release the previous key and press down the new key:
	SetKeyDelay -1  ; Avoid delays between keystrokes.
	if KeyToHoldDownPrev   ; There is a previous key to release.
		Send, {%KeyToHoldDownPrev% up}  ; Release it.
	if KeyToHoldDown   ; There is a key to press down.
		Send, {%KeyToHoldDown% down}  ; Press it down.
return

; main non analog button remaping
; ------------------------------------------------------------------------------

myjoy1: ; --------------------------------------------------------------------- a
	buttonFunction("a")
Return

myjoy2: ; --------------------------------------------------------------------- b
	buttonFunction("b")
Return

myjoy3: ; --------------------------------------------------------------------- x
	buttonFunction("x")
Return

myjoy4: ; --------------------------------------------------------------------- y
	buttonFunction("y")
Return

myjoy5: ;  -------------------------------------------------------------------- left_shoulder_button
	buttonFunction("left_shoulder_button")
Return

myjoy6: ; --------------------------------------------------------------------- right_shoulder_button
	buttonFunction("right_shoulder_button")
Return

myjoy7: ; --------------------------------------------------------------------- back
	buttonFunction("back")
Return

myjoy8: ; --------------------------------------------------------------------- start
	buttonFunction("start")
Return

myjoy9: ; --------------------------------------------------------------------- left_stick_button
	buttonFunction("left_stick_button")
Return

myjoy10: ; -------------------------------------------------------------------- left_stick_down_button
	buttonFunction("left_stick_down_button")
Return

myjoy11: ; -------------------------------------------------------------------- xbox
	buttonFunction("xbox")
Return


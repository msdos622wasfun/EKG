// Project: EKG 
// Created: 2015-10-31

/*

	EKG
	Version 1.02
	Copyleft 2020 by Erich Kohl
	
	A simple little graphics demo/screensaver
	that simulates the rhythm of a heartbeat
	on an electrocardiograph.
	
	Feel free to use this code.
	
	Send comments/questions to:
	ekohl1972@outlook.com
	
*/

#option_explicit

dim colorPalette[8] as integer
dim spritesHearts[11] as integer
dim heartsSpeed_X[11] as integer
dim heartsSpeed_Y[11] as integer
global fullScreen as integer
global colorIndex as integer
global showHearts as integer
global playBeep as integer

Initialize()
Main()

end

function DemoLoop()

	x1 as integer
	x2 as integer
	x as integer
	y as integer
	centerY as integer
	beatTopY as integer
	beatBotY as integer
	interval as integer

	x1 = 0

	centerY = 400
	beatTopY = 150
	beatBotY = 800 - 150
	
	interval = 100

	if showHearts = 1 then HeartsCreate()
	
	do
		// Draw the grid first so it stays in the background
		for x = 40 to 1240 step 40
			DrawLine(x, 0, x, 800, 64, 64, 64)
		next x	
		for y = 40 to 760 step 40
			DrawLine(0, y, 1280, y, 64, 64, 64)
		next y
		inc x1
		x2 = 0
		do
			if mod(x2, interval) = 0
				DrawLine(x2, centerY, x2 + 10, beatTopY, colorPalette[colorIndex], colorPalette[colorIndex])
				DrawLine(x2 + 1, centerY, x2 + 11, beatTopY, colorPalette[colorIndex], colorPalette[colorIndex])
				DrawLine(x2 + 2, centerY, x2 + 12, beatTopY, colorPalette[colorIndex], colorPalette[colorIndex])
				inc x2, 12
				DrawLine(x2, beatTopY, x2 + 10, beatBotY, colorPalette[colorIndex], colorPalette[colorIndex])
				DrawLine(x2 + 1, beatTopY, x2 + 11, beatBotY, colorPalette[colorIndex], colorPalette[colorIndex])
				DrawLine(x2 + 2, beatTopY, x2 + 12, beatBotY, colorPalette[colorIndex], colorPalette[colorIndex])
				inc x2, 12
				DrawLine(x2, beatBotY, x2 + 10, centerY, colorPalette[colorIndex], colorPalette[colorIndex])
				DrawLine(x2 + 1, beatBotY, x2 + 11, centerY, colorPalette[colorIndex], colorPalette[colorIndex])
				DrawLine(x2 + 2, beatBotY, x2 + 12, centerY, colorPalette[colorIndex], colorPalette[colorIndex])
				inc x2, 12
			else
				if mod(x1, interval) = 0
					if playBeep = 1 then PlaySound(1)
					inc x1, 36
				endif
				DrawLine(x2, centerY - 1, x2, centerY - 1, colorPalette[colorIndex], colorPalette[colorIndex])
				DrawLine(x2, centerY, x2, centerY, colorPalette[colorIndex], colorPalette[colorIndex])
				DrawLine(x2, centerY + 1, x2, centerY + 1, colorPalette[colorIndex], colorPalette[colorIndex])
			endif
			inc x2
			if x2 > x1 then exit
		loop
		
		if showHearts = 1 then HeartsMove()

		Sync()
		
		if GetRawKeyState(38) = 1
			dec interval
			if interval < 40 then interval = 40
		endif
		
		if GetRawKeyState(40) = 1
			inc interval
			if interval > 200 then interval = 200
		endif
		
		if GetRawKeyReleased(70) = 1
			if fullScreen = 0
				fullScreen = 1
				SetWindowSize(1280, 800, 1)
				SetVirtualResolution(1280, 800)
			else
				fullScreen = 0
				SetWindowSize(1280, 800, 0)
				SetVirtualResolution(1280, 800)
			endif
		endif
		
		if GetRawKeyReleased(67)
			inc colorIndex
			if colorIndex > 7 then colorIndex = 0
		endif
		
		if GetRawKeyReleased(72) = 1
			if showHearts = 0
				showHearts = 1
				HeartsCreate()
			else
				showHearts = 0
				HeartsDestroy()
			endif
		endif
		
		if GetRawKeyReleased(27) = 1
			if showHearts = 1 then HeartsDestroy()
			ClearScreen()
			exit
		endif
		
		if GetRawKeyReleased(83) = 1
			if playBeep = 1
				playBeep = 0
			else
				playBeep = 1
			endif
		endif

		if x1 >= 1280
			ClearScreen()
			x1 = 0
		endif

	loop
		
endfunction

function HeartsCreate()
	
	a as integer
	scale as integer
	
	for a = 1 to 10
		spritesHearts[a] = CreateSprite(1)
		SetSpritePosition(spritesHearts[a], Random(0, 1280), Random(0, 800))
		heartsSpeed_X[a] = Random(0, 10)
		dec heartsSpeed_X[a], 5
		heartsSpeed_Y[a] = Random(0, 10)
		dec heartsSpeed_Y[a], 5
		//scale = Random(1, 5)
		//SetSpriteScale(spritesHearts[a], scale, scale)
		SetSpriteScale(spritesHearts[a], .05, .05)
	next a
	
endfunction

function HeartsDestroy()
	
	DeleteAllSprites()
	
endfunction
	
function HeartsMove()
	
	a as integer
	x as integer
	y as integer
	
	for a = 1 to 10
		x = GetSpriteX(spritesHearts[a])
		y = GetSpriteY(spritesHearts[a])
		inc x, heartsSpeed_X[a]
		inc y, heartsSpeed_Y[a]
		if x < 0 then x = 1280
		if x > 1280 then x = 0
		if y < 0 then y = 800
		if y > 800 then y = 0
		SetSpritePosition(spritesHearts[a], x, y)
	next a
	
endfunction

function Initialize()
	
	fullScreen = 0
	colorIndex = 0
	showHearts = 0
	playBeep = 0
	
	colorPalette[0] = MakeColor(0, 255, 0)
	colorPalette[1] = MakeColor(255, 0, 0)
	colorPalette[2] = MakeColor(0, 0, 255)
	colorPalette[3] = MakeColor(255, 255, 0)
	colorPalette[4] = MakeColor(0, 255, 255)
	colorPalette[5] = MakeColor(255, 0, 255)
	colorPalette[6] = MakeColor(255, 128, 0)
	colorPalette[7] = MakeColor(255, 255, 255)
	
	SetWindowTitle("EKG")
	SetWindowSize(1280, 800, 0)
	SetVirtualResolution(1280, 800)
	SetSyncRate(60, 0)

	LoadImage(1, "Heart 001.png")
	LoadSound(1, "Beep.wav")
	
endfunction

function Main()

	a as integer
	quit as integer

	quit = 0
	
	repeat

		CreateText(1, "EKG")
		SetTextPosition(1, 640, 185)
		SetTextSize(1, 50)
		SetTextAlignment(1, 1)
		SetTextColor(1, 255, 255, 0, 255)
		
		CreateText(2, "Version 1.02")
		SetTextPosition(2, 640, 235)
		SetTextSize(2, 25)
		SetTextAlignment(2, 1)
		SetTextColor(2, 0, 255, 255, 255)
		
		CreateText(3, "Copyleft 2020 by Erich Kohl")
		SetTextPosition(3, 640, 260)
		SetTextSize(3, 25)
		SetTextAlignment(3, 1)
		SetTextColor(3, 0, 255, 255, 255)
		
		CreateText(4, "Use these commands during the demo:")
		SetTextPosition(4, 640, 310)
		SetTextSize(4, 25)
		SetTextAlignment(4, 1)
		
		CreateText(5, "Up-arrow           Increase BPM")
		SetTextPosition(5, 640, 360)
		SetTextSize(5, 25)
		SetTextAlignment(5, 1)
		
		CreateText(6, "Down-arrow         Decrease BPM")
		SetTextPosition(6, 640, 385)
		SetTextSize(6, 25)
		SetTextAlignment(6, 1)
		
		CreateText(7, "C                         Color")
		SetTextPosition(7, 640, 410)
		SetTextSize(7, 25)
		SetTextAlignment(7, 1)
		
		CreateText(8, "F                   Full-screen")
		SetTextPosition(8, 640, 435)
		SetTextSize(8, 25)
		SetTextAlignment(8, 1)
		
		CreateText(9, "H                        Hearts")
		SetTextPosition(9, 640, 460)
		SetTextSize(9, 25)
		SetTextAlignment(9, 1)
		
		CreateText(10, "S                         Sound")
		SetTextPosition(10, 640, 485)
		SetTextSize(10, 25)
		SetTextAlignment(10, 1)
		
		CreateText(11, "Esc                        Quit")
		SetTextPosition(11, 640, 510)
		SetTextSize(11, 25)
		SetTextAlignment(11, 1)
		
		CreateText(12, "Press Enter to run the demo or Esc to exit.")
		SetTextPosition(12, 640, 560)
		SetTextSize(12, 25)
		SetTextAlignment(12, 1)
		
		do
			DrawBox(100, 100, 1180, 700, colorPalette[2], colorPalette[2], colorPalette[2], colorPalette[2], 0)
			Sync()
			if GetRawKeyReleased(13) = 1
				for a = 1 to 12
					DeleteText(a)
				next a
				ClearScreen()
				Sync()
				DemoLoop()
				exit
			elseif GetRawKeyReleased(70) = 1
				if fullScreen = 0
					fullScreen = 1
					SetWindowSize(1280, 800, 1)
					SetVirtualResolution(1280, 800)
				else
					fullScreen = 0
					SetWindowSize(1280, 800, 0)
					SetVirtualResolution(1280, 800)
				endif
			elseif GetRawKeyReleased(27) = 1
				quit = 1
				exit
			endif
		loop
	
	until quit = 1
	
endfunction

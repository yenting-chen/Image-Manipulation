
;========================================================
; Student Name:陳彥廷
; Student ID:0216018
; Email:ian9696@kimo.com
;========================================================
; Instructor: Sai-Keung WONG
; Email: cswingo@cs.nctu.edu.tw
; Room: 706
; Assembly Language 
;========================================================
; Description:

INCLUDE Irvine32.inc
INCLUDE Macros.inc

invisibleDigitX  TEXTEQU %(-100000)
invisibleDigitY  TEXTEQU %(-100000)

; PROTO C is to make agreement on calling convention for INVOKE

c_updatePositionsOfAllObjects PROTO C

ShowSubRegionAtLoc PROTO,
	x : DWORD, y: DWORD, w : DWORD, h : DWORD, x0 : DWORD, y0 : DWORD
	
computeLocationOfPixelInImage PROTO,
	x0 : DWORD, y0 : DWORD, w : DWORD, h : DWORD

swapPickedGridCellandCurGridCellRegion PROTO

.data 
colors BYTE 01ch
colorOriginal BYTE 01ch


MYINFO	BYTE "My Student Name: 陳彥廷: StudentID: 0216018", 0

OpenMsgDelay	DWORD	1
;OpenMsgDelay	DWORD	25
EnterStageDelay	DWORD	50

MyMsg BYTE "Final Project for Assembly Language...",0dh, 0ah
BYTE "My Student Name: 陳彥廷",0dh, 0ah 
BYTE "My student ID: 0216018.", 0dh, 0ah, 0dh, 0ah
BYTE "My Email is: ian9696@kimo.com.", 0dh, 0ah, 0dh, 0ah
BYTE "Make sure the screen dimension is (120, 30).", 0dh, 0ah, 0dh, 0ah
BYTE "Key usages:", 0dh, 0ah
BYTE "w (gray), g (grid)", 0dh, 0ah
BYTE "r (reset), b (blue)", 0dh, 0ah
BYTE "8:2x4, 9:4x8, 0:8x8", 0dh, 0ah
BYTE "< (blending), > (blending)", 0dh, 0ah
BYTE "s: show student ID", 0dh, 0ah, 0

openingMsg	BYTE	"This program shows the student ID using bitmap and manipulates images....", 0dh
			BYTE	"Great programming.", 0dh, 0


EndingMsg	BYTE "Thanks for playing.", 0dh, 0ah
			BYTE "My name is: 陳彥廷.", 0dh, 0ah
			BYTE "My student ID is: 0216018.", 0dh, 0ah
			BYTE "Press ENTER to quit.", 0dh, 0ah, 0

windowWidth	DWORD 8000
windowHeight	DWORD 8000

scaleFactor	DWORD	128
canvasMinX	DWORD -4000	;-51200 at beginning
canvasMaxX	DWORD 4000	; 51200 at beginning
canvasMinY	DWORD -4000	;-51200 at beginning
canvasMaxY	DWORD 4000	; 51200 at beginning
;
particleRangeMinX REAL8 0.0
particleRangeMaxX REAL8 0.0
particleRangeMinY REAL8 0.0
particleRangeMaxY REAL8 0.0
;
tmpParticleY DWORD ?
;
particleSize DWORD  2
numParticles DWORD 20000
particleMaxSpeed DWORD 3

flgQuit		DWORD	0

numObjects	DWORD	105		; number of objects (rectangles/blocks)
objPosX		SDWORD	512 DUP(0)	; object x-coordinate
objPosY		SDWORD	512 DUP(0)	; object y-coordinate
objTypes	BYTE	512 DUP(0)	; object type
objSpeedX	SDWORD	512 DUP(1)
objSpeedY	SDWORD	512 DUP(0)	

;objColor : an array of object colors (red, green, blue)		
objColor	DWORD	0, 254, 254,
					254, 254, 254,
					0, 127, 0,
					2048 DUP(255)

goMsg		BYTE "Assembly Language: Final term Project.", 0dh, 0ah
			BYTE "This is my own work!", 0dh, 0ah, 0
bell		BYTE 0,0, 0
					
studentIDDigit DWORD 0
studentID	DWORD 0, 1

particleState BYTE 0

DIGIT_ALL		BYTE 1, 1, 1, 1
				BYTE 1, 1, 1, 1
				BYTE 1, 1, 1, 0dh
				BYTE 1, 1, 1, 1
				BYTE 1, 1, 1, 1

DIGIT_MO_0		BYTE 0, 0, 1, 0dh
				BYTE 0, 0, 0, 0dh
				BYTE 0, 0, 0, 0dh
				BYTE 0, 0, 0, 0dh
				BYTE 0, 0, 0, 0ffh
DIGIT_MO_SIZE = ($-DIGIT_MO_0)				
DIGIT_MO_1		BYTE 0, 1, 1, 0dh
				BYTE 0, 0, 0, 0dh
				BYTE 0, 0, 0, 0dh
				BYTE 0, 0, 0, 0dh
				BYTE 0, 0, 0, 0ffh
				
DIGIT_MO_2		BYTE 1, 1, 1, 0dh
				BYTE 0, 0, 0, 0dh
				BYTE 0, 0, 0, 0dh
				BYTE 0, 0, 0, 0dh
				BYTE 0, 0, 0, 0ffh
												
DIGIT_INDEX		DWORD	0
TOTALDIGITS		DWORD	3


DIGIT_0			BYTE 1, 1, 1, 0dh
				BYTE 1, 0, 1, 0dh
				BYTE 1, 0, 1, 0dh
				BYTE 1, 0, 1, 0dh
				BYTE 1, 1, 1, 0ffh
DIGIT_SIZE = ($-DIGIT_0)				
DIGIT_1			BYTE 1, 1, 1
				BYTE 1, 0, 1
				BYTE 1, 0, 1
				BYTE 1, 0, 1
				BYTE 1, 1, 1
				
DIGIT_2			BYTE 1, 1, 1
				BYTE 0, 0, 1
				BYTE 1, 1, 1
				BYTE 1, 0, 0
				BYTE 1, 1, 1
				
DIGIT_3			BYTE 0, 0, 1
				BYTE 0, 0, 1
				BYTE 0, 0, 1
				BYTE 0, 0, 1
				BYTE 0, 0, 1

DIGIT_4			BYTE 1, 1, 1
				BYTE 1, 0, 0
				BYTE 1, 1, 1
				BYTE 1, 0, 1
				BYTE 1, 1, 1

DIGIT_5			BYTE 1, 1, 1
				BYTE 1, 0, 1
				BYTE 1, 0, 1
				BYTE 1, 0, 1
				BYTE 1, 1, 1

DIGIT_6			BYTE 0, 0, 1
				BYTE 0, 0, 1
				BYTE 0, 0, 1
				BYTE 0, 0, 1
				BYTE 0, 0, 1

DIGIT_7			BYTE 1, 1, 1
				BYTE 1, 0, 1
				BYTE 1, 1, 1
				BYTE 1, 0, 1
				BYTE 1, 1, 1


stage				DWORD 0
currentDigit			DWORD 0
objPosForOneDigitX	SDWORD 1000 DUP(0)
objPosForOneDigitY	SDWORD 1000 DUP(0)
digitX SDWORD -8000
digitY SDWORD 25000
digitTimer DWORD 0
colorTimer DWORD 0
colorIndex DWORD 0

offsetImage DWORD 0

digitOffsetX DWORD 0
digitSpacingDFTWidth DWORD	2000
digitSpacingDFTHeight DWORD 2000

digitSpacingWidth DWORD	2000
digitSpacingHeight DWORD 2000

digitMaxSpeed DWORD 10
digitMaxDFTSpeed DWORD 10

digitWidth DWORD 0

totalColors	DWORD	0
;for blocks
colorRed	BYTE	10000 DUP(0)
colorGreen	BYTE	10000 DUP(0)
colorBlue	BYTE	10000 DUP(0)

movementDIR	BYTE	0
state		BYTE	0

imagePercentage DWORD	100

mImageStatus DWORD 0
mImagePtr0 BYTE 200000 DUP(?)	; the first image 
mImagePtr1 BYTE 200000 DUP(?)	; the second image
mImagePtr2 BYTE 200000 DUP(?)	; temporary storage
mTmpBuffer	BYTE	600 DUP(?)	; temporary storage
mImageWidth DWORD 256
mImageHeight DWORD 256
mBytesPerPixel DWORD 3
mImagePixelPointSize DWORD 6

mFlipX DWORD 0
mFlipY DWORD 1
mEnableBrighter DWORD 0
mAmountOfBrightness DWORD 1
mBrightnessDirection DWORD 0

;width and height
GridDimensionW	DWORD	8
GridDimensionH	DWORD	8
GridCellW			DWORD	1
GridCellH			DWORD	1
CurGridX		DWORD	0
CurGridY		DWORD	0
flgPickedGrid	DWORD	0
PickedGridX		DWORD	-1
PickedGridY		DWORD	-1

OldPickedGridX		DWORD	-1
OldPickedGridY		DWORD	-1

GridColorRed		BYTE	0
GridColorGreen		BYTE	0
GridColorBlue		BYTE	0


FlgSaveImage		BYTE	0
FlgRestoreImage		BYTE	0
FlgShowGrid			BYTE	0	
FlgYellowFlower		BYTE	0	
FlgBrigtenImage		BYTE	0	
FlgDarkenImage		BYTE	0	
FlgGrayLevelImage	BYTE	0	

programState		BYTE	0

toBlueMode		BYTE	0
toBlue			SDWORD	1
toBlueCount		SDWORD	1

showGridMode	BYTE	0
showGridType	BYTE	8	; 8:2x4, 9:4x8, 0:8x8

currentGridX	DWORD	0	; in pixels
currentGridY	DWORD	0
selected	BYTE	0		; 2:selected
selectedGridX	DWORD	0	; grid selected to copy from
selectedGridY	DWORD	0

currentGridColorForward		BYTE	1
currentGridColor			BYTE	100

objPosSpeed		SDWORD		50
objPosCount		SDWORD		80		;0~10000
showObj		BYTE	0


.code

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;void asm_InitializeApp()
;
;This function is called
;at the beginning of the program.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_InitializeApp PROC C USES eax edx edi 
	;
	; Need Modification
	;

	mov al, blue + white*16
	or al, 88h
	mov ah, 080h
	call SetTextColor
	mov edi, offset openingMsg
P0:
	mov al, [edi]
	inc edi
	cmp al, 0
	je P1
	cmp al, 0dh
	jne P2
	mWriteln " "
	jmp P0
P2:
	call writechar
	mov eax, OpenMsgDelay
	call delay
	jmp P0
P1:

	mov edx, offset bell
	call WriteString


	mov al, green
	or al, 08h	;變螢光
	call SetTextColor
	
	mWrite "Enter the maximum speed of a digit (integer):"
	call ReadInt
	cmp eax, 0
	jle L2
	mov particleMaxSpeed, eax
	mov objPosSpeed, eax
L2:
	mWrite "Enter the spacing for the blocks along the X-axis (integer):"
	call ReadInt
	cmp eax, 0
	jle L3
	mov digitSpacingWidth, eax
L3:
	mWrite "Enter the spacing for the blocks along the Y-axis (integer):"
	call ReadInt
	cmp eax, 0
	jle L4
	mov digitSpacingHeight, eax
L4:


	call asm_ClearScreen
	mov edx, offset goMsg
	call WriteString
	mWriteln " "

	ret
asm_InitializeApp ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;void setCursor(int x, int y)
;
;Set the position of the cursor 
;in the console (text) window.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
setCursor PROC C USES edx,
	x:DWORD, y:DWORD
	mov edx, y
	shl edx, 8
	xor edx, x
	call Gotoxy
	ret
setCursor ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;void asm_ClearScreen()
;
;Clear the screen.
;We can set text color if you want.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_ClearScreen PROC C USES eax
	mov al, white
	mov ah, 0
	call SetTextColor
	call clrscr
	ret
asm_ClearScreen ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;void asm_ShowTitle()
;
;Show the title of the program
;at the beginning.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_ShowTitle PROC C USES eax edx
	INVOKE setCursor, 0, 0
	xor eax, eax
	mov ah, 0h
	mov al, 0e1h
	call SetTextColor
	mov edx, offset MyMsg
	call WriteString
	ret
asm_ShowTitle ENDP

asm_computeCircularPosX PROC C
	ret
asm_computeCircularPosX ENDP

asm_GetNumParticles PROC C
	mov eax, numParticles
	ret
asm_GetNumParticles ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_GetParticleMaxSpeed PROC C
	mov eax, particleMaxSpeed
	ret
asm_GetParticleMaxSpeed ENDP

;int asm_GetParticleSize()
;
;Return the particle size.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_GetParticleSize PROC C
	mov eax, 2
	ret
asm_GetParticleSize ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;void asm_handleMousePassiveEvent( int x, int y )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_handleMousePassiveEvent PROC C USES eax ebx edx,
	x : DWORD, y : DWORD
	;
	;modify this procedure
	;
	mov eax, x
	mWrite "x:"
	call WriteDec
	mWriteln " "
	mov eax, y
	mWrite "y:"
	call WriteDec
	mWriteln " "

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	mov ebx, 8
	mov al, showGridType
	cmp al, 8
	jne L1
		mov ebx, 4
	jmp L2
L1:
	cmp al, 9
	jne L2
		mov ebx, 8
L2:
	mov eax, mImageWidth
	cdq
	div ebx
	mov ebx, eax

	mov eax, mImageWidth
	dec eax
	mul x
	div windowWidth
	cdq
	div ebx
	mul ebx
	mov currentGridX, eax
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	mov ebx, 8
	mov al, showGridType
	cmp al, 8
	jne L3
		mov ebx, 2
	jmp L4
L3:
	cmp al, 9
	jne L4
		mov ebx, 4
L4:
	mov eax, mImageHeight
	cdq
	div ebx
	mov ebx, eax

	mov eax, mImageHeight
	dec eax
	mul y
	div windowHeight
	cdq
	div ebx
	mul ebx
	mov currentGridY, eax
	

	ret
asm_handleMousePassiveEvent ENDP



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;void asm_handleMouseEvent(int button, int status, int x, int y)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_handleMouseEvent PROC C USES ebx,
	button : DWORD, status : DWORD, x : DWORD, y : DWORD
	;
	;modify this procedure
	;	
	mWriteln "asm_handleMouseEvent"
	mov eax, button
	mWrite "button:"
	call WriteDec
	mWriteln " "
	mov eax, status
	mWrite "status:"
	call WriteDec
	mov eax, x
	mWriteln " "
	mWrite "x:"
	call WriteDec
	mWriteln " "
	mov eax, y
	mWrite "y:"
	call WriteDec
	mWriteln " "
	mov eax, windowWidth
	mWrite "windowWidth:"
	call WriteDec
	mWriteln " "
	mov eax, windowHeight
	mWrite "windowHeight:"
	call WriteDec
	mWriteln " "
	

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	mov ebx, 8
	mov al, showGridType
	cmp al, 8
	jne L1
		mov ebx, 4
	jmp L2
L1:
	cmp al, 9
	jne L2
		mov ebx, 8
L2:
	mov eax, mImageWidth
	cdq
	div ebx
	mov ebx, eax

	mov eax, mImageWidth
	dec eax
	mul x
	div windowWidth
	cdq
	div ebx
	mul ebx
	mov currentGridX, eax
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	mov ebx, 8
	mov al, showGridType
	cmp al, 8
	jne L3
		mov ebx, 2
	jmp L4
L3:
	cmp al, 9
	jne L4
		mov ebx, 4
L4:
	mov eax, mImageHeight
	cdq
	div ebx
	mov ebx, eax

	mov eax, mImageHeight
	dec eax
	mul y
	div windowHeight
	cdq
	div ebx
	mul ebx
	mov currentGridY, eax
	
	mov eax, status
	cmp eax, 1
	jne Lb

	mov al, selected
	cmp al, 1
	jne La
		mov al, 0
		mov selected, al
		call copyImage
	jmp Lb
La:
		mov al, 1
		mov selected, al
		mov eax, currentGridX
		mov selectedGridX, eax
		mov eax, currentGridY
		mov selectedGridY, eax
	jmp Lb
Lb:


exit0:
	ret
asm_handleMouseEvent ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;int asm_HandleKey(int key)
;
;Handle key events.
;Return 1 if the key has been handled.
;Return 0, otherwise.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_HandleKey PROC C, 
	key : DWORD
	
	cmp key, 'w'
	jne Lb
		call toGray
	jmp exit0
Lb:
	cmp key, 's'
	jne La
		mov al, showObj
		xor al, 1
		mov showObj, al
	jmp exit0
La:
	cmp key, '0'
	jne L9
		mov al, 0
		mov selected, al
		mov al, 0
		mov showGridType, al
		call resetImage
	jmp exit0
L9:
	cmp key, '9'
	jne L8
		mov al, 0
		mov selected, al
		mov al, 9
		mov showGridType, al
		call resetImage
		mov eax, windowWidth
		dec eax
		mul currentGridX
		div mImageWidth
		mov  ebx, eax
		mov eax, windowHeight
		dec eax
		mul currentGridY
		div mImageHeight
		push eax
		push ebx
		mov eax, windowWidth
		mov ebx, 100
		cdq
		div ebx
		pop ebx
		add ebx, eax
		push ebx
		mov eax, windowHeight
		mov ebx, 100
		cdq
		div ebx
		pop ebx
		mov edx, eax
		pop eax
		add eax, edx
		invoke asm_handleMousePassiveEvent, ebx, eax
	jmp exit0
L8:
	cmp key, '8'
	jne L7
		mov al, 0
		mov selected, al
		mov al, 8
		mov showGridType, al
		call resetImage
		mov eax, windowWidth
		dec eax
		mul currentGridX
		div mImageWidth
		mov  ebx, eax
		mov eax, windowHeight
		dec eax
		mul currentGridY
		div mImageHeight
		push eax
		push ebx
		mov eax, windowWidth
		mov ebx, 100
		cdq
		div ebx
		pop ebx
		add ebx, eax
		push ebx
		mov eax, windowHeight
		mov ebx, 100
		cdq
		div ebx
		pop ebx
		mov edx, eax
		pop eax
		add eax, edx
		invoke asm_handleMousePassiveEvent, ebx, eax
	jmp exit0
L7:
	cmp key, 'r'
	jne L6
		mov al, 0
		mov selected, al
		call resetImage
	jmp exit0
L6:
	cmp key, 'g'
	jne L5
		mov al, 0
		mov selected, al
		mov al, showGridMode
		cmp al, 1
		jne L5a
			xor al, 1
			mov showGridMode, al
			call resetImage	
		jmp exit0
	L5a:
		xor al, 1
		mov showGridMode, al
	jmp exit0
L5:
	cmp key, 'b'
	jne L4
		mov al, toBlueMode		
		xor al, 1
		mov toBlueMode, al
		mov eax, 1
		mov toBlue,  eax
		mov toBlueCount,  eax
	jmp exit0
L4:
	cmp key, '>'
	jne L3
	mov eax, imagePercentage
	inc eax
	cmp eax, 100
	jle L3a
	mov eax, 0
	L3a:
	mov imagePercentage, eax
	jmp exit0
L3:
	cmp key, '<'
	jne L2
	mov eax, imagePercentage
	dec eax
	cmp eax, 0
	jge L2a
	mov eax, 100
	L2a:
	mov imagePercentage, eax
	jmp exit0
L2:
	cmp key, 's'
	jmp exit0
	jne L0
L0:
exit0:
	mov eax, 0
	ret
asm_HandleKey ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;void asm_EndingMessage()
;
;This function is called
;when the program exits.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_EndingMessage PROC C USES eax edx
	mov ah, 0h
	mov al, 0e1h
	call SetTextColor
	mov edx, offset EndingMsg
	call WriteString
	ret
asm_EndingMessage ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;void asm_SetWindowDimension(int w, int h, int scaledWidth, int scaledHeight)
;
;w: window resolution (i.e. number of pixels) along the x-axis.
;h: window resolution (i.e. number of pixels) along the y-axis. 
;scaledWidth : scaled up width
;scaledHeight : scaled up height

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;asm_SetWindowDimension is called when the window is resized.
;w : actual width in pixels
;h : actual height in pixels
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_SetWindowDimension PROC C USES eax ebx,
	w: DWORD, h: DWORD, scaledWidth : DWORD, scaledHeight : DWORD
	mov ebx, offset windowWidth
	mov eax, w
	mov [ebx], eax
	mov eax, scaledWidth
	shr eax, 1	; divide by 2, i.e. eax = eax/2
	mov ebx, offset canvasMaxX
	mov [ebx], eax
	neg eax
	mov ebx, offset canvasMinX
	mov [ebx], eax
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	mov ebx, offset windowHeight
	mov eax, h
	mov [ebx], eax
	mov eax, scaledHeight
	shr eax, 1	; divide by 2, i.e. eax = eax/2
	mov ebx, offset canvasMaxY
	mov [ebx], eax
	neg eax
	mov ebx, offset canvasMinY
	mov [ebx], eax
	;
	finit
	fild canvasMinX
	fstp particleRangeMinX
	;
	finit
	fild canvasMaxX
	fstp particleRangeMaxX
	;
	finit
	fild canvasMinY
	fstp particleRangeMinY
	;
	finit
	fild canvasMaxY
	fstp particleRangeMaxY	
	;
	; Add your stuff here if you need it....
	ret
asm_SetWindowDimension ENDP	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;int asm_GetNumOfObjects()
;
;Return the number of objects
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_GetNumOfObjects PROC C
	mov eax, numObjects
	ret
asm_GetNumOfObjects ENDP	

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;int asm_GetObjType(int objID)
;
;Return the object type
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_GetObjType		PROC C USES ebx edx,
	objID: DWORD
	xor eax, eax
	mov edx, offset objTypes
	mov ebx, objID
	mov al, [edx + ebx]
	ret
asm_GetObjType		ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;void asm_GetColor (int &r, int &g, int &b, int objID)
;Input: objID, the ID of the object
;
;Return the color three color components
;red, green and blue.
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_GetColor  PROC C USES ebx,
	r: PTR DWORD, g: PTR DWORD, b: PTR DWORD, objID: DWORD
	
	mov ebx, r
	mov DWORD PTR [ebx], 0
	mov ebx, g
	mov DWORD PTR [ebx], 255
	mov ebx, b
	mov DWORD PTR [ebx], 0
	
exit0:
	ret
asm_GetColor ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;int asm_ComputeRotationAngle(a, b)
;return an angle*10.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_ComputeRotationAngle PROC C,
	a: DWORD, b: DWORD
	push ebx
	mov ebx, b
	shl ebx, 1
	mov eax, a
	add eax, 10
	pop ebx
	ret
asm_ComputeRotationAngle ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;int asm_ComputePositionX(int x, int objID)
;
;Return the x-coordinate.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_ComputePositionX PROC C USES ebx edx esi,
	x: DWORD, objID: DWORD
	;modify this procedure
	
	mov eax, objID
	mov ebx, 15
	cdq
	div ebx
	mov ebx, 4
	push edx
	mul ebx
	pop edx
	push eax
	mov eax, edx
	mov ebx, 3
	cdq
	div ebx
	pop eax
	add eax, edx
	mov ebx, 2000
	mul ebx
	push eax

	mov eax, canvasMaxX
	sub eax, canvasMinX
	sub eax, 56000
	mul objPosCount
	mov ebx, 10000
	div ebx
	add eax, canvasMinX
	mov ebx, eax
	pop eax
	add eax, ebx

	ret
asm_ComputePositionX ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;int asm_ComputePositionY(int y, int objID)
;
;Return the y-coordinate.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_ComputePositionY PROC C USES ebx esi,
	y: DWORD, objID: DWORD
	;modify this procedure
	
	mov eax, objID
	mov ebx, 15
	cdq
	div ebx
	mov eax, edx
	mov ebx, 3
	cdq
	div ebx
	mov ebx, 2000
	mul ebx
	push eax

	mov eax, canvasMaxY
	sub eax, canvasMinY
	mov ebx, 2
	mul ebx
	mov ebx, 7
	div ebx
	sub eax, canvasMaxY
	neg eax
	mov ebx, eax
	pop eax
	sub eax, ebx
	neg eax
	

	mov bl, showObj
	cmp bl, 0
	jne L1
		mov eax, canvasMaxY
		mov ebx, 2
		mul ebx
L1:
	mov esi, offset DIGIT_1
	add esi, objID
	mov bl, [esi]
	cmp bl, 0
	jne Lexit
		mov eax, canvasMaxY
		mov ebx, 2
		mul ebx
Lexit:
	ret
asm_ComputePositionY ENDP

ASM_setText PROC C
	;mov al, 0e1h
	mov al, 01eh
	call SetTextColor
	ret
ASM_setText ENDP

asm_ComputeParticlePosX PROC C,
xPtr : PTR REAL8
ret
asm_ComputeParticlePosX ENDP

;
asm_ComputeParticlePosY PROC C,
x : DWORD, yPtr : PTR REAL8, yVelocityPtr : PTR REAL8
ret
asm_ComputeParticlePosY ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;asm_SetImage
;copy the image pointed by imagePtr
;to a storage, e.g., mImagePtr0 or mImagePtr1,
;according to the imageIndex (0, or 1).
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_SetImage PROC C USES eax ebx ecx esi edi,
imageIndex : DWORD,
imagePtr : PTR BYTE, w : DWORD, h : DWORD, bytesPerPixel : DWORD
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; modify this procedure
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	mov esi, imagePtr
	mov edi, offset mImagePtr0
	mov eax, imageIndex
	cmp eax, 0
	je L2
	mov edi, offset mImagePtr1
L2:
	mov eax, bytesPerPixel
	mul mImageWidth
	mul mImageHeight
	sub eax, bytesPerPixel
	add edi, eax

	mov eax, w
	mul h
	mov ecx, eax
	cld
L3:
	movsb
	movsb
	movsb
	sub edi, bytesPerPixel
	sub edi, bytesPerPixel
	loop L3

	mov eax, w
	mov mImageWidth, eax
	mov eax, h
	mov mImageHeight, eax
	mov eax, bytesPerPixel
	mov mBytesPerPixel, eax
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	mov esi, offset mImagePtr0
	mov edi, offset mImagePtr2
	
	mov eax, w
	mul h
	mul bytesPerPixel
	mov ecx, eax
	cld
	rep movsb

	ret
asm_SetImage ENDP

asm_GetImagePixelSize PROC C
mov eax, mImagePixelPointSize
ret
asm_GetImagePixelSize ENDP

asm_GetImageStatus PROC C
mov eax, mImageStatus
ret
asm_GetImageStatus ENDP

asm_getImagePercentage PROC C
mov eax, imagePercentage
ret
asm_getImagePercentage ENDP
;
;asm_GetImageColour(int imageIndex, int ix, int iy, int &r, int &g, int &b)
;
asm_GetImageColour PROC C USES eax ebx edx esi edi, 
imageIndex : DWORD,
ix: DWORD, iy : DWORD,
r: PTR DWORD, g: PTR DWORD, b: PTR DWORD
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; modify this procedure
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	mov eax, mBytesPerPixel
	mul mImageWidth
	mul iy
	mov ebx, eax
	mov eax, mBytesPerPixel
	mul ix
	add eax, ebx
	mov esi, eax
	mov edi, eax
	add esi, offset mImagePtr0
	add edi, offset mImagePtr1

	xor eax, eax
	mov al, [esi]
	mul imagePercentage
	mov ebx, 100
	div ebx
	mov edx, eax
	push edx
	mov eax, 100
	sub eax, imagePercentage
	mov ebx, eax
	xor eax, eax
	mov al, [edi]
	mul ebx
	mov ebx, 100
	div ebx
	pop edx
	add eax, edx
	mov ebx, r
	mov BYTE PTR [ebx], al
	
	inc esi
	inc edi
	xor eax, eax
	mov al, [esi]
	mul imagePercentage
	mov ebx, 100
	div ebx
	mov edx, eax
	push edx
	mov eax, 100
	sub eax, imagePercentage
	mov ebx, eax
	xor eax, eax
	mov al, [edi]
	mul ebx
	mov ebx, 100
	div ebx
	pop edx
	add eax, edx
	mov ebx, g
	mov BYTE PTR [ebx], al
	
	
	inc esi
	inc edi
	xor eax, eax
	mov al, [esi]
	mul imagePercentage
	mov ebx, 100
	div ebx
	mov edx, eax
	push edx
	mov eax, 100
	sub eax, imagePercentage
	mov ebx, eax
	xor eax, eax
	mov al, [edi]
	mul ebx
	mov ebx, 100
	div ebx
	pop edx
	add eax, edx
	mov ebx, b
	mov BYTE PTR [ebx], al
	
	ret
asm_GetImageColour ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;const char *asm_getStudentInfoString()
;
;return pointer in edx
asm_getStudentInfoString PROC C
	mov eax, offset MYINFO
	ret
asm_getStudentInfoString ENDP
;
;void asm_GetImageDimension(int &iw, int &ih)
;
asm_GetImageDimension PROC C USES ebx,
iw : PTR DWORD, ih : PTR DWORD
mov ebx, iw
mov eax, mImageWidth
mov [ebx], eax
mov ebx, ih
mov eax, mImageHeight
mov [ebx], eax
ret
asm_GetImageDimension ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;asm_GetImagePos(int &x, int &y)
;Get the position of the upper left corner of the image.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_GetImagePos PROC C USES ebx,
x : PTR DWORD,
y : PTR DWORD
mov eax, canvasMinX
mov ebx, scaleFactor
cdq
idiv ebx
mov ebx, x
mov [ebx], eax

mov eax, canvasMinY
mov ebx, scaleFactor
cdq
idiv ebx
mov ebx, y
mov [ebx], eax
ret
asm_GetImagePos ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;void asm_updateSimulation()
;
;Update the simulation.
;For examples,
;we can update the positions of the objects.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_updateSimulation PROC C USES edi esi ebx

	mov eax, objPosCount
	add eax, objPosSpeed
	mov objPosCount, eax
	cmp eax, 0
	jle L3
	cmp eax, 10000
	jge L3
	jmp L4
L3:
	mov eax, objPosSpeed
	neg eax
	mov objPosSpeed, eax
	mov eax, objPosCount
	add eax, objPosSpeed
	add eax, objPosSpeed
	mov objPosCount, eax
L4:

	mov al, showGridMode
	cmp al, 1
	jne L2
		call showGrid
	L2:

	call toYellow

	mov al, toBlueMode
	cmp al, 1
	jne L1
		call blueMode
	L1:

	INVOKE c_updatePositionsOfAllObjects
	;call ReadInt
	ret
asm_updateSimulation ENDP

toYellow PROC USES eax ebx ecx esi
	
	mov esi, offset mImagePtr0
	mov eax, mImageWidth
	mul mImageHeight
	mov ecx, eax
L1:
	mov al, [esi]
	mov bl, [esi+1]
	cmp al, bl
	jbe L2
		inc bl
		mov [esi+1], bl
	L2:
	add esi, mBytesPerPixel
	loop L1

	ret
toYellow ENDP

blueMode PROC USES eax ebx ecx esi

	mov esi, offset mImagePtr0
	mov eax, mImageWidth
	mul mImageHeight
	mov ecx, eax
L1:
	mov al, [esi+2]
	mov ebx, toBlue
	cmp ebx, 1
	jne L6
		cmp al, 255
		je L7
			inc al
			mov [esi+2], al
		jmp L7
	L6:
		cmp al, 0
		je L7
			dec al
			mov [esi+2], al
	L7:
	add esi, mBytesPerPixel
	loop L1
	
	mov eax, toBlueCount
	add eax, toBlue
	mov toBlueCount, eax
	cmp eax, 0
	je L8
	cmp eax, 255
	je L8
	jmp L9
	L8:
		mov eax, toBlue
		neg eax
		mov toBlue, eax
	L9:

	ret
blueMode ENDP

resetImage PROC
	
	mov esi, offset mImagePtr2
	mov edi, offset mImagePtr0
	
	mov eax, mImageWidth
	mul mImageHeight
	mul mbytesPerPixel
	mov ecx, eax
	cld
	rep movsb

	ret
resetImage ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
showGrid PROC
	mov al, showGridType
	cmp al, 8
	jne L1
		call showGrid8
	jmp Lexit
L1:
	cmp al, 9
	jne L2
		call showGrid9
	jmp Lexit
L2:
	cmp al, 0
	jne L3
		call showGrid0
	jmp Lexit
L3:
Lexit:

	ret
showGrid ENDP

showGrid8 PROC USES eax ebx ecx edx esi

	mov esi, offset mImagePtr0

	mov ecx, 5
L4:
	mov eax, mImageWidth
	sub eax, 1
	mov ebx, ecx
	dec ebx
	mul ebx
	mov ebx, 4
	cdq
	div ebx
	mov ebx, mBytesPerPixel
	mul ebx
	mov edx, eax
	
	push ecx

	mov ecx, mImageHeight
L3:
	mov eax, mBytesPerPixel
	push edx
	mul mImageWidth
	mov ebx, ecx
	dec ebx
	mul ebx
	add esi, eax
	pop edx
	add esi, edx
	mov BYTE PTR [esi], 255
	mov BYTE PTR [esi+1], 255
	mov BYTE PTR [esi+2], 255
	sub esi, eax
	sub esi, edx
	loop L3

	pop ecx
	loop L4

	;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	mov ecx, 3
L6:
	mov eax, mImageHeight
	sub eax, 1
	mov ebx, ecx
	dec ebx
	mul ebx
	mov ebx, 2
	cdq
	div ebx
	mov ebx, mImageWidth
	mul ebx
	mov ebx, mBytesPerPixel
	mul ebx
	mov edx, eax
	
	push ecx

	mov ecx, mImageWidth
L5:
	mov eax, mBytesPerPixel
	mov ebx, ecx
	dec ebx
	push edx
	mul ebx
	add esi, eax
	pop edx
	add esi, edx
	mov BYTE PTR [esi], 255
	mov BYTE PTR [esi+1], 255
	mov BYTE PTR [esi+2], 255
	sub esi, eax
	sub esi, edx
	loop L5

	pop ecx
	loop L6
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;;;;;;;;;;;;;;;;;;
	
	push esi
	
	mov eax, currentGridX
	mul mBytesPerPixel
	add esi, eax 
	mov eax, mImageHeight
	dec eax
	sub eax, currentGridY
	mul mImageWidth
	mul mBytesPerPixel
	add esi, eax

	mov eax, mImageWidth
	mov ebx, 4
	cdq
	div ebx
	mov ecx, eax
La:
	mov BYTE PTR [esi], 255
	mov BYTE PTR [esi+1], 0
	mov BYTE PTR [esi+2], 0
	add esi, 3
	loop La 
	
	pop esi

	;;;;;;;;;;;;;;;;;;;;
	
	push esi
	
	mov eax, currentGridX
	mul mBytesPerPixel
	add esi, eax 
	mov eax, mImageHeight
	dec eax
	sub eax, currentGridY
	sub eax, 128
	mul mImageWidth
	mul mBytesPerPixel
	add esi, eax

	mov eax, mImageWidth
	mov ebx, 4
	cdq
	div ebx
	mov ecx, eax

	mov eax, currentGridY
	cmp eax, 128
	jne Lb1
		mov eax, mBytesPerPixel
		mul mImageWidth
		add esi, eax
Lb1:

	sub esi, 3
Lb:
	mov BYTE PTR [esi], 255
	mov BYTE PTR [esi+1], 0
	mov BYTE PTR [esi+2], 0
	add esi, 3
	loop Lb
	
	pop esi

	;;;;;;;;;;;;;;;;;;;;
	push esi
	
	mov eax, currentGridX
	mul mBytesPerPixel
	add esi, eax 
	mov eax, mImageHeight
	dec eax
	sub eax, currentGridY
	sub eax, 128
	mul mImageWidth
	mul mBytesPerPixel
	add esi, eax

	mov eax, mImageHeight
	mov ebx, 2
	cdq
	div ebx
	mov ecx, eax
	
	mov eax, currentGridX
	cmp eax, 0
	je Lc1
		sub esi, 3
Lc1:

	mov eax, mImageWidth
	mul mBytesPerPixel
	mov edx, eax
Lc:
	mov BYTE PTR [esi], 255
	mov BYTE PTR [esi+1], 0
	mov BYTE PTR [esi+2], 0
	add esi, edx
	loop Lc
	
	pop esi
	;;;;;;;;;;;;;;;;;;;;
	push esi
	
	mov eax, currentGridX
	mul mBytesPerPixel
	add esi, eax 
	mov eax, mImageHeight
	dec eax
	sub eax, currentGridY
	sub eax, 128
	mul mImageWidth
	mul mBytesPerPixel
	add esi, eax

	mov eax, mImageHeight
	mov ebx, 2
	cdq
	div ebx
	mov ecx, eax
	
	sub esi, 3

	add esi, 192

	mov eax, mImageWidth
	mul mBytesPerPixel
	mov edx, eax
Ld:
	mov BYTE PTR [esi], 255
	mov BYTE PTR [esi+1], 0
	mov BYTE PTR [esi+2], 0
	add esi, edx
	loop Ld
	
	pop esi
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


	mov al, selected
	cmp al, 1
	je Lselected
	ret
Lselected:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	push esi
	
	mov eax, selectedGridX
	mul mBytesPerPixel
	add esi, eax 
	mov eax, mImageHeight
	dec eax
	sub eax, selectedGridY
	mul mImageWidth
	mul mBytesPerPixel
	add esi, eax

	mov eax, mImageWidth
	mov ebx, 4
	cdq
	div ebx
	mov ecx, eax
Laa:
	mov BYTE PTR [esi], 255
	mov BYTE PTR [esi+1], 0
	mov BYTE PTR [esi+2], 0
	add esi, 3
	loop Laa
	
	pop esi

	;;;;;;;;;;;;;;;;;;;;
	
	push esi
	
	mov eax, selectedGridX
	mul mBytesPerPixel
	add esi, eax 
	mov eax, mImageHeight
	dec eax
	sub eax, selectedGridY
	sub eax, 128
	mul mImageWidth
	mul mBytesPerPixel
	add esi, eax

	mov eax, mImageWidth
	mov ebx, 4
	cdq
	div ebx
	mov ecx, eax

	mov eax, selectedGridY
	cmp eax, 128
	jne Lb1b
		mov eax, mBytesPerPixel
		mul mImageWidth
		add esi, eax
Lb1b:

	sub esi, 3
Lbb:
	mov BYTE PTR [esi], 255
	mov BYTE PTR [esi+1], 0
	mov BYTE PTR [esi+2], 0
	add esi, 3
	loop Lbb
	
	pop esi

	;;;;;;;;;;;;;;;;;;;;
	push esi
	
	mov eax, selectedGridX
	mul mBytesPerPixel
	add esi, eax 
	mov eax, mImageHeight
	dec eax
	sub eax, selectedGridY
	sub eax, 128
	mul mImageWidth
	mul mBytesPerPixel
	add esi, eax

	mov eax, mImageHeight
	mov ebx, 2
	cdq
	div ebx
	mov ecx, eax
	
	mov eax, selectedGridX
	cmp eax, 0
	je Lc1c
		sub esi, 3
Lc1c:

	mov eax, mImageWidth
	mul mBytesPerPixel
	mov edx, eax
Lcc:
	mov BYTE PTR [esi], 255
	mov BYTE PTR [esi+1], 0
	mov BYTE PTR [esi+2], 0
	add esi, edx
	loop Lcc
	
	pop esi
	;;;;;;;;;;;;;;;;;;;;
	push esi
	
	mov eax, selectedGridX
	mul mBytesPerPixel
	add esi, eax 
	mov eax, mImageHeight
	dec eax
	sub eax, selectedGridY
	sub eax, 128
	mul mImageWidth
	mul mBytesPerPixel
	add esi, eax

	mov eax, mImageHeight
	mov ebx, 2
	cdq
	div ebx
	mov ecx, eax
	
	sub esi, 3

	add esi, 192

	mov eax, mImageWidth
	mul mBytesPerPixel
	mov edx, eax
Ldd:
	mov BYTE PTR [esi], 255
	mov BYTE PTR [esi+1], 0
	mov BYTE PTR [esi+2], 0
	add esi, edx
	loop Ldd
	
	pop esi
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Lexit:
	ret
showGrid8 ENDP




showGrid9 PROC USES eax ebx ecx edx esi

	mov esi, offset mImagePtr0

	mov ecx, 9
L4:
	mov eax, mImageWidth
	sub eax, 1
	mov ebx, ecx
	dec ebx
	mul ebx
	mov ebx, 8
	cdq
	div ebx
	mov ebx, mBytesPerPixel
	mul ebx
	mov edx, eax
	
	push ecx

	mov ecx, mImageHeight
L3:
	mov eax, mBytesPerPixel
	push edx
	mul mImageWidth
	mov ebx, ecx
	dec ebx
	mul ebx
	add esi, eax
	pop edx
	add esi, edx
	mov BYTE PTR [esi], 255
	mov BYTE PTR [esi+1], 255
	mov BYTE PTR [esi+2], 255
	sub esi, eax
	sub esi, edx
	loop L3

	pop ecx
	loop L4

	;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	mov ecx, 5
L6:
	mov eax, mImageHeight
	sub eax, 1
	mov ebx, ecx
	dec ebx
	mul ebx
	mov ebx, 4
	cdq
	div ebx
	mov ebx, mImageWidth
	mul ebx
	mov ebx, mBytesPerPixel
	mul ebx
	mov edx, eax
	
	push ecx

	mov ecx, mImageWidth
L5:
	mov eax, mBytesPerPixel
	mov ebx, ecx
	dec ebx
	push edx
	mul ebx
	add esi, eax
	pop edx
	add esi, edx
	mov BYTE PTR [esi], 255
	mov BYTE PTR [esi+1], 255
	mov BYTE PTR [esi+2], 255
	sub esi, eax
	sub esi, edx
	loop L5

	pop ecx
	loop L6
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;;;;;;;;;;;;;;;;;;
	
	push esi
	
	mov eax, currentGridX
	mul mBytesPerPixel
	add esi, eax 
	mov eax, mImageHeight
	dec eax
	sub eax, currentGridY
	mul mImageWidth
	mul mBytesPerPixel
	add esi, eax

	mov eax, mImageWidth
	mov ebx, 8
	cdq
	div ebx
	mov ecx, eax
La:
	mov BYTE PTR [esi], 255
	mov BYTE PTR [esi+1], 0
	mov BYTE PTR [esi+2], 0
	add esi, 3
	loop La 
	
	pop esi

	;;;;;;;;;;;;;;;;;;;;
	
	push esi
	
	mov eax, currentGridX
	mul mBytesPerPixel
	add esi, eax 
	mov eax, mImageHeight
	dec eax
	sub eax, currentGridY
	sub eax, 64
	mul mImageWidth
	mul mBytesPerPixel
	add esi, eax

	mov eax, mImageWidth
	mov ebx, 8
	cdq
	div ebx
	mov ecx, eax

	mov eax, currentGridY
	cmp eax, 192
	jne Lb1
		mov eax, mBytesPerPixel
		mul mImageWidth
		add esi, eax
Lb1:

	sub esi, 3
Lb:
	mov BYTE PTR [esi], 255
	mov BYTE PTR [esi+1], 0
	mov BYTE PTR [esi+2], 0
	add esi, 3
	loop Lb
	
	pop esi

	;;;;;;;;;;;;;;;;;;;;
	push esi
	
	mov eax, currentGridX
	mul mBytesPerPixel
	add esi, eax 
	mov eax, mImageHeight
	dec eax
	sub eax, currentGridY
	sub eax, 64
	mul mImageWidth
	mul mBytesPerPixel
	add esi, eax

	mov eax, mImageHeight
	mov ebx, 4
	cdq
	div ebx
	mov ecx, eax
	
	mov eax, currentGridX
	cmp eax, 0
	je Lc1
		sub esi, 3
Lc1:

	mov eax, mImageWidth
	mul mBytesPerPixel
	mov edx, eax
Lc:
	mov BYTE PTR [esi], 255
	mov BYTE PTR [esi+1], 0
	mov BYTE PTR [esi+2], 0
	add esi, edx
	loop Lc
	
	pop esi
	;;;;;;;;;;;;;;;;;;;;
	push esi
	
	mov eax, currentGridX
	mul mBytesPerPixel
	add esi, eax 
	mov eax, mImageHeight
	dec eax
	sub eax, currentGridY
	sub eax, 64
	mul mImageWidth
	mul mBytesPerPixel
	add esi, eax

	mov eax, mImageHeight
	mov ebx, 4
	cdq
	div ebx
	mov ecx, eax
	
	sub esi, 3

	add esi, 96

	mov eax, mImageWidth
	mul mBytesPerPixel
	mov edx, eax
Ld:
	mov BYTE PTR [esi], 255
	mov BYTE PTR [esi+1], 0
	mov BYTE PTR [esi+2], 0
	add esi, edx
	loop Ld
	
	pop esi
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


	mov al, selected
	cmp al, 1
	je Lselected
	ret
Lselected:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	push esi
	
	mov eax, selectedGridX
	mul mBytesPerPixel
	add esi, eax 
	mov eax, mImageHeight
	dec eax
	sub eax, selectedGridY
	mul mImageWidth
	mul mBytesPerPixel
	add esi, eax

	mov eax, mImageWidth
	mov ebx, 8
	cdq
	div ebx
	mov ecx, eax
Laa:
	mov BYTE PTR [esi], 255
	mov BYTE PTR [esi+1], 0
	mov BYTE PTR [esi+2], 0
	add esi, 3
	loop Laa 
	
	pop esi

	;;;;;;;;;;;;;;;;;;;;
	
	push esi
	
	mov eax, selectedGridX
	mul mBytesPerPixel
	add esi, eax 
	mov eax, mImageHeight
	dec eax
	sub eax, selectedGridY
	sub eax, 64
	mul mImageWidth
	mul mBytesPerPixel
	add esi, eax

	mov eax, mImageWidth
	mov ebx, 8
	cdq
	div ebx
	mov ecx, eax

	mov eax, selectedGridY
	cmp eax, 192
	jne Lb1b
		mov eax, mBytesPerPixel
		mul mImageWidth
		add esi, eax
Lb1b:

	sub esi, 3
Lbb:
	mov BYTE PTR [esi], 255
	mov BYTE PTR [esi+1], 0
	mov BYTE PTR [esi+2], 0
	add esi, 3
	loop Lbb
	
	pop esi

	;;;;;;;;;;;;;;;;;;;;
	push esi
	
	mov eax, selectedGridX
	mul mBytesPerPixel
	add esi, eax 
	mov eax, mImageHeight
	dec eax
	sub eax, selectedGridY
	sub eax, 64
	mul mImageWidth
	mul mBytesPerPixel
	add esi, eax

	mov eax, mImageHeight
	mov ebx, 4
	cdq
	div ebx
	mov ecx, eax
	
	mov eax, selectedGridX
	cmp eax, 0
	je Lc1c
		sub esi, 3
Lc1c:

	mov eax, mImageWidth
	mul mBytesPerPixel
	mov edx, eax
Lcc:
	mov BYTE PTR [esi], 255
	mov BYTE PTR [esi+1], 0
	mov BYTE PTR [esi+2], 0
	add esi, edx
	loop Lcc
	
	pop esi
	;;;;;;;;;;;;;;;;;;;;
	push esi
	
	mov eax, selectedGridX
	mul mBytesPerPixel
	add esi, eax 
	mov eax, mImageHeight
	dec eax
	sub eax, selectedGridY
	sub eax, 64
	mul mImageWidth
	mul mBytesPerPixel
	add esi, eax

	mov eax, mImageHeight
	mov ebx, 4
	cdq
	div ebx
	mov ecx, eax
	
	sub esi, 3

	add esi, 96

	mov eax, mImageWidth
	mul mBytesPerPixel
	mov edx, eax
Ldd:
	mov BYTE PTR [esi], 255
	mov BYTE PTR [esi+1], 0
	mov BYTE PTR [esi+2], 0
	add esi, edx
	loop Ldd
	
	pop esi
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Lexit:
	ret
showGrid9 ENDP




showGrid0 PROC USES eax ebx ecx edx esi

	mov esi, offset mImagePtr0

	mov ecx, 9
L4:
	mov eax, mImageWidth
	sub eax, 1
	mov ebx, ecx
	dec ebx
	mul ebx
	mov ebx, 8
	cdq
	div ebx
	mov ebx, mBytesPerPixel
	mul ebx
	mov edx, eax
	
	push ecx

	mov ecx, mImageHeight
L3:
	mov eax, mBytesPerPixel
	push edx
	mul mImageWidth
	mov ebx, ecx
	dec ebx
	mul ebx
	add esi, eax
	pop edx
	add esi, edx
	mov BYTE PTR [esi], 255
	mov BYTE PTR [esi+1], 255
	mov BYTE PTR [esi+2], 255
	sub esi, eax
	sub esi, edx
	loop L3

	pop ecx
	loop L4

	;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	mov ecx, 9
L6:
	mov eax, mImageHeight
	sub eax, 1
	mov ebx, ecx
	dec ebx
	mul ebx
	mov ebx, 8
	cdq
	div ebx
	mov ebx, mImageWidth
	mul ebx
	mov ebx, mBytesPerPixel
	mul ebx
	mov edx, eax
	
	push ecx

	mov ecx, mImageWidth
L5:
	mov eax, mBytesPerPixel
	mov ebx, ecx
	dec ebx
	push edx
	mul ebx
	add esi, eax
	pop edx
	add esi, edx
	mov BYTE PTR [esi], 255
	mov BYTE PTR [esi+1], 255
	mov BYTE PTR [esi+2], 255
	sub esi, eax
	sub esi, edx
	loop L5

	pop ecx
	loop L6
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;;;;;;;;;;;;;;;;;;
	
	push esi
	
	mov eax, currentGridX
	mul mBytesPerPixel
	add esi, eax 
	mov eax, mImageHeight
	dec eax
	sub eax, currentGridY
	mul mImageWidth
	mul mBytesPerPixel
	add esi, eax

	mov eax, mImageWidth
	mov ebx, 8
	cdq
	div ebx
	mov ecx, eax
La:
	mov BYTE PTR [esi], 255
	mov BYTE PTR [esi+1], 0
	mov BYTE PTR [esi+2], 0
	add esi, 3
	loop La 
	
	pop esi

	;;;;;;;;;;;;;;;;;;;;
	
	push esi
	
	mov eax, currentGridX
	mul mBytesPerPixel
	add esi, eax 
	mov eax, mImageHeight
	dec eax
	sub eax, currentGridY
	sub eax, 32
	mul mImageWidth
	mul mBytesPerPixel
	add esi, eax

	mov eax, mImageWidth
	mov ebx, 8
	cdq
	div ebx
	mov ecx, eax

	mov eax, currentGridY
	cmp eax, 224
	jne Lb1
		mov eax, mBytesPerPixel
		mul mImageWidth
		add esi, eax
Lb1:

	sub esi, 3
Lb:
	mov BYTE PTR [esi], 255
	mov BYTE PTR [esi+1], 0
	mov BYTE PTR [esi+2], 0
	add esi, 3
	loop Lb
	
	pop esi

	;;;;;;;;;;;;;;;;;;;;
	push esi
	
	mov eax, currentGridX
	mul mBytesPerPixel
	add esi, eax 
	mov eax, mImageHeight
	dec eax
	sub eax, currentGridY
	sub eax, 32
	mul mImageWidth
	mul mBytesPerPixel
	add esi, eax

	mov eax, mImageHeight
	mov ebx, 8
	cdq
	div ebx
	mov ecx, eax
	
	mov eax, currentGridX
	cmp eax, 0
	je Lc1
		sub esi, 3
Lc1:

	mov eax, mImageWidth
	mul mBytesPerPixel
	mov edx, eax
Lc:
	mov BYTE PTR [esi], 255
	mov BYTE PTR [esi+1], 0
	mov BYTE PTR [esi+2], 0
	add esi, edx
	loop Lc
	
	pop esi
	;;;;;;;;;;;;;;;;;;;;
	push esi
	
	mov eax, currentGridX
	mul mBytesPerPixel
	add esi, eax 
	mov eax, mImageHeight
	dec eax
	sub eax, currentGridY
	sub eax, 32
	mul mImageWidth
	mul mBytesPerPixel
	add esi, eax

	mov eax, mImageHeight
	mov ebx, 8
	cdq
	div ebx
	mov ecx, eax
	
	sub esi, 3

	add esi, 96

	mov eax, mImageWidth
	mul mBytesPerPixel
	mov edx, eax
Ld:
	mov BYTE PTR [esi], 255
	mov BYTE PTR [esi+1], 0
	mov BYTE PTR [esi+2], 0
	add esi, edx
	loop Ld
	
	pop esi
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


	mov al, selected
	cmp al, 1
	je Lselected
	ret
Lselected:

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	push esi
	
	mov eax, selectedGridX
	mul mBytesPerPixel
	add esi, eax 
	mov eax, mImageHeight
	dec eax
	sub eax, selectedGridY
	mul mImageWidth
	mul mBytesPerPixel
	add esi, eax

	mov eax, mImageWidth
	mov ebx, 8
	cdq
	div ebx
	mov ecx, eax
Laa:
	mov BYTE PTR [esi], 255
	mov BYTE PTR [esi+1], 0
	mov BYTE PTR [esi+2], 0
	add esi, 3
	loop Laa 
	
	pop esi

	;;;;;;;;;;;;;;;;;;;;
	
	push esi
	
	mov eax, selectedGridX
	mul mBytesPerPixel
	add esi, eax 
	mov eax, mImageHeight
	dec eax
	sub eax, selectedGridY
	sub eax, 32
	mul mImageWidth
	mul mBytesPerPixel
	add esi, eax

	mov eax, mImageWidth
	mov ebx, 8
	cdq
	div ebx
	mov ecx, eax

	mov eax, currentGridY
	cmp eax, 224
	jne Lb1b
		mov eax, mBytesPerPixel
		mul mImageWidth
		add esi, eax
Lb1b:

	sub esi, 3
Lbb:
	mov BYTE PTR [esi], 255
	mov BYTE PTR [esi+1], 0
	mov BYTE PTR [esi+2], 0
	add esi, 3
	loop Lbb
	
	pop esi

	;;;;;;;;;;;;;;;;;;;;
	push esi
	
	mov eax, selectedGridX
	mul mBytesPerPixel
	add esi, eax 
	mov eax, mImageHeight
	dec eax
	sub eax, selectedGridY
	sub eax, 32
	mul mImageWidth
	mul mBytesPerPixel
	add esi, eax

	mov eax, mImageHeight
	mov ebx, 8
	cdq
	div ebx
	mov ecx, eax
	
	mov eax, selectedGridX
	cmp eax, 0
	je Lc1c
		sub esi, 3
Lc1c:

	mov eax, mImageWidth
	mul mBytesPerPixel
	mov edx, eax
Lcc:
	mov BYTE PTR [esi], 255
	mov BYTE PTR [esi+1], 0
	mov BYTE PTR [esi+2], 0
	add esi, edx
	loop Lcc
	
	pop esi
	;;;;;;;;;;;;;;;;;;;;
	push esi
	
	mov eax, selectedGridX
	mul mBytesPerPixel
	add esi, eax 
	mov eax, mImageHeight
	dec eax
	sub eax, selectedGridY
	sub eax, 32
	mul mImageWidth
	mul mBytesPerPixel
	add esi, eax

	mov eax, mImageHeight
	mov ebx, 8
	cdq
	div ebx
	mov ecx, eax
	
	sub esi, 3

	add esi, 96

	mov eax, mImageWidth
	mul mBytesPerPixel
	mov edx, eax
Ldd:
	mov BYTE PTR [esi], 255
	mov BYTE PTR [esi+1], 0
	mov BYTE PTR [esi+2], 0
	add esi, edx
	loop Ldd
	
	pop esi
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Lexit:
	ret
showGrid0 ENDP



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

copyImage PROC

	mov al, showGridType
	cmp al, 8
	jne L1
		call copyImage8
	jmp L3
L1:
	cmp al, 9
	jne L2
		call copyImage9
	jmp L3
L2:
		call copyImage0
	jmp L3
L3:
	ret
copyImage ENDP

copyImage8 PROC USES eax ebx ecx edx esi edi

	mov esi, offset mImagePtr0
	mov edi, offset mImagePtr0
;;;;;;;;;;;;;;;;;
	mov eax, selectedGridX
	mul mBytesPerPixel
	add esi, eax 
	mov eax, mImageHeight
	dec eax
	sub eax, selectedGridY
	sub eax, 128
	mul mImageWidth
	mul mBytesPerPixel
	add esi, eax
	sub esi, 3

	mov eax, selectedGridY
	cmp eax, 128
	jne Lb1b
		mov eax, mBytesPerPixel
		mul mImageWidth
		add esi, eax
Lb1b:
;;;;;;;;;;;;;;;;;
	mov eax, currentGridX
	mul mBytesPerPixel
	add edi, eax 
	mov eax, mImageHeight
	dec eax
	sub eax, currentGridY
	sub eax, 128
	mul mImageWidth
	mul mBytesPerPixel
	add edi, eax
	sub edi, 3

	mov eax, currentGridY
	cmp eax, 128
	jne Lb1
		mov eax, mBytesPerPixel
		mul mImageWidth
		add edi, eax
Lb1:
;;;;;;;;;;;;;;;;;

	mov ecx, 128
Lk:
	push ecx

	mov eax, 3
	mul mImageWidth
	mov ebx, 4
	cdq
	div ebx
	mov ecx, eax
Lb:
	mov ebx, ecx
	dec ebx
	mov al, [esi+ebx]
	mov BYTE PTR [edi+ebx], al
	loop Lb
	
	add esi, 768
	add edi, 768
	pop ecx
	loop Lk
	
	ret
copyImage8 ENDP



copyImage9 PROC USES eax ebx ecx edx esi edi

	mov esi, offset mImagePtr0
	mov edi, offset mImagePtr0
;;;;;;;;;;;;;;;;;
	mov eax, selectedGridX
	mul mBytesPerPixel
	add esi, eax 
	mov eax, mImageHeight
	dec eax
	sub eax, selectedGridY
	sub eax, 64
	mul mImageWidth
	mul mBytesPerPixel
	add esi, eax
	sub esi, 3

	mov eax, selectedGridY
	cmp eax, 192
	jne Lb1b
		mov eax, mBytesPerPixel
		mul mImageWidth
		add esi, eax
Lb1b:
;;;;;;;;;;;;;;;;;
	mov eax, currentGridX
	mul mBytesPerPixel
	add edi, eax 
	mov eax, mImageHeight
	dec eax
	sub eax, currentGridY
	sub eax, 64
	mul mImageWidth
	mul mBytesPerPixel
	add edi, eax
	sub edi, 3

	mov eax, currentGridY
	cmp eax, 192
	jne Lb1
		mov eax, mBytesPerPixel
		mul mImageWidth
		add edi, eax
Lb1:
;;;;;;;;;;;;;;;;;

	mov ecx, 64
Lk:
	push ecx

	mov eax, 3
	mul mImageWidth
	mov ebx, 8
	cdq
	div ebx
	mov ecx, eax
Lb:
	mov ebx, ecx
	dec ebx
	mov al, [esi+ebx]
	mov BYTE PTR [edi+ebx], al
	loop Lb
	
	add esi, 768
	add edi, 768
	pop ecx
	loop Lk
	
	ret
copyImage9 ENDP

copyImage0 PROC USES eax ebx ecx edx esi edi
	

	mov esi, offset mImagePtr0
	mov edi, offset mImagePtr0
;;;;;;;;;;;;;;;;;
	mov eax, selectedGridX
	mul mBytesPerPixel
	add esi, eax 
	mov eax, mImageHeight
	dec eax
	sub eax, selectedGridY
	sub eax, 32
	mul mImageWidth
	mul mBytesPerPixel
	add esi, eax
	sub esi, 3

	mov eax, selectedGridY
	cmp eax, 224
	jne Lb1b
		mov eax, mBytesPerPixel
		mul mImageWidth
		add esi, eax
Lb1b:
;;;;;;;;;;;;;;;;;
	mov eax, currentGridX
	mul mBytesPerPixel
	add edi, eax 
	mov eax, mImageHeight
	dec eax
	sub eax, currentGridY
	sub eax, 32
	mul mImageWidth
	mul mBytesPerPixel
	add edi, eax
	sub edi, 3

	mov eax, currentGridY
	cmp eax, 224
	jne Lb1
		mov eax, mBytesPerPixel
		mul mImageWidth
		add edi, eax
Lb1:
;;;;;;;;;;;;;;;;;

	mov ecx, 32
Lk:
	push ecx

	mov eax, 3
	mul mImageWidth
	mov ebx, 8
	cdq
	div ebx
	mov ecx, eax
Lb:
	mov ebx, ecx
	dec ebx
	mov al, [esi+ebx]
	mov BYTE PTR [edi+ebx], al
	loop Lb
	
	add esi, 768
	add edi, 768
	pop ecx
	loop Lk
	
	ret
copyImage0 ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

toGray PROC

	mov esi, offset mImagePtr0
	mov eax, mImageWidth
	mul mImageHeight
	mov ecx, eax
L1:
	xor ax, ax
	xor bx, bx
	mov al, [esi]
	mov bl, [esi+1]
	add ax, bx
	mov bl, [esi+2]
	add ax, bx
	mov bx, 3
	cwd
	div bx
	mov [esi], al
	mov [esi+1], al
	mov [esi+2], al
	add esi, mBytesPerPixel
	loop L1
	
	ret
toGray ENDP


END
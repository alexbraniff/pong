;Names: Sam Findler, Alexander Braniff
;This Program creates a table on zero page of
;all the the row adresses, then clears the screen
;and puts up a title screen for the game pong

table = $0020
lineptr = $0058
p1score = $0060
.alias iobase   $8800
.alias iostatus [iobase + 1]
.alias iocmd    [iobase + 2]
.alias ioctrl   [iobase + 3]
p2score = $0061
	.CR	6502
	.LI on,toff
	.TF display.prg.BIN
	.OR $0300

;this part of the routine creates a little endian table of the rows on the screen on zero page
	lda #$70
	sta table+1
	lda #$00
	sta table
	lda #$70
	sta table+3
	lda #$28
	sta table+2
	lda #$70
	sta table+5
	lda #$50
	sta table+4
	lda #$70
	sta table+7
	lda #$78
	sta table+6
	lda #$70
	sta table+9
	lda #$A0
	sta table+8
	lda #$70
	sta table+11
	lda #$C8
	sta table+10
	lda #$70
	sta table+13
	lda #$F0
	sta table+12
	lda #$71
	sta table+15
	lda #$18
	sta table+14
	lda #$71
	sta table+17
	lda #$40
	sta table+16
	lda #$71
	sta table+19
	lda #$68
	sta table+18
	lda #$71
	sta table+21
	lda #$90
	sta table+20
	lda #$71
	sta table+23
	lda #$B8
	sta table+22
	lda #$71
	sta table+25
	lda #$E0
	sta table+24
	lda #$72
	sta table+27
	lda #$08	
	sta table+26
	lda #$72
	sta table+29
	lda #$30
	sta table+28
	lda #$72
	sta table+31
	lda #$58
	sta table+30
	lda #$72
	sta table+33
	lda #$80
	sta table+32
	lda #$72
	sta table+35
	lda #$A8
	sta table+34
	lda #$72
	sta table+37
	lda #$D0
	sta table+36
	lda #$72
	sta table+39
	lda #$F8
	sta table+38
	lda #$73
	sta table+41
	lda #$20
	sta table+40
	lda #$73
	sta table+43
	lda #$48
	sta table+42
	lda #$73
	sta table+45
	lda #$70
	sta table+44
	lda #$73
	sta table+47
	lda #$98
	sta table+46
	lda #$73
	sta table+49
	lda #$C0
	sta table+48

;this is where the game code starts
start:
  jsr clear 
	jsr title
	jsr waitforenter ;need
	jsr gameplay
	jsr endscrn ;need
	jsr waitforenter
	jmp start
	

gameplay:
  jsr clear
  jsr strtscrn
  jsr drawball ;need
  jsr onepoint ;main game loop, for one point, need
  lda p1score
  cpa #10
  beq p1win ;need
  lda p2score
  cpa #10
  beq p2win ;need
  jmp gameplay

endscrn: rts
drawball: rts
onepoint: rts
p2win: rts
p1win:rts

;this part of the code uses the table to clear the screen
clear:  ldx #0
clxloop: 
	lda table,x
	sta lineptr
	inx
	lda table,x
	sta lineptr+1
	
	lda #$20
	ldy #39
clyloop: 
	bmi clexit
	sta (lineptr),y
	dey
	jmp clyloop

clexit:	
	inx
	cpx #50
	bne clxloop
	rts

;this part of the code paints a basic title screen
title:	
	lda table+20 ;write PONG on the center of the screen
	sta lineptr
	lda table+21
	sta lineptr+1
	lda #$50 ;P
	ldy #18
	sta (lineptr),y
	lda #$4F ;O
	iny
	sta (lineptr),y
	lda #$4E ;N
	iny
	sta (lineptr),y
	lda #$47 ;G
	iny 
	sta (lineptr),y

	lda table+24 ;write "hit enter to begin" below PONG
	sta lineptr
	lda table+25
	sta lineptr+1
	lda #$68 ;h
	ldy #11
	sta (lineptr),y
	lda #$69 ;i
	iny
	sta (lineptr),y
	lda #$74 ;t
	iny 
	sta (lineptr),y
	lda #$20 ;" "
	iny
	sta (lineptr),y
	lda #$65 ;e
	iny
	sta (lineptr),y
	lda #$6E ;n
	iny
	sta (lineptr),y
	lda #$74 ;t
	iny
	sta (lineptr),y
	lda #$65 ;e
	iny
	sta (lineptr),y
	lda #$72 ;r
	iny
	sta (lineptr),y
	lda #$20 ;' '
	iny
	sta (lineptr),y
	lda #$74 ;t
	iny
	sta (lineptr),y
	lda #$6F ;o
	iny
	sta (lineptr),y
	lda #$20 ;' '
	iny
	sta (lineptr),y
	lda #$62 ;b
	iny
	sta (lineptr),y
	lda #$65 ;e
	iny
	sta (lineptr),y
	lda #$67 ;g
	iny
	sta (lineptr),y
	lda #$69 ;i
	iny
	sta (lineptr),y
	lda #$6E ;n
	iny
	sta (lineptr),y
	rts
	
;make the original game screen on the screen	
strtscrn:
	lda table
	sta lineptr
	lda table+1
	sta lineptr+1

;paint a line across the top of the screen
ssinit1:	
	lda #249
	ldy #$27
ssloop1:
	bmi ssinit2
	sta (lineptr),y
	dey
	jmp ssloop1
;paint a line across the bottom of the screen	
ssinit2:
	lda table+48
	sta lineptr
	lda table+49
	sta lineptr+1
	lda #249
	ldy #$27
ssloop2:
	bmi sspadels
	sta (lineptr),y
	dey
	jmp ssloop2
;paint the padels on either side, padels are 4 pixels wide	
sspadels:
	ldx #20
ssloop3:
	beq ssinit4
	lda table,x
	sta lineptr
	inx
	lda table,x
	sta lineptr+1
	lda #245
	ldy #$00
	sta (lineptr),y
	ldy #$27
	sta (lineptr),y
	inx
	cpx #28
	jmp ssloop3
ssinit4:
	ldx #02
ssloop4:
	beq ssexit
	lda table,x
	sta lineptr
	inx
	lda table,x
	sta lineptr+1
	lda #$2E
	ldy #19
	sta (lineptr),y
	ldy #20
	sta (lineptr),y
	inx
	cpx #48
	jmp ssloop4
ssexit: rts

waitforenter:
	cli
        lda #$0b
        sta iocmd      ; Set command status
        lda #$1a
        sta ioctrl     ; 0 stop bits, 8 bit word, 2400 baud
getkey:
	lda iostatus   ; Read the ACIA status
        and #$08       ; Is the rx register empty?
        beq getkey     ; Yes, wait for it to fill
        lda iobase     ; Otherwise, read into accumulator
        cpa #$15
        bne getkey
	cli 
	rts

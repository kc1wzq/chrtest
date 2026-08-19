	include "nesdefs.dasm"

;;;;; VARIABLES

	seg.u ZEROPAGE
	org $0

;;;;; NES CARTRIDGE HEADER

	NES_HEADER 0,2,1,NES_MIRR_HORIZ ; mapper 0, 2 PRGs, 1 CHR

;;;;; START OF CODE

Start:	subroutine
	NES_INIT	; set up stack pointer, turn off PPU
        jsr WaitSync	; wait for VSYNC
        jsr ClearRAM	; clear RAM
        jsr WaitSync	; wait for VSYNC (and PPU warmup)
	
        
	jsr SetPallete
	jsr FillVram
        
        lda #MASK_BG
        sta PPU_MASK
        
        ; RESET
        
        lda #0
        sta PPU_ADDR
        sta PPU_ADDR

        sta PPU_SCROLL
        sta PPU_SCROLL
        
        lda #CTRL_NMI
        sta PPU_CTRL	; enable NMI
        
        
        
.endless:
	jmp .endless	; endless loop
        
SetPallete:

	PPU_SETADDR $3F00
        lda #$0F
        sta PPU_DATA
        lda #$16
        sta PPU_DATA
        lda #$27
        sta PPU_DATA
        lda #$30
        sta PPU_DATA
        
	rts
        
FillVram: subroutine
	
        PPU_SETADDR $2021	; Set the PPU Address to tile $2021

        ldy #0			; Set up the counter

.loop:
	lda HelloMsg,y		; Load Hello, World's byte by y
        beq .end		; End when 0 terminator is detected
        sta PPU_DATA		; store + advance ppu
        iny			; Increase Y
        bne .loop		; If not 0, jmp to .loop
.end:
	rts

HelloMsg:
	.byte "Hello, World!"	; Data
        .byte 0			; 0 Terminator

;;;;; COMMON SUBROUTINES

	include "nesppu.dasm"

;;;;; INTERRUPT HANDLERS

NMIHandler: subroutine
	SAVE_REGS
	RESTORE_REGS
	rti

;;;;; CPU VECTORS

	NES_VECTORS
        
;;;;; CHR
	org $10000
	incbin "jroatch.chr"
        incbin "jroatch.chr"


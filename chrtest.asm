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

	PPU_SETADDR $2000
        
        ldx #$00
.loop:

	lda #$10
        sta PPU_DATA
        lda #$17
        sta PPU_DATA
        
        
        inx
        bne .loop
        rts

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


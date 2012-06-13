*=0x500    ;set offset to 0x500

clc        ;clear carry flag
xce        ;set emulation flag
rep #$30   ;set to 16bit mode
!al        ;need this to make acc 16bit

lda #$1    ;map device 1 (monitor) to redbus window
mmu #$0
lda #$300  ;set redbus window offset to 0x300
mmu #1
mmu #2     ;enable redbus

lda #$400  ;set external memory mapped window to 0x400
mmu #$3
mmu #$4    ;enable external memory mapped window

lda #$500  ;set por to 0x500
mmu #$6

;setup display registers
sep #$30    ;switch to 8bit mode
!as

jmp .main

!src "terminal.s"
!src "tokenizer.s"

;enter main program

.main

	jsr .reset_display

.cursorloop
	jsr .getch
	jsr .print
jmp .cursorloop

stp

!src "terminal_statics.s"

!fi 128, $00 ;fill disk with 0's to make the disk at least 128bytes

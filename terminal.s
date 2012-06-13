
.reset_display
	lda #$0     ;set memory access row to 0
	sta $300
	lda #0
	sta $301	;cursor x to 0
	sta $302	;cursor y to 0
	lda #$02
	sta $303    ;cursor mode to blink

	jsr .clear_line

	lda #' '
	sta $308    ;set blit x start to 0
	lda #$00
	sta $309    ;set blit y start to 0
	sta $30a    ;set blit x offset to 0
	sta $30b    ;set blit y offset to 0

	lda #80    ;set blit width to 80
	sta $30c
	lda #50    ;set blit height to 50
	sta $30d

	lda #$1     ;fill
	sta $307

	.clear_screen_wait
		wai
		lda $307
		bne .clear_screen_wait

.getch
	lda #$1
	mmu #$0

	.getch_loop
		lda $304			;load keybuffer start to accu
		sta .getch_counter	;store keybuffer in zeropage
		lda $305			;load keybuffer position in accu
		cmp .getch_counter  ;compare keybuffer start and position for key detection
		            		;note: if keypress is detected 305 will increment
		            		;buffer start and position(incremented) will be unequal and bne will branch
		bne +       		;if accu does not equal value in $5d0 branch (+ means go to next + on branch)
		jmp .getch_loop 	;if no keypress was detected loop

	+ lda .getch_counter  
	sta $305    ;set keybuffer start to keybuffer position - this may skip some key strokes
	lda $306    ;load newly typed character from start of keybuffer
rts


.scroll_screen

	lda #0
	sta $308
	lda #1
	sta $309
	lda #0
	sta $30a
	sta $30b
	lda #80
	sta $30c
	lda #49
	sta $30d

	lda #3
	sta $307

	.scroll_line_loop
		wai
		lda $307
		cmp #$00
		bne .scroll_line_loop

.clear_line

	phx
	lda .printch_row_length
	tax
	lda #' '

	.clear_line_loop
		dex
		sta $310, x
		cpx #0
		bne .clear_line_loop

	plx
rts



rts

.printbs
	txa
	cmp #$00
	beq .printbs_exit

	lda #$20 ;fill current char with space
	sta $310,x
	dex         ;decrement x to go one character back

	.printbs_exit
rts

.printcr

	ldx #$00    ;reset x (go back to start of line)
	lda .printcr_row

	cmp .printcr_column_height
	bne .printcr_space_left
		jsr .scroll_screen
		jsr .clear_line
		lda .printcr_row
	jmp .printcr_no_space_left

	.printcr_space_left
		inc
		sta .printcr_row

	.printcr_no_space_left
		sta $300
		sta $302
		lda #$00
		sta .print_col
		sta $301
rts

.printch

	phx

	sta .printch_char
	lda .print_col
	cmp .printch_row_length
	bne .printch_print	; if char does not fit on line, do a line break

	jsr .printcr

	.printch_print
		lda .print_col
		tax
		inc .print_col
		inc
		sta $301

		lda .printch_char
		sta $310,x

	plx
rts

.print
	cmp .cr_char
	beq .print_cr

	cmp .bs_char
	beq .print_bs

	.print_print
		jsr .printch
		jmp .print_exit

	.print_cr
		jsr .printcr
		jmp .print_exit

	.print_bs
		jsr .printbs

	.print_exit
rts
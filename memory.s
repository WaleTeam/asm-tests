;mem_block
; +0 flags
; +1 size_low
; +2 size_high
; +3 next_block_low
; +4 next_block_high

.memory_init

	phy

	+load_address const_memory_idx0, var_heap_memory_start


	lda #0
	ldy #0							;set flags to 0
	sta (const_memory_idx0), y
	
	iny
	lda #$FF						;set size_low to FF
	sta (const_memory_idx0), y

	iny
	lda #$FF						;set size_high to FF
	sta (const_memory_idx0), y

	iny
	lda var_heap_memory_start		;point back to self
	sta (const_memory_idx0), y

	iny
	lda var_heap_memory_start + 1	;point back to self
	sta (const_memory_idx0), y

	ply
rts
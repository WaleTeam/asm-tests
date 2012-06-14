!set const_memory_frm0 = $E0
!set const_memory_frm1 = $E2
!set const_memory_frm2 = $E4
!set const_memory_frm3 = $E6
!set const_memory_frm4 = $E8
!set const_memory_frm5 = $EA
!set const_memory_frm6 = $EC
!set const_memory_frm7 = $EE


!set const_memory_idx0 = $F0
!set const_memory_idx1 = $F2
!set const_memory_idx2 = $F4
!set const_memory_idx3 = $F6
!set const_memory_idx4 = $F8
!set const_memory_idx5 = $FA
!set const_memory_idx6 = $FC
!set const_memory_idx7 = $FE

!set const_parameter_ptr = const_memory_frm0
!set const_stack_frame_ptr = const_memory_frm1

!macro save_8bitZP .zpIndex {
	lda .zpIndex
	pha
}

!macro restore_8bitZP .zpIndex {
	pla
	sta .zpIndex
}

!macro save_16bitZP .zpIndex {
	lda .zpIndex
	pha
	lda .zpIndex + 1
	pha
}

!macro restore_16bitZP .zpIndex {
	pla
	sta .zpIndex + 1
	pla
	sta .zpIndex
}

!macro copy_16bitZP_Mem .zpIndex, .address  {
	lda+2 .address
	sta .zpIndex

	lda+2 .address + 1
	sta .zpIndex + 1
}

;-4 old_param_low
;-3 old_param_high
;-2 old_stack_low
;-1 old_stack_high
; 0 old_x
;+1 <= const_stack_frame_ptr (points to this memory location)

!macro enter_stack_frame_with_bytes .frame_bytes {
	+save_16bitZP const_parameter_ptr
	+save_16bitZP const_stack_frame_ptr
	phx
	tsx

	stx const_stack_frame_ptr
	lda #$01
	sta const_stack_frame_ptr + 1

	; create space for local variables
	txa
	adc #.frame_bytes
	tax
	txs
}

!macro enter_stack_frame {
	+save_16bitZP const_parameter_ptr
	+save_16bitZP const_stack_frame_ptr
	phx
	tsx

	stx const_stack_frame_ptr
	lda #$01
	sta const_stack_frame_ptr + 1
}

!macro restore_stack_frame_with_bytes .frame_bytes {

	; clear local variables
	tsx
	txa
	sbc #.frame_bytes
	tax
	txs

	plx
	+restore_16bitZP const_stack_frame_ptr
	+restore_16bitZP const_parameter_ptr
}

!macro restore_stack_frame .frame_bytes {

	plx
	+restore_16bitZP const_stack_frame_ptr
	+restore_16bitZP const_parameter_ptr
}


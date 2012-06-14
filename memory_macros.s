!set const_memory_idx0 = $F0
!set const_memory_idx1 = $F2

!macro load_address .index, .address  {
	lda+2 .address
	sta .index

	lda+2 .address + 1
	sta .index + 1
}
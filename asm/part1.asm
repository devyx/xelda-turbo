	org 06100h
	di
	push iy
	ld a,(05B5Ch)
	push af
	ld c,6
	call switchbank
	ld de,0C000h
	ld hl,ram6
	call deexo
	ld c,3
	call switchbank
	ld de,0C000h
	ld hl,ram3
	call deexo
	pop af
	ld c,a
	push af
	call switchbank
	ld bc,04000h
	ld de,ram6
	ld hl,ram7
	ldir
	ld c,7
	call switchbank
	ld hl,ram6 		; actualy ram7
	ld de,0C000h
	call deexo
	pop af
	ld c,a
	call switchbank
	pop iy
	ret


	
ram6:	
	incbin "src/ram6-32768-15267.exo"
ram3:
	incbin "src/ram3-32768-16332.exo"
ram7:
	incbin "src/ram7-32768-14181.exo"
part1_end:
	include "loader.obj"

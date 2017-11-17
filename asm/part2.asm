	org 06100h
	di
	push iy
	ld a,(05B5Ch)
	push af
	ld c,4
	call switchbank
	ld de,0C000h
	ld hl,ram4
	call deexo
	ld c,1
	call switchbank
	ld de,0C000h
	ld hl,ram1
	call deexo
	pop af
	ld c,a
	call switchbank
	ld hl,main
	ld de,05E88h
	jp deexo_end


	
ram4:	
	incbin "src/ram4-32768-16306.exo"
ram1:
	incbin "src/ram1-32768-14512.exo"
main:	
	incbin "src/main-24200-36115.exo"
deexo_end:
	call _exo
	pop iy
	ei
	jp 05E88h
_exo:	
	include "asm/deexo.asm"
part2_end:	
exo_mapbasebits:	EQU 0FF00h

	include "loader.obj"

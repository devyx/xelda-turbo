	org 5E88h

	;; 1. copy loader to end
	ld hl,_real_loader
	ld de,real_loader
	ld bc,100h
	ldir
_screen:
	ld ix,6100h
	ld de,len_screen
	ld a,0FFh
	scf 
	call real_loader
	jr nc,_screen
	call _call2
_part1:
	ld ix,6100h
	ld de,len_part1
	ld a,0FFh
	scf 
	call real_loader
	jr nc,_part1
	call _call2
_part2:
	ld ix,6100h
	ld de,len_part2
	ld a,0FFh
	scf 
	call real_loader
	jr nc,_part2
_call2:	
	di
	jp 6100h

	
switchbank:
        proc
        LD      A,(0x5b5c)      ;Previous value of port
        AND     0xf8
        OR     c               ;Select bank C
        LD      BC,0x7ffd
        LD      (0x5b5c),A
        OUT     (C),A
        ret
        endp

deexo:	
	include "asm/deexo.asm"

_real_loader:
	incbin "tape/tapeload.bin"
real_loader:		EQU 65358
exo_mapbasebits:	EQU 06000h

	include "lengths.obj"

	org 6100h
	push iy 
	ld de,temp
	ld hl,payload
	call deexo
	ld hl,temp
	ld de,04800h
	call decode_rcs
	pop iy
	ret
	
decode_rcs:
        proc
next_row_or_col:
        ld a,d
        sub 8
        ld d,a
next_third:
        ld b,8
next_line:
        ld a,(hl)
        inc hl
        ld (de),a
        inc d              ; next pixel line
        djnz next_line
        ld a,e
        add a,32           ; next row
        ld e,a
        jr nc,next_row_or_col
        inc e              ; next column
        bit 5,e
        jr z,next_row_or_col
        ld e,b
        ld a,d
        cp $58             ; finished bitmap area?
        jr nz,next_third

        ld bc,768
        ldir               ; copy attributes
        ret
        endp

payload:
	incbin "src/screen.exo"
temp:	
screen_end:	
	include "loader.obj"

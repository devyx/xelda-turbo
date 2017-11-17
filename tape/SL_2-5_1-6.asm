; Routine caricamento turbo "SetoLOAD" rev. 1
; di Alessandro Grussu, marzo 2016
; Versione rosso-ciano/giallo-blu (178 byte)
;
; Velocità di trasferimento dati: ca. 3000 baud
; Temporizzazioni:
; Pilot pulse   2168
; Pilot length  3223
; Sync 1 pulse   714
; Sync 2 pulse   714
; Zero pulse     454
; One pulse      907

ORG 65358

  LD A,255
  SCF
  INC D
  EX AF,AF'
  DEC D
  DI
  LD A,015             ; colore bordo iniziale
  OUT (254),A
  LD HL,01343
  PUSH HL
  IN A,(254)
  RRA
  AND 032
  OR 002               ; primo byte colore
  LD C,A
  CP A
REF_2:  RET NZ
REF_5:  CALL REF_1
  JR NC,REF_2
  LD HL,01045          ; periodo di attesa (1045)
REF_3:  DJNZ REF_3
  DEC HL
  LD A,H
  OR L
  JR NZ,REF_3
  CALL REF_4
  JR NC,REF_2
REF_6:  LD B,156       ; costante temporale Leader (156)
  CALL REF_4
  JR NC,REF_2
  LD A,198
  CP B
  JR NC,REF_5
  INC H
  JR NZ,REF_6
REF_7:  LD B,201       ; costante temporale Sync Pulse (201)
  CALL REF_1
  JR NC,REF_2
  LD A,B
  CP 212
  JR NC,REF_7
  CALL REF_1
  RET NC
  LD A,C
  XOR 003              ; secondo byte colore
  LD C,A
  LD H,000
  LD B,088             ; costante temporale Flag Byte (176)
  JR REF_8
REF_D:  EX AF,AF'
  JR NZ,REF_9
  JR NC,REF_0
  LD (IX+000),L
  JR REF_A
REF_9:  RL C
  XOR L
  RET NZ
  LD A,C
  RRA
  LD C,A
  INC DE
  JR REF_B
REF_0:  LD A,(IX+000)
  XOR L
  RET NZ
REF_A:  INC IX
REF_B:  DEC DE
  EX AF,AF'
  LD B,089             ; costante temporale del bit da caricare (178)
REF_8:  LD L,001
REF_C:  CALL REF_4
  RET NC
  LD A,102             ; costante temporale di comparazione (2400 stati T) (203)
  CP B
  RL L
  LD B,088             ; costante temporale del prossimo bit da caricare (176)
  JP NC,REF_C
  LD A,H
  XOR L
  LD H,A
  LD A,D
  OR E
  JR NZ,REF_D
  LD A,H
  CP 001
  RET
REF_4:  CALL REF_1
  RET NC
REF_1:  LD A,011       ; costante temporale Sampling Loop (22)
REF_E:  DEC A
  JR NZ,REF_E
  AND A
REF_F:  INC B
  RET Z
  LD A,127
  IN A,(254)
  RRA
  NOP                  ; BREAK disabilitato (RET NC)
  XOR C
  AND 032
  JR Z,REF_F
  LD A,C
  CPL
  LD C,A
  AND 007              ; cambiare questi valori per
  OR 008               ; modificare i colori del bordo
  OUT (254),A
  SCF
  RET
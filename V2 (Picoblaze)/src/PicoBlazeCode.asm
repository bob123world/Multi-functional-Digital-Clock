vhdl "rom_form.vhd", "testprg.vhd", "testprg"

clk1hond dsin $00 			;Honderdste seconden
clk1sec dsin $01 			;Secondenklok
buttons dsin $02 			;Buttons (4bit) if1:B1, if2:B2, if3:B3, if4:B4

seg1out dsout $03			;Binaire waarde segment 1
seg2out dsout $04			;Binaire waarde segment 2
seg3out dsout $05			;Binaire waarde segment 3

selectie dsout $06			;Selectie statemachine {Tijdsfunctie=?,Datumfunctie=?,...}
selectieseg dsout $07		;Selectie welk segment je instelt {0=geen,1=links??,2=midden??,3=rechts??}
wekkerac dsout $08			;Michael type hier wat dit is: of wekker actief is en deze op de vga dus op aan moet staan.
alarmac dsout $09			;Michael type hier wat dit is: of alarm actief is en er dus een symbool van alarm op de vga moet komen

f_cH dsout $10				;Freezetime honderdsten
f_cS dsout $11				;Freezetime seconden
f_cM dsout $12				;Freezetime minuten

startcyc dsout $13			;1bit setting: bij 1: uitzenden uitgangen wordt gestart (gok ik)
endcyc dsout $14			;1bit setting: bij 1: uitzenden uitgangen voltooid (gok ik)


;Scratchpad RAM
t_S equ 00		;tijdsfunctie seconden
t_M equ 01		;tijdsfunctie minuten
t_H equ 02		;tijdsfunctie uren

d_D equ 03		;datumfunctie dagen
d_M equ 04		;datumfunctie maanden
d_Y equ 05		;datumfunctie jaren

w_M equ 06		;wekkerfunctie minuten
w_H equ 07		;wekkerfunctie uren

ti_S equ 08		;timerfunctie seconden
ti_M equ 09		;timerfunctie minuten
ti_H equ 10		;timerfunctie uren

c_H equ 11		;chronometerfunctie honderdsten
c_S equ 12		;chronometerfunctie seconden
c_M equ 13		;chronometerfunctie minuten

temp1 equ 14
temp2 equ 15
temp3 equ 16

w_ac equ 17
ti_en equ 18
al_ac equ 19

;Registers
but equ s0		;Register die de knoppen stand bijhoud
sel equ s1		;Statemachine: Selectie
selseg equ s2	;Statemachine: Selectie Segment
seg1 equ s3
seg2 equ s4
seg3 equ s5
honderdteller equ s6
jdat equ s7			; Houd schrikkeljaar telling bij
mdat equ s8			; Houd max aantal dagen maand bij
startc equ s9
endc equ sA

werk1 equ sB	;werkregister1: wordt gebruikt voor wekkerAc en voor uren van wekker
werk2 equ sC	;werkregister2: wordt gebruikt voor alarmAc en voor minuten van wekker	

chronostate equ sD	;1 wanneer chronometer actief is, 0 wanneer niet actief
timerstate equ sE	;1 wanneer timer actief is, 0 wanneer niet actief

; equ sF

ORG 0	 ;Hier start het programma
EINT	 ;Enable interrupt


coldstart:	   	LOAD sel, 0
				OUT sel, selectie
				LOAD selseg, 0
				OUT selseg, selectieseg
				LOAD seg3, 0
				OUT seg3, seg3out
				LOAD seg2, 0
				OUT seg2, seg2out
				LOAD seg1, 0
				OUT seg1, seg1out
				LOAD startc, 0
				OUT startc, startcyc
				LOAD endc, 0
				OUT endc, endcyc
				LOAD honderdteller, 0
				
				;honderdteller staat op 0, we gebruiken dit om alle scratchpad waardes op 0 mee te zetten
				STORE honderdteller, t_S
				STORE honderdteller, t_M
				STORE honderdteller, t_H
				
				LOAD honderdteller, 1
				STORE honderdteller, d_D
				STORE honderdteller, d_M
				LOAD honderdteller, 12
				STORE honderdteller, d_Y
				
				LOAD honderdteller, 0
				STORE honderdteller, w_M
				STORE honderdteller, w_H
				
				STORE honderdteller, ti_S
				STORE honderdteller, ti_M
				STORE honderdteller, ti_H
				
				STORE honderdteller, c_H
				STORE honderdteller, c_S
				STORE honderdteller, c_M

main:			CALL start
				
				IN but, buttons
				COMP but, 0
				JUMP NZ, aluit		;Alarm uitzetten wanneer actief
alarmchecked:	COMP but, 1
				CALL Z, seladd
				OUT sel, selectie
				COMP but, 2
				CALL Z, selsegadd
				OUT selseg, selectieseg
				FETCH werk2, al_ac
				OUT werk2, alarmac
				
				COMP sel, 0
				CALL Z, tijdsfunctie_out
				EINT 					;Enable interrupt, mocht hij disabled zijn na instellen
				
				COMP sel, 1
				CALL Z, datumfunctie_out
				
				COMP sel, 2
				CALL Z, wekkerfunctie_out
				
				COMP sel, 3
				CALL Z, timerfunctie_out
				
				COMP sel, 4
				CALL Z, chronometerfunctie_out
				
				OUT sel, selectie
				CALL endcycl
				JUMP main	
				
start:			LOAD startc, 1
				OUT startc, startcyc
				LOAD startc, 0
				OUT startc, startcyc
				RET
				
endcycl:		LOAD endc, 1
				OUT endc, endcyc
				LOAD endc, 0
				OUT endc, endcyc
				RET						


				
tijdsf:			;CALL Z, unset1Hzflag
				FETCH seg3, t_S
				ADD seg3, 1
				COMP seg3, 60
				STORE seg3, t_S
				RET NZ
				LOAD seg3, 0
				STORE seg3, t_S
				
				
				FETCH seg2, t_M
				ADD seg2, 1
				STORE seg2, t_M
				COMP seg2, 60		
				RET NZ
				LOAD seg2, 0
				STORE seg2, t_M
				
				
				FETCH seg1, t_H
				ADD seg1, 1
				STORE seg1, t_H
				COMP seg1, 24
				RET NZ
				LOAD seg1, 0
				STORE seg1, t_H
				
				
				;Datumfunctie bij interrupt
				
				FETCH seg1, d_D
				FETCH seg2, d_M
				FETCH seg3, d_Y
				CALL dagenm		;Checkt hoeveel dagen deze maand heeft!
				ADD seg1, 1
				COMP seg1, mdat
				STORE seg1, d_D
				RET NZ
				LOAD seg1, 1
				STORE seg1, d_D
				
				ADD seg2, 1
				STORE seg2, d_M
				COMP seg2, 13
				RET NZ
				LOAD seg2, 1
				STORE seg2, d_M
				
				CALL jdatplus
				ADD seg3, 1
				STORE seg3, d_Y
				COMP seg3, 100
				RET NZ
				LOAD seg3, 0
				STORE seg3, d_Y
				
				RET

timerf:			
				COMP timerstate, 1	;Controleren of de timerfunctie actief is
				RET NZ				;Terugkeren wanneer niet actief
				
				;FETCH seg3, ti_S		;Seconden uitlezen
				ADD seg3, 255			;Seconden +255 (maxregister=256, dus +255 = -1 behalve wanneer sec=0 dan = 255)
				COMP seg3, 255			
				RET NZ					;Seconden is nog niet tot 0 gegaan
				LOAD seg3, 59			;Terminalcount setten
				
				;FETCH seg2, ti_M		;Minuten uitlezen
				ADD seg2, 255			
				COMP seg2, 255
				RET NZ
				LOAD seg2, 59
				
				;FETCH seg1, ti_H		;uren uitlezen
				ADD seg1, 255
				COMP seg1, 255
				RET NZ
				
				;Timer volledig afgeteld
				LOAD seg1, 0
				LOAD seg2, 0
				LOAD seg3, 0
				
				LOAD timerstate, 0
				
				LOAD werk2, 1
				STORE werk2, al_ac
				
				RET
				
chronof:		
				COMP chronostate, 1	;Controleren of de chronometer actief is
				RET NZ				;terugkeren wanneer niet actief

				FETCH seg3, c_H	;Honderdsten naar tijdelijk register halen
				ADD seg3, 1		;Honderdsten +1
				STORE seg3, c_H	
				COMP seg3, 100		;Honderdsten =? 100
				RET NZ				;Terugkeren bij honderdsten != 100
				LOAD seg3, 0		;Honderdsten reset
				STORE seg3, c_H	
				
				FETCH seg2, c_S	;Seconden naar tijdelijk register halen
				ADD seg2, 1		;Seconden +1
				STORE seg2, c_S	
				COMP seg2, 60		;Seconden ?= 60
				RET NZ				;Terugkeren bij seconden != 60
				LOAD seg2, 0		;Seconden reset
				STORE seg2, c_S
				
				FETCH seg1, c_M	;Minuten naar tijdelijk register halen
				ADD seg1, 1		;Minuten +1
				STORE seg1, c_M
				COMP seg1, 60		;Minuten ?= 60
				RET NZ				;Terugkeren bij minuten != 60
				LOAD seg1, 0		;Minuten reset
				STORE seg1, c_M
				RET
				
tijdsfunctie_out:
				; CALL endcycl
				FETCH seg3, t_S
				FETCH seg2, t_M
				FETCH seg1, t_H
				OUT selseg, selectieseg
				OUT seg1, seg1out
				OUT seg2, seg2out
				OUT seg3, seg3out
				COMP selseg, 0
				RET Z
				;instellen
				DINT	  	  	 	   ;Disable interrupt
				CALL endcycl			
				CALL start
				IN but, buttons
				COMP but, 2
				CALL Z, selsegadd
				COMP but, 3
				CALL Z, plus
				COMP but, 4
				CALL Z, min
				STORE seg3, t_S
				STORE seg2, t_M
				STORE seg1, t_H
				JUMP tijdsfunctie_out				

datumfunctie_out:
				FETCH seg3, d_Y
				FETCH seg2, d_M
				FETCH seg1, d_D
				OUT selseg, selectieseg
				OUT seg1, seg1out
				OUT seg2, seg2out
				OUT seg3, seg3out
				COMP selseg, 0
				RET Z
				
				CALL endcycl		;instellen
				CALL start
				IN but, buttons
				COMP but, 2
				CALL Z, selsegadd
				COMP but, 3
				CALL Z, datplus
				COMP but, 4
				CALL Z, datmin
				STORE seg3, d_Y
				STORE seg2, d_M
				STORE seg1, d_D
				COMP selseg, 0
				JUMP NZ, datumfunctie_out
				CALL datcorrectie
				STORE seg3, d_Y
				STORE seg2, d_M
				STORE seg1, d_D
				JUMP datumfunctie_out			

wekkerfunctie_out:
				CALL endcycl
				FETCH seg3, w_M
				FETCH seg2, w_M
				FETCH seg1, w_H
				OUT selseg, selectieseg
				OUT seg1, seg1out
				OUT seg2, seg2out
				OUT seg3, seg3out
				FETCH werk1, w_ac
				OUT werk1, wekkerac
				COMP selseg, 0
				RET Z
				
				CALL endcycl		;instellen
				CALL start
				IN but, buttons
				COMP but, 2
				CALL Z, selsegadd
				COMP but, 3
				CALL Z, plus
				COMP but, 4
				CALL Z, min
				STORE seg3, w_M
				STORE seg2, w_M
				STORE seg1, w_H
				JUMP wekkerfunctie_out						
				
timerfunctie_out:
				FETCH seg3, ti_S
				FETCH seg2, ti_M
				FETCH seg1, ti_H
				OUT selseg, selectieseg
				OUT seg1, seg1out
				OUT seg2, seg2out
				OUT seg3, seg3out
				
				
				COMP selseg, 0
				JUMP Z, timermanage
				
				CALL endcycl
				CALL start
				IN but, buttons
				
				;RET Z
				
				COMP but, 2
				CALL Z, selsegadd
				COMP but, 3
				CALL Z, plus
				COMP but, 4
				CALL Z, min
				STORE seg3, ti_S
				STORE seg2, ti_M
				STORE seg1, ti_H
				JUMP timerfunctie_out
				
timermanage:	;niet aan 't instellen, b3 = start/stop
				COMP but, 3
				RET NZ
				ADD timerstate, 1	;timer state +1 stel chrono stond uit, nieuwe waarde = 1, stel chrono was aan, waarde = 2
				COMP timerstate, 1
				RET Z
				LOAD timerstate, 0	
				RET
			
				
chronometerfunctie_out:
				LOAD selseg, 0
				
				FETCH seg3, c_H
				FETCH seg2, c_S
				FETCH seg1, c_M
				OUT selseg, selectieseg
				OUT seg1, seg1out
				OUT seg2, seg2out
				OUT seg3, seg3out
				
				COMP but, 2
				CALL Z, chronostartpause
				COMP but, 3
				CALL Z, chronoreset
				COMP but, 4
				CALL Z, chronofreeze
				
				STORE seg3, c_H
				STORE seg2, c_S
				STORE seg1, c_M			
				RET

chronostartpause:
				ADD chronostate, 1	;chrono state +1 stel chrono stond uit, nieuwe waarde = 1, stel chrono was aan, waarde = 2
				COMP chronostate, 1
				RET Z
				LOAD chronostate, 0
				RET
				
chronoreset:
				LOAD seg3, 0
				LOAD seg2, 0
				LOAD seg1, 0
				RET
				
chronofreeze:
				OUT seg3, f_cH
				OUT seg2, f_cS
				OUT seg1, f_cM
				RET
				
				
;============================Generieke instelfunctie voor Timer- en tijdsfunctie============================				
plus:			COMP selseg, 1
				CALL Z, lpinst
				COMP selseg, 2
				CALL Z, mpinst
				COMP selseg, 3
				CALL Z, rpinst
				RET
				
lpinst:			ADD seg1, 1
				COMP seg1, 24
				RET NZ
				LOAD seg1, 0
				RET
				
mpinst:			ADD seg2, 1
				COMP seg2, 60
				RET NZ
				LOAD seg2, 0
				RET
				
rpinst:			COMP sel, 2			;Bij wekkerfunctie springen naar het activeren van de wekker
				JUMP Z, wekact
				ADD seg3, 1
				COMP seg3, 60
				RET NZ
				LOAD seg3, 0
				RET
				
min:			COMP selseg, 1
				CALL Z, lminst
				COMP selseg, 2
				CALL Z, mminst
				COMP selseg, 3
				CALL Z, rminst
				RET
				
lminst:			COMP seg1, 0
				JUMP Z, lminreset
				ADD seg1, 255
				RET
				
lminreset:		LOAD seg1, 23
				RET
				
mminst:			COMP seg2, 0
				JUMP Z, mminreset
				ADD seg2, 255
				RET
				
mminreset:		LOAD seg2, 59
				RET
				
rminst:			COMP sel, 2			;Bij wekkerfunctie springen naar het activeren van de wekker
				JUMP Z, wekact
				COMP seg3,0
				JUMP Z, rminreset
				ADD seg3, 255
				RET
				
rminreset:		LOAD seg3, 59
				RET
			
;=========================================================Datumfunctie=======================================
dagenm:			COMP seg2, 2
				JUMP Z, febr
				LOAD mdat, 31
				COMP seg2, 4
				RET Z
				COMP seg2, 6
				RET Z
				COMP seg2, 9
				RET Z
				COMP seg2, 11
				RET Z
				LOAD mdat, 32
				RET
				
febr:			LOAD mdat, 29
				COMP jdat, 0
				RET NZ
				LOAD mdat, 30
				RET
				
datcorrectie:	CALL dagenm				;Corrigeert de dagen van datumfunctie als deze onjuist zijn ingesteld!
				COMP seg1, mdat
				JUMP Z, cor
				ADD mdat, 1
				COMP seg1, mdat
				JUMP Z, corr
				ADD mdat, 1
				COMP seg1, mdat
				RET NZ
				ADD seg1, 253
				RET
				
cor:			ADD seg1, 255
				RET
				
corr:			ADD seg1, 254
				RET

jdatplus:		ADD jdat, 1
				COMP jdat, 4
				RET NZ
				LOAD jdat, 0
				RET
				
jdatmin:		COMP jdat, 0
				JUMP Z, jdatreset
				ADD jdat, 255
				RET
				
jdatreset:		LOAD jdat, 3
				RET
				
datplus:		COMP selseg, 1
				CALL Z, datlpinst
				COMP selseg, 2
				CALL Z, datmpinst
				COMP selseg, 3
				CALL Z, datrpinst
				RET
				
datlpinst:		CALL dagenm
				ADD seg1, 1
				COMP seg1, mdat
				RET NZ
				LOAD seg1, 1
				RET
				
datmpinst:		ADD seg2, 1
				COMP seg2, 13
				RET NZ
				LOAD seg2, 1
				RET
				
datrpinst:		ADD seg3, 1
				CALL jdatplus
				COMP seg3, 100
				RET NZ
				LOAD seg3, 0
				RET
				
datmin:			COMP selseg, 1
				CALL Z, datlminst
				COMP selseg, 2
				CALL Z, datmminst
				COMP selseg, 3
				CALL Z, datrminst
				RET

datlminst:		CALL dagenm
				COMP seg1, 1
				JUMP Z, datlminreset
				ADD seg1, 255
				RET
				
datlminreset:	ADD mdat, 255
				LOAD seg1, mdat
				RET
				
datmminst:		COMP seg2, 1
				JUMP Z, datmminreset
				ADD seg2, 255
				RET
				
datmminreset:	LOAD seg2, 12
				RET
				
datrminst:		CALL jdatmin
				COMP seg3, 0
				JUMP Z, datrminreset
				ADD seg3, 255
				RET
				
datrminreset:	LOAD seg3, 99
				RET

;================================================Wekkerfunctie=================================
wekact:			FETCH werk1, w_ac
				ADD werk1, 1
				COMP werk1, 2
				STORE werk1, w_ac
				RET NZ
				LOAD werk1, 0
				STORE werk1, w_ac
				RET
				
wekal:			FETCH seg3, t_S
				FETCH seg2, t_M
				FETCH seg1, t_H
				
				FETCH werk2, w_M
				COMP seg2, werk2
				RET NZ
				FETCH werk1, w_H
				COMP seg1, werk1
				RET NZ
				FETCH werk1, w_ac
				FETCH werk2, al_ac
				COMP werk1, 1
				RET NZ
				LOAD werk1, 0
				LOAD werk2, 1
				OUT werk2, alarmac
				OUT werk1, wekkerac
				STORE werk1, w_ac
				STORE werk2, al_ac
				RET

aluit:			call endcycl
				FETCH werk2, al_ac
				COMP werk2, 1
				JUMP NZ, alarmchecked
				LOAD werk2, 0
				OUT werk2, alarmac
				STORE werk2 ,al_ac
				JUMP main			

				
;================================================Statemachine==================================				
seladd:			ADD sel, 1
				COMP sel, 5
				RET NZ
				LOAD sel, 0
				RET
				
selsegadd:		ADD selseg, 1
				COMP selseg, 4
				RET NZ
				LOAD selseg, 0
				RET


				
hteller:		;--chronometerke late telle :)
				
				STORE seg1, temp1
				STORE seg2, temp2
				STORE seg3, temp3
				CALL chronof
				FETCH seg1, temp1
				FETCH seg2, temp2
				FETCH seg3, temp3
				
				
				ADD honderdteller, 1
				COMP honderdteller, 100
				
				
				RET NZ
				STORE seg1, temp1
				STORE seg2, temp2
				STORE seg3, temp3
				
				
				
				FETCH seg3, ti_S
				FETCH seg2, ti_M
				FETCH seg1, ti_H
				CALL timerf
				STORE seg3, ti_S
				STORE seg2, ti_M
				STORE seg1, ti_H
				
				CALL tijdsf
				CALL wekal
				LOAD honderdteller, 0
				FETCH seg1, temp1
				FETCH seg2, temp2
				FETCH seg3, temp3
				RET

				
ISR:			;Interrupt module
				;hier de code hoipiepeloilolololdiedelololol
				;CALL tijdsf ;Tijdsfunctie doorlopen (sec+1)-->Gevolgen
				CALL hteller
				RETI ENABLE ;Terugkeren naar het main programma en INTERRUPT terug activeren
				
				
ORG $3FF		;Hier komt het programma uit bij een interrupt
				JUMP isr ;Spring naar ISR module


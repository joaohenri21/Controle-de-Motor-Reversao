; PIC16F628A Configuration Bit Settings
; Assembly source line config statements
#include "p16f628a.inc"
; CONFIG
; __config 0xFF70
    __CONFIG _FOSC_INTOSCIO & _WDTE_OFF & _PWRTE_ON & _MCLRE_ON & _BOREN_ON & _LVP_OFF & _CPD_OFF & _CP_OFF

#define	BANK0	BCF STATUS,RP0	    ;seleciona banco 0 da memória RAM
#define	BANK1	BSF STATUS,RP0	    ;seleciona banco 1 da memória RAM

 
;entradas
#define	LIG_HORARIO	PORTA,1
#define LIG_ANTIHOR	PORTA,2
#define DESL		PORTA,3
#define LIGA_EMERG	PORTA,4
;saídas
#define	LIGADO		PORTA,0
#define	HORARIO		PORTB,0
#define ANTIHOR		PORTB,1
#define DESLIGADO	PORTB,2
#define EMERG_LIGADO	PORTB,3
  
RES_VECT  CODE    0x0000            ; processor reset vector
    BANK1			    ;seleciona banco 1 da memória RAM
    BCF	    TRISA,0
    BCF	    TRISB,0		    
    BCF	    TRISB,1
    BCF	    TRISB,2
    BCF	    TRISB,3
    BANK0			    ;seleciona banco 0 da memória RAM
    BSF	    DESLIGADO		    
    BCF	    LIGADO
    BCF	    HORARIO
    BCF	    ANTIHOR
    BCF	    EMERG_LIGADO
    
PRINCIPAL1
    BTFSS   LIGA_EMERG
    GOTO    EMERGENCIA
    GOTO    PRINCIPAL2
PRINCIPAL2
    BTFSS   LIG_HORARIO
    GOTO    LIGA_HORARIO
    GOTO    PRINCIPAL3
PRINCIPAL3
    BTFSS   LIG_ANTIHOR
    GOTO    LIGA_ANTIHORARIO
    GOTO    PRINCIPAL4
PRINCIPAL4
    BTFSS   DESL
    GOTO    DESLIGA
    GOTO    PRINCIPAL1
EMERGENCIA
    BSF	    EMERG_LIGADO
    BSF	    DESLIGADO
    BCF	    LIGADO
    BCF	    HORARIO
    BCF	    ANTIHOR
    GOTO    PRINCIPAL2
LIGA_HORARIO
    BTFSC   ANTIHOR
    GOTO    PRINCIPAL3
    BTFSS   LIG_ANTIHOR
    GOTO    PRINCIPAL3
    BTFSS   DESL
    GOTO    PRINCIPAL3
    BTFSC   EMERG_LIGADO
    GOTO    PRINCIPAL3
    BSF	    HORARIO
    BSF	    LIGADO
    BCF	    ANTIHOR
    BCF	    DESLIGADO
    GOTO    PRINCIPAL3
LIGA_ANTIHORARIO
    BTFSC   HORARIO
    GOTO    PRINCIPAL4
    BTFSS   LIG_HORARIO
    GOTO    PRINCIPAL4
    BTFSS   DESL
    GOTO    PRINCIPAL4
    BTFSC   EMERG_LIGADO
    GOTO    PRINCIPAL4
    BSF	    ANTIHOR
    BSF	    LIGADO
    BCF	    HORARIO
    BCF	    DESLIGADO
    GOTO    PRINCIPAL4
DESLIGA    
    BSF	    DESLIGADO
    BCF	    HORARIO
    BCF	    ANTIHOR
    BCF	    LIGADO
    BCF	    EMERG_LIGADO
    GOTO    PRINCIPAL1
    
    END

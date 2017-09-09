
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega8
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega8
	#pragma AVRPART MEMORY PROG_FLASH 8192
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	RCALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	RCALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _dht_nhiet_do=R5
	.DEF _dht_do_am=R4
	.DEF _P_Add=R7
	.DEF _Code_tay_cam1=R6
	.DEF _Code_tay_cam2=R9
	.DEF _Code_tay_cam3=R8
	.DEF _Code_tay_cam4=R11
	.DEF _data_receive_2=R10
	.DEF _result=R13

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _timer2_ovf
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

_font5x7:
	.DB  0x5,0x7,0x20,0x60,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x5F,0x0,0x0,0x0,0x7
	.DB  0x0,0x7,0x0,0x14,0x7F,0x14,0x7F,0x14
	.DB  0x24,0x2A,0x7F,0x2A,0x12,0x23,0x13,0x8
	.DB  0x64,0x62,0x36,0x49,0x55,0x22,0x50,0x0
	.DB  0x5,0x3,0x0,0x0,0x0,0x1C,0x22,0x41
	.DB  0x0,0x0,0x41,0x22,0x1C,0x0,0x8,0x2A
	.DB  0x1C,0x2A,0x8,0x8,0x8,0x3E,0x8,0x8
	.DB  0x0,0x50,0x30,0x0,0x0,0x8,0x8,0x8
	.DB  0x8,0x8,0x0,0x30,0x30,0x0,0x0,0x20
	.DB  0x10,0x8,0x4,0x2,0x3E,0x51,0x49,0x45
	.DB  0x3E,0x0,0x42,0x7F,0x40,0x0,0x42,0x61
	.DB  0x51,0x49,0x46,0x21,0x41,0x45,0x4B,0x31
	.DB  0x18,0x14,0x12,0x7F,0x10,0x27,0x45,0x45
	.DB  0x45,0x39,0x3C,0x4A,0x49,0x49,0x30,0x1
	.DB  0x71,0x9,0x5,0x3,0x36,0x49,0x49,0x49
	.DB  0x36,0x6,0x49,0x49,0x29,0x1E,0x0,0x36
	.DB  0x36,0x0,0x0,0x0,0x56,0x36,0x0,0x0
	.DB  0x0,0x8,0x14,0x22,0x41,0x14,0x14,0x14
	.DB  0x14,0x14,0x41,0x22,0x14,0x8,0x0,0x2
	.DB  0x1,0x51,0x9,0x6,0x32,0x49,0x79,0x41
	.DB  0x3E,0x7E,0x11,0x11,0x11,0x7E,0x7F,0x49
	.DB  0x49,0x49,0x36,0x3E,0x41,0x41,0x41,0x22
	.DB  0x7F,0x41,0x41,0x22,0x1C,0x7F,0x49,0x49
	.DB  0x49,0x41,0x7F,0x9,0x9,0x1,0x1,0x3E
	.DB  0x41,0x41,0x51,0x32,0x7F,0x8,0x8,0x8
	.DB  0x7F,0x0,0x41,0x7F,0x41,0x0,0x20,0x40
	.DB  0x41,0x3F,0x1,0x7F,0x8,0x14,0x22,0x41
	.DB  0x7F,0x40,0x40,0x40,0x40,0x7F,0x2,0x4
	.DB  0x2,0x7F,0x7F,0x4,0x8,0x10,0x7F,0x3E
	.DB  0x41,0x41,0x41,0x3E,0x7F,0x9,0x9,0x9
	.DB  0x6,0x3E,0x41,0x51,0x21,0x5E,0x7F,0x9
	.DB  0x19,0x29,0x46,0x46,0x49,0x49,0x49,0x31
	.DB  0x1,0x1,0x7F,0x1,0x1,0x3F,0x40,0x40
	.DB  0x40,0x3F,0x1F,0x20,0x40,0x20,0x1F,0x7F
	.DB  0x20,0x18,0x20,0x7F,0x63,0x14,0x8,0x14
	.DB  0x63,0x3,0x4,0x78,0x4,0x3,0x61,0x51
	.DB  0x49,0x45,0x43,0x0,0x0,0x7F,0x41,0x41
	.DB  0x2,0x4,0x8,0x10,0x20,0x41,0x41,0x7F
	.DB  0x0,0x0,0x4,0x2,0x1,0x2,0x4,0x40
	.DB  0x40,0x40,0x40,0x40,0x0,0x1,0x2,0x4
	.DB  0x0,0x20,0x54,0x54,0x54,0x78,0x7F,0x48
	.DB  0x44,0x44,0x38,0x38,0x44,0x44,0x44,0x20
	.DB  0x38,0x44,0x44,0x48,0x7F,0x38,0x54,0x54
	.DB  0x54,0x18,0x8,0x7E,0x9,0x1,0x2,0x8
	.DB  0x14,0x54,0x54,0x3C,0x7F,0x8,0x4,0x4
	.DB  0x78,0x0,0x44,0x7D,0x40,0x0,0x20,0x40
	.DB  0x44,0x3D,0x0,0x0,0x7F,0x10,0x28,0x44
	.DB  0x0,0x41,0x7F,0x40,0x0,0x7C,0x4,0x18
	.DB  0x4,0x78,0x7C,0x8,0x4,0x4,0x78,0x38
	.DB  0x44,0x44,0x44,0x38,0x7C,0x14,0x14,0x14
	.DB  0x8,0x8,0x14,0x14,0x18,0x7C,0x7C,0x8
	.DB  0x4,0x4,0x8,0x48,0x54,0x54,0x54,0x20
	.DB  0x4,0x3F,0x44,0x40,0x20,0x3C,0x40,0x40
	.DB  0x20,0x7C,0x1C,0x20,0x40,0x20,0x1C,0x3C
	.DB  0x40,0x30,0x40,0x3C,0x44,0x28,0x10,0x28
	.DB  0x44,0xC,0x50,0x50,0x50,0x3C,0x44,0x64
	.DB  0x54,0x4C,0x44,0x0,0x8,0x36,0x41,0x0
	.DB  0x0,0x0,0x7F,0x0,0x0,0x0,0x41,0x36
	.DB  0x8,0x0,0x2,0x1,0x2,0x4,0x2,0x7F
	.DB  0x41,0x41,0x41,0x7F
_tbl10_G101:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G101:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0
__glcd_mask:
	.DB  0x0,0x1,0x3,0x7,0xF,0x1F,0x3F,0x7F
	.DB  0xFF

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0xA2

_0x0:
	.DB  0x4E,0x6F,0x64,0x65,0x3A,0x20,0x0,0x32
	.DB  0x0,0x54,0x65,0x6D,0x70,0x3A,0x20,0x0
	.DB  0x48,0x75,0x6D,0x69,0x64,0x3A,0x20,0x0
	.DB  0x57,0x61,0x74,0x65,0x72,0x3A,0x20,0x0
	.DB  0x6D,0x6D,0x0,0x25,0x75,0x0,0x25,0x75
	.DB  0x20,0x20,0x0,0x4E,0x61,0x4E,0x0,0x25
	.DB  0x64,0x20,0x0
_0x2000060:
	.DB  0x1
_0x2000000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x07
	.DW  __REG_VARS*2

	.DW  0x07
	.DW  _0xD5
	.DW  _0x0*2

	.DW  0x02
	.DW  _0xD5+7
	.DW  _0x0*2+7

	.DW  0x07
	.DW  _0xD5+9
	.DW  _0x0*2+9

	.DW  0x08
	.DW  _0xD5+16
	.DW  _0x0*2+16

	.DW  0x08
	.DW  _0xD5+24
	.DW  _0x0*2+24

	.DW  0x03
	.DW  _0xD5+32
	.DW  _0x0*2+32

	.DW  0x01
	.DW  __seed_G100
	.DW  _0x2000060*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;
;#include <mega8.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;
;//config DHT11
;#define         DHT_DATA_IN     PIND.0
;#define         DHT_DATA_OUT    PORTD.0
;#define         DHT_DDR_DATA    DDRD.0
;
;
;#include <stdlib.h>
;#include <stdio.h>
;#include <DHT.h>

	.CSEG
_DHT_GetTemHumi:
; .FSTART _DHT_GetTemHumi
	RCALL SUBOPT_0x0
	SBIW R28,5
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	STD  Y+2,R30
	STD  Y+3,R30
	STD  Y+4,R30
	RCALL __SAVELOCR4
;	*tem -> Y+11
;	*humi -> Y+9
;	buffer -> Y+4
;	ii -> R17
;	i -> R16
;	checksum -> R19
	SBI  0x11,0
	SBI  0x12,0
	RCALL SUBOPT_0x1
	CBI  0x12,0
	LDI  R26,LOW(25)
	RCALL SUBOPT_0x2
	SBI  0x12,0
	CBI  0x11,0
	RCALL SUBOPT_0x1
	SBIS 0x10,0
	RJMP _0xD
	LDI  R30,LOW(0)
	RJMP _0x212000E
_0xD:
_0xF:
	SBIS 0x10,0
	RJMP _0xF
	RCALL SUBOPT_0x1
	SBIC 0x10,0
	RJMP _0x12
	LDI  R30,LOW(0)
	RJMP _0x212000E
_0x12:
_0x14:
	SBIC 0x10,0
	RJMP _0x14
	LDI  R16,LOW(0)
_0x18:
	CPI  R16,5
	BRSH _0x19
	LDI  R17,LOW(0)
_0x1B:
	CPI  R17,8
	BRSH _0x1C
_0x1D:
	SBIS 0x10,0
	RJMP _0x1D
	__DELAY_USB 133
	SBIS 0x10,0
	RJMP _0x20
	MOV  R30,R16
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,4
	RCALL SUBOPT_0x3
	MOVW R22,R30
	LD   R1,Z
	LDI  R30,LOW(7)
	SUB  R30,R17
	LDI  R26,LOW(1)
	RCALL __LSLB12
	OR   R30,R1
	MOVW R26,R22
	ST   X,R30
_0x21:
	SBIC 0x10,0
	RJMP _0x21
_0x20:
	SUBI R17,-1
	RJMP _0x1B
_0x1C:
	SUBI R16,-1
	RJMP _0x18
_0x19:
	LDD  R30,Y+5
	LDD  R26,Y+4
	ADD  R30,R26
	LDD  R26,Y+6
	ADD  R30,R26
	LDD  R26,Y+7
	ADD  R30,R26
	MOV  R19,R30
	LDD  R30,Y+8
	CP   R30,R19
	BREQ _0x24
	LDI  R30,LOW(0)
	RJMP _0x212000E
_0x24:
	LDD  R30,Y+6
	LDD  R26,Y+11
	LDD  R27,Y+11+1
	ST   X,R30
	LDD  R30,Y+4
	RCALL SUBOPT_0x4
	LDI  R30,LOW(1)
_0x212000E:
	RCALL __LOADLOCR4
	ADIW R28,13
	RET
; .FEND
;
;
;// Graphic Display functions
;#include <glcd.h>
;
;// Font used for displaying text
;// on the graphic display
;#include <font5x7.h>
;
;// Declare your global variables here
;unsigned char buff[20];
;unsigned char dht_nhiet_do,dht_do_am;
;
;// Voltage Reference: AREF pin
;#define ADC_VREF_TYPE ((0<<REFS1) | (0<<REFS0) | (0<<ADLAR))
;
;// Read the AD conversion result
;unsigned int read_adc(unsigned char adc_input)
; 0000 0020 {
_read_adc:
; .FSTART _read_adc
; 0000 0021 ADMUX=adc_input | ADC_VREF_TYPE;
	ST   -Y,R26
;	adc_input -> Y+0
	LD   R30,Y
	OUT  0x7,R30
; 0000 0022 // Delay needed for the stabilization of the ADC input voltage
; 0000 0023 delay_us(10);
	RCALL SUBOPT_0x5
; 0000 0024 // Start the AD conversion
; 0000 0025 ADCSRA|=(1<<ADSC);
	SBI  0x6,6
; 0000 0026 // Wait for the AD conversion to complete
; 0000 0027 while ((ADCSRA & (1<<ADIF))==0);
_0x25:
	SBIS 0x6,4
	RJMP _0x25
; 0000 0028 ADCSRA|=(1<<ADIF);
	SBI  0x6,4
; 0000 0029 return ADCW;
	IN   R30,0x4
	IN   R31,0x4+1
	RJMP _0x212000B
; 0000 002A }
; .FEND
;
;
;//config NRF24L01
;#define CE PORTD.3
;#define CSN PORTD.4
;#define SCK PORTD.2
;#define MOSI PORTB.6
;#define MISO PIND.1
;#define IRQ PINB.7
;unsigned char P_Add=0xA2, Code_tay_cam1, Code_tay_cam2, Code_tay_cam3, Code_tay_cam4;
;#include <nrf_code.h>
_config:
; .FSTART _config
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0x6
	LDI  R26,LOW(31)
	RCALL _RF_Write_TX
	LDI  R26,LOW(2)
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x7
	LDI  R30,LOW(29)
	ST   -Y,R30
	LDI  R26,LOW(4)
	RCALL _RF_Write_TX
	LDI  R30,LOW(5)
	ST   -Y,R30
	LDI  R26,LOW(2)
	RJMP _0x212000D
; .FEND
_SPI_RW_TX:
; .FSTART _SPI_RW_TX
	RCALL SUBOPT_0x8
;	Buff -> Y+1
;	bit_ctr -> R17
	LDI  R17,LOW(0)
_0x29:
	CPI  R17,8
	BRSH _0x2A
	LDD  R30,Y+1
	ANDI R30,LOW(0x80)
	BRNE _0x2B
	CBI  0x18,6
	RJMP _0x2C
_0x2B:
	SBI  0x18,6
_0x2C:
	__DELAY_USB 13
	LDD  R30,Y+1
	LSL  R30
	STD  Y+1,R30
	SBI  0x12,2
	__DELAY_USB 13
	LDI  R30,0
	SBIC 0x10,1
	LDI  R30,1
	LDD  R26,Y+1
	OR   R30,R26
	STD  Y+1,R30
	CBI  0x12,2
	SUBI R17,-1
	RJMP _0x29
_0x2A:
	LDD  R30,Y+1
	LDD  R17,Y+0
	RJMP _0x2120003
; .FEND
_RF_Write_TX:
; .FSTART _RF_Write_TX
	ST   -Y,R26
;	Reg_Add -> Y+1
;	Value -> Y+0
	CBI  0x12,4
	LDD  R30,Y+1
	ORI  R30,0x20
	MOV  R26,R30
	RCALL _SPI_RW_TX
	MOV  R13,R30
	RCALL SUBOPT_0x9
	RCALL SUBOPT_0xA
	MOV  R30,R13
	RJMP _0x2120003
; .FEND
_RF_Write_Address_TX:
; .FSTART _RF_Write_Address_TX
	ST   -Y,R26
;	Address -> Y+0
	CBI  0x12,4
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDI  R26,LOW(3)
	RCALL _RF_Write_TX
	RCALL SUBOPT_0xA
	CBI  0x12,4
	LDI  R26,LOW(42)
	RCALL _SPI_RW_TX
	RCALL SUBOPT_0x9
	RCALL SUBOPT_0x9
	RCALL SUBOPT_0x9
	RCALL SUBOPT_0x9
	RCALL SUBOPT_0x9
	RCALL SUBOPT_0xA
	CBI  0x12,4
	LDI  R26,LOW(48)
	RCALL _SPI_RW_TX
	RCALL SUBOPT_0x9
	RCALL SUBOPT_0x9
	RCALL SUBOPT_0x9
	RCALL SUBOPT_0x9
	RCALL SUBOPT_0x9
	RCALL SUBOPT_0xA
	RJMP _0x212000B
; .FEND
;	Address -> Y+1
;	Address2 -> Y+0
_RF_Mode_TX:
; .FSTART _RF_Mode_TX
	CBI  0x12,3
	RCALL SUBOPT_0x6
	LDI  R26,LOW(30)
	RJMP _0x212000D
; .FEND
_RF_Config_TX:
; .FSTART _RF_Config_TX
	LDI  R30,LOW(28)
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _RF_Write_TX
	MOV  R26,R7
	RCALL _RF_Write_Address_TX
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _RF_Write_TX
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R26,LOW(1)
_0x212000D:
	RCALL _RF_Write_TX
	RET
; .FEND
_RF_Command_TX:
; .FSTART _RF_Command_TX
	ST   -Y,R26
;	command -> Y+0
	CBI  0x12,4
	RCALL SUBOPT_0x9
	RCALL SUBOPT_0xA
	RJMP _0x212000B
; .FEND
_RF_Send_TX:
; .FSTART _RF_Send_TX
;	send -> Y+0
	MOV  R26,R7
	RCALL _RF_Write_Address_TX
	RCALL SUBOPT_0xA
	CBI  0x12,4
	LDI  R26,LOW(225)
	RCALL _SPI_RW_TX
	RCALL SUBOPT_0xA
	CBI  0x12,4
	LDI  R26,LOW(160)
	RCALL _SPI_RW_TX
	RCALL SUBOPT_0x9
	LDD  R26,Y+2
	RCALL _SPI_RW_TX
	LDD  R26,Y+4
	RCALL _SPI_RW_TX
	LDD  R26,Y+6
	RCALL _SPI_RW_TX
	LDD  R26,Y+8
	RCALL _SPI_RW_TX
	LDD  R26,Y+10
	RCALL _SPI_RW_TX
	SBI  0x12,4
	SBI  0x12,3
	__DELAY_USW 1000
	CBI  0x12,3
	RCALL SUBOPT_0x7
	MOV  R26,R7
	RCALL _RF_Write_Address_TX
	LDI  R26,LOW(225)
	RCALL _RF_Command_TX
	RJMP _0x2120008
; .FEND
;	send -> Y+0
;	Buff -> Y+1
;	bit_ctr -> R17
;	Buff -> R17
;	bit_ctr -> R16
_RF_Init_RX:
; .FSTART _RF_Init_RX
	SBI  0x12,3
	__DELAY_USW 1400
	CBI  0x12,3
	SBI  0x12,4
	RET
; .FEND
;	Reg_Add -> Y+1
;	Value -> Y+0
;	Reg_Add -> Y+1
;	Value -> Y+0
;	Reg_Add -> Y+1
;	Value -> Y+0
;	command -> Y+0
;	Address1 -> Y+3
;	Address2 -> Y+2
;	Address3 -> Y+1
;	Address4 -> Y+0
;	Address1 -> Y+0
;
;station_info data_send;
;
;#define TRIGGER PORTB.5
;#define ECHO PINB.4
;
;int change, dem;
;float distance;
;
;void set_up_sieu_am(){
; 0000 003F void set_up_sieu_am(){
_set_up_sieu_am:
; .FSTART _set_up_sieu_am
; 0000 0040     TRIGGER = 0;
	CBI  0x18,5
; 0000 0041     delay_us(2);
	__DELAY_USB 5
; 0000 0042     TRIGGER = 1;
	SBI  0x18,5
; 0000 0043     delay_us(10);
	RCALL SUBOPT_0x5
; 0000 0044     TRIGGER = 0;
	CBI  0x18,5
; 0000 0045     while(ECHO == 0);
_0xCD:
	SBIS 0x16,4
	RJMP _0xCD
; 0000 0046     dem = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _dem,R30
	STS  _dem+1,R31
; 0000 0047     change = 1;
	STS  _change,R30
	STS  _change+1,R31
; 0000 0048 }
	RET
; .FEND
;
;
;interrupt [TIM0_OVF] void timer2_ovf(){
; 0000 004B interrupt [10] void timer2_ovf(){
_timer2_ovf:
; .FSTART _timer2_ovf
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 004C     TCNT0 = 0x9C;
	LDI  R30,LOW(156)
	OUT  0x32,R30
; 0000 004D     dem++;
	LDI  R26,LOW(_dem)
	LDI  R27,HIGH(_dem)
	RCALL SUBOPT_0xB
; 0000 004E 
; 0000 004F     if(ECHO == 0 && change == 1){
	SBIC 0x16,4
	RJMP _0xD1
	LDS  R26,_change
	LDS  R27,_change+1
	SBIW R26,1
	BREQ _0xD2
_0xD1:
	RJMP _0xD0
_0xD2:
; 0000 0050     distance = dem*0.1*3.432*5;
	LDS  R30,_dem
	LDS  R31,_dem+1
	RCALL __CWD1
	RCALL __CDF1
	__GETD2N 0x3DCCCCCD
	RCALL __MULF12
	__GETD2N 0x405BA5E3
	RCALL __MULF12
	__GETD2N 0x40A00000
	RCALL __MULF12
	STS  _distance,R30
	STS  _distance+1,R31
	STS  _distance+2,R22
	STS  _distance+3,R23
; 0000 0051     dem = 0;
	LDI  R30,LOW(0)
	STS  _dem,R30
	STS  _dem+1,R30
; 0000 0052     change = 0;
	STS  _change,R30
	STS  _change+1,R30
; 0000 0053     }
; 0000 0054 }
_0xD0:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND
;
;
;
;void main(void)
; 0000 0059 {
_main:
; .FSTART _main
; 0000 005A // Declare your local variables here
; 0000 005B // Variable used to store graphic display
; 0000 005C // controller initialization data
; 0000 005D GLCDINIT_t glcd_init_data;
; 0000 005E 
; 0000 005F // Input/Output Ports initialization
; 0000 0060 // Port B initialization
; 0000 0061 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0062 DDRB=(0<<DDB7) | (1<<DDB6) | (1<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
	SBIW R28,8
;	glcd_init_data -> Y+0
	LDI  R30,LOW(96)
	OUT  0x17,R30
; 0000 0063 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0064 PORTB=(1<<PORTB7) | (1<<PORTB6) | (1<<PORTB5) | (1<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(240)
	OUT  0x18,R30
; 0000 0065 
; 0000 0066 // Port C initialization
; 0000 0067 // Function: Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0068 DDRC=(0<<DDC6) | (1<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
	LDI  R30,LOW(32)
	OUT  0x14,R30
; 0000 0069 // State: Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 006A PORTC=(0<<PORTC6) | (1<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	OUT  0x15,R30
; 0000 006B 
; 0000 006C // Port D initialization
; 0000 006D // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 006E DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (1<<DDD4) | (1<<DDD3) | (1<<DDD2) | (0<<DDD1) | (0<<DDD0);
	LDI  R30,LOW(28)
	OUT  0x11,R30
; 0000 006F // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0070 PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (1<<PORTD4) | (1<<PORTD3) | (1<<PORTD2) | (1<<PORTD1) | (0<<PORTD0);
	LDI  R30,LOW(30)
	OUT  0x12,R30
; 0000 0071 
; 0000 0072 // Timer/Counter 0 initialization
; 0000 0073 // Clock source: System Clock
; 0000 0074 // Clock value: Timer 0 Stopped
; 0000 0075 TCCR0=(0<<CS02) | (1<<CS01) | (0<<CS00);
	LDI  R30,LOW(2)
	OUT  0x33,R30
; 0000 0076 TCNT0=0x9C;
	LDI  R30,LOW(156)
	OUT  0x32,R30
; 0000 0077 
; 0000 0078 // Timer/Counter 1 initialization
; 0000 0079 // Clock source: System Clock
; 0000 007A // Clock value: Timer1 Stopped
; 0000 007B // Mode: Normal top=0xFFFF
; 0000 007C // OC1A output: Disconnected
; 0000 007D // OC1B output: Disconnected
; 0000 007E // Noise Canceler: Off
; 0000 007F // Input Capture on Falling Edge
; 0000 0080 // Timer1 Overflow Interrupt: Off
; 0000 0081 // Input Capture Interrupt: Off
; 0000 0082 // Compare A Match Interrupt: Off
; 0000 0083 // Compare B Match Interrupt: Off
; 0000 0084 TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	LDI  R30,LOW(0)
	OUT  0x2F,R30
; 0000 0085 TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
	OUT  0x2E,R30
; 0000 0086 TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 0087 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 0088 ICR1H=0x00;
	OUT  0x27,R30
; 0000 0089 ICR1L=0x00;
	OUT  0x26,R30
; 0000 008A OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 008B OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 008C OCR1BH=0x00;
	OUT  0x29,R30
; 0000 008D OCR1BL=0x00;
	OUT  0x28,R30
; 0000 008E 
; 0000 008F // Timer/Counter 2 initialization
; 0000 0090 // Clock source: System Clock
; 0000 0091 // Clock value: Timer2 Stopped
; 0000 0092 // Mode: Normal top=0xFF
; 0000 0093 // OC2 output: Disconnected
; 0000 0094 ASSR=0<<AS2;
	OUT  0x22,R30
; 0000 0095 TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	OUT  0x25,R30
; 0000 0096 TCNT2=0x00;
	OUT  0x24,R30
; 0000 0097 OCR2=0x00;
	OUT  0x23,R30
; 0000 0098 
; 0000 0099 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 009A TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (1<<TOIE0);
	LDI  R30,LOW(1)
	OUT  0x39,R30
; 0000 009B 
; 0000 009C // External Interrupt(s) initialization
; 0000 009D // INT0: Off
; 0000 009E // INT1: Off
; 0000 009F MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	LDI  R30,LOW(0)
	OUT  0x35,R30
; 0000 00A0 
; 0000 00A1 // USART initialization
; 0000 00A2 // USART disabled
; 0000 00A3 UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	OUT  0xA,R30
; 0000 00A4 
; 0000 00A5 // Analog Comparator initialization
; 0000 00A6 // Analog Comparator: Off
; 0000 00A7 // The Analog Comparator's positive input is
; 0000 00A8 // connected to the AIN0 pin
; 0000 00A9 // The Analog Comparator's negative input is
; 0000 00AA // connected to the AIN1 pin
; 0000 00AB ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 00AC 
; 0000 00AD // ADC initialization
; 0000 00AE // ADC Clock frequency: 1000.000 kHz
; 0000 00AF // ADC Voltage Reference: AREF pin
; 0000 00B0 ADMUX=ADC_VREF_TYPE;
	LDI  R30,LOW(0)
	OUT  0x7,R30
; 0000 00B1 ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADFR) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (1<<ADPS1) | (1<<ADPS0);
	LDI  R30,LOW(131)
	OUT  0x6,R30
; 0000 00B2 SFIOR=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 00B3 
; 0000 00B4 // SPI initialization
; 0000 00B5 // SPI disabled
; 0000 00B6 SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0000 00B7 
; 0000 00B8 // TWI initialization
; 0000 00B9 // TWI disabled
; 0000 00BA TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	OUT  0x36,R30
; 0000 00BB 
; 0000 00BC // Graphic Display Controller initialization
; 0000 00BD // The PCD8544 connections are specified in the
; 0000 00BE // Project|Configure|C Compiler|Libraries|Graphic Display menu:
; 0000 00BF // SDIN - PORTC Bit 3
; 0000 00C0 // SCLK - PORTC Bit 4
; 0000 00C1 // D /C - PORTC Bit 2
; 0000 00C2 // /SCE - PORTC Bit 1
; 0000 00C3 // /RES - PORTC Bit 0
; 0000 00C4 
; 0000 00C5 // Specify the current font for displaying text
; 0000 00C6 glcd_init_data.font=font5x7;
	LDI  R30,LOW(_font5x7*2)
	LDI  R31,HIGH(_font5x7*2)
	ST   Y,R30
	STD  Y+1,R31
; 0000 00C7 // No function is used for reading
; 0000 00C8 // image data from external memory
; 0000 00C9 glcd_init_data.readxmem=NULL;
	LDI  R30,LOW(0)
	STD  Y+2,R30
	STD  Y+2+1,R30
; 0000 00CA // No function is used for writing
; 0000 00CB // image data to external memory
; 0000 00CC glcd_init_data.writexmem=NULL;
	STD  Y+4,R30
	STD  Y+4+1,R30
; 0000 00CD // Set the LCD temperature coefficient
; 0000 00CE glcd_init_data.temp_coef=PCD8544_DEFAULT_TEMP_COEF;
	LDD  R30,Y+6
	ANDI R30,LOW(0xFC)
	STD  Y+6,R30
; 0000 00CF // Set the LCD bias
; 0000 00D0 glcd_init_data.bias=4;
	ANDI R30,LOW(0xE3)
	ORI  R30,0x10
	STD  Y+6,R30
; 0000 00D1 // Set the LCD contrast control voltage VLCD
; 0000 00D2 glcd_init_data.vlcd=PCD8544_DEFAULT_VLCD;
	LDD  R30,Y+7
	ANDI R30,LOW(0x80)
	ORI  R30,LOW(0x32)
	STD  Y+7,R30
; 0000 00D3 
; 0000 00D4 #asm("sei")
	sei
; 0000 00D5 
; 0000 00D6 glcd_init(&glcd_init_data);
	MOVW R26,R28
	RCALL _glcd_init
; 0000 00D7 PORTC.5 = 0;
	CBI  0x15,5
; 0000 00D8 
; 0000 00D9 config();
	RCALL _config
; 0000 00DA RF_Init_RX();
	RCALL _RF_Init_RX
; 0000 00DB RF_Config_TX();
	RCALL _RF_Config_TX
; 0000 00DC RF_Mode_TX();
	RCALL _RF_Mode_TX
; 0000 00DD 
; 0000 00DE glcd_line(48,0, 48, 15);
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0xC
	LDI  R26,LOW(15)
	RCALL SUBOPT_0xD
; 0000 00DF glcd_line(0, 15, 48, 15);
	LDI  R30,LOW(15)
	ST   -Y,R30
	RCALL SUBOPT_0xC
	LDI  R26,LOW(15)
	RCALL SUBOPT_0xD
; 0000 00E0 glcd_line(0,0,84,0);
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0xE
	LDI  R26,LOW(0)
	RCALL _glcd_line
; 0000 00E1 glcd_line(84,0, 84, 48);
	RCALL SUBOPT_0xE
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0xE
	LDI  R26,LOW(48)
	RCALL SUBOPT_0xD
; 0000 00E2 glcd_line(0, 48, 84, 48);
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0xE
	LDI  R26,LOW(48)
	RCALL SUBOPT_0xD
; 0000 00E3 glcd_line(0, 0, 0, 48);
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0x6
	LDI  R26,LOW(48)
	RCALL _glcd_line
; 0000 00E4 glcd_moveto(3,3);
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDI  R26,LOW(3)
	RCALL _glcd_moveto
; 0000 00E5 glcd_outtext("Node: ");
	__POINTW2MN _0xD5,0
	RCALL _glcd_outtext
; 0000 00E6 glcd_moveto(40, 3);
	LDI  R30,LOW(40)
	ST   -Y,R30
	LDI  R26,LOW(3)
	RCALL _glcd_moveto
; 0000 00E7 glcd_outtext("2");
	__POINTW2MN _0xD5,7
	RCALL SUBOPT_0xF
; 0000 00E8 
; 0000 00E9 glcd_moveto(4, 18);
	LDI  R26,LOW(18)
	RCALL _glcd_moveto
; 0000 00EA glcd_outtext("Temp: ");
	__POINTW2MN _0xD5,9
	RCALL SUBOPT_0xF
; 0000 00EB glcd_moveto(4, 28);
	LDI  R26,LOW(28)
	RCALL _glcd_moveto
; 0000 00EC glcd_outtext("Humid: ");
	__POINTW2MN _0xD5,16
	RCALL SUBOPT_0xF
; 0000 00ED glcd_moveto(4, 37);
	LDI  R26,LOW(37)
	RCALL _glcd_moveto
; 0000 00EE glcd_outtext("Water: ");
	__POINTW2MN _0xD5,24
	RCALL _glcd_outtext
; 0000 00EF 
; 0000 00F0 glcd_moveto(67, 28);
	LDI  R30,LOW(67)
	ST   -Y,R30
	LDI  R26,LOW(28)
	RCALL _glcd_moveto
; 0000 00F1 glcd_putchar(37);
	LDI  R26,LOW(37)
	RCALL _glcd_putchar
; 0000 00F2 glcd_moveto(67, 37);
	LDI  R30,LOW(67)
	ST   -Y,R30
	LDI  R26,LOW(37)
	RCALL _glcd_moveto
; 0000 00F3 glcd_outtext("mm");
	__POINTW2MN _0xD5,32
	RCALL _glcd_outtext
; 0000 00F4 
; 0000 00F5 while (1){
_0xD6:
; 0000 00F6         if(DHT_GetTemHumi(&dht_nhiet_do,&dht_do_am)){
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	RCALL SUBOPT_0x10
	LDI  R26,LOW(4)
	LDI  R27,HIGH(4)
	RCALL _DHT_GetTemHumi
	CPI  R30,0
	BREQ _0xD9
; 0000 00F7             sprintf(buff, "%u", (unsigned int)dht_do_am);
	RCALL SUBOPT_0x11
	__POINTW1FN _0x0,35
	RCALL SUBOPT_0x10
	MOV  R30,R4
	RCALL SUBOPT_0x12
; 0000 00F8             glcd_moveto(50, 28);
	LDI  R26,LOW(28)
	RCALL SUBOPT_0x13
; 0000 00F9             glcd_outtext(buff);
; 0000 00FA             sprintf(buff, "%u  ", (unsigned int)dht_nhiet_do);
	RCALL SUBOPT_0x11
	__POINTW1FN _0x0,38
	RCALL SUBOPT_0x10
	MOV  R30,R5
	RCALL SUBOPT_0x12
; 0000 00FB             glcd_moveto(50, 18);
	LDI  R26,LOW(18)
	RCALL SUBOPT_0x13
; 0000 00FC             glcd_outtext(buff);
; 0000 00FD         }
; 0000 00FE 
; 0000 00FF         set_up_sieu_am();
_0xD9:
	RCALL _set_up_sieu_am
; 0000 0100         glcd_moveto(50, 37);
	LDI  R30,LOW(50)
	ST   -Y,R30
	LDI  R26,LOW(37)
	RCALL _glcd_moveto
; 0000 0101         if((int)distance > 20)
	RCALL SUBOPT_0x14
	SBIW R30,21
	BRLT _0xDA
; 0000 0102             sprintf(buff, "NaN");
	RCALL SUBOPT_0x11
	__POINTW1FN _0x0,43
	RCALL SUBOPT_0x10
	LDI  R24,0
	RCALL _sprintf
	ADIW R28,4
; 0000 0103         else
	RJMP _0xDB
_0xDA:
; 0000 0104             sprintf(buff, "%d ", (int)distance);
	RCALL SUBOPT_0x11
	__POINTW1FN _0x0,47
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0x14
	RCALL __CWD1
	RCALL __PUTPARD1
	LDI  R24,4
	RCALL _sprintf
	ADIW R28,8
; 0000 0105         glcd_outtext(buff);
_0xDB:
	LDI  R26,LOW(_buff)
	LDI  R27,HIGH(_buff)
	RCALL _glcd_outtext
; 0000 0106 
; 0000 0107         data_send.flag = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	STS  _data_send,R30
	STS  _data_send+1,R31
; 0000 0108         data_send.temp = dht_nhiet_do;
	__POINTW2MN _data_send,6
	MOV  R30,R5
	LDI  R31,0
	RCALL SUBOPT_0x15
; 0000 0109         data_send.humi = dht_do_am;
	__POINTW2MN _data_send,4
	MOV  R30,R4
	LDI  R31,0
	RCALL SUBOPT_0x15
; 0000 010A         data_send.light = (int)read_adc(6)/4;
	LDI  R26,LOW(6)
	RCALL SUBOPT_0x16
	__PUTW1MN _data_send,2
; 0000 010B         data_send.sm = (int)read_adc(7)/4;
	LDI  R26,LOW(7)
	RCALL SUBOPT_0x16
	__PUTW1MN _data_send,8
; 0000 010C         data_send.water = (int)distance;
	RCALL SUBOPT_0x14
	__PUTW1MN _data_send,10
; 0000 010D 
; 0000 010E         RF_Send_TX(data_send);
	LDI  R30,LOW(_data_send)
	LDI  R31,HIGH(_data_send)
	LDI  R26,12
	RCALL __PUTPARL
	RCALL _RF_Send_TX
; 0000 010F 
; 0000 0110         delay_ms(200);
	LDI  R26,LOW(200)
	RCALL SUBOPT_0x2
; 0000 0111 
; 0000 0112         }
	RJMP _0xD6
; 0000 0113 }
_0xDC:
	RJMP _0xDC
; .FEND

	.DSEG
_0xD5:
	.BYTE 0x23

	.CSEG

	.DSEG

	.CSEG
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_put_buff_G101:
; .FSTART _put_buff_G101
	RCALL SUBOPT_0x0
	RCALL __SAVELOCR2
	RCALL SUBOPT_0x17
	ADIW R26,2
	RCALL __GETW1P
	SBIW R30,0
	BREQ _0x2020010
	RCALL SUBOPT_0x17
	RCALL SUBOPT_0x18
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2020012
	__CPWRN 16,17,2
	BRLO _0x2020013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2020012:
	RCALL SUBOPT_0x17
	ADIW R26,2
	RCALL SUBOPT_0xB
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
_0x2020013:
	RCALL SUBOPT_0x17
	RCALL __GETW1P
	TST  R31
	BRMI _0x2020014
	RCALL SUBOPT_0x17
	RCALL SUBOPT_0xB
_0x2020014:
	RJMP _0x2020015
_0x2020010:
	RCALL SUBOPT_0x17
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RCALL SUBOPT_0x15
_0x2020015:
	RCALL __LOADLOCR2
	RJMP _0x2120004
; .FEND
__print_G101:
; .FSTART __print_G101
	RCALL SUBOPT_0x0
	SBIW R28,6
	RCALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	RCALL SUBOPT_0x19
	RCALL SUBOPT_0x15
_0x2020016:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2020018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x202001C
	CPI  R18,37
	BRNE _0x202001D
	LDI  R17,LOW(1)
	RJMP _0x202001E
_0x202001D:
	RCALL SUBOPT_0x1A
_0x202001E:
	RJMP _0x202001B
_0x202001C:
	CPI  R30,LOW(0x1)
	BRNE _0x202001F
	CPI  R18,37
	BRNE _0x2020020
	RCALL SUBOPT_0x1A
	RJMP _0x20200CC
_0x2020020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2020021
	LDI  R16,LOW(1)
	RJMP _0x202001B
_0x2020021:
	CPI  R18,43
	BRNE _0x2020022
	LDI  R20,LOW(43)
	RJMP _0x202001B
_0x2020022:
	CPI  R18,32
	BRNE _0x2020023
	LDI  R20,LOW(32)
	RJMP _0x202001B
_0x2020023:
	RJMP _0x2020024
_0x202001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2020025
_0x2020024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2020026
	ORI  R16,LOW(128)
	RJMP _0x202001B
_0x2020026:
	RJMP _0x2020027
_0x2020025:
	CPI  R30,LOW(0x3)
	BREQ PC+2
	RJMP _0x202001B
_0x2020027:
	CPI  R18,48
	BRLO _0x202002A
	CPI  R18,58
	BRLO _0x202002B
_0x202002A:
	RJMP _0x2020029
_0x202002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x202001B
_0x2020029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x202002F
	RCALL SUBOPT_0x1B
	RCALL SUBOPT_0x1C
	RCALL SUBOPT_0x1B
	LDD  R26,Z+4
	ST   -Y,R26
	RCALL SUBOPT_0x1D
	RJMP _0x2020030
_0x202002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2020032
	RCALL SUBOPT_0x1E
	RCALL SUBOPT_0x1F
	RCALL SUBOPT_0x20
	RCALL _strlen
	MOV  R17,R30
	RJMP _0x2020033
_0x2020032:
	CPI  R30,LOW(0x70)
	BRNE _0x2020035
	RCALL SUBOPT_0x1E
	RCALL SUBOPT_0x1F
	RCALL SUBOPT_0x20
	RCALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2020033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2020036
_0x2020035:
	CPI  R30,LOW(0x64)
	BREQ _0x2020039
	CPI  R30,LOW(0x69)
	BRNE _0x202003A
_0x2020039:
	ORI  R16,LOW(4)
	RJMP _0x202003B
_0x202003A:
	CPI  R30,LOW(0x75)
	BRNE _0x202003C
_0x202003B:
	LDI  R30,LOW(_tbl10_G101*2)
	LDI  R31,HIGH(_tbl10_G101*2)
	RCALL SUBOPT_0x21
	LDI  R17,LOW(5)
	RJMP _0x202003D
_0x202003C:
	CPI  R30,LOW(0x58)
	BRNE _0x202003F
	ORI  R16,LOW(8)
	RJMP _0x2020040
_0x202003F:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x2020071
_0x2020040:
	LDI  R30,LOW(_tbl16_G101*2)
	LDI  R31,HIGH(_tbl16_G101*2)
	RCALL SUBOPT_0x21
	LDI  R17,LOW(4)
_0x202003D:
	SBRS R16,2
	RJMP _0x2020042
	RCALL SUBOPT_0x1E
	RCALL SUBOPT_0x1F
	RCALL SUBOPT_0x22
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2020043
	RCALL SUBOPT_0x23
	RCALL __ANEGW1
	RCALL SUBOPT_0x22
	LDI  R20,LOW(45)
_0x2020043:
	CPI  R20,0
	BREQ _0x2020044
	SUBI R17,-LOW(1)
	RJMP _0x2020045
_0x2020044:
	ANDI R16,LOW(251)
_0x2020045:
	RJMP _0x2020046
_0x2020042:
	RCALL SUBOPT_0x1E
	RCALL SUBOPT_0x1F
	RCALL SUBOPT_0x22
_0x2020046:
_0x2020036:
	SBRC R16,0
	RJMP _0x2020047
_0x2020048:
	CP   R17,R21
	BRSH _0x202004A
	SBRS R16,7
	RJMP _0x202004B
	SBRS R16,2
	RJMP _0x202004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x202004D
_0x202004C:
	LDI  R18,LOW(48)
_0x202004D:
	RJMP _0x202004E
_0x202004B:
	LDI  R18,LOW(32)
_0x202004E:
	RCALL SUBOPT_0x1A
	SUBI R21,LOW(1)
	RJMP _0x2020048
_0x202004A:
_0x2020047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x202004F
_0x2020050:
	CPI  R19,0
	BREQ _0x2020052
	SBRS R16,3
	RJMP _0x2020053
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	RCALL SUBOPT_0x21
	RJMP _0x2020054
_0x2020053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2020054:
	RCALL SUBOPT_0x1A
	CPI  R21,0
	BREQ _0x2020055
	SUBI R21,LOW(1)
_0x2020055:
	SUBI R19,LOW(1)
	RJMP _0x2020050
_0x2020052:
	RJMP _0x2020056
_0x202004F:
_0x2020058:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	RCALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	RCALL SUBOPT_0x21
_0x202005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	RCALL SUBOPT_0x24
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x202005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	RCALL SUBOPT_0x23
	SUB  R30,R26
	SBC  R31,R27
	RCALL SUBOPT_0x22
	RJMP _0x202005A
_0x202005C:
	CPI  R18,58
	BRLO _0x202005D
	SBRS R16,3
	RJMP _0x202005E
	SUBI R18,-LOW(7)
	RJMP _0x202005F
_0x202005E:
	SUBI R18,-LOW(39)
_0x202005F:
_0x202005D:
	SBRC R16,4
	RJMP _0x2020061
	CPI  R18,49
	BRSH _0x2020063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2020062
_0x2020063:
	RJMP _0x20200CD
_0x2020062:
	CP   R21,R19
	BRLO _0x2020067
	SBRS R16,0
	RJMP _0x2020068
_0x2020067:
	RJMP _0x2020066
_0x2020068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2020069
	LDI  R18,LOW(48)
_0x20200CD:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x202006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	RCALL SUBOPT_0x1D
	CPI  R21,0
	BREQ _0x202006B
	SUBI R21,LOW(1)
_0x202006B:
_0x202006A:
_0x2020069:
_0x2020061:
	RCALL SUBOPT_0x1A
	CPI  R21,0
	BREQ _0x202006C
	SUBI R21,LOW(1)
_0x202006C:
_0x2020066:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x2020059
	RJMP _0x2020058
_0x2020059:
_0x2020056:
	SBRS R16,0
	RJMP _0x202006D
_0x202006E:
	CPI  R21,0
	BREQ _0x2020070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL SUBOPT_0x1D
	RJMP _0x202006E
_0x2020070:
_0x202006D:
_0x2020071:
_0x2020030:
_0x20200CC:
	LDI  R17,LOW(0)
_0x202001B:
	RJMP _0x2020016
_0x2020018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	RCALL __GETW1P
	RCALL __LOADLOCR6
	ADIW R28,20
	RET
; .FEND
_sprintf:
; .FSTART _sprintf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	RCALL __SAVELOCR4
	RCALL SUBOPT_0x25
	SBIW R30,0
	BRNE _0x2020072
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x212000C
_0x2020072:
	MOVW R26,R28
	ADIW R26,6
	RCALL __ADDW2R15
	MOVW R16,R26
	RCALL SUBOPT_0x25
	RCALL SUBOPT_0x21
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	RCALL __ADDW2R15
	RCALL __GETW1P
	RCALL SUBOPT_0x10
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G101)
	LDI  R31,HIGH(_put_buff_G101)
	RCALL SUBOPT_0x10
	MOVW R26,R28
	ADIW R26,10
	RCALL __print_G101
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x212000C:
	RCALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_pcd8544_delay_G102:
; .FSTART _pcd8544_delay_G102
	RET
; .FEND
_pcd8544_wrbus_G102:
; .FSTART _pcd8544_wrbus_G102
	RCALL SUBOPT_0x8
	CBI  0x15,1
	LDI  R17,LOW(8)
_0x2040004:
	RCALL _pcd8544_delay_G102
	LDD  R30,Y+1
	ANDI R30,LOW(0x80)
	BREQ _0x2040006
	SBI  0x15,3
	RJMP _0x2040007
_0x2040006:
	CBI  0x15,3
_0x2040007:
	LDD  R30,Y+1
	LSL  R30
	STD  Y+1,R30
	RCALL _pcd8544_delay_G102
	SBI  0x15,4
	RCALL _pcd8544_delay_G102
	CBI  0x15,4
	SUBI R17,LOW(1)
	BRNE _0x2040004
	SBI  0x15,1
	LDD  R17,Y+0
	RJMP _0x2120003
; .FEND
_pcd8544_wrcmd:
; .FSTART _pcd8544_wrcmd
	ST   -Y,R26
	CBI  0x15,2
	LD   R26,Y
	RCALL _pcd8544_wrbus_G102
	RJMP _0x212000B
; .FEND
_pcd8544_wrdata_G102:
; .FSTART _pcd8544_wrdata_G102
	ST   -Y,R26
	SBI  0x15,2
	LD   R26,Y
	RCALL _pcd8544_wrbus_G102
	RJMP _0x212000B
; .FEND
_pcd8544_setaddr_G102:
; .FSTART _pcd8544_setaddr_G102
	RCALL SUBOPT_0x8
	LDD  R30,Y+1
	RCALL SUBOPT_0x26
	MOV  R17,R30
	LDI  R30,LOW(84)
	MUL  R30,R17
	MOVW R30,R0
	MOVW R26,R30
	LDD  R30,Y+2
	RCALL SUBOPT_0x27
	STS  _gfx_addr_G102,R30
	STS  _gfx_addr_G102+1,R31
	MOV  R30,R17
	LDD  R17,Y+0
	RJMP _0x2120002
; .FEND
_pcd8544_gotoxy:
; .FSTART _pcd8544_gotoxy
	ST   -Y,R26
	LDD  R30,Y+1
	ORI  R30,0x80
	RCALL SUBOPT_0x28
	LDD  R30,Y+1
	ST   -Y,R30
	LDD  R26,Y+1
	RCALL _pcd8544_setaddr_G102
	ORI  R30,0x40
	RCALL SUBOPT_0x28
	RJMP _0x2120003
; .FEND
_pcd8544_rdbyte:
; .FSTART _pcd8544_rdbyte
	ST   -Y,R26
	LDD  R30,Y+1
	ST   -Y,R30
	LDD  R26,Y+1
	RCALL _pcd8544_gotoxy
	LDS  R30,_gfx_addr_G102
	LDS  R31,_gfx_addr_G102+1
	RCALL SUBOPT_0x29
	LD   R30,Z
	RJMP _0x2120003
; .FEND
_pcd8544_wrbyte:
; .FSTART _pcd8544_wrbyte
	ST   -Y,R26
	RCALL SUBOPT_0x2A
	RCALL SUBOPT_0x2B
	LD   R26,Y
	STD  Z+0,R26
	RCALL _pcd8544_wrdata_G102
	RJMP _0x212000B
; .FEND
_glcd_init:
; .FSTART _glcd_init
	RCALL SUBOPT_0x0
	RCALL __SAVELOCR4
	SBI  0x14,1
	SBI  0x15,1
	SBI  0x14,4
	CBI  0x15,4
	SBI  0x14,3
	SBI  0x14,2
	SBI  0x14,0
	CBI  0x15,0
	LDI  R26,LOW(10)
	RCALL SUBOPT_0x2
	SBI  0x15,0
	RCALL SUBOPT_0x2C
	SBIW R30,0
	BREQ _0x2040008
	RCALL SUBOPT_0x2C
	LDD  R30,Z+6
	ANDI R30,LOW(0x3)
	MOV  R17,R30
	RCALL SUBOPT_0x2C
	LDD  R30,Z+6
	LSR  R30
	LSR  R30
	ANDI R30,LOW(0x7)
	MOV  R16,R30
	RCALL SUBOPT_0x2C
	LDD  R30,Z+7
	ANDI R30,0x7F
	MOV  R19,R30
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	RCALL __GETW1P
	RCALL SUBOPT_0x2D
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ADIW R26,2
	RCALL __GETW1P
	RCALL SUBOPT_0x2E
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	RCALL SUBOPT_0x18
	RJMP _0x20400A0
_0x2040008:
	LDI  R17,LOW(0)
	LDI  R16,LOW(3)
	LDI  R19,LOW(50)
	RCALL SUBOPT_0x19
	RCALL SUBOPT_0x2D
	RCALL SUBOPT_0x19
	RCALL SUBOPT_0x2E
	RCALL SUBOPT_0x19
_0x20400A0:
	__PUTW1MN _glcd_state,27
	LDI  R26,LOW(33)
	RCALL _pcd8544_wrcmd
	MOV  R30,R17
	ORI  R30,4
	RCALL SUBOPT_0x28
	MOV  R30,R16
	ORI  R30,0x10
	RCALL SUBOPT_0x28
	MOV  R30,R19
	ORI  R30,0x80
	RCALL SUBOPT_0x28
	LDI  R26,LOW(32)
	RCALL _pcd8544_wrcmd
	LDI  R26,LOW(1)
	RCALL _glcd_display
	LDI  R30,LOW(1)
	STS  _glcd_state,R30
	LDI  R30,LOW(0)
	__PUTB1MN _glcd_state,1
	LDI  R30,LOW(1)
	__PUTB1MN _glcd_state,6
	__PUTB1MN _glcd_state,7
	__PUTB1MN _glcd_state,8
	LDI  R30,LOW(255)
	__PUTB1MN _glcd_state,9
	LDI  R30,LOW(1)
	__PUTB1MN _glcd_state,16
	__POINTW1MN _glcd_state,17
	RCALL SUBOPT_0x10
	LDI  R30,LOW(255)
	ST   -Y,R30
	LDI  R26,LOW(8)
	LDI  R27,0
	RCALL _memset
	RCALL _glcd_clear
	LDI  R30,LOW(1)
	RCALL __LOADLOCR4
	RJMP _0x212000A
; .FEND
_glcd_display:
; .FSTART _glcd_display
	ST   -Y,R26
	LD   R30,Y
	CPI  R30,0
	BREQ _0x204000A
	LDI  R30,LOW(12)
	RJMP _0x204000B
_0x204000A:
	LDI  R30,LOW(8)
_0x204000B:
	RCALL SUBOPT_0x28
_0x212000B:
	ADIW R28,1
	RET
; .FEND
_glcd_clear:
; .FSTART _glcd_clear
	RCALL __SAVELOCR4
	LDI  R19,0
	__GETB1MN _glcd_state,1
	CPI  R30,0
	BREQ _0x204000D
	LDI  R19,LOW(255)
_0x204000D:
	RCALL SUBOPT_0x6
	LDI  R26,LOW(0)
	RCALL _pcd8544_gotoxy
	__GETWRN 16,17,504
_0x204000E:
	MOVW R30,R16
	__SUBWRN 16,17,1
	SBIW R30,0
	BREQ _0x2040010
	MOV  R26,R19
	RCALL _pcd8544_wrbyte
	RJMP _0x204000E
_0x2040010:
	RCALL SUBOPT_0x6
	LDI  R26,LOW(0)
	RCALL _glcd_moveto
	RCALL __LOADLOCR4
	RJMP _0x2120001
; .FEND
_glcd_putpixel:
; .FSTART _glcd_putpixel
	ST   -Y,R26
	RCALL __SAVELOCR2
	LDD  R26,Y+4
	CPI  R26,LOW(0x54)
	BRSH _0x2040012
	LDD  R26,Y+3
	CPI  R26,LOW(0x30)
	BRLO _0x2040011
_0x2040012:
	RCALL __LOADLOCR2
	RJMP _0x2120004
_0x2040011:
	LDD  R30,Y+4
	ST   -Y,R30
	LDD  R26,Y+4
	RCALL _pcd8544_rdbyte
	MOV  R17,R30
	LDD  R30,Y+3
	ANDI R30,LOW(0x7)
	LDI  R26,LOW(1)
	RCALL __LSLB12
	MOV  R16,R30
	LDD  R30,Y+2
	CPI  R30,0
	BREQ _0x2040014
	OR   R17,R16
	RJMP _0x2040015
_0x2040014:
	MOV  R30,R16
	COM  R30
	AND  R17,R30
_0x2040015:
	MOV  R26,R17
	RCALL _pcd8544_wrbyte
	RCALL __LOADLOCR2
	RJMP _0x2120004
; .FEND
_pcd8544_wrmasked_G102:
; .FSTART _pcd8544_wrmasked_G102
	RCALL SUBOPT_0x8
	LDD  R30,Y+5
	ST   -Y,R30
	LDD  R26,Y+5
	RCALL _pcd8544_rdbyte
	MOV  R17,R30
	LDD  R30,Y+1
	CPI  R30,LOW(0x7)
	BREQ _0x2040020
	CPI  R30,LOW(0x8)
	BRNE _0x2040021
_0x2040020:
	LDD  R30,Y+3
	ST   -Y,R30
	LDD  R26,Y+2
	RCALL _glcd_mappixcolor1bit
	STD  Y+3,R30
	RJMP _0x2040022
_0x2040021:
	CPI  R30,LOW(0x3)
	BRNE _0x2040024
	LDD  R30,Y+3
	COM  R30
	STD  Y+3,R30
	RJMP _0x2040025
_0x2040024:
	CPI  R30,0
	BRNE _0x2040026
_0x2040025:
_0x2040022:
	LDD  R30,Y+2
	COM  R30
	AND  R17,R30
	RJMP _0x2040027
_0x2040026:
	CPI  R30,LOW(0x2)
	BRNE _0x2040028
_0x2040027:
	LDD  R30,Y+2
	LDD  R26,Y+3
	AND  R30,R26
	OR   R17,R30
	RJMP _0x204001E
_0x2040028:
	CPI  R30,LOW(0x1)
	BRNE _0x2040029
	LDD  R30,Y+2
	LDD  R26,Y+3
	AND  R30,R26
	EOR  R17,R30
	RJMP _0x204001E
_0x2040029:
	CPI  R30,LOW(0x4)
	BRNE _0x204001E
	LDD  R30,Y+2
	COM  R30
	LDD  R26,Y+3
	OR   R30,R26
	AND  R17,R30
_0x204001E:
	MOV  R26,R17
	RCALL _pcd8544_wrbyte
	LDD  R17,Y+0
_0x212000A:
	ADIW R28,6
	RET
; .FEND
_glcd_block:
; .FSTART _glcd_block
	ST   -Y,R26
	SBIW R28,3
	RCALL __SAVELOCR6
	LDD  R26,Y+16
	CPI  R26,LOW(0x54)
	BRSH _0x204002C
	LDD  R26,Y+15
	CPI  R26,LOW(0x30)
	BRSH _0x204002C
	LDD  R26,Y+14
	CPI  R26,LOW(0x0)
	BREQ _0x204002C
	LDD  R26,Y+13
	CPI  R26,LOW(0x0)
	BRNE _0x204002B
_0x204002C:
	RJMP _0x2120009
_0x204002B:
	LDD  R30,Y+14
	STD  Y+8,R30
	LDD  R26,Y+16
	CLR  R27
	LDD  R30,Y+14
	RCALL SUBOPT_0x2F
	CPI  R26,LOW(0x55)
	LDI  R30,HIGH(0x55)
	CPC  R27,R30
	BRLO _0x204002E
	LDD  R26,Y+16
	LDI  R30,LOW(84)
	SUB  R30,R26
	STD  Y+14,R30
_0x204002E:
	LDD  R18,Y+13
	LDD  R26,Y+15
	CLR  R27
	LDD  R30,Y+13
	RCALL SUBOPT_0x2F
	SBIW R26,49
	BRLO _0x204002F
	LDD  R26,Y+15
	LDI  R30,LOW(48)
	SUB  R30,R26
	STD  Y+13,R30
_0x204002F:
	LDD  R26,Y+9
	CPI  R26,LOW(0x6)
	BREQ PC+2
	RJMP _0x2040030
	LDD  R30,Y+12
	CPI  R30,LOW(0x1)
	BRNE _0x2040034
	RJMP _0x2120009
_0x2040034:
	CPI  R30,LOW(0x3)
	BRNE _0x2040037
	__GETW1MN _glcd_state,27
	SBIW R30,0
	BRNE _0x2040036
	RJMP _0x2120009
_0x2040036:
_0x2040037:
	LDD  R16,Y+8
	LDD  R30,Y+13
	RCALL SUBOPT_0x26
	MOV  R19,R30
	MOV  R30,R18
	ANDI R30,LOW(0x7)
	BRNE _0x2040039
	LDD  R26,Y+13
	CP   R18,R26
	BREQ _0x2040038
_0x2040039:
	MOV  R26,R16
	CLR  R27
	MOV  R30,R19
	RCALL SUBOPT_0x30
	RCALL SUBOPT_0x24
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x21
	LSR  R18
	LSR  R18
	LSR  R18
	MOV  R21,R19
_0x204003B:
	PUSH R21
	SUBI R21,-1
	MOV  R30,R18
	POP  R26
	CP   R30,R26
	BRLO _0x204003D
	MOV  R17,R16
_0x204003E:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x2040040
	RCALL SUBOPT_0x31
	RJMP _0x204003E
_0x2040040:
	RJMP _0x204003B
_0x204003D:
_0x2040038:
	LDD  R26,Y+14
	CP   R16,R26
	BREQ _0x2040041
	LDD  R30,Y+14
	RCALL SUBOPT_0x24
	RCALL SUBOPT_0x27
	RCALL SUBOPT_0x21
	LDD  R30,Y+13
	ANDI R30,LOW(0x7)
	BREQ _0x2040042
	SUBI R19,-LOW(1)
_0x2040042:
	LDI  R18,LOW(0)
_0x2040043:
	PUSH R18
	SUBI R18,-1
	MOV  R30,R19
	POP  R26
	CP   R26,R30
	BRSH _0x2040045
	LDD  R17,Y+14
_0x2040046:
	PUSH R17
	SUBI R17,-1
	MOV  R30,R16
	POP  R26
	CP   R26,R30
	BRSH _0x2040048
	RCALL SUBOPT_0x31
	RJMP _0x2040046
_0x2040048:
	LDD  R30,Y+14
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RCALL SUBOPT_0x27
	RCALL SUBOPT_0x21
	RJMP _0x2040043
_0x2040045:
_0x2040041:
_0x2040030:
	LDD  R30,Y+15
	ANDI R30,LOW(0x7)
	MOV  R19,R30
_0x2040049:
	LDD  R30,Y+13
	CPI  R30,0
	BRNE PC+2
	RJMP _0x204004B
	RCALL SUBOPT_0x23
	RCALL SUBOPT_0x21
	LDI  R17,LOW(0)
	LDD  R16,Y+16
	CPI  R19,0
	BREQ PC+2
	RJMP _0x204004C
	LDD  R26,Y+13
	CPI  R26,LOW(0x8)
	BRSH PC+2
	RJMP _0x204004D
	LDD  R30,Y+9
	CPI  R30,0
	BREQ _0x2040052
	CPI  R30,LOW(0x3)
	BRNE _0x2040053
_0x2040052:
	RJMP _0x2040054
_0x2040053:
	CPI  R30,LOW(0x7)
	BRNE _0x2040055
_0x2040054:
	RJMP _0x2040056
_0x2040055:
	CPI  R30,LOW(0x8)
	BRNE _0x2040057
_0x2040056:
	RJMP _0x2040058
_0x2040057:
	CPI  R30,LOW(0x9)
	BRNE _0x2040059
_0x2040058:
	RJMP _0x204005A
_0x2040059:
	CPI  R30,LOW(0xA)
	BRNE _0x204005B
_0x204005A:
	RCALL SUBOPT_0x32
	RCALL _pcd8544_gotoxy
	RJMP _0x2040050
_0x204005B:
	CPI  R30,LOW(0x6)
	BRNE _0x2040050
	RCALL SUBOPT_0x32
	RCALL _pcd8544_setaddr_G102
_0x2040050:
_0x204005D:
	PUSH R17
	RCALL SUBOPT_0x33
	POP  R26
	CP   R26,R30
	BRSH _0x204005F
	LDD  R26,Y+9
	CPI  R26,LOW(0x6)
	BRNE _0x2040060
	RCALL SUBOPT_0x34
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0x2A
	RCALL SUBOPT_0x2B
	LD   R26,Z
	RCALL _glcd_writemem
	RJMP _0x2040061
_0x2040060:
	LDD  R30,Y+9
	CPI  R30,LOW(0x9)
	BRNE _0x2040065
	LDI  R21,LOW(0)
	RJMP _0x2040066
_0x2040065:
	CPI  R30,LOW(0xA)
	BRNE _0x2040064
	LDI  R21,LOW(255)
	RJMP _0x2040066
_0x2040064:
	RCALL SUBOPT_0x34
	RCALL SUBOPT_0x35
	MOV  R21,R30
	LDD  R30,Y+9
	CPI  R30,LOW(0x7)
	BREQ _0x204006D
	CPI  R30,LOW(0x8)
	BRNE _0x204006E
_0x204006D:
_0x2040066:
	RCALL SUBOPT_0x36
	MOV  R21,R30
	RJMP _0x204006F
_0x204006E:
	CPI  R30,LOW(0x3)
	BRNE _0x2040071
	COM  R21
	RJMP _0x2040072
_0x2040071:
	CPI  R30,0
	BRNE _0x2040074
_0x2040072:
_0x204006F:
	MOV  R26,R21
	RCALL _pcd8544_wrdata_G102
	RJMP _0x204006B
_0x2040074:
	RCALL SUBOPT_0x37
	LDI  R30,LOW(255)
	ST   -Y,R30
	LDD  R26,Y+13
	RCALL _pcd8544_wrmasked_G102
_0x204006B:
_0x2040061:
	RJMP _0x204005D
_0x204005F:
	LDD  R30,Y+15
	SUBI R30,-LOW(8)
	STD  Y+15,R30
	LDD  R30,Y+13
	SUBI R30,LOW(8)
	STD  Y+13,R30
	RJMP _0x2040075
_0x204004D:
	LDD  R21,Y+13
	LDI  R18,LOW(0)
	LDI  R30,LOW(0)
	STD  Y+13,R30
	RJMP _0x2040076
_0x204004C:
	MOV  R30,R19
	LDD  R26,Y+13
	ADD  R26,R30
	CPI  R26,LOW(0x9)
	BRSH _0x2040077
	LDD  R18,Y+13
	LDI  R30,LOW(0)
	STD  Y+13,R30
	RJMP _0x2040078
_0x2040077:
	LDI  R30,LOW(8)
	SUB  R30,R19
	MOV  R18,R30
_0x2040078:
	ST   -Y,R19
	MOV  R26,R18
	RCALL _glcd_getmask
	MOV  R20,R30
	LDD  R30,Y+9
	CPI  R30,LOW(0x6)
	BRNE _0x204007C
	RCALL SUBOPT_0x32
	RCALL _pcd8544_setaddr_G102
_0x204007D:
	PUSH R17
	RCALL SUBOPT_0x33
	POP  R26
	CP   R26,R30
	BRSH _0x204007F
	RCALL SUBOPT_0x2A
	RCALL SUBOPT_0x2B
	LD   R30,Z
	AND  R30,R20
	MOV  R26,R30
	MOV  R30,R19
	RCALL __LSRB12
	RCALL SUBOPT_0x38
	MOV  R30,R19
	MOV  R26,R20
	RCALL __LSRB12
	RCALL SUBOPT_0x39
	RCALL SUBOPT_0x10
	MOV  R26,R21
	RCALL _glcd_writemem
	RJMP _0x204007D
_0x204007F:
	RJMP _0x204007B
_0x204007C:
	CPI  R30,LOW(0x9)
	BRNE _0x2040080
	LDI  R21,LOW(0)
	RJMP _0x2040081
_0x2040080:
	CPI  R30,LOW(0xA)
	BRNE _0x2040087
	LDI  R21,LOW(255)
_0x2040081:
	RCALL SUBOPT_0x36
	MOV  R26,R30
	MOV  R30,R19
	RCALL __LSLB12
	MOV  R21,R30
_0x2040084:
	PUSH R17
	RCALL SUBOPT_0x33
	POP  R26
	CP   R26,R30
	BRSH _0x2040086
	RCALL SUBOPT_0x37
	ST   -Y,R20
	LDI  R26,LOW(0)
	RCALL _pcd8544_wrmasked_G102
	RJMP _0x2040084
_0x2040086:
	RJMP _0x204007B
_0x2040087:
_0x2040088:
	PUSH R17
	RCALL SUBOPT_0x33
	POP  R26
	CP   R26,R30
	BRSH _0x204008A
	RCALL SUBOPT_0x3A
	MOV  R26,R30
	MOV  R30,R19
	RCALL __LSLB12
	RCALL SUBOPT_0x3B
	RJMP _0x2040088
_0x204008A:
_0x204007B:
	LDD  R30,Y+13
	CPI  R30,0
	BRNE _0x204008B
	RJMP _0x204004B
_0x204008B:
	LDD  R26,Y+13
	CPI  R26,LOW(0x8)
	BRSH _0x204008C
	LDD  R30,Y+13
	SUB  R30,R18
	MOV  R21,R30
	LDI  R30,LOW(0)
	RJMP _0x20400A1
_0x204008C:
	MOV  R21,R19
	LDD  R30,Y+13
	SUBI R30,LOW(8)
_0x20400A1:
	STD  Y+13,R30
	LDI  R17,LOW(0)
	LDD  R30,Y+15
	SUBI R30,-LOW(8)
	STD  Y+15,R30
	LDI  R30,LOW(8)
	SUB  R30,R19
	MOV  R18,R30
	LDD  R16,Y+16
	RCALL SUBOPT_0x23
	RCALL SUBOPT_0x21
_0x2040076:
	MOV  R30,R21
	LDI  R31,0
	SUBI R30,LOW(-__glcd_mask*2)
	SBCI R31,HIGH(-__glcd_mask*2)
	LPM  R20,Z
	LDD  R30,Y+9
	CPI  R30,LOW(0x6)
	BRNE _0x2040091
	RCALL SUBOPT_0x32
	RCALL _pcd8544_setaddr_G102
_0x2040092:
	PUSH R17
	RCALL SUBOPT_0x33
	POP  R26
	CP   R26,R30
	BRSH _0x2040094
	RCALL SUBOPT_0x2A
	RCALL SUBOPT_0x2B
	LD   R30,Z
	AND  R30,R20
	MOV  R26,R30
	MOV  R30,R18
	RCALL __LSLB12
	RCALL SUBOPT_0x38
	MOV  R30,R18
	MOV  R26,R20
	RCALL __LSLB12
	RCALL SUBOPT_0x39
	RCALL SUBOPT_0x10
	MOV  R26,R21
	RCALL _glcd_writemem
	RJMP _0x2040092
_0x2040094:
	RJMP _0x2040090
_0x2040091:
	CPI  R30,LOW(0x9)
	BRNE _0x2040095
	LDI  R21,LOW(0)
	RJMP _0x2040096
_0x2040095:
	CPI  R30,LOW(0xA)
	BRNE _0x204009C
	LDI  R21,LOW(255)
_0x2040096:
	RCALL SUBOPT_0x36
	MOV  R26,R30
	MOV  R30,R18
	RCALL __LSRB12
	MOV  R21,R30
_0x2040099:
	PUSH R17
	RCALL SUBOPT_0x33
	POP  R26
	CP   R26,R30
	BRSH _0x204009B
	RCALL SUBOPT_0x37
	ST   -Y,R20
	LDI  R26,LOW(0)
	RCALL _pcd8544_wrmasked_G102
	RJMP _0x2040099
_0x204009B:
	RJMP _0x2040090
_0x204009C:
_0x204009D:
	PUSH R17
	RCALL SUBOPT_0x33
	POP  R26
	CP   R26,R30
	BRSH _0x204009F
	RCALL SUBOPT_0x3A
	MOV  R26,R30
	MOV  R30,R18
	RCALL __LSRB12
	RCALL SUBOPT_0x3B
	RJMP _0x204009D
_0x204009F:
_0x2040090:
_0x2040075:
	LDD  R30,Y+8
	RCALL SUBOPT_0x24
	RCALL SUBOPT_0x27
	RCALL SUBOPT_0x22
	RJMP _0x2040049
_0x204004B:
_0x2120009:
	RCALL __LOADLOCR6
	ADIW R28,17
	RET
; .FEND

	.CSEG
_glcd_clipx:
; .FSTART _glcd_clipx
	RCALL SUBOPT_0x3C
	BRLT _0x2060003
	RCALL SUBOPT_0x19
	RJMP _0x2120003
_0x2060003:
	RCALL SUBOPT_0x3D
	CPI  R26,LOW(0x54)
	LDI  R30,HIGH(0x54)
	CPC  R27,R30
	BRLT _0x2060004
	LDI  R30,LOW(83)
	LDI  R31,HIGH(83)
	RJMP _0x2120003
_0x2060004:
	LD   R30,Y
	LDD  R31,Y+1
	RJMP _0x2120003
; .FEND
_glcd_clipy:
; .FSTART _glcd_clipy
	RCALL SUBOPT_0x3C
	BRLT _0x2060005
	RCALL SUBOPT_0x19
	RJMP _0x2120003
_0x2060005:
	RCALL SUBOPT_0x3D
	SBIW R26,48
	BRLT _0x2060006
	LDI  R30,LOW(47)
	LDI  R31,HIGH(47)
	RJMP _0x2120003
_0x2060006:
	LD   R30,Y
	LDD  R31,Y+1
	RJMP _0x2120003
; .FEND
_glcd_getcharw_G103:
; .FSTART _glcd_getcharw_G103
	RCALL SUBOPT_0x0
	SBIW R28,3
	RCALL SUBOPT_0x3E
	MOVW R16,R30
	MOV  R0,R16
	OR   R0,R17
	BRNE _0x206000B
	RCALL SUBOPT_0x19
	RJMP _0x2120007
_0x206000B:
	RCALL SUBOPT_0x3F
	STD  Y+7,R0
	RCALL SUBOPT_0x3F
	STD  Y+6,R0
	RCALL SUBOPT_0x3F
	STD  Y+8,R0
	LDD  R30,Y+11
	LDD  R26,Y+8
	CP   R30,R26
	BRSH _0x206000C
	RCALL SUBOPT_0x19
	RJMP _0x2120007
_0x206000C:
	MOVW R30,R16
	__ADDWRN 16,17,1
	LPM  R21,Z
	LDD  R26,Y+8
	CLR  R27
	CLR  R30
	ADD  R26,R21
	ADC  R27,R30
	LDD  R30,Y+11
	LDI  R31,0
	CP   R30,R26
	CPC  R31,R27
	BRLO _0x206000D
	RCALL SUBOPT_0x19
	RJMP _0x2120007
_0x206000D:
	LDD  R30,Y+6
	RCALL SUBOPT_0x26
	MOV  R20,R30
	LDD  R30,Y+6
	ANDI R30,LOW(0x7)
	BREQ _0x206000E
	SUBI R20,-LOW(1)
_0x206000E:
	LDD  R30,Y+7
	CPI  R30,0
	BREQ _0x206000F
	RCALL SUBOPT_0x4
	LDD  R26,Y+8
	LDD  R30,Y+11
	SUB  R30,R26
	LDI  R31,0
	MOVW R26,R30
	LDD  R30,Y+7
	RCALL SUBOPT_0x30
	MOVW R26,R30
	MOV  R30,R20
	RCALL SUBOPT_0x30
	ADD  R30,R16
	ADC  R31,R17
	RJMP _0x2120007
_0x206000F:
	MOVW R18,R16
	MOV  R30,R21
	LDI  R31,0
	__ADDWRR 16,17,30,31
_0x2060010:
	LDD  R26,Y+8
	SUBI R26,-LOW(1)
	STD  Y+8,R26
	SUBI R26,LOW(1)
	LDD  R30,Y+11
	CP   R26,R30
	BRSH _0x2060012
	MOVW R30,R18
	__ADDWRN 18,19,1
	LPM  R26,Z
	LDI  R27,0
	MOV  R30,R20
	RCALL SUBOPT_0x30
	__ADDWRR 16,17,30,31
	RJMP _0x2060010
_0x2060012:
	MOVW R30,R18
	LPM  R30,Z
	RCALL SUBOPT_0x4
	MOVW R30,R16
_0x2120007:
	RCALL __LOADLOCR6
_0x2120008:
	ADIW R28,12
	RET
; .FEND
_glcd_new_line_G103:
; .FSTART _glcd_new_line_G103
	LDI  R30,LOW(0)
	__PUTB1MN _glcd_state,2
	__GETB2MN _glcd_state,3
	CLR  R27
	RCALL SUBOPT_0x40
	RCALL SUBOPT_0x2F
	__GETB1MN _glcd_state,7
	RCALL SUBOPT_0x2F
	RCALL _glcd_clipy
	__PUTB1MN _glcd_state,3
	RET
; .FEND
_glcd_putchar:
; .FSTART _glcd_putchar
	ST   -Y,R26
	SBIW R28,1
	RCALL SUBOPT_0x3E
	SBIW R30,0
	BRNE PC+2
	RJMP _0x206001F
	LDD  R26,Y+7
	CPI  R26,LOW(0xA)
	BRNE _0x2060020
	RJMP _0x2060021
_0x2060020:
	LDD  R30,Y+7
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,7
	RCALL _glcd_getcharw_G103
	MOVW R20,R30
	SBIW R30,0
	BRNE _0x2060022
	RJMP _0x2120006
_0x2060022:
	__GETB1MN _glcd_state,6
	LDD  R26,Y+6
	ADD  R30,R26
	MOV  R19,R30
	__GETB2MN _glcd_state,2
	CLR  R27
	RCALL SUBOPT_0x27
	MOVW R16,R30
	__CPWRN 16,17,85
	BRLO _0x2060023
	MOV  R16,R19
	CLR  R17
	RCALL _glcd_new_line_G103
_0x2060023:
	__GETB1MN _glcd_state,2
	RCALL SUBOPT_0x41
	LDD  R30,Y+8
	ST   -Y,R30
	RCALL SUBOPT_0x40
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	ST   -Y,R21
	ST   -Y,R20
	LDI  R26,LOW(7)
	RCALL _glcd_block
	__GETB1MN _glcd_state,2
	LDD  R26,Y+6
	ADD  R30,R26
	RCALL SUBOPT_0x41
	__GETB1MN _glcd_state,6
	ST   -Y,R30
	RCALL SUBOPT_0x40
	ST   -Y,R30
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0x42
	__GETB1MN _glcd_state,2
	ST   -Y,R30
	__GETB2MN _glcd_state,3
	RCALL SUBOPT_0x40
	ADD  R30,R26
	ST   -Y,R30
	ST   -Y,R19
	__GETB1MN _glcd_state,7
	ST   -Y,R30
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0x42
	LDI  R30,LOW(84)
	LDI  R31,HIGH(84)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x2060024
_0x2060021:
	RCALL _glcd_new_line_G103
	RJMP _0x2120006
_0x2060024:
_0x206001F:
	__PUTBMRN _glcd_state,2,16
_0x2120006:
	RCALL __LOADLOCR6
	ADIW R28,8
	RET
; .FEND
_glcd_outtext:
; .FSTART _glcd_outtext
	RCALL SUBOPT_0x0
	ST   -Y,R17
_0x206002E:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2060030
	MOV  R26,R17
	RCALL _glcd_putchar
	RJMP _0x206002E
_0x2060030:
	LDD  R17,Y+0
	RJMP _0x2120002
; .FEND
_glcd_putpixelm_G103:
; .FSTART _glcd_putpixelm_G103
	ST   -Y,R26
	LDD  R30,Y+2
	ST   -Y,R30
	LDD  R30,Y+2
	ST   -Y,R30
	__GETB1MN _glcd_state,9
	LDD  R26,Y+2
	AND  R30,R26
	BREQ _0x206003E
	LDS  R30,_glcd_state
	RJMP _0x206003F
_0x206003E:
	__GETB1MN _glcd_state,1
_0x206003F:
	MOV  R26,R30
	RCALL _glcd_putpixel
	LD   R30,Y
	LSL  R30
	ST   Y,R30
	CPI  R30,0
	BRNE _0x2060041
	LDI  R30,LOW(1)
	ST   Y,R30
_0x2060041:
	LD   R30,Y
	RJMP _0x2120002
; .FEND
_glcd_moveto:
; .FSTART _glcd_moveto
	ST   -Y,R26
	LDD  R26,Y+1
	CLR  R27
	RCALL _glcd_clipx
	__PUTB1MN _glcd_state,2
	LD   R26,Y
	CLR  R27
	RCALL _glcd_clipy
	__PUTB1MN _glcd_state,3
	RJMP _0x2120003
; .FEND
_glcd_line:
; .FSTART _glcd_line
	ST   -Y,R26
	SBIW R28,11
	RCALL __SAVELOCR6
	LDD  R26,Y+20
	CLR  R27
	RCALL _glcd_clipx
	STD  Y+20,R30
	LDD  R26,Y+18
	CLR  R27
	RCALL _glcd_clipx
	STD  Y+18,R30
	LDD  R26,Y+19
	CLR  R27
	RCALL _glcd_clipy
	STD  Y+19,R30
	LDD  R26,Y+17
	CLR  R27
	RCALL _glcd_clipy
	STD  Y+17,R30
	LDD  R30,Y+18
	__PUTB1MN _glcd_state,2
	LDD  R30,Y+17
	__PUTB1MN _glcd_state,3
	LDI  R30,LOW(1)
	STD  Y+8,R30
	LDD  R30,Y+17
	LDD  R26,Y+19
	CP   R30,R26
	BRNE _0x2060042
	LDD  R17,Y+20
	LDD  R26,Y+18
	CP   R17,R26
	BRNE _0x2060043
	ST   -Y,R17
	LDD  R30,Y+20
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _glcd_putpixelm_G103
	RJMP _0x2120005
_0x2060043:
	LDD  R26,Y+18
	CP   R17,R26
	BRSH _0x2060044
	LDD  R30,Y+18
	SUB  R30,R17
	MOV  R16,R30
	__GETWRN 20,21,1
	RJMP _0x2060045
_0x2060044:
	LDD  R26,Y+18
	MOV  R30,R17
	SUB  R30,R26
	MOV  R16,R30
	__GETWRN 20,21,-1
_0x2060045:
_0x2060047:
	LDD  R19,Y+19
	LDI  R30,LOW(0)
	STD  Y+6,R30
_0x2060049:
	RCALL SUBOPT_0x43
	BRSH _0x206004B
	RCALL SUBOPT_0x44
	INC  R19
	LDD  R26,Y+10
	RCALL _glcd_putpixelm_G103
	STD  Y+7,R30
	RJMP _0x2060049
_0x206004B:
	LDD  R30,Y+7
	STD  Y+8,R30
	ADD  R17,R20
	MOV  R30,R16
	SUBI R16,1
	CPI  R30,0
	BRNE _0x2060047
	RJMP _0x206004C
_0x2060042:
	LDD  R30,Y+18
	LDD  R26,Y+20
	CP   R30,R26
	BRNE _0x206004D
	LDD  R19,Y+19
	LDD  R26,Y+17
	CP   R19,R26
	BRSH _0x206004E
	LDD  R30,Y+17
	SUB  R30,R19
	MOV  R18,R30
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x206011B
_0x206004E:
	LDD  R26,Y+17
	MOV  R30,R19
	SUB  R30,R26
	MOV  R18,R30
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
_0x206011B:
	STD  Y+13,R30
	STD  Y+13+1,R31
_0x2060051:
	LDD  R17,Y+20
	LDI  R30,LOW(0)
	STD  Y+6,R30
_0x2060053:
	RCALL SUBOPT_0x43
	BRSH _0x2060055
	ST   -Y,R17
	INC  R17
	ST   -Y,R19
	LDD  R26,Y+10
	RCALL _glcd_putpixelm_G103
	STD  Y+7,R30
	RJMP _0x2060053
_0x2060055:
	LDD  R30,Y+7
	STD  Y+8,R30
	LDD  R30,Y+13
	ADD  R19,R30
	MOV  R30,R18
	SUBI R18,1
	CPI  R30,0
	BRNE _0x2060051
	RJMP _0x2060056
_0x206004D:
	LDI  R30,LOW(0)
	STD  Y+6,R30
_0x2060057:
	RCALL SUBOPT_0x43
	BRLO PC+2
	RJMP _0x2060059
	LDD  R17,Y+20
	LDD  R19,Y+19
	LDI  R30,LOW(1)
	MOV  R18,R30
	MOV  R16,R30
	LDD  R26,Y+18
	CLR  R27
	LDD  R30,Y+20
	LDI  R31,0
	SUB  R26,R30
	SBC  R27,R31
	MOVW R20,R26
	TST  R21
	BRPL _0x206005A
	LDI  R16,LOW(255)
	MOVW R30,R20
	RCALL __ANEGW1
	MOVW R20,R30
_0x206005A:
	MOVW R30,R20
	LSL  R30
	ROL  R31
	STD  Y+15,R30
	STD  Y+15+1,R31
	LDD  R26,Y+17
	CLR  R27
	LDD  R30,Y+19
	LDI  R31,0
	SUB  R26,R30
	SBC  R27,R31
	STD  Y+13,R26
	STD  Y+13+1,R27
	LDD  R26,Y+14
	TST  R26
	BRPL _0x206005B
	LDI  R18,LOW(255)
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	RCALL __ANEGW1
	STD  Y+13,R30
	STD  Y+13+1,R31
_0x206005B:
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	LSL  R30
	ROL  R31
	STD  Y+11,R30
	STD  Y+11+1,R31
	RCALL SUBOPT_0x44
	LDI  R26,LOW(1)
	RCALL _glcd_putpixelm_G103
	STD  Y+8,R30
	LDI  R30,LOW(0)
	STD  Y+9,R30
	STD  Y+9+1,R30
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	CP   R20,R26
	CPC  R21,R27
	BRLT _0x206005C
_0x206005E:
	ADD  R17,R16
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	RCALL SUBOPT_0x45
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x46
	RCALL SUBOPT_0x45
	CP   R20,R26
	CPC  R21,R27
	BRGE _0x2060060
	ADD  R19,R18
	LDD  R26,Y+15
	LDD  R27,Y+15+1
	RCALL SUBOPT_0x47
_0x2060060:
	RCALL SUBOPT_0x44
	LDD  R26,Y+10
	RCALL _glcd_putpixelm_G103
	STD  Y+8,R30
	LDD  R30,Y+18
	CP   R30,R17
	BRNE _0x206005E
	RJMP _0x2060061
_0x206005C:
_0x2060063:
	ADD  R19,R18
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	RCALL SUBOPT_0x45
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x46
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	RCALL SUBOPT_0x45
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x2060065
	ADD  R17,R16
	LDD  R26,Y+11
	LDD  R27,Y+11+1
	RCALL SUBOPT_0x47
_0x2060065:
	RCALL SUBOPT_0x44
	LDD  R26,Y+10
	RCALL _glcd_putpixelm_G103
	STD  Y+8,R30
	LDD  R30,Y+17
	CP   R30,R19
	BRNE _0x2060063
_0x2060061:
	LDD  R30,Y+19
	SUBI R30,-LOW(1)
	STD  Y+19,R30
	LDD  R30,Y+17
	SUBI R30,-LOW(1)
	STD  Y+17,R30
	RJMP _0x2060057
_0x2060059:
_0x2060056:
_0x206004C:
_0x2120005:
	RCALL __LOADLOCR6
	ADIW R28,21
	RET
; .FEND

	.CSEG

	.CSEG

	.CSEG
_memset:
; .FSTART _memset
	RCALL SUBOPT_0x0
    ldd  r27,y+1
    ld   r26,y
    adiw r26,0
    breq memset1
    ldd  r31,y+4
    ldd  r30,y+3
    ldd  r22,y+2
memset0:
    st   z+,r22
    sbiw r26,1
    brne memset0
memset1:
    ldd  r30,y+3
    ldd  r31,y+4
_0x2120004:
	ADIW R28,5
	RET
; .FEND
_strlen:
; .FSTART _strlen
	RCALL SUBOPT_0x0
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
; .FEND
_strlenf:
; .FSTART _strlenf
	RCALL SUBOPT_0x0
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret
; .FEND

	.CSEG
_glcd_getmask:
; .FSTART _glcd_getmask
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__glcd_mask*2)
	SBCI R31,HIGH(-__glcd_mask*2)
	LPM  R26,Z
	LDD  R30,Y+1
	RCALL __LSLB12
_0x2120003:
	ADIW R28,2
	RET
; .FEND
_glcd_mappixcolor1bit:
; .FSTART _glcd_mappixcolor1bit
	RCALL SUBOPT_0x8
	LDD  R30,Y+1
	CPI  R30,LOW(0x7)
	BREQ _0x2100007
	CPI  R30,LOW(0xA)
	BRNE _0x2100008
_0x2100007:
	LDS  R17,_glcd_state
	RJMP _0x2100009
_0x2100008:
	CPI  R30,LOW(0x9)
	BRNE _0x210000B
	__GETBRMN 17,_glcd_state,1
	RJMP _0x2100009
_0x210000B:
	CPI  R30,LOW(0x8)
	BRNE _0x2100005
	__GETBRMN 17,_glcd_state,16
_0x2100009:
	__GETB1MN _glcd_state,1
	CPI  R30,0
	BREQ _0x210000E
	CPI  R17,0
	BREQ _0x210000F
	LDI  R30,LOW(255)
	LDD  R17,Y+0
	RJMP _0x2120002
_0x210000F:
	LDD  R30,Y+2
	COM  R30
	LDD  R17,Y+0
	RJMP _0x2120002
_0x210000E:
	CPI  R17,0
	BRNE _0x2100011
	LDI  R30,LOW(0)
	LDD  R17,Y+0
	RJMP _0x2120002
_0x2100011:
_0x2100005:
	LDD  R30,Y+2
	LDD  R17,Y+0
	RJMP _0x2120002
; .FEND
_glcd_readmem:
; .FSTART _glcd_readmem
	RCALL SUBOPT_0x0
	LDD  R30,Y+2
	CPI  R30,LOW(0x1)
	BRNE _0x2100015
	LD   R30,Y
	LDD  R31,Y+1
	LPM  R30,Z
	RJMP _0x2120002
_0x2100015:
	CPI  R30,LOW(0x2)
	BRNE _0x2100016
	RCALL SUBOPT_0x3D
	RCALL __EEPROMRDB
	RJMP _0x2120002
_0x2100016:
	CPI  R30,LOW(0x3)
	BRNE _0x2100018
	RCALL SUBOPT_0x3D
	__CALL1MN _glcd_state,25
	RJMP _0x2120002
_0x2100018:
	RCALL SUBOPT_0x3D
	LD   R30,X
_0x2120002:
	ADIW R28,3
	RET
; .FEND
_glcd_writemem:
; .FSTART _glcd_writemem
	ST   -Y,R26
	LDD  R30,Y+3
	CPI  R30,0
	BRNE _0x210001C
	LD   R30,Y
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	ST   X,R30
	RJMP _0x210001B
_0x210001C:
	CPI  R30,LOW(0x2)
	BRNE _0x210001D
	LD   R30,Y
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	RCALL __EEPROMWRB
	RJMP _0x210001B
_0x210001D:
	CPI  R30,LOW(0x3)
	BRNE _0x210001B
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	RCALL SUBOPT_0x10
	LDD  R26,Y+2
	__CALL1MN _glcd_state,27
_0x210001B:
_0x2120001:
	ADIW R28,4
	RET
; .FEND

	.DSEG
_glcd_state:
	.BYTE 0x1D
_buff:
	.BYTE 0x14
_station_receive:
	.BYTE 0xC
_tay_cam_receive:
	.BYTE 0x8
_data_receive:
	.BYTE 0x12
_data_send:
	.BYTE 0xC
_change:
	.BYTE 0x2
_dem:
	.BYTE 0x2
_distance:
	.BYTE 0x4
__seed_G100:
	.BYTE 0x4
_gfx_addr_G102:
	.BYTE 0x2
_gfx_buffer_G102:
	.BYTE 0x1F8

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x0:
	ST   -Y,R27
	ST   -Y,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1:
	__DELAY_USB 160
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	LDI  R27,0
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x3:
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x4:
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0x5:
	__DELAY_USB 27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 15 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x6:
	LDI  R30,LOW(0)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	LDI  R30,LOW(7)
	ST   -Y,R30
	LDI  R26,LOW(126)
	RJMP _RF_Write_TX

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x8:
	ST   -Y,R26
	ST   -Y,R17
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x9:
	LD   R26,Y
	RJMP _SPI_RW_TX

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xA:
	SBI  0x12,4
	RJMP SUBOPT_0x5

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0xB:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC:
	LDI  R30,LOW(48)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD:
	RCALL _glcd_line
	RJMP SUBOPT_0x6

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xE:
	LDI  R30,LOW(84)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xF:
	RCALL _glcd_outtext
	LDI  R30,LOW(4)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 20 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x10:
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x11:
	LDI  R30,LOW(_buff)
	LDI  R31,HIGH(_buff)
	RJMP SUBOPT_0x10

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x12:
	LDI  R31,0
	CLR  R22
	CLR  R23
	RCALL __PUTPARD1
	LDI  R24,4
	RCALL _sprintf
	ADIW R28,8
	LDI  R30,LOW(50)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x13:
	RCALL _glcd_moveto
	LDI  R26,LOW(_buff)
	LDI  R27,HIGH(_buff)
	RJMP _glcd_outtext

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x14:
	LDS  R30,_distance
	LDS  R31,_distance+1
	LDS  R22,_distance+2
	LDS  R23,_distance+3
	RCALL __CFD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x15:
	ST   X+,R30
	ST   X,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x16:
	RCALL _read_adc
	MOVW R26,R30
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	RCALL __DIVW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x17:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x18:
	ADIW R26,4
	RCALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x19:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x1A:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1B:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x1C:
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x1D:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1E:
	RCALL SUBOPT_0x1B
	RJMP SUBOPT_0x1C

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1F:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	RJMP SUBOPT_0x18

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x20:
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x21:
	STD  Y+6,R30
	STD  Y+6+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x22:
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x23:
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x24:
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x25:
	MOVW R26,R28
	ADIW R26,12
	RCALL __ADDW2R15
	RCALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x26:
	LSR  R30
	LSR  R30
	LSR  R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x27:
	LDI  R31,0
	RJMP SUBOPT_0x3

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x28:
	MOV  R26,R30
	RJMP _pcd8544_wrcmd

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x29:
	SUBI R30,LOW(-_gfx_buffer_G102)
	SBCI R31,HIGH(-_gfx_buffer_G102)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x2A:
	LDI  R26,LOW(_gfx_addr_G102)
	LDI  R27,HIGH(_gfx_addr_G102)
	RJMP SUBOPT_0xB

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2B:
	SBIW R30,1
	RJMP SUBOPT_0x29

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2C:
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2D:
	__PUTW1MN _glcd_state,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2E:
	__PUTW1MN _glcd_state,25
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x2F:
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x30:
	LDI  R31,0
	RCALL __MULW12U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x31:
	LDD  R30,Y+12
	ST   -Y,R30
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ADIW R30,1
	STD  Y+7,R30
	STD  Y+7+1,R31
	SBIW R30,1
	RCALL SUBOPT_0x10
	LDI  R26,LOW(0)
	RJMP _glcd_writemem

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x32:
	ST   -Y,R16
	LDD  R26,Y+16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x33:
	SUBI R17,-1
	LDD  R30,Y+14
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x34:
	LDD  R30,Y+12
	ST   -Y,R30
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ADIW R30,1
	STD  Y+7,R30
	STD  Y+7+1,R31
	SBIW R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x35:
	CLR  R22
	CLR  R23
	MOVW R26,R30
	MOVW R24,R22
	RJMP _glcd_readmem

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x36:
	ST   -Y,R21
	LDD  R26,Y+10
	RJMP _glcd_mappixcolor1bit

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x37:
	ST   -Y,R16
	INC  R16
	LDD  R30,Y+16
	ST   -Y,R30
	ST   -Y,R21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x38:
	MOV  R21,R30
	LDD  R30,Y+12
	ST   -Y,R30
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	CLR  R24
	CLR  R25
	RCALL _glcd_readmem
	MOV  R1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x39:
	COM  R30
	AND  R30,R1
	OR   R21,R30
	RJMP SUBOPT_0x34

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x3A:
	ST   -Y,R16
	INC  R16
	LDD  R30,Y+16
	ST   -Y,R30
	LDD  R30,Y+14
	ST   -Y,R30
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	ADIW R30,1
	STD  Y+9,R30
	STD  Y+9+1,R31
	SBIW R30,1
	RJMP SUBOPT_0x35

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3B:
	ST   -Y,R30
	ST   -Y,R20
	LDD  R26,Y+13
	RJMP _pcd8544_wrmasked_G102

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3C:
	RCALL SUBOPT_0x0
	LD   R26,Y
	LDD  R27,Y+1
	RCALL __CPW02
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3D:
	LD   R26,Y
	LDD  R27,Y+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3E:
	RCALL __SAVELOCR6
	__GETW1MN _glcd_state,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x3F:
	MOVW R30,R16
	__ADDWRN 16,17,1
	LPM  R0,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x40:
	__GETW1MN _glcd_state,4
	ADIW R30,1
	LPM  R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x41:
	ST   -Y,R30
	__GETB1MN _glcd_state,3
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x42:
	RCALL SUBOPT_0x19
	RCALL SUBOPT_0x10
	LDI  R26,LOW(9)
	RJMP _glcd_block

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x43:
	LDD  R26,Y+6
	SUBI R26,-LOW(1)
	STD  Y+6,R26
	SUBI R26,LOW(1)
	__GETB1MN _glcd_state,8
	CP   R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x44:
	ST   -Y,R17
	ST   -Y,R19
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x45:
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x46:
	STD  Y+9,R30
	STD  Y+9+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x47:
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	SUB  R30,R26
	SBC  R31,R27
	RJMP SUBOPT_0x46


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R0
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R17
	CLR  R18
	CLR  R25
	MUL  R22,R24
	MOVW R20,R0
	MUL  R24,R31
	MOV  R19,R0
	ADD  R20,R1
	ADC  R21,R25
	MUL  R22,R27
	ADD  R19,R0
	ADC  R20,R1
	ADC  R21,R25
	MUL  R24,R30
	RCALL __MULF126
	MUL  R27,R31
	RCALL __MULF126
	MUL  R22,R26
	RCALL __MULF126
	MUL  R27,R30
	RCALL __MULF127
	MUL  R26,R31
	RCALL __MULF127
	MUL  R26,R30
	ADD  R17,R1
	ADC  R18,R25
	ADC  R19,R25
	ADC  R20,R25
	ADC  R21,R25
	MOV  R30,R19
	MOV  R31,R20
	MOV  R22,R21
	MOV  R21,R18
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	POP  R0
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__MULF127:
	ADD  R17,R0
	ADC  R18,R1
	ADC  R19,R25
	RJMP __MULF128
__MULF126:
	ADD  R18,R0
	ADC  R19,R1
__MULF128:
	ADC  R20,R25
	ADC  R21,R25
	RET

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__LSLB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSLB12R
__LSLB12L:
	LSL  R30
	DEC  R0
	BRNE __LSLB12L
__LSLB12R:
	RET

__LSRB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSRB12R
__LSRB12L:
	LSR  R30
	DEC  R0
	BRNE __LSRB12L
__LSRB12R:
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__PUTPARL:
	CLR  R27
__PUTPAR:
	ADD  R30,R26
	ADC  R31,R27
__PUTPAR0:
	LD   R0,-Z
	ST   -Y,R0
	SBIW R26,1
	BRNE __PUTPAR0
	RET

__EEPROMRDB:
	SBIC EECR,EEWE
	RJMP __EEPROMRDB
	PUSH R31
	IN   R31,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R30,EEDR
	OUT  SREG,R31
	POP  R31
	RET

__EEPROMWRB:
	SBIS EECR,EEWE
	RJMP __EEPROMWRB1
	WDR
	RJMP __EEPROMWRB
__EEPROMWRB1:
	IN   R25,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R24,EEDR
	CP   R30,R24
	BREQ __EEPROMWRB0
	OUT  EEDR,R30
	SBI  EECR,EEMWE
	SBI  EECR,EEWE
__EEPROMWRB0:
	OUT  SREG,R25
	RET

__CPW02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:

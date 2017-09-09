
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega128A
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 1024 byte(s)
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

	#pragma AVRPART ADMIN PART_NAME ATmega128A
	#pragma AVRPART MEMORY PROG_FLASH 131072
	#pragma AVRPART MEMORY EEPROM 4096
	#pragma AVRPART MEMORY INT_SRAM SIZE 4096
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

	#define CALL_SUPPORTED 1

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
	.EQU RAMPZ=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU XMCRA=0x6D
	.EQU XMCRB=0x6C

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

	.EQU __SRAM_START=0x0100
	.EQU __SRAM_END=0x10FF
	.EQU __DSTACK_SIZE=0x0400
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
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
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
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	.DEF _rx_wr_index0=R5
	.DEF _rx_rd_index0=R4
	.DEF _rx_counter0=R7
	.DEF _i=R8
	.DEF _i_msb=R9
	.DEF _time_flow=R10
	.DEF _time_flow_msb=R11
	.DEF _time_s=R12
	.DEF _time_s_msb=R13
	.DEF _tx_wr_index0=R6

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer0_ovf_isr
	JMP  0x00
	JMP  _usart0_rx_isr
	JMP  0x00
	JMP  _usart0_tx_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

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
__glcd_mask:
	.DB  0x0,0x1,0x3,0x7,0xF,0x1F,0x3F,0x7F
	.DB  0xFF
_tbl10_G105:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G105:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0

_0x2A:
	.DB  0x47,0x45,0x54,0x20,0x2F,0x75,0x70,0x64
	.DB  0x61,0x74,0x65,0x3F,0x6B,0x65,0x79,0x3D
	.DB  0x0
_0x0:
	.DB  0x54,0x69,0x6D,0x65,0x64,0x20,0x6F,0x75
	.DB  0x74,0xD,0xA,0x0,0x45,0x52,0x52,0x4F
	.DB  0x52,0x0,0x45,0x72,0x72,0x6F,0x72,0x20
	.DB  0x66,0x6F,0x75,0x6E,0x64,0x2C,0x20,0x61
	.DB  0x74,0x74,0x65,0x6D,0x70,0x74,0x69,0x6E
	.DB  0x67,0x20,0x74,0x6F,0x20,0x63,0x6F,0x6E
	.DB  0x74,0x69,0x6E,0x75,0x65,0x2E,0x2E,0xD
	.DB  0xA,0x0,0x41,0x54,0x2B,0x43,0x49,0x50
	.DB  0x4D,0x55,0x58,0x3D,0x31,0x0,0x4F,0x4B
	.DB  0x0,0x41,0x54,0x2B,0x43,0x49,0x50,0x53
	.DB  0x54,0x41,0x52,0x54,0x3D,0x30,0x2C,0x22
	.DB  0x54,0x43,0x50,0x22,0x2C,0x22,0x61,0x70
	.DB  0x69,0x2E,0x74,0x68,0x69,0x6E,0x67,0x73
	.DB  0x70,0x65,0x61,0x6B,0x2E,0x63,0x6F,0x6D
	.DB  0x22,0x2C,0x38,0x30,0x0,0x26,0x66,0x69
	.DB  0x65,0x6C,0x64,0x31,0x3D,0x0,0x26,0x66
	.DB  0x69,0x65,0x6C,0x64,0x32,0x3D,0x0,0x26
	.DB  0x66,0x69,0x65,0x6C,0x64,0x33,0x3D,0x0
	.DB  0x41,0x54,0x2B,0x43,0x49,0x50,0x53,0x45
	.DB  0x4E,0x44,0x3D,0x30,0x2C,0x0,0x3E,0x20
	.DB  0x0,0x53,0x65,0x6E,0x64,0x69,0x6E,0x67
	.DB  0x0,0x44,0x6F,0x6E,0x65,0x0,0x41,0x54
	.DB  0xD,0xA,0x0,0x41,0x54,0x2B,0x43,0x57
	.DB  0x4D,0x4F,0x44,0x45,0x3D,0x31,0xD,0xA
	.DB  0x0,0x41,0x54,0x2B,0x43,0x57,0x4A,0x41
	.DB  0x50,0x3D,0x22,0x54,0x68,0x61,0x79,0x5F
	.DB  0x54,0x68,0x61,0x6F,0x5F,0x64,0x65,0x6F
	.DB  0x5F,0x67,0x69,0x61,0x69,0x22,0x2C,0x22
	.DB  0x63,0x68,0x69,0x6E,0x68,0x78,0x61,0x63
	.DB  0x22,0xD,0xA,0x0,0x37,0x55,0x30,0x4D
	.DB  0x35,0x55,0x54,0x45,0x4B,0x58,0x45,0x36
	.DB  0x34,0x5A,0x4B,0x39,0x0
_0x2020060:
	.DB  0x1
_0x2020000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x0A
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x0C
	.DW  _0x23
	.DW  _0x0*2

	.DW  0x0C
	.DW  _0x23+12
	.DW  _0x0*2

	.DW  0x06
	.DW  _0x23+24
	.DW  _0x0*2+12

	.DW  0x28
	.DW  _0x23+30
	.DW  _0x0*2+18

	.DW  0x0C
	.DW  _0x2E
	.DW  _0x0*2+58

	.DW  0x03
	.DW  _0x2E+12
	.DW  _0x0*2+9

	.DW  0x03
	.DW  _0x2E+15
	.DW  _0x0*2+70

	.DW  0x2C
	.DW  _0x2E+18
	.DW  _0x0*2+73

	.DW  0x03
	.DW  _0x2E+62
	.DW  _0x0*2+9

	.DW  0x03
	.DW  _0x2E+65
	.DW  _0x0*2+70

	.DW  0x09
	.DW  _0x2E+68
	.DW  _0x0*2+117

	.DW  0x09
	.DW  _0x2E+77
	.DW  _0x0*2+126

	.DW  0x09
	.DW  _0x2E+86
	.DW  _0x0*2+135

	.DW  0x0E
	.DW  _0x2E+95
	.DW  _0x0*2+144

	.DW  0x03
	.DW  _0x2E+109
	.DW  _0x0*2+9

	.DW  0x03
	.DW  _0x2E+112
	.DW  _0x0*2+158

	.DW  0x08
	.DW  _0x2E+115
	.DW  _0x0*2+161

	.DW  0x03
	.DW  _0x2E+123
	.DW  _0x0*2+9

	.DW  0x05
	.DW  _0x2E+126
	.DW  _0x0*2+169

	.DW  0x05
	.DW  _0x2F
	.DW  _0x0*2+174

	.DW  0x03
	.DW  _0x2F+5
	.DW  _0x0*2+70

	.DW  0x0E
	.DW  _0x2F+8
	.DW  _0x0*2+179

	.DW  0x03
	.DW  _0x2F+22
	.DW  _0x0*2+70

	.DW  0x2B
	.DW  _0x2F+25
	.DW  _0x0*2+193

	.DW  0x03
	.DW  _0x2F+68
	.DW  _0x0*2+70

	.DW  0x11
	.DW  _0x2F+71
	.DW  _0x0*2+236

	.DW  0x01
	.DW  __seed_G101
	.DW  _0x2020060*2

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
	OUT  MCUCR,R31
	OUT  MCUCR,R30
	STS  XMCRB,R30

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
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
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

	OUT  RAMPZ,R24

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x500

	.CSEG
;#include <delay.h>
;#include <string.h>
;#include <mega128.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif
;#include <stdlib.h>
;
;// Graphic Display functions
;#include <glcd.h>
;
;// Font used for displaying text
;// on the graphic display
;#include <font5x7.h>
;
;// Declare your global variables here
;
;#define DATA_REGISTER_EMPTY (1<<UDRE0)
;#define RX_COMPLETE (1<<RXC0)
;#define FRAMING_ERROR (1<<FE0)
;#define PARITY_ERROR (1<<UPE0)
;#define DATA_OVERRUN (1<<DOR0)
;
;// USART0 Receiver buffer
;#define RX_BUFFER_SIZE0 64
;char rx_buffer0[RX_BUFFER_SIZE0];
;
;#if RX_BUFFER_SIZE0 <= 256
;unsigned char rx_wr_index0=0,rx_rd_index0=0;
;#else
;unsigned int rx_wr_index0=0,rx_rd_index0=0;
;#endif
;
;#if RX_BUFFER_SIZE0 < 256
;unsigned char rx_counter0=0;
;#else
;unsigned int rx_counter0=0;
;#endif
;
;char buff[260];
;int i = 0, time_flow = 0, time_s = 0;
;
;void del_string(unsigned char *s) {
; 0000 0028 void del_string(unsigned char *s) {

	.CSEG
_del_string:
; .FSTART _del_string
; 0000 0029     while (*s) {
	ST   -Y,R27
	ST   -Y,R26
;	*s -> Y+0
_0x3:
	LD   R26,Y
	LDD  R27,Y+1
	LD   R30,X
	CPI  R30,0
	BREQ _0x5
; 0000 002A         *s = '\0';
	LDI  R30,LOW(0)
	ST   X,R30
; 0000 002B         s++;
	LD   R30,Y
	LDD  R31,Y+1
	ADIW R30,1
	ST   Y,R30
	STD  Y+1,R31
; 0000 002C     }
	RJMP _0x3
_0x5:
; 0000 002D }
	RJMP _0x2120009
; .FEND
;
;// This flag is set on USART0 Receiver buffer overflow
;bit rx_buffer_overflow0;
;
;// USART0 Receiver interrupt service routine
;interrupt [USART0_RXC] void usart0_rx_isr(void) {
; 0000 0033 interrupt [19] void usart0_rx_isr(void) {
_usart0_rx_isr:
; .FSTART _usart0_rx_isr
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0034     char status,data;
; 0000 0035     status=UCSR0A;
	ST   -Y,R17
	ST   -Y,R16
;	status -> R17
;	data -> R16
	IN   R17,11
; 0000 0036     data=UDR0;
	IN   R16,12
; 0000 0037     if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0) {
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0x6
; 0000 0038         rx_buffer0[rx_wr_index0++]=data;
	MOV  R30,R5
	INC  R5
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer0)
	SBCI R31,HIGH(-_rx_buffer0)
	ST   Z,R16
; 0000 0039 #if RX_BUFFER_SIZE0 == 256
; 0000 003A         // special case for receiver buffer size=256
; 0000 003B         if (++rx_counter0 == 0) rx_buffer_overflow0=1;
; 0000 003C #else
; 0000 003D         if (rx_wr_index0 == RX_BUFFER_SIZE0) rx_wr_index0=0;
	LDI  R30,LOW(64)
	CP   R30,R5
	BRNE _0x7
	CLR  R5
; 0000 003E         if (++rx_counter0 == RX_BUFFER_SIZE0) {
_0x7:
	INC  R7
	LDI  R30,LOW(64)
	CP   R30,R7
	BRNE _0x8
; 0000 003F             rx_counter0=0;
	CLR  R7
; 0000 0040             rx_buffer_overflow0=1;
	SET
	BLD  R2,0
; 0000 0041         }
; 0000 0042 #endif
; 0000 0043     }
_0x8:
; 0000 0044     buff[i] = data;
_0x6:
	MOVW R30,R8
	SUBI R30,LOW(-_buff)
	SBCI R31,HIGH(-_buff)
	ST   Z,R16
; 0000 0045     i++;
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
; 0000 0046 }
	LD   R16,Y+
	LD   R17,Y+
	RJMP _0x34
; .FEND
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Get a character from the USART0 Receiver buffer
;#define _ALTERNATE_GETCHAR_
;#pragma used+
;char getchar(void) {
; 0000 004C char getchar(void) {
_getchar:
; .FSTART _getchar
; 0000 004D     char data;
; 0000 004E     while (rx_counter0==0);
	ST   -Y,R17
;	data -> R17
_0x9:
	TST  R7
	BREQ _0x9
; 0000 004F     data=rx_buffer0[rx_rd_index0++];
	MOV  R30,R4
	INC  R4
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer0)
	SBCI R31,HIGH(-_rx_buffer0)
	LD   R17,Z
; 0000 0050 #if RX_BUFFER_SIZE0 != 256
; 0000 0051     if (rx_rd_index0 == RX_BUFFER_SIZE0) rx_rd_index0=0;
	LDI  R30,LOW(64)
	CP   R30,R4
	BRNE _0xC
	CLR  R4
; 0000 0052 #endif
; 0000 0053 #asm("cli")
_0xC:
	cli
; 0000 0054     --rx_counter0;
	DEC  R7
; 0000 0055 #asm("sei")
	sei
; 0000 0056     return data;
	MOV  R30,R17
	LD   R17,Y+
	RET
; 0000 0057 }
; .FEND
;#pragma used-
;#endif
;
;// USART0 Transmitter buffer
;#define TX_BUFFER_SIZE0 64
;char tx_buffer0[TX_BUFFER_SIZE0];
;
;#if TX_BUFFER_SIZE0 <= 256
;unsigned char tx_wr_index0=0,tx_rd_index0=0;
;#else
;unsigned int tx_wr_index0=0,tx_rd_index0=0;
;#endif
;
;#if TX_BUFFER_SIZE0 < 256
;unsigned char tx_counter0=0;
;#else
;unsigned int tx_counter0=0;
;#endif
;
;// USART0 Transmitter interrupt service routine
;interrupt [USART0_TXC] void usart0_tx_isr(void) {
; 0000 006C interrupt [21] void usart0_tx_isr(void) {
_usart0_tx_isr:
; .FSTART _usart0_tx_isr
	ST   -Y,R26
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 006D     if (tx_counter0) {
	LDS  R30,_tx_counter0
	CPI  R30,0
	BREQ _0xD
; 0000 006E         --tx_counter0;
	SUBI R30,LOW(1)
	STS  _tx_counter0,R30
; 0000 006F         UDR0=tx_buffer0[tx_rd_index0++];
	LDS  R30,_tx_rd_index0
	SUBI R30,-LOW(1)
	STS  _tx_rd_index0,R30
	SUBI R30,LOW(1)
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer0)
	SBCI R31,HIGH(-_tx_buffer0)
	LD   R30,Z
	OUT  0xC,R30
; 0000 0070 #if TX_BUFFER_SIZE0 != 256
; 0000 0071         if (tx_rd_index0 == TX_BUFFER_SIZE0) tx_rd_index0=0;
	LDS  R26,_tx_rd_index0
	CPI  R26,LOW(0x40)
	BRNE _0xE
	LDI  R30,LOW(0)
	STS  _tx_rd_index0,R30
; 0000 0072 #endif
; 0000 0073     }
_0xE:
; 0000 0074 }
_0xD:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R26,Y+
	RETI
; .FEND
;
;interrupt [TIM0_OVF] void timer0_ovf_isr(void) {
; 0000 0076 interrupt [17] void timer0_ovf_isr(void) {
_timer0_ovf_isr:
; .FSTART _timer0_ovf_isr
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0077 	//0.02 ms => 50k = 1s.
; 0000 0078 	TCNT0=0x60;
	LDI  R30,LOW(96)
	OUT  0x32,R30
; 0000 0079 	// Place your code here
; 0000 007A     time_flow++;
	MOVW R30,R10
	ADIW R30,1
	MOVW R10,R30
; 0000 007B 
; 0000 007C     if (time_flow == 50000) {
	LDI  R30,LOW(50000)
	LDI  R31,HIGH(50000)
	CP   R30,R10
	CPC  R31,R11
	BRNE _0xF
; 0000 007D         time_s++;
	MOVW R30,R12
	ADIW R30,1
	MOVW R12,R30
; 0000 007E         time_flow = 0;
	CLR  R10
	CLR  R11
; 0000 007F     }
; 0000 0080 }
_0xF:
_0x34:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
; .FEND
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Write a character to the USART0 Transmitter buffer
;#define _ALTERNATE_PUTCHAR_
;#pragma used+
;void putchar(char c) {
; 0000 0086 void putchar(char c) {
_putchar:
; .FSTART _putchar
; 0000 0087     while (tx_counter0 == TX_BUFFER_SIZE0);
	ST   -Y,R26
;	c -> Y+0
_0x10:
	LDS  R26,_tx_counter0
	CPI  R26,LOW(0x40)
	BREQ _0x10
; 0000 0088 #asm("cli")
	cli
; 0000 0089     if (tx_counter0 || ((UCSR0A & DATA_REGISTER_EMPTY)==0)) {
	LDS  R30,_tx_counter0
	CPI  R30,0
	BRNE _0x14
	SBIC 0xB,5
	RJMP _0x13
_0x14:
; 0000 008A         tx_buffer0[tx_wr_index0++]=c;
	MOV  R30,R6
	INC  R6
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer0)
	SBCI R31,HIGH(-_tx_buffer0)
	LD   R26,Y
	STD  Z+0,R26
; 0000 008B #if TX_BUFFER_SIZE0 != 256
; 0000 008C         if (tx_wr_index0 == TX_BUFFER_SIZE0) tx_wr_index0=0;
	LDI  R30,LOW(64)
	CP   R30,R6
	BRNE _0x16
	CLR  R6
; 0000 008D #endif
; 0000 008E         ++tx_counter0;
_0x16:
	LDS  R30,_tx_counter0
	SUBI R30,-LOW(1)
	STS  _tx_counter0,R30
; 0000 008F     } else
	RJMP _0x17
_0x13:
; 0000 0090         UDR0=c;
	LD   R30,Y
	OUT  0xC,R30
; 0000 0091 #asm("sei")
_0x17:
	sei
; 0000 0092 }
	JMP  _0x2120008
; .FEND
;#pragma used-
;#endif
;
;// Standard Input/Output functions
;#include <stdio.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif
;
;void put_string (unsigned char *s) {
; 0000 0099 void put_string (unsigned char *s) {
_put_string:
; .FSTART _put_string
; 0000 009A     while(*s) {
	ST   -Y,R27
	ST   -Y,R26
;	*s -> Y+0
_0x18:
	LD   R26,Y
	LDD  R27,Y+1
	LD   R30,X
	CPI  R30,0
	BREQ _0x1A
; 0000 009B         putchar(*s);
	LD   R26,X
	RCALL _putchar
; 0000 009C 		delay_ms(50);
	LDI  R26,LOW(50)
	LDI  R27,0
	CALL _delay_ms
; 0000 009D         s++;
	LD   R30,Y
	LDD  R31,Y+1
	ADIW R30,1
	ST   Y,R30
	STD  Y+1,R31
; 0000 009E     }
	RJMP _0x18
_0x1A:
; 0000 009F }
_0x2120009:
	ADIW R28,2
	RET
; .FEND
;
;void refresh(int time_ms) {
; 0000 00A1 void refresh(int time_ms) {
_refresh:
; .FSTART _refresh
; 0000 00A2     int j;
; 0000 00A3 
; 0000 00A4 	delay_ms(time_ms);
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	time_ms -> Y+2
;	j -> R16,R17
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL SUBOPT_0x0
; 0000 00A5 
; 0000 00A6     glcd_clear();
; 0000 00A7     glcd_moveto(0,0);
; 0000 00A8 
; 0000 00A9     glcd_outtext(buff);
	LDI  R26,LOW(_buff)
	LDI  R27,HIGH(_buff)
	CALL _glcd_outtext
; 0000 00AA 
; 0000 00AB     del_string(buff);
	LDI  R26,LOW(_buff)
	LDI  R27,HIGH(_buff)
	RCALL _del_string
; 0000 00AC 
; 0000 00AD     i = 0;
	CLR  R8
	CLR  R9
; 0000 00AE 
; 0000 00AF 
; 0000 00B0 
; 0000 00B1 }
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,4
	RET
; .FEND
;
;void wait_until(unsigned char *keyword, int time_out_s) {
; 0000 00B3 void wait_until(unsigned char *keyword, int time_out_s) {
_wait_until:
; .FSTART _wait_until
; 0000 00B4 	/* 	deu biet cai temp2 de lam gi nhung khong co thi no khong chay trong 1 so truong hop @@
; 0000 00B5 		Vi du nhap vao "Hell" thi no se tach thua ra them 2 char. Co the do vi tri o nho. Cha biet @@*/
; 0000 00B6 	char temp[20], temp2[20];
; 0000 00B7 	int i = 0, time_start, time_temp;
; 0000 00B8 
; 0000 00B9 	del_string(temp);
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,40
	CALL __SAVELOCR6
;	*keyword -> Y+48
;	time_out_s -> Y+46
;	temp -> Y+26
;	temp2 -> Y+6
;	i -> R16,R17
;	time_start -> R18,R19
;	time_temp -> R20,R21
	__GETWRN 16,17,0
	MOVW R26,R28
	ADIW R26,26
	RCALL _del_string
; 0000 00BA 
; 0000 00BB 	while (*keyword) {
_0x1B:
	LDD  R26,Y+48
	LDD  R27,Y+48+1
	LD   R30,X
	CPI  R30,0
	BREQ _0x1D
; 0000 00BC 		temp[i] = *keyword;
	MOVW R30,R16
	MOVW R26,R28
	ADIW R26,26
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	LDD  R26,Y+48
	LDD  R27,Y+48+1
	LD   R30,X
	MOVW R26,R0
	ST   X,R30
; 0000 00BD 		temp2[i] = temp[i];
	MOVW R30,R16
	MOVW R26,R28
	ADIW R26,6
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	MOVW R26,R28
	ADIW R26,26
	ADD  R26,R16
	ADC  R27,R17
	LD   R30,X
	MOVW R26,R0
	ST   X,R30
; 0000 00BE 		keyword++;
	LDD  R30,Y+48
	LDD  R31,Y+48+1
	ADIW R30,1
	STD  Y+48,R30
	STD  Y+48+1,R31
; 0000 00BF 		i++;
	__ADDWRN 16,17,1
; 0000 00C0 	}
	RJMP _0x1B
_0x1D:
; 0000 00C1 
; 0000 00C2 	time_start = time_s;
	MOVW R18,R12
; 0000 00C3 
; 0000 00C4 	while (1) {
_0x1E:
; 0000 00C5 		if (time_s < time_start) {
	__CPWRR 12,13,18,19
	BRGE _0x21
; 0000 00C6 			time_temp = time_s + 60;
	MOVW R30,R12
	ADIW R30,60
	MOVW R20,R30
; 0000 00C7 			if (time_temp - time_start > time_out_s) {
	MOVW R26,R20
	CALL SUBOPT_0x1
	BRGE _0x22
; 0000 00C8 				glcd_outtext("Timed out\r\n");
	__POINTW2MN _0x23,0
	CALL _glcd_outtext
; 0000 00C9 				break;
	RJMP _0x20
; 0000 00CA 			}
; 0000 00CB 		} else {
_0x22:
	RJMP _0x24
_0x21:
; 0000 00CC 			if (time_s - time_start > time_out_s) {
	MOVW R26,R12
	CALL SUBOPT_0x1
	BRGE _0x25
; 0000 00CD 				glcd_outtext("Timed out\r\n");
	__POINTW2MN _0x23,12
	CALL _glcd_outtext
; 0000 00CE 				break;
	RJMP _0x20
; 0000 00CF 			}
; 0000 00D0 		}
_0x25:
_0x24:
; 0000 00D1 
; 0000 00D2 		if ((strstr(buff, temp)) || (strstr(buff, temp2))) {
	CALL SUBOPT_0x2
	MOVW R26,R28
	ADIW R26,28
	CALL _strstr
	SBIW R30,0
	BRNE _0x27
	CALL SUBOPT_0x2
	MOVW R26,R28
	ADIW R26,8
	CALL _strstr
	SBIW R30,0
	BREQ _0x26
_0x27:
; 0000 00D3 			break;
	RJMP _0x20
; 0000 00D4 		}
; 0000 00D5 		if (strstr(buff, "ERROR")) {
_0x26:
	CALL SUBOPT_0x2
	__POINTW2MN _0x23,24
	CALL _strstr
	SBIW R30,0
	BREQ _0x29
; 0000 00D6 			glcd_outtext("Error found, attempting to continue..\r\n");
	__POINTW2MN _0x23,30
	CALL _glcd_outtext
; 0000 00D7 			delay_ms(3000);
	LDI  R26,LOW(3000)
	LDI  R27,HIGH(3000)
	CALL SUBOPT_0x0
; 0000 00D8 			glcd_clear();
; 0000 00D9 			glcd_moveto(0,0);
; 0000 00DA 			break;
	RJMP _0x20
; 0000 00DB 			//nen lam them ve cai nay nua
; 0000 00DC 		}
; 0000 00DD 	}
_0x29:
	RJMP _0x1E
_0x20:
; 0000 00DE }
	CALL __LOADLOCR6
	ADIW R28,50
	RET
; .FEND

	.DSEG
_0x23:
	.BYTE 0x46
;
;void read_and_send(unsigned char *s){
; 0000 00E0 void read_and_send(unsigned char *s){

	.CSEG
_read_and_send:
; .FSTART _read_and_send
; 0000 00E1     // Thay nhung ham respones_read bang ham wait_until
; 0000 00E2     char api_key[20], cmd[] = "GET /update?key=", temp[20], temp2[20];
; 0000 00E3     int length = 0, i = 0;
; 0000 00E4 
; 0000 00E5 	while (*s) {
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,63
	SBIW R28,14
	LDI  R24,17
	LDI  R26,LOW(40)
	LDI  R27,HIGH(40)
	LDI  R30,LOW(_0x2A*2)
	LDI  R31,HIGH(_0x2A*2)
	CALL __INITLOCB
	CALL __SAVELOCR4
;	*s -> Y+81
;	api_key -> Y+61
;	cmd -> Y+44
;	temp -> Y+24
;	temp2 -> Y+4
;	length -> R16,R17
;	i -> R18,R19
	__GETWRN 16,17,0
	__GETWRN 18,19,0
_0x2B:
	CALL SUBOPT_0x3
	CPI  R30,0
	BREQ _0x2D
; 0000 00E6         temp2[i] = *s;
	MOVW R30,R18
	MOVW R26,R28
	ADIW R26,4
	ADD  R30,R26
	ADC  R31,R27
	MOVW R22,R30
	CALL SUBOPT_0x3
	MOVW R26,R22
	ST   X,R30
; 0000 00E7 		api_key[i] = temp2[i];
	MOVW R30,R18
	MOVW R26,R28
	ADIW R26,61
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	MOVW R26,R28
	ADIW R26,4
	ADD  R26,R18
	ADC  R27,R19
	LD   R30,X
	MOVW R26,R0
	ST   X,R30
; 0000 00E8         s++;
	MOVW R26,R28
	SUBI R26,LOW(-(81))
	SBCI R27,HIGH(-(81))
	CALL SUBOPT_0x4
; 0000 00E9         i++;
	__ADDWRN 18,19,1
; 0000 00EA     }
	RJMP _0x2B
_0x2D:
; 0000 00EB 
; 0000 00EC 
; 0000 00ED     // glcd_clear();
; 0000 00EE 	// glcd_moveto(0,0);
; 0000 00EF 	// glcd_outtext("Wifi connected");
; 0000 00F0 
; 0000 00F1 	put_string("AT+CIPMUX=1");
	__POINTW2MN _0x2E,0
	CALL SUBOPT_0x5
; 0000 00F2 	delay_ms(300);
; 0000 00F3 	put_string("\r\n");
	__POINTW2MN _0x2E,12
	RCALL _put_string
; 0000 00F4     wait_until("OK", 2);
	__POINTW1MN _0x2E,15
	CALL SUBOPT_0x6
; 0000 00F5     refresh(0);
; 0000 00F6 
; 0000 00F7     put_string("AT+CIPSTART=0,\"TCP\",\"api.thingspeak.com\",80");
	__POINTW2MN _0x2E,18
	CALL SUBOPT_0x5
; 0000 00F8 	delay_ms(300);
; 0000 00F9 	put_string("\r\n");
	__POINTW2MN _0x2E,62
	RCALL _put_string
; 0000 00FA     wait_until("OK", 20);
	__POINTW1MN _0x2E,65
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(20)
	LDI  R27,0
	RCALL _wait_until
; 0000 00FB 	refresh(2000);
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	RCALL _refresh
; 0000 00FC 
; 0000 00FD 	glcd_clear();
	CALL SUBOPT_0x7
; 0000 00FE 	glcd_moveto(0,0);
; 0000 00FF 	// glcd_outtext("Server connected");
; 0000 0100 
; 0000 0101     strcat(cmd, temp2);
	CALL SUBOPT_0x8
	MOVW R26,R28
	ADIW R26,6
	CALL SUBOPT_0x9
; 0000 0102     strcat(cmd, "&field1=");
	__POINTW2MN _0x2E,68
	CALL SUBOPT_0xA
; 0000 0103 
; 0000 0104     // itoa(station_receive.temp, cmd);
; 0000 0105 
; 0000 0106     itoa(200, temp);
; 0000 0107 	strcat(cmd, temp);
	MOVW R26,R28
	ADIW R26,26
	CALL SUBOPT_0x9
; 0000 0108 
; 0000 0109     strcat(cmd, "&field2=");
	__POINTW2MN _0x2E,77
	CALL SUBOPT_0xA
; 0000 010A     // itoa(station_receive.humi, cmd);
; 0000 010B     itoa(200, temp);
; 0000 010C 	strcat(cmd, temp);
	MOVW R26,R28
	ADIW R26,26
	CALL SUBOPT_0x9
; 0000 010D 
; 0000 010E     strcat(cmd, "&field3=");
	__POINTW2MN _0x2E,86
	CALL SUBOPT_0xA
; 0000 010F     // itoa(station_receive.water, cmd);
; 0000 0110     itoa(200, temp);
; 0000 0111 	strcat(cmd, temp);
	MOVW R26,R28
	ADIW R26,26
	CALL _strcat
; 0000 0112 
; 0000 0113 
; 0000 0114 	// glcd_outtext(cmd);
; 0000 0115 
; 0000 0116 	length = strlen(cmd);
	MOVW R26,R28
	ADIW R26,44
	CALL _strlen
	MOVW R16,R30
; 0000 0117 	length += 2;
	__ADDWRN 16,17,2
; 0000 0118 
; 0000 0119 	itoa(length, temp);
	ST   -Y,R17
	ST   -Y,R16
	MOVW R26,R28
	ADIW R26,26
	CALL _itoa
; 0000 011A 
; 0000 011B 	// for (i = 0; i < 260; i++) {
; 0000 011C 		// buff[i] = '\0';
; 0000 011D 	// }
; 0000 011E 	// i = 0;
; 0000 011F 
; 0000 0120 	del_string(buff);
	LDI  R26,LOW(_buff)
	LDI  R27,HIGH(_buff)
	CALL _del_string
; 0000 0121 
; 0000 0122     put_string("AT+CIPSEND=0,");
	__POINTW2MN _0x2E,95
	RCALL _put_string
; 0000 0123     put_string(temp);
	MOVW R26,R28
	ADIW R26,24
	CALL SUBOPT_0xB
; 0000 0124 	delay_ms(1000);
; 0000 0125     put_string("\r\n");
	__POINTW2MN _0x2E,109
	RCALL _put_string
; 0000 0126 
; 0000 0127     wait_until("> ", 5);
	__POINTW1MN _0x2E,112
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(5)
	LDI  R27,0
	RCALL _wait_until
; 0000 0128 
; 0000 0129 	glcd_clear();
	CALL SUBOPT_0x7
; 0000 012A 	glcd_moveto(0,0);
; 0000 012B 	glcd_outtext("Sending");
	__POINTW2MN _0x2E,115
	CALL _glcd_outtext
; 0000 012C 
; 0000 012D     put_string(cmd);
	MOVW R26,R28
	ADIW R26,44
	RCALL _put_string
; 0000 012E 	put_string("\r\n");
	__POINTW2MN _0x2E,123
	CALL SUBOPT_0xB
; 0000 012F     delay_ms(1000);
; 0000 0130     putchar(0x1A);
	LDI  R26,LOW(26)
	RCALL _putchar
; 0000 0131 
; 0000 0132 	refresh(0);
	LDI  R26,LOW(0)
	LDI  R27,0
	RCALL _refresh
; 0000 0133 
; 0000 0134 	glcd_outtext("Done");
	__POINTW2MN _0x2E,126
	CALL _glcd_outtext
; 0000 0135 
; 0000 0136     /*if(check_ok==1){
; 0000 0137         glcd_moveto(0,0);
; 0000 0138         glcd_outtext("done");
; 0000 0139     }
; 0000 013A 
; 0000 013B     delay_ms(1000); */
; 0000 013C }
	CALL __LOADLOCR4
	ADIW R28,63
	ADIW R28,20
	RET
; .FEND

	.DSEG
_0x2E:
	.BYTE 0x83
;
;void main(void) {
; 0000 013E void main(void) {

	.CSEG
_main:
; .FSTART _main
; 0000 013F 
; 0000 0140     char temp;
; 0000 0141 // Declare your local variables here
; 0000 0142 // Variable used to store graphic display
; 0000 0143 // controller initialization data
; 0000 0144     GLCDINIT_t glcd_init_data;
; 0000 0145 
; 0000 0146 // Input/Output Ports initialization
; 0000 0147 // Port A initialization
; 0000 0148 // Function: Bit7=In Bit6=Out Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0149     DDRA=(0<<DDA7) | (1<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
	SBIW R28,8
;	temp -> R17
;	glcd_init_data -> Y+0
	LDI  R30,LOW(64)
	OUT  0x1A,R30
; 0000 014A // State: Bit7=T Bit6=1 Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 014B     PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 014C 
; 0000 014D // Port B initialization
; 0000 014E // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 014F     DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
	OUT  0x17,R30
; 0000 0150 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0151     PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	OUT  0x18,R30
; 0000 0152 
; 0000 0153 // Port C initialization
; 0000 0154 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0155     DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
	OUT  0x14,R30
; 0000 0156 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0157     PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	OUT  0x15,R30
; 0000 0158 
; 0000 0159 // Port D initialization
; 0000 015A // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 015B     DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	OUT  0x11,R30
; 0000 015C // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 015D     PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	OUT  0x12,R30
; 0000 015E 
; 0000 015F // Port E initialization
; 0000 0160 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0161     DDRE=(0<<DDE7) | (0<<DDE6) | (0<<DDE5) | (0<<DDE4) | (0<<DDE3) | (0<<DDE2) | (0<<DDE1) | (0<<DDE0);
	OUT  0x2,R30
; 0000 0162 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0163     PORTE=(0<<PORTE7) | (0<<PORTE6) | (0<<PORTE5) | (0<<PORTE4) | (0<<PORTE3) | (0<<PORTE2) | (0<<PORTE1) | (0<<PORTE0);
	OUT  0x3,R30
; 0000 0164 
; 0000 0165 // Port F initialization
; 0000 0166 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0167     DDRF=(0<<DDF7) | (0<<DDF6) | (0<<DDF5) | (0<<DDF4) | (0<<DDF3) | (0<<DDF2) | (0<<DDF1) | (0<<DDF0);
	STS  97,R30
; 0000 0168 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0169     PORTF=(0<<PORTF7) | (0<<PORTF6) | (0<<PORTF5) | (0<<PORTF4) | (0<<PORTF3) | (0<<PORTF2) | (0<<PORTF1) | (0<<PORTF0);
	STS  98,R30
; 0000 016A 
; 0000 016B // Port G initialization
; 0000 016C // Function: Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 016D     DDRG=(0<<DDG4) | (0<<DDG3) | (0<<DDG2) | (0<<DDG1) | (0<<DDG0);
	STS  100,R30
; 0000 016E // State: Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 016F     PORTG=(0<<PORTG4) | (0<<PORTG3) | (0<<PORTG2) | (0<<PORTG1) | (0<<PORTG0);
	STS  101,R30
; 0000 0170 
; 0000 0171 // Timer/Counter 0 initialization
; 0000 0172 // Clock source: System Clock
; 0000 0173 // Clock value: 8000.000 kHz
; 0000 0174 // Mode: Normal top=0xFF
; 0000 0175 // OC0 output: Disconnected
; 0000 0176 // Timer Period: 0.02 ms
; 0000 0177 
; 0000 0178         ASSR=0<<AS0;
	OUT  0x30,R30
; 0000 0179         TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (1<<CS00);
	LDI  R30,LOW(1)
	OUT  0x33,R30
; 0000 017A         TCNT0=0x60;
	LDI  R30,LOW(96)
	OUT  0x32,R30
; 0000 017B         OCR0=0x00;
	LDI  R30,LOW(0)
	OUT  0x31,R30
; 0000 017C 
; 0000 017D // Timer/Counter 1 initialization
; 0000 017E // Clock source: System Clock
; 0000 017F // Clock value: Timer1 Stopped
; 0000 0180 // Mode: Normal top=0xFFFF
; 0000 0181 // OC1A output: Disconnected
; 0000 0182 // OC1B output: Disconnected
; 0000 0183 // OC1C output: Disconnected
; 0000 0184 // Noise Canceler: Off
; 0000 0185 // Input Capture on Falling Edge
; 0000 0186 // Timer1 Overflow Interrupt: Off
; 0000 0187 // Input Capture Interrupt: Off
; 0000 0188 // Compare A Match Interrupt: Off
; 0000 0189 // Compare B Match Interrupt: Off
; 0000 018A // Compare C Match Interrupt: Off
; 0000 018B     TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<COM1C1) | (0<<COM1C0) | (0<<WGM11) | (0<<WGM10);
	OUT  0x2F,R30
; 0000 018C     TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
	OUT  0x2E,R30
; 0000 018D     TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 018E     TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 018F     ICR1H=0x00;
	OUT  0x27,R30
; 0000 0190     ICR1L=0x00;
	OUT  0x26,R30
; 0000 0191     OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0192     OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0193     OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0194     OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0195     OCR1CH=0x00;
	STS  121,R30
; 0000 0196     OCR1CL=0x00;
	STS  120,R30
; 0000 0197 
; 0000 0198 // Timer/Counter 2 initialization
; 0000 0199 // Clock source: System Clock
; 0000 019A // Clock value: Timer2 Stopped
; 0000 019B // Mode: Normal top=0xFF
; 0000 019C // OC2 output: Disconnected
; 0000 019D     TCCR2=(0<<WGM20) | (0<<COM21) | (0<<COM20) | (0<<WGM21) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	OUT  0x25,R30
; 0000 019E     TCNT2=0x00;
	OUT  0x24,R30
; 0000 019F     OCR2=0x00;
	OUT  0x23,R30
; 0000 01A0 
; 0000 01A1 // Timer/Counter 3 initialization
; 0000 01A2 // Clock source: System Clock
; 0000 01A3 // Clock value: Timer3 Stopped
; 0000 01A4 // Mode: Normal top=0xFFFF
; 0000 01A5 // OC3A output: Disconnected
; 0000 01A6 // OC3B output: Disconnected
; 0000 01A7 // OC3C output: Disconnected
; 0000 01A8 // Noise Canceler: Off
; 0000 01A9 // Input Capture on Falling Edge
; 0000 01AA // Timer3 Overflow Interrupt: Off
; 0000 01AB // Input Capture Interrupt: Off
; 0000 01AC // Compare A Match Interrupt: Off
; 0000 01AD // Compare B Match Interrupt: Off
; 0000 01AE // Compare C Match Interrupt: Off
; 0000 01AF     TCCR3A=(0<<COM3A1) | (0<<COM3A0) | (0<<COM3B1) | (0<<COM3B0) | (0<<COM3C1) | (0<<COM3C0) | (0<<WGM31) | (0<<WGM30);
	STS  139,R30
; 0000 01B0     TCCR3B=(0<<ICNC3) | (0<<ICES3) | (0<<WGM33) | (0<<WGM32) | (0<<CS32) | (0<<CS31) | (0<<CS30);
	STS  138,R30
; 0000 01B1     TCNT3H=0x00;
	STS  137,R30
; 0000 01B2     TCNT3L=0x00;
	STS  136,R30
; 0000 01B3     ICR3H=0x00;
	STS  129,R30
; 0000 01B4     ICR3L=0x00;
	STS  128,R30
; 0000 01B5     OCR3AH=0x00;
	STS  135,R30
; 0000 01B6     OCR3AL=0x00;
	STS  134,R30
; 0000 01B7     OCR3BH=0x00;
	STS  133,R30
; 0000 01B8     OCR3BL=0x00;
	STS  132,R30
; 0000 01B9     OCR3CH=0x00;
	STS  131,R30
; 0000 01BA     OCR3CL=0x00;
	STS  130,R30
; 0000 01BB 
; 0000 01BC // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 01BD     TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);
	OUT  0x37,R30
; 0000 01BE     ETIMSK=(0<<TICIE3) | (0<<OCIE3A) | (0<<OCIE3B) | (0<<TOIE3) | (0<<OCIE3C) | (0<<OCIE1C);
	STS  125,R30
; 0000 01BF 
; 0000 01C0 // External Interrupt(s) initialization
; 0000 01C1 // INT0: Off
; 0000 01C2 // INT1: Off
; 0000 01C3 // INT2: Off
; 0000 01C4 // INT3: Off
; 0000 01C5 // INT4: Off
; 0000 01C6 // INT5: Off
; 0000 01C7 // INT6: Off
; 0000 01C8 // INT7: Off
; 0000 01C9     EICRA=(0<<ISC31) | (0<<ISC30) | (0<<ISC21) | (0<<ISC20) | (0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	STS  106,R30
; 0000 01CA     EICRB=(0<<ISC71) | (0<<ISC70) | (0<<ISC61) | (0<<ISC60) | (0<<ISC51) | (0<<ISC50) | (0<<ISC41) | (0<<ISC40);
	OUT  0x3A,R30
; 0000 01CB     EIMSK=(0<<INT7) | (0<<INT6) | (0<<INT5) | (0<<INT4) | (0<<INT3) | (0<<INT2) | (0<<INT1) | (0<<INT0);
	OUT  0x39,R30
; 0000 01CC 
; 0000 01CD // USART0 initialization
; 0000 01CE // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 01CF // USART0 Receiver: On
; 0000 01D0 // USART0 Transmitter: On
; 0000 01D1 // USART0 Mode: Asynchronous
; 0000 01D2 // USART0 Baud Rate: 9600
; 0000 01D3     UCSR0A=(0<<RXC0) | (0<<TXC0) | (0<<UDRE0) | (0<<FE0) | (0<<DOR0) | (0<<UPE0) | (0<<U2X0) | (0<<MPCM0);
	OUT  0xB,R30
; 0000 01D4     UCSR0B=(1<<RXCIE0) | (1<<TXCIE0) | (0<<UDRIE0) | (1<<RXEN0) | (1<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);
	LDI  R30,LOW(216)
	OUT  0xA,R30
; 0000 01D5     UCSR0C=(0<<UMSEL0) | (0<<UPM01) | (0<<UPM00) | (0<<USBS0) | (1<<UCSZ01) | (1<<UCSZ00) | (0<<UCPOL0);
	LDI  R30,LOW(6)
	STS  149,R30
; 0000 01D6     UBRR0H=0x00;
	LDI  R30,LOW(0)
	STS  144,R30
; 0000 01D7     UBRR0L=0x33;
	LDI  R30,LOW(51)
	OUT  0x9,R30
; 0000 01D8 
; 0000 01D9 // USART1 initialization
; 0000 01DA // USART1 disabled
; 0000 01DB     UCSR1B=(0<<RXCIE1) | (0<<TXCIE1) | (0<<UDRIE1) | (0<<RXEN1) | (0<<TXEN1) | (0<<UCSZ12) | (0<<RXB81) | (0<<TXB81);
	LDI  R30,LOW(0)
	STS  154,R30
; 0000 01DC 
; 0000 01DD // Analog Comparator initialization
; 0000 01DE // Analog Comparator: Off
; 0000 01DF // The Analog Comparator's positive input is
; 0000 01E0 // connected to the AIN0 pin
; 0000 01E1 // The Analog Comparator's negative input is
; 0000 01E2 // connected to the AIN1 pin
; 0000 01E3     ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 01E4     SFIOR=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 01E5 
; 0000 01E6 // ADC initialization
; 0000 01E7 // ADC disabled
; 0000 01E8     ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADFR) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
	OUT  0x6,R30
; 0000 01E9 
; 0000 01EA // SPI initialization
; 0000 01EB // SPI disabled
; 0000 01EC     SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0000 01ED 
; 0000 01EE // TWI initialization
; 0000 01EF // TWI disabled
; 0000 01F0     TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	STS  116,R30
; 0000 01F1 
; 0000 01F2 // Graphic Display Controller initialization
; 0000 01F3 // The PCD8544 connections are specified in the
; 0000 01F4 // Project|Configure|C Compiler|Libraries|Graphic Display menu:
; 0000 01F5 // SDIN - PORTC Bit 7
; 0000 01F6 // SCLK - PORTA Bit 7
; 0000 01F7 // D /C - PORTC Bit 6
; 0000 01F8 // /SCE - PORTC Bit 5
; 0000 01F9 // /RES - PORTC Bit 4
; 0000 01FA 
; 0000 01FB // Specify the current font for displaying text
; 0000 01FC     glcd_init_data.font=font5x7;
	LDI  R30,LOW(_font5x7*2)
	LDI  R31,HIGH(_font5x7*2)
	ST   Y,R30
	STD  Y+1,R31
; 0000 01FD // No function is used for reading
; 0000 01FE // image data from external memory
; 0000 01FF     glcd_init_data.readxmem=NULL;
	LDI  R30,LOW(0)
	STD  Y+2,R30
	STD  Y+2+1,R30
; 0000 0200 // No function is used for writing
; 0000 0201 // image data to external memory
; 0000 0202     glcd_init_data.writexmem=NULL;
	STD  Y+4,R30
	STD  Y+4+1,R30
; 0000 0203 // Set the LCD temperature coefficient
; 0000 0204     glcd_init_data.temp_coef=90;
	LDD  R30,Y+6
	ANDI R30,LOW(0xFC)
	ORI  R30,2
	STD  Y+6,R30
; 0000 0205 // Set the LCD bias
; 0000 0206     glcd_init_data.bias=3;
	ANDI R30,LOW(0xE3)
	ORI  R30,LOW(0xC)
	STD  Y+6,R30
; 0000 0207 // Set the LCD contrast control voltage VLCD
; 0000 0208     glcd_init_data.vlcd=55;
	LDD  R30,Y+7
	ANDI R30,LOW(0x80)
	ORI  R30,LOW(0x37)
	STD  Y+7,R30
; 0000 0209 
; 0000 020A     glcd_init(&glcd_init_data);
	MOVW R26,R28
	CALL _glcd_init
; 0000 020B 
; 0000 020C // Global enable interrupts
; 0000 020D #asm("sei")
	sei
; 0000 020E 
; 0000 020F     put_string("AT\r\n");
	__POINTW2MN _0x2F,0
	RCALL _put_string
; 0000 0210     wait_until("OK", 2);
	__POINTW1MN _0x2F,5
	CALL SUBOPT_0x6
; 0000 0211     refresh(0);
; 0000 0212 
; 0000 0213     put_string("AT+CWMODE=1\r\n");
	__POINTW2MN _0x2F,8
	RCALL _put_string
; 0000 0214     wait_until("OK", 2);
	__POINTW1MN _0x2F,22
	CALL SUBOPT_0x6
; 0000 0215     refresh(0);
; 0000 0216 
; 0000 0217     put_string("AT+CWJAP=\"Thay_Thao_deo_giai\",\"chinhxac\"\r\n");
	__POINTW2MN _0x2F,25
	RCALL _put_string
; 0000 0218     wait_until("OK", 10);
	__POINTW1MN _0x2F,68
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(10)
	LDI  R27,0
	RCALL _wait_until
; 0000 0219     refresh(0);
	LDI  R26,LOW(0)
	LDI  R27,0
	RCALL _refresh
; 0000 021A 
; 0000 021B     read_and_send("7U0M5UTEKXE64ZK9");
	__POINTW2MN _0x2F,71
	RCALL _read_and_send
; 0000 021C 
; 0000 021D     while (1) {
_0x30:
; 0000 021E         temp = getchar();
	CALL _getchar
	MOV  R17,R30
; 0000 021F         glcd_putchar(temp);
	MOV  R26,R17
	CALL _glcd_putchar
; 0000 0220     }
	RJMP _0x30
; 0000 0221 }
_0x33:
	RJMP _0x33
; .FEND

	.DSEG
_0x2F:
	.BYTE 0x58

	.CSEG
_memset:
; .FSTART _memset
	ST   -Y,R27
	ST   -Y,R26
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
	ADIW R28,5
	RET
; .FEND
_strcat:
; .FSTART _strcat
	ST   -Y,R27
	ST   -Y,R26
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
    movw r24,r26
strcat0:
    ld   r22,x+
    tst  r22
    brne strcat0
    sbiw r26,1
strcat1:
    ld   r22,z+
    st   x+,r22
    tst  r22
    brne strcat1
    movw r30,r24
    ret
; .FEND
_strlen:
; .FSTART _strlen
	ST   -Y,R27
	ST   -Y,R26
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
_strstr:
; .FSTART _strstr
	ST   -Y,R27
	ST   -Y,R26
    ldd  r26,y+2
    ldd  r27,y+3
    movw r24,r26
strstr0:
    ld   r30,y
    ldd  r31,y+1
strstr1:
    ld   r23,z+
    tst  r23
    brne strstr2
    movw r30,r24
    rjmp strstr3
strstr2:
    ld   r22,x+
    cp   r22,r23
    breq strstr1
    adiw r24,1
    movw r26,r24
    tst  r22
    brne strstr0
    clr  r30
    clr  r31
strstr3:
	JMP  _0x2120001
; .FEND

	.CSEG
_itoa:
; .FSTART _itoa
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    ld   r30,y+
    ld   r31,y+
    adiw r30,0
    brpl __itoa0
    com  r30
    com  r31
    adiw r30,1
    ldi  r22,'-'
    st   x+,r22
__itoa0:
    clt
    ldi  r24,low(10000)
    ldi  r25,high(10000)
    rcall __itoa1
    ldi  r24,low(1000)
    ldi  r25,high(1000)
    rcall __itoa1
    ldi  r24,100
    clr  r25
    rcall __itoa1
    ldi  r24,10
    rcall __itoa1
    mov  r22,r30
    rcall __itoa5
    clr  r22
    st   x,r22
    ret

__itoa1:
    clr	 r22
__itoa2:
    cp   r30,r24
    cpc  r31,r25
    brlo __itoa3
    inc  r22
    sub  r30,r24
    sbc  r31,r25
    brne __itoa2
__itoa3:
    tst  r22
    brne __itoa4
    brts __itoa5
    ret
__itoa4:
    set
__itoa5:
    subi r22,-0x30
    st   x+,r22
    ret
; .FEND

	.DSEG

	.CSEG
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_pcd8544_delay_G102:
; .FSTART _pcd8544_delay_G102
	RET
; .FEND
_pcd8544_wrbus_G102:
; .FSTART _pcd8544_wrbus_G102
	ST   -Y,R26
	ST   -Y,R17
	CBI  0x15,5
	LDI  R17,LOW(8)
_0x2040004:
	RCALL _pcd8544_delay_G102
	LDD  R30,Y+1
	ANDI R30,LOW(0x80)
	BREQ _0x2040006
	SBI  0x15,7
	RJMP _0x2040007
_0x2040006:
	CBI  0x15,7
_0x2040007:
	LDD  R30,Y+1
	LSL  R30
	STD  Y+1,R30
	RCALL _pcd8544_delay_G102
	SBI  0x1B,7
	RCALL _pcd8544_delay_G102
	CBI  0x1B,7
	SUBI R17,LOW(1)
	BRNE _0x2040004
	SBI  0x15,5
	LDD  R17,Y+0
	JMP  _0x2120003
; .FEND
_pcd8544_wrcmd:
; .FSTART _pcd8544_wrcmd
	ST   -Y,R26
	CBI  0x15,6
	LD   R26,Y
	RCALL _pcd8544_wrbus_G102
	RJMP _0x2120008
; .FEND
_pcd8544_wrdata_G102:
; .FSTART _pcd8544_wrdata_G102
	ST   -Y,R26
	SBI  0x15,6
	LD   R26,Y
	RCALL _pcd8544_wrbus_G102
	RJMP _0x2120008
; .FEND
_pcd8544_setaddr_G102:
; .FSTART _pcd8544_setaddr_G102
	ST   -Y,R26
	ST   -Y,R17
	LDD  R30,Y+1
	LSR  R30
	LSR  R30
	LSR  R30
	MOV  R17,R30
	LDI  R30,LOW(84)
	MUL  R30,R17
	MOVW R30,R0
	MOVW R26,R30
	LDD  R30,Y+2
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	STS  _gfx_addr_G102,R30
	STS  _gfx_addr_G102+1,R31
	MOV  R30,R17
	LDD  R17,Y+0
	JMP  _0x2120002
; .FEND
_pcd8544_gotoxy:
; .FSTART _pcd8544_gotoxy
	ST   -Y,R26
	LDD  R30,Y+1
	ORI  R30,0x80
	MOV  R26,R30
	RCALL _pcd8544_wrcmd
	LDD  R30,Y+1
	ST   -Y,R30
	LDD  R26,Y+1
	RCALL _pcd8544_setaddr_G102
	ORI  R30,0x40
	MOV  R26,R30
	RCALL _pcd8544_wrcmd
	JMP  _0x2120003
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
	SUBI R30,LOW(-_gfx_buffer_G102)
	SBCI R31,HIGH(-_gfx_buffer_G102)
	LD   R30,Z
	JMP  _0x2120003
; .FEND
_pcd8544_wrbyte:
; .FSTART _pcd8544_wrbyte
	ST   -Y,R26
	CALL SUBOPT_0xC
	SBIW R30,1
	SUBI R30,LOW(-_gfx_buffer_G102)
	SBCI R31,HIGH(-_gfx_buffer_G102)
	LD   R26,Y
	STD  Z+0,R26
	RCALL _pcd8544_wrdata_G102
	RJMP _0x2120008
; .FEND
_glcd_init:
; .FSTART _glcd_init
	ST   -Y,R27
	ST   -Y,R26
	CALL __SAVELOCR4
	SBI  0x14,5
	SBI  0x15,5
	SBI  0x1A,7
	CBI  0x1B,7
	SBI  0x14,7
	SBI  0x14,6
	SBI  0x14,4
	CBI  0x15,4
	LDI  R26,LOW(10)
	LDI  R27,0
	CALL _delay_ms
	SBI  0x15,4
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	SBIW R30,0
	BREQ _0x2040008
	LDD  R30,Z+6
	ANDI R30,LOW(0x3)
	MOV  R17,R30
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	LDD  R30,Z+6
	LSR  R30
	LSR  R30
	ANDI R30,LOW(0x7)
	MOV  R16,R30
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	LDD  R30,Z+7
	ANDI R30,0x7F
	MOV  R19,R30
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CALL __GETW1P
	__PUTW1MN _glcd_state,4
	ADIW R26,2
	CALL __GETW1P
	__PUTW1MN _glcd_state,25
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ADIW R26,4
	CALL __GETW1P
	RJMP _0x20400A0
_0x2040008:
	LDI  R17,LOW(0)
	LDI  R16,LOW(3)
	LDI  R19,LOW(50)
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	__PUTW1MN _glcd_state,4
	__PUTW1MN _glcd_state,25
_0x20400A0:
	__PUTW1MN _glcd_state,27
	LDI  R26,LOW(33)
	RCALL _pcd8544_wrcmd
	MOV  R30,R17
	ORI  R30,4
	MOV  R26,R30
	RCALL _pcd8544_wrcmd
	MOV  R30,R16
	ORI  R30,0x10
	MOV  R26,R30
	RCALL _pcd8544_wrcmd
	MOV  R30,R19
	ORI  R30,0x80
	MOV  R26,R30
	RCALL _pcd8544_wrcmd
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
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(255)
	ST   -Y,R30
	LDI  R26,LOW(8)
	LDI  R27,0
	CALL _memset
	RCALL _glcd_clear
	LDI  R30,LOW(1)
	CALL __LOADLOCR4
	RJMP _0x2120007
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
	MOV  R26,R30
	RCALL _pcd8544_wrcmd
_0x2120008:
	ADIW R28,1
	RET
; .FEND
_glcd_clear:
; .FSTART _glcd_clear
	CALL __SAVELOCR4
	LDI  R19,0
	__GETB1MN _glcd_state,1
	CPI  R30,0
	BREQ _0x204000D
	LDI  R19,LOW(255)
_0x204000D:
	LDI  R30,LOW(0)
	ST   -Y,R30
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
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _glcd_moveto
	CALL __LOADLOCR4
	JMP  _0x2120001
; .FEND
_pcd8544_wrmasked_G102:
; .FSTART _pcd8544_wrmasked_G102
	ST   -Y,R26
	ST   -Y,R17
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
	CALL _glcd_mappixcolor1bit
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
_0x2120007:
	ADIW R28,6
	RET
; .FEND
_glcd_block:
; .FSTART _glcd_block
	ST   -Y,R26
	SBIW R28,3
	CALL __SAVELOCR6
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
	RJMP _0x2120006
_0x204002B:
	LDD  R30,Y+14
	STD  Y+8,R30
	LDD  R26,Y+16
	CLR  R27
	LDD  R30,Y+14
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
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
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
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
	RJMP _0x2120006
_0x2040034:
	CPI  R30,LOW(0x3)
	BRNE _0x2040037
	__GETW1MN _glcd_state,27
	SBIW R30,0
	BRNE _0x2040036
	RJMP _0x2120006
_0x2040036:
_0x2040037:
	LDD  R16,Y+8
	LDD  R30,Y+13
	LSR  R30
	LSR  R30
	LSR  R30
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
	LDI  R31,0
	CALL __MULW12U
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CALL SUBOPT_0xD
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
	CALL SUBOPT_0xE
	RJMP _0x204003E
_0x2040040:
	RJMP _0x204003B
_0x204003D:
_0x2040038:
	LDD  R26,Y+14
	CP   R16,R26
	BREQ _0x2040041
	LDD  R30,Y+14
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	LDI  R31,0
	CALL SUBOPT_0xD
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
	CALL SUBOPT_0xE
	RJMP _0x2040046
_0x2040048:
	LDD  R30,Y+14
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R31,0
	CALL SUBOPT_0xD
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
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	STD  Y+6,R30
	STD  Y+6+1,R31
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
	ST   -Y,R16
	LDD  R26,Y+16
	RCALL _pcd8544_gotoxy
	RJMP _0x2040050
_0x204005B:
	CPI  R30,LOW(0x6)
	BRNE _0x2040050
	CALL SUBOPT_0xF
_0x2040050:
_0x204005D:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x204005F
	LDD  R26,Y+9
	CPI  R26,LOW(0x6)
	BRNE _0x2040060
	CALL SUBOPT_0x10
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0xC
	SBIW R30,1
	SUBI R30,LOW(-_gfx_buffer_G102)
	SBCI R31,HIGH(-_gfx_buffer_G102)
	LD   R26,Z
	CALL _glcd_writemem
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
	CALL SUBOPT_0x10
	CALL SUBOPT_0x11
	MOV  R21,R30
	LDD  R30,Y+9
	CPI  R30,LOW(0x7)
	BREQ _0x204006D
	CPI  R30,LOW(0x8)
	BRNE _0x204006E
_0x204006D:
_0x2040066:
	CALL SUBOPT_0x12
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
	CALL SUBOPT_0x13
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
	CALL _glcd_getmask
	MOV  R20,R30
	LDD  R30,Y+9
	CPI  R30,LOW(0x6)
	BRNE _0x204007C
	CALL SUBOPT_0xF
_0x204007D:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x204007F
	CALL SUBOPT_0xC
	SBIW R30,1
	SUBI R30,LOW(-_gfx_buffer_G102)
	SBCI R31,HIGH(-_gfx_buffer_G102)
	LD   R30,Z
	AND  R30,R20
	MOV  R26,R30
	MOV  R30,R19
	CALL __LSRB12
	CALL SUBOPT_0x14
	MOV  R30,R19
	MOV  R26,R20
	CALL __LSRB12
	COM  R30
	AND  R30,R1
	OR   R21,R30
	CALL SUBOPT_0x10
	ST   -Y,R31
	ST   -Y,R30
	MOV  R26,R21
	CALL _glcd_writemem
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
	CALL SUBOPT_0x12
	MOV  R26,R30
	MOV  R30,R19
	CALL __LSLB12
	MOV  R21,R30
_0x2040084:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x2040086
	CALL SUBOPT_0x13
	ST   -Y,R20
	LDI  R26,LOW(0)
	RCALL _pcd8544_wrmasked_G102
	RJMP _0x2040084
_0x2040086:
	RJMP _0x204007B
_0x2040087:
_0x2040088:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x204008A
	CALL SUBOPT_0x15
	MOV  R26,R30
	MOV  R30,R19
	CALL __LSLB12
	ST   -Y,R30
	ST   -Y,R20
	LDD  R26,Y+13
	RCALL _pcd8544_wrmasked_G102
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
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x2040076:
	MOV  R30,R21
	LDI  R31,0
	SUBI R30,LOW(-__glcd_mask*2)
	SBCI R31,HIGH(-__glcd_mask*2)
	LPM  R20,Z
	LDD  R30,Y+9
	CPI  R30,LOW(0x6)
	BRNE _0x2040091
	CALL SUBOPT_0xF
_0x2040092:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x2040094
	CALL SUBOPT_0xC
	SBIW R30,1
	SUBI R30,LOW(-_gfx_buffer_G102)
	SBCI R31,HIGH(-_gfx_buffer_G102)
	LD   R30,Z
	AND  R30,R20
	MOV  R26,R30
	MOV  R30,R18
	CALL __LSLB12
	CALL SUBOPT_0x14
	MOV  R30,R18
	MOV  R26,R20
	CALL __LSLB12
	COM  R30
	AND  R30,R1
	OR   R21,R30
	CALL SUBOPT_0x10
	ST   -Y,R31
	ST   -Y,R30
	MOV  R26,R21
	CALL _glcd_writemem
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
	CALL SUBOPT_0x12
	MOV  R26,R30
	MOV  R30,R18
	CALL __LSRB12
	MOV  R21,R30
_0x2040099:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x204009B
	CALL SUBOPT_0x13
	ST   -Y,R20
	LDI  R26,LOW(0)
	RCALL _pcd8544_wrmasked_G102
	RJMP _0x2040099
_0x204009B:
	RJMP _0x2040090
_0x204009C:
_0x204009D:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x204009F
	CALL SUBOPT_0x15
	MOV  R26,R30
	MOV  R30,R18
	CALL __LSRB12
	ST   -Y,R30
	ST   -Y,R20
	LDD  R26,Y+13
	RCALL _pcd8544_wrmasked_G102
	RJMP _0x204009D
_0x204009F:
_0x2040090:
_0x2040075:
	LDD  R30,Y+8
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x2040049
_0x204004B:
_0x2120006:
	CALL __LOADLOCR6
	ADIW R28,17
	RET
; .FEND

	.CSEG
_glcd_clipx:
; .FSTART _glcd_clipx
	CALL SUBOPT_0x16
	BRLT _0x2060003
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x2120003
_0x2060003:
	LD   R26,Y
	LDD  R27,Y+1
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
	CALL SUBOPT_0x16
	BRLT _0x2060005
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x2120003
_0x2060005:
	LD   R26,Y
	LDD  R27,Y+1
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
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,3
	CALL SUBOPT_0x17
	MOVW R16,R30
	MOV  R0,R16
	OR   R0,R17
	BRNE _0x206000B
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x2120005
_0x206000B:
	CALL SUBOPT_0x18
	STD  Y+7,R0
	CALL SUBOPT_0x18
	STD  Y+6,R0
	CALL SUBOPT_0x18
	STD  Y+8,R0
	LDD  R30,Y+11
	LDD  R26,Y+8
	CP   R30,R26
	BRSH _0x206000C
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x2120005
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
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x2120005
_0x206000D:
	LDD  R30,Y+6
	LSR  R30
	LSR  R30
	LSR  R30
	MOV  R20,R30
	LDD  R30,Y+6
	ANDI R30,LOW(0x7)
	BREQ _0x206000E
	SUBI R20,-LOW(1)
_0x206000E:
	LDD  R30,Y+7
	CPI  R30,0
	BREQ _0x206000F
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ST   X,R30
	LDD  R26,Y+8
	LDD  R30,Y+11
	SUB  R30,R26
	LDI  R31,0
	MOVW R26,R30
	LDD  R30,Y+7
	LDI  R31,0
	CALL __MULW12U
	MOVW R26,R30
	MOV  R30,R20
	LDI  R31,0
	CALL __MULW12U
	ADD  R30,R16
	ADC  R31,R17
	RJMP _0x2120005
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
	LDI  R31,0
	CALL __MULW12U
	__ADDWRR 16,17,30,31
	RJMP _0x2060010
_0x2060012:
	MOVW R30,R18
	LPM  R30,Z
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ST   X,R30
	MOVW R30,R16
_0x2120005:
	CALL __LOADLOCR6
	ADIW R28,12
	RET
; .FEND
_glcd_new_line_G103:
; .FSTART _glcd_new_line_G103
	LDI  R30,LOW(0)
	__PUTB1MN _glcd_state,2
	__GETB2MN _glcd_state,3
	CLR  R27
	CALL SUBOPT_0x19
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	__GETB1MN _glcd_state,7
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	RCALL _glcd_clipy
	__PUTB1MN _glcd_state,3
	RET
; .FEND
_glcd_putchar:
; .FSTART _glcd_putchar
	ST   -Y,R26
	SBIW R28,1
	CALL SUBOPT_0x17
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
	RJMP _0x2120004
_0x2060022:
	__GETB1MN _glcd_state,6
	LDD  R26,Y+6
	ADD  R30,R26
	MOV  R19,R30
	__GETB2MN _glcd_state,2
	CLR  R27
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	MOVW R16,R30
	__CPWRN 16,17,85
	BRLO _0x2060023
	MOV  R16,R19
	CLR  R17
	RCALL _glcd_new_line_G103
_0x2060023:
	__GETB1MN _glcd_state,2
	ST   -Y,R30
	__GETB1MN _glcd_state,3
	ST   -Y,R30
	LDD  R30,Y+8
	ST   -Y,R30
	CALL SUBOPT_0x19
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
	ST   -Y,R30
	__GETB1MN _glcd_state,3
	ST   -Y,R30
	__GETB1MN _glcd_state,6
	ST   -Y,R30
	CALL SUBOPT_0x19
	CALL SUBOPT_0x1A
	__GETB1MN _glcd_state,2
	ST   -Y,R30
	__GETB2MN _glcd_state,3
	CALL SUBOPT_0x19
	ADD  R30,R26
	ST   -Y,R30
	ST   -Y,R19
	__GETB1MN _glcd_state,7
	CALL SUBOPT_0x1A
	LDI  R30,LOW(84)
	LDI  R31,HIGH(84)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x2060024
_0x2060021:
	RCALL _glcd_new_line_G103
	RJMP _0x2120004
_0x2060024:
_0x206001F:
	__PUTBMRN _glcd_state,2,16
_0x2120004:
	CALL __LOADLOCR6
	ADIW R28,8
	RET
; .FEND
_glcd_outtext:
; .FSTART _glcd_outtext
	ST   -Y,R27
	ST   -Y,R26
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
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG

	.CSEG

	.CSEG

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
	CALL __LSLB12
_0x2120003:
	ADIW R28,2
	RET
; .FEND
_glcd_mappixcolor1bit:
; .FSTART _glcd_mappixcolor1bit
	ST   -Y,R26
	ST   -Y,R17
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
	ST   -Y,R27
	ST   -Y,R26
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
	LD   R26,Y
	LDD  R27,Y+1
	CALL __EEPROMRDB
	RJMP _0x2120002
_0x2100016:
	CPI  R30,LOW(0x3)
	BRNE _0x2100018
	LD   R26,Y
	LDD  R27,Y+1
	__CALL1MN _glcd_state,25
	RJMP _0x2120002
_0x2100018:
	LD   R26,Y
	LDD  R27,Y+1
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
	CALL __EEPROMWRB
	RJMP _0x210001B
_0x210001D:
	CPI  R30,LOW(0x3)
	BRNE _0x210001B
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ST   -Y,R31
	ST   -Y,R30
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
_rx_buffer0:
	.BYTE 0x40
_buff:
	.BYTE 0x104
_tx_buffer0:
	.BYTE 0x40
_tx_rd_index0:
	.BYTE 0x1
_tx_counter0:
	.BYTE 0x1
__seed_G101:
	.BYTE 0x4
_gfx_addr_G102:
	.BYTE 0x2
_gfx_buffer_G102:
	.BYTE 0x1F8

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x0:
	CALL _delay_ms
	CALL _glcd_clear
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _glcd_moveto

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	SUB  R26,R18
	SBC  R27,R19
	LDD  R30,Y+46
	LDD  R31,Y+46+1
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	LDI  R30,LOW(_buff)
	LDI  R31,HIGH(_buff)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3:
	__GETW2SX 81
	LD   R30,X
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x4:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	CALL _put_string
	LDI  R26,LOW(300)
	LDI  R27,HIGH(300)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x6:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(2)
	LDI  R27,0
	CALL _wait_until
	LDI  R26,LOW(0)
	LDI  R27,0
	JMP  _refresh

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x7:
	CALL _glcd_clear
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _glcd_moveto

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x8:
	MOVW R30,R28
	ADIW R30,44
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9:
	CALL _strcat
	RJMP SUBOPT_0x8

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0xA:
	CALL _strcat
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,26
	CALL _itoa
	RJMP SUBOPT_0x8

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB:
	CALL _put_string
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xC:
	LDI  R26,LOW(_gfx_addr_G102)
	LDI  R27,HIGH(_gfx_addr_G102)
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD:
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+6,R30
	STD  Y+6+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0xE:
	LDD  R30,Y+12
	ST   -Y,R30
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ADIW R30,1
	STD  Y+7,R30
	STD  Y+7+1,R31
	SBIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _glcd_writemem

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF:
	ST   -Y,R16
	LDD  R26,Y+16
	JMP  _pcd8544_setaddr_G102

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x10:
	LDD  R30,Y+12
	ST   -Y,R30
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ADIW R30,1
	STD  Y+7,R30
	STD  Y+7+1,R31
	SBIW R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x11:
	CLR  R22
	CLR  R23
	MOVW R26,R30
	MOVW R24,R22
	JMP  _glcd_readmem

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x12:
	ST   -Y,R21
	LDD  R26,Y+10
	JMP  _glcd_mappixcolor1bit

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x13:
	ST   -Y,R16
	INC  R16
	LDD  R30,Y+16
	ST   -Y,R30
	ST   -Y,R21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x14:
	MOV  R21,R30
	LDD  R30,Y+12
	ST   -Y,R30
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	CLR  R24
	CLR  R25
	CALL _glcd_readmem
	MOV  R1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x15:
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
	RJMP SUBOPT_0x11

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x16:
	ST   -Y,R27
	ST   -Y,R26
	LD   R26,Y
	LDD  R27,Y+1
	CALL __CPW02
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x17:
	CALL __SAVELOCR6
	__GETW1MN _glcd_state,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x18:
	MOVW R30,R16
	__ADDWRN 16,17,1
	LPM  R0,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x19:
	__GETW1MN _glcd_state,4
	ADIW R30,1
	LPM  R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1A:
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(9)
	JMP  _glcd_block


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

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
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

__INITLOCB:
__INITLOCW:
	ADD  R26,R28
	ADC  R27,R29
__INITLOC0:
	LPM  R0,Z+
	ST   X+,R0
	DEC  R24
	BRNE __INITLOC0
	RET

;END OF CODE MARKER
__END_OF_CODE:

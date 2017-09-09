
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
	.DEF _i=R4
	.DEF _i_msb=R5
	.DEF _time_flow=R6
	.DEF _time_flow_msb=R7
	.DEF _j=R8
	.DEF _j_msb=R9
	.DEF _k=R10
	.DEF _k_msb=R11
	.DEF _new_sms=R13
	.DEF _notified=R12

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
	JMP  _usart1_rx_isr
	JMP  0x00
	JMP  _usart1_tx_isr
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
_tbl10_G104:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G104:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0

_0x3:
	.DB  0xFF,0xFF
_0x3F:
	.DB  0xA1
_0x40:
	.DB  0xA2
_0x41:
	.DB  0xA3
_0x42:
	.DB  0xA4
_0xFE:
	.DB  0x47,0x45,0x54,0x20,0x2F,0x75,0x70,0x64
	.DB  0x61,0x74,0x65,0x3F,0x6B,0x65,0x79,0x3D
	.DB  0x0
_0x0:
	.DB  0x4E,0x6F,0x64,0x65,0x3A,0x20,0x0,0x54
	.DB  0x65,0x6D,0x70,0x3A,0x20,0x0,0x48,0x75
	.DB  0x6D,0x69,0x64,0x3A,0x20,0x0,0x57,0x61
	.DB  0x74,0x65,0x72,0x3A,0x20,0x0,0x6D,0x6D
	.DB  0x0,0x45,0x52,0x52,0x4F,0x52,0x0,0x41
	.DB  0x54,0x2B,0x43,0x57,0x4D,0x4F,0x44,0x45
	.DB  0x3D,0x31,0xD,0xA,0x0,0x4F,0x4B,0x0
	.DB  0x63,0x6F,0x6E,0x66,0x69,0x67,0x20,0x66
	.DB  0x61,0x69,0x6C,0x0,0x41,0x54,0x2B,0x43
	.DB  0x57,0x4A,0x41,0x50,0x3D,0x22,0x54,0x68
	.DB  0x61,0x79,0x5F,0x54,0x68,0x61,0x6F,0x5F
	.DB  0x64,0x65,0x6F,0x5F,0x67,0x69,0x61,0x69
	.DB  0x22,0x2C,0x22,0x63,0x68,0x69,0x6E,0x68
	.DB  0x78,0x61,0x63,0x22,0xD,0xA,0x0,0x63
	.DB  0x6F,0x6E,0x6E,0x65,0x63,0x74,0x20,0x66
	.DB  0x61,0x69,0x6C,0x0,0x63,0x6F,0x6E,0x6E
	.DB  0x65,0x63,0x74,0x20,0x77,0x69,0x66,0x69
	.DB  0x20,0x73,0x75,0x63,0x63,0x65,0x73,0x73
	.DB  0x0,0x41,0x54,0x2B,0x43,0x49,0x50,0x4D
	.DB  0x55,0x58,0x3D,0x31,0x0,0x41,0x54,0x2B
	.DB  0x43,0x49,0x50,0x53,0x54,0x41,0x52,0x54
	.DB  0x3D,0x30,0x2C,0x22,0x54,0x43,0x50,0x22
	.DB  0x2C,0x22,0x61,0x70,0x69,0x2E,0x74,0x68
	.DB  0x69,0x6E,0x67,0x73,0x70,0x65,0x61,0x6B
	.DB  0x2E,0x63,0x6F,0x6D,0x22,0x2C,0x38,0x30
	.DB  0x0,0x26,0x66,0x69,0x65,0x6C,0x64,0x31
	.DB  0x3D,0x0,0x26,0x66,0x69,0x65,0x6C,0x64
	.DB  0x32,0x3D,0x0,0x26,0x66,0x69,0x65,0x6C
	.DB  0x64,0x33,0x3D,0x0,0x41,0x54,0x2B,0x43
	.DB  0x49,0x50,0x53,0x45,0x4E,0x44,0x3D,0x30
	.DB  0x2C,0x0,0x3E,0x20,0x0,0x53,0x65,0x6E
	.DB  0x64,0x69,0x6E,0x67,0x0,0x44,0x6F,0x6E
	.DB  0x65,0x0,0x61,0x61,0x61,0x61,0x0,0x25
	.DB  0x64,0x20,0x0,0x25,0x64,0x20,0x20,0x0
	.DB  0x36,0x5A,0x46,0x31,0x59,0x42,0x38,0x41
	.DB  0x58,0x49,0x53,0x42,0x53,0x41,0x32,0x50
	.DB  0x0
_0x20A0060:
	.DB  0x1
_0x20A0000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x0A
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x01
	.DW  _Code_tay_cam1
	.DW  _0x3F*2

	.DW  0x01
	.DW  _Code_tay_cam2
	.DW  _0x40*2

	.DW  0x01
	.DW  _Code_tay_cam3
	.DW  _0x41*2

	.DW  0x01
	.DW  _Code_tay_cam4
	.DW  _0x42*2

	.DW  0x07
	.DW  _0xE2
	.DW  _0x0*2

	.DW  0x07
	.DW  _0xE2+7
	.DW  _0x0*2+7

	.DW  0x08
	.DW  _0xE2+14
	.DW  _0x0*2+14

	.DW  0x08
	.DW  _0xE2+22
	.DW  _0x0*2+22

	.DW  0x03
	.DW  _0xE2+30
	.DW  _0x0*2+30

	.DW  0x06
	.DW  _0xFA
	.DW  _0x0*2+33

	.DW  0x0E
	.DW  _0xFB
	.DW  _0x0*2+39

	.DW  0x03
	.DW  _0xFB+14
	.DW  _0x0*2+53

	.DW  0x0C
	.DW  _0xFB+17
	.DW  _0x0*2+56

	.DW  0x2B
	.DW  _0xFB+29
	.DW  _0x0*2+68

	.DW  0x03
	.DW  _0xFB+72
	.DW  _0x0*2+53

	.DW  0x0D
	.DW  _0xFB+75
	.DW  _0x0*2+111

	.DW  0x15
	.DW  _0xFB+88
	.DW  _0x0*2+124

	.DW  0x0C
	.DW  _0x102
	.DW  _0x0*2+145

	.DW  0x03
	.DW  _0x102+12
	.DW  _0x0*2+50

	.DW  0x03
	.DW  _0x102+15
	.DW  _0x0*2+53

	.DW  0x2C
	.DW  _0x102+18
	.DW  _0x0*2+157

	.DW  0x03
	.DW  _0x102+62
	.DW  _0x0*2+50

	.DW  0x03
	.DW  _0x102+65
	.DW  _0x0*2+53

	.DW  0x09
	.DW  _0x102+68
	.DW  _0x0*2+201

	.DW  0x09
	.DW  _0x102+77
	.DW  _0x0*2+210

	.DW  0x09
	.DW  _0x102+86
	.DW  _0x0*2+219

	.DW  0x0E
	.DW  _0x102+95
	.DW  _0x0*2+228

	.DW  0x03
	.DW  _0x102+109
	.DW  _0x0*2+50

	.DW  0x03
	.DW  _0x102+112
	.DW  _0x0*2+242

	.DW  0x08
	.DW  _0x102+115
	.DW  _0x0*2+245

	.DW  0x03
	.DW  _0x102+123
	.DW  _0x0*2+50

	.DW  0x05
	.DW  _0x102+126
	.DW  _0x0*2+253

	.DW  0x05
	.DW  _0x103
	.DW  _0x0*2+258

	.DW  0x11
	.DW  _0x103+5
	.DW  _0x0*2+272

	.DW  0x01
	.DW  __seed_G105
	.DW  _0x20A0060*2

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
;
;
;#include <mega128a.h>
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
;// I2C Bus functions
;#include <i2c.h>
;
;// DS1307 Real Time Clock functions
;#include <ds1307.h>
;
;// Graphic Display functions
;#include <glcd.h>
;
;// Font used for displaying text
;// on the graphic display
;#include <font5x7.h>
;#include <stdio.h>
;#include <delay.h>
;#include <stdlib.h>
;#include <string.h>
;
;//============================================================= WIFI CONFIG ============================================ ...
;
;const int BUFFSIZE = 460, TIME_LOOP_S = 120;
;
;int i = 0, time_flow = 0;
;int j,k = 0;
;char cmd[4];
;char buff[BUFFSIZE],la[20],lo[20], sms_command[8], gprs_command[6], entry_id[4], entry_id_old[6];
;bool new_sms = false, notified = false, stop = false, send_ok = false, loop = false;
;int pr_back = -1, time_s = 0;

	.DSEG
;//====================================================================================================================== ...
;
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
;// This flag is set on USART0 Receiver buffer overflow
;bit rx_buffer_overflow0;
;
;// USART0 Receiver interrupt service routine
;interrupt [USART0_RXC] void usart0_rx_isr(void)
; 0000 0040 {

	.CSEG
_usart0_rx_isr:
; .FSTART _usart0_rx_isr
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0041 char status,data;
; 0000 0042 bool id_found = false;
; 0000 0043 status=UCSR0A;
	CALL __SAVELOCR4
;	status -> R17
;	data -> R16
;	id_found -> R19
	LDI  R19,0
	IN   R17,11
; 0000 0044 data=UDR0;
	IN   R16,12
; 0000 0045 if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0x4
; 0000 0046    {
; 0000 0047    rx_buffer0[rx_wr_index0++]=data;
	LDS  R30,_rx_wr_index0
	SUBI R30,-LOW(1)
	STS  _rx_wr_index0,R30
	SUBI R30,LOW(1)
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer0)
	SBCI R31,HIGH(-_rx_buffer0)
	ST   Z,R16
; 0000 0048 #if RX_BUFFER_SIZE0 == 256
; 0000 0049    // special case for receiver buffer size=256
; 0000 004A    if (++rx_counter0 == 0) rx_buffer_overflow0=1;
; 0000 004B #else
; 0000 004C    if (rx_wr_index0 == RX_BUFFER_SIZE0) rx_wr_index0=0;
	LDS  R26,_rx_wr_index0
	CPI  R26,LOW(0x40)
	BRNE _0x5
	LDI  R30,LOW(0)
	STS  _rx_wr_index0,R30
; 0000 004D    if (++rx_counter0 == RX_BUFFER_SIZE0)
_0x5:
	LDS  R26,_rx_counter0
	SUBI R26,-LOW(1)
	STS  _rx_counter0,R26
	CPI  R26,LOW(0x40)
	BRNE _0x6
; 0000 004E       {
; 0000 004F       rx_counter0=0;
	LDI  R30,LOW(0)
	STS  _rx_counter0,R30
; 0000 0050       rx_buffer_overflow0=1;
	SET
	BLD  R2,0
; 0000 0051       }
; 0000 0052 #endif
; 0000 0053    }
_0x6:
; 0000 0054       buff[i] = data;
_0x4:
	MOVW R30,R4
	SUBI R30,LOW(-_buff)
	SBCI R31,HIGH(-_buff)
	ST   Z,R16
; 0000 0055 
; 0000 0056     if (data == ']') {
	CPI  R16,93
	BRNE _0x7
; 0000 0057         stop = true;
	LDI  R30,LOW(1)
	STS  _stop,R30
; 0000 0058     }
; 0000 0059 
; 0000 005A     if (buff[i] == 'I') {
_0x7:
	CALL SUBOPT_0x0
	CPI  R26,LOW(0x49)
	BRNE _0x8
; 0000 005B         if (buff[i - 1] == 'T') {
	MOVW R30,R4
	SBIW R30,1
	SUBI R30,LOW(-_buff)
	SBCI R31,HIGH(-_buff)
	LD   R26,Z
	CPI  R26,LOW(0x54)
	BRNE _0x9
; 0000 005C             if (buff[i - 2] == 'M') {
	MOVW R30,R4
	SBIW R30,2
	SUBI R30,LOW(-_buff)
	SBCI R31,HIGH(-_buff)
	LD   R26,Z
	CPI  R26,LOW(0x4D)
	BRNE _0xA
; 0000 005D                 if (buff[i - 3] == 'C') {
	MOVW R30,R4
	SBIW R30,3
	SUBI R30,LOW(-_buff)
	SBCI R31,HIGH(-_buff)
	LD   R26,Z
	CPI  R26,LOW(0x43)
	BRNE _0xB
; 0000 005E                     new_sms = true;
	LDI  R30,LOW(1)
	MOV  R13,R30
; 0000 005F                     notified = false;
	CLR  R12
; 0000 0060                 }
; 0000 0061             }
_0xB:
; 0000 0062         }
_0xA:
; 0000 0063     }
_0x9:
; 0000 0064 
; 0000 0065     if (buff[i] == ']') {
_0x8:
	CALL SUBOPT_0x0
	CPI  R26,LOW(0x5D)
	BREQ PC+2
	RJMP _0xC
; 0000 0066         //"entry_id":15,"field1":"info"}]
; 0000 0067         j = i - 2;
	MOVW R30,R4
	SBIW R30,2
	MOVW R8,R30
; 0000 0068         k = 0;
	CLR  R10
	CLR  R11
; 0000 0069         while (1) {
_0xD:
; 0000 006A             if (j < 0) {
	CLR  R0
	CP   R8,R0
	CPC  R9,R0
	BRGE _0x10
; 0000 006B                 j += BUFFSIZE;
	MOVW R30,R8
	SUBI R30,LOW(-460)
	SBCI R31,HIGH(-460)
	MOVW R8,R30
; 0000 006C             }
; 0000 006D 
; 0000 006E             gprs_command[k] = buff[j - k];
_0x10:
	MOVW R26,R10
	SUBI R26,LOW(-_gprs_command)
	SBCI R27,HIGH(-_gprs_command)
	MOVW R30,R8
	SUB  R30,R10
	SBC  R31,R11
	SUBI R30,LOW(-_buff)
	SBCI R31,HIGH(-_buff)
	LD   R30,Z
	ST   X,R30
; 0000 006F             k++;
	MOVW R30,R10
	ADIW R30,1
	MOVW R10,R30
; 0000 0070             if ((buff[j - k] == '"')) {
	MOVW R30,R8
	SUB  R30,R10
	SBC  R31,R11
	SUBI R30,LOW(-_buff)
	SBCI R31,HIGH(-_buff)
	LD   R26,Z
	CPI  R26,LOW(0x22)
	BRNE _0xD
; 0000 0071                 break;
; 0000 0072             }
; 0000 0073         }
; 0000 0074 
; 0000 0075         while (!id_found) {
_0x12:
	CPI  R19,0
	BRNE _0x14
; 0000 0076             //nen them 1 cai check neu het gioi han mang nhu o tren
; 0000 0077             // if (j < 0) {
; 0000 0078                 // j += BUFFSIZE;
; 0000 0079             // }
; 0000 007A             if ((buff[j] == 'i') && (buff[j+1] == 'd')) {
	LDI  R26,LOW(_buff)
	LDI  R27,HIGH(_buff)
	ADD  R26,R8
	ADC  R27,R9
	LD   R26,X
	CPI  R26,LOW(0x69)
	BRNE _0x16
	MOVW R30,R8
	__ADDW1MN _buff,1
	LD   R26,Z
	CPI  R26,LOW(0x64)
	BREQ _0x17
_0x16:
	RJMP _0x15
_0x17:
; 0000 007B                 k = 0;
	CLR  R10
	CLR  R11
; 0000 007C                 j = j + 4;
	MOVW R30,R8
	ADIW R30,4
	MOVW R8,R30
; 0000 007D                 while (buff[j] != ',') {
_0x18:
	LDI  R26,LOW(_buff)
	LDI  R27,HIGH(_buff)
	ADD  R26,R8
	ADC  R27,R9
	LD   R26,X
	CPI  R26,LOW(0x2C)
	BREQ _0x1A
; 0000 007E                     entry_id[k] = buff[j];
	MOVW R30,R10
	SUBI R30,LOW(-_entry_id)
	SBCI R31,HIGH(-_entry_id)
	MOVW R0,R30
	LDI  R26,LOW(_buff)
	LDI  R27,HIGH(_buff)
	ADD  R26,R8
	ADC  R27,R9
	LD   R30,X
	MOVW R26,R0
	ST   X,R30
; 0000 007F                     j++;
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
; 0000 0080                     k++;
	MOVW R30,R10
	ADIW R30,1
	MOVW R10,R30
; 0000 0081                 }
	RJMP _0x18
_0x1A:
; 0000 0082                 id_found = true;
	LDI  R19,LOW(1)
; 0000 0083             }
; 0000 0084             j--;
_0x15:
	MOVW R30,R8
	SBIW R30,1
	MOVW R8,R30
; 0000 0085         }
	RJMP _0x12
_0x14:
; 0000 0086     }
; 0000 0087 
; 0000 0088 	if (buff[i] == 'e') {
_0xC:
	CALL SUBOPT_0x0
	CPI  R26,LOW(0x65)
	BRNE _0x1B
; 0000 0089 		if (buff[i - 1] == 'd') {
	MOVW R30,R4
	SBIW R30,1
	SUBI R30,LOW(-_buff)
	SBCI R31,HIGH(-_buff)
	LD   R26,Z
	CPI  R26,LOW(0x64)
	BRNE _0x1C
; 0000 008A 			if (buff[i - 2] == 'a') {
	MOVW R30,R4
	SBIW R30,2
	SUBI R30,LOW(-_buff)
	SBCI R31,HIGH(-_buff)
	LD   R26,Z
	CPI  R26,LOW(0x61)
	BRNE _0x1D
; 0000 008B 				if (buff[i - 3] == 'e') {
	MOVW R30,R4
	SBIW R30,3
	SUBI R30,LOW(-_buff)
	SBCI R31,HIGH(-_buff)
	LD   R26,Z
	CPI  R26,LOW(0x65)
	BRNE _0x1E
; 0000 008C 					send_ok = true;
	LDI  R30,LOW(1)
	STS  _send_ok,R30
; 0000 008D 				}
; 0000 008E 			}
_0x1E:
; 0000 008F 		}
_0x1D:
; 0000 0090 	}
_0x1C:
; 0000 0091 
; 0000 0092     i++;
_0x1B:
	MOVW R30,R4
	ADIW R30,1
	MOVW R4,R30
; 0000 0093     if (i > BUFFSIZE) {
	LDI  R30,LOW(460)
	LDI  R31,HIGH(460)
	CP   R30,R4
	CPC  R31,R5
	BRGE _0x1F
; 0000 0094         i = 0;
	CLR  R4
	CLR  R5
; 0000 0095     }
; 0000 0096 
; 0000 0097 }
_0x1F:
	CALL __LOADLOCR4
	ADIW R28,4
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Get a character from the USART0 Receiver buffer
;#define _ALTERNATE_GETCHAR_
;#pragma used+
;char getchar(void)
; 0000 009E {
; 0000 009F char data;
; 0000 00A0 while (rx_counter0==0);
;	data -> R17
; 0000 00A1 data=rx_buffer0[rx_rd_index0++];
; 0000 00A2 #if RX_BUFFER_SIZE0 != 256
; 0000 00A3 if (rx_rd_index0 == RX_BUFFER_SIZE0) rx_rd_index0=0;
; 0000 00A4 #endif
; 0000 00A5 #asm("cli")
; 0000 00A6 --rx_counter0;
; 0000 00A7 #asm("sei")
; 0000 00A8 return data;
; 0000 00A9 }
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
;interrupt [USART0_TXC] void usart0_tx_isr(void)
; 0000 00BF {
_usart0_tx_isr:
; .FSTART _usart0_tx_isr
	CALL SUBOPT_0x1
; 0000 00C0 if (tx_counter0)
	LDS  R30,_tx_counter0
	CPI  R30,0
	BREQ _0x24
; 0000 00C1    {
; 0000 00C2    --tx_counter0;
	SUBI R30,LOW(1)
	STS  _tx_counter0,R30
; 0000 00C3    UDR0=tx_buffer0[tx_rd_index0++];
	LDS  R30,_tx_rd_index0
	SUBI R30,-LOW(1)
	STS  _tx_rd_index0,R30
	SUBI R30,LOW(1)
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer0)
	SBCI R31,HIGH(-_tx_buffer0)
	LD   R30,Z
	OUT  0xC,R30
; 0000 00C4 #if TX_BUFFER_SIZE0 != 256
; 0000 00C5    if (tx_rd_index0 == TX_BUFFER_SIZE0) tx_rd_index0=0;
	LDS  R26,_tx_rd_index0
	CPI  R26,LOW(0x40)
	BRNE _0x25
	LDI  R30,LOW(0)
	STS  _tx_rd_index0,R30
; 0000 00C6 #endif
; 0000 00C7    }
_0x25:
; 0000 00C8 }
_0x24:
	RJMP _0x10E
; .FEND
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Write a character to the USART0 Transmitter buffer
;#define _ALTERNATE_PUTCHAR_
;#pragma used+
;void putchar(char c)
; 0000 00CF {
_putchar:
; .FSTART _putchar
; 0000 00D0 while (tx_counter0 == TX_BUFFER_SIZE0);
	ST   -Y,R26
;	c -> Y+0
_0x26:
	LDS  R26,_tx_counter0
	CPI  R26,LOW(0x40)
	BREQ _0x26
; 0000 00D1 #asm("cli")
	cli
; 0000 00D2 if (tx_counter0 || ((UCSR0A & DATA_REGISTER_EMPTY)==0))
	LDS  R30,_tx_counter0
	CPI  R30,0
	BRNE _0x2A
	SBIC 0xB,5
	RJMP _0x29
_0x2A:
; 0000 00D3    {
; 0000 00D4    tx_buffer0[tx_wr_index0++]=c;
	LDS  R30,_tx_wr_index0
	SUBI R30,-LOW(1)
	STS  _tx_wr_index0,R30
	SUBI R30,LOW(1)
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer0)
	SBCI R31,HIGH(-_tx_buffer0)
	LD   R26,Y
	STD  Z+0,R26
; 0000 00D5 #if TX_BUFFER_SIZE0 != 256
; 0000 00D6    if (tx_wr_index0 == TX_BUFFER_SIZE0) tx_wr_index0=0;
	LDS  R26,_tx_wr_index0
	CPI  R26,LOW(0x40)
	BRNE _0x2C
	LDI  R30,LOW(0)
	STS  _tx_wr_index0,R30
; 0000 00D7 #endif
; 0000 00D8    ++tx_counter0;
_0x2C:
	LDS  R30,_tx_counter0
	SUBI R30,-LOW(1)
	STS  _tx_counter0,R30
; 0000 00D9    }
; 0000 00DA else
	RJMP _0x2D
_0x29:
; 0000 00DB    UDR0=c;
	LD   R30,Y
	OUT  0xC,R30
; 0000 00DC #asm("sei")
_0x2D:
	sei
; 0000 00DD }
	JMP  _0x216000D
; .FEND
;#pragma used-
;#endif
;
;// USART1 Receiver buffer
;#define RX_BUFFER_SIZE1 64
;char rx_buffer1[RX_BUFFER_SIZE1];
;
;#if RX_BUFFER_SIZE1 <= 256
;unsigned char rx_wr_index1=0,rx_rd_index1=0;
;#else
;unsigned int rx_wr_index1=0,rx_rd_index1=0;
;#endif
;
;#if RX_BUFFER_SIZE1 < 256
;unsigned char rx_counter1=0;
;#else
;unsigned int rx_counter1=0;
;#endif
;
;// This flag is set on USART1 Receiver buffer overflow
;bit rx_buffer_overflow1;
;
;// USART1 Receiver interrupt service routine
;interrupt [USART1_RXC] void usart1_rx_isr(void)
; 0000 00F6 {
_usart1_rx_isr:
; .FSTART _usart1_rx_isr
	CALL SUBOPT_0x1
; 0000 00F7 char status,data;
; 0000 00F8 status=UCSR1A;
	ST   -Y,R17
	ST   -Y,R16
;	status -> R17
;	data -> R16
	LDS  R17,155
; 0000 00F9 data=UDR1;
	LDS  R16,156
; 0000 00FA if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0x2E
; 0000 00FB    {
; 0000 00FC    rx_buffer1[rx_wr_index1++]=data;
	LDS  R30,_rx_wr_index1
	SUBI R30,-LOW(1)
	STS  _rx_wr_index1,R30
	SUBI R30,LOW(1)
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer1)
	SBCI R31,HIGH(-_rx_buffer1)
	ST   Z,R16
; 0000 00FD #if RX_BUFFER_SIZE1 == 256
; 0000 00FE    // special case for receiver buffer size=256
; 0000 00FF    if (++rx_counter1 == 0) rx_buffer_overflow1=1;
; 0000 0100 #else
; 0000 0101    if (rx_wr_index1 == RX_BUFFER_SIZE1) rx_wr_index1=0;
	LDS  R26,_rx_wr_index1
	CPI  R26,LOW(0x40)
	BRNE _0x2F
	LDI  R30,LOW(0)
	STS  _rx_wr_index1,R30
; 0000 0102    if (++rx_counter1 == RX_BUFFER_SIZE1)
_0x2F:
	LDS  R26,_rx_counter1
	SUBI R26,-LOW(1)
	STS  _rx_counter1,R26
	CPI  R26,LOW(0x40)
	BRNE _0x30
; 0000 0103       {
; 0000 0104       rx_counter1=0;
	LDI  R30,LOW(0)
	STS  _rx_counter1,R30
; 0000 0105       rx_buffer_overflow1=1;
	SET
	BLD  R2,1
; 0000 0106       }
; 0000 0107 #endif
; 0000 0108    }
_0x30:
; 0000 0109 }
_0x2E:
	LD   R16,Y+
	LD   R17,Y+
	RJMP _0x10E
; .FEND
;
;// Get a character from the USART1 Receiver buffer
;#pragma used+
;char getchar1(void)
; 0000 010E {
; 0000 010F char data;
; 0000 0110 while (rx_counter1==0);
;	data -> R17
; 0000 0111 data=rx_buffer1[rx_rd_index1++];
; 0000 0112 #if RX_BUFFER_SIZE1 != 256
; 0000 0113 if (rx_rd_index1 == RX_BUFFER_SIZE1) rx_rd_index1=0;
; 0000 0114 #endif
; 0000 0115 #asm("cli")
; 0000 0116 --rx_counter1;
; 0000 0117 #asm("sei")
; 0000 0118 return data;
; 0000 0119 }
;#pragma used-
;// USART1 Transmitter buffer
;#define TX_BUFFER_SIZE1 64
;char tx_buffer1[TX_BUFFER_SIZE1];
;
;#if TX_BUFFER_SIZE1 <= 256
;unsigned char tx_wr_index1=0,tx_rd_index1=0;
;#else
;unsigned int tx_wr_index1=0,tx_rd_index1=0;
;#endif
;
;#if TX_BUFFER_SIZE1 < 256
;unsigned char tx_counter1=0;
;#else
;unsigned int tx_counter1=0;
;#endif
;
;// USART1 Transmitter interrupt service routine
;interrupt [USART1_TXC] void usart1_tx_isr(void)
; 0000 012D {
_usart1_tx_isr:
; .FSTART _usart1_tx_isr
	CALL SUBOPT_0x1
; 0000 012E if (tx_counter1)
	LDS  R30,_tx_counter1
	CPI  R30,0
	BREQ _0x35
; 0000 012F    {
; 0000 0130    --tx_counter1;
	SUBI R30,LOW(1)
	STS  _tx_counter1,R30
; 0000 0131    UDR1=tx_buffer1[tx_rd_index1++];
	LDS  R30,_tx_rd_index1
	SUBI R30,-LOW(1)
	STS  _tx_rd_index1,R30
	SUBI R30,LOW(1)
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer1)
	SBCI R31,HIGH(-_tx_buffer1)
	LD   R30,Z
	STS  156,R30
; 0000 0132 #if TX_BUFFER_SIZE1 != 256
; 0000 0133    if (tx_rd_index1 == TX_BUFFER_SIZE1) tx_rd_index1=0;
	LDS  R26,_tx_rd_index1
	CPI  R26,LOW(0x40)
	BRNE _0x36
	LDI  R30,LOW(0)
	STS  _tx_rd_index1,R30
; 0000 0134 #endif
; 0000 0135    }
_0x36:
; 0000 0136 }
_0x35:
_0x10E:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R26,Y+
	RETI
; .FEND
;
;// Write a character to the USART1 Transmitter buffer
;#pragma used+
;void putchar1(char c)
; 0000 013B {
_putchar1:
; .FSTART _putchar1
; 0000 013C while (tx_counter1 == TX_BUFFER_SIZE1);
	ST   -Y,R26
;	c -> Y+0
_0x37:
	LDS  R26,_tx_counter1
	CPI  R26,LOW(0x40)
	BREQ _0x37
; 0000 013D #asm("cli")
	cli
; 0000 013E if (tx_counter1 || ((UCSR1A & DATA_REGISTER_EMPTY)==0))
	LDS  R30,_tx_counter1
	CPI  R30,0
	BRNE _0x3B
	LDS  R30,155
	ANDI R30,LOW(0x20)
	BRNE _0x3A
_0x3B:
; 0000 013F    {
; 0000 0140    tx_buffer1[tx_wr_index1++]=c;
	LDS  R30,_tx_wr_index1
	SUBI R30,-LOW(1)
	STS  _tx_wr_index1,R30
	SUBI R30,LOW(1)
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer1)
	SBCI R31,HIGH(-_tx_buffer1)
	LD   R26,Y
	STD  Z+0,R26
; 0000 0141 #if TX_BUFFER_SIZE1 != 256
; 0000 0142    if (tx_wr_index1 == TX_BUFFER_SIZE1) tx_wr_index1=0;
	LDS  R26,_tx_wr_index1
	CPI  R26,LOW(0x40)
	BRNE _0x3D
	LDI  R30,LOW(0)
	STS  _tx_wr_index1,R30
; 0000 0143 #endif
; 0000 0144    ++tx_counter1;
_0x3D:
	LDS  R30,_tx_counter1
	SUBI R30,-LOW(1)
	STS  _tx_counter1,R30
; 0000 0145    }
; 0000 0146 else
	RJMP _0x3E
_0x3A:
; 0000 0147    UDR1=c;
	LD   R30,Y
	STS  156,R30
; 0000 0148 #asm("sei")
_0x3E:
	sei
; 0000 0149 }
	JMP  _0x216000D
; .FEND
;#pragma used-
;
;//============================================== NRF CODE ============================================================== ...
;#include <stdio.h>
;#include <delay.h>
;
;#define CE PORTA.3
;#define CSN PORTA.2
;#define SCK PORTA.4
;#define MOSI PORTA.1
;#define MISO PINA.5
;#define IRQ PINA.0
;
;unsigned char P_Add, Code_tay_cam1 = 0xA1, Code_tay_cam2 = 0xA2, Code_tay_cam3 = 0xA3, Code_tay_cam4 = 0xA4;

	.DSEG
;#include <nrf_code.h>

	.CSEG
_config:
; .FSTART _config
	__DELAY_USB 27
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(31)
	RCALL _RF_Write_TX
	LDI  R26,LOW(2)
	LDI  R27,0
	CALL _delay_ms
	LDI  R30,LOW(7)
	ST   -Y,R30
	LDI  R26,LOW(126)
	RCALL _RF_Write_TX
	LDI  R30,LOW(29)
	ST   -Y,R30
	LDI  R26,LOW(4)
	RCALL _RF_Write_TX
	LDI  R30,LOW(5)
	ST   -Y,R30
	LDI  R26,LOW(2)
	RCALL _RF_Write_TX
	RET
; .FEND
_SPI_RW_TX:
; .FSTART _SPI_RW_TX
	ST   -Y,R26
	ST   -Y,R17
;	Buff -> Y+1
;	bit_ctr -> R17
	LDI  R17,LOW(0)
_0x44:
	CPI  R17,8
	BRSH _0x45
	LDD  R30,Y+1
	ANDI R30,LOW(0x80)
	BRNE _0x46
	CBI  0x1B,1
	RJMP _0x47
_0x46:
	SBI  0x1B,1
_0x47:
	CALL SUBOPT_0x2
	SUBI R17,-1
	RJMP _0x44
_0x45:
	LDD  R30,Y+1
	LDD  R17,Y+0
	JMP  _0x216000E
; .FEND
_RF_Write_TX:
; .FSTART _RF_Write_TX
	CALL SUBOPT_0x3
;	Reg_Add -> Y+1
;	Value -> Y+0
	RCALL _SPI_RW_TX
	STS  _result,R30
	LD   R26,Y
	RCALL _SPI_RW_TX
	CALL SUBOPT_0x4
	LDS  R30,_result
	JMP  _0x216000E
; .FEND
;	Address -> Y+0
;	Address -> Y+1
;	Address2 -> Y+0
;	command -> Y+0
;	send -> Y+0
;	send -> Y+0
_SPI_RW_RX:
; .FSTART _SPI_RW_RX
	ST   -Y,R26
	ST   -Y,R17
;	Buff -> Y+1
;	bit_ctr -> R17
	LDI  R17,LOW(0)
_0x91:
	CPI  R17,8
	BRSH _0x92
	LDD  R30,Y+1
	ANDI R30,LOW(0x80)
	BRNE _0x93
	CBI  0x1B,1
	RJMP _0x94
_0x93:
	SBI  0x1B,1
_0x94:
	CALL SUBOPT_0x2
	SUBI R17,-1
	RJMP _0x91
_0x92:
	LDD  R30,Y+1
	LDD  R17,Y+0
	JMP  _0x216000E
; .FEND
_SPI_Read_RX:
; .FSTART _SPI_Read_RX
	ST   -Y,R17
	ST   -Y,R16
;	Buff -> R17
;	bit_ctr -> R16
	LDI  R17,0
	LDI  R16,LOW(0)
_0x9A:
	CPI  R16,8
	BRSH _0x9B
	__DELAY_USB 13
	LSL  R17
	SBI  0x1B,4
	__DELAY_USB 13
	LDI  R30,0
	SBIC 0x19,5
	LDI  R30,1
	OR   R17,R30
	CBI  0x1B,4
	SUBI R16,-1
	RJMP _0x9A
_0x9B:
	MOV  R30,R17
	LD   R16,Y+
	LD   R17,Y+
	RET
; .FEND
_RF_Init_RX:
; .FSTART _RF_Init_RX
	SBI  0x1B,3
	__DELAY_USW 1400
	CBI  0x1B,3
	SBI  0x1B,2
	RET
; .FEND
_RF_Write_RX:
; .FSTART _RF_Write_RX
	CALL SUBOPT_0x3
;	Reg_Add -> Y+1
;	Value -> Y+0
	CALL SUBOPT_0x5
	CALL SUBOPT_0x4
	JMP  _0x216000E
; .FEND
_RF_Write2_RX:
; .FSTART _RF_Write2_RX
	CALL SUBOPT_0x3
;	Reg_Add -> Y+1
;	Value -> Y+0
	CALL SUBOPT_0x5
	LD   R26,Y
	CALL SUBOPT_0x5
	LD   R26,Y
	CALL SUBOPT_0x5
	CALL SUBOPT_0x4
	JMP  _0x216000E
; .FEND
_RF_Write3_RX:
; .FSTART _RF_Write3_RX
	CALL SUBOPT_0x3
;	Reg_Add -> Y+1
;	Value -> Y+0
	CALL SUBOPT_0x6
	CALL SUBOPT_0x6
	CALL SUBOPT_0x6
	CALL SUBOPT_0x6
	CALL SUBOPT_0x5
	CALL SUBOPT_0x4
	JMP  _0x216000E
; .FEND
_RF_Command_RX:
; .FSTART _RF_Command_RX
	ST   -Y,R26
;	command -> Y+0
	CBI  0x1B,2
	LD   R26,Y
	RCALL _SPI_RW_RX
	CALL SUBOPT_0x4
	JMP  _0x216000D
; .FEND
_RF_Write_Address_RX:
; .FSTART _RF_Write_Address_RX
	ST   -Y,R26
;	Address1 -> Y+3
;	Address2 -> Y+2
;	Address3 -> Y+1
;	Address4 -> Y+0
	CBI  0x1B,2
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDI  R26,LOW(3)
	RCALL _RF_Write_RX
	CALL SUBOPT_0x4
	CBI  0x1B,2
	LDI  R30,LOW(10)
	ST   -Y,R30
	LDD  R26,Y+4
	RCALL _RF_Write2_RX
	LDI  R30,LOW(16)
	ST   -Y,R30
	LDD  R26,Y+4
	RCALL _RF_Write2_RX
	LDI  R30,LOW(11)
	ST   -Y,R30
	LDD  R26,Y+3
	CALL SUBOPT_0x7
	LDD  R26,Y+3
	RCALL _RF_Write3_RX
	LDI  R30,LOW(12)
	ST   -Y,R30
	LDD  R26,Y+2
	CALL SUBOPT_0x7
	LDD  R26,Y+2
	RCALL _RF_Write3_RX
	LDI  R30,LOW(13)
	ST   -Y,R30
	LDD  R26,Y+1
	CALL SUBOPT_0x7
	LDD  R26,Y+1
	RCALL _RF_Write3_RX
	JMP  _0x216000C
; .FEND
;	Address1 -> Y+0
_RF_Mode_RX:
; .FSTART _RF_Mode_RX
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(31)
	RCALL _RF_Write_RX
	SBI  0x1B,3
	RET
; .FEND
_RF_Config_RX:
; .FSTART _RF_Config_RX
	LDI  R30,LOW(28)
	CALL SUBOPT_0x8
	LDS  R30,_Code_tay_cam1
	ST   -Y,R30
	LDS  R30,_Code_tay_cam2
	ST   -Y,R30
	LDS  R30,_Code_tay_cam3
	ST   -Y,R30
	LDS  R26,_Code_tay_cam4
	RCALL _RF_Write_Address_RX
	LDI  R30,LOW(2)
	CALL SUBOPT_0x8
	LDI  R30,LOW(1)
	CALL SUBOPT_0x8
	RET
; .FEND
_RF_Read_RX_3:
; .FSTART _RF_Read_RX_3
	CBI  0x1B,3
	CALL SUBOPT_0x4
	CBI  0x1B,2
	LDI  R26,LOW(97)
	RCALL _SPI_RW_RX
	__DELAY_USB 27
	RCALL _SPI_Read_RX
	LDI  R31,0
	STS  _station_receive,R30
	STS  _station_receive+1,R31
	RCALL _SPI_Read_RX
	__POINTW2MN _station_receive,2
	CALL SUBOPT_0x9
	__POINTW2MN _station_receive,4
	CALL SUBOPT_0x9
	__POINTW2MN _station_receive,6
	CALL SUBOPT_0x9
	__POINTW2MN _station_receive,8
	CALL SUBOPT_0x9
	__POINTW2MN _station_receive,10
	LDI  R31,0
	ST   X+,R30
	ST   X,R31
	SBI  0x1B,2
	SBI  0x1B,3
	LDI  R30,LOW(7)
	ST   -Y,R30
	LDI  R26,LOW(126)
	RCALL _RF_Write_RX
	LDI  R26,LOW(226)
	RCALL _RF_Command_RX
	RET
; .FEND
;
;#include <stdlib.h>
;
;int count;
;long dem;
;bool flag;
;
;void print_border(){
; 0000 0160 void print_border(){
_print_border:
; .FSTART _print_border
; 0000 0161     glcd_line(48,0, 48, 15);
	LDI  R30,LOW(48)
	ST   -Y,R30
	LDI  R30,LOW(0)
	CALL SUBOPT_0xA
; 0000 0162     glcd_line(0, 15, 48, 15);
	LDI  R30,LOW(15)
	CALL SUBOPT_0xA
; 0000 0163 
; 0000 0164     glcd_line(0,0,84,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(84)
	ST   -Y,R30
	LDI  R26,LOW(0)
	CALL _glcd_line
; 0000 0165     glcd_line(84,0, 84, 48);
	LDI  R30,LOW(84)
	ST   -Y,R30
	LDI  R30,LOW(0)
	CALL SUBOPT_0xB
; 0000 0166     glcd_line(0, 48, 84, 48);
	LDI  R30,LOW(48)
	CALL SUBOPT_0xB
; 0000 0167     glcd_line(0, 0, 0, 48);
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	LDI  R26,LOW(48)
	CALL _glcd_line
; 0000 0168     glcd_moveto(3,3);
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDI  R26,LOW(3)
	CALL _glcd_moveto
; 0000 0169     glcd_outtext("Node: ");
	__POINTW2MN _0xE2,0
	CALL SUBOPT_0xC
; 0000 016A 
; 0000 016B     glcd_moveto(4, 18);
	LDI  R26,LOW(18)
	CALL _glcd_moveto
; 0000 016C     glcd_outtext("Temp: ");
	__POINTW2MN _0xE2,7
	CALL SUBOPT_0xC
; 0000 016D     glcd_moveto(4, 28);
	LDI  R26,LOW(28)
	CALL _glcd_moveto
; 0000 016E     glcd_outtext("Humid: ");
	__POINTW2MN _0xE2,14
	CALL SUBOPT_0xC
; 0000 016F     glcd_moveto(4, 37);
	LDI  R26,LOW(37)
	CALL _glcd_moveto
; 0000 0170     glcd_outtext("Water: ");
	__POINTW2MN _0xE2,22
	CALL _glcd_outtext
; 0000 0171     glcd_moveto(67, 28);
	LDI  R30,LOW(67)
	ST   -Y,R30
	LDI  R26,LOW(28)
	CALL _glcd_moveto
; 0000 0172     glcd_putchar(37);
	LDI  R26,LOW(37)
	CALL _glcd_putchar
; 0000 0173     glcd_moveto(67, 37);
	LDI  R30,LOW(67)
	ST   -Y,R30
	LDI  R26,LOW(37)
	CALL _glcd_moveto
; 0000 0174     glcd_outtext("mm");
	__POINTW2MN _0xE2,30
	CALL _glcd_outtext
; 0000 0175 }
	RET
; .FEND

	.DSEG
_0xE2:
	.BYTE 0x21
;
;// Timer 0 overflow interrupt service routine
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 0179 {

	.CSEG
_timer0_ovf_isr:
; .FSTART _timer0_ovf_isr
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
; 0000 017A // Reinitialize Timer 0 value
; 0000 017B TCNT0=0x83;
	LDI  R30,LOW(131)
	OUT  0x32,R30
; 0000 017C if(flag == true)
	LDS  R26,_flag
	CPI  R26,LOW(0x1)
	BRNE _0xE3
; 0000 017D     dem++;
	LDI  R26,LOW(_dem)
	LDI  R27,HIGH(_dem)
	CALL __GETD1P_INC
	__SUBD1N -1
	CALL __PUTDP1_DEC
; 0000 017E if(dem == 10000){
_0xE3:
	LDS  R26,_dem
	LDS  R27,_dem+1
	LDS  R24,_dem+2
	LDS  R25,_dem+3
	__CPD2N 0x2710
	BRNE _0xE4
; 0000 017F     flag = false;
	LDI  R30,LOW(0)
	STS  _flag,R30
; 0000 0180     count++;
	CALL SUBOPT_0xD
; 0000 0181     dem = 0;
	LDI  R30,LOW(0)
	STS  _dem,R30
	STS  _dem+1,R30
	STS  _dem+2,R30
	STS  _dem+3,R30
; 0000 0182     if(count == 5)
	LDS  R26,_count
	LDS  R27,_count+1
	SBIW R26,5
	BRNE _0xE5
; 0000 0183         count = 1;
	CALL SUBOPT_0xE
; 0000 0184 }
_0xE5:
; 0000 0185 
; 0000 0186 }
_0xE4:
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
	RETI
; .FEND
;//====================================================================================================================== ...
;
;
;//========================================================= WIFI ======================================================= ...
;
;void del_string(unsigned char *s) {
; 0000 018C void del_string(unsigned char *s) {
_del_string:
; .FSTART _del_string
; 0000 018D     while (*s) {
	ST   -Y,R27
	ST   -Y,R26
;	*s -> Y+0
_0xE6:
	LD   R26,Y
	LDD  R27,Y+1
	LD   R30,X
	CPI  R30,0
	BREQ _0xE8
; 0000 018E         *s = '\0';
	LDI  R30,LOW(0)
	ST   X,R30
; 0000 018F         s++;
	LD   R30,Y
	LDD  R31,Y+1
	ADIW R30,1
	ST   Y,R30
	STD  Y+1,R31
; 0000 0190     }
	RJMP _0xE6
_0xE8:
; 0000 0191 }
	JMP  _0x216000E
; .FEND
;
;void put_string(unsigned char *s) {
; 0000 0193 void put_string(unsigned char *s) {
_put_string:
; .FSTART _put_string
; 0000 0194     while (*s) {
	ST   -Y,R27
	ST   -Y,R26
;	*s -> Y+0
_0xE9:
	LD   R26,Y
	LDD  R27,Y+1
	LD   R30,X
	CPI  R30,0
	BREQ _0xEB
; 0000 0195         putchar1(*s);
	LD   R26,X
	RCALL _putchar1
; 0000 0196         delay_ms(50);
	LDI  R26,LOW(50)
	LDI  R27,0
	CALL _delay_ms
; 0000 0197         s++;
	LD   R30,Y
	LDD  R31,Y+1
	ADIW R30,1
	ST   Y,R30
	STD  Y+1,R31
; 0000 0198     }
	RJMP _0xE9
_0xEB:
; 0000 0199     // putchar1('\n');
; 0000 019A 
; 0000 019B }
	JMP  _0x216000E
; .FEND
;
;void refresh(int time_ms) {
; 0000 019D void refresh(int time_ms) {
_refresh:
; .FSTART _refresh
; 0000 019E 
; 0000 019F 
; 0000 01A0     glcd_clear();
	ST   -Y,R27
	ST   -Y,R26
;	time_ms -> Y+0
	CALL SUBOPT_0xF
; 0000 01A1     glcd_moveto(0,0);
; 0000 01A2 
; 0000 01A3     glcd_outtext(buff);
	CALL SUBOPT_0x10
; 0000 01A4 
; 0000 01A5     del_string(buff);
	LDI  R26,LOW(_buff)
	LDI  R27,HIGH(_buff)
	RCALL _del_string
; 0000 01A6 
; 0000 01A7     i = 0;
	CLR  R4
	CLR  R5
; 0000 01A8 
; 0000 01A9     delay_ms(time_ms);
	LD   R26,Y
	LDD  R27,Y+1
	CALL _delay_ms
; 0000 01AA 
; 0000 01AB }
	JMP  _0x216000E
; .FEND
;
;bool wait_until(unsigned char *keyword, int time_out_s) {
; 0000 01AD _Bool wait_until(unsigned char *keyword, int time_out_s) {
_wait_until:
; .FSTART _wait_until
; 0000 01AE     /*     deu biet cai temp2 de lam gi nhung khong co thi no khong chay trong 1 so truong hop @@
; 0000 01AF         Vi du nhap vao "Hell" thi no se tach thua ra them 2 char. Co the do vi tri o nho. Cha biet @@*/
; 0000 01B0     char temp[20], temp2[20];
; 0000 01B1     int i = 0, time_start, time_temp;
; 0000 01B2 
; 0000 01B3     del_string(temp);
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
; 0000 01B4 
; 0000 01B5     while (*keyword) {
_0xEC:
	LDD  R26,Y+48
	LDD  R27,Y+48+1
	LD   R30,X
	CPI  R30,0
	BREQ _0xEE
; 0000 01B6         temp[i] = *keyword;
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
; 0000 01B7         temp2[i] = temp[i];
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
; 0000 01B8         keyword++;
	LDD  R30,Y+48
	LDD  R31,Y+48+1
	ADIW R30,1
	STD  Y+48,R30
	STD  Y+48+1,R31
; 0000 01B9         i++;
	__ADDWRN 16,17,1
; 0000 01BA     }
	RJMP _0xEC
_0xEE:
; 0000 01BB 
; 0000 01BC     time_start = time_s;
	__GETWRMN 18,19,0,_time_s
; 0000 01BD 
; 0000 01BE     while (1) {
_0xEF:
; 0000 01BF         if (time_s < time_start) {
	LDS  R26,_time_s
	LDS  R27,_time_s+1
	CP   R26,R18
	CPC  R27,R19
	BRGE _0xF2
; 0000 01C0             time_temp = time_s + 60;
	LDS  R30,_time_s
	LDS  R31,_time_s+1
	ADIW R30,60
	MOVW R20,R30
; 0000 01C1             if (time_temp - time_start > time_out_s) {
	MOVW R26,R20
	CALL SUBOPT_0x11
	BRLT _0x2160011
; 0000 01C2                 //glcd_outtext("Timed out\r\n");
; 0000 01C3                 return false;
; 0000 01C4                 //break;
; 0000 01C5             }
; 0000 01C6         } else {
	RJMP _0xF4
_0xF2:
; 0000 01C7             if (time_s - time_start > time_out_s) {
	LDS  R26,_time_s
	LDS  R27,_time_s+1
	CALL SUBOPT_0x11
	BRLT _0x2160011
; 0000 01C8                 //glcd_outtext("Timed out\r\n");
; 0000 01C9                 return false;
; 0000 01CA                 //break;
; 0000 01CB             }
; 0000 01CC         }
_0xF4:
; 0000 01CD 
; 0000 01CE         if ((strstr(buff, temp)) || (strstr(buff, temp2))) {
	CALL SUBOPT_0x12
	MOVW R26,R28
	ADIW R26,28
	CALL _strstr
	SBIW R30,0
	BRNE _0xF7
	CALL SUBOPT_0x12
	MOVW R26,R28
	ADIW R26,8
	CALL _strstr
	SBIW R30,0
	BREQ _0xF6
_0xF7:
; 0000 01CF             return true;
	LDI  R30,LOW(1)
	RJMP _0x2160012
; 0000 01D0             //break;
; 0000 01D1         }
; 0000 01D2         if (strstr(buff, "ERROR")) {
_0xF6:
	CALL SUBOPT_0x12
	__POINTW2MN _0xFA,0
	CALL _strstr
	SBIW R30,0
	BRNE _0x2160011
; 0000 01D3             /*glcd_outtext("Error found, attempting to continue..\r\n");
; 0000 01D4             delay_ms(3000);
; 0000 01D5             glcd_clear();
; 0000 01D6             glcd_moveto(0,0);*/
; 0000 01D7             return false;
; 0000 01D8             //break;
; 0000 01D9             //nen lam them ve cai nay nua
; 0000 01DA         }
; 0000 01DB     }
	RJMP _0xEF
; 0000 01DC     return false;
_0x2160011:
	LDI  R30,LOW(0)
_0x2160012:
	CALL __LOADLOCR6
	ADIW R28,50
	RET
; 0000 01DD }
; .FEND

	.DSEG
_0xFA:
	.BYTE 0x6
;
;bool wifi_connect(){
; 0000 01DF _Bool wifi_connect(){

	.CSEG
_wifi_connect:
; .FSTART _wifi_connect
; 0000 01E0     put_string("AT+CWMODE=1\r\n");
	__POINTW2MN _0xFB,0
	RCALL _put_string
; 0000 01E1     if(!wait_until("OK", 2)){
	__POINTW1MN _0xFB,14
	CALL SUBOPT_0x13
	CPI  R30,0
	BRNE _0xFC
; 0000 01E2         glcd_clear();
	CALL SUBOPT_0xF
; 0000 01E3         glcd_moveto(0,0);
; 0000 01E4         glcd_outtext("config fail");
	__POINTW2MN _0xFB,17
	RJMP _0x2160010
; 0000 01E5         return false;
; 0000 01E6     }
; 0000 01E7     refresh(0);
_0xFC:
	CALL SUBOPT_0x14
; 0000 01E8 
; 0000 01E9     put_string("AT+CWJAP=\"Thay_Thao_deo_giai\",\"chinhxac\"\r\n");
	__POINTW2MN _0xFB,29
	RCALL _put_string
; 0000 01EA     if(!wait_until("OK", 10)){
	__POINTW1MN _0xFB,72
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(10)
	LDI  R27,0
	RCALL _wait_until
	CPI  R30,0
	BRNE _0xFD
; 0000 01EB         glcd_clear();
	CALL SUBOPT_0xF
; 0000 01EC         glcd_moveto(0,0);
; 0000 01ED         glcd_outtext("connect fail");
	__POINTW2MN _0xFB,75
_0x2160010:
	CALL _glcd_outtext
; 0000 01EE         return false;
	LDI  R30,LOW(0)
	RET
; 0000 01EF     }
; 0000 01F0     glcd_clear();
_0xFD:
	CALL SUBOPT_0xF
; 0000 01F1     glcd_moveto(0,0);
; 0000 01F2     glcd_outtext("connect wifi success");
	__POINTW2MN _0xFB,88
	CALL _glcd_outtext
; 0000 01F3     delay_ms(1000);
	CALL SUBOPT_0x15
; 0000 01F4     refresh(0);
	CALL SUBOPT_0x14
; 0000 01F5     return true;
	LDI  R30,LOW(1)
	RET
; 0000 01F6 }
; .FEND

	.DSEG
_0xFB:
	.BYTE 0x6D
;
;void read_and_send(unsigned char *s){
; 0000 01F8 void read_and_send(unsigned char *s){

	.CSEG
_read_and_send:
; .FSTART _read_and_send
; 0000 01F9     // Thay nhung ham respones_read bang ham wait_until
; 0000 01FA     char api_key[20], cmd[] = "GET /update?key=", temp[20], temp2[20];
; 0000 01FB     int length = 0, i = 0;
; 0000 01FC 
; 0000 01FD 	while (*s) {
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,63
	SBIW R28,14
	LDI  R24,17
	LDI  R26,LOW(40)
	LDI  R27,HIGH(40)
	LDI  R30,LOW(_0xFE*2)
	LDI  R31,HIGH(_0xFE*2)
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
_0xFF:
	CALL SUBOPT_0x16
	CPI  R30,0
	BREQ _0x101
; 0000 01FE         temp2[i] = *s;
	MOVW R30,R18
	MOVW R26,R28
	ADIW R26,4
	ADD  R30,R26
	ADC  R31,R27
	MOVW R22,R30
	CALL SUBOPT_0x16
	MOVW R26,R22
	ST   X,R30
; 0000 01FF 		api_key[i] = temp2[i];
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
; 0000 0200         s++;
	MOVW R26,R28
	SUBI R26,LOW(-(81))
	SBCI R27,HIGH(-(81))
	CALL SUBOPT_0x17
; 0000 0201         i++;
	__ADDWRN 18,19,1
; 0000 0202     }
	RJMP _0xFF
_0x101:
; 0000 0203 
; 0000 0204 	put_string("AT+CIPMUX=1");
	__POINTW2MN _0x102,0
	CALL SUBOPT_0x18
; 0000 0205 	delay_ms(300);
; 0000 0206 	put_string("\r\n");
	__POINTW2MN _0x102,12
	RCALL _put_string
; 0000 0207     wait_until("OK", 2);
	__POINTW1MN _0x102,15
	CALL SUBOPT_0x13
; 0000 0208     refresh(0);
	CALL SUBOPT_0x14
; 0000 0209 
; 0000 020A     put_string("AT+CIPSTART=0,\"TCP\",\"api.thingspeak.com\",80");
	__POINTW2MN _0x102,18
	CALL SUBOPT_0x18
; 0000 020B 	delay_ms(300);
; 0000 020C 	put_string("\r\n");
	__POINTW2MN _0x102,62
	RCALL _put_string
; 0000 020D     wait_until("OK", 20);
	__POINTW1MN _0x102,65
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(20)
	LDI  R27,0
	RCALL _wait_until
; 0000 020E 	refresh(2000);
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	RCALL _refresh
; 0000 020F 
; 0000 0210 	glcd_clear();
	CALL SUBOPT_0xF
; 0000 0211 	glcd_moveto(0,0);
; 0000 0212 	// glcd_outtext("Server connected");
; 0000 0213 
; 0000 0214     strcat(cmd, temp2);
	CALL SUBOPT_0x19
	MOVW R26,R28
	ADIW R26,6
	CALL SUBOPT_0x1A
; 0000 0215     strcat(cmd, "&field1=");
	__POINTW2MN _0x102,68
	CALL _strcat
; 0000 0216 
; 0000 0217     // itoa(station_receive.temp, cmd);
; 0000 0218 
; 0000 0219     itoa(station_receive.temp, temp);
	__GETW1MN _station_receive,6
	CALL SUBOPT_0x1B
; 0000 021A 	strcat(cmd, temp);
	MOVW R26,R28
	ADIW R26,26
	CALL SUBOPT_0x1A
; 0000 021B 
; 0000 021C     strcat(cmd, "&field2=");
	__POINTW2MN _0x102,77
	CALL _strcat
; 0000 021D     itoa(station_receive.humi, temp);
	__GETW1MN _station_receive,4
	CALL SUBOPT_0x1B
; 0000 021E     //itoa(200, temp);
; 0000 021F 	strcat(cmd, temp);
	MOVW R26,R28
	ADIW R26,26
	CALL SUBOPT_0x1A
; 0000 0220 
; 0000 0221     strcat(cmd, "&field3=");
	__POINTW2MN _0x102,86
	CALL _strcat
; 0000 0222     itoa(station_receive.water, temp);
	__GETW1MN _station_receive,10
	CALL SUBOPT_0x1B
; 0000 0223     //itoa(200, temp);
; 0000 0224 	strcat(cmd, temp);
	MOVW R26,R28
	ADIW R26,26
	CALL _strcat
; 0000 0225 
; 0000 0226 	length = strlen(cmd);
	MOVW R26,R28
	ADIW R26,44
	CALL _strlen
	MOVW R16,R30
; 0000 0227 	length += 2;
	__ADDWRN 16,17,2
; 0000 0228 
; 0000 0229 	itoa(length, temp);
	ST   -Y,R17
	ST   -Y,R16
	MOVW R26,R28
	ADIW R26,26
	CALL _itoa
; 0000 022A 
; 0000 022B 	del_string(buff);
	LDI  R26,LOW(_buff)
	LDI  R27,HIGH(_buff)
	RCALL _del_string
; 0000 022C 
; 0000 022D     put_string("AT+CIPSEND=0,");
	__POINTW2MN _0x102,95
	RCALL _put_string
; 0000 022E     put_string(temp);
	MOVW R26,R28
	ADIW R26,24
	RCALL _put_string
; 0000 022F 	delay_ms(1000);
	CALL SUBOPT_0x15
; 0000 0230     put_string("\r\n");
	__POINTW2MN _0x102,109
	RCALL _put_string
; 0000 0231 
; 0000 0232     wait_until("> ", 5);
	__POINTW1MN _0x102,112
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(5)
	LDI  R27,0
	RCALL _wait_until
; 0000 0233 
; 0000 0234 	glcd_clear();
	CALL SUBOPT_0xF
; 0000 0235 	glcd_moveto(0,0);
; 0000 0236 	glcd_outtext("Sending");
	__POINTW2MN _0x102,115
	CALL _glcd_outtext
; 0000 0237 
; 0000 0238     put_string(cmd);
	MOVW R26,R28
	ADIW R26,44
	RCALL _put_string
; 0000 0239 	put_string("\r\n");
	__POINTW2MN _0x102,123
	RCALL _put_string
; 0000 023A     delay_ms(1000);
	CALL SUBOPT_0x15
; 0000 023B     putchar(0x1A);
	LDI  R26,LOW(26)
	RCALL _putchar
; 0000 023C 
; 0000 023D 	refresh(0);
	CALL SUBOPT_0x14
; 0000 023E 
; 0000 023F 	glcd_outtext("Done");
	__POINTW2MN _0x102,126
	CALL _glcd_outtext
; 0000 0240 }
	CALL __LOADLOCR4
	ADIW R28,63
	ADIW R28,20
	RET
; .FEND

	.DSEG
_0x102:
	.BYTE 0x83
;//====================================================================================================================== ...
;
;
;void main(void)
; 0000 0245 {

	.CSEG
_main:
; .FSTART _main
; 0000 0246 // Declare your local variables here
; 0000 0247 // Variable used to store graphic display
; 0000 0248 // controller initialization data
; 0000 0249 GLCDINIT_t glcd_init_data;
; 0000 024A 
; 0000 024B // Input/Output Ports initialization
; 0000 024C // Port A initialization
; 0000 024D // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 024E DDRA=(0<<DDA7) | (1<<DDA6) | (0<<DDA5) | (1<<DDA4) | (1<<DDA3) | (1<<DDA2) | (1<<DDA1) | (0<<DDA0);
	SBIW R28,8
;	glcd_init_data -> Y+0
	LDI  R30,LOW(94)
	OUT  0x1A,R30
; 0000 024F // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0250 PORTA=(0<<PORTA7) | (0<<PORTA6) | (1<<PORTA5) | (1<<PORTA4) | (1<<PORTA3) | (1<<PORTA2) | (1<<PORTA1) | (1<<PORTA0);
	LDI  R30,LOW(63)
	OUT  0x1B,R30
; 0000 0251 
; 0000 0252 // Port B initialization
; 0000 0253 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0254 DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
	LDI  R30,LOW(0)
	OUT  0x17,R30
; 0000 0255 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0256 PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	OUT  0x18,R30
; 0000 0257 
; 0000 0258 // Port C initialization
; 0000 0259 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 025A DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
	OUT  0x14,R30
; 0000 025B // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 025C PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	OUT  0x15,R30
; 0000 025D 
; 0000 025E // Port D initialization
; 0000 025F // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0260 DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	OUT  0x11,R30
; 0000 0261 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0262 PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	OUT  0x12,R30
; 0000 0263 
; 0000 0264 // Port E initialization
; 0000 0265 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0266 DDRE=(0<<DDE7) | (0<<DDE6) | (0<<DDE5) | (0<<DDE4) | (0<<DDE3) | (0<<DDE2) | (0<<DDE1) | (0<<DDE0);
	OUT  0x2,R30
; 0000 0267 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0268 PORTE=(0<<PORTE7) | (0<<PORTE6) | (0<<PORTE5) | (0<<PORTE4) | (0<<PORTE3) | (0<<PORTE2) | (0<<PORTE1) | (0<<PORTE0);
	OUT  0x3,R30
; 0000 0269 
; 0000 026A // Port F initialization
; 0000 026B // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 026C DDRF=(0<<DDF7) | (0<<DDF6) | (0<<DDF5) | (0<<DDF4) | (0<<DDF3) | (0<<DDF2) | (0<<DDF1) | (0<<DDF0);
	STS  97,R30
; 0000 026D // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 026E PORTF=(0<<PORTF7) | (0<<PORTF6) | (0<<PORTF5) | (0<<PORTF4) | (0<<PORTF3) | (0<<PORTF2) | (0<<PORTF1) | (0<<PORTF0);
	STS  98,R30
; 0000 026F 
; 0000 0270 // Port G initialization
; 0000 0271 // Function: Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0272 DDRG=(0<<DDG4) | (0<<DDG3) | (0<<DDG2) | (0<<DDG1) | (0<<DDG0);
	STS  100,R30
; 0000 0273 // State: Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0274 PORTG=(0<<PORTG4) | (0<<PORTG3) | (0<<PORTG2) | (0<<PORTG1) | (0<<PORTG0);
	STS  101,R30
; 0000 0275 
; 0000 0276 // Timer/Counter 0 initialization
; 0000 0277 // Clock source: System Clock
; 0000 0278 // Clock value: 250.000 kHz
; 0000 0279 // Mode: Normal top=0xFF
; 0000 027A // OC0 output: Disconnected
; 0000 027B // Timer Period: 0.5 ms
; 0000 027C ASSR=0<<AS0;
	OUT  0x30,R30
; 0000 027D TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (1<<CS01) | (1<<CS00);
	LDI  R30,LOW(3)
	OUT  0x33,R30
; 0000 027E TCNT0=0x83;
	LDI  R30,LOW(131)
	OUT  0x32,R30
; 0000 027F OCR0=0x00;
	LDI  R30,LOW(0)
	OUT  0x31,R30
; 0000 0280 
; 0000 0281 // Timer/Counter 1 initialization
; 0000 0282 // Clock source: System Clock
; 0000 0283 // Clock value: Timer1 Stopped
; 0000 0284 // Mode: Normal top=0xFFFF
; 0000 0285 // OC1A output: Disconnected
; 0000 0286 // OC1B output: Disconnected
; 0000 0287 // OC1C output: Disconnected
; 0000 0288 // Noise Canceler: Off
; 0000 0289 // Input Capture on Falling Edge
; 0000 028A // Timer1 Overflow Interrupt: Off
; 0000 028B // Input Capture Interrupt: Off
; 0000 028C // Compare A Match Interrupt: Off
; 0000 028D // Compare B Match Interrupt: Off
; 0000 028E // Compare C Match Interrupt: Off
; 0000 028F TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<COM1C1) | (0<<COM1C0) | (0<<WGM11) | (0<<WGM10);
	OUT  0x2F,R30
; 0000 0290 TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
	OUT  0x2E,R30
; 0000 0291 TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 0292 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 0293 ICR1H=0x00;
	OUT  0x27,R30
; 0000 0294 ICR1L=0x00;
	OUT  0x26,R30
; 0000 0295 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0296 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0297 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0298 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0299 OCR1CH=0x00;
	STS  121,R30
; 0000 029A OCR1CL=0x00;
	STS  120,R30
; 0000 029B 
; 0000 029C // Timer/Counter 2 initialization
; 0000 029D // Clock source: System Clock
; 0000 029E // Clock value: Timer2 Stopped
; 0000 029F // Mode: Normal top=0xFF
; 0000 02A0 // OC2 output: Disconnected
; 0000 02A1 TCCR2=(0<<WGM20) | (0<<COM21) | (0<<COM20) | (0<<WGM21) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	OUT  0x25,R30
; 0000 02A2 TCNT2=0x00;
	OUT  0x24,R30
; 0000 02A3 OCR2=0x00;
	OUT  0x23,R30
; 0000 02A4 
; 0000 02A5 // Timer/Counter 3 initialization
; 0000 02A6 // Clock source: System Clock
; 0000 02A7 // Clock value: Timer3 Stopped
; 0000 02A8 // Mode: Normal top=0xFFFF
; 0000 02A9 // OC3A output: Disconnected
; 0000 02AA // OC3B output: Disconnected
; 0000 02AB // OC3C output: Disconnected
; 0000 02AC // Noise Canceler: Off
; 0000 02AD // Input Capture on Falling Edge
; 0000 02AE // Timer3 Overflow Interrupt: Off
; 0000 02AF // Input Capture Interrupt: Off
; 0000 02B0 // Compare A Match Interrupt: Off
; 0000 02B1 // Compare B Match Interrupt: Off
; 0000 02B2 // Compare C Match Interrupt: Off
; 0000 02B3 TCCR3A=(0<<COM3A1) | (0<<COM3A0) | (0<<COM3B1) | (0<<COM3B0) | (0<<COM3C1) | (0<<COM3C0) | (0<<WGM31) | (0<<WGM30);
	STS  139,R30
; 0000 02B4 TCCR3B=(0<<ICNC3) | (0<<ICES3) | (0<<WGM33) | (0<<WGM32) | (0<<CS32) | (0<<CS31) | (0<<CS30);
	STS  138,R30
; 0000 02B5 TCNT3H=0x00;
	STS  137,R30
; 0000 02B6 TCNT3L=0x00;
	STS  136,R30
; 0000 02B7 ICR3H=0x00;
	STS  129,R30
; 0000 02B8 ICR3L=0x00;
	STS  128,R30
; 0000 02B9 OCR3AH=0x00;
	STS  135,R30
; 0000 02BA OCR3AL=0x00;
	STS  134,R30
; 0000 02BB OCR3BH=0x00;
	STS  133,R30
; 0000 02BC OCR3BL=0x00;
	STS  132,R30
; 0000 02BD OCR3CH=0x00;
	STS  131,R30
; 0000 02BE OCR3CL=0x00;
	STS  130,R30
; 0000 02BF 
; 0000 02C0 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 02C1 TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (1<<TOIE0);
	LDI  R30,LOW(1)
	OUT  0x37,R30
; 0000 02C2 ETIMSK=(0<<TICIE3) | (0<<OCIE3A) | (0<<OCIE3B) | (0<<TOIE3) | (0<<OCIE3C) | (0<<OCIE1C);
	LDI  R30,LOW(0)
	STS  125,R30
; 0000 02C3 
; 0000 02C4 // External Interrupt(s) initialization
; 0000 02C5 // INT0: Off
; 0000 02C6 // INT1: Off
; 0000 02C7 // INT2: Off
; 0000 02C8 // INT3: Off
; 0000 02C9 // INT4: Off
; 0000 02CA // INT5: Off
; 0000 02CB // INT6: Off
; 0000 02CC // INT7: Off
; 0000 02CD EICRA=(0<<ISC31) | (0<<ISC30) | (0<<ISC21) | (0<<ISC20) | (0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	STS  106,R30
; 0000 02CE EICRB=(0<<ISC71) | (0<<ISC70) | (0<<ISC61) | (0<<ISC60) | (0<<ISC51) | (0<<ISC50) | (0<<ISC41) | (0<<ISC40);
	OUT  0x3A,R30
; 0000 02CF EIMSK=(0<<INT7) | (0<<INT6) | (0<<INT5) | (0<<INT4) | (0<<INT3) | (0<<INT2) | (0<<INT1) | (0<<INT0);
	OUT  0x39,R30
; 0000 02D0 
; 0000 02D1 // USART0 initialization
; 0000 02D2 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 02D3 // USART0 Receiver: On
; 0000 02D4 // USART0 Transmitter: On
; 0000 02D5 // USART0 Mode: Asynchronous
; 0000 02D6 // USART0 Baud Rate: 9600
; 0000 02D7 UCSR0A=(0<<RXC0) | (0<<TXC0) | (0<<UDRE0) | (0<<FE0) | (0<<DOR0) | (0<<UPE0) | (0<<U2X0) | (0<<MPCM0);
	OUT  0xB,R30
; 0000 02D8 UCSR0B=(1<<RXCIE0) | (1<<TXCIE0) | (0<<UDRIE0) | (1<<RXEN0) | (1<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);
	LDI  R30,LOW(216)
	OUT  0xA,R30
; 0000 02D9 UCSR0C=(0<<UMSEL0) | (0<<UPM01) | (0<<UPM00) | (0<<USBS0) | (1<<UCSZ01) | (1<<UCSZ00) | (0<<UCPOL0);
	LDI  R30,LOW(6)
	STS  149,R30
; 0000 02DA UBRR0H=0x00;
	LDI  R30,LOW(0)
	STS  144,R30
; 0000 02DB UBRR0L=0x33;
	LDI  R30,LOW(51)
	OUT  0x9,R30
; 0000 02DC 
; 0000 02DD // USART1 initialization
; 0000 02DE // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 02DF // USART1 Receiver: On
; 0000 02E0 // USART1 Transmitter: On
; 0000 02E1 // USART1 Mode: Asynchronous
; 0000 02E2 // USART1 Baud Rate: 9600
; 0000 02E3 UCSR1A=(0<<RXC1) | (0<<TXC1) | (0<<UDRE1) | (0<<FE1) | (0<<DOR1) | (0<<UPE1) | (0<<U2X1) | (0<<MPCM1);
	LDI  R30,LOW(0)
	STS  155,R30
; 0000 02E4 UCSR1B=(1<<RXCIE1) | (1<<TXCIE1) | (0<<UDRIE1) | (1<<RXEN1) | (1<<TXEN1) | (0<<UCSZ12) | (0<<RXB81) | (0<<TXB81);
	LDI  R30,LOW(216)
	STS  154,R30
; 0000 02E5 UCSR1C=(0<<UMSEL1) | (0<<UPM11) | (0<<UPM10) | (0<<USBS1) | (1<<UCSZ11) | (1<<UCSZ10) | (0<<UCPOL1);
	LDI  R30,LOW(6)
	STS  157,R30
; 0000 02E6 UBRR1H=0x00;
	LDI  R30,LOW(0)
	STS  152,R30
; 0000 02E7 UBRR1L=0x33;
	LDI  R30,LOW(51)
	STS  153,R30
; 0000 02E8 
; 0000 02E9 // Analog Comparator initialization
; 0000 02EA // Analog Comparator: Off
; 0000 02EB // The Analog Comparator's positive input is
; 0000 02EC // connected to the AIN0 pin
; 0000 02ED // The Analog Comparator's negative input is
; 0000 02EE // connected to the AIN1 pin
; 0000 02EF ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 02F0 SFIOR=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 02F1 
; 0000 02F2 // ADC initialization
; 0000 02F3 // ADC disabled
; 0000 02F4 ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADFR) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
	OUT  0x6,R30
; 0000 02F5 
; 0000 02F6 // SPI initialization
; 0000 02F7 // SPI disabled
; 0000 02F8 SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0000 02F9 
; 0000 02FA // TWI initialization
; 0000 02FB // TWI disabled
; 0000 02FC TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	STS  116,R30
; 0000 02FD 
; 0000 02FE // Bit-Banged I2C Bus initialization
; 0000 02FF // I2C Port: PORTD
; 0000 0300 // I2C SDA bit: 1
; 0000 0301 // I2C SCL bit: 0
; 0000 0302 // Bit Rate: 100 kHz
; 0000 0303 // Note: I2C settings are specified in the
; 0000 0304 // Project|Configure|C Compiler|Libraries|I2C menu.
; 0000 0305 i2c_init();
	CALL _i2c_init
; 0000 0306 
; 0000 0307 // DS1307 Real Time Clock initialization
; 0000 0308 // Square wave output on pin SQW/OUT: On
; 0000 0309 // Square wave frequency: 32768Hz
; 0000 030A rtc_init(3,1,0);
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _rtc_init
; 0000 030B 
; 0000 030C // Graphic Display Controller initialization
; 0000 030D // The PCD8544 connections are specified in the
; 0000 030E // Project|Configure|C Compiler|Libraries|Graphic Display menu:
; 0000 030F // SDIN - PORTC Bit 7
; 0000 0310 // SCLK - PORTA Bit 7
; 0000 0311 // D /C - PORTC Bit 6
; 0000 0312 // /SCE - PORTC Bit 5
; 0000 0313 // /RES - PORTC Bit 4
; 0000 0314 
; 0000 0315 // Specify the current font for displaying text
; 0000 0316 glcd_init_data.font=font5x7;
	LDI  R30,LOW(_font5x7*2)
	LDI  R31,HIGH(_font5x7*2)
	ST   Y,R30
	STD  Y+1,R31
; 0000 0317 // No function is used for reading
; 0000 0318 // image data from external memory
; 0000 0319 glcd_init_data.readxmem=NULL;
	LDI  R30,LOW(0)
	STD  Y+2,R30
	STD  Y+2+1,R30
; 0000 031A // No function is used for writing
; 0000 031B // image data to external memory
; 0000 031C glcd_init_data.writexmem=NULL;
	STD  Y+4,R30
	STD  Y+4+1,R30
; 0000 031D // Set the LCD temperature coefficient
; 0000 031E glcd_init_data.temp_coef=80;
	LDD  R30,Y+6
	ANDI R30,LOW(0xFC)
	STD  Y+6,R30
; 0000 031F // Set the LCD bias
; 0000 0320 glcd_init_data.bias=3;
	ANDI R30,LOW(0xE3)
	ORI  R30,LOW(0xC)
	STD  Y+6,R30
; 0000 0321 // Set the LCD contrast control voltage VLCD
; 0000 0322 glcd_init_data.vlcd=56;
	LDD  R30,Y+7
	ANDI R30,LOW(0x80)
	ORI  R30,LOW(0x38)
	STD  Y+7,R30
; 0000 0323 
; 0000 0324 glcd_init(&glcd_init_data);
	MOVW R26,R28
	RCALL _glcd_init
; 0000 0325 
; 0000 0326 // Global enable interrupts
; 0000 0327 #asm("sei")
	sei
; 0000 0328 glcd_moveto(0,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	CALL _glcd_moveto
; 0000 0329 glcd_outtext("aaaa");
	__POINTW2MN _0x103,0
	CALL _glcd_outtext
; 0000 032A while(!wifi_connect());
_0x104:
	RCALL _wifi_connect
	CPI  R30,0
	BREQ _0x104
; 0000 032B 
; 0000 032C RF_Init_RX();
	RCALL _RF_Init_RX
; 0000 032D config();
	RCALL _config
; 0000 032E RF_Config_RX();
	RCALL _RF_Config_RX
; 0000 032F count = 1;
	CALL SUBOPT_0xE
; 0000 0330 
; 0000 0331 while (1){
_0x107:
; 0000 0332     RF_Mode_RX();
	RCALL _RF_Mode_RX
; 0000 0333 
; 0000 0334     if(IRQ == 0){
	SBIC 0x19,0
	RJMP _0x10A
; 0000 0335         RF_Read_RX_3();
	RCALL _RF_Read_RX_3
; 0000 0336 
; 0000 0337 
; 0000 0338 
; 0000 0339         if(station_receive.flag == count){
	LDS  R30,_count
	LDS  R31,_count+1
	LDS  R26,_station_receive
	LDS  R27,_station_receive+1
	CP   R30,R26
	CPC  R31,R27
	BREQ PC+2
	RJMP _0x10B
; 0000 033A             print_border();
	RCALL _print_border
; 0000 033B             glcd_moveto(40, 3);
	LDI  R30,LOW(40)
	ST   -Y,R30
	LDI  R26,LOW(3)
	CALL _glcd_moveto
; 0000 033C             itoa(station_receive.flag, buff);
	LDS  R30,_station_receive
	LDS  R31,_station_receive+1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_buff)
	LDI  R27,HIGH(_buff)
	CALL _itoa
; 0000 033D             glcd_outtext(buff);
	CALL SUBOPT_0x10
; 0000 033E             glcd_moveto(46, 18);
	LDI  R30,LOW(46)
	ST   -Y,R30
	LDI  R26,LOW(18)
	CALL SUBOPT_0x1C
; 0000 033F             sprintf(buff, "%d ", station_receive.temp);
	__POINTW1FN _0x0,263
	ST   -Y,R31
	ST   -Y,R30
	__GETW1MN _station_receive,6
	CALL SUBOPT_0x1D
; 0000 0340             glcd_outtext(buff);
; 0000 0341             glcd_moveto(46, 28);
	LDI  R30,LOW(46)
	ST   -Y,R30
	LDI  R26,LOW(28)
	CALL SUBOPT_0x1C
; 0000 0342             sprintf(buff, "%d ", station_receive.humi);
	__POINTW1FN _0x0,263
	ST   -Y,R31
	ST   -Y,R30
	__GETW1MN _station_receive,4
	CALL SUBOPT_0x1D
; 0000 0343             glcd_outtext(buff);
; 0000 0344             glcd_moveto(46, 37);
	LDI  R30,LOW(46)
	ST   -Y,R30
	LDI  R26,LOW(37)
	CALL SUBOPT_0x1C
; 0000 0345             sprintf(buff, "%d  ", station_receive.water);
	__POINTW1FN _0x0,267
	ST   -Y,R31
	ST   -Y,R30
	__GETW1MN _station_receive,10
	CALL SUBOPT_0x1D
; 0000 0346             glcd_outtext(buff);
; 0000 0347             read_and_send("6ZF1YB8AXISBSA2P");
	__POINTW2MN _0x103,5
	RCALL _read_and_send
; 0000 0348             delay_ms(100);
	LDI  R26,LOW(100)
	LDI  R27,0
	CALL _delay_ms
; 0000 0349             glcd_clear();
	RCALL _glcd_clear
; 0000 034A 			count++;
	CALL SUBOPT_0xD
; 0000 034B 			if(count == 5)
	LDS  R26,_count
	LDS  R27,_count+1
	SBIW R26,5
	BRNE _0x10C
; 0000 034C                 count = 1;
	CALL SUBOPT_0xE
; 0000 034D             flag = true;
_0x10C:
	LDI  R30,LOW(1)
	STS  _flag,R30
; 0000 034E 
; 0000 034F         }
; 0000 0350     }
_0x10B:
; 0000 0351 }
_0x10A:
	RJMP _0x107
; 0000 0352 
; 0000 0353 }
_0x10D:
	RJMP _0x10D
; .FEND

	.DSEG
_0x103:
	.BYTE 0x16
;

	.CSEG
_rtc_init:
; .FSTART _rtc_init
	ST   -Y,R26
	LDD  R30,Y+2
	ANDI R30,LOW(0x3)
	STD  Y+2,R30
	LDD  R30,Y+1
	CPI  R30,0
	BREQ _0x2000003
	LDD  R30,Y+2
	ORI  R30,0x10
	STD  Y+2,R30
_0x2000003:
	LD   R30,Y
	CPI  R30,0
	BREQ _0x2000004
	LDD  R30,Y+2
	ORI  R30,0x80
	STD  Y+2,R30
_0x2000004:
	CALL _i2c_start
	LDI  R26,LOW(208)
	CALL _i2c_write
	LDI  R26,LOW(7)
	CALL _i2c_write
	LDD  R26,Y+2
	CALL _i2c_write
	CALL _i2c_stop
	RJMP _0x216000F
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
_pcd8544_delay_G101:
; .FSTART _pcd8544_delay_G101
	RET
; .FEND
_pcd8544_wrbus_G101:
; .FSTART _pcd8544_wrbus_G101
	ST   -Y,R26
	ST   -Y,R17
	CBI  0x15,5
	LDI  R17,LOW(8)
_0x2020004:
	RCALL _pcd8544_delay_G101
	LDD  R30,Y+1
	ANDI R30,LOW(0x80)
	BREQ _0x2020006
	SBI  0x15,7
	RJMP _0x2020007
_0x2020006:
	CBI  0x15,7
_0x2020007:
	LDD  R30,Y+1
	LSL  R30
	STD  Y+1,R30
	RCALL _pcd8544_delay_G101
	SBI  0x1B,7
	RCALL _pcd8544_delay_G101
	CBI  0x1B,7
	SUBI R17,LOW(1)
	BRNE _0x2020004
	SBI  0x15,5
	LDD  R17,Y+0
	RJMP _0x216000E
; .FEND
_pcd8544_wrcmd:
; .FSTART _pcd8544_wrcmd
	ST   -Y,R26
	CBI  0x15,6
	LD   R26,Y
	RCALL _pcd8544_wrbus_G101
	RJMP _0x216000D
; .FEND
_pcd8544_wrdata_G101:
; .FSTART _pcd8544_wrdata_G101
	ST   -Y,R26
	SBI  0x15,6
	LD   R26,Y
	RCALL _pcd8544_wrbus_G101
	RJMP _0x216000D
; .FEND
_pcd8544_setaddr_G101:
; .FSTART _pcd8544_setaddr_G101
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
	STS  _gfx_addr_G101,R30
	STS  _gfx_addr_G101+1,R31
	MOV  R30,R17
	LDD  R17,Y+0
_0x216000F:
	ADIW R28,3
	RET
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
	RCALL _pcd8544_setaddr_G101
	ORI  R30,0x40
	MOV  R26,R30
	RCALL _pcd8544_wrcmd
	RJMP _0x216000E
; .FEND
_pcd8544_rdbyte:
; .FSTART _pcd8544_rdbyte
	ST   -Y,R26
	LDD  R30,Y+1
	ST   -Y,R30
	LDD  R26,Y+1
	RCALL _pcd8544_gotoxy
	LDS  R30,_gfx_addr_G101
	LDS  R31,_gfx_addr_G101+1
	SUBI R30,LOW(-_gfx_buffer_G101)
	SBCI R31,HIGH(-_gfx_buffer_G101)
	LD   R30,Z
_0x216000E:
	ADIW R28,2
	RET
; .FEND
_pcd8544_wrbyte:
; .FSTART _pcd8544_wrbyte
	ST   -Y,R26
	CALL SUBOPT_0x1E
	SBIW R30,1
	SUBI R30,LOW(-_gfx_buffer_G101)
	SBCI R31,HIGH(-_gfx_buffer_G101)
	LD   R26,Y
	STD  Z+0,R26
	RCALL _pcd8544_wrdata_G101
	RJMP _0x216000D
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
	BREQ _0x2020008
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
	RJMP _0x20200A0
_0x2020008:
	LDI  R17,LOW(0)
	LDI  R16,LOW(3)
	LDI  R19,LOW(50)
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	__PUTW1MN _glcd_state,4
	__PUTW1MN _glcd_state,25
_0x20200A0:
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
	RJMP _0x216000A
; .FEND
_glcd_display:
; .FSTART _glcd_display
	ST   -Y,R26
	LD   R30,Y
	CPI  R30,0
	BREQ _0x202000A
	LDI  R30,LOW(12)
	RJMP _0x202000B
_0x202000A:
	LDI  R30,LOW(8)
_0x202000B:
	MOV  R26,R30
	RCALL _pcd8544_wrcmd
_0x216000D:
	ADIW R28,1
	RET
; .FEND
_glcd_clear:
; .FSTART _glcd_clear
	CALL __SAVELOCR4
	LDI  R19,0
	__GETB1MN _glcd_state,1
	CPI  R30,0
	BREQ _0x202000D
	LDI  R19,LOW(255)
_0x202000D:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _pcd8544_gotoxy
	__GETWRN 16,17,504
_0x202000E:
	MOVW R30,R16
	__SUBWRN 16,17,1
	SBIW R30,0
	BREQ _0x2020010
	MOV  R26,R19
	RCALL _pcd8544_wrbyte
	RJMP _0x202000E
_0x2020010:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _glcd_moveto
	CALL __LOADLOCR4
_0x216000C:
	ADIW R28,4
	RET
; .FEND
_glcd_putpixel:
; .FSTART _glcd_putpixel
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+4
	CPI  R26,LOW(0x54)
	BRSH _0x2020012
	LDD  R26,Y+3
	CPI  R26,LOW(0x30)
	BRLO _0x2020011
_0x2020012:
	RJMP _0x216000B
_0x2020011:
	LDD  R30,Y+4
	ST   -Y,R30
	LDD  R26,Y+4
	RCALL _pcd8544_rdbyte
	MOV  R17,R30
	LDD  R30,Y+3
	ANDI R30,LOW(0x7)
	LDI  R26,LOW(1)
	CALL __LSLB12
	MOV  R16,R30
	LDD  R30,Y+2
	CPI  R30,0
	BREQ _0x2020014
	OR   R17,R16
	RJMP _0x2020015
_0x2020014:
	MOV  R30,R16
	COM  R30
	AND  R17,R30
_0x2020015:
	MOV  R26,R17
	RCALL _pcd8544_wrbyte
_0x216000B:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,5
	RET
; .FEND
_pcd8544_wrmasked_G101:
; .FSTART _pcd8544_wrmasked_G101
	ST   -Y,R26
	ST   -Y,R17
	LDD  R30,Y+5
	ST   -Y,R30
	LDD  R26,Y+5
	RCALL _pcd8544_rdbyte
	MOV  R17,R30
	LDD  R30,Y+1
	CPI  R30,LOW(0x7)
	BREQ _0x2020020
	CPI  R30,LOW(0x8)
	BRNE _0x2020021
_0x2020020:
	LDD  R30,Y+3
	ST   -Y,R30
	LDD  R26,Y+2
	CALL _glcd_mappixcolor1bit
	STD  Y+3,R30
	RJMP _0x2020022
_0x2020021:
	CPI  R30,LOW(0x3)
	BRNE _0x2020024
	LDD  R30,Y+3
	COM  R30
	STD  Y+3,R30
	RJMP _0x2020025
_0x2020024:
	CPI  R30,0
	BRNE _0x2020026
_0x2020025:
_0x2020022:
	LDD  R30,Y+2
	COM  R30
	AND  R17,R30
	RJMP _0x2020027
_0x2020026:
	CPI  R30,LOW(0x2)
	BRNE _0x2020028
_0x2020027:
	LDD  R30,Y+2
	LDD  R26,Y+3
	AND  R30,R26
	OR   R17,R30
	RJMP _0x202001E
_0x2020028:
	CPI  R30,LOW(0x1)
	BRNE _0x2020029
	LDD  R30,Y+2
	LDD  R26,Y+3
	AND  R30,R26
	EOR  R17,R30
	RJMP _0x202001E
_0x2020029:
	CPI  R30,LOW(0x4)
	BRNE _0x202001E
	LDD  R30,Y+2
	COM  R30
	LDD  R26,Y+3
	OR   R30,R26
	AND  R17,R30
_0x202001E:
	MOV  R26,R17
	RCALL _pcd8544_wrbyte
	LDD  R17,Y+0
_0x216000A:
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
	BRSH _0x202002C
	LDD  R26,Y+15
	CPI  R26,LOW(0x30)
	BRSH _0x202002C
	LDD  R26,Y+14
	CPI  R26,LOW(0x0)
	BREQ _0x202002C
	LDD  R26,Y+13
	CPI  R26,LOW(0x0)
	BRNE _0x202002B
_0x202002C:
	RJMP _0x2160009
_0x202002B:
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
	BRLO _0x202002E
	LDD  R26,Y+16
	LDI  R30,LOW(84)
	SUB  R30,R26
	STD  Y+14,R30
_0x202002E:
	LDD  R18,Y+13
	LDD  R26,Y+15
	CLR  R27
	LDD  R30,Y+13
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	SBIW R26,49
	BRLO _0x202002F
	LDD  R26,Y+15
	LDI  R30,LOW(48)
	SUB  R30,R26
	STD  Y+13,R30
_0x202002F:
	LDD  R26,Y+9
	CPI  R26,LOW(0x6)
	BREQ PC+2
	RJMP _0x2020030
	LDD  R30,Y+12
	CPI  R30,LOW(0x1)
	BRNE _0x2020034
	RJMP _0x2160009
_0x2020034:
	CPI  R30,LOW(0x3)
	BRNE _0x2020037
	__GETW1MN _glcd_state,27
	SBIW R30,0
	BRNE _0x2020036
	RJMP _0x2160009
_0x2020036:
_0x2020037:
	LDD  R16,Y+8
	LDD  R30,Y+13
	LSR  R30
	LSR  R30
	LSR  R30
	MOV  R19,R30
	MOV  R30,R18
	ANDI R30,LOW(0x7)
	BRNE _0x2020039
	LDD  R26,Y+13
	CP   R18,R26
	BREQ _0x2020038
_0x2020039:
	MOV  R26,R16
	CLR  R27
	MOV  R30,R19
	LDI  R31,0
	CALL __MULW12U
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CALL SUBOPT_0x1F
	LSR  R18
	LSR  R18
	LSR  R18
	MOV  R21,R19
_0x202003B:
	PUSH R21
	SUBI R21,-1
	MOV  R30,R18
	POP  R26
	CP   R30,R26
	BRLO _0x202003D
	MOV  R17,R16
_0x202003E:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x2020040
	CALL SUBOPT_0x20
	RJMP _0x202003E
_0x2020040:
	RJMP _0x202003B
_0x202003D:
_0x2020038:
	LDD  R26,Y+14
	CP   R16,R26
	BREQ _0x2020041
	LDD  R30,Y+14
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	LDI  R31,0
	CALL SUBOPT_0x1F
	LDD  R30,Y+13
	ANDI R30,LOW(0x7)
	BREQ _0x2020042
	SUBI R19,-LOW(1)
_0x2020042:
	LDI  R18,LOW(0)
_0x2020043:
	PUSH R18
	SUBI R18,-1
	MOV  R30,R19
	POP  R26
	CP   R26,R30
	BRSH _0x2020045
	LDD  R17,Y+14
_0x2020046:
	PUSH R17
	SUBI R17,-1
	MOV  R30,R16
	POP  R26
	CP   R26,R30
	BRSH _0x2020048
	CALL SUBOPT_0x20
	RJMP _0x2020046
_0x2020048:
	LDD  R30,Y+14
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R31,0
	CALL SUBOPT_0x1F
	RJMP _0x2020043
_0x2020045:
_0x2020041:
_0x2020030:
	LDD  R30,Y+15
	ANDI R30,LOW(0x7)
	MOV  R19,R30
_0x2020049:
	LDD  R30,Y+13
	CPI  R30,0
	BRNE PC+2
	RJMP _0x202004B
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(0)
	LDD  R16,Y+16
	CPI  R19,0
	BREQ PC+2
	RJMP _0x202004C
	LDD  R26,Y+13
	CPI  R26,LOW(0x8)
	BRSH PC+2
	RJMP _0x202004D
	LDD  R30,Y+9
	CPI  R30,0
	BREQ _0x2020052
	CPI  R30,LOW(0x3)
	BRNE _0x2020053
_0x2020052:
	RJMP _0x2020054
_0x2020053:
	CPI  R30,LOW(0x7)
	BRNE _0x2020055
_0x2020054:
	RJMP _0x2020056
_0x2020055:
	CPI  R30,LOW(0x8)
	BRNE _0x2020057
_0x2020056:
	RJMP _0x2020058
_0x2020057:
	CPI  R30,LOW(0x9)
	BRNE _0x2020059
_0x2020058:
	RJMP _0x202005A
_0x2020059:
	CPI  R30,LOW(0xA)
	BRNE _0x202005B
_0x202005A:
	ST   -Y,R16
	LDD  R26,Y+16
	RCALL _pcd8544_gotoxy
	RJMP _0x2020050
_0x202005B:
	CPI  R30,LOW(0x6)
	BRNE _0x2020050
	CALL SUBOPT_0x21
_0x2020050:
_0x202005D:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x202005F
	LDD  R26,Y+9
	CPI  R26,LOW(0x6)
	BRNE _0x2020060
	CALL SUBOPT_0x22
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x1E
	SBIW R30,1
	SUBI R30,LOW(-_gfx_buffer_G101)
	SBCI R31,HIGH(-_gfx_buffer_G101)
	LD   R26,Z
	CALL _glcd_writemem
	RJMP _0x2020061
_0x2020060:
	LDD  R30,Y+9
	CPI  R30,LOW(0x9)
	BRNE _0x2020065
	LDI  R21,LOW(0)
	RJMP _0x2020066
_0x2020065:
	CPI  R30,LOW(0xA)
	BRNE _0x2020064
	LDI  R21,LOW(255)
	RJMP _0x2020066
_0x2020064:
	CALL SUBOPT_0x22
	CALL SUBOPT_0x23
	MOV  R21,R30
	LDD  R30,Y+9
	CPI  R30,LOW(0x7)
	BREQ _0x202006D
	CPI  R30,LOW(0x8)
	BRNE _0x202006E
_0x202006D:
_0x2020066:
	CALL SUBOPT_0x24
	MOV  R21,R30
	RJMP _0x202006F
_0x202006E:
	CPI  R30,LOW(0x3)
	BRNE _0x2020071
	COM  R21
	RJMP _0x2020072
_0x2020071:
	CPI  R30,0
	BRNE _0x2020074
_0x2020072:
_0x202006F:
	MOV  R26,R21
	RCALL _pcd8544_wrdata_G101
	RJMP _0x202006B
_0x2020074:
	CALL SUBOPT_0x25
	LDI  R30,LOW(255)
	ST   -Y,R30
	LDD  R26,Y+13
	RCALL _pcd8544_wrmasked_G101
_0x202006B:
_0x2020061:
	RJMP _0x202005D
_0x202005F:
	LDD  R30,Y+15
	SUBI R30,-LOW(8)
	STD  Y+15,R30
	LDD  R30,Y+13
	SUBI R30,LOW(8)
	STD  Y+13,R30
	RJMP _0x2020075
_0x202004D:
	LDD  R21,Y+13
	LDI  R18,LOW(0)
	LDI  R30,LOW(0)
	STD  Y+13,R30
	RJMP _0x2020076
_0x202004C:
	MOV  R30,R19
	LDD  R26,Y+13
	ADD  R26,R30
	CPI  R26,LOW(0x9)
	BRSH _0x2020077
	LDD  R18,Y+13
	LDI  R30,LOW(0)
	STD  Y+13,R30
	RJMP _0x2020078
_0x2020077:
	LDI  R30,LOW(8)
	SUB  R30,R19
	MOV  R18,R30
_0x2020078:
	ST   -Y,R19
	MOV  R26,R18
	CALL _glcd_getmask
	MOV  R20,R30
	LDD  R30,Y+9
	CPI  R30,LOW(0x6)
	BRNE _0x202007C
	CALL SUBOPT_0x21
_0x202007D:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x202007F
	CALL SUBOPT_0x1E
	SBIW R30,1
	SUBI R30,LOW(-_gfx_buffer_G101)
	SBCI R31,HIGH(-_gfx_buffer_G101)
	LD   R30,Z
	AND  R30,R20
	MOV  R26,R30
	MOV  R30,R19
	CALL __LSRB12
	CALL SUBOPT_0x26
	MOV  R30,R19
	MOV  R26,R20
	CALL __LSRB12
	COM  R30
	AND  R30,R1
	OR   R21,R30
	CALL SUBOPT_0x22
	ST   -Y,R31
	ST   -Y,R30
	MOV  R26,R21
	CALL _glcd_writemem
	RJMP _0x202007D
_0x202007F:
	RJMP _0x202007B
_0x202007C:
	CPI  R30,LOW(0x9)
	BRNE _0x2020080
	LDI  R21,LOW(0)
	RJMP _0x2020081
_0x2020080:
	CPI  R30,LOW(0xA)
	BRNE _0x2020087
	LDI  R21,LOW(255)
_0x2020081:
	CALL SUBOPT_0x24
	MOV  R26,R30
	MOV  R30,R19
	CALL __LSLB12
	MOV  R21,R30
_0x2020084:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x2020086
	CALL SUBOPT_0x25
	ST   -Y,R20
	LDI  R26,LOW(0)
	RCALL _pcd8544_wrmasked_G101
	RJMP _0x2020084
_0x2020086:
	RJMP _0x202007B
_0x2020087:
_0x2020088:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x202008A
	CALL SUBOPT_0x27
	MOV  R26,R30
	MOV  R30,R19
	CALL __LSLB12
	ST   -Y,R30
	ST   -Y,R20
	LDD  R26,Y+13
	RCALL _pcd8544_wrmasked_G101
	RJMP _0x2020088
_0x202008A:
_0x202007B:
	LDD  R30,Y+13
	CPI  R30,0
	BRNE _0x202008B
	RJMP _0x202004B
_0x202008B:
	LDD  R26,Y+13
	CPI  R26,LOW(0x8)
	BRSH _0x202008C
	LDD  R30,Y+13
	SUB  R30,R18
	MOV  R21,R30
	LDI  R30,LOW(0)
	RJMP _0x20200A1
_0x202008C:
	MOV  R21,R19
	LDD  R30,Y+13
	SUBI R30,LOW(8)
_0x20200A1:
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
_0x2020076:
	MOV  R30,R21
	LDI  R31,0
	SUBI R30,LOW(-__glcd_mask*2)
	SBCI R31,HIGH(-__glcd_mask*2)
	LPM  R20,Z
	LDD  R30,Y+9
	CPI  R30,LOW(0x6)
	BRNE _0x2020091
	CALL SUBOPT_0x21
_0x2020092:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x2020094
	CALL SUBOPT_0x1E
	SBIW R30,1
	SUBI R30,LOW(-_gfx_buffer_G101)
	SBCI R31,HIGH(-_gfx_buffer_G101)
	LD   R30,Z
	AND  R30,R20
	MOV  R26,R30
	MOV  R30,R18
	CALL __LSLB12
	CALL SUBOPT_0x26
	MOV  R30,R18
	MOV  R26,R20
	CALL __LSLB12
	COM  R30
	AND  R30,R1
	OR   R21,R30
	CALL SUBOPT_0x22
	ST   -Y,R31
	ST   -Y,R30
	MOV  R26,R21
	CALL _glcd_writemem
	RJMP _0x2020092
_0x2020094:
	RJMP _0x2020090
_0x2020091:
	CPI  R30,LOW(0x9)
	BRNE _0x2020095
	LDI  R21,LOW(0)
	RJMP _0x2020096
_0x2020095:
	CPI  R30,LOW(0xA)
	BRNE _0x202009C
	LDI  R21,LOW(255)
_0x2020096:
	CALL SUBOPT_0x24
	MOV  R26,R30
	MOV  R30,R18
	CALL __LSRB12
	MOV  R21,R30
_0x2020099:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x202009B
	CALL SUBOPT_0x25
	ST   -Y,R20
	LDI  R26,LOW(0)
	RCALL _pcd8544_wrmasked_G101
	RJMP _0x2020099
_0x202009B:
	RJMP _0x2020090
_0x202009C:
_0x202009D:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x202009F
	CALL SUBOPT_0x27
	MOV  R26,R30
	MOV  R30,R18
	CALL __LSRB12
	ST   -Y,R30
	ST   -Y,R20
	LDD  R26,Y+13
	RCALL _pcd8544_wrmasked_G101
	RJMP _0x202009D
_0x202009F:
_0x2020090:
_0x2020075:
	LDD  R30,Y+8
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x2020049
_0x202004B:
_0x2160009:
	CALL __LOADLOCR6
	ADIW R28,17
	RET
; .FEND

	.CSEG
_glcd_clipx:
; .FSTART _glcd_clipx
	CALL SUBOPT_0x28
	BRLT _0x2040003
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	JMP  _0x2160003
_0x2040003:
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0x54)
	LDI  R30,HIGH(0x54)
	CPC  R27,R30
	BRLT _0x2040004
	LDI  R30,LOW(83)
	LDI  R31,HIGH(83)
	JMP  _0x2160003
_0x2040004:
	LD   R30,Y
	LDD  R31,Y+1
	JMP  _0x2160003
; .FEND
_glcd_clipy:
; .FSTART _glcd_clipy
	CALL SUBOPT_0x28
	BRLT _0x2040005
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	JMP  _0x2160003
_0x2040005:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,48
	BRLT _0x2040006
	LDI  R30,LOW(47)
	LDI  R31,HIGH(47)
	JMP  _0x2160003
_0x2040006:
	LD   R30,Y
	LDD  R31,Y+1
	JMP  _0x2160003
; .FEND
_glcd_getcharw_G102:
; .FSTART _glcd_getcharw_G102
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,3
	CALL SUBOPT_0x29
	MOVW R16,R30
	MOV  R0,R16
	OR   R0,R17
	BRNE _0x204000B
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x2160008
_0x204000B:
	CALL SUBOPT_0x2A
	STD  Y+7,R0
	CALL SUBOPT_0x2A
	STD  Y+6,R0
	CALL SUBOPT_0x2A
	STD  Y+8,R0
	LDD  R30,Y+11
	LDD  R26,Y+8
	CP   R30,R26
	BRSH _0x204000C
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x2160008
_0x204000C:
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
	BRLO _0x204000D
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x2160008
_0x204000D:
	LDD  R30,Y+6
	LSR  R30
	LSR  R30
	LSR  R30
	MOV  R20,R30
	LDD  R30,Y+6
	ANDI R30,LOW(0x7)
	BREQ _0x204000E
	SUBI R20,-LOW(1)
_0x204000E:
	LDD  R30,Y+7
	CPI  R30,0
	BREQ _0x204000F
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
	RJMP _0x2160008
_0x204000F:
	MOVW R18,R16
	MOV  R30,R21
	LDI  R31,0
	__ADDWRR 16,17,30,31
_0x2040010:
	LDD  R26,Y+8
	SUBI R26,-LOW(1)
	STD  Y+8,R26
	SUBI R26,LOW(1)
	LDD  R30,Y+11
	CP   R26,R30
	BRSH _0x2040012
	MOVW R30,R18
	__ADDWRN 18,19,1
	LPM  R26,Z
	LDI  R27,0
	MOV  R30,R20
	LDI  R31,0
	CALL __MULW12U
	__ADDWRR 16,17,30,31
	RJMP _0x2040010
_0x2040012:
	MOVW R30,R18
	LPM  R30,Z
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ST   X,R30
	MOVW R30,R16
_0x2160008:
	CALL __LOADLOCR6
	ADIW R28,12
	RET
; .FEND
_glcd_new_line_G102:
; .FSTART _glcd_new_line_G102
	LDI  R30,LOW(0)
	__PUTB1MN _glcd_state,2
	__GETB2MN _glcd_state,3
	CLR  R27
	CALL SUBOPT_0x2B
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
	CALL SUBOPT_0x29
	SBIW R30,0
	BRNE PC+2
	RJMP _0x204001F
	LDD  R26,Y+7
	CPI  R26,LOW(0xA)
	BRNE _0x2040020
	RJMP _0x2040021
_0x2040020:
	LDD  R30,Y+7
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,7
	RCALL _glcd_getcharw_G102
	MOVW R20,R30
	SBIW R30,0
	BRNE _0x2040022
	RJMP _0x2160007
_0x2040022:
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
	BRLO _0x2040023
	MOV  R16,R19
	CLR  R17
	RCALL _glcd_new_line_G102
_0x2040023:
	__GETB1MN _glcd_state,2
	ST   -Y,R30
	__GETB1MN _glcd_state,3
	ST   -Y,R30
	LDD  R30,Y+8
	ST   -Y,R30
	CALL SUBOPT_0x2B
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
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2C
	__GETB1MN _glcd_state,2
	ST   -Y,R30
	__GETB2MN _glcd_state,3
	CALL SUBOPT_0x2B
	ADD  R30,R26
	ST   -Y,R30
	ST   -Y,R19
	__GETB1MN _glcd_state,7
	CALL SUBOPT_0x2C
	LDI  R30,LOW(84)
	LDI  R31,HIGH(84)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x2040024
_0x2040021:
	RCALL _glcd_new_line_G102
	RJMP _0x2160007
_0x2040024:
_0x204001F:
	__PUTBMRN _glcd_state,2,16
_0x2160007:
	CALL __LOADLOCR6
	ADIW R28,8
	RET
; .FEND
_glcd_outtext:
; .FSTART _glcd_outtext
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x204002E:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2040030
	MOV  R26,R17
	RCALL _glcd_putchar
	RJMP _0x204002E
_0x2040030:
	LDD  R17,Y+0
	JMP  _0x2160002
; .FEND
_glcd_putpixelm_G102:
; .FSTART _glcd_putpixelm_G102
	ST   -Y,R26
	LDD  R30,Y+2
	ST   -Y,R30
	LDD  R30,Y+2
	ST   -Y,R30
	__GETB1MN _glcd_state,9
	LDD  R26,Y+2
	AND  R30,R26
	BREQ _0x204003E
	LDS  R30,_glcd_state
	RJMP _0x204003F
_0x204003E:
	__GETB1MN _glcd_state,1
_0x204003F:
	MOV  R26,R30
	RCALL _glcd_putpixel
	LD   R30,Y
	LSL  R30
	ST   Y,R30
	CPI  R30,0
	BRNE _0x2040041
	LDI  R30,LOW(1)
	ST   Y,R30
_0x2040041:
	LD   R30,Y
	JMP  _0x2160002
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
	JMP  _0x2160003
; .FEND
_glcd_line:
; .FSTART _glcd_line
	ST   -Y,R26
	SBIW R28,11
	CALL __SAVELOCR6
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
	BRNE _0x2040042
	LDD  R17,Y+20
	LDD  R26,Y+18
	CP   R17,R26
	BRNE _0x2040043
	ST   -Y,R17
	LDD  R30,Y+20
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _glcd_putpixelm_G102
	RJMP _0x2160006
_0x2040043:
	LDD  R26,Y+18
	CP   R17,R26
	BRSH _0x2040044
	LDD  R30,Y+18
	SUB  R30,R17
	MOV  R16,R30
	__GETWRN 20,21,1
	RJMP _0x2040045
_0x2040044:
	LDD  R26,Y+18
	MOV  R30,R17
	SUB  R30,R26
	MOV  R16,R30
	__GETWRN 20,21,-1
_0x2040045:
_0x2040047:
	LDD  R19,Y+19
	LDI  R30,LOW(0)
	STD  Y+6,R30
_0x2040049:
	CALL SUBOPT_0x2D
	BRSH _0x204004B
	ST   -Y,R17
	ST   -Y,R19
	INC  R19
	LDD  R26,Y+10
	RCALL _glcd_putpixelm_G102
	STD  Y+7,R30
	RJMP _0x2040049
_0x204004B:
	LDD  R30,Y+7
	STD  Y+8,R30
	ADD  R17,R20
	MOV  R30,R16
	SUBI R16,1
	CPI  R30,0
	BRNE _0x2040047
	RJMP _0x204004C
_0x2040042:
	LDD  R30,Y+18
	LDD  R26,Y+20
	CP   R30,R26
	BRNE _0x204004D
	LDD  R19,Y+19
	LDD  R26,Y+17
	CP   R19,R26
	BRSH _0x204004E
	LDD  R30,Y+17
	SUB  R30,R19
	MOV  R18,R30
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x204011B
_0x204004E:
	LDD  R26,Y+17
	MOV  R30,R19
	SUB  R30,R26
	MOV  R18,R30
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
_0x204011B:
	STD  Y+13,R30
	STD  Y+13+1,R31
_0x2040051:
	LDD  R17,Y+20
	LDI  R30,LOW(0)
	STD  Y+6,R30
_0x2040053:
	CALL SUBOPT_0x2D
	BRSH _0x2040055
	ST   -Y,R17
	INC  R17
	CALL SUBOPT_0x2E
	STD  Y+7,R30
	RJMP _0x2040053
_0x2040055:
	LDD  R30,Y+7
	STD  Y+8,R30
	LDD  R30,Y+13
	ADD  R19,R30
	MOV  R30,R18
	SUBI R18,1
	CPI  R30,0
	BRNE _0x2040051
	RJMP _0x2040056
_0x204004D:
	LDI  R30,LOW(0)
	STD  Y+6,R30
_0x2040057:
	CALL SUBOPT_0x2D
	BRLO PC+2
	RJMP _0x2040059
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
	BRPL _0x204005A
	LDI  R16,LOW(255)
	MOVW R30,R20
	CALL __ANEGW1
	MOVW R20,R30
_0x204005A:
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
	BRPL _0x204005B
	LDI  R18,LOW(255)
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	CALL __ANEGW1
	STD  Y+13,R30
	STD  Y+13+1,R31
_0x204005B:
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	LSL  R30
	ROL  R31
	STD  Y+11,R30
	STD  Y+11+1,R31
	ST   -Y,R17
	ST   -Y,R19
	LDI  R26,LOW(1)
	RCALL _glcd_putpixelm_G102
	STD  Y+8,R30
	LDI  R30,LOW(0)
	STD  Y+9,R30
	STD  Y+9+1,R30
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	CP   R20,R26
	CPC  R21,R27
	BRLT _0x204005C
_0x204005E:
	ADD  R17,R16
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	CALL SUBOPT_0x2F
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	CP   R20,R26
	CPC  R21,R27
	BRGE _0x2040060
	ADD  R19,R18
	LDD  R26,Y+15
	LDD  R27,Y+15+1
	CALL SUBOPT_0x30
_0x2040060:
	ST   -Y,R17
	CALL SUBOPT_0x2E
	STD  Y+8,R30
	LDD  R30,Y+18
	CP   R30,R17
	BRNE _0x204005E
	RJMP _0x2040061
_0x204005C:
_0x2040063:
	ADD  R19,R18
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	CALL SUBOPT_0x2F
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x2040065
	ADD  R17,R16
	LDD  R26,Y+11
	LDD  R27,Y+11+1
	CALL SUBOPT_0x30
_0x2040065:
	ST   -Y,R17
	CALL SUBOPT_0x2E
	STD  Y+8,R30
	LDD  R30,Y+17
	CP   R30,R19
	BRNE _0x2040063
_0x2040061:
	LDD  R30,Y+19
	SUBI R30,-LOW(1)
	STD  Y+19,R30
	LDD  R30,Y+17
	SUBI R30,-LOW(1)
	STD  Y+17,R30
	RJMP _0x2040057
_0x2040059:
_0x2040056:
_0x204004C:
_0x2160006:
	CALL __LOADLOCR6
	ADIW R28,21
	RET
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
_put_buff_G104:
; .FSTART _put_buff_G104
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x2080010
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,4
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2080012
	__CPWRN 16,17,2
	BRLO _0x2080013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2080012:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL SUBOPT_0x17
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
_0x2080013:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRMI _0x2080014
	CALL SUBOPT_0x17
_0x2080014:
	RJMP _0x2080015
_0x2080010:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2080015:
	LDD  R17,Y+1
	LDD  R16,Y+0
	JMP  _0x2160004
; .FEND
__print_G104:
; .FSTART __print_G104
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,6
	CALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2080016:
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
	RJMP _0x2080018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x208001C
	CPI  R18,37
	BRNE _0x208001D
	LDI  R17,LOW(1)
	RJMP _0x208001E
_0x208001D:
	CALL SUBOPT_0x31
_0x208001E:
	RJMP _0x208001B
_0x208001C:
	CPI  R30,LOW(0x1)
	BRNE _0x208001F
	CPI  R18,37
	BRNE _0x2080020
	CALL SUBOPT_0x31
	RJMP _0x20800CC
_0x2080020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2080021
	LDI  R16,LOW(1)
	RJMP _0x208001B
_0x2080021:
	CPI  R18,43
	BRNE _0x2080022
	LDI  R20,LOW(43)
	RJMP _0x208001B
_0x2080022:
	CPI  R18,32
	BRNE _0x2080023
	LDI  R20,LOW(32)
	RJMP _0x208001B
_0x2080023:
	RJMP _0x2080024
_0x208001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2080025
_0x2080024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2080026
	ORI  R16,LOW(128)
	RJMP _0x208001B
_0x2080026:
	RJMP _0x2080027
_0x2080025:
	CPI  R30,LOW(0x3)
	BREQ PC+2
	RJMP _0x208001B
_0x2080027:
	CPI  R18,48
	BRLO _0x208002A
	CPI  R18,58
	BRLO _0x208002B
_0x208002A:
	RJMP _0x2080029
_0x208002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x208001B
_0x2080029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x208002F
	CALL SUBOPT_0x32
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x33
	RJMP _0x2080030
_0x208002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2080032
	CALL SUBOPT_0x32
	CALL SUBOPT_0x34
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2080033
_0x2080032:
	CPI  R30,LOW(0x70)
	BRNE _0x2080035
	CALL SUBOPT_0x32
	CALL SUBOPT_0x34
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2080033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2080036
_0x2080035:
	CPI  R30,LOW(0x64)
	BREQ _0x2080039
	CPI  R30,LOW(0x69)
	BRNE _0x208003A
_0x2080039:
	ORI  R16,LOW(4)
	RJMP _0x208003B
_0x208003A:
	CPI  R30,LOW(0x75)
	BRNE _0x208003C
_0x208003B:
	LDI  R30,LOW(_tbl10_G104*2)
	LDI  R31,HIGH(_tbl10_G104*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(5)
	RJMP _0x208003D
_0x208003C:
	CPI  R30,LOW(0x58)
	BRNE _0x208003F
	ORI  R16,LOW(8)
	RJMP _0x2080040
_0x208003F:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x2080071
_0x2080040:
	LDI  R30,LOW(_tbl16_G104*2)
	LDI  R31,HIGH(_tbl16_G104*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(4)
_0x208003D:
	SBRS R16,2
	RJMP _0x2080042
	CALL SUBOPT_0x32
	CALL SUBOPT_0x35
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2080043
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	CALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x2080043:
	CPI  R20,0
	BREQ _0x2080044
	SUBI R17,-LOW(1)
	RJMP _0x2080045
_0x2080044:
	ANDI R16,LOW(251)
_0x2080045:
	RJMP _0x2080046
_0x2080042:
	CALL SUBOPT_0x32
	CALL SUBOPT_0x35
_0x2080046:
_0x2080036:
	SBRC R16,0
	RJMP _0x2080047
_0x2080048:
	CP   R17,R21
	BRSH _0x208004A
	SBRS R16,7
	RJMP _0x208004B
	SBRS R16,2
	RJMP _0x208004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x208004D
_0x208004C:
	LDI  R18,LOW(48)
_0x208004D:
	RJMP _0x208004E
_0x208004B:
	LDI  R18,LOW(32)
_0x208004E:
	CALL SUBOPT_0x31
	SUBI R21,LOW(1)
	RJMP _0x2080048
_0x208004A:
_0x2080047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x208004F
_0x2080050:
	CPI  R19,0
	BREQ _0x2080052
	SBRS R16,3
	RJMP _0x2080053
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x2080054
_0x2080053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2080054:
	CALL SUBOPT_0x31
	CPI  R21,0
	BREQ _0x2080055
	SUBI R21,LOW(1)
_0x2080055:
	SUBI R19,LOW(1)
	RJMP _0x2080050
_0x2080052:
	RJMP _0x2080056
_0x208004F:
_0x2080058:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x208005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x208005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x208005A
_0x208005C:
	CPI  R18,58
	BRLO _0x208005D
	SBRS R16,3
	RJMP _0x208005E
	SUBI R18,-LOW(7)
	RJMP _0x208005F
_0x208005E:
	SUBI R18,-LOW(39)
_0x208005F:
_0x208005D:
	SBRC R16,4
	RJMP _0x2080061
	CPI  R18,49
	BRSH _0x2080063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2080062
_0x2080063:
	RJMP _0x20800CD
_0x2080062:
	CP   R21,R19
	BRLO _0x2080067
	SBRS R16,0
	RJMP _0x2080068
_0x2080067:
	RJMP _0x2080066
_0x2080068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2080069
	LDI  R18,LOW(48)
_0x20800CD:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x208006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	CALL SUBOPT_0x33
	CPI  R21,0
	BREQ _0x208006B
	SUBI R21,LOW(1)
_0x208006B:
_0x208006A:
_0x2080069:
_0x2080061:
	CALL SUBOPT_0x31
	CPI  R21,0
	BREQ _0x208006C
	SUBI R21,LOW(1)
_0x208006C:
_0x2080066:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x2080059
	RJMP _0x2080058
_0x2080059:
_0x2080056:
	SBRS R16,0
	RJMP _0x208006D
_0x208006E:
	CPI  R21,0
	BREQ _0x2080070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0x33
	RJMP _0x208006E
_0x2080070:
_0x208006D:
_0x2080071:
_0x2080030:
_0x20800CC:
	LDI  R17,LOW(0)
_0x208001B:
	RJMP _0x2080016
_0x2080018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CALL __GETW1P
	CALL __LOADLOCR6
	ADIW R28,20
	RET
; .FEND
_sprintf:
; .FSTART _sprintf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	CALL __SAVELOCR4
	CALL SUBOPT_0x36
	SBIW R30,0
	BRNE _0x2080072
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x2160005
_0x2080072:
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	MOVW R16,R26
	CALL SUBOPT_0x36
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G104)
	LDI  R31,HIGH(_put_buff_G104)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,10
	RCALL __print_G104
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x2160005:
	CALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET
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
_0x2160004:
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
_strlenf:
; .FSTART _strlenf
	ST   -Y,R27
	ST   -Y,R26
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
	RJMP _0x2160001
; .FEND

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
_0x2160003:
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
	RJMP _0x2160002
_0x210000F:
	LDD  R30,Y+2
	COM  R30
	LDD  R17,Y+0
	RJMP _0x2160002
_0x210000E:
	CPI  R17,0
	BRNE _0x2100011
	LDI  R30,LOW(0)
	LDD  R17,Y+0
	RJMP _0x2160002
_0x2100011:
_0x2100005:
	LDD  R30,Y+2
	LDD  R17,Y+0
	RJMP _0x2160002
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
	RJMP _0x2160002
_0x2100015:
	CPI  R30,LOW(0x2)
	BRNE _0x2100016
	LD   R26,Y
	LDD  R27,Y+1
	CALL __EEPROMRDB
	RJMP _0x2160002
_0x2100016:
	CPI  R30,LOW(0x3)
	BRNE _0x2100018
	LD   R26,Y
	LDD  R27,Y+1
	__CALL1MN _glcd_state,25
	RJMP _0x2160002
_0x2100018:
	LD   R26,Y
	LDD  R27,Y+1
	LD   R30,X
_0x2160002:
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
_0x2160001:
	ADIW R28,4
	RET
; .FEND

	.CSEG

	.CSEG

	.DSEG
_glcd_state:
	.BYTE 0x1D
_buff:
	.BYTE 0x1CC
_gprs_command:
	.BYTE 0x6
_entry_id:
	.BYTE 0x4
_stop:
	.BYTE 0x1
_send_ok:
	.BYTE 0x1
_time_s:
	.BYTE 0x2
_rx_buffer0:
	.BYTE 0x40
_rx_wr_index0:
	.BYTE 0x1
_rx_rd_index0:
	.BYTE 0x1
_rx_counter0:
	.BYTE 0x1
_tx_buffer0:
	.BYTE 0x40
_tx_wr_index0:
	.BYTE 0x1
_tx_rd_index0:
	.BYTE 0x1
_tx_counter0:
	.BYTE 0x1
_rx_buffer1:
	.BYTE 0x40
_rx_wr_index1:
	.BYTE 0x1
_rx_rd_index1:
	.BYTE 0x1
_rx_counter1:
	.BYTE 0x1
_tx_buffer1:
	.BYTE 0x40
_tx_wr_index1:
	.BYTE 0x1
_tx_rd_index1:
	.BYTE 0x1
_tx_counter1:
	.BYTE 0x1
_P_Add:
	.BYTE 0x1
_Code_tay_cam1:
	.BYTE 0x1
_Code_tay_cam2:
	.BYTE 0x1
_Code_tay_cam3:
	.BYTE 0x1
_Code_tay_cam4:
	.BYTE 0x1
_station_receive:
	.BYTE 0xC
_tay_cam_receive:
	.BYTE 0x8
_data_receive:
	.BYTE 0x12
_result:
	.BYTE 0x1
_count:
	.BYTE 0x2
_dem:
	.BYTE 0x4
_flag:
	.BYTE 0x1
_gfx_addr_G101:
	.BYTE 0x2
_gfx_buffer_G101:
	.BYTE 0x1F8
__seed_G105:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x0:
	LDI  R26,LOW(_buff)
	LDI  R27,HIGH(_buff)
	ADD  R26,R4
	ADC  R27,R5
	LD   R26,X
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1:
	ST   -Y,R26
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x2:
	__DELAY_USB 13
	LDD  R30,Y+1
	LSL  R30
	STD  Y+1,R30
	SBI  0x1B,4
	__DELAY_USB 13
	LDI  R30,0
	SBIC 0x19,5
	LDI  R30,1
	LDD  R26,Y+1
	OR   R30,R26
	STD  Y+1,R30
	CBI  0x1B,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x3:
	ST   -Y,R26
	CBI  0x1B,2
	LDD  R30,Y+1
	ORI  R30,0x20
	MOV  R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x4:
	SBI  0x1B,2
	__DELAY_USB 27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x5:
	CALL _SPI_RW_RX
	LD   R26,Y
	JMP  _SPI_RW_RX

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6:
	CALL _SPI_RW_RX
	LDS  R26,_Code_tay_cam2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	CALL _RF_Write3_RX
	LDI  R30,LOW(16)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8:
	ST   -Y,R30
	LDI  R26,LOW(15)
	JMP  _RF_Write_RX

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x9:
	LDI  R31,0
	ST   X+,R30
	ST   X,R31
	JMP  _SPI_Read_RX

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xA:
	ST   -Y,R30
	LDI  R30,LOW(48)
	ST   -Y,R30
	LDI  R26,LOW(15)
	CALL _glcd_line
	LDI  R30,LOW(0)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xB:
	ST   -Y,R30
	LDI  R30,LOW(84)
	ST   -Y,R30
	LDI  R26,LOW(48)
	CALL _glcd_line
	LDI  R30,LOW(0)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC:
	CALL _glcd_outtext
	LDI  R30,LOW(4)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xD:
	LDI  R26,LOW(_count)
	LDI  R27,HIGH(_count)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xE:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _count,R30
	STS  _count+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0xF:
	CALL _glcd_clear
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _glcd_moveto

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x10:
	LDI  R26,LOW(_buff)
	LDI  R27,HIGH(_buff)
	JMP  _glcd_outtext

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x11:
	SUB  R26,R18
	SBC  R27,R19
	LDD  R30,Y+46
	LDD  R31,Y+46+1
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x12:
	LDI  R30,LOW(_buff)
	LDI  R31,HIGH(_buff)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x13:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(2)
	LDI  R27,0
	JMP  _wait_until

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x14:
	LDI  R26,LOW(0)
	LDI  R27,0
	JMP  _refresh

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x15:
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x16:
	__GETW2SX 81
	LD   R30,X
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x17:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x18:
	CALL _put_string
	LDI  R26,LOW(300)
	LDI  R27,HIGH(300)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x19:
	MOVW R30,R28
	ADIW R30,44
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1A:
	CALL _strcat
	RJMP SUBOPT_0x19

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1B:
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,26
	CALL _itoa
	RJMP SUBOPT_0x19

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1C:
	CALL _glcd_moveto
	RJMP SUBOPT_0x12

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x1D:
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	RJMP SUBOPT_0x10

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1E:
	LDI  R26,LOW(_gfx_addr_G101)
	LDI  R27,HIGH(_gfx_addr_G101)
	RJMP SUBOPT_0x17

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1F:
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+6,R30
	STD  Y+6+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x20:
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
SUBOPT_0x21:
	ST   -Y,R16
	LDD  R26,Y+16
	JMP  _pcd8544_setaddr_G101

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x22:
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
SUBOPT_0x23:
	CLR  R22
	CLR  R23
	MOVW R26,R30
	MOVW R24,R22
	JMP  _glcd_readmem

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x24:
	ST   -Y,R21
	LDD  R26,Y+10
	JMP  _glcd_mappixcolor1bit

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x25:
	ST   -Y,R16
	INC  R16
	LDD  R30,Y+16
	ST   -Y,R30
	ST   -Y,R21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x26:
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
SUBOPT_0x27:
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
	RJMP SUBOPT_0x23

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x28:
	ST   -Y,R27
	ST   -Y,R26
	LD   R26,Y
	LDD  R27,Y+1
	CALL __CPW02
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x29:
	CALL __SAVELOCR6
	__GETW1MN _glcd_state,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2A:
	MOVW R30,R16
	__ADDWRN 16,17,1
	LPM  R0,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x2B:
	__GETW1MN _glcd_state,4
	ADIW R30,1
	LPM  R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2C:
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(9)
	JMP  _glcd_block

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x2D:
	LDD  R26,Y+6
	SUBI R26,-LOW(1)
	STD  Y+6,R26
	SUBI R26,LOW(1)
	__GETB1MN _glcd_state,8
	CP   R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2E:
	ST   -Y,R19
	LDD  R26,Y+10
	JMP  _glcd_putpixelm_G102

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2F:
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+9,R30
	STD  Y+9+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x30:
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+9,R30
	STD  Y+9+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x31:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x32:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x33:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x34:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x35:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x36:
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	RET


	.CSEG
	.equ __sda_bit=1
	.equ __scl_bit=0
	.equ __i2c_port=0x12 ;PORTD
	.equ __i2c_dir=__i2c_port-1
	.equ __i2c_pin=__i2c_port-2

_i2c_init:
	cbi  __i2c_port,__scl_bit
	cbi  __i2c_port,__sda_bit
	sbi  __i2c_dir,__scl_bit
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_delay2
_i2c_start:
	cbi  __i2c_dir,__sda_bit
	cbi  __i2c_dir,__scl_bit
	clr  r30
	nop
	sbis __i2c_pin,__sda_bit
	ret
	sbis __i2c_pin,__scl_bit
	ret
	rcall __i2c_delay1
	sbi  __i2c_dir,__sda_bit
	rcall __i2c_delay1
	sbi  __i2c_dir,__scl_bit
	ldi  r30,1
__i2c_delay1:
	ldi  r22,13
	rjmp __i2c_delay2l
_i2c_stop:
	sbi  __i2c_dir,__sda_bit
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__sda_bit
__i2c_delay2:
	ldi  r22,27
__i2c_delay2l:
	dec  r22
	brne __i2c_delay2l
	ret
_i2c_read:
	ldi  r23,8
__i2c_read0:
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
__i2c_read3:
	sbis __i2c_pin,__scl_bit
	rjmp __i2c_read3
	rcall __i2c_delay1
	clc
	sbic __i2c_pin,__sda_bit
	sec
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	rol  r30
	dec  r23
	brne __i2c_read0
	mov  r23,r26
	tst  r23
	brne __i2c_read1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_read2
__i2c_read1:
	sbi  __i2c_dir,__sda_bit
__i2c_read2:
	rcall __i2c_delay1
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_delay1

_i2c_write:
	ldi  r23,8
__i2c_write0:
	lsl  r26
	brcc __i2c_write1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_write2
__i2c_write1:
	sbi  __i2c_dir,__sda_bit
__i2c_write2:
	rcall __i2c_delay2
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
__i2c_write3:
	sbis __i2c_pin,__scl_bit
	rjmp __i2c_write3
	rcall __i2c_delay1
	sbi  __i2c_dir,__scl_bit
	dec  r23
	brne __i2c_write0
	cbi  __i2c_dir,__sda_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	ldi  r30,1
	sbic __i2c_pin,__sda_bit
	clr  r30
	sbi  __i2c_dir,__scl_bit
	rjmp __i2c_delay1

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

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETD1P_INC:
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X+
	RET

__PUTDP1_DEC:
	ST   -X,R23
	ST   -X,R22
	ST   -X,R31
	ST   -X,R30
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

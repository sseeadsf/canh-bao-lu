
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
;Global 'const' stored in FLASH: No
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
	.DEF _flag=R6

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
	JMP  _timer2_ovf
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
_tbl10_G106:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G106:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0

_0x2C:
	.DB  0xA1
_0x2D:
	.DB  0xA2
_0x2E:
	.DB  0xA3
_0x2F:
	.DB  0xA4
_0xD0:
	.DB  LOW(_0xCF),HIGH(_0xCF),LOW(_0xCF+1),HIGH(_0xCF+1),LOW(_0xCF+18),HIGH(_0xCF+18),LOW(_0xCF+35),HIGH(_0xCF+35)
	.DB  LOW(_0xCF+52),HIGH(_0xCF+52)
_0xD6:
	.DB  0x47,0x45,0x54,0x20,0x2F,0x75,0x70,0x64
	.DB  0x61,0x74,0x65,0x3F,0x6B,0x65,0x79,0x3D
	.DB  0x0
_0x0:
	.DB  0x45,0x52,0x52,0x4F,0x52,0x0,0x37,0x52
	.DB  0x36,0x4E,0x53,0x59,0x46,0x48,0x42,0x46
	.DB  0x52,0x55,0x41,0x52,0x36,0x4B,0x0,0x35
	.DB  0x49,0x30,0x30,0x30,0x57,0x52,0x4F,0x58
	.DB  0x4F,0x46,0x53,0x30,0x56,0x38,0x35,0x0
	.DB  0x36,0x4E,0x48,0x46,0x58,0x48,0x30,0x37
	.DB  0x36,0x53,0x43,0x30,0x32,0x44,0x5A,0x30
	.DB  0x0,0x57,0x55,0x49,0x54,0x38,0x4C,0x58
	.DB  0x37,0x4E,0x39,0x32,0x58,0x38,0x4A,0x34
	.DB  0x57,0x0,0x4E,0x6F,0x64,0x65,0x3A,0x20
	.DB  0x0,0x54,0x65,0x6D,0x70,0x3A,0x20,0x0
	.DB  0x48,0x75,0x6D,0x69,0x64,0x3A,0x20,0x0
	.DB  0x57,0x61,0x74,0x65,0x72,0x3A,0x20,0x0
	.DB  0x21,0x43,0x0,0x63,0x6D,0x0,0x32,0x31
	.DB  0x0,0x37,0x35,0x0,0x34,0x35,0x0,0x42
	.DB  0x6F,0x6F,0x74,0x69,0x6E,0x67,0x0,0x41
	.DB  0x54,0xD,0xA,0x0,0x4F,0x4B,0x0,0x41
	.DB  0x54,0x2B,0x43,0x49,0x50,0x53,0x54,0x41
	.DB  0x54,0x55,0x53,0xD,0xA,0x0,0x53,0x54
	.DB  0x41,0x54,0x55,0x53,0x3A,0x32,0x0,0x57
	.DB  0x69,0x66,0x69,0x20,0x43,0x6F,0x6E,0x6E
	.DB  0x65,0x63,0x74,0x65,0x64,0xD,0xA,0x0
	.DB  0x41,0x54,0x2B,0x43,0x57,0x4D,0x4F,0x44
	.DB  0x45,0x3D,0x31,0xD,0xA,0x0,0x41,0x54
	.DB  0x2B,0x43,0x57,0x4A,0x41,0x50,0x3D,0x22
	.DB  0x54,0x68,0x61,0x79,0x5F,0x54,0x68,0x61
	.DB  0x6F,0x5F,0x64,0x65,0x6F,0x5F,0x67,0x69
	.DB  0x61,0x69,0x22,0x2C,0x22,0x63,0x68,0x69
	.DB  0x6E,0x68,0x78,0x61,0x63,0x22,0xD,0xA
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
	.DB  0x2C,0x0,0x3E,0x20,0x0,0x41,0x54,0x2B
	.DB  0x43,0x49,0x50,0x43,0x4C,0x4F,0x53,0x45
	.DB  0x3D,0x30,0xD,0xA,0x0,0x25,0x64,0x0
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

	.DW  0x06
	.DW  _0x2B
	.DW  _0x0*2

	.DW  0x01
	.DW  _Code_tay_cam1
	.DW  _0x2C*2

	.DW  0x01
	.DW  _Code_tay_cam2
	.DW  _0x2D*2

	.DW  0x01
	.DW  _Code_tay_cam3
	.DW  _0x2E*2

	.DW  0x01
	.DW  _Code_tay_cam4
	.DW  _0x2F*2

	.DW  0x01
	.DW  _0xCF
	.DW  _0x0*2+5

	.DW  0x11
	.DW  _0xCF+1
	.DW  _0x0*2+6

	.DW  0x11
	.DW  _0xCF+18
	.DW  _0x0*2+23

	.DW  0x11
	.DW  _0xCF+35
	.DW  _0x0*2+40

	.DW  0x11
	.DW  _0xCF+52
	.DW  _0x0*2+57

	.DW  0x0A
	.DW  _key
	.DW  _0xD0*2

	.DW  0x07
	.DW  _0xD1
	.DW  _0x0*2+74

	.DW  0x07
	.DW  _0xD1+7
	.DW  _0x0*2+81

	.DW  0x08
	.DW  _0xD1+14
	.DW  _0x0*2+88

	.DW  0x08
	.DW  _0xD1+22
	.DW  _0x0*2+96

	.DW  0x03
	.DW  _0xD1+30
	.DW  _0x0*2+104

	.DW  0x03
	.DW  _0xD1+33
	.DW  _0x0*2+107

	.DW  0x03
	.DW  _0xD2
	.DW  _0x0*2+110

	.DW  0x03
	.DW  _0xD2+3
	.DW  _0x0*2+113

	.DW  0x03
	.DW  _0xD2+6
	.DW  _0x0*2+116

	.DW  0x08
	.DW  _0xD3
	.DW  _0x0*2+119

	.DW  0x05
	.DW  _0xD3+8
	.DW  _0x0*2+127

	.DW  0x03
	.DW  _0xD3+13
	.DW  _0x0*2+132

	.DW  0x0F
	.DW  _0xD3+16
	.DW  _0x0*2+135

	.DW  0x03
	.DW  _0xD3+31
	.DW  _0x0*2+132

	.DW  0x09
	.DW  _0xD3+34
	.DW  _0x0*2+150

	.DW  0x11
	.DW  _0xD3+43
	.DW  _0x0*2+159

	.DW  0x0E
	.DW  _0xD3+60
	.DW  _0x0*2+176

	.DW  0x03
	.DW  _0xD3+74
	.DW  _0x0*2+132

	.DW  0x2B
	.DW  _0xD3+77
	.DW  _0x0*2+190

	.DW  0x03
	.DW  _0xD3+120
	.DW  _0x0*2+132

	.DW  0x0C
	.DW  _0xDA
	.DW  _0x0*2+233

	.DW  0x03
	.DW  _0xDA+12
	.DW  _0x0*2+129

	.DW  0x03
	.DW  _0xDA+15
	.DW  _0x0*2+132

	.DW  0x2C
	.DW  _0xDA+18
	.DW  _0x0*2+245

	.DW  0x03
	.DW  _0xDA+62
	.DW  _0x0*2+129

	.DW  0x03
	.DW  _0xDA+65
	.DW  _0x0*2+132

	.DW  0x09
	.DW  _0xDA+68
	.DW  _0x0*2+289

	.DW  0x09
	.DW  _0xDA+77
	.DW  _0x0*2+298

	.DW  0x09
	.DW  _0xDA+86
	.DW  _0x0*2+307

	.DW  0x03
	.DW  _0xDA+95
	.DW  _0x0*2+129

	.DW  0x0E
	.DW  _0xDA+98
	.DW  _0x0*2+316

	.DW  0x03
	.DW  _0xDA+112
	.DW  _0x0*2+129

	.DW  0x03
	.DW  _0xDA+115
	.DW  _0x0*2+330

	.DW  0x10
	.DW  _0xDA+118
	.DW  _0x0*2+333

	.DW  0x03
	.DW  _0xDA+134
	.DW  _0x0*2+132

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
;#include <stdlib.h>
;// Graphic Display functions
;#include <glcd.h>
;// Font used for displaying text
;// on the graphic display
;#include <font5x7.h>
;#include <i2c.h>
;
;// DS1307 Real Time Clock functions
;#include <ds1307.h>
;
;// Declare your global variables here
;#define menu PINC.3
;#define back PINC.2
;#define enter PINC.0
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
;bool flag = false;
;int dem;
;int count;
;
;void del_string(unsigned char *s) {
; 0000 002F void del_string(unsigned char *s) {

	.CSEG
_del_string:
; .FSTART _del_string
; 0000 0030     while (*s) {
	ST   -Y,R27
	ST   -Y,R26
;	*s -> Y+0
_0x3:
	LD   R26,Y
	LDD  R27,Y+1
	LD   R30,X
	CPI  R30,0
	BREQ _0x5
; 0000 0031         *s = '\0';
	LDI  R30,LOW(0)
	ST   X,R30
; 0000 0032         s++;
	LD   R30,Y
	LDD  R31,Y+1
	ADIW R30,1
	ST   Y,R30
	STD  Y+1,R31
; 0000 0033     }
	RJMP _0x3
_0x5:
; 0000 0034     i = 0;
	CLR  R8
	CLR  R9
; 0000 0035 }
	JMP  _0x216000C
; .FEND
;
;// This flag is set on USART0 Receiver buffer overflow
;bit rx_buffer_overflow0;
;
;// USART0 Receiver interrupt service routine
;interrupt [USART0_RXC] void usart0_rx_isr(void) {
; 0000 003B interrupt [19] void usart0_rx_isr(void) {
_usart0_rx_isr:
; .FSTART _usart0_rx_isr
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 003C     char status,data;
; 0000 003D     status=UCSR0A;
	ST   -Y,R17
	ST   -Y,R16
;	status -> R17
;	data -> R16
	IN   R17,11
; 0000 003E     data=UDR0;
	IN   R16,12
; 0000 003F     if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0) {
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0x6
; 0000 0040         rx_buffer0[rx_wr_index0++]=data;
	MOV  R30,R5
	INC  R5
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer0)
	SBCI R31,HIGH(-_rx_buffer0)
	ST   Z,R16
; 0000 0041 #if RX_BUFFER_SIZE0 == 256
; 0000 0042         // special case for receiver buffer size=256
; 0000 0043         if (++rx_counter0 == 0) rx_buffer_overflow0=1;
; 0000 0044 #else
; 0000 0045         if (rx_wr_index0 == RX_BUFFER_SIZE0) rx_wr_index0=0;
	LDI  R30,LOW(64)
	CP   R30,R5
	BRNE _0x7
	CLR  R5
; 0000 0046         if (++rx_counter0 == RX_BUFFER_SIZE0) {
_0x7:
	INC  R7
	LDI  R30,LOW(64)
	CP   R30,R7
	BRNE _0x8
; 0000 0047             rx_counter0=0;
	CLR  R7
; 0000 0048             rx_buffer_overflow0=1;
	SET
	BLD  R2,0
; 0000 0049         }
; 0000 004A #endif
; 0000 004B     }
_0x8:
; 0000 004C     buff[i] = data;
_0x6:
	MOVW R30,R8
	SUBI R30,LOW(-_buff)
	SBCI R31,HIGH(-_buff)
	ST   Z,R16
; 0000 004D     i++;
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
; 0000 004E }
	LD   R16,Y+
	LD   R17,Y+
	RJMP _0xF0
; .FEND
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Get a character from the USART0 Receiver buffer
;#define _ALTERNATE_GETCHAR_
;#pragma used+
;char getchar(void) {
; 0000 0054 char getchar(void) {
; 0000 0055     char data;
; 0000 0056     while (rx_counter0==0);
;	data -> R17
; 0000 0057     data=rx_buffer0[rx_rd_index0++];
; 0000 0058 #if RX_BUFFER_SIZE0 != 256
; 0000 0059     if (rx_rd_index0 == RX_BUFFER_SIZE0) rx_rd_index0=0;
; 0000 005A #endif
; 0000 005B #asm("cli")
; 0000 005C     --rx_counter0;
; 0000 005D #asm("sei")
; 0000 005E     return data;
; 0000 005F }
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
; 0000 0074 interrupt [21] void usart0_tx_isr(void) {
_usart0_tx_isr:
; .FSTART _usart0_tx_isr
	ST   -Y,R26
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0075     if (tx_counter0) {
	LDS  R30,_tx_counter0
	CPI  R30,0
	BREQ _0xD
; 0000 0076         --tx_counter0;
	SUBI R30,LOW(1)
	STS  _tx_counter0,R30
; 0000 0077         UDR0=tx_buffer0[tx_rd_index0++];
	LDS  R30,_tx_rd_index0
	SUBI R30,-LOW(1)
	STS  _tx_rd_index0,R30
	SUBI R30,LOW(1)
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer0)
	SBCI R31,HIGH(-_tx_buffer0)
	LD   R30,Z
	OUT  0xC,R30
; 0000 0078 #if TX_BUFFER_SIZE0 != 256
; 0000 0079         if (tx_rd_index0 == TX_BUFFER_SIZE0) tx_rd_index0=0;
	LDS  R26,_tx_rd_index0
	CPI  R26,LOW(0x40)
	BRNE _0xE
	LDI  R30,LOW(0)
	STS  _tx_rd_index0,R30
; 0000 007A #endif
; 0000 007B     }
_0xE:
; 0000 007C }
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
; 0000 007E interrupt [17] void timer0_ovf_isr(void) {
_timer0_ovf_isr:
; .FSTART _timer0_ovf_isr
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 007F     //0.02 ms => 50k = 1s.
; 0000 0080     TCNT0=0x9C;
	LDI  R30,LOW(156)
	OUT  0x32,R30
; 0000 0081     // Place your code here
; 0000 0082     time_flow++;
	MOVW R30,R10
	ADIW R30,1
	MOVW R10,R30
; 0000 0083 
; 0000 0084     if (time_flow == 10000) {
	LDI  R30,LOW(10000)
	LDI  R31,HIGH(10000)
	CP   R30,R10
	CPC  R31,R11
	BRNE _0xF
; 0000 0085         time_s++;
	MOVW R30,R12
	ADIW R30,1
	MOVW R12,R30
; 0000 0086         time_flow = 0;
	CLR  R10
	CLR  R11
; 0000 0087     }
; 0000 0088 }
_0xF:
_0xF0:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
; .FEND
;
;interrupt [TIM2_OVF] void timer2_ovf(void){
; 0000 008A interrupt [11] void timer2_ovf(void){
_timer2_ovf:
; .FSTART _timer2_ovf
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 008B     TCNT2 = 0x83;
	LDI  R30,LOW(131)
	OUT  0x24,R30
; 0000 008C     if(flag == true)
	LDI  R30,LOW(1)
	CP   R30,R6
	BRNE _0x10
; 0000 008D         dem++;
	LDI  R26,LOW(_dem)
	LDI  R27,HIGH(_dem)
	CALL SUBOPT_0x0
; 0000 008E     if(dem == 3000){
_0x10:
	LDS  R26,_dem
	LDS  R27,_dem+1
	CPI  R26,LOW(0xBB8)
	LDI  R30,HIGH(0xBB8)
	CPC  R27,R30
	BRNE _0x11
; 0000 008F         count++;
	CALL SUBOPT_0x1
; 0000 0090         dem = 0;
	CALL SUBOPT_0x2
; 0000 0091         flag = false;
	CLR  R6
; 0000 0092     }
; 0000 0093 }
_0x11:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	RETI
; .FEND
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Write a character to the USART0 Transmitter buffer
;#define _ALTERNATE_PUTCHAR_
;#pragma used+
;void putchar(char c) {
; 0000 0099 void putchar(char c) {
_putchar:
; .FSTART _putchar
; 0000 009A     while (tx_counter0 == TX_BUFFER_SIZE0);
	ST   -Y,R26
;	c -> Y+0
_0x12:
	LDS  R26,_tx_counter0
	CPI  R26,LOW(0x40)
	BREQ _0x12
; 0000 009B #asm("cli")
	cli
; 0000 009C     if (tx_counter0 || ((UCSR0A & DATA_REGISTER_EMPTY)==0)) {
	LDS  R30,_tx_counter0
	CPI  R30,0
	BRNE _0x16
	SBIC 0xB,5
	RJMP _0x15
_0x16:
; 0000 009D         tx_buffer0[tx_wr_index0++]=c;
	LDS  R30,_tx_wr_index0
	SUBI R30,-LOW(1)
	STS  _tx_wr_index0,R30
	SUBI R30,LOW(1)
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer0)
	SBCI R31,HIGH(-_tx_buffer0)
	LD   R26,Y
	STD  Z+0,R26
; 0000 009E #if TX_BUFFER_SIZE0 != 256
; 0000 009F         if (tx_wr_index0 == TX_BUFFER_SIZE0) tx_wr_index0=0;
	LDS  R26,_tx_wr_index0
	CPI  R26,LOW(0x40)
	BRNE _0x18
	LDI  R30,LOW(0)
	STS  _tx_wr_index0,R30
; 0000 00A0 #endif
; 0000 00A1         ++tx_counter0;
_0x18:
	LDS  R30,_tx_counter0
	SUBI R30,-LOW(1)
	STS  _tx_counter0,R30
; 0000 00A2     } else
	RJMP _0x19
_0x15:
; 0000 00A3         UDR0=c;
	LD   R30,Y
	OUT  0xC,R30
; 0000 00A4 #asm("sei")
_0x19:
	sei
; 0000 00A5 }
	JMP  _0x216000B
; .FEND
;#pragma used-
;#endif
;
;// Standard Input/Output functions
;#include <stdio.h>
;
;void put_string (unsigned char *s) {
; 0000 00AC void put_string (unsigned char *s) {
_put_string:
; .FSTART _put_string
; 0000 00AD     while(*s) {
	ST   -Y,R27
	ST   -Y,R26
;	*s -> Y+0
_0x1A:
	LD   R26,Y
	LDD  R27,Y+1
	LD   R30,X
	CPI  R30,0
	BREQ _0x1C
; 0000 00AE         putchar(*s);
	LD   R26,X
	RCALL _putchar
; 0000 00AF         delay_ms(50);
	LDI  R26,LOW(50)
	LDI  R27,0
	CALL _delay_ms
; 0000 00B0         s++;
	LD   R30,Y
	LDD  R31,Y+1
	ADIW R30,1
	ST   Y,R30
	STD  Y+1,R31
; 0000 00B1     }
	RJMP _0x1A
_0x1C:
; 0000 00B2 }
	JMP  _0x216000C
; .FEND
;
;void refresh(int time_ms) {
; 0000 00B4 void refresh(int time_ms) {
_refresh:
; .FSTART _refresh
; 0000 00B5 
; 0000 00B6     delay_ms(time_ms);
	CALL SUBOPT_0x3
;	time_ms -> Y+0
	CALL _delay_ms
; 0000 00B7    // glcd_clear();
; 0000 00B8     //glcd_moveto(0,0);
; 0000 00B9    // glcd_outtext(buff);
; 0000 00BA     del_string(buff);
	LDI  R26,LOW(_buff)
	LDI  R27,HIGH(_buff)
	RCALL _del_string
; 0000 00BB     i = 0;
	CLR  R8
	CLR  R9
; 0000 00BC 
; 0000 00BD 
; 0000 00BE 
; 0000 00BF }
	JMP  _0x216000C
; .FEND
;
;void wait_until(unsigned char *keyword, int time_out_s) {
; 0000 00C1 void wait_until(unsigned char *keyword, int time_out_s) {
_wait_until:
; .FSTART _wait_until
; 0000 00C2     /*     deu biet cai temp2 de lam gi nhung khong co thi no khong chay trong 1 so truong hop @@
; 0000 00C3         Vi du nhap vao "Hell" thi no se tach thua ra them 2 char. Co the do vi tri o nho. Cha biet @@*/
; 0000 00C4     char temp[20], temp2[20];
; 0000 00C5     int i = 0, time_start, time_temp;
; 0000 00C6 
; 0000 00C7     del_string(temp);
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
; 0000 00C8 
; 0000 00C9     while (*keyword) {
_0x1D:
	LDD  R26,Y+48
	LDD  R27,Y+48+1
	LD   R30,X
	CPI  R30,0
	BREQ _0x1F
; 0000 00CA         temp[i] = *keyword;
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
; 0000 00CB         temp2[i] = temp[i];
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
; 0000 00CC         keyword++;
	LDD  R30,Y+48
	LDD  R31,Y+48+1
	ADIW R30,1
	STD  Y+48,R30
	STD  Y+48+1,R31
; 0000 00CD         i++;
	__ADDWRN 16,17,1
; 0000 00CE     }
	RJMP _0x1D
_0x1F:
; 0000 00CF 
; 0000 00D0     time_start = time_s;
	MOVW R18,R12
; 0000 00D1 
; 0000 00D2     while (1) {
_0x20:
; 0000 00D3         if (time_s < time_start) {
	__CPWRR 12,13,18,19
	BRGE _0x23
; 0000 00D4             time_temp = time_s + 60;
	MOVW R30,R12
	ADIW R30,60
	MOVW R20,R30
; 0000 00D5             if (time_temp - time_start > time_out_s) {
	MOVW R26,R20
	CALL SUBOPT_0x4
	BRLT _0x22
; 0000 00D6             //    glcd_outtext("Timed out\r\n");
; 0000 00D7                 break;
; 0000 00D8             }
; 0000 00D9         } else {
	RJMP _0x25
_0x23:
; 0000 00DA             if (time_s - time_start > time_out_s) {
	MOVW R26,R12
	CALL SUBOPT_0x4
	BRLT _0x22
; 0000 00DB             //    glcd_outtext("Timed out\r\n");
; 0000 00DC                 break;
; 0000 00DD             }
; 0000 00DE         }
_0x25:
; 0000 00DF 
; 0000 00E0         if ((strstr(buff, temp)) || (strstr(buff, temp2))) {
	CALL SUBOPT_0x5
	MOVW R26,R28
	ADIW R26,28
	CALL _strstr
	SBIW R30,0
	BRNE _0x28
	CALL SUBOPT_0x5
	MOVW R26,R28
	ADIW R26,8
	CALL _strstr
	SBIW R30,0
	BREQ _0x27
_0x28:
; 0000 00E1             break;
	RJMP _0x22
; 0000 00E2         }
; 0000 00E3         if (strstr(buff, "ERROR")) {
_0x27:
	CALL SUBOPT_0x5
	__POINTW2MN _0x2B,0
	CALL _strstr
	SBIW R30,0
	BREQ _0x20
; 0000 00E4          //   glcd_outtext("Error found, attempting to continue..\r\n");
; 0000 00E5           /*  delay_ms(3000);
; 0000 00E6             glcd_clear();
; 0000 00E7             glcd_moveto(0,0); */
; 0000 00E8             break;
; 0000 00E9             //nen lam them ve cai nay nua
; 0000 00EA         }
; 0000 00EB     }
_0x22:
; 0000 00EC }
	CALL __LOADLOCR6
	ADIW R28,50
	RET
; .FEND

	.DSEG
_0x2B:
	.BYTE 0x6
;#define CE PORTA.3
;#define CSN PORTA.2
;#define SCK PORTA.4
;#define MOSI PORTA.1
;#define MISO PINA.5
;#define IRQ PINA.0
;
;unsigned char P_Add, Code_tay_cam1 = 0xA1, Code_tay_cam2 = 0xA2, Code_tay_cam3 = 0xA3, Code_tay_cam4 = 0xA4;
;#include "nrf_code.c"
;#define _BV(x) (1<<(x))
;#define RX_DR       6
;#define TX_DS       5
;#define MAX_RT      4
;#define STATUS      0x07
;
;typedef struct
;{
;    int flag;
;    float a;
;    float b;
;    float c;
;    float d;
;}data;
;
;
;typedef struct
;{
;    int flag;
;    int light;
;    int humi;
;    int temp;
;    int sm;
;}station_info;
;
;typedef struct
;{
;    int analog_l;
;    int analog_r;
;    int digital_l;
;    int digital_r;
;}tay_cam_info;
;
;station_info station_receive;
;tay_cam_info tay_cam_receive;
;
;data data_receive;
;unsigned char data_receive_2;
;unsigned char result;
;
;
;void config();
;
;
;//-----------------------------TX Mode -----------------------------------------------//
;unsigned char SPI_RW_TX(unsigned char Buff);                                       //Function used for text moving
;void RF_Init_TX();                                                                 //Function allow to Initialize RF dev ...
;unsigned char RF_Write_TX(unsigned char Reg_Add, unsigned char Value);                      //Function to write a value  ...
;void RF_Write_Address_TX(unsigned char Address);                                   //Function to write TX address for pi ...
;void RF_Write_Address_2_TX(unsigned char Address);                                 //Function to write TX address for pi ...
;void RX_Mode_Active_TX();                                                          //Function to put nRF in RX mode
;void TX_Mode_Active_TX();                                                          //Function to put nRF in TX mode
;void RF_Config_TX();                                                               //Function to config the nRF
;void RF_TX_Send_TX(data send);                                                     //Function to send data Value to RX A ...
;void RF_TX_Send_2_TX(data send);                                                   //Function to send data Value to RX a ...
;
;
;//---------------------------------RX Mode----------------------------------------------//
;unsigned char SPI_RW_RX(unsigned char Buff);                                       //Function used for text moving
;unsigned char SPI_Read_RX(void);
;void RF_Init_RX();                                                                 //Function allow to Initialize RF dev ...
;void RF_Write_RX(unsigned char Reg_Add, unsigned char Value);                      //Function to write a value to a regi ...
;void RF_Command_RX(unsigned char command);                                         //Function to write a command
;void RF_Write_Address_RX(unsigned char Address1, unsigned char Address2, unsigned char Address3, unsigned char Address4) ...
;void RX_Mode_RX();                                                          //Function to put nRF in RX mode
;void RF_Config_RX();                                                               //Function to config the nRF
;void RF_Read_RX();                                                     //Function to read the data from RX FIFO
;void RF_Write2_RX(unsigned char Reg_Add, unsigned char Value);
;void RF_Write3_RX(unsigned char Reg_Add, unsigned char Value);
;void RF_Read_RX_2();
;
;
;
;
;void config()
; 0000 00F5 {

	.CSEG
_config:
; .FSTART _config
;RF_Write_RX(0x07,0b01111110);  // Clear flag
	CALL SUBOPT_0x6
;RF_Command_RX(0b11100010);     //Flush RX
;delay_us(10);
	__DELAY_USB 27
;RF_Write_TX(0x00,0b00011111);     //CONFIG 0x00
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(31)
	RCALL _RF_Write_TX
;delay_ms(2);
	LDI  R26,LOW(2)
	LDI  R27,0
	CALL _delay_ms
;RF_Write_TX(0x07,0b01111110);
	LDI  R30,LOW(7)
	ST   -Y,R30
	LDI  R26,LOW(126)
	RCALL _RF_Write_TX
;RF_Write_TX(0x1D, 0b00000100);
	LDI  R30,LOW(29)
	ST   -Y,R30
	LDI  R26,LOW(4)
	RCALL _RF_Write_TX
;RF_Write_TX(0x05,0b00000010);     //RF_CH 0x05        Choose frequency channel
	LDI  R30,LOW(5)
	ST   -Y,R30
	LDI  R26,LOW(2)
	RCALL _RF_Write_TX
;}
	RET
; .FEND
;
;
;
;unsigned char SPI_RW_TX(unsigned char Buff){
_SPI_RW_TX:
; .FSTART _SPI_RW_TX
;    unsigned char bit_ctr;
;       for(bit_ctr=0;bit_ctr<8;bit_ctr++) // output 8-bit
	ST   -Y,R26
	ST   -Y,R17
;	Buff -> Y+1
;	bit_ctr -> R17
	LDI  R17,LOW(0)
_0x31:
	CPI  R17,8
	BRSH _0x32
;       {
;        MOSI = (Buff & 0x80);         // output 'uchar', MSB to MOSI
	LDD  R30,Y+1
	ANDI R30,LOW(0x80)
	BRNE _0x33
	CBI  0x1B,1
	RJMP _0x34
_0x33:
	SBI  0x1B,1
_0x34:
;        delay_us(5);
	CALL SUBOPT_0x7
;        Buff = (Buff << 1);           // shift next bit into MSB..
;        SCK = 1;                      // Set SCK high..
;        delay_us(5);
;        Buff |= MISO;                 // capture current MISO bit
;        SCK = 0;                      // ..then set SCK low again
;       }
	SUBI R17,-1
	RJMP _0x31
_0x32:
;    return(Buff);                     // return read uchar
	LDD  R30,Y+1
	LDD  R17,Y+0
	JMP  _0x216000C
;}
; .FEND
;
;void RF_Init_TX()                                                    //Function allow to Initialize RF device
;{
;    CE=1;
;    delay_us(700);
;    CE=0;
;    CSN=1;
;}
;
;unsigned char RF_Write_TX(unsigned char Reg_Add, unsigned char Value)         //Function to write a value to a register  ...
;{
_RF_Write_TX:
; .FSTART _RF_Write_TX
;
;    CSN=0;
	CALL SUBOPT_0x8
;	Reg_Add -> Y+1
;	Value -> Y+0
;    result = SPI_RW_TX(0b00100000|Reg_Add);
	RCALL _SPI_RW_TX
	STS  _result,R30
;    SPI_RW_TX(Value);
	LD   R26,Y
	RCALL _SPI_RW_TX
;    CSN=1;
	CALL SUBOPT_0x9
;    delay_us(10);
;	return result;
	LDS  R30,_result
	JMP  _0x216000C
;}
; .FEND
;
;void RF_Write_Address_TX(unsigned char Address)                      //Function to write TX and RX address
;{
;    CSN=0;
;	Address -> Y+0
;    RF_Write_TX(0x03,0b00000011);
;    CSN=1;
;    delay_us(10);
;    CSN=0;
;    SPI_RW_TX(0b00100000|0x0A);
;    SPI_RW_TX(Address);
;    SPI_RW_TX(Address);
;    SPI_RW_TX(Address);
;    SPI_RW_TX(Address);
;    SPI_RW_TX(Address);
;    CSN=1;
;    delay_us(10);
;    CSN=0;
;    SPI_RW_TX(0b00100000|0x10);
;    SPI_RW_TX(Address);
;    SPI_RW_TX(Address);
;    SPI_RW_TX(Address);
;    SPI_RW_TX(Address);
;    SPI_RW_TX(Address);
;
;    CSN=1;
;    delay_us(10);
;}
;
;void RF_Write_Address_TX_2(unsigned char Address)                      //Function to write TX and RX address
;{
;    CSN=0;
;	Address -> Y+0
;    RF_Write_TX(0x03,0b00000011);
;    CSN=1;
;    delay_us(10);
;    CSN=0;
;    SPI_RW_TX(0b00100000|0x0A);
;    SPI_RW_TX(Address);
;    SPI_RW_TX(0x02);
;    SPI_RW_TX(0x02);
;    SPI_RW_TX(0x02);
;    SPI_RW_TX(0x02);
;    CSN=1;
;    delay_us(10);
;    CSN=0;
;    SPI_RW_TX(0b00100000|0x10);
;    SPI_RW_TX(Address);
;    SPI_RW_TX(0x02);
;    SPI_RW_TX(0x02);
;    SPI_RW_TX(0x02);
;    SPI_RW_TX(0x02);
;
;    CSN=1;
;    delay_us(10);
;}
;
;void RF_Mode_TX()                                             //Function to put nRF in TX mode
;{
;    CE=0;
;    RF_Write_TX(0x00,0b00011110);     //CONFIG 0x00
;}
;
;void RF_Config_TX()                                                  //Function to config the nRF
;{
;
;RF_Write_TX(0x1C,0b00000001);
;RF_Write_Address_TX(P_Add);
;RF_Write_TX(0x02,0b00000001);     //EX_RXADDR 0x02    enable data pipe 0;
;RF_Write_TX(0x01,0b00000001);     //EN_AA 0x01        enable auto-acknowledgment
;}
;
;void RF_Config_TX_2()                                                  //Function to config the nRF
;{
;
;RF_Write_TX(0x1C,0b00000001);
;RF_Write_Address_TX_2(P_Add);
;RF_Write_TX(0x02,0b00000001);     //EX_RXADDR 0x02    enable data pipe 0;
;RF_Write_TX(0x01,0b00000001);     //EN_AA 0x01        enable auto-acknowledgment
;}
;
;void RF_Command_TX(unsigned char command)                            //Function to write a command
;{
;    CSN=0;
;	command -> Y+0
;    SPI_RW_TX(command);
;    CSN=1;
;    delay_us(10);
;}
;
;void RF_Send_TX(station_info send)     //Function to send data Value to a specify RX Address
;{
;
;  RF_Write_Address_TX(P_Add);
;	send -> Y+0
;  CSN=1;
;  delay_us(10);
;  CSN=0;
;  SPI_RW_TX(0b11100001);
;  CSN=1;
;  delay_us(10);
;  CSN=0;
;  SPI_RW_TX(0b10100000);
;  SPI_RW_TX(send.flag);
;  SPI_RW_TX(send.light);
;  SPI_RW_TX(send.humi);
;  SPI_RW_TX(send.temp);
;  SPI_RW_TX(send.sm);
;  CSN=1;
;  CE=1;
;  delay_us(500);
;  CE=0;
;  RF_Write_TX(0x07,0b01111110);
;  RF_Write_Address_TX(P_Add);
;  RF_Command_TX(0b11100001);
;
;  /*status = RF_Write_TX(0x07,0b00111000); //0b00111000
;  tx_ok = status & 0b00010000;
;  return tx_ok; */
;}
;
;void RF_Send_TX_2(data send)     //Function to send data Value to a specify RX Address
;{
;
;  RF_Write_Address_TX_2(P_Add);
;	send -> Y+0
;  CSN=1;
;  delay_us(10);
;  CSN=0;
;  SPI_RW_TX(0b11100001);
;  CSN=1;
;  delay_us(10);
;  CSN=0;
;  SPI_RW_TX(0b10100000);
;  SPI_RW_TX(send.flag);
;  SPI_RW_TX(send.a);
;  SPI_RW_TX(send.b);
;  SPI_RW_TX(send.c);
;  SPI_RW_TX(send.d);
;  CSN=1;
;  CE=1;
;  delay_us(500);
;  CE=0;
;  RF_Write_TX(0x07,0b01111110);
;  RF_Write_Address_TX_2(P_Add);
;  RF_Command_TX(0b11100001);
;
;  /*status = RF_Write_TX(0x07,0b00111000); //0b00111000
;  tx_ok = status & 0b00010000;
;  return tx_ok; */
;}
;
;
;
;//--------------------------------------------RX function------------------------------------//
;unsigned char SPI_RW_RX(unsigned char Buff)
;{
_SPI_RW_RX:
; .FSTART _SPI_RW_RX
;    unsigned char bit_ctr;
;       for(bit_ctr=0;bit_ctr<8;bit_ctr++) // output 8-bit
	ST   -Y,R26
	ST   -Y,R17
;	Buff -> Y+1
;	bit_ctr -> R17
	LDI  R17,LOW(0)
_0x7E:
	CPI  R17,8
	BRSH _0x7F
;       {
;        MOSI = (Buff & 0x80);         // output 'uchar', MSB to MOSI
	LDD  R30,Y+1
	ANDI R30,LOW(0x80)
	BRNE _0x80
	CBI  0x1B,1
	RJMP _0x81
_0x80:
	SBI  0x1B,1
_0x81:
;        delay_us(5);
	CALL SUBOPT_0x7
;        Buff = (Buff << 1);           // shift next bit into MSB..
;        SCK = 1;                      // Set SCK high..
;        delay_us(5);
;        Buff |= MISO;                 // capture current MISO bit
;        SCK = 0;                      // ..then set SCK low again
;       }
	SUBI R17,-1
	RJMP _0x7E
_0x7F:
;    return(Buff);                     // return read uchar
	LDD  R30,Y+1
	LDD  R17,Y+0
	JMP  _0x216000C
;}
; .FEND
;
;unsigned char SPI_Read_RX(void)
;{   unsigned char Buff=0;
_SPI_Read_RX:
; .FSTART _SPI_Read_RX
;    unsigned char bit_ctr;
;       for(bit_ctr=0;bit_ctr<8;bit_ctr++) // output 8-bit
	ST   -Y,R17
	ST   -Y,R16
;	Buff -> R17
;	bit_ctr -> R16
	LDI  R17,0
	LDI  R16,LOW(0)
_0x87:
	CPI  R16,8
	BRSH _0x88
;       {
;        delay_us(5);
	__DELAY_USB 13
;        Buff = (Buff << 1);           // shift next bit into MSB..
	LSL  R17
;        SCK = 1;                      // Set SCK high..
	SBI  0x1B,4
;        delay_us(5);
	__DELAY_USB 13
;        Buff |= MISO;                 // capture current MISO bit
	LDI  R30,0
	SBIC 0x19,5
	LDI  R30,1
	OR   R17,R30
;        SCK = 0;                      // ..then set SCK low again
	CBI  0x1B,4
;       }
	SUBI R16,-1
	RJMP _0x87
_0x88:
;    return(Buff);                     // return read uchar
	MOV  R30,R17
	LD   R16,Y+
	LD   R17,Y+
	RET
;}
; .FEND
;
;void RF_Init_RX()                                                    //Function allow to Initialize RF device
;{
_RF_Init_RX:
; .FSTART _RF_Init_RX
;    CE=1;
	SBI  0x1B,3
;    delay_us(700);
	__DELAY_USW 1400
;    CE=0;
	CBI  0x1B,3
;    CSN=1;
	SBI  0x1B,2
;}
	RET
; .FEND
;
;void RF_Write_RX(unsigned char Reg_Add, unsigned char Value)         //Function to write a value to a register address
;{
_RF_Write_RX:
; .FSTART _RF_Write_RX
;    CSN=0;
	CALL SUBOPT_0x8
;	Reg_Add -> Y+1
;	Value -> Y+0
;    SPI_RW_RX(0b00100000|Reg_Add);
	CALL SUBOPT_0xA
;    SPI_RW_RX(Value);
;    CSN=1;
	CALL SUBOPT_0x9
;    delay_us(10);
;}
	JMP  _0x216000C
; .FEND
;
;void RF_Write2_RX(unsigned char Reg_Add, unsigned char Value)         //Function to write a value to a register address
;{
_RF_Write2_RX:
; .FSTART _RF_Write2_RX
;    CSN=0;
	CALL SUBOPT_0x8
;	Reg_Add -> Y+1
;	Value -> Y+0
;    SPI_RW_RX(0b00100000|Reg_Add);
	CALL SUBOPT_0xA
;    SPI_RW_RX(Value);
;    SPI_RW_RX(Value);
	LD   R26,Y
	CALL SUBOPT_0xA
;    SPI_RW_RX(Value);
;    SPI_RW_RX(Value);
	LD   R26,Y
	CALL SUBOPT_0xA
;    SPI_RW_RX(Value);
;    CSN=1;
	CALL SUBOPT_0x9
;    delay_us(10);
;}
	JMP  _0x216000C
; .FEND
;
;void RF_Write3_RX(unsigned char Reg_Add, unsigned char Value)         //Function to write a value to a register address
;{
_RF_Write3_RX:
; .FSTART _RF_Write3_RX
;    CSN=0;
	CALL SUBOPT_0x8
;	Reg_Add -> Y+1
;	Value -> Y+0
;    SPI_RW_RX(0b00100000|Reg_Add);
	CALL SUBOPT_0xB
;    SPI_RW_RX(Code_tay_cam2);
	CALL SUBOPT_0xB
;    SPI_RW_RX(Code_tay_cam2);
	CALL SUBOPT_0xB
;    SPI_RW_RX(Code_tay_cam2);
	CALL SUBOPT_0xB
;    SPI_RW_RX(Code_tay_cam2);
	CALL SUBOPT_0xA
;    SPI_RW_RX(Value);
;
;
;    CSN=1;
	CALL SUBOPT_0x9
;    delay_us(10);
;}
	JMP  _0x216000C
; .FEND
;
;void RF_Command_RX(unsigned char command)                            //Function to write a command
;{
_RF_Command_RX:
; .FSTART _RF_Command_RX
;    CSN=0;
	ST   -Y,R26
;	command -> Y+0
	CBI  0x1B,2
;    SPI_RW_RX(command);
	LD   R26,Y
	RCALL _SPI_RW_RX
;    CSN=1;
	CALL SUBOPT_0x9
;    delay_us(10);
;}
	JMP  _0x216000B
; .FEND
;
;void RF_Write_Address_RX(unsigned char Address1, unsigned char Address2, unsigned char Address3, unsigned char Address4) ...
;{
_RF_Write_Address_RX:
; .FSTART _RF_Write_Address_RX
;    CSN=0;
	ST   -Y,R26
;	Address1 -> Y+3
;	Address2 -> Y+2
;	Address3 -> Y+1
;	Address4 -> Y+0
	CBI  0x1B,2
;    RF_Write_RX(0x03,0b00000011);
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDI  R26,LOW(3)
	RCALL _RF_Write_RX
;    CSN=1;
	CALL SUBOPT_0x9
;    delay_us(10);
;    CSN=0;
	CBI  0x1B,2
;    RF_Write2_RX(0x0A, Address1);
	LDI  R30,LOW(10)
	ST   -Y,R30
	LDD  R26,Y+4
	RCALL _RF_Write2_RX
;    RF_Write2_RX(0x10, Address1);
	LDI  R30,LOW(16)
	ST   -Y,R30
	LDD  R26,Y+4
	RCALL _RF_Write2_RX
;
;    RF_Write3_RX(0x0B, Address2);
	LDI  R30,LOW(11)
	ST   -Y,R30
	LDD  R26,Y+3
	CALL SUBOPT_0xC
;    RF_Write3_RX(0x10, Address2);
	LDD  R26,Y+3
	RCALL _RF_Write3_RX
;
;    RF_Write3_RX(0x0C, Address3);
	LDI  R30,LOW(12)
	ST   -Y,R30
	LDD  R26,Y+2
	CALL SUBOPT_0xC
;    RF_Write3_RX(0x10, Address3);
	LDD  R26,Y+2
	RCALL _RF_Write3_RX
;
;    RF_Write3_RX(0x0D, Address4);
	LDI  R30,LOW(13)
	ST   -Y,R30
	LDD  R26,Y+1
	CALL SUBOPT_0xC
;    RF_Write3_RX(0x10, Address4);
	LDD  R26,Y+1
	RCALL _RF_Write3_RX
;
;}
	JMP  _0x216000A
; .FEND
;
;void RF_Write_Address_RX_2(unsigned char Address1){
;    CSN=0;
;	Address1 -> Y+0
;    RF_Write_RX(0x03,0b00000011);
;    CSN=1;
;    delay_us(10);
;    CSN=0;
;
;    RF_Write2_RX(0x0A, Address1);
;    RF_Write2_RX(0x10, Address1);
;}
;
;
;void RF_Mode_RX()                                             //Function to put nRF in RX mode
;{
_RF_Mode_RX:
; .FSTART _RF_Mode_RX
;    RF_Write_RX(0x00,0b00011111);     //CONFIG 0x00
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(31)
	RCALL _RF_Write_RX
;    CE=1;
	SBI  0x1B,3
;}
	RET
; .FEND
;
;void RF_Config_RX()                                                  //Function to config the nRF
;{
_RF_Config_RX:
; .FSTART _RF_Config_RX
;RF_Write_RX(0x1C,0b00001111);
	LDI  R30,LOW(28)
	CALL SUBOPT_0xD
;RF_Write_Address_RX(Code_tay_cam1, Code_tay_cam2, Code_tay_cam3, Code_tay_cam4);
	LDS  R30,_Code_tay_cam1
	ST   -Y,R30
	LDS  R30,_Code_tay_cam2
	ST   -Y,R30
	LDS  R30,_Code_tay_cam3
	ST   -Y,R30
	LDS  R26,_Code_tay_cam4
	RCALL _RF_Write_Address_RX
;RF_Write_RX(0x02,0b00001111);     //EX_RXADDR 0x02    enable data pipe 0;
	LDI  R30,LOW(2)
	CALL SUBOPT_0xD
;RF_Write_RX(0x01,0b00001111);     //EN_AA 0x01        enable auto-acknowledgment
	LDI  R30,LOW(1)
	CALL SUBOPT_0xD
;}
	RET
; .FEND
;
;void RF_Config_RX_2(){
;    RF_Write_RX(0x1C,0b00001111);
;    RF_Write_Address_RX_2(Code_tay_cam1);
;    RF_Write_RX(0x02,0b00000001);     //EX_RXADDR 0x02    enable data pipe 0;
;    RF_Write_RX(0x01,0b00000001);     //EN_AA 0x01        enable auto-acknowledgment
;}
;
;void RF_Config_RX_3(){
;RF_Write_RX(0x11,0b00000001);     //RX_PW_P0 0x11     Payload size
;RF_Write_Address_RX_2(Code_tay_cam1);
;RF_Write_RX(0x02,0b00000001);     //EX_RXADDR 0x02    enable data pipe 0;
;RF_Write_RX(0x01,0b00000001);     //EN_AA 0x01        enable auto-acknowledgment
;RF_Write_RX(0x04,0b00000000);     //SETUP_RETR 0x04   Setup retry time
;}
;
;void RF_Read_RX()                                         //Function to read the data from RX FIFO
;{
;   CE=0;
;   CSN=1;
;   delay_us(10);
;   CSN=0;
;   SPI_RW_RX(0b01100001);
;   delay_us(10);
;   data_receive.flag = SPI_Read_RX();
;   data_receive.a = SPI_Read_RX();
;   data_receive.b = SPI_Read_RX();
;   data_receive.c = SPI_Read_RX();
;   data_receive.d = SPI_Read_RX();
;   CSN=1;
;   CE=1;
;   RF_Write_RX(0x07,0b01111110);  // Clear flag
;   RF_Command_RX(0b11100010);     //Flush RX
;}
;
;void RF_Read_RX_2(){
;    CE=0;
;    CSN=1;
;    delay_us(10);
;    CSN=0;
;    SPI_RW_RX(0b01100001);
;    delay_us(10);
;    tay_cam_receive.analog_l = SPI_Read_RX();
;    tay_cam_receive.analog_r = SPI_Read_RX();
;    tay_cam_receive.digital_l = SPI_Read_RX();
;    tay_cam_receive.digital_r = SPI_Read_RX();
;    CSN=1;
;    CE=1;
;    RF_Write_RX(0x07,0b01111110);  // Clear flag
;    RF_Command_RX(0b11100010);     //Flush RX
;}
;
;void RF_Read_RX_3()                                         //Function to read the data from RX FIFO
;{
_RF_Read_RX_3:
; .FSTART _RF_Read_RX_3
;   CE=0;
	CBI  0x1B,3
;   CSN=1;
	CALL SUBOPT_0x9
;   delay_us(10);
;   CSN=0;
	CBI  0x1B,2
;   SPI_RW_RX(0b01100001);
	LDI  R26,LOW(97)
	RCALL _SPI_RW_RX
;   delay_us(10);
	__DELAY_USB 27
;   station_receive.flag = SPI_Read_RX();
	RCALL _SPI_Read_RX
	LDI  R31,0
	STS  _station_receive,R30
	STS  _station_receive+1,R31
;   station_receive.light = SPI_Read_RX();
	RCALL _SPI_Read_RX
	__POINTW2MN _station_receive,2
	CALL SUBOPT_0xE
;   station_receive.humi = SPI_Read_RX();
	__POINTW2MN _station_receive,4
	CALL SUBOPT_0xE
;   station_receive.temp = SPI_Read_RX();
	__POINTW2MN _station_receive,6
	CALL SUBOPT_0xE
;   station_receive.sm = SPI_Read_RX();
	__POINTW2MN _station_receive,8
	LDI  R31,0
	ST   X+,R30
	ST   X,R31
;   CSN=1;
	SBI  0x1B,2
;   CE=1;
	SBI  0x1B,3
;   RF_Write_RX(0x07,0b01111110);  // Clear flag
	CALL SUBOPT_0x6
;   RF_Command_RX(0b11100010);     //Flush RX
;}
	RET
; .FEND
;
;bool flag;
;unsigned char* key[] = {"", "7R6NSYFHBFRUAR6K", "5I000WROXOFS0V85", "6NHFXH076SC02DZ0", "WUIT8LX7N92X8J4W"};

	.DSEG
_0xCF:
	.BYTE 0x45
;char cmd[250];
;station_info data_send;
;#include "s_function.c"
;void border()
; 0000 00FB {

	.CSEG
_border:
; .FSTART _border
;    glcd_line(48,0, 48, 15);
	LDI  R30,LOW(48)
	ST   -Y,R30
	LDI  R30,LOW(0)
	CALL SUBOPT_0xF
;    glcd_line(0, 15, 48, 15);
	LDI  R30,LOW(15)
	CALL SUBOPT_0xF
;    glcd_line(0,0,84,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(84)
	ST   -Y,R30
	LDI  R26,LOW(0)
	CALL _glcd_line
;    glcd_line(84,0, 84, 48);
	LDI  R30,LOW(84)
	ST   -Y,R30
	LDI  R30,LOW(0)
	CALL SUBOPT_0x10
;    glcd_line(0, 48, 84, 48);
	LDI  R30,LOW(48)
	CALL SUBOPT_0x10
;    glcd_line(0, 0, 0, 48);
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	LDI  R26,LOW(48)
	CALL _glcd_line
;    glcd_moveto(3,3);
	LDI  R30,LOW(3)
	CALL SUBOPT_0x11
;    glcd_outtext("Node: ");
	__POINTW2MN _0xD1,0
	CALL SUBOPT_0x12
;   // glcd_moveto(40, 3);
;   // glcd_outtext("4");
;
;    glcd_moveto(4, 18);
	LDI  R26,LOW(18)
	CALL _glcd_moveto
;    glcd_outtext("Temp: ");
	__POINTW2MN _0xD1,7
	CALL SUBOPT_0x12
;    glcd_moveto(4, 28);
	LDI  R26,LOW(28)
	CALL _glcd_moveto
;    glcd_outtext("Humid: ");
	__POINTW2MN _0xD1,14
	CALL SUBOPT_0x12
;    glcd_moveto(4, 37);
	LDI  R26,LOW(37)
	CALL _glcd_moveto
;    glcd_outtext("Water: ");
	__POINTW2MN _0xD1,22
	CALL _glcd_outtext
;    glcd_moveto(68, 18);
	LDI  R30,LOW(68)
	CALL SUBOPT_0x13
;    glcd_outtext("!C");
	__POINTW2MN _0xD1,30
	CALL _glcd_outtext
;    glcd_moveto(69, 28);
	LDI  R30,LOW(69)
	CALL SUBOPT_0x14
;    glcd_putchar(37);
	LDI  R26,LOW(37)
	CALL _glcd_putchar
;    glcd_moveto(69, 37);
	LDI  R30,LOW(69)
	CALL SUBOPT_0x15
;    glcd_outtext("cm");
	__POINTW2MN _0xD1,33
	CALL _glcd_outtext
;}
	RET
; .FEND

	.DSEG
_0xD1:
	.BYTE 0x24
;void temp()
;{

	.CSEG
;     glcd_moveto(50, 28);
;     glcd_outtext("21");
;     glcd_moveto(50, 18);
;     glcd_outtext("75");
;     glcd_moveto(50, 37);
;     glcd_outtext("45");
;}

	.DSEG
_0xD2:
	.BYTE 0x9
;void wifi_connect()
;{

	.CSEG
_wifi_connect:
; .FSTART _wifi_connect
;	glcd_moveto(10,10);
	LDI  R30,LOW(10)
	ST   -Y,R30
	LDI  R26,LOW(10)
	CALL _glcd_moveto
;    glcd_clear();
	CALL _glcd_clear
;    glcd_outtext("Booting");
	__POINTW2MN _0xD3,0
	CALL _glcd_outtext
;    delay_ms(2000);
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	CALL _delay_ms
;	put_string("AT\r\n");
	__POINTW2MN _0xD3,8
	RCALL _put_string
;    wait_until("OK", 2);
	__POINTW1MN _0xD3,13
	CALL SUBOPT_0x16
;    refresh(0);
;	delay_ms(100);
	LDI  R26,LOW(100)
	LDI  R27,0
	CALL _delay_ms
;        put_string("AT+CIPSTATUS\r\n");
	__POINTW2MN _0xD3,16
	RCALL _put_string
;        wait_until("OK", 2);
	__POINTW1MN _0xD3,31
	CALL SUBOPT_0x16
;        refresh(0);
;        if (strstr(buff, "STATUS:2")) {
	CALL SUBOPT_0x5
	__POINTW2MN _0xD3,34
	CALL _strstr
	SBIW R30,0
	BREQ _0xD4
;            glcd_outtext("Wifi Connected\r\n");
	__POINTW2MN _0xD3,43
	CALL _glcd_outtext
;        }
;        else
	RJMP _0xD5
_0xD4:
;        {
;            put_string("AT+CWMODE=1\r\n");
	__POINTW2MN _0xD3,60
	RCALL _put_string
;            wait_until("OK", 2);
	__POINTW1MN _0xD3,74
	CALL SUBOPT_0x17
;           // refresh(0);
;            put_string("AT+CWJAP=\"Thay_Thao_deo_giai\",\"chinhxac\"\r\n");
	__POINTW2MN _0xD3,77
	RCALL _put_string
;            wait_until("OK", 10);
	__POINTW1MN _0xD3,120
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(10)
	LDI  R27,0
	RCALL _wait_until
;            refresh(0);
	LDI  R26,LOW(0)
	LDI  R27,0
	RCALL _refresh
;         //PORTA.6=!PORTA.6;
;        }
_0xD5:
;
;  //  refresh(0);
;}
	RET
; .FEND

	.DSEG
_0xD3:
	.BYTE 0x7B
;
;void read_and_send(unsigned char *s){
; 0000 00FC void read_and_send(unsigned char *s){

	.CSEG
_read_and_send:
; .FSTART _read_and_send
; 0000 00FD     // Thay nhung ham respones_read bang ham wait_until
; 0000 00FE     char api_key[20], cmd[] = "GET /update?key=", temp[20], temp2[20];
; 0000 00FF     int length = 0, i = 0;
; 0000 0100     memset(api_key, '\0',20);
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,63
	SBIW R28,14
	LDI  R24,17
	LDI  R26,LOW(40)
	LDI  R27,HIGH(40)
	LDI  R30,LOW(_0xD6*2)
	LDI  R31,HIGH(_0xD6*2)
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
	MOVW R30,R28
	ADIW R30,61
	CALL SUBOPT_0x18
; 0000 0101     memset(temp, '\0',20);
	MOVW R30,R28
	ADIW R30,24
	CALL SUBOPT_0x18
; 0000 0102     memset(temp2, '\0',20);
	MOVW R30,R28
	ADIW R30,4
	CALL SUBOPT_0x18
; 0000 0103 
; 0000 0104     while (*s) {
_0xD7:
	CALL SUBOPT_0x19
	CPI  R30,0
	BREQ _0xD9
; 0000 0105         temp2[i] = *s;
	MOVW R30,R18
	MOVW R26,R28
	ADIW R26,4
	ADD  R30,R26
	ADC  R31,R27
	MOVW R22,R30
	CALL SUBOPT_0x19
	MOVW R26,R22
	ST   X,R30
; 0000 0106         api_key[i] = temp2[i];
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
; 0000 0107         s++;
	MOVW R26,R28
	SUBI R26,LOW(-(81))
	SBCI R27,HIGH(-(81))
	CALL SUBOPT_0x0
; 0000 0108         i++;
	__ADDWRN 18,19,1
; 0000 0109     }
	RJMP _0xD7
_0xD9:
; 0000 010A     put_string("AT+CIPMUX=1");
	__POINTW2MN _0xDA,0
	CALL SUBOPT_0x1A
; 0000 010B     delay_ms(300);
; 0000 010C     put_string("\r\n");
	__POINTW2MN _0xDA,12
	RCALL _put_string
; 0000 010D     wait_until("OK", 2);
	__POINTW1MN _0xDA,15
	CALL SUBOPT_0x17
; 0000 010E     refresh(10);
	LDI  R26,LOW(10)
	LDI  R27,0
	RCALL _refresh
; 0000 010F 
; 0000 0110     put_string("AT+CIPSTART=0,\"TCP\",\"api.thingspeak.com\",80");
	__POINTW2MN _0xDA,18
	CALL SUBOPT_0x1A
; 0000 0111     delay_ms(300);
; 0000 0112     put_string("\r\n");
	__POINTW2MN _0xDA,62
	RCALL _put_string
; 0000 0113     wait_until("OK", 20);
	__POINTW1MN _0xDA,65
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(20)
	LDI  R27,0
	RCALL _wait_until
; 0000 0114     refresh(500);
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	RCALL _refresh
; 0000 0115 
; 0000 0116    // glcd_clear();
; 0000 0117   //  glcd_moveto(0,0);
; 0000 0118    // glcd_outtext("Server connected\r\n");
; 0000 0119 
; 0000 011A     strcat(cmd, api_key);
	CALL SUBOPT_0x1B
	MOVW R26,R28
	ADIW R26,63
	CALL SUBOPT_0x1C
; 0000 011B     strcat(cmd, "&field1=");
	__POINTW2MN _0xDA,68
	CALL _strcat
; 0000 011C 
; 0000 011D      itoa(station_receive.temp, temp);
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x1E
; 0000 011E 
; 0000 011F     //itoa(200, temp);
; 0000 0120     strcat(cmd, temp);
	CALL SUBOPT_0x1F
; 0000 0121 
; 0000 0122     strcat(cmd, "&field2=");
	__POINTW2MN _0xDA,77
	CALL _strcat
; 0000 0123      itoa(station_receive.humi, temp);
	CALL SUBOPT_0x20
	CALL SUBOPT_0x1E
; 0000 0124    // itoa(200, temp);
; 0000 0125     strcat(cmd, temp);
	CALL SUBOPT_0x1F
; 0000 0126 
; 0000 0127     strcat(cmd, "&field3=");
	__POINTW2MN _0xDA,86
	CALL _strcat
; 0000 0128      itoa(station_receive.sm, temp);
	CALL SUBOPT_0x21
	CALL SUBOPT_0x1E
; 0000 0129    // itoa(200, temp);
; 0000 012A     strcat(cmd, temp);
	CALL SUBOPT_0x1F
; 0000 012B 
; 0000 012C     strcat(cmd, "\r\n");
	__POINTW2MN _0xDA,95
	CALL _strcat
; 0000 012D 
; 0000 012E     length = strlen(cmd);
	MOVW R26,R28
	ADIW R26,44
	CALL _strlen
	MOVW R16,R30
; 0000 012F 
; 0000 0130     itoa(length, temp);
	ST   -Y,R17
	ST   -Y,R16
	MOVW R26,R28
	ADIW R26,26
	CALL _itoa
; 0000 0131 
; 0000 0132     put_string("AT+CIPSEND=0,");
	__POINTW2MN _0xDA,98
	RCALL _put_string
; 0000 0133     put_string(temp);
	MOVW R26,R28
	ADIW R26,24
	RCALL _put_string
; 0000 0134     delay_ms(500);
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	CALL _delay_ms
; 0000 0135     put_string("\r\n");
	__POINTW2MN _0xDA,112
	RCALL _put_string
; 0000 0136 
; 0000 0137     wait_until("> ", 5);
	__POINTW1MN _0xDA,115
	CALL SUBOPT_0x22
; 0000 0138 
; 0000 0139    /* glcd_clear();
; 0000 013A     glcd_moveto(0,0);
; 0000 013B     glcd_outtext(cmd);*/
; 0000 013C 
; 0000 013D     put_string(cmd);
	MOVW R26,R28
	ADIW R26,44
	RCALL _put_string
; 0000 013E     delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	CALL _delay_ms
; 0000 013F     putchar(0x1A);
	LDI  R26,LOW(26)
	RCALL _putchar
; 0000 0140 
; 0000 0141     refresh(10);
	LDI  R26,LOW(10)
	LDI  R27,0
	RCALL _refresh
; 0000 0142 	put_string("AT+CIPCLOSE=0\r\n");
	__POINTW2MN _0xDA,118
	RCALL _put_string
; 0000 0143 	wait_until("OK",5);
	__POINTW1MN _0xDA,134
	CALL SUBOPT_0x22
; 0000 0144 
; 0000 0145 }
	CALL __LOADLOCR4
	ADIW R28,63
	ADIW R28,20
	RET
; .FEND

	.DSEG
_0xDA:
	.BYTE 0x89
;
;
;void main(void) {
; 0000 0148 void main(void) {

	.CSEG
_main:
; .FSTART _main
; 0000 0149 {
; 0000 014A // Declare your local variables here
; 0000 014B // Variable used to store graphic display
; 0000 014C // controller initialization data
; 0000 014D     GLCDINIT_t glcd_init_data;
; 0000 014E 
; 0000 014F // Input/Output Ports initialization
; 0000 0150 // Port A initialization
; 0000 0151 DDRA=(0<<DDA7) | (1<<DDA6) | (0<<DDA5) | (1<<DDA4) | (1<<DDA3) | (1<<DDA2) | (1<<DDA1) | (0<<DDA0);
	SBIW R28,8
;	glcd_init_data -> Y+0
	LDI  R30,LOW(94)
	OUT  0x1A,R30
; 0000 0152 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0153 PORTA=(0<<PORTA7) | (0<<PORTA6) | (1<<PORTA5) | (1<<PORTA4) | (1<<PORTA3) | (1<<PORTA2) | (1<<PORTA1) | (1<<PORTA0);
	LDI  R30,LOW(63)
	OUT  0x1B,R30
; 0000 0154 
; 0000 0155 // Port B initialization
; 0000 0156 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0157     DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (1<<DDB3) | (1<<DDB2) | (0<<DDB1) | (0<<DDB0);
	LDI  R30,LOW(12)
	OUT  0x17,R30
; 0000 0158 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0159     PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (1<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(4)
	OUT  0x18,R30
; 0000 015A 
; 0000 015B // Port C initialization
; 0000 015C // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 015D     DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
	LDI  R30,LOW(0)
	OUT  0x14,R30
; 0000 015E // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 015F     PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (1<<PORTC3) | (1<<PORTC2) | (0<<PORTC1) | (1<<PORTC0);
	LDI  R30,LOW(13)
	OUT  0x15,R30
; 0000 0160 
; 0000 0161 // Port D initialization
; 0000 0162 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0163     DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	LDI  R30,LOW(0)
	OUT  0x11,R30
; 0000 0164 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0165     PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	OUT  0x12,R30
; 0000 0166 
; 0000 0167 // Port E initialization
; 0000 0168 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0169     DDRE=(0<<DDE7) | (0<<DDE6) | (0<<DDE5) | (0<<DDE4) | (0<<DDE3) | (0<<DDE2) | (0<<DDE1) | (0<<DDE0);
	OUT  0x2,R30
; 0000 016A // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 016B     PORTE=(0<<PORTE7) | (0<<PORTE6) | (0<<PORTE5) | (0<<PORTE4) | (0<<PORTE3) | (0<<PORTE2) | (0<<PORTE1) | (0<<PORTE0);
	OUT  0x3,R30
; 0000 016C 
; 0000 016D // Port F initialization
; 0000 016E // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 016F     DDRF=(0<<DDF7) | (0<<DDF6) | (0<<DDF5) | (0<<DDF4) | (0<<DDF3) | (0<<DDF2) | (0<<DDF1) | (0<<DDF0);
	STS  97,R30
; 0000 0170 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0171     PORTF=(0<<PORTF7) | (0<<PORTF6) | (0<<PORTF5) | (0<<PORTF4) | (0<<PORTF3) | (0<<PORTF2) | (0<<PORTF1) | (0<<PORTF0);
	STS  98,R30
; 0000 0172 
; 0000 0173 // Port G initialization
; 0000 0174 // Function: Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0175     DDRG=(0<<DDG4) | (0<<DDG3) | (0<<DDG2) | (0<<DDG1) | (0<<DDG0);
	STS  100,R30
; 0000 0176 // State: Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0177     PORTG=(0<<PORTG4) | (0<<PORTG3) | (0<<PORTG2) | (0<<PORTG1) | (0<<PORTG0);
	STS  101,R30
; 0000 0178 
; 0000 0179 // Timer/Counter 0 initialization
; 0000 017A // Clock source: System Clock
; 0000 017B // Clock value: 8000.000 kHz
; 0000 017C // Mode: Normal top=0xFF
; 0000 017D // OC0 output: Disconnected
; 0000 017E // Timer Period: 0.02 ms
; 0000 017F 
; 0000 0180         ASSR=0<<AS0;
	OUT  0x30,R30
; 0000 0181         TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (1<<CS00);
	LDI  R30,LOW(1)
	OUT  0x33,R30
; 0000 0182         TCNT0=0x60;
	LDI  R30,LOW(96)
	OUT  0x32,R30
; 0000 0183         OCR0=0x00;
	LDI  R30,LOW(0)
	OUT  0x31,R30
; 0000 0184 
; 0000 0185 // Timer/Counter 1 initialization
; 0000 0186 // Clock source: System Clock
; 0000 0187 // Clock value: Timer1 Stopped
; 0000 0188 // Mode: Normal top=0xFFFF
; 0000 0189 // OC1A output: Disconnected
; 0000 018A // OC1B output: Disconnected
; 0000 018B // OC1C output: Disconnected
; 0000 018C // Noise Canceler: Off
; 0000 018D // Input Capture on Falling Edge
; 0000 018E // Timer1 Overflow Interrupt: Off
; 0000 018F // Input Capture Interrupt: Off
; 0000 0190 // Compare A Match Interrupt: Off
; 0000 0191 // Compare B Match Interrupt: Off
; 0000 0192 // Compare C Match Interrupt: Off
; 0000 0193     TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<COM1C1) | (0<<COM1C0) | (0<<WGM11) | (0<<WGM10);
	OUT  0x2F,R30
; 0000 0194     TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
	OUT  0x2E,R30
; 0000 0195     TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 0196     TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 0197     ICR1H=0x00;
	OUT  0x27,R30
; 0000 0198     ICR1L=0x00;
	OUT  0x26,R30
; 0000 0199     OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 019A     OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 019B     OCR1BH=0x00;
	OUT  0x29,R30
; 0000 019C     OCR1BL=0x00;
	OUT  0x28,R30
; 0000 019D     OCR1CH=0x00;
	STS  121,R30
; 0000 019E     OCR1CL=0x00;
	STS  120,R30
; 0000 019F 
; 0000 01A0 // Timer/Counter 2 initialization
; 0000 01A1 // Clock source: System Clock
; 0000 01A2 // Clock value: Timer2 Stopped
; 0000 01A3 // Mode: Normal top=0xFF
; 0000 01A4 // OC2 output: Disconnected
; 0000 01A5     TCCR2=(0<<WGM20) | (0<<COM21) | (0<<COM20) | (0<<WGM21) | (0<<CS22) | (1<<CS21) | (1<<CS20);
	LDI  R30,LOW(3)
	OUT  0x25,R30
; 0000 01A6     TCNT2=0x83;   //1ms
	LDI  R30,LOW(131)
	OUT  0x24,R30
; 0000 01A7     OCR2=0x00;
	LDI  R30,LOW(0)
	OUT  0x23,R30
; 0000 01A8 
; 0000 01A9 // Timer/Counter 3 initialization
; 0000 01AA // Clock source: System Clock
; 0000 01AB // Clock value: Timer3 Stopped
; 0000 01AC // Mode: Normal top=0xFFFF
; 0000 01AD // OC3A output: Disconnected
; 0000 01AE // OC3B output: Disconnected
; 0000 01AF // OC3C output: Disconnected
; 0000 01B0 // Noise Canceler: Off
; 0000 01B1 // Input Capture on Falling Edge
; 0000 01B2 // Timer3 Overflow Interrupt: Off
; 0000 01B3 // Input Capture Interrupt: Off
; 0000 01B4 // Compare A Match Interrupt: Off
; 0000 01B5 // Compare B Match Interrupt: Off
; 0000 01B6 // Compare C Match Interrupt: Off
; 0000 01B7     TCCR3A=(0<<COM3A1) | (0<<COM3A0) | (0<<COM3B1) | (0<<COM3B0) | (0<<COM3C1) | (0<<COM3C0) | (0<<WGM31) | (0<<WGM30);
	STS  139,R30
; 0000 01B8     TCCR3B=(0<<ICNC3) | (0<<ICES3) | (0<<WGM33) | (0<<WGM32) | (0<<CS32) | (0<<CS31) | (0<<CS30);
	STS  138,R30
; 0000 01B9     TCNT3H=0x00;
	STS  137,R30
; 0000 01BA     TCNT3L=0x00;
	STS  136,R30
; 0000 01BB     ICR3H=0x00;
	STS  129,R30
; 0000 01BC     ICR3L=0x00;
	STS  128,R30
; 0000 01BD     OCR3AH=0x00;
	STS  135,R30
; 0000 01BE     OCR3AL=0x00;
	STS  134,R30
; 0000 01BF     OCR3BH=0x00;
	STS  133,R30
; 0000 01C0     OCR3BL=0x00;
	STS  132,R30
; 0000 01C1     OCR3CH=0x00;
	STS  131,R30
; 0000 01C2     OCR3CL=0x00;
	STS  130,R30
; 0000 01C3 
; 0000 01C4 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 01C5     TIMSK=(0<<OCIE2) | (1<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (1<<TOIE0);
	LDI  R30,LOW(65)
	OUT  0x37,R30
; 0000 01C6     ETIMSK=(0<<TICIE3) | (0<<OCIE3A) | (0<<OCIE3B) | (0<<TOIE3) | (0<<OCIE3C) | (0<<OCIE1C);
	LDI  R30,LOW(0)
	STS  125,R30
; 0000 01C7 
; 0000 01C8 // External Interrupt(s) initialization
; 0000 01C9 // INT0: Off
; 0000 01CA // INT1: Off
; 0000 01CB // INT2: Off
; 0000 01CC // INT3: Off
; 0000 01CD // INT4: Off
; 0000 01CE // INT5: Off
; 0000 01CF // INT6: Off
; 0000 01D0 // INT7: Off
; 0000 01D1     EICRA=(0<<ISC31) | (0<<ISC30) | (0<<ISC21) | (0<<ISC20) | (0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	STS  106,R30
; 0000 01D2     EICRB=(0<<ISC71) | (0<<ISC70) | (0<<ISC61) | (0<<ISC60) | (0<<ISC51) | (0<<ISC50) | (0<<ISC41) | (0<<ISC40);
	OUT  0x3A,R30
; 0000 01D3     EIMSK=(0<<INT7) | (0<<INT6) | (0<<INT5) | (0<<INT4) | (0<<INT3) | (0<<INT2) | (0<<INT1) | (0<<INT0);
	OUT  0x39,R30
; 0000 01D4 
; 0000 01D5 // USART0 initialization
; 0000 01D6 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 01D7 // USART0 Receiver: On
; 0000 01D8 // USART0 Transmitter: On
; 0000 01D9 // USART0 Mode: Asynchronous
; 0000 01DA // USART0 Baud Rate: 9600
; 0000 01DB     UCSR0A=(0<<RXC0) | (0<<TXC0) | (0<<UDRE0) | (0<<FE0) | (0<<DOR0) | (0<<UPE0) | (0<<U2X0) | (0<<MPCM0);
	OUT  0xB,R30
; 0000 01DC     UCSR0B=(1<<RXCIE0) | (1<<TXCIE0) | (0<<UDRIE0) | (1<<RXEN0) | (1<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);
	LDI  R30,LOW(216)
	OUT  0xA,R30
; 0000 01DD     UCSR0C=(0<<UMSEL0) | (0<<UPM01) | (0<<UPM00) | (0<<USBS0) | (1<<UCSZ01) | (1<<UCSZ00) | (0<<UCPOL0);
	LDI  R30,LOW(6)
	STS  149,R30
; 0000 01DE     UBRR0H=0x00;
	LDI  R30,LOW(0)
	STS  144,R30
; 0000 01DF     UBRR0L=0x33;
	LDI  R30,LOW(51)
	OUT  0x9,R30
; 0000 01E0 
; 0000 01E1 // USART1 initialization
; 0000 01E2 // USART1 disabled
; 0000 01E3     UCSR1B=(0<<RXCIE1) | (0<<TXCIE1) | (0<<UDRIE1) | (0<<RXEN1) | (0<<TXEN1) | (0<<UCSZ12) | (0<<RXB81) | (0<<TXB81);
	LDI  R30,LOW(0)
	STS  154,R30
; 0000 01E4 
; 0000 01E5 // Analog Comparator initialization
; 0000 01E6 // Analog Comparator: Off
; 0000 01E7 // The Analog Comparator's positive input is
; 0000 01E8 // connected to the AIN0 pin
; 0000 01E9 // The Analog Comparator's negative input is
; 0000 01EA // connected to the AIN1 pin
; 0000 01EB     ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 01EC     SFIOR=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 01ED 
; 0000 01EE // ADC initialization
; 0000 01EF // ADC disabled
; 0000 01F0     ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADFR) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
	OUT  0x6,R30
; 0000 01F1 
; 0000 01F2 // SPI initialization
; 0000 01F3 // SPI disabled
; 0000 01F4     SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0000 01F5 
; 0000 01F6 // TWI initialization
; 0000 01F7 // TWI disabled
; 0000 01F8     TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	STS  116,R30
; 0000 01F9 
; 0000 01FA     // Bit-Banged I2C Bus initialization
; 0000 01FB // I2C Port: PORTD
; 0000 01FC // I2C SDA bit: 1
; 0000 01FD // I2C SCL bit: 0
; 0000 01FE // Bit Rate: 100 kHz
; 0000 01FF // Note: I2C settings are specified in the
; 0000 0200 // Project|Configure|C Compiler|Libraries|I2C menu.
; 0000 0201 i2c_init();
	CALL _i2c_init
; 0000 0202 
; 0000 0203 // DS1307 Real Time Clock initialization
; 0000 0204 // Square wave output on pin SQW/OUT: On
; 0000 0205 // Square wave frequency: 32768Hz
; 0000 0206 rtc_init(3,1,0);
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R26,LOW(0)
	CALL _rtc_init
; 0000 0207 
; 0000 0208 // Graphic Display Controller initialization
; 0000 0209 // The PCD8544 connections are specified in the
; 0000 020A // Project|Configure|C Compiler|Libraries|Graphic Display menu:
; 0000 020B // SDIN - PORTC Bit 7
; 0000 020C // SCLK - PORTA Bit 7
; 0000 020D // D /C - PORTC Bit 6
; 0000 020E // /SCE - PORTC Bit 5
; 0000 020F // /RES - PORTC Bit 4
; 0000 0210 
; 0000 0211 // Specify the current font for displaying text
; 0000 0212     glcd_init_data.font=font5x7;
	LDI  R30,LOW(_font5x7*2)
	LDI  R31,HIGH(_font5x7*2)
	ST   Y,R30
	STD  Y+1,R31
; 0000 0213 // No function is used for reading
; 0000 0214 // image data from external memory
; 0000 0215     glcd_init_data.readxmem=NULL;
	LDI  R30,LOW(0)
	STD  Y+2,R30
	STD  Y+2+1,R30
; 0000 0216 // No function is used for writing
; 0000 0217 // image data to external memory
; 0000 0218     glcd_init_data.writexmem=NULL;
	STD  Y+4,R30
	STD  Y+4+1,R30
; 0000 0219 // Set the LCD temperature coefficient
; 0000 021A     glcd_init_data.temp_coef=90;
	LDD  R30,Y+6
	ANDI R30,LOW(0xFC)
	ORI  R30,2
	STD  Y+6,R30
; 0000 021B // Set the LCD bias
; 0000 021C     glcd_init_data.bias=3;
	ANDI R30,LOW(0xE3)
	ORI  R30,LOW(0xC)
	STD  Y+6,R30
; 0000 021D // Set the LCD contrast control voltage VLCD
; 0000 021E     glcd_init_data.vlcd=55;
	LDD  R30,Y+7
	ANDI R30,LOW(0x80)
	ORI  R30,LOW(0x37)
	STD  Y+7,R30
; 0000 021F 
; 0000 0220     glcd_init(&glcd_init_data);
	MOVW R26,R28
	CALL _glcd_init
; 0000 0221 
; 0000 0222 // Global enable interrupts
; 0000 0223 #asm("sei")
	sei
; 0000 0224 }
	ADIW R28,8
; 0000 0225 delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	CALL _delay_ms
; 0000 0226 wifi_connect();
	RCALL _wifi_connect
; 0000 0227 
; 0000 0228 RF_Init_RX();
	RCALL _RF_Init_RX
; 0000 0229 config();
	RCALL _config
; 0000 022A RF_Config_RX();
	RCALL _RF_Config_RX
; 0000 022B count = 1;
	CALL SUBOPT_0x23
; 0000 022C glcd_clear();
	CALL _glcd_clear
; 0000 022D 
; 0000 022E while (1){
_0xDB:
; 0000 022F     if (menu==0){
	SBIC 0x13,3
	RJMP _0xDE
; 0000 0230         while(1){
_0xDF:
; 0000 0231             RF_Mode_RX();
	RCALL _RF_Mode_RX
; 0000 0232             if(IRQ == 0){
	SBIC 0x19,0
	RJMP _0xE2
; 0000 0233                 RF_Read_RX_3();
	CALL SUBOPT_0x24
; 0000 0234                 if(station_receive.flag == count){
	BRNE _0xE3
; 0000 0235                     border();
	RCALL _border
; 0000 0236                     glcd_moveto(40, 3);
	LDI  R30,LOW(40)
	CALL SUBOPT_0x11
; 0000 0237                     itoa(station_receive.flag, buff);
	CALL SUBOPT_0x25
; 0000 0238                     glcd_outtext(buff);
; 0000 0239                     glcd_moveto(46, 18);
; 0000 023A                     sprintf(buff, "%d", station_receive.temp);
	CALL SUBOPT_0x5
	CALL SUBOPT_0x26
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x27
; 0000 023B                     glcd_outtext(buff);
; 0000 023C                     glcd_moveto(46, 28);
	CALL SUBOPT_0x14
; 0000 023D                     sprintf(buff, "%d", station_receive.humi);
	CALL SUBOPT_0x5
	CALL SUBOPT_0x26
	CALL SUBOPT_0x20
	CALL SUBOPT_0x27
; 0000 023E                     glcd_outtext(buff);
; 0000 023F                     glcd_moveto(46, 37);
	CALL SUBOPT_0x15
; 0000 0240                     sprintf(buff, "%d", station_receive.sm);
	CALL SUBOPT_0x5
	CALL SUBOPT_0x26
	CALL SUBOPT_0x21
	CALL SUBOPT_0x28
; 0000 0241                     glcd_outtext(buff);
; 0000 0242                     read_and_send(key[count]);
	LDS  R30,_count
	LDS  R31,_count+1
	LDI  R26,LOW(_key)
	LDI  R27,HIGH(_key)
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	MOVW R26,R30
	RCALL _read_and_send
; 0000 0243                     delay_ms(800);
	CALL SUBOPT_0x29
; 0000 0244                     count++;
; 0000 0245                     if(count == 5)
	LDS  R26,_count
	LDS  R27,_count+1
	SBIW R26,5
	BRNE _0xE4
; 0000 0246                         count = 1;
	CALL SUBOPT_0x23
; 0000 0247                     dem = 0;
_0xE4:
	CALL SUBOPT_0x2
; 0000 0248                     flag = true;
	LDI  R30,LOW(1)
	MOV  R6,R30
; 0000 0249                 }
; 0000 024A             }
_0xE3:
; 0000 024B         }
_0xE2:
	RJMP _0xDF
; 0000 024C     }
; 0000 024D     if (back==0){
_0xDE:
	SBIC 0x13,2
	RJMP _0xE5
; 0000 024E         while(1){
_0xE6:
; 0000 024F             RF_Mode_RX();
	RCALL _RF_Mode_RX
; 0000 0250             if(IRQ == 0){
	SBIC 0x19,0
	RJMP _0xE9
; 0000 0251                 RF_Read_RX_3();
	CALL SUBOPT_0x24
; 0000 0252                 if(station_receive.flag == count){
	BRNE _0xEA
; 0000 0253                     border();
	RCALL _border
; 0000 0254                     glcd_moveto(40, 3);
	LDI  R30,LOW(40)
	CALL SUBOPT_0x11
; 0000 0255                     itoa(station_receive.flag, buff);
	CALL SUBOPT_0x25
; 0000 0256                     glcd_outtext(buff);
; 0000 0257                     glcd_moveto(46, 18);
; 0000 0258                     sprintf(buff, "%d", station_receive.temp);
	CALL SUBOPT_0x5
	CALL SUBOPT_0x26
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x27
; 0000 0259                     glcd_outtext(buff);
; 0000 025A                     glcd_moveto(46, 28);
	CALL SUBOPT_0x14
; 0000 025B                     sprintf(buff, "%d", station_receive.humi);
	CALL SUBOPT_0x5
	CALL SUBOPT_0x26
	CALL SUBOPT_0x20
	CALL SUBOPT_0x27
; 0000 025C                     glcd_outtext(buff);
; 0000 025D                     glcd_moveto(46, 37);
	CALL SUBOPT_0x15
; 0000 025E                     sprintf(buff, "%d", station_receive.sm);
	CALL SUBOPT_0x5
	CALL SUBOPT_0x26
	CALL SUBOPT_0x21
	CALL SUBOPT_0x28
; 0000 025F                     glcd_outtext(buff);
; 0000 0260                     delay_ms(800);
	CALL SUBOPT_0x29
; 0000 0261                     count++;
; 0000 0262                     if(count == 5)
	LDS  R26,_count
	LDS  R27,_count+1
	SBIW R26,5
	BRNE _0xEB
; 0000 0263                         count = 1;
	CALL SUBOPT_0x23
; 0000 0264                     dem = 0;
_0xEB:
	CALL SUBOPT_0x2
; 0000 0265                     flag = true;
	LDI  R30,LOW(1)
	MOV  R6,R30
; 0000 0266                 }
; 0000 0267             }
_0xEA:
; 0000 0268         }
_0xE9:
	RJMP _0xE6
; 0000 0269     }
; 0000 026A     while(enter == 1){
_0xE5:
_0xEC:
	SBIC 0x13,0
; 0000 026B 
; 0000 026C     }
	RJMP _0xEC
; 0000 026D }
	RJMP _0xDB
; 0000 026E }
_0xEF:
	RJMP _0xEF
; .FEND

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
	JMP  _0x216000A
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
	RJMP _0x216000C
; .FEND
_pcd8544_wrcmd:
; .FSTART _pcd8544_wrcmd
	ST   -Y,R26
	CBI  0x15,6
	LD   R26,Y
	RCALL _pcd8544_wrbus_G102
	RJMP _0x216000B
; .FEND
_pcd8544_wrdata_G102:
; .FSTART _pcd8544_wrdata_G102
	ST   -Y,R26
	SBI  0x15,6
	LD   R26,Y
	RCALL _pcd8544_wrbus_G102
	RJMP _0x216000B
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
	RCALL _pcd8544_setaddr_G102
	ORI  R30,0x40
	MOV  R26,R30
	RCALL _pcd8544_wrcmd
	RJMP _0x216000C
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
_0x216000C:
	ADIW R28,2
	RET
; .FEND
_pcd8544_wrbyte:
; .FSTART _pcd8544_wrbyte
	ST   -Y,R26
	CALL SUBOPT_0x2A
	SBIW R30,1
	SUBI R30,LOW(-_gfx_buffer_G102)
	SBCI R31,HIGH(-_gfx_buffer_G102)
	LD   R26,Y
	STD  Z+0,R26
	RCALL _pcd8544_wrdata_G102
	RJMP _0x216000B
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
	RJMP _0x2160009
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
_0x216000B:
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
_0x216000A:
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
	BRSH _0x2040012
	LDD  R26,Y+3
	CPI  R26,LOW(0x30)
	BRLO _0x2040011
_0x2040012:
	JMP  _0x2160004
_0x2040011:
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
	JMP  _0x2160004
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
_0x2160009:
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
	RJMP _0x2160008
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
	RJMP _0x2160008
_0x2040034:
	CPI  R30,LOW(0x3)
	BRNE _0x2040037
	__GETW1MN _glcd_state,27
	SBIW R30,0
	BRNE _0x2040036
	RJMP _0x2160008
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
	CALL SUBOPT_0x2B
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
	CALL SUBOPT_0x2C
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
	CALL SUBOPT_0x2B
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
	CALL SUBOPT_0x2C
	RJMP _0x2040046
_0x2040048:
	LDD  R30,Y+14
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R31,0
	CALL SUBOPT_0x2B
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
	CALL SUBOPT_0x2D
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
	CALL SUBOPT_0x2E
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x2A
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
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x2F
	MOV  R21,R30
	LDD  R30,Y+9
	CPI  R30,LOW(0x7)
	BREQ _0x204006D
	CPI  R30,LOW(0x8)
	BRNE _0x204006E
_0x204006D:
_0x2040066:
	CALL SUBOPT_0x30
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
	CALL SUBOPT_0x31
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
	CALL SUBOPT_0x2D
_0x204007D:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x204007F
	CALL SUBOPT_0x2A
	SBIW R30,1
	SUBI R30,LOW(-_gfx_buffer_G102)
	SBCI R31,HIGH(-_gfx_buffer_G102)
	LD   R30,Z
	AND  R30,R20
	MOV  R26,R30
	MOV  R30,R19
	CALL __LSRB12
	CALL SUBOPT_0x32
	MOV  R30,R19
	MOV  R26,R20
	CALL __LSRB12
	COM  R30
	AND  R30,R1
	OR   R21,R30
	CALL SUBOPT_0x2E
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
	CALL SUBOPT_0x30
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
	CALL SUBOPT_0x31
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
	CALL SUBOPT_0x33
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
	CALL SUBOPT_0x2D
_0x2040092:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x2040094
	CALL SUBOPT_0x2A
	SBIW R30,1
	SUBI R30,LOW(-_gfx_buffer_G102)
	SBCI R31,HIGH(-_gfx_buffer_G102)
	LD   R30,Z
	AND  R30,R20
	MOV  R26,R30
	MOV  R30,R18
	CALL __LSLB12
	CALL SUBOPT_0x32
	MOV  R30,R18
	MOV  R26,R20
	CALL __LSLB12
	COM  R30
	AND  R30,R1
	OR   R21,R30
	CALL SUBOPT_0x2E
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
	CALL SUBOPT_0x30
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
	CALL SUBOPT_0x31
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
	CALL SUBOPT_0x33
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
_0x2160008:
	CALL __LOADLOCR6
	ADIW R28,17
	RET
; .FEND

	.CSEG
_glcd_clipx:
; .FSTART _glcd_clipx
	CALL SUBOPT_0x3
	CALL __CPW02
	BRLT _0x2060003
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	JMP  _0x2160002
_0x2060003:
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0x54)
	LDI  R30,HIGH(0x54)
	CPC  R27,R30
	BRLT _0x2060004
	LDI  R30,LOW(83)
	LDI  R31,HIGH(83)
	JMP  _0x2160002
_0x2060004:
	LD   R30,Y
	LDD  R31,Y+1
	JMP  _0x2160002
; .FEND
_glcd_clipy:
; .FSTART _glcd_clipy
	CALL SUBOPT_0x3
	CALL __CPW02
	BRLT _0x2060005
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	JMP  _0x2160002
_0x2060005:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,48
	BRLT _0x2060006
	LDI  R30,LOW(47)
	LDI  R31,HIGH(47)
	JMP  _0x2160002
_0x2060006:
	LD   R30,Y
	LDD  R31,Y+1
	JMP  _0x2160002
; .FEND
_glcd_getcharw_G103:
; .FSTART _glcd_getcharw_G103
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,3
	CALL SUBOPT_0x34
	MOVW R16,R30
	MOV  R0,R16
	OR   R0,R17
	BRNE _0x206000B
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x2160007
_0x206000B:
	CALL SUBOPT_0x35
	STD  Y+7,R0
	CALL SUBOPT_0x35
	STD  Y+6,R0
	CALL SUBOPT_0x35
	STD  Y+8,R0
	LDD  R30,Y+11
	LDD  R26,Y+8
	CP   R30,R26
	BRSH _0x206000C
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x2160007
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
	RJMP _0x2160007
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
	RJMP _0x2160007
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
_0x2160007:
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
	CALL SUBOPT_0x36
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
	CALL SUBOPT_0x34
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
	RJMP _0x2160006
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
	CALL SUBOPT_0x36
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
	CALL SUBOPT_0x36
	CALL SUBOPT_0x37
	__GETB1MN _glcd_state,2
	ST   -Y,R30
	__GETB2MN _glcd_state,3
	CALL SUBOPT_0x36
	ADD  R30,R26
	ST   -Y,R30
	ST   -Y,R19
	__GETB1MN _glcd_state,7
	CALL SUBOPT_0x37
	LDI  R30,LOW(84)
	LDI  R31,HIGH(84)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x2060024
_0x2060021:
	RCALL _glcd_new_line_G103
	RJMP _0x2160006
_0x2060024:
_0x206001F:
	__PUTBMRN _glcd_state,2,16
_0x2160006:
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
	RJMP _0x2160001
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
	RJMP _0x2160001
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
	RJMP _0x2160002
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
	RJMP _0x2160005
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
	CALL SUBOPT_0x38
	BRSH _0x206004B
	ST   -Y,R17
	ST   -Y,R19
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
	CALL SUBOPT_0x38
	BRSH _0x2060055
	ST   -Y,R17
	INC  R17
	CALL SUBOPT_0x39
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
	CALL SUBOPT_0x38
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
	CALL __ANEGW1
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
	CALL __ANEGW1
	STD  Y+13,R30
	STD  Y+13+1,R31
_0x206005B:
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	LSL  R30
	ROL  R31
	STD  Y+11,R30
	STD  Y+11+1,R31
	ST   -Y,R17
	ST   -Y,R19
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
	CALL SUBOPT_0x3A
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	CP   R20,R26
	CPC  R21,R27
	BRGE _0x2060060
	ADD  R19,R18
	LDD  R26,Y+15
	LDD  R27,Y+15+1
	CALL SUBOPT_0x3B
_0x2060060:
	ST   -Y,R17
	CALL SUBOPT_0x39
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
	CALL SUBOPT_0x3A
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x2060065
	ADD  R17,R16
	LDD  R26,Y+11
	LDD  R27,Y+11+1
	CALL SUBOPT_0x3B
_0x2060065:
	ST   -Y,R17
	CALL SUBOPT_0x39
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
_0x2160005:
	CALL __LOADLOCR6
	ADIW R28,21
	RET
; .FEND

	.CSEG
_rtc_init:
; .FSTART _rtc_init
	ST   -Y,R26
	LDD  R30,Y+2
	ANDI R30,LOW(0x3)
	STD  Y+2,R30
	LDD  R30,Y+1
	CPI  R30,0
	BREQ _0x20A0003
	LDD  R30,Y+2
	ORI  R30,0x10
	STD  Y+2,R30
_0x20A0003:
	LD   R30,Y
	CPI  R30,0
	BREQ _0x20A0004
	LDD  R30,Y+2
	ORI  R30,0x80
	STD  Y+2,R30
_0x20A0004:
	CALL _i2c_start
	LDI  R26,LOW(208)
	CALL _i2c_write
	LDI  R26,LOW(7)
	CALL _i2c_write
	LDD  R26,Y+2
	CALL _i2c_write
	CALL _i2c_stop
	RJMP _0x2160001
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
_put_buff_G106:
; .FSTART _put_buff_G106
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x20C0010
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,4
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x20C0012
	__CPWRN 16,17,2
	BRLO _0x20C0013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x20C0012:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL SUBOPT_0x0
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
_0x20C0013:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRMI _0x20C0014
	CALL SUBOPT_0x0
_0x20C0014:
	RJMP _0x20C0015
_0x20C0010:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x20C0015:
_0x2160004:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,5
	RET
; .FEND
__print_G106:
; .FSTART __print_G106
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
_0x20C0016:
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
	RJMP _0x20C0018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x20C001C
	CPI  R18,37
	BRNE _0x20C001D
	LDI  R17,LOW(1)
	RJMP _0x20C001E
_0x20C001D:
	CALL SUBOPT_0x3C
_0x20C001E:
	RJMP _0x20C001B
_0x20C001C:
	CPI  R30,LOW(0x1)
	BRNE _0x20C001F
	CPI  R18,37
	BRNE _0x20C0020
	CALL SUBOPT_0x3C
	RJMP _0x20C00CC
_0x20C0020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x20C0021
	LDI  R16,LOW(1)
	RJMP _0x20C001B
_0x20C0021:
	CPI  R18,43
	BRNE _0x20C0022
	LDI  R20,LOW(43)
	RJMP _0x20C001B
_0x20C0022:
	CPI  R18,32
	BRNE _0x20C0023
	LDI  R20,LOW(32)
	RJMP _0x20C001B
_0x20C0023:
	RJMP _0x20C0024
_0x20C001F:
	CPI  R30,LOW(0x2)
	BRNE _0x20C0025
_0x20C0024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x20C0026
	ORI  R16,LOW(128)
	RJMP _0x20C001B
_0x20C0026:
	RJMP _0x20C0027
_0x20C0025:
	CPI  R30,LOW(0x3)
	BREQ PC+2
	RJMP _0x20C001B
_0x20C0027:
	CPI  R18,48
	BRLO _0x20C002A
	CPI  R18,58
	BRLO _0x20C002B
_0x20C002A:
	RJMP _0x20C0029
_0x20C002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x20C001B
_0x20C0029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x20C002F
	CALL SUBOPT_0x3D
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x3E
	RJMP _0x20C0030
_0x20C002F:
	CPI  R30,LOW(0x73)
	BRNE _0x20C0032
	CALL SUBOPT_0x3D
	CALL SUBOPT_0x3F
	CALL _strlen
	MOV  R17,R30
	RJMP _0x20C0033
_0x20C0032:
	CPI  R30,LOW(0x70)
	BRNE _0x20C0035
	CALL SUBOPT_0x3D
	CALL SUBOPT_0x3F
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x20C0033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x20C0036
_0x20C0035:
	CPI  R30,LOW(0x64)
	BREQ _0x20C0039
	CPI  R30,LOW(0x69)
	BRNE _0x20C003A
_0x20C0039:
	ORI  R16,LOW(4)
	RJMP _0x20C003B
_0x20C003A:
	CPI  R30,LOW(0x75)
	BRNE _0x20C003C
_0x20C003B:
	LDI  R30,LOW(_tbl10_G106*2)
	LDI  R31,HIGH(_tbl10_G106*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(5)
	RJMP _0x20C003D
_0x20C003C:
	CPI  R30,LOW(0x58)
	BRNE _0x20C003F
	ORI  R16,LOW(8)
	RJMP _0x20C0040
_0x20C003F:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x20C0071
_0x20C0040:
	LDI  R30,LOW(_tbl16_G106*2)
	LDI  R31,HIGH(_tbl16_G106*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(4)
_0x20C003D:
	SBRS R16,2
	RJMP _0x20C0042
	CALL SUBOPT_0x3D
	CALL SUBOPT_0x40
	LDD  R26,Y+11
	TST  R26
	BRPL _0x20C0043
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	CALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x20C0043:
	CPI  R20,0
	BREQ _0x20C0044
	SUBI R17,-LOW(1)
	RJMP _0x20C0045
_0x20C0044:
	ANDI R16,LOW(251)
_0x20C0045:
	RJMP _0x20C0046
_0x20C0042:
	CALL SUBOPT_0x3D
	CALL SUBOPT_0x40
_0x20C0046:
_0x20C0036:
	SBRC R16,0
	RJMP _0x20C0047
_0x20C0048:
	CP   R17,R21
	BRSH _0x20C004A
	SBRS R16,7
	RJMP _0x20C004B
	SBRS R16,2
	RJMP _0x20C004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x20C004D
_0x20C004C:
	LDI  R18,LOW(48)
_0x20C004D:
	RJMP _0x20C004E
_0x20C004B:
	LDI  R18,LOW(32)
_0x20C004E:
	CALL SUBOPT_0x3C
	SUBI R21,LOW(1)
	RJMP _0x20C0048
_0x20C004A:
_0x20C0047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x20C004F
_0x20C0050:
	CPI  R19,0
	BREQ _0x20C0052
	SBRS R16,3
	RJMP _0x20C0053
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x20C0054
_0x20C0053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x20C0054:
	CALL SUBOPT_0x3C
	CPI  R21,0
	BREQ _0x20C0055
	SUBI R21,LOW(1)
_0x20C0055:
	SUBI R19,LOW(1)
	RJMP _0x20C0050
_0x20C0052:
	RJMP _0x20C0056
_0x20C004F:
_0x20C0058:
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
_0x20C005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x20C005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x20C005A
_0x20C005C:
	CPI  R18,58
	BRLO _0x20C005D
	SBRS R16,3
	RJMP _0x20C005E
	SUBI R18,-LOW(7)
	RJMP _0x20C005F
_0x20C005E:
	SUBI R18,-LOW(39)
_0x20C005F:
_0x20C005D:
	SBRC R16,4
	RJMP _0x20C0061
	CPI  R18,49
	BRSH _0x20C0063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x20C0062
_0x20C0063:
	RJMP _0x20C00CD
_0x20C0062:
	CP   R21,R19
	BRLO _0x20C0067
	SBRS R16,0
	RJMP _0x20C0068
_0x20C0067:
	RJMP _0x20C0066
_0x20C0068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x20C0069
	LDI  R18,LOW(48)
_0x20C00CD:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x20C006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	CALL SUBOPT_0x3E
	CPI  R21,0
	BREQ _0x20C006B
	SUBI R21,LOW(1)
_0x20C006B:
_0x20C006A:
_0x20C0069:
_0x20C0061:
	CALL SUBOPT_0x3C
	CPI  R21,0
	BREQ _0x20C006C
	SUBI R21,LOW(1)
_0x20C006C:
_0x20C0066:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x20C0059
	RJMP _0x20C0058
_0x20C0059:
_0x20C0056:
	SBRS R16,0
	RJMP _0x20C006D
_0x20C006E:
	CPI  R21,0
	BREQ _0x20C0070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0x3E
	RJMP _0x20C006E
_0x20C0070:
_0x20C006D:
_0x20C0071:
_0x20C0030:
_0x20C00CC:
	LDI  R17,LOW(0)
_0x20C001B:
	RJMP _0x20C0016
_0x20C0018:
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
	CALL SUBOPT_0x41
	SBIW R30,0
	BRNE _0x20C0072
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x2160003
_0x20C0072:
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	MOVW R16,R26
	CALL SUBOPT_0x41
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
	LDI  R30,LOW(_put_buff_G106)
	LDI  R31,HIGH(_put_buff_G106)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,10
	RCALL __print_G106
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x2160003:
	CALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET
; .FEND

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
_0x2160002:
	ADIW R28,2
	RET
; .FEND
_glcd_mappixcolor1bit:
; .FSTART _glcd_mappixcolor1bit
	ST   -Y,R26
	ST   -Y,R17
	LDD  R30,Y+1
	CPI  R30,LOW(0x7)
	BREQ _0x2120007
	CPI  R30,LOW(0xA)
	BRNE _0x2120008
_0x2120007:
	LDS  R17,_glcd_state
	RJMP _0x2120009
_0x2120008:
	CPI  R30,LOW(0x9)
	BRNE _0x212000B
	__GETBRMN 17,_glcd_state,1
	RJMP _0x2120009
_0x212000B:
	CPI  R30,LOW(0x8)
	BRNE _0x2120005
	__GETBRMN 17,_glcd_state,16
_0x2120009:
	__GETB1MN _glcd_state,1
	CPI  R30,0
	BREQ _0x212000E
	CPI  R17,0
	BREQ _0x212000F
	LDI  R30,LOW(255)
	LDD  R17,Y+0
	RJMP _0x2160001
_0x212000F:
	LDD  R30,Y+2
	COM  R30
	LDD  R17,Y+0
	RJMP _0x2160001
_0x212000E:
	CPI  R17,0
	BRNE _0x2120011
	LDI  R30,LOW(0)
	LDD  R17,Y+0
	RJMP _0x2160001
_0x2120011:
_0x2120005:
	LDD  R30,Y+2
	LDD  R17,Y+0
	RJMP _0x2160001
; .FEND
_glcd_readmem:
; .FSTART _glcd_readmem
	ST   -Y,R27
	ST   -Y,R26
	LDD  R30,Y+2
	CPI  R30,LOW(0x1)
	BRNE _0x2120015
	LD   R30,Y
	LDD  R31,Y+1
	LPM  R30,Z
	RJMP _0x2160001
_0x2120015:
	CPI  R30,LOW(0x2)
	BRNE _0x2120016
	LD   R26,Y
	LDD  R27,Y+1
	CALL __EEPROMRDB
	RJMP _0x2160001
_0x2120016:
	CPI  R30,LOW(0x3)
	BRNE _0x2120018
	LD   R26,Y
	LDD  R27,Y+1
	__CALL1MN _glcd_state,25
	RJMP _0x2160001
_0x2120018:
	LD   R26,Y
	LDD  R27,Y+1
	LD   R30,X
_0x2160001:
	ADIW R28,3
	RET
; .FEND
_glcd_writemem:
; .FSTART _glcd_writemem
	ST   -Y,R26
	LDD  R30,Y+3
	CPI  R30,0
	BRNE _0x212001C
	LD   R30,Y
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	ST   X,R30
	RJMP _0x212001B
_0x212001C:
	CPI  R30,LOW(0x2)
	BRNE _0x212001D
	LD   R30,Y
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	CALL __EEPROMWRB
	RJMP _0x212001B
_0x212001D:
	CPI  R30,LOW(0x3)
	BRNE _0x212001B
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R26,Y+2
	__CALL1MN _glcd_state,27
_0x212001B:
	ADIW R28,4
	RET
; .FEND

	.CSEG

	.DSEG
_glcd_state:
	.BYTE 0x1D
_rx_buffer0:
	.BYTE 0x40
_buff:
	.BYTE 0x104
_dem:
	.BYTE 0x2
_count:
	.BYTE 0x2
_tx_buffer0:
	.BYTE 0x40
_tx_wr_index0:
	.BYTE 0x1
_tx_rd_index0:
	.BYTE 0x1
_tx_counter0:
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
	.BYTE 0xA
_tay_cam_receive:
	.BYTE 0x8
_data_receive:
	.BYTE 0x12
_result:
	.BYTE 0x1
_key:
	.BYTE 0xA
__seed_G101:
	.BYTE 0x4
_gfx_addr_G102:
	.BYTE 0x2
_gfx_buffer_G102:
	.BYTE 0x1F8

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x0:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	LDI  R26,LOW(_count)
	LDI  R27,HIGH(_count)
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2:
	LDI  R30,LOW(0)
	STS  _dem,R30
	STS  _dem+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	ST   -Y,R27
	ST   -Y,R26
	LD   R26,Y
	LDD  R27,Y+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	SUB  R26,R18
	SBC  R27,R19
	LDD  R30,Y+46
	LDD  R31,Y+46+1
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x5:
	LDI  R30,LOW(_buff)
	LDI  R31,HIGH(_buff)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6:
	LDI  R30,LOW(7)
	ST   -Y,R30
	LDI  R26,LOW(126)
	CALL _RF_Write_RX
	LDI  R26,LOW(226)
	JMP  _RF_Command_RX

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x7:
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
SUBOPT_0x8:
	ST   -Y,R26
	CBI  0x1B,2
	LDD  R30,Y+1
	ORI  R30,0x20
	MOV  R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x9:
	SBI  0x1B,2
	__DELAY_USB 27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xA:
	CALL _SPI_RW_RX
	LD   R26,Y
	JMP  _SPI_RW_RX

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xB:
	CALL _SPI_RW_RX
	LDS  R26,_Code_tay_cam2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC:
	CALL _RF_Write3_RX
	LDI  R30,LOW(16)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD:
	ST   -Y,R30
	LDI  R26,LOW(15)
	JMP  _RF_Write_RX

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xE:
	LDI  R31,0
	ST   X+,R30
	ST   X,R31
	JMP  _SPI_Read_RX

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xF:
	ST   -Y,R30
	LDI  R30,LOW(48)
	ST   -Y,R30
	LDI  R26,LOW(15)
	CALL _glcd_line
	LDI  R30,LOW(0)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x10:
	ST   -Y,R30
	LDI  R30,LOW(84)
	ST   -Y,R30
	LDI  R26,LOW(48)
	CALL _glcd_line
	LDI  R30,LOW(0)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x11:
	ST   -Y,R30
	LDI  R26,LOW(3)
	JMP  _glcd_moveto

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x12:
	CALL _glcd_outtext
	LDI  R30,LOW(4)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x13:
	ST   -Y,R30
	LDI  R26,LOW(18)
	JMP  _glcd_moveto

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x14:
	ST   -Y,R30
	LDI  R26,LOW(28)
	JMP  _glcd_moveto

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x15:
	ST   -Y,R30
	LDI  R26,LOW(37)
	JMP  _glcd_moveto

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x16:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(2)
	LDI  R27,0
	CALL _wait_until
	LDI  R26,LOW(0)
	LDI  R27,0
	JMP  _refresh

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x17:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(2)
	LDI  R27,0
	JMP  _wait_until

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x18:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(20)
	LDI  R27,0
	JMP  _memset

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x19:
	__GETW2SX 81
	LD   R30,X
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1A:
	CALL _put_string
	LDI  R26,LOW(300)
	LDI  R27,HIGH(300)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x1B:
	MOVW R30,R28
	ADIW R30,44
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1C:
	CALL _strcat
	RJMP SUBOPT_0x1B

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1D:
	__GETW1MN _station_receive,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1E:
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,26
	CALL _itoa
	RJMP SUBOPT_0x1B

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1F:
	MOVW R26,R28
	ADIW R26,26
	RJMP SUBOPT_0x1C

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x20:
	__GETW1MN _station_receive,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x21:
	__GETW1MN _station_receive,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x22:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(5)
	LDI  R27,0
	JMP  _wait_until

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x23:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _count,R30
	STS  _count+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x24:
	CALL _RF_Read_RX_3
	LDS  R30,_count
	LDS  R31,_count+1
	LDS  R26,_station_receive
	LDS  R27,_station_receive+1
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x25:
	LDS  R30,_station_receive
	LDS  R31,_station_receive+1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_buff)
	LDI  R27,HIGH(_buff)
	CALL _itoa
	LDI  R26,LOW(_buff)
	LDI  R27,HIGH(_buff)
	CALL _glcd_outtext
	LDI  R30,LOW(46)
	RJMP SUBOPT_0x13

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x26:
	__POINTW1FN _0x0,349
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:30 WORDS
SUBOPT_0x27:
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	LDI  R26,LOW(_buff)
	LDI  R27,HIGH(_buff)
	CALL _glcd_outtext
	LDI  R30,LOW(46)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x28:
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	LDI  R26,LOW(_buff)
	LDI  R27,HIGH(_buff)
	JMP  _glcd_outtext

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x29:
	LDI  R26,LOW(800)
	LDI  R27,HIGH(800)
	CALL _delay_ms
	RJMP SUBOPT_0x1

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2A:
	LDI  R26,LOW(_gfx_addr_G102)
	LDI  R27,HIGH(_gfx_addr_G102)
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2B:
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+6,R30
	STD  Y+6+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x2C:
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
SUBOPT_0x2D:
	ST   -Y,R16
	LDD  R26,Y+16
	JMP  _pcd8544_setaddr_G102

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x2E:
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
SUBOPT_0x2F:
	CLR  R22
	CLR  R23
	MOVW R26,R30
	MOVW R24,R22
	JMP  _glcd_readmem

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x30:
	ST   -Y,R21
	LDD  R26,Y+10
	JMP  _glcd_mappixcolor1bit

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x31:
	ST   -Y,R16
	INC  R16
	LDD  R30,Y+16
	ST   -Y,R30
	ST   -Y,R21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x32:
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
SUBOPT_0x33:
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
	RJMP SUBOPT_0x2F

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x34:
	CALL __SAVELOCR6
	__GETW1MN _glcd_state,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x35:
	MOVW R30,R16
	__ADDWRN 16,17,1
	LPM  R0,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x36:
	__GETW1MN _glcd_state,4
	ADIW R30,1
	LPM  R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x37:
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
SUBOPT_0x38:
	LDD  R26,Y+6
	SUBI R26,-LOW(1)
	STD  Y+6,R26
	SUBI R26,LOW(1)
	__GETB1MN _glcd_state,8
	CP   R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x39:
	ST   -Y,R19
	LDD  R26,Y+10
	JMP  _glcd_putpixelm_G103

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3A:
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+9,R30
	STD  Y+9+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3B:
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+9,R30
	STD  Y+9+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x3C:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x3D:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3E:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x3F:
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
SUBOPT_0x40:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x41:
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	RET


	.CSEG
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

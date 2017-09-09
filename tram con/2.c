
#include <mega8.h>
#include <delay.h>

//config DHT11
#define         DHT_DATA_IN     PIND.0   
#define         DHT_DATA_OUT    PORTD.0            
#define         DHT_DDR_DATA    DDRD.0 


#include <stdlib.h>
#include <stdio.h>  
#include <DHT.h>    


// Graphic Display functions
#include <glcd.h>

// Font used for displaying text
// on the graphic display
#include <font5x7.h>

// Declare your global variables here
unsigned char buff[20];
unsigned char dht_nhiet_do,dht_do_am; 

// Voltage Reference: AREF pin
#define ADC_VREF_TYPE ((0<<REFS1) | (0<<REFS0) | (0<<ADLAR))

// Read the AD conversion result
unsigned int read_adc(unsigned char adc_input)
{
ADMUX=adc_input | ADC_VREF_TYPE;
// Delay needed for the stabilization of the ADC input voltage
delay_us(10);
// Start the AD conversion
ADCSRA|=(1<<ADSC);
// Wait for the AD conversion to complete
while ((ADCSRA & (1<<ADIF))==0);
ADCSRA|=(1<<ADIF);
return ADCW;
}

 
//config NRF24L01
#define CE PORTD.3
#define CSN PORTD.4
#define SCK PORTD.2
#define MOSI PORTB.6
#define MISO PIND.1
#define IRQ PINB.7
unsigned char P_Add=0xA2, Code_tay_cam1, Code_tay_cam2, Code_tay_cam3, Code_tay_cam4;
#include <nrf_code.h> 

station_info data_send;

#define TRIGGER PORTB.5
#define ECHO PINB.4

int change, dem;
float distance;

void set_up_sieu_am(){
    TRIGGER = 0;
    delay_us(2);
    TRIGGER = 1;
    delay_us(10);
    TRIGGER = 0;
    while(ECHO == 0);
    dem = 1;    
    change = 1;
}


interrupt [TIM0_OVF] void timer2_ovf(){
    TCNT0 = 0x9C;
    dem++;
      
    if(ECHO == 0 && change == 1){
    distance = dem*0.1*3.432*5; 
    dem = 0;
    change = 0;
    }
}

          

void main(void)
{
// Declare your local variables here
// Variable used to store graphic display
// controller initialization data
GLCDINIT_t glcd_init_data;

// Input/Output Ports initialization
// Port B initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRB=(0<<DDB7) | (1<<DDB6) | (1<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTB=(1<<PORTB7) | (1<<PORTB6) | (1<<PORTB5) | (1<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);

// Port C initialization
// Function: Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRC=(0<<DDC6) | (1<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
// State: Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTC=(0<<PORTC6) | (1<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);

// Port D initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (1<<DDD4) | (1<<DDD3) | (1<<DDD2) | (0<<DDD1) | (0<<DDD0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (1<<PORTD4) | (1<<PORTD3) | (1<<PORTD2) | (1<<PORTD1) | (0<<PORTD0);

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
TCCR0=(0<<CS02) | (1<<CS01) | (0<<CS00);
TCNT0=0x9C;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: Timer1 Stopped
// Mode: Normal top=0xFFFF
// OC1A output: Disconnected
// OC1B output: Disconnected
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer2 Stopped
// Mode: Normal top=0xFF
// OC2 output: Disconnected
ASSR=0<<AS2;
TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
TCNT2=0x00;
OCR2=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (1<<TOIE0);

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);

// USART initialization
// USART disabled
UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);

// Analog Comparator initialization
// Analog Comparator: Off
// The Analog Comparator's positive input is
// connected to the AIN0 pin
// The Analog Comparator's negative input is
// connected to the AIN1 pin
ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);

// ADC initialization
// ADC Clock frequency: 1000.000 kHz
// ADC Voltage Reference: AREF pin
ADMUX=ADC_VREF_TYPE;
ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADFR) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (1<<ADPS1) | (1<<ADPS0);
SFIOR=(0<<ACME);

// SPI initialization
// SPI disabled
SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);

// TWI initialization
// TWI disabled
TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);

// Graphic Display Controller initialization
// The PCD8544 connections are specified in the
// Project|Configure|C Compiler|Libraries|Graphic Display menu:
// SDIN - PORTC Bit 3
// SCLK - PORTC Bit 4
// D /C - PORTC Bit 2
// /SCE - PORTC Bit 1
// /RES - PORTC Bit 0

// Specify the current font for displaying text
glcd_init_data.font=font5x7;
// No function is used for reading
// image data from external memory
glcd_init_data.readxmem=NULL;
// No function is used for writing
// image data to external memory
glcd_init_data.writexmem=NULL;
// Set the LCD temperature coefficient
glcd_init_data.temp_coef=PCD8544_DEFAULT_TEMP_COEF;
// Set the LCD bias
glcd_init_data.bias=4;
// Set the LCD contrast control voltage VLCD
glcd_init_data.vlcd=PCD8544_DEFAULT_VLCD;

#asm("sei")

glcd_init(&glcd_init_data);
PORTC.5 = 0;

config();
RF_Init_RX();
RF_Config_TX();
RF_Mode_TX(); 

glcd_line(48,0, 48, 15);
glcd_line(0, 15, 48, 15);
glcd_line(0,0,84,0);
glcd_line(84,0, 84, 48);
glcd_line(0, 48, 84, 48);
glcd_line(0, 0, 0, 48);
glcd_moveto(3,3);
glcd_outtext("Node: ");
glcd_moveto(40, 3);
glcd_outtext("2");
			
glcd_moveto(4, 18);
glcd_outtext("Temp: ");
glcd_moveto(4, 28);
glcd_outtext("Humid: ");
glcd_moveto(4, 37);
glcd_outtext("Water: ");
	
glcd_moveto(67, 28);
glcd_putchar(37);
glcd_moveto(67, 37);
glcd_outtext("mm");

while (1){     
        if(DHT_GetTemHumi(&dht_nhiet_do,&dht_do_am)){
            sprintf(buff, "%u", (unsigned int)dht_do_am);
            glcd_moveto(50, 28);
            glcd_outtext(buff);
            sprintf(buff, "%u  ", (unsigned int)dht_nhiet_do);
            glcd_moveto(50, 18);
            glcd_outtext(buff); 
        }          
        
        set_up_sieu_am(); 
        glcd_moveto(50, 37); 
        if((int)distance > 20)
            sprintf(buff, "NaN");
        else 
            sprintf(buff, "%d ", (int)distance);
        glcd_outtext(buff);              
      
        data_send.flag = 2;
        data_send.temp = dht_nhiet_do;
        data_send.humi = dht_do_am;
        data_send.light = (int)read_adc(6)/4;
        data_send.sm = (int)read_adc(7)/4; 
        data_send.water = (int)distance;  
      
        RF_Send_TX(data_send);

        delay_ms(200);

        }
}

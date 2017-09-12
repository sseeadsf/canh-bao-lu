//define NRF
#define CE PORTD.2     //out 1
#define CE_DDR DDRD.2
#define CSN PORTD.7      //out 1
#define CSN_DDR DDRD.7
#define SCK PORTD.3       //out 1
#define SCK_DDR DDRD.3
#define MOSI PORTD.6      //out 1
#define MOSI_DDR DDRD.6
#define MISO PIND.4       //in p
#define MISO_DDR DDRD.4
#define IRQ PIND.5        //in p
#define IRQ_DDR DDRD.5
//----------------define button--------
#define bt_reset PINB.3
#define bt_reset_DDR DDRB.3
#define bt_enter PINB.4
#define bt_enter_DDR DDRB.4
#define bt_back PINB.2
#define bt_back_DDR DDRB.2
#define bt_down PINB.1
#define bt_down_DDR DDRB.1
//----------------define LED ----------
#define LED PORTA.6
#define LED_DDR DDRA.6
//----------------config NRF-----------
void init()
    {  
//----------------init glcd nokia------
        GLCDINIT_t glcd_init_data;
        glcd_init_data.font=font5x7;
		glcd_init_data.readxmem=NULL;
		glcd_init_data.writexmem=NULL;
		glcd_init_data.temp_coef=150;
		glcd_init_data.bias=3;
		glcd_init_data.vlcd=60;
		glcd_init(&glcd_init_data);
//-------------config NRF PIN--------
        CE_DDR = 1;
        CE = 1;
        CSN_DDR = 1;
        CSN = 1;
        SCK_DDR = 1;
        SCK = 1;
        MOSI_DDR = 1;
        MOSI = 1;
        MISO_DDR = 0;
        MISO = 1;
        IRQ_DDR = 0;
        IRQ = 1;
//----------------config LED-----------
        LED_DDR = 1;
        LED = 0;
//----------------config button--------
        bt_reset_DDR = 0;
        bt_reset = 1;
        bt_enter_DDR = 0;
        bt_enter = 1;
        bt_back_DDR = 0;
        bt_back = 1;
        bt_down_DDR = 0;
        bt_down = 1;
        #asm("sei")
    }

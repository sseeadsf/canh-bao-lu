//----------------define NRF------------
#define CE PORTA.3     //out 1
#define CE_DDR DDRA.3
#define CSN PORTA.2      //out 1
#define CSN_DDR DDRA.2
#define SCK PORTA.4       //out 1
#define SCK_DDR DDRA.4
#define MOSI PORTA.1      //out 1
#define MOSI_DDR DDRA.1
#define MISO PINA.5       //in p
#define MISO_DDR DDRA.5
#define IRQ PINA.0        //in p
#define IRQ_DDR DDRA.0
//----------------define button--------
#define bt_menu PINC.3
#define bt_menu_DDR DDRC.3
#define bt_enter PINC.0
#define bt_enter_DDR DDRC.0
#define bt_back PINC.2
#define bt_back_DDR DDRC.2
//----------------define LED ----------
#define LED PORTA.6
#define LED_DDR DDRA.6
//----------------define ROLE----------
#define role_1  PORTB.3
#define role_1_DDR DDRB.3
#define role_2  PORTB.2
#define role_2_DDR  DDRB.2
#define role_3  PORTD.7
#define role_3_DDR  DDRD.7
#define role_4 PORTD.6
#define role_4_DDR  DDRD.6
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
        bt_menu_DDR = 0;
        bt_menu = 1;
        bt_enter_DDR = 0;
        bt_enter = 1;
        bt_back_DDR = 0;
        bt_back = 1;
//------------- config role ------------- 
        role_1_DDR = 1;
        role_1 = 0;
        role_2_DDR = 1;
        role_2 = 0;
        role_3_DDR = 1;
        role_3 = 0;
        role_4_DDR = 1;
        role_4 = 0;  
//------------- config timer overflow -------------0.1ms 
        TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (1<<TOIE0);
        ETIMSK=(0<<TICIE3) | (0<<OCIE3A) | (0<<OCIE3B) | (0<<TOIE3) | (0<<OCIE3C) | (0<<OCIE1C);


        
        #asm("sei")
    }

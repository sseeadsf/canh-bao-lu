unsigned char P_Add=0xA1, Code_tay_cam1, Code_tay_cam2, Code_tay_cam3, Code_tay_cam4;

#include <io.h>
#include <mega32a.h>
#include <delay.h>
#include <stdlib.h>
#include <stdio.h>
#include <glcd.h>
#include <font5x7.h>
#include "define.c"
#include "nrf_code.c"
#include "s_function.c"
station_info data_send;
void main(void)
{
init();
border();
temp();
config();
RF_Init_RX();
RF_Config_TX();
RF_Mode_TX(); 
while (1)
      {  
        
            data_send.flag = 1;
            data_send.temp = 100;
            data_send.humi = 100;  
            data_send.light = 100;
            data_send.sm = 100;
            RF_Send_TX(data_send);
            delay_ms(300);
            IRQ=1;
            RF_Command_RX(0b11100010);

        }
}
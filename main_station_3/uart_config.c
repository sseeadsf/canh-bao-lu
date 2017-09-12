void uart_config()
{
#define DATA_REGISTER_EMPTY (1<<UDRE0)
#define RX_COMPLETE (1<<RXC0)
#define FRAMING_ERROR (1<<FE0)
#define PARITY_ERROR (1<<UPE0)
#define DATA_OVERRUN (1<<DOR0)

// USART0 Receiver buffer
#define RX_BUFFER_SIZE0 64
char rx_buffer0[RX_BUFFER_SIZE0];

#if RX_BUFFER_SIZE0 <= 256
unsigned char rx_wr_index0=0,rx_rd_index0=0;
#else
unsigned int rx_wr_index0=0,rx_rd_index0=0;
#endif

#if RX_BUFFER_SIZE0 < 256
unsigned char rx_counter0=0;
#else
unsigned int rx_counter0=0;
#endif

char buff[260];
int i = 0, time_flow = 0, time_s = 0;

}
bit rx_buffer_overflow0;

// USART0 Receiver interrupt service routine
interrupt [USART0_RXC] void usart0_rx_isr(void) {
    char status,data;
    status=UCSR0A;
    data=UDR0;
    if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0) {
        rx_buffer0[rx_wr_index0++]=data;
#if RX_BUFFER_SIZE0 == 256
        // special case for receiver buffer size=256
        if (++rx_counter0 == 0) rx_buffer_overflow0=1;
#else
        if (rx_wr_index0 == RX_BUFFER_SIZE0) rx_wr_index0=0;
        if (++rx_counter0 == RX_BUFFER_SIZE0) {
            rx_counter0=0;
            rx_buffer_overflow0=1;
        }
#endif
    }
    buff[i] = data;
    i++;
}
#ifndef _DEBUG_TERMINAL_IO_
// Get a character from the USART0 Receiver buffer
#define _ALTERNATE_GETCHAR_
#pragma used+
char getchar(void) {
    char data;
    while (rx_counter0==0);
    data=rx_buffer0[rx_rd_index0++];
#if RX_BUFFER_SIZE0 != 256
    if (rx_rd_index0 == RX_BUFFER_SIZE0) rx_rd_index0=0;
#endif
#asm("cli")
    --rx_counter0;
#asm("sei")
    return data;
}
#pragma used-
#endif

// USART0 Transmitter buffer
#define TX_BUFFER_SIZE0 64
char tx_buffer0[TX_BUFFER_SIZE0];

#if TX_BUFFER_SIZE0 <= 256
unsigned char tx_wr_index0=0,tx_rd_index0=0;
#else
unsigned int tx_wr_index0=0,tx_rd_index0=0;
#endif

#if TX_BUFFER_SIZE0 < 256
unsigned char tx_counter0=0;
#else
unsigned int tx_counter0=0;
#endif

// USART0 Transmitter interrupt service routine
interrupt [USART0_TXC] void usart0_tx_isr(void) {
    if (tx_counter0) {
        --tx_counter0;
        UDR0=tx_buffer0[tx_rd_index0++];
#if TX_BUFFER_SIZE0 != 256
        if (tx_rd_index0 == TX_BUFFER_SIZE0) tx_rd_index0=0;
#endif
    }
}

interrupt [TIM0_OVF] void timer0_ovf_isr(void) {
	//0.02 ms => 50k = 1s.
	TCNT0=0x60;
	// Place your code here
    time_flow++;
	
    if (time_flow == 50000) {
        time_s++;
        time_flow = 0;
    }
}

#ifndef _DEBUG_TERMINAL_IO_
// Write a character to the USART0 Transmitter buffer
#define _ALTERNATE_PUTCHAR_
#pragma used+
void putchar(char c) {
    while (tx_counter0 == TX_BUFFER_SIZE0);
#asm("cli")
    if (tx_counter0 || ((UCSR0A & DATA_REGISTER_EMPTY)==0)) {
        tx_buffer0[tx_wr_index0++]=c;
#if TX_BUFFER_SIZE0 != 256
        if (tx_wr_index0 == TX_BUFFER_SIZE0) tx_wr_index0=0;
#endif
        ++tx_counter0;
    } else
        UDR0=c;
#asm("sei")
}
#pragma used-
#endif
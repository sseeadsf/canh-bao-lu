#include <RF24Network.h>
#include <RF24.h>
#include <SPI.h>
///==============
#include<LiquidCrystal.h>                                           // thu vien LCD
#include <stdlib.h>
LiquidCrystal lcd(A1, 5, 4, 3, 2, A0);  //  LED LCD A2    
//===============
#include <stdlib.h>
#include <SoftwareSerial.h>
#define SSID "Thay_Thao_deo_giai"
#define PASS "chinhxac"
#define IP "184.106.153.149"     // thingspeak.com

RF24 radio(9,10);
//RF24Network network(radio);
const uint16_t thisNode = 00;
//=============
String response;
boolean debug = true;
SoftwareSerial esp8266(15, 16); // RX, TX
unsigned long time;
int count = 1;
int dem;
bool flag = false;
byte pipeNum = 0;

typedef struct
{
    int flag;
    int light;
    int humi;
    int temp;
    int sm;  
    int water;
}station_info;

station_info data_receive;

void receives(){
  radio.startListening();
  radio.openReadingPipe(1, 0xA1A1A1A1A1);
  radio.openReadingPipe(2, 0xA2A2A2A2A2);
  radio.openReadingPipe(3, 0xA3A2A2A2A2);
  radio.openReadingPipe(4, 0xA4A2A2A2A2);
}

void setup(void)
{
    Serial.begin(115200);
    esp8266.begin(115200);
    //pinMode(A2,OUTPUT);         //////////// DEN LCD
    //pinMode(A3,INPUT_PULLUP);     // tien can, binh thuong = 1, co nguoi =0
    radio.begin();      //nrf setup
    radio.setRetries(1,1);
    radio.setDataRate(RF24_250KBPS);
    radio.setPALevel(RF24_PA_MAX);
    lcd.begin(16,2);
    delay(500);
    wifi_connect();
  //////===================
     cli();                                  // tắt ngắt toàn cục
    
    /* Reset Timer/Counter1 */
    TCCR1A = 0;
    TCCR1B = 0;
    TIMSK1 = 0;
    
    /* Setup Timer/Counter1 */
    TCCR1B |= (1 << CS11) | (1 << CS10);    // prescale = 64
    TCNT1 = 0;
    TIMSK1 = (1 << TOIE1);                  // Overflow interrupt enable 
    sei();                    // cho phép ngắt toàn cục
    //============================================
}

void loop(void)
{ 
  receive_data(count);
  flag = true;

}

void receive_data(int Num)
{
    while(radio.available(&pipeNum))
    {
      if(pipeNum == Num)
      {
          radio.read(&data_receive, sizeof(data_receive));
          Serial.print(pipeNum);
          Serial.print(":");
          //Serial.println(data_receive.flag);
          Serial.println(data_receive.light);
          Serial.println(data_receive.humi);
          Serial.println(data_receive.temp);
          Serial.println(data_receive.sm);
          Serial.println(data_receive.water);
          count++;
          //send_data_to_web();
          delay(200);
          //get_setting();
      }
    }
}

void send_data_to_web(String key){
  String cmd;
  String cmd2;  
  //if (debug==true){Serial.println("****************************************");};
  cmd = "AT+CIPSTART=\"TCP\",\"";
  cmd += IP;
  cmd += "\",80";
  delay(1000);
  data_send(cmd);
  delay(1000);
  response_read();
  cmd = "GET /update?key=";
  cmd += key;
  cmd += "&field1=";  
  cmd += data_receive.light;  
  cmd += "&field2="; 
  cmd += data_receive.humi; 
  cmd += "&field3="; 
  cmd += data_receive.temp;  
  cmd += "&field4=";  
  cmd += data_receive.sm;  
  cmd += "&field5="; 
  cmd += data_receive.water; 
  cmd2 =  "AT+CIPSEND=";
  cmd2 += (cmd.length()+2);
  delay(1000);
  data_send(cmd2);
  delay(1000);
  response_read();
  delay(1000);
  data_send(cmd);
  delay(1000);
  response_read();
}

ISR (TIMER1_OVF_vect) 
{
    TCNT1 = 0;
    if(flag == true){
      dem++;
    }
    if(dem == 500){
      dem = 0;
      count++;
      flag = false;
    }
}

/*****************************************************************
* wifi_connect()
*****************************************************************/ 
boolean wifi_connect(){
  delay(1000);
  data_send("AT+CWMODE=1"); 
  delay(1000);
  response_read();
  String cmd="AT+CWJAP=\"";
  cmd+=SSID;
  cmd+="\",\"";
  cmd+=PASS;
  cmd+="\"";
  delay(1000);
  data_send(cmd);
  delay(7000);
  response_read();
}

/*****************************************************************
* data_send
*****************************************************************/
void data_send(String cmd){
  esp8266.println(cmd);
  response = ""; 
  response_read();
} 
/*****************************************************************
* response_read
*****************************************************************/
void response_read(){
  char chr;
 while(esp8266.available()){ 
  chr = esp8266.read(); 
  if (debug == true){Serial.write(chr);} 
  response += chr; 
 }
}




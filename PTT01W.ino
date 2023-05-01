#include <WiFiManager.h>  //biblioteca Wifi
#include "max6675.h"      //biblioteca da temperatura
#include <OneWire.h>
#include <DallasTemperature.h>

//pino PH
#define pinPH 35
//pino TDS
#define TdsSensorPin 34
//pino temeperatura
#define SENSOR_PIN 23
//#define azul 9 //sem necessidade
#define verde 18 //19
#define vermelho 5 //21

//configuração sensor temperatura
OneWire oneWire(SENSOR_PIN);
DallasTemperature DS18B20(&oneWire);
float tempC; // temperature in Celsius

//tempo de sono do arduino
#define uS_TO_S_FACTOR 1000000 /* Conversion factor for micro seconds to seconds */
#define TIME_TO_SLEEP 20       /* Time ESP32 will go to sleep (in seconds) */

//parametros de conexão da API
String apiKey = "H0J55613LE91SUR7";
const char* server = "api.thingspeak.com";

WiFiClient client;
WiFiManager wm;
bool res;

//tempo para o envio dos dados para API
unsigned long lastTime = 0;
unsigned long timerDelay = 15000;

//valores para o TDS
#define VREF 3.3           // analog reference voltage(Volt) of the ADC
#define SCOUNT 30          // sum of sample point
int analogBuffer[SCOUNT];  // store the analog value in the array, read from ADC
int analogBufferTemp[SCOUNT];
int analogBufferIndex = 0, copyIndex = 0;
float averageVoltage = 0, tdsValue = 0, temperature = 25;

//amostras captadas a cada tempo de uso
int amostra;

void setup() {
  amostra = 0;  //zerando amostra
  pinMode(verde, OUTPUT);
  pinMode(vermelho, OUTPUT);
  pinMode(pinPH, INPUT);
  pinMode(TdsSensorPin, INPUT);
  pinMode(27, OUTPUT);
  digitalWrite(27, 1);
  vermelhoFuncao();
  Serial.begin(115200);
  while(!Serial);
  //wm.resetSettings(); //resetar redes salvas

  //wm.setConfigPortalTimeout(180);               //limite de 60 segundos para conexão
  res = wm.autoConnect("PTT-01W", "12345678");  //Conectar na rede (Nome e senha)

  DS18B20.begin();    // initialize the DS18B20 sensor

  if (!res) {
    Serial.println("Failed to connect");
    vermelhoFuncao();

  } else {
    Serial.println("connected...yeey :)");
    verdeFuncao();
  }

 // esp_sleep_enable_timer_wakeup(TIME_TO_SLEEP * uS_TO_S_FACTOR);  //tempo de sono do ESP32
}

void loop() {
  if ((millis() - lastTime) > timerDelay && amostra <= 3) {
    if (client.connect(server, 80)) {
      Serial.println(".");
      verdeFuncao();

      String postStr = apiKey;
      postStr += "&field1=";
      postStr += String(readPH());
      postStr += "&field2=";
      postStr += String(readTDS());
      //postStr += String(32);
      postStr += "&field3=";
      postStr += String(readTemp());
      //postStr += String(67);
      postStr += "\r\n";

      client.print("POST /update HTTP/1.1\n");
      client.print("Host: api.thingspeak.com\n");
      client.print("Connection: close\n");
      client.print("X-THINGSPEAKAPIKEY: H0J55613LE91SUR7\n");
      client.print("Content-Type: application/x-www-form-urlencoded\n");
      client.print("Content-Length: ");
      client.print(postStr.length());
      client.print("\n\n");
      client.print(postStr);
    } else {
      vermelhoFuncao();
    }
    lastTime = millis();
    amostra++;
  }
  if (amostra == 3) {
    amostra = 0;
    Serial.println("Dormiu");
    //esp_deep_sleep_start();
  }
}

//função leitura de PH
float readPH() {
  float media = 0;
  float Po = 0;
  // média das tensões
  for (int i = 0; i < 500; i++) {
    media += analogRead(pinPH);
  }
    Serial.println("ppm");
  Po = (2384 - (media / 500)) / 98.73;

  if (Po > 14) {
    Po = 14;
  }
  if (Po < 1) {
    Po = 1;
  }
  //Serial.print(Po);
  return Po;
}
//função leitura de temperatura
float readTemp() {
  DS18B20.requestTemperatures();       // send the command to get temperatures
  temperature = DS18B20.getTempCByIndex(0); 
  //Serial.println(F("°C "));
  if (temperature < 1) {
    temperature = 0;
  }
  if (temperature > 100) {
    temperature = 100;
  }
  return temperature;
}
float readTDS() {

  for (analogBufferIndex = 0; analogBufferIndex < SCOUNT; analogBufferIndex++)
    analogBuffer[analogBufferIndex] = analogRead(TdsSensorPin);  //read the analog value and store into the buffer

  for (copyIndex = 0; copyIndex < SCOUNT; copyIndex++)
    analogBufferTemp[copyIndex] = analogBuffer[copyIndex];

  averageVoltage = getMedianNum(analogBufferTemp, SCOUNT) * (float)VREF / 4095.0;                                                                                                   // read the analog value more stable by the median filtering algorithm, and convert to voltage value
  float compensationCoefficient = 1.0 + 0.02 * (25 - 25.0);                                                                                                                 //temperature compensation formula: fFinalResult(25^C) = fFinalResult(current)/(1.0+0.02*(fTP-25.0));
  float compensationVolatge = averageVoltage / compensationCoefficient;                                                                                                             //temperature compensation
  tdsValue = (133.42 * compensationVolatge * compensationVolatge * compensationVolatge - 255.86 * compensationVolatge * compensationVolatge + 857.39 * compensationVolatge) * 0.5;  //convert voltage value to tds value
  //Serial.print("voltage:");
  //Serial.print(averageVoltage,2);
  //Serial.print("V ");
  //Serial.print("TDS Value:");
  //Serial.print(tdsValue, 0);
  //Serial.println("ppm");
  return tdsValue;
}
//MEDIA BTEMP TDS
int getMedianNum(int bArray[], int iFilterLen) {
  int bTab[iFilterLen];
  for (byte i = 0; i < iFilterLen; i++)
    bTab[i] = bArray[i];
  int i, j, bTemp;
  for (j = 0; j < iFilterLen - 1; j++) {
    for (i = 0; i < iFilterLen - j - 1; i++) {
      if (bTab[i] > bTab[i + 1]) {
        bTemp = bTab[i];
        bTab[i] = bTab[i + 1];
        bTab[i + 1] = bTemp;
      }
    }
  }
  if ((iFilterLen & 1) > 0)
    bTemp = bTab[(iFilterLen - 1) / 2];
  else
    bTemp = (bTab[iFilterLen / 2] + bTab[iFilterLen / 2 - 1]) / 2;
  return bTemp;
}

//deixar led verde
void verdeFuncao() {
    Serial.println("azul");

  digitalWrite(verde, HIGH);
  digitalWrite(vermelho, LOW);
}
//deixar led vermelho
void vermelhoFuncao() {
  Serial.println("Vermelho");
  digitalWrite(verde, LOW);
  digitalWrite(vermelho, HIGH);
}
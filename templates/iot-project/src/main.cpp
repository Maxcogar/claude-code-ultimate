/**
 * Claude Code Ultimate IoT Project
 * ESP32 Smart Device Template
 * 
 * Features:
 * - WiFi connectivity with auto-reconnect
 * - MQTT communication
 * - Web server for configuration
 * - OTA updates
 * - Sensor data collection
 * - Real-time monitoring
 */

#include <WiFi.h>
#include <PubSubClient.h>
#include <ArduinoJson.h>
#include <DHT.h>
#include <ESPAsyncWebServer.h>
#include <ArduinoOTA.h>
#include "config.h"

// Hardware Configuration
#define DHT_PIN 4
#define DHT_TYPE DHT22
#define LED_PIN 2
#define BUTTON_PIN 0

// Initialize components
DHT dht(DHT_PIN, DHT_TYPE);
WiFiClient wifiClient;
PubSubClient mqttClient(wifiClient);
AsyncWebServer server(80);

// Global variables
float temperature = 0.0;
float humidity = 0.0;
bool deviceStatus = true;
unsigned long lastSensorRead = 0;
unsigned long lastMqttPublish = 0;

const unsigned long SENSOR_INTERVAL = 5000;   // 5 seconds
const unsigned long MQTT_INTERVAL = 10000;    // 10 seconds

void setup() {
  Serial.begin(115200);
  Serial.println("Claude Code Ultimate IoT Device Starting...");
  
  // Initialize hardware
  pinMode(LED_PIN, OUTPUT);
  pinMode(BUTTON_PIN, INPUT_PULLUP);
  
  // Initialize sensors
  dht.begin();
  
  // Setup WiFi
  setupWiFi();
  
  // Setup MQTT
  setupMQTT();
  
  // Setup Web Server
  setupWebServer();
  
  // Setup OTA
  setupOTA();
  
  Serial.println("Device initialization complete!");
  digitalWrite(LED_PIN, HIGH); // Indicate ready
}

void loop() {
  // Handle OTA updates
  ArduinoOTA.handle();
  
  // Maintain WiFi connection
  if (WiFi.status() != WL_CONNECTED) {
    reconnectWiFi();
  }
  
  // Maintain MQTT connection
  if (!mqttClient.connected()) {
    reconnectMQTT();
  }
  mqttClient.loop();
  
  // Read sensors
  if (millis() - lastSensorRead > SENSOR_INTERVAL) {
    readSensors();
    lastSensorRead = millis();
  }
  
  // Publish data via MQTT
  if (millis() - lastMqttPublish > MQTT_INTERVAL) {
    publishSensorData();
    lastMqttPublish = millis();
  }
  
  // Handle button press
  if (digitalRead(BUTTON_PIN) == LOW) {
    handleButtonPress();
    delay(200); // Simple debounce
  }
}

void setupWiFi() {
  Serial.println("Connecting to WiFi...");
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  
  int attempts = 0;
  while (WiFi.status() != WL_CONNECTED && attempts < 20) {
    delay(500);
    Serial.print(".");
    attempts++;
  }
  
  if (WiFi.status() == WL_CONNECTED) {
    Serial.println("\\nWiFi connected!");
    Serial.print("IP address: ");
    Serial.println(WiFi.localIP());
  } else {
    Serial.println("\\nWiFi connection failed!");
  }
}

void setupMQTT() {
  mqttClient.setServer(MQTT_SERVER, MQTT_PORT);
  mqttClient.setCallback(mqttCallback);
  
  reconnectMQTT();
}

void setupWebServer() {
  // Serve status page
  server.on("/", HTTP_GET, [](AsyncWebServerRequest *request){
    String html = generateStatusPage();
    request->send(200, "text/html", html);
  });
  
  // API endpoint for sensor data
  server.on("/api/sensors", HTTP_GET, [](AsyncWebServerRequest *request){
    DynamicJsonDocument doc(1024);
    doc["temperature"] = temperature;
    doc["humidity"] = humidity;
    doc["status"] = deviceStatus;
    doc["uptime"] = millis();
    doc["free_heap"] = ESP.getFreeHeap();
    
    String jsonString;
    serializeJson(doc, jsonString);
    request->send(200, "application/json", jsonString);
  });
  
  // Configuration endpoint
  server.on("/api/config", HTTP_POST, [](AsyncWebServerRequest *request){
    // Handle configuration updates
    request->send(200, "application/json", "{\\"status\\":\\"updated\\"}");
  });
  
  server.begin();
  Serial.println("Web server started");
}

void setupOTA() {
  ArduinoOTA.setHostname(DEVICE_NAME);
  ArduinoOTA.setPassword(OTA_PASSWORD);
  
  ArduinoOTA.onStart([]() {
    Serial.println("OTA Update Starting...");
  });
  
  ArduinoOTA.onEnd([]() {
    Serial.println("\\nOTA Update Complete!");
  });
  
  ArduinoOTA.onProgress([](unsigned int progress, unsigned int total) {
    Serial.printf("Progress: %u%%\\r", (progress / (total / 100)));
  });
  
  ArduinoOTA.onError([](ota_error_t error) {
    Serial.printf("Error[%u]: ", error);
    if (error == OTA_AUTH_ERROR) Serial.println("Auth Failed");
    else if (error == OTA_BEGIN_ERROR) Serial.println("Begin Failed");
    else if (error == OTA_CONNECT_ERROR) Serial.println("Connect Failed");
    else if (error == OTA_RECEIVE_ERROR) Serial.println("Receive Failed");
    else if (error == OTA_END_ERROR) Serial.println("End Failed");
  });
  
  ArduinoOTA.begin();
}

void readSensors() {
  float newTemp = dht.readTemperature();
  float newHum = dht.readHumidity();
  
  if (!isnan(newTemp) && !isnan(newHum)) {
    temperature = newTemp;
    humidity = newHum;
    Serial.printf("Temp: %.1f°C, Humidity: %.1f%%\\n", temperature, humidity);
  } else {
    Serial.println("Failed to read from DHT sensor!");
  }
}

void publishSensorData() {
  if (mqttClient.connected()) {
    DynamicJsonDocument doc(1024);
    doc["device"] = DEVICE_NAME;
    doc["timestamp"] = millis();
    doc["temperature"] = temperature;
    doc["humidity"] = humidity;
    doc["status"] = deviceStatus;
    
    String jsonString;
    serializeJson(doc, jsonString);
    
    String topic = String(MQTT_TOPIC_PREFIX) + "/sensors";
    mqttClient.publish(topic.c_str(), jsonString.c_str());
    
    Serial.println("Data published to MQTT");
  }
}

void mqttCallback(char* topic, byte* payload, unsigned int length) {
  String message = "";
  for (int i = 0; i < length; i++) {
    message += (char)payload[i];
  }
  
  Serial.printf("MQTT message received on %s: %s\\n", topic, message.c_str());
  
  // Handle commands
  if (String(topic).endsWith("/commands")) {
    DynamicJsonDocument doc(1024);
    deserializeJson(doc, message);
    
    if (doc["command"] == "toggle_status") {
      deviceStatus = !deviceStatus;
      digitalWrite(LED_PIN, deviceStatus ? HIGH : LOW);
    }
  }
}

void reconnectWiFi() {
  Serial.println("Reconnecting to WiFi...");
  WiFi.reconnect();
  
  int attempts = 0;
  while (WiFi.status() != WL_CONNECTED && attempts < 10) {
    delay(500);
    attempts++;
  }
}

void reconnectMQTT() {
  while (!mqttClient.connected()) {
    Serial.print("Attempting MQTT connection...");
    
    if (mqttClient.connect(DEVICE_NAME, MQTT_USER, MQTT_PASSWORD)) {
      Serial.println("connected");
      
      // Subscribe to command topic
      String commandTopic = String(MQTT_TOPIC_PREFIX) + "/commands";
      mqttClient.subscribe(commandTopic.c_str());
      
    } else {
      Serial.print("failed, rc=");
      Serial.print(mqttClient.state());
      Serial.println(" try again in 5 seconds");
      delay(5000);
    }
  }
}

void handleButtonPress() {
  Serial.println("Button pressed!");
  deviceStatus = !deviceStatus;
  digitalWrite(LED_PIN, deviceStatus ? HIGH : LOW);
  
  // Send button press event via MQTT
  if (mqttClient.connected()) {
    String topic = String(MQTT_TOPIC_PREFIX) + "/events";
    mqttClient.publish(topic.c_str(), "{\\"event\\":\\"button_press\\"}");
  }
}

String generateStatusPage() {
  return String("<!DOCTYPE html><html><head><title>Device Status</title></head><body><h1>Claude IoT Device</h1><p>Temperature: " + String(temperature) + "°C</p><p>Humidity: " + String(humidity) + "%</p></body></html>");
}

# IoT Project Template - Claude Code Ultimate

Complete template for Internet of Things development with ESP32, Arduino, and Claude Code integration.

## 🚀 Features

- **Hardware Support**: ESP32, Arduino, Raspberry Pi ready
- **Firmware Development**: PlatformIO integration
- **Cloud Integration**: AWS IoT, Azure IoT, Google Cloud IoT
- **MCP Integration**: Specialized IoT development servers
- **SuperClaude Agents**: Hardware-specific development agents
- **Monitoring**: Real-time device monitoring and logging

## 🔧 Quick Setup

```bash
# 1. Copy this template to your project
copy C:\path\to\claude-code-ultimate\templates\iot-project C:\your-projects\my-iot-device -Recurse

# 2. Navigate to project
cd C:\your-projects\my-iot-device

# 3. Install PlatformIO (if not installed)
pip install platformio

# 4. Initialize PlatformIO project
pio project init
```

## 🎯 MCP Servers Included

- **Context7**: Hardware documentation and patterns
- **Sequential**: Complex IoT logic reasoning
- **Magic**: UI for device dashboards
- **Custom IoT MCP**: Hardware-specific tools (coming soon)

## 🤖 SuperClaude Integration

This template works with IoT-focused SuperClaude agents:

```bash
# Generate firmware code
claude /sc:implement "sensor reading with WiFi" --type firmware --platform esp32

# Hardware design assistance
claude /sc:design "circuit diagram for temperature monitoring" --hardware esp32

# Troubleshooting
claude /sc:troubleshoot "device connectivity issues" --platform iot
```

## 📁 Project Structure

```
iot-project/
├── firmware/
│   ├── src/             # Main firmware source
│   ├── lib/             # Custom libraries
│   ├── include/         # Header files
│   └── platformio.ini   # PlatformIO configuration
├── hardware/
│   ├── schematics/      # Circuit diagrams
│   ├── pcb/             # PCB design files
│   └── 3d-models/       # 3D printable parts
├── cloud/
│   ├── aws/             # AWS IoT configuration
│   ├── azure/           # Azure IoT configuration
│   └── gcp/             # Google Cloud IoT configuration
├── dashboard/
│   ├── web/             # Web-based dashboard
│   └── mobile/          # Mobile app (React Native)
├── docs/                # Project documentation
└── claude-config/       # Claude Code specific configs
```

## 🛠 Development Commands

```bash
# Firmware development
pio run                 # Build firmware
pio upload              # Upload to device
pio device monitor      # Monitor serial output

# Cloud deployment
npm run deploy:aws      # Deploy to AWS IoT
npm run deploy:azure    # Deploy to Azure IoT

# Dashboard
npm run dev:dashboard   # Start dashboard development
npm run build:dashboard # Build dashboard

# Claude Code integration
claude /sc:implement "add new sensor" --type firmware
claude /sc:troubleshoot "device not connecting"
```

## 🔌 Hardware Platforms

### ESP32
- **WiFi/Bluetooth**: Built-in connectivity
- **Sensors**: Temperature, humidity, motion, etc.
- **Actuators**: LEDs, motors, relays
- **Power Management**: Deep sleep, battery optimization

### Arduino
- **Multiple Boards**: Uno, Mega, Nano, etc.
- **Shields**: Ethernet, WiFi, sensor shields
- **Extensive Libraries**: Vast ecosystem support

### Raspberry Pi
- **Full Linux**: Complete development environment
- **GPIO Control**: Hardware interfacing
- **Camera Module**: Image processing
- **AI/ML**: Edge computing capabilities

## ☁️ Cloud Integration

### AWS IoT Core
- **Device Management**: Fleet management
- **MQTT Messaging**: Pub/sub communication
- **Rules Engine**: Data processing
- **Security**: Certificate-based authentication

### Azure IoT Hub
- **Device Twins**: Device state management
- **Direct Methods**: Remote device control
- **Telemetry**: Data ingestion
- **Edge Computing**: Local processing

### Google Cloud IoT
- **Device Registry**: Device management
- **Pub/Sub**: Message routing
- **Cloud Functions**: Event processing
- **BigQuery**: Data analytics

## 📊 Monitoring & Analytics

- **Real-time Dashboards**: Live device monitoring
- **Alerting**: Anomaly detection and notifications
- **Data Visualization**: Charts and graphs
- **Historical Analysis**: Trend analysis

## 🔒 Security

- **Certificate Management**: PKI-based security
- **Secure Boot**: Firmware integrity
- **OTA Updates**: Secure over-the-air updates
- **Data Encryption**: End-to-end encryption

## 📚 Getting Started

1. **Choose your hardware platform** (ESP32 recommended for beginners)
2. **Set up development environment** (PlatformIO + VS Code)
3. **Configure cloud services** based on your needs
4. **Start with basic examples** in the firmware/ directory
5. **Use SuperClaude agents** for development assistance

---

**💡 Tip**: This template includes example projects for common IoT scenarios like environmental monitoring, home automation, and industrial sensors.
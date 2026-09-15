# VeriSmat ESP32 Controller
### Native Android Mobile Application for ESP32 Educational Project Board

`VeriSmat ESP32 Controller` is a native Android mobile application created in FlutterFlow / Flutter. It functions as a direct local hardware controller for the **VeriSmat ESP32 educational project board**, enabling students and educators to select and control Grade 1–4 electronics projects over direct Wi-Fi with **zero internet connection, zero cloud dependency, and no router**.

---

## 📱 Hardware & Wi-Fi Architecture

```
 Android Phone / Tablet
           │
           │  (Direct Wi-Fi connection from Android Settings)
           ▼
 ESP32 Access Point: "VeriSmat-ESP32" (Password: "VeriSmat123")
           │
           │  (Fixed IP: http://192.168.4.1)
           ▼
 ESP32 Hardware Project Board
 (Autonomous GPIO, Sensors, Relays, PWM, Displays)
```

### Key Principles:
1. **Manual Wi-Fi Connection**: The application does **not** scan, connect, or manage Wi-Fi. The user connects once in Android's system Wi-Fi settings.
2. **Permanently Fixed IP**: All API requests strictly target `http://192.168.4.1`. The address is non-editable, non-discoverable, and permanent.
3. **Completely Offline**: Operates reliably even when Android displays "Wi-Fi has no Internet access". Cleartext HTTP is explicitly permitted in the Android network security config.

---

## 🗂️ Project Structure

```
verismat_esp32_controller/
├── android/
│   ├── app/
│   │   ├── src/main/
│   │   │   ├── AndroidManifest.xml              # Cleartext traffic, network permissions
│   │   │   ├── kotlin/com/verismat/esp32controller/MainActivity.kt
│   │   │   └── res/xml/network_security_config.xml # Strict cleartext whitelist for 192.168.4.1
│   │   └── build.gradle
│   ├── build.gradle
│   └── settings.gradle
├── lib/
│   ├── app_state.dart                           # FlutterFlow AppState (all 10 required variables)
│   ├── backend/
│   │   ├── api_requests/
│   │   │   ├── api_calls.dart                   # ESP32_Status, ESP32_Select, ESP32_Execute, ESP32_Stop
│   │   │   └── api_manager.dart                 # Offline HTTP client with timeouts & resilience
│   │   └── schema/
│   │       └── project_data.dart                # Grade 1–4 project definitions (6 projects each)
│   ├── flutter_flow/
│   │   ├── flutter_flow_theme.dart              # Modern educational dark/light electronics theme
│   │   ├── flutter_flow_util.dart               # Helpers, snackbars, navigation extensions
│   │   ├── flutter_flow_widgets.dart            # FFButtonWidget & FFButtonOptions
│   │   └── flutter_flow_icon_button.dart        # FlutterFlow icon button
│   ├── pages/
│   │   ├── splash/                              # Screen 1: Splash screen with auto-navigation
│   │   ├── home/                                # Screen 2: Connection card, Check Connection, Start
│   │   ├── grade_selection/                     # Screen 3: 4 large Grade cards (Grade 1 to 4)
│   │   ├── project_selection/                   # Screen 4: 6 projects for selected grade
│   │   ├── project_control/                     # Screen 5: Execute/Stop, 1.5s automatic polling
│   │   └── esp32_status/                        # Screen 6: Live hardware telemetry dashboard
│   ├── index.dart                               # Exports all page widgets
│   └── main.dart                                # Flutter app entry point & route definitions
├── test_server/
│   ├── esp32_mock_server.js                     # Node.js mock ESP32 server
│   └── test_api_client.js                       # Automated API contract test runner
├── FLUTTERFLOW_SETUP_GUIDE.md                   # Visual builder guide for FlutterFlow GUI
├── pubspec.yaml                                 # Flutter dependencies
└── README.md                                    # Documentation
```

---

## 📡 ESP32 API Specification

Base URL: `http://192.168.4.1`

| API Name | Method | Endpoint | Request Body | Expected Response |
| :--- | :--- | :--- | :--- | :--- |
| **`ESP32_Status`** | `GET` | `/api/status` | *None* | `{"wifi": true, "ssid": "VeriSmat-ESP32", "ip": "192.168.4.1", "grade": 2, "project": 3, "running": false, "projectName": "Temperature Indicator"}` |
| **`ESP32_Select`** | `POST` | `/api/select` | `{"grade": 2, "project": 3}` | `{"ok": true, "grade": 2, "project": 3}` |
| **`ESP32_Execute`**| `POST` | `/api/execute`| *None* | `{"ok": true, "running": true}` |
| **`ESP32_Stop`**   | `POST` | `/api/stop`   | *None* | `{"ok": true, "running": false}` |

> **Note on Numbering**: Numbers are strictly 1-based: Grade 1–4 and Project 1–6.

---

## 📚 Curriculum Project Catalog

### Grade 1: Elementary Foundations
1. **Push and Glow Board** — Tactile switches and basic LED circuit actuation.
2. **LED Pattern Board** — Sequential pulses and chasing light patterns.
3. **Sound Alert Box** — Audible buzzers and continuity alerts.
4. **Colour Light Selector** — Additive RGB tricolor light mixing.
5. **Traffic Light Model** — Timed state transitions replicating real-world signals.
6. **Rain Alert System** — Conductive water sensing plate with audio alarms.

### Grade 2: Intermediate Electronics
1. **Smart Night Lamp** — LDR photoresistor ambient light detector.
2. **Motion Alert System** — PIR passive infrared intrusion detection.
3. **Temperature Indicator** — Thermistor / analog threshold warning bar.
4. **Digital Counter Model** — 7-segment digital counter with BCD decoder.
5. **Password Entry System** — Keypad matrix security with feedback LEDs.
6. **Touch Music Panel** — Capacitive touch synthesizer pads.

### Grade 3: Advanced Control Systems
1. **Smart Room Monitor** — Environmental multi-sensor comfort monitoring.
2. **Distance Measurement System** — Ultrasonic echo distance calculation with alerts.
3. **Water Level Indicator** — Multi-depth fluid probe with overflow warning.
4. **Automated Gate System** — Motor driver and safety barrier limits.
5. **Smart Switch** — Opto-isolated power relay switching.
6. **Sensor Status Dashboard** — Real-time telemetry across board GPIO pins.

### Grade 4: Mastery & Embedded Mechatronics
1. **Servo Controlled Gate Model** — Angular PWM servo entrance boom barrier.
2. **Smart Parking Indicator System** — Bay occupancy sensors with red/green indicators.
3. **Event-Based Intrusion Recorder** — Trigger timestamping and persistent logging.
4. **Smart Energy Saving System** — Occupancy-aware automatic power conservation.
5. **Magnetic Door Status Monitor** — Reed switch perimeter aperture monitoring.
6. **Laser Tripwire Security System** — Visible beam photoelectric tripwire lockdown.

---

## 🚀 Testing with the Mock ESP32 Server

You can verify the entire app without physical ESP32 hardware using the included Node.js mock server:

1. **Start the Mock Server**:
   ```bash
   node test_server/esp32_mock_server.js
   ```

2. **Run the Automated Test Client**:
   ```bash
   node test_server/test_api_client.js
   ```
   All 6 tests verify status querying, project selection, execution, polling reflection, and stopping.

---

## 🔨 Building the Android APK

To compile the native Android APK:
```bash
flutter pub get
flutter build apk --release
```
The output APK will be located at:
`build/app/outputs/flutter-apk/app-release.apk`

Transfer this APK to any Android phone or tablet. Connect to `VeriSmat-ESP32` Wi-Fi in Android Settings, open the app, and tap **CHECK CONNECTION**.

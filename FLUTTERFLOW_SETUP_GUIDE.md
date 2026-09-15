# FlutterFlow Visual Builder Setup Guide
## VeriSmat ESP32 Controller (Native Android Mobile App)

This guide provides step-by-step instructions for setting up the **VeriSmat ESP32 Controller** within the **FlutterFlow Web/Desktop Visual Builder** (`flutterflow.io`), ensuring 100% fidelity to the native code structure and offline ESP32 communication requirements.

---

## 1. Project Initialization & Platform Settings
1. Create a new project in FlutterFlow named: `VeriSmat ESP32 Controller`.
2. Under **Project Settings → General**:
   - **Initial Page**: `Splash`
   - **Entry Page (Authenticated/Main)**: `Home`
   - **Platform Targets**: Ensure **Android Mobile & Tablet** is enabled. Disable Web if prompted.
3. Under **Project Settings → Android Permissions & Configuration**:
   - Enable `INTERNET` and `ACCESS_NETWORK_STATE`.
   - In **Custom Android Manifest** (or via FlutterFlow Advanced Settings):
     ```xml
     android:usesCleartextTraffic="true"
     ```
   - This allows HTTP communication to `http://192.168.4.1` on Android 9.0+.

---

## 2. Defining App State Variables
Navigate to **App State** in the left sidebar and create the following 10 variables:

| Variable Name | Type | Default Value | Persisted? | Notes |
| :--- | :--- | :--- | :--- | :--- |
| `selectedGrade` | Integer | `0` | No | Current grade chosen (1–4) |
| `selectedProject` | Integer | `0` | No | Current project chosen (1–6) |
| `selectedProjectName` | String | `""` | No | Name of selected project |
| `esp32Connected` | Boolean | `false` | No | True if ESP32 responds |
| `projectRunning` | Boolean | `false` | No | True if ESP32 is running |
| `currentGrade` | Integer | `0` | No | Active grade from ESP32 |
| `currentProject` | Integer | `0` | No | Active project from ESP32 |
| `currentProjectName` | String | `""` | No | Active project name from ESP32 |
| `esp32IP` | String | `192.168.4.1` | No | **FIXED**. Never allow edit. |
| `esp32SSID` | String | `VeriSmat-ESP32` | No | Access point SSID |

---

## 3. Configuring API Calls in FlutterFlow
Navigate to **API Calls** (`</>`) and create a group or standalone calls:

### API 1: `ESP32_Status`
- **Method**: `GET`
- **API URL**: `http://192.168.4.1/api/status`
- **Headers**: None required.
- **JSON Paths**:
  - `wifi`: `$.wifi` (Boolean)
  - `ssid`: `$.ssid` (String)
  - `ip`: `$.ip` (String)
  - `grade`: `$.grade` (Integer)
  - `project`: `$.project` (Integer)
  - `running`: `$.running` (Boolean)
  - `projectName`: `$.projectName` (String)

### API 2: `ESP32_Select`
- **Method**: `POST`
- **API URL**: `http://192.168.4.1/api/select`
- **Headers**: `Content-Type: application/json`
- **Variables**:
  - `grade` (Integer)
  - `project` (Integer)
- **JSON Body**:
  ```json
  {
    "grade": [grade],
    "project": [project]
  }
  ```
- **JSON Paths**:
  - `ok`: `$.ok` (Boolean)

### API 3: `ESP32_Execute`
- **Method**: `POST`
- **API URL**: `http://192.168.4.1/api/execute`
- **Headers**: `Content-Type: application/json`
- **Body**: None (or empty JSON `{}`)
- **JSON Paths**:
  - `ok`: `$.ok` (Boolean)
  - `running`: `$.running` (Boolean)

### API 4: `ESP32_Stop`
- **Method**: `POST`
- **API URL**: `http://192.168.4.1/api/stop`
- **Headers**: `Content-Type: application/json`
- **Body**: None (or empty JSON `{}`)
- **JSON Paths**:
  - `ok`: `$.ok` (Boolean)
  - `running`: `$.running` (Boolean)

---

## 4. Screen Construction & Action Flows

### Screen 1: Splash (`Splash`)
- **UI Elements**:
  - Background dark slate (`#0B1120`).
  - Centered Container with microchip icon (`Icons.memory`).
  - Title: `VeriSmat` (Bold 36pt).
  - Subtitle: `ESP32 Smart Learning Controller` (Cyan 16pt).
- **On Page Load Action**:
  - Action 1: **Wait (Delay)** `2000 ms`.
  - Action 2: **Navigate to** `Home` (Replace Route).

---

### Screen 2: Home (`Home`)
- **UI Elements**:
  - Top AppBar: Title `VeriSmat ESP32 Controller` with status icon.
  - Connection Status Card:
    - Label `ESP32 STATUS` with dynamic indicator:
      - If `FFAppState().esp32Connected == true`: `● CONNECTED` (Green).
      - Else: `● NOT CONNECTED` (Red).
    - `ESP32 IP`: Display `192.168.4.1` (Text widget, non-editable).
    - `Wi-Fi Network`: Display `VeriSmat-ESP32`.
    - Conditional Text (when `esp32Connected == false`):
      `"Connect your Android device to VeriSmat-ESP32 using Android Wi-Fi Settings."`
    - **CHECK CONNECTION** Button:
      - **Action Flow**:
        1. Call API `ESP32_Status`.
        2. If Succeeded:
           - Update App State `esp32Connected = true`.
           - Update App State `projectRunning = getJsonField(response, '$.running')`.
           - Update App State `currentGrade = getJsonField(response, '$.grade')`.
           - Update App State `currentProject = getJsonField(response, '$.project')`.
           - Update App State `currentProjectName = getJsonField(response, '$.projectName')`.
           - Show SnackBar: "Connected to ESP32 board at 192.168.4.1".
        3. If Failed:
           - Update App State `esp32Connected = false`.
           - Show SnackBar (Alert): "Connect your Android device to VeriSmat-ESP32 using Android Wi-Fi Settings."
    - **START LEARNING** Button:
      - **Action**: Navigate to `GradeSelection`.
    - Bottom Button: `VIEW HARDWARE TELEMETRY` → Navigate to `ESP32Status`.

---

### Screen 3: Grade Selection (`GradeSelection`)
- **UI Elements**:
  - Header: `Select Grade`.
  - 4 Large Cards:
    - **GRADE 1**: Circuits & Visual Indicators (Elementary Foundations)
    - **GRADE 2**: Sensors & Interactive Controls (Intermediate Electronics)
    - **GRADE 3**: Automation & Environmental Systems (Advanced Control Systems)
    - **GRADE 4**: Robotics & Security Engineering (Mastery & Embedded Mechatronics)
- **On Tap Action on each card**:
  - Update App State: `selectedGrade = 1` (or 2, 3, 4).
  - Navigate to `ProjectSelection`.

---

### Screen 4: Project Selection (`ProjectSelection`)
- **Data Source**:
  - Filter list based on `FFAppState().selectedGrade`:
    - **Grade 1**: Push and Glow Board, LED Pattern Board, Sound Alert Box, Colour Light Selector, Traffic Light Model, Rain Alert System.
    - **Grade 2**: Smart Night Lamp, Motion Alert System, Temperature Indicator, Digital Counter Model, Password Entry System, Touch Music Panel.
    - **Grade 3**: Smart Room Monitor, Distance Measurement System, Water Level Indicator, Automated Gate System, Smart Switch, Sensor Status Dashboard.
    - **Grade 4**: Servo Controlled Gate Model, Smart Parking Indicator System, Event-Based Intrusion Recorder, Smart Energy Saving System, Magnetic Door Status Monitor, Laser Tripwire Security System.
- **On Project Selected Action**:
  - Step 1: Call API `ESP32_Select` with parameters:
    - `grade`: `FFAppState().selectedGrade`
    - `project`: `item.projectIndex` (1 to 6)
  - Step 2: Conditional Action (Check if `getJsonField(response, '$.ok') == true`):
    - **True**:
      - Update App State `selectedProject = item.projectIndex`.
      - Update App State `selectedProjectName = item.name`.
      - Update App State `currentGrade = FFAppState().selectedGrade`.
      - Update App State `currentProject = item.projectIndex`.
      - Update App State `currentProjectName = item.name`.
      - Navigate to `ProjectControl`.
    - **False**:
      - Show Alert Dialog:
        - Title: `Selection Failed`
        - Message: `The ESP32 could not receive the project selection.`

---

### Screen 5: Project Control (`ProjectControl`)
- **UI Elements**:
  - Title: `PROJECT CONTROL`.
  - Info Card:
    - Grade: `Grade [currentGrade]`.
    - Project: `[currentProjectName]`.
    - ESP32: `192.168.4.1`.
    - Status Banner:
      - If `projectRunning == true`: `PROJECT RUNNING` (Green glowing indicator).
      - Else: `PROJECT STOPPED` (Slate indicator).
  - **EXECUTE PROJECT** Button:
    - Enabled only when `projectRunning == false`.
    - Action:
      1. Call API `ESP32_Execute`.
      2. If Succeeded: Update App State `projectRunning = true`.
      3. If Failed: Show Alert Dialog:
         - Title: `Execution Failed`
         - Message: `The ESP32 could not start the project.`
  - **STOP PROJECT** Button:
    - Enabled only when `projectRunning == true`.
    - Action:
      1. Call API `ESP32_Stop`.
      2. If Succeeded: Update App State `projectRunning = false`.
      3. If Failed: Show Alert Dialog:
         - Title: `Stop Failed`
         - Message: `The ESP32 could not stop the project.`
- **Automatic Polling Timer**:
  - In FlutterFlow, add a **Periodic Action** on page load:
    - Frequency: `1500 ms`.
    - Action: Call API `ESP32_Status`.
    - Update App State: `projectRunning`, `currentGrade`, `currentProject`, `currentProjectName`.
    - Stop Periodic Action automatically on page exit.

---

### Screen 6: ESP32 Status (`ESP32Status`)
- **UI Elements**:
  - Title: `ESP32 STATUS`.
  - Detailed Telemetry rows:
    - **Connection**: `CONNECTED` / `NOT CONNECTED`
    - **Wi-Fi**: `VeriSmat-ESP32`
    - **IP**: `192.168.4.1`
    - **Current Grade**: `Grade X`
    - **Current Project**: `Project Name`
    - **Running**: `YES` / `NO`
  - **REFRESH STATUS** Button:
    - Calls API `ESP32_Status`.
    - Updates `esp32Connected`, `projectRunning`, etc.
    - Shows feedback SnackBar.

---

## 5. Offline Android Wi-Fi Workflow Reminder
Remember that Android users connect to the ESP32 network manually:
1. Power ON ESP32 board.
2. Open Android Settings → Wi-Fi.
3. Select `VeriSmat-ESP32` and enter password `VeriSmat123`.
4. If Android displays *"Wi-Fi has no Internet access. Keep connection?"*, select **Yes / Keep Connected**.
5. Switch back to the VeriSmat Android application and tap **CHECK CONNECTION**.

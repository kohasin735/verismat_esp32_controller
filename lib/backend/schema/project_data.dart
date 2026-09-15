import 'package:flutter/material.dart';

class ProjectItem {
  final int grade;
  final int project;
  final String name;
  final String description;
  final IconData icon;
  final Color themeColor;
  final List<String> components;

  const ProjectItem({
    required this.grade,
    required this.project,
    required this.name,
    required this.description,
    required this.icon,
    required this.themeColor,
    required this.components,
  });
}

class GradeInfo {
  final int gradeNumber;
  final String title;
  final String subtitle;
  final String level;
  final IconData icon;
  final Color primaryColor;
  final Color accentColor;
  final List<ProjectItem> projects;

  const GradeInfo({
    required this.gradeNumber,
    required this.title,
    required this.subtitle,
    required this.level,
    required this.icon,
    required this.primaryColor,
    required this.accentColor,
    required this.projects,
  });
}

class ProjectCatalog {
  static const List<ProjectItem> grade1Projects = [
    ProjectItem(
      grade: 1,
      project: 1,
      name: 'Push and Glow Board',
      description: 'Learn simple electrical circuits and push-button actuation controlling LED arrays.',
      icon: Icons.touch_app,
      themeColor: Color(0xFF00B4D8),
      components: ['Tactile Switch', 'LED Array', 'Resistor Bank'],
    ),
    ProjectItem(
      grade: 1,
      project: 2,
      name: 'LED Pattern Board',
      description: 'Explore sequential digital pulses and decorative chasing light patterns.',
      icon: Icons.lightbulb_outline,
      themeColor: Color(0xFF48CAE4),
      components: ['RGB LEDs', 'Digital Shift Register', 'ESP32 GPIO'],
    ),
    ProjectItem(
      grade: 1,
      project: 3,
      name: 'Sound Alert Box',
      description: 'Generate audible buzzers and frequency alerts triggered by circuit continuity.',
      icon: Icons.volume_up,
      themeColor: Color(0xFF06D6A0),
      components: ['Piezo Buzzer', 'NPN Transistor', 'Capacitor'],
    ),
    ProjectItem(
      grade: 1,
      project: 4,
      name: 'Colour Light Selector',
      description: 'Mix primary additive light colors (Red, Green, Blue) using mechanical selectors.',
      icon: Icons.palette,
      themeColor: Color(0xFFFFB703),
      components: ['Tricolor LED', 'Rotary Selector', 'Diffuser'],
    ),
    ProjectItem(
      grade: 1,
      project: 5,
      name: 'Traffic Light Model',
      description: 'Program timed state transitions replicating real-world automated traffic lights.',
      icon: Icons.traffic,
      themeColor: Color(0xFFEF476F),
      components: ['Red/Yellow/Green LEDs', 'Timer Module', 'Display'],
    ),
    ProjectItem(
      grade: 1,
      project: 6,
      name: 'Rain Alert System',
      description: 'Detect moisture and water presence using conductive grid sensing plates.',
      icon: Icons.water_drop,
      themeColor: Color(0xFF118AB2),
      components: ['Raindrop Sensor Plate', 'Comparator IC', 'Audio Alarm'],
    ),
  ];

  static const List<ProjectItem> grade2Projects = [
    ProjectItem(
      grade: 2,
      project: 1,
      name: 'Smart Night Lamp',
      description: 'LDR photoresistor-controlled illumination that activates automatically in darkness.',
      icon: Icons.bedtime,
      themeColor: Color(0xFF7209B7),
      components: ['LDR Light Sensor', 'High-Power LED', 'Voltage Divider'],
    ),
    ProjectItem(
      grade: 2,
      project: 2,
      name: 'Motion Alert System',
      description: 'Passive infrared sensor detecting human movement and signaling an intrusion alarm.',
      icon: Icons.directions_walk,
      themeColor: Color(0xFFF72585),
      components: ['PIR Motion Sensor', 'Warning Strobe', 'Siren'],
    ),
    ProjectItem(
      grade: 2,
      project: 3,
      name: 'Temperature Indicator',
      description: 'Analog temperature monitoring with multi-color threshold warning indicators.',
      icon: Icons.thermostat,
      themeColor: Color(0xFFFB8500),
      components: ['Thermistor / DHT Sensor', 'Bar Graph LED', 'ADC Pin'],
    ),
    ProjectItem(
      grade: 2,
      project: 4,
      name: 'Digital Counter Model',
      description: 'Count physical events or button presses on a 7-segment digital display.',
      icon: Icons.pin,
      themeColor: Color(0xFF3A0CA3),
      components: ['7-Segment LED Display', 'BCD Driver IC', 'Reset Switch'],
    ),
    ProjectItem(
      grade: 2,
      project: 5,
      name: 'Password Entry System',
      description: 'Sequential passcode validation with success/error audio-visual feedback.',
      icon: Icons.lock_outline,
      themeColor: Color(0xFF4361EE),
      components: ['Keypad Matrix', 'Status LEDs', 'Memory Register'],
    ),
    ProjectItem(
      grade: 2,
      project: 6,
      name: 'Touch Music Panel',
      description: 'Capacitive touch contacts triggering musical notes and synthesizer tones.',
      icon: Icons.music_note,
      themeColor: Color(0xFF4CC9F0),
      components: ['Capacitive Touch Pads', 'DAC Output', 'Speaker Module'],
    ),
  ];

  static const List<ProjectItem> grade3Projects = [
    ProjectItem(
      grade: 3,
      project: 1,
      name: 'Smart Room Monitor',
      description: 'Combined ambient environment metrics monitoring comfort levels and ventilation.',
      icon: Icons.home_work,
      themeColor: Color(0xFF0077B6),
      components: ['DHT22 Temp & Humidity', 'Air Quality Probe', 'Status LCD'],
    ),
    ProjectItem(
      grade: 3,
      project: 2,
      name: 'Distance Measurement System',
      description: 'Ultrasonic echo distance calculation with real-time range warnings.',
      icon: Icons.straighten,
      themeColor: Color(0xFF0096C7),
      components: ['HC-SR04 Ultrasonic Sensor', 'OLED Display', 'Beep Rate Module'],
    ),
    ProjectItem(
      grade: 3,
      project: 3,
      name: 'Water Level Indicator',
      description: 'Multi-depth contact probe measuring fluid levels and overflow warnings.',
      icon: Icons.waves,
      themeColor: Color(0xFF03045E),
      components: ['Stainless Probes', 'Level Decoder', 'Sump Pump Relay'],
    ),
    ProjectItem(
      grade: 3,
      project: 4,
      name: 'Automated Gate System',
      description: 'Proximity detection opening safety barrier gates with motor driver controls.',
      icon: Icons.sensor_door,
      themeColor: Color(0xFF2A9D8F),
      components: ['Geared DC Motor', 'Limit Switches', 'H-Bridge Driver'],
    ),
    ProjectItem(
      grade: 3,
      project: 5,
      name: 'Smart Switch',
      description: 'Isolated relay activation controlling high-voltage educational demo appliances.',
      icon: Icons.toggle_on,
      themeColor: Color(0xFFE76F51),
      components: ['Opto-Isolated Relay', 'Snubber Circuit', 'LED Indicator'],
    ),
    ProjectItem(
      grade: 3,
      project: 6,
      name: 'Sensor Status Dashboard',
      description: 'Telemetry aggregator gathering inputs across all digital and analog board pins.',
      icon: Icons.dashboard_customize,
      themeColor: Color(0xFF264653),
      components: ['Multi-Sensor Bus', 'ADC Multiplexer', 'Serial Protocol'],
    ),
  ];

  static const List<ProjectItem> grade4Projects = [
    ProjectItem(
      grade: 4,
      project: 1,
      name: 'Servo Controlled Gate Model',
      description: 'Precision angular PWM servo positioning controlling entrance boom gates.',
      icon: Icons.precision_manufacturing,
      themeColor: Color(0xFF6A040F),
      components: ['SG90 Micro Servo', 'PWM Controller', 'Optical Sensor'],
    ),
    ProjectItem(
      grade: 4,
      project: 2,
      name: 'Smart Parking Indicator System',
      description: 'Bay occupancy sensing displaying vacant slots with red/green bay indicators.',
      icon: Icons.local_parking,
      themeColor: Color(0xFF9D0208),
      components: ['IR Obstacle Sensors', 'LED Bay Indicators', 'Slot Counter'],
    ),
    ProjectItem(
      grade: 4,
      project: 3,
      name: 'Event-Based Intrusion Recorder',
      description: 'Trigger-based security event timestamping with persistent local memory logging.',
      icon: Icons.security,
      themeColor: Color(0xFFD00000),
      components: ['Dual PIR Trigger', 'Tamper Switch', 'EEPROM/SPI Flash'],
    ),
    ProjectItem(
      grade: 4,
      project: 4,
      name: 'Smart Energy Saving System',
      description: 'Intelligent occupancy-aware load shedding and automated power conservation.',
      icon: Icons.eco,
      themeColor: Color(0xFF2D6A4F),
      components: ['Current Sensor Module', 'Solid State Relay', 'Power Meter'],
    ),
    ProjectItem(
      grade: 4,
      project: 5,
      name: 'Magnetic Door Status Monitor',
      description: 'Reed switch perimeter security monitoring door/window aperture status.',
      icon: Icons.meeting_room,
      themeColor: Color(0xFFE85D04),
      components: ['Magnetic Reed Switch', 'Debounce Filter', 'Alarm Trigger'],
    ),
    ProjectItem(
      grade: 4,
      project: 6,
      name: 'Laser Tripwire Security System',
      description: 'Visible beam photoelectric tripwire triggering instantaneous lockdown alert.',
      icon: Icons.highlight,
      themeColor: Color(0xFFDC2F02),
      components: ['Laser Diode Module', 'Photo-Transistor Receiver', 'Latching Circuit'],
    ),
  ];

  static const List<GradeInfo> grades = [
    GradeInfo(
      gradeNumber: 1,
      title: 'GRADE 1',
      subtitle: 'Circuits & Visual Indicators',
      level: 'Elementary Foundations',
      icon: Icons.looks_one,
      primaryColor: Color(0xFF0077B6),
      accentColor: Color(0xFF48CAE4),
      projects: grade1Projects,
    ),
    GradeInfo(
      gradeNumber: 2,
      title: 'GRADE 2',
      subtitle: 'Sensors & Interactive Controls',
      level: 'Intermediate Electronics',
      icon: Icons.looks_two,
      primaryColor: Color(0xFF5A189A),
      accentColor: Color(0xFF9D4EDD),
      projects: grade2Projects,
    ),
    GradeInfo(
      gradeNumber: 3,
      title: 'GRADE 3',
      subtitle: 'Automation & Environmental Systems',
      level: 'Advanced Control Systems',
      icon: Icons.looks_3,
      primaryColor: Color(0xFF1B4965),
      accentColor: Color(0xFF62B6CB),
      projects: grade3Projects,
    ),
    GradeInfo(
      gradeNumber: 4,
      title: 'GRADE 4',
      subtitle: 'Robotics & Security Engineering',
      level: 'Mastery & Embedded Mechatronics',
      icon: Icons.looks_4,
      primaryColor: Color(0xFF8B1E3F),
      accentColor: Color(0xFFBA3F65),
      projects: grade4Projects,
    ),
  ];

  static List<ProjectItem> getProjectsForGrade(int grade) {
    switch (grade) {
      case 1:
        return grade1Projects;
      case 2:
        return grade2Projects;
      case 3:
        return grade3Projects;
      case 4:
        return grade4Projects;
      default:
        return [];
    }
  }

  static String getProjectName(int grade, int project) {
    final list = getProjectsForGrade(grade);
    for (final p in list) {
      if (p.project == project) return p.name;
    }
    return 'Project $project';
  }
}

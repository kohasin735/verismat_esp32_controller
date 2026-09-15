import 'package:flutter/material.dart';

class FFAppState extends ChangeNotifier {
  static final FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  void initializePersistedState() {}

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  // App State Variables as required by specification

  int _selectedGrade = 0;
  int get selectedGrade => _selectedGrade;
  set selectedGrade(int value) {
    _selectedGrade = value;
    notifyListeners();
  }

  int _selectedProject = 0;
  int get selectedProject => _selectedProject;
  set selectedProject(int value) {
    _selectedProject = value;
    notifyListeners();
  }

  String _selectedProjectName = '';
  String get selectedProjectName => _selectedProjectName;
  set selectedProjectName(String value) {
    _selectedProjectName = value;
    notifyListeners();
  }

  bool _esp32Connected = false;
  bool get esp32Connected => _esp32Connected;
  set esp32Connected(bool value) {
    _esp32Connected = value;
    notifyListeners();
  }

  bool _projectRunning = false;
  bool get projectRunning => _projectRunning;
  set projectRunning(bool value) {
    _projectRunning = value;
    notifyListeners();
  }

  int _currentGrade = 0;
  int get currentGrade => _currentGrade;
  set currentGrade(int value) {
    _currentGrade = value;
    notifyListeners();
  }

  int _currentProject = 0;
  int get currentProject => _currentProject;
  set currentProject(int value) {
    _currentProject = value;
    notifyListeners();
  }

  String _currentProjectName = '';
  String get currentProjectName => _currentProjectName;
  set currentProjectName(String value) {
    _currentProjectName = value;
    notifyListeners();
  }

  // FIXED ESP32 IP ADDRESS: MUST ALWAYS REMAIN 192.168.4.1
  // Non-modifiable per specification requirement
  static const String _fixedEsp32IP = '192.168.4.1';
  String get esp32IP => _fixedEsp32IP;

  static const String _fixedEsp32SSID = 'VeriSmat-ESP32';
  String get esp32SSID => _fixedEsp32SSID;

  // Helper methods to update status safely from polling
  void updateFromStatusResponse({
    required bool connected,
    bool? running,
    int? grade,
    int? project,
    String? projectName,
  }) {
    _esp32Connected = connected;
    if (connected) {
      if (running != null) _projectRunning = running;
      if (grade != null) _currentGrade = grade;
      if (project != null) _currentProject = project;
      if (projectName != null && projectName.isNotEmpty) {
        _currentProjectName = projectName;
      }
    }
    notifyListeners();
  }
}

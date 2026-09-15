import 'dart:async';
import 'package:flutter/material.dart';

class ProjectControlModel {
  bool isExecuting = false;
  bool isStopping = false;
  Timer? pollingTimer;
  bool isPollingActive = false;

  void initState(BuildContext context) {}
  void dispose() {
    pollingTimer?.cancel();
    pollingTimer = null;
    isPollingActive = false;
  }
}

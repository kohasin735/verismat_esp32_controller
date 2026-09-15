import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app_state.dart';
import '../../backend/api_requests/api_calls.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';
import 'project_control_model.dart';

class ProjectControlWidget extends StatefulWidget {
  const ProjectControlWidget({super.key});

  static const String routeName = '/project_control';

  @override
  State<ProjectControlWidget> createState() => _ProjectControlWidgetState();
}

class _ProjectControlWidgetState extends State<ProjectControlWidget> with SingleTickerProviderStateMixin {
  late ProjectControlModel _model;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _model = ProjectControlModel();
    _model.initState(context);

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Initial status fetch immediately
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _pollStatus();
      _startPollingTimer();
    });
  }

  @override
  void dispose() {
    _model.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  // Polling every 1.5 seconds while screen is active
  void _startPollingTimer() {
    _model.pollingTimer?.cancel();
    _model.isPollingActive = true;
    _model.pollingTimer = Timer.periodic(const Duration(milliseconds: 1500), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      _pollStatus();
    });
  }

  Future<void> _pollStatus() async {
    final appState = Provider.of<FFAppState>(context, listen: false);

    try {
      final response = await ESP32StatusCall.call();
      if (!mounted) return;

      if (response.succeeded && response.jsonBody != null) {
        final running = ESP32StatusCall.running(response.jsonBody);
        final grade = ESP32StatusCall.grade(response.jsonBody);
        final project = ESP32StatusCall.project(response.jsonBody);
        final projectName = ESP32StatusCall.projectName(response.jsonBody);

        appState.updateFromStatusResponse(
          connected: true,
          running: running,
          grade: grade,
          project: project,
          projectName: projectName,
        );
      } else {
        appState.esp32Connected = false;
      }
    } catch (_) {
      // Quiet background polling error - do not interrupt user
    }
  }

  // Execute Project: POST http://192.168.4.1/api/execute
  Future<void> _executeProject() async {
    final appState = Provider.of<FFAppState>(context, listen: false);
    if (_model.isExecuting || appState.projectRunning) return;

    setState(() {
      _model.isExecuting = true;
    });

    try {
      final response = await ESP32ExecuteCall.call();
      if (!mounted) return;

      final isOk = response.succeeded && ESP32ExecuteCall.ok(response.jsonBody) == true;

      if (isOk) {
        appState.projectRunning = true;
        appState.esp32Connected = true;
        showCustomSnackBar(
          context,
          message: 'Project started successfully on ESP32.',
          isError: false,
        );
      } else {
        _showErrorDialog(
          title: 'Execution Failed',
          message: 'The ESP32 could not start the project.',
        );
      }
    } catch (_) {
      if (mounted) {
        _showErrorDialog(
          title: 'Execution Failed',
          message: 'The ESP32 could not start the project.',
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _model.isExecuting = false;
        });
      }
    }
  }

  // Stop Project: POST http://192.168.4.1/api/stop
  Future<void> _stopProject() async {
    final appState = Provider.of<FFAppState>(context, listen: false);
    if (_model.isStopping) return;

    setState(() {
      _model.isStopping = true;
    });

    try {
      final response = await ESP32StopCall.call();
      if (!mounted) return;

      final isOk = response.succeeded && ESP32StopCall.ok(response.jsonBody) == true;

      if (isOk) {
        appState.projectRunning = false;
        appState.esp32Connected = true;
        showCustomSnackBar(
          context,
          message: 'Project stopped on ESP32.',
          isError: false,
        );
      } else {
        _showErrorDialog(
          title: 'Stop Failed',
          message: 'The ESP32 could not stop the project.',
        );
      }
    } catch (_) {
      if (mounted) {
        _showErrorDialog(
          title: 'Stop Failed',
          message: 'The ESP32 could not stop the project.',
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _model.isStopping = false;
        });
      }
    }
  }

  void _showErrorDialog({required String title, required String message}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
          side: const BorderSide(color: Color(0xFFEF4444), width: 1.2),
        ),
        title: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Color(0xFFEF4444), size: 24.0),
            const SizedBox(width: 10.0),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: const TextStyle(
            color: Color(0xFFCBD5E1),
            fontSize: 14.0,
            height: 1.4,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'OK',
              style: TextStyle(
                color: Color(0xFF38BDF8),
                fontWeight: FontWeight.bold,
                fontSize: 15.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final appState = Provider.of<FFAppState>(context);

    final gradeNumber = appState.currentGrade > 0 ? appState.currentGrade : appState.selectedGrade;
    final projectName = appState.currentProjectName.isNotEmpty
        ? appState.currentProjectName
        : (appState.selectedProjectName.isNotEmpty ? appState.selectedProjectName : 'Active Experiment');
    final isRunning = appState.projectRunning;

    return Scaffold(
      backgroundColor: theme.primaryBackground,
      appBar: AppBar(
        backgroundColor: theme.secondaryBackground,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: theme.primaryText, size: 20.0),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'PROJECT CONTROL',
          style: theme.title2.override(
            fontSize: 18.0,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.8,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'ESP32 Status',
            icon: Icon(Icons.tune, color: theme.primaryText),
            onPressed: () {
              Navigator.of(context).pushNamed('/esp32_status');
            },
          ),
          const SizedBox(width: 8.0),
        ],
        elevation: 0.0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: theme.cardBorder,
            height: 1.0,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Project Info Card
              Container(
                padding: const EdgeInsets.all(22.0),
                decoration: BoxDecoration(
                  color: theme.secondaryBackground,
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(color: theme.cardBorder),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 14.0,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                          decoration: BoxDecoration(
                            color: theme.primary.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Text(
                            'Grade $gradeNumber',
                            style: TextStyle(
                              color: theme.primary,
                              fontSize: 13.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.memory, size: 16.0, color: Color(0xFF94A3B8)),
                            const SizedBox(width: 6.0),
                            Text(
                              'ESP32',
                              style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                                color: theme.secondaryText,
                              ),
                            ),
                            const SizedBox(width: 4.0),
                            Text(
                              appState.esp32IP,
                              style: const TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 12.0,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF38BDF8),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 14.0),

                    // Project Name
                    Text(
                      projectName,
                      style: theme.title1.override(
                        fontSize: 22.0,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const Divider(height: 28.0),

                    // Hardware Execution State Display
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                      decoration: BoxDecoration(
                        color: isRunning
                            ? const Color(0xFF10B981).withOpacity(0.12)
                            : const Color(0xFF334155).withOpacity(0.3),
                        borderRadius: BorderRadius.circular(14.0),
                        border: Border.all(
                          color: isRunning
                              ? const Color(0xFF10B981).withOpacity(0.5)
                              : theme.cardBorder,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              if (isRunning)
                                ScaleTransition(
                                  scale: _pulseAnimation,
                                  child: Container(
                                    width: 14.0,
                                    height: 14.0,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF10B981),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                )
                              else
                                Container(
                                  width: 14.0,
                                  height: 14.0,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF94A3B8),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              const SizedBox(width: 12.0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Status:',
                                    style: TextStyle(
                                      fontSize: 11.0,
                                      color: theme.secondaryText,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    isRunning ? 'PROJECT RUNNING' : 'PROJECT STOPPED',
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.5,
                                      color: isRunning
                                          ? const Color(0xFF10B981)
                                          : const Color(0xFF94A3B8),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                            decoration: BoxDecoration(
                              color: theme.primaryBackground,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.sync, size: 12.0, color: Color(0xFF38BDF8)),
                                const SizedBox(width: 4.0),
                                Text(
                                  'Polling 1.5s',
                                  style: TextStyle(
                                    fontSize: 10.0,
                                    fontWeight: FontWeight.w500,
                                    color: theme.secondaryText,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32.0),

              // ==========================================
              // ACTION BUTTONS: EXECUTE / STOP
              // ==========================================

              // PRIMARY BUTTON: EXECUTE PROJECT
              FFButtonWidget(
                text: 'EXECUTE PROJECT',
                loading: _model.isExecuting,
                iconData: Icons.play_arrow_rounded,
                // Do not repeatedly send Execute requests while the project is already running
                onPressed: (isRunning || _model.isExecuting) ? null : _executeProject,
                options: FFButtonOptions(
                  width: double.infinity,
                  height: 58.0,
                  color: const Color(0xFF10B981),
                  disabledColor: const Color(0xFF1E293B),
                  disabledTextColor: const Color(0xFF64748B),
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                  ),
                  borderRadius: BorderRadius.circular(16.0),
                  elevation: isRunning ? 0.0 : 4.0,
                ),
              ),

              const SizedBox(height: 16.0),

              // SHOW: STOP PROJECT
              FFButtonWidget(
                text: 'STOP PROJECT',
                loading: _model.isStopping,
                iconData: Icons.stop_rounded,
                onPressed: (!isRunning || _model.isStopping) ? null : _stopProject,
                options: FFButtonOptions(
                  width: double.infinity,
                  height: 58.0,
                  color: const Color(0xFFEF4444),
                  disabledColor: const Color(0xFF1E293B),
                  disabledTextColor: const Color(0xFF64748B),
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                  ),
                  borderRadius: BorderRadius.circular(16.0),
                  elevation: isRunning ? 4.0 : 0.0,
                ),
              ),

              const SizedBox(height: 28.0),

              // Hardware Control Advisory Box
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: theme.secondaryBackground,
                  borderRadius: BorderRadius.circular(14.0),
                  border: Border.all(color: theme.cardBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, size: 18.0, color: theme.primary),
                        const SizedBox(width: 8.0),
                        Text(
                          'BOARD EXECUTION INFO',
                          style: TextStyle(
                            fontSize: 11.0,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.8,
                            color: theme.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    const Text(
                      '• The ESP32 autonomously executes hardware pins, timers, and sensors.\n'
                      '• Tapping STOP safely de-energizes actuators, relays, and LED arrays.\n'
                      '• Live status is queried every 1.5 seconds directly over Wi-Fi without internet.',
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Color(0xFF94A3B8),
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app_state.dart';
import '../../backend/api_requests/api_calls.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';
import 'esp32_status_model.dart';

class ESP32StatusWidget extends StatefulWidget {
  const ESP32StatusWidget({super.key});

  static const String routeName = '/esp32_status';

  @override
  State<ESP32StatusWidget> createState() => _ESP32StatusWidgetState();
}

class _ESP32StatusWidgetState extends State<ESP32StatusWidget> {
  late ESP32StatusModel _model;

  @override
  void initState() {
    super.initState();
    _model = ESP32StatusModel();
    _model.initState(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshStatus(silent: true);
    });
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  // Button REFRESH STATUS calls GET http://192.168.4.1/api/status
  Future<void> _refreshStatus({bool silent = false}) async {
    if (_model.isRefreshing) return;

    setState(() {
      _model.isRefreshing = true;
    });

    final appState = Provider.of<FFAppState>(context, listen: false);

    try {
      final response = await ESP32StatusCall.call();
      if (!mounted) return;

      if (response.succeeded && response.jsonBody != null) {
        final wifi = ESP32StatusCall.wifi(response.jsonBody) ?? true;
        final running = ESP32StatusCall.running(response.jsonBody);
        final grade = ESP32StatusCall.grade(response.jsonBody);
        final project = ESP32StatusCall.project(response.jsonBody);
        final projectName = ESP32StatusCall.projectName(response.jsonBody);

        appState.updateFromStatusResponse(
          connected: wifi,
          running: running,
          grade: grade,
          project: project,
          projectName: projectName,
        );

        if (!silent) {
          showCustomSnackBar(
            context,
            message: 'ESP32 Status refreshed successfully.',
            isError: false,
          );
        }
      } else {
        appState.esp32Connected = false;
        if (!silent) {
          showCustomSnackBar(
            context,
            message: 'ESP32 Not Connected: Please connect your Android device to VeriSmat-ESP32 using Android Wi-Fi Settings.',
            isError: true,
          );
        }
      }
    } catch (_) {
      if (mounted) {
        appState.esp32Connected = false;
        if (!silent) {
          showCustomSnackBar(
            context,
            message: 'ESP32 Not Connected: Please connect your Android device to VeriSmat-ESP32 using Android Wi-Fi Settings.',
            isError: true,
          );
        }
      }
    } finally {
      if (mounted) {
        setState(() {
          _model.isRefreshing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final appState = Provider.of<FFAppState>(context);
    final isConnected = appState.esp32Connected;
    final isRunning = appState.projectRunning;

    final displayGrade = appState.currentGrade > 0
        ? 'Grade ${appState.currentGrade}'
        : (appState.selectedGrade > 0 ? 'Grade ${appState.selectedGrade}' : 'None');

    final displayProject = appState.currentProjectName.isNotEmpty
        ? appState.currentProjectName
        : (appState.selectedProjectName.isNotEmpty
            ? appState.selectedProjectName
            : (appState.currentProject > 0 ? 'Project ${appState.currentProject}' : 'None'));

    return Scaffold(
      backgroundColor: theme.primaryBackground,
      appBar: AppBar(
        backgroundColor: theme.secondaryBackground,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: theme.primaryText, size: 20.0),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'ESP32 STATUS',
          style: theme.title2.override(
            fontSize: 18.0,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.8,
          ),
        ),
        centerTitle: true,
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
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Main Hardware Status Card
              Container(
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
                padding: const EdgeInsets.all(22.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section Title
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: theme.primary.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Icon(Icons.terminal, color: theme.primary, size: 20.0),
                        ),
                        const SizedBox(width: 12.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ESP32 STATUS',
                              style: theme.title3.override(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.8,
                              ),
                            ),
                            Text(
                              'Live Hardware Board Telemetry',
                              style: theme.bodyText2,
                            ),
                          ],
                        ),
                      ],
                    ),

                    const Divider(height: 28.0),

                    // Connection: CONNECTED / NOT CONNECTED
                    _buildTelemetryRow(
                      label: 'Connection:',
                      value: isConnected ? 'CONNECTED' : 'NOT CONNECTED',
                      valueColor: isConnected ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                      icon: Icons.link,
                      badge: isConnected ? Icons.check_circle : Icons.cancel,
                    ),

                    const Divider(height: 20.0),

                    // Wi-Fi: VeriSmat-ESP32
                    _buildTelemetryRow(
                      label: 'Wi-Fi:',
                      value: appState.esp32SSID,
                      icon: Icons.wifi,
                    ),

                    const Divider(height: 20.0),

                    // IP: 192.168.4.1
                    _buildTelemetryRow(
                      label: 'IP:',
                      value: appState.esp32IP,
                      icon: Icons.lan,
                      isMonospace: true,
                    ),

                    const Divider(height: 20.0),

                    // Current Grade: Grade X
                    _buildTelemetryRow(
                      label: 'Current Grade:',
                      value: displayGrade,
                      icon: Icons.school,
                    ),

                    const Divider(height: 20.0),

                    // Current Project: Project Name
                    _buildTelemetryRow(
                      label: 'Current Project:',
                      value: displayProject,
                      icon: Icons.memory,
                    ),

                    const Divider(height: 20.0),

                    // Running: YES / NO
                    _buildTelemetryRow(
                      label: 'Running:',
                      value: isRunning ? 'YES' : 'NO',
                      valueColor: isRunning ? const Color(0xFF10B981) : const Color(0xFF94A3B8),
                      icon: Icons.play_circle_outline,
                      isBoldValue: true,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24.0),

              // REFRESH STATUS BUTTON
              FFButtonWidget(
                text: 'REFRESH STATUS',
                loading: _model.isRefreshing,
                iconData: Icons.refresh_rounded,
                onPressed: () => _refreshStatus(silent: false),
                options: FFButtonOptions(
                  width: double.infinity,
                  height: 52.0,
                  color: theme.primary,
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                  borderRadius: BorderRadius.circular(14.0),
                  elevation: 2.0,
                ),
              ),

              const SizedBox(height: 24.0),

              // Network Diagnostics Note
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
                    Text(
                      'NETWORK ARCHITECTURE',
                      style: TextStyle(
                        fontSize: 11.0,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                        color: theme.secondaryText,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    const Text(
                      'Android Phone  →  Wi-Fi: VeriSmat-ESP32  →  ESP32 (192.168.4.1)\n\n'
                      '• Standalone access point connection without router or internet gateway.\n'
                      '• Cleartext HTTP permitted exclusively for 192.168.4.1.\n'
                      '• All hardware commands execute locally on the ESP32 board.',
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Color(0xFF94A3B8),
                        height: 1.4,
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

  Widget _buildTelemetryRow({
    required String label,
    required String value,
    required IconData icon,
    Color? valueColor,
    IconData? badge,
    bool isMonospace = false,
    bool isBoldValue = false,
  }) {
    final theme = FlutterFlowTheme.of(context);

    return Row(
      children: [
        Icon(icon, size: 18.0, color: theme.secondaryText),
        const SizedBox(width: 10.0),
        Text(
          label,
          style: TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
            color: theme.secondaryText,
          ),
        ),
        const Spacer(),
        if (badge != null) ...[
          Icon(badge, size: 15.0, color: valueColor ?? theme.primaryText),
          const SizedBox(width: 5.0),
        ],
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 14.0,
              fontFamily: isMonospace ? 'monospace' : null,
              fontWeight: isBoldValue ? FontWeight.w800 : FontWeight.w700,
              color: valueColor ?? theme.primaryText,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

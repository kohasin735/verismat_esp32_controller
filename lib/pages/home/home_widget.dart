import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app_state.dart';
import '../../backend/api_requests/api_calls.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';
import 'home_model.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  static const String routeName = '/home';

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  late HomeModel _model;

  @override
  void initState() {
    super.initState();
    _model = HomeModel();
    _model.initState(context);

    // Initial silent connection check on page load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkConnection(silent: true);
    });
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _checkConnection({bool silent = false}) async {
    if (_model.isCheckingConnection) return;

    setState(() {
      _model.isCheckingConnection = true;
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
            message: 'Connected to ESP32 board at 192.168.4.1',
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
            message: 'Connect your Android device to VeriSmat-ESP32 using Android Wi-Fi Settings.',
            isError: true,
          );
        }
      }
    } finally {
      if (mounted) {
        setState(() {
          _model.isCheckingConnection = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final appState = Provider.of<FFAppState>(context);
    final isConnected = appState.esp32Connected;

    return Scaffold(
      backgroundColor: theme.primaryBackground,
      appBar: AppBar(
        backgroundColor: theme.secondaryBackground,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6.0),
              decoration: BoxDecoration(
                color: theme.primary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Icon(
                Icons.developer_board,
                color: theme.primary,
                size: 22.0,
              ),
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: Text(
                'VeriSmat ESP32 Controller',
                style: theme.title3.override(
                  fontWeight: FontWeight.w700,
                  fontSize: 18.0,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'ESP32 Status',
            icon: Icon(
              Icons.analytics_outlined,
              color: theme.primaryText,
            ),
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
              // Welcome / Header banner
              Container(
                padding: const EdgeInsets.all(18.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.secondaryBackground,
                      const Color(0xFF1E293B),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(18.0),
                  border: Border.all(color: theme.cardBorder),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Educational Project Board',
                            style: TextStyle(
                              color: theme.primary,
                              fontSize: 12.0,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            'VeriSmat Control Hub',
                            style: theme.title2.override(fontSize: 20.0),
                          ),
                          const SizedBox(height: 6.0),
                          Text(
                            'Direct offline Wi-Fi control for Grade 1–4 electronics experiments.',
                            style: theme.bodyText2,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12.0),
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: theme.primary.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(14.0),
                      ),
                      child: Icon(
                        Icons.sensors,
                        color: theme.primary,
                        size: 30.0,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20.0),

              // ==========================================
              // CONNECTION STATUS CARD
              // ==========================================
              Container(
                decoration: BoxDecoration(
                  color: theme.secondaryBackground,
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(
                    color: isConnected ? const Color(0xFF10B981) : theme.cardBorder,
                    width: isConnected ? 1.5 : 1.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isConnected
                          ? const Color(0xFF10B981).withOpacity(0.1)
                          : Colors.black.withOpacity(0.08),
                      blurRadius: 16.0,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(22.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'ESP32 STATUS',
                          style: theme.subtitle2.override(
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                            color: theme.secondaryText,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                          decoration: BoxDecoration(
                            color: isConnected
                                ? const Color(0xFF10B981).withOpacity(0.15)
                                : const Color(0xFFEF4444).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 8.0,
                                height: 8.0,
                                decoration: BoxDecoration(
                                  color: isConnected
                                      ? const Color(0xFF10B981)
                                      : const Color(0xFFEF4444),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6.0),
                              Text(
                                isConnected ? 'CONNECTED' : 'NOT CONNECTED',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w700,
                                  color: isConnected
                                      ? const Color(0xFF10B981)
                                      : const Color(0xFFEF4444),
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const Divider(height: 28.0),

                    // ESP32 IP Display (Fixed, non-editable)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: theme.primaryBackground,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Icon(Icons.lan, size: 20.0, color: theme.primary),
                        ),
                        const SizedBox(width: 12.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'ESP32 IP',
                                style: theme.bodyText2.override(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 2.0),
                              Row(
                                children: [
                                  Text(
                                    appState.esp32IP,
                                    style: const TextStyle(
                                      fontFamily: 'monospace',
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(width: 8.0),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                                    decoration: BoxDecoration(
                                      color: theme.primaryBackground,
                                      borderRadius: BorderRadius.circular(6.0),
                                    ),
                                    child: const Text(
                                      'FIXED',
                                      style: TextStyle(
                                        fontSize: 9.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14.0),

                    // Wi-Fi Network Display
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: theme.primaryBackground,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Icon(Icons.wifi, size: 20.0, color: theme.secondary),
                        ),
                        const SizedBox(width: 12.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Wi-Fi Network',
                                style: theme.bodyText2.override(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 2.0),
                              Text(
                                appState.esp32SSID,
                                style: theme.title3.override(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    // Guidance banner if NOT CONNECTED
                    if (!isConnected) ...[
                      const SizedBox(height: 18.0),
                      Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF2F2).withOpacity(0.08),
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(
                            color: const Color(0xFFEF4444).withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.info_outline,
                              color: Color(0xFFEF4444),
                              size: 18.0,
                            ),
                            const SizedBox(width: 10.0),
                            Expanded(
                              child: Text(
                                'Connect your Android device to VeriSmat-ESP32 using Android Wi-Fi Settings.',
                                style: TextStyle(
                                  color: theme.error,
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w500,
                                  height: 1.35,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 20.0),

                    // CHECK CONNECTION BUTTON
                    FFButtonWidget(
                      text: 'CHECK CONNECTION',
                      loading: _model.isCheckingConnection,
                      iconData: Icons.sync,
                      onPressed: () => _checkConnection(silent: false),
                      options: FFButtonOptions(
                        width: double.infinity,
                        height: 48.0,
                        color: theme.primary,
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28.0),

              // ==========================================
              // START LEARNING BUTTON
              // ==========================================
              FFButtonWidget(
                text: 'START LEARNING',
                iconData: Icons.school_outlined,
                onPressed: () {
                  Navigator.of(context).pushNamed('/grade_selection');
                },
                options: FFButtonOptions(
                  width: double.infinity,
                  height: 56.0,
                  color: const Color(0xFF10B981),
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                  ),
                  borderRadius: BorderRadius.circular(14.0),
                  elevation: 3.0,
                ),
              ),

              const SizedBox(height: 16.0),

              // Quick Access to ESP32 Status
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.of(context).pushNamed('/esp32_status');
                },
                icon: Icon(Icons.settings_ethernet, size: 18.0, color: theme.primaryText),
                label: Text(
                  'VIEW HARDWARE TELEMETRY',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                    color: theme.primaryText,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(46.0),
                  side: BorderSide(color: theme.cardBorder),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),

              const SizedBox(height: 24.0),

              // Educational Workflow Steps Guide
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
                      'QUICK WORKFLOW GUIDE',
                      style: TextStyle(
                        fontSize: 11.0,
                        fontWeight: FontWeight.bold,
                        color: theme.secondaryText,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    _buildStepRow('1', 'Power ON ESP32 educational board.'),
                    _buildStepRow('2', 'Connect Android Wi-Fi to VeriSmat-ESP32 (Password: VeriSmat123).'),
                    _buildStepRow('3', 'Tap CHECK CONNECTION above to confirm communication.'),
                    _buildStepRow('4', 'Tap START LEARNING to select Grade & Project.'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepRow(String number, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 18.0,
            height: 18.0,
            decoration: BoxDecoration(
              color: const Color(0xFF38BDF8).withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              number,
              style: const TextStyle(
                fontSize: 10.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFF38BDF8),
              ),
            ),
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 12.0,
                color: Color(0xFF94A3B8),
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

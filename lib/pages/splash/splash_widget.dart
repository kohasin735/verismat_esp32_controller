import 'dart:async';
import 'package:flutter/material.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import 'splash_model.dart';

class SplashWidget extends StatefulWidget {
  const SplashWidget({super.key});

  static const String routeName = '/splash';

  @override
  State<SplashWidget> createState() => _SplashWidgetState();
}

class _SplashWidgetState extends State<SplashWidget> with SingleTickerProviderStateMixin {
  late SplashModel _model;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  Timer? _navTimer;

  @override
  void initState() {
    super.initState();
    _model = SplashModel();
    _model.initState(context);

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.92, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // After a short delay navigate to Home
    _navTimer = Timer(const Duration(milliseconds: 2200), () {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    });
  }

  @override
  void dispose() {
    _navTimer?.cancel();
    _pulseController.dispose();
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return Scaffold(
      backgroundColor: theme.primaryBackground,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                theme.primaryBackground,
                const Color(0xFF0F172A),
                const Color(0xFF0B192C),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(flex: 2),

              // Animated ESP32 / Electronic Circuit Emblem
              ScaleTransition(
                scale: _pulseAnimation,
                child: Container(
                  width: 120.0,
                  height: 120.0,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(28.0),
                    border: Border.all(
                      color: theme.primary.withOpacity(0.6),
                      width: 2.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: theme.primary.withOpacity(0.35),
                        blurRadius: 28.0,
                        spreadRadius: 4.0,
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Circuit traces decorative icons
                      Icon(
                        Icons.memory,
                        size: 64.0,
                        color: theme.primary,
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Color(0xFF10B981),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 36.0),

              // Application Name
              Text(
                'VeriSmat',
                style: theme.title1.override(
                  fontSize: 38.0,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 10.0),

              // Subtitle
              Text(
                'ESP32 Smart Learning Controller',
                textAlign: TextAlign.center,
                style: theme.subtitle1.override(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF38BDF8),
                  letterSpacing: 0.2,
                ),
              ),

              const SizedBox(height: 8.0),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(color: const Color(0xFF334155)),
                ),
                child: const Text(
                  'Educational Hardware Platform',
                  style: TextStyle(
                    fontSize: 11.5,
                    color: Color(0xFF94A3B8),
                    letterSpacing: 0.8,
                  ),
                ),
              ),

              const Spacer(flex: 3),

              // Bottom loading bar / indicator
              SizedBox(
                width: 140.0,
                child: LinearProgressIndicator(
                  backgroundColor: const Color(0xFF1E293B),
                  valueColor: AlwaysStoppedAnimation<Color>(theme.primary),
                  minHeight: 3.5,
                ),
              ),

              const SizedBox(height: 16.0),

              const Text(
                'Initializing Direct Local Wi-Fi...',
                style: TextStyle(
                  fontSize: 12.0,
                  color: Color(0xFF64748B),
                ),
              ),

              const SizedBox(height: 32.0),
            ],
          ),
        ),
      ),
    );
  }
}

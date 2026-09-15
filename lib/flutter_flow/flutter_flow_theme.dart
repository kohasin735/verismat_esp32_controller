import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class FlutterFlowTheme {
  static FlutterFlowTheme of(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? DarkModeTheme()
        : LightModeTheme();
  }

  @Deprecated('Use primary instead')
  Color get primaryColor => primary;
  @Deprecated('Use secondary instead')
  Color get secondaryColor => secondary;
  @Deprecated('Use tertiary instead')
  Color get tertiaryColor => tertiary;

  late Color primary;
  late Color secondary;
  late Color tertiary;
  late Color alternate;
  late Color primaryText;
  late Color secondaryText;
  late Color primaryBackground;
  late Color secondaryBackground;
  late Color accent1;
  late Color accent2;
  late Color accent3;
  late Color accent4;
  late Color success;
  late Color warning;
  late Color error;
  late Color info;

  late Color cardBorder;
  late Color circuitAccent;
  late Color connectedGreen;
  late Color disconnectedRed;

  String get title1Family => typography.title1Family;
  TextStyle get title1 => typography.title1;
  String get title2Family => typography.title2Family;
  TextStyle get title2 => typography.title2;
  String get title3Family => typography.title3Family;
  TextStyle get title3 => typography.title3;
  String get subtitle1Family => typography.subtitle1Family;
  TextStyle get subtitle1 => typography.subtitle1;
  String get subtitle2Family => typography.subtitle2Family;
  TextStyle get subtitle2 => typography.subtitle2;
  String get bodyText1Family => typography.bodyText1Family;
  TextStyle get bodyText1 => typography.bodyText1;
  String get bodyText2Family => typography.bodyText2Family;
  TextStyle get bodyText2 => typography.bodyText2;

  Typography get typography => ThemeTypography(this);
}

class LightModeTheme extends FlutterFlowTheme {
  LightModeTheme() {
    primary = const Color(0xFF0284C7);
    secondary = const Color(0xFF0D9488);
    tertiary = const Color(0xFF6366F1);
    alternate = const Color(0xFFE2E8F0);
    primaryText = const Color(0xFF0F172A);
    secondaryText = const Color(0xFF475569);
    primaryBackground = const Color(0xFFF8FAFC);
    secondaryBackground = const Color(0xFFFFFFFF);
    accent1 = const Color(0xFF38BDF8);
    accent2 = const Color(0xFF2DD4BF);
    accent3 = const Color(0xFF818CF8);
    accent4 = const Color(0xFFCBD5E1);
    success = const Color(0xFF16A34A);
    warning = const Color(0xFFD97706);
    error = const Color(0xFFDC2626);
    info = const Color(0xFF2563EB);

    cardBorder = const Color(0xFFE2E8F0);
    circuitAccent = const Color(0xFF0EA5E9);
    connectedGreen = const Color(0xFF10B981);
    disconnectedRed = const Color(0xFFEF4444);
  }
}

class DarkModeTheme extends FlutterFlowTheme {
  DarkModeTheme() {
    primary = const Color(0xFF38BDF8);
    secondary = const Color(0xFF2DD4BF);
    tertiary = const Color(0xFF818CF8);
    alternate = const Color(0xFF334155);
    primaryText = const Color(0xFFF8FAFC);
    secondaryText = const Color(0xFF94A3B8);
    primaryBackground = const Color(0xFF0B1120);
    secondaryBackground = const Color(0xFF1E293B);
    accent1 = const Color(0xFF0284C7);
    accent2 = const Color(0xFF0F766E);
    accent3 = const Color(0xFF4338CA);
    accent4 = const Color(0xFF475569);
    success = const Color(0xFF22C55E);
    warning = const Color(0xFFF59E0B);
    error = const Color(0xFFF43F5E);
    info = const Color(0xFF38BDF8);

    cardBorder = const Color(0xFF334155);
    circuitAccent = const Color(0xFF38BDF8);
    connectedGreen = const Color(0xFF22C55E);
    disconnectedRed = const Color(0xFFF43F5E);
  }
}

abstract class Typography {
  String get title1Family;
  TextStyle get title1;
  String get title2Family;
  TextStyle get title2;
  String get title3Family;
  TextStyle get title3;
  String get subtitle1Family;
  TextStyle get subtitle1;
  String get subtitle2Family;
  TextStyle get subtitle2;
  String get bodyText1Family;
  TextStyle get bodyText1;
  String get bodyText2Family;
  TextStyle get bodyText2;
}

class ThemeTypography extends Typography {
  final FlutterFlowTheme theme;

  ThemeTypography(this.theme);

  @override
  String get title1Family => 'Inter';
  @override
  TextStyle get title1 => GoogleFonts.inter(
        color: theme.primaryText,
        fontWeight: FontWeight.w700,
        fontSize: 28.0,
        letterSpacing: -0.5,
      );

  @override
  String get title2Family => 'Inter';
  @override
  TextStyle get title2 => GoogleFonts.inter(
        color: theme.primaryText,
        fontWeight: FontWeight.w700,
        fontSize: 22.0,
        letterSpacing: -0.3,
      );

  @override
  String get title3Family => 'Inter';
  @override
  TextStyle get title3 => GoogleFonts.inter(
        color: theme.primaryText,
        fontWeight: FontWeight.w600,
        fontSize: 18.0,
      );

  @override
  String get subtitle1Family => 'Inter';
  @override
  TextStyle get subtitle1 => GoogleFonts.inter(
        color: theme.secondaryText,
        fontWeight: FontWeight.w500,
        fontSize: 15.0,
      );

  @override
  String get subtitle2Family => 'Inter';
  @override
  TextStyle get subtitle2 => GoogleFonts.inter(
        color: theme.secondaryText,
        fontWeight: FontWeight.w500,
        fontSize: 13.0,
      );

  @override
  String get bodyText1Family => 'Inter';
  @override
  TextStyle get bodyText1 => GoogleFonts.inter(
        color: theme.primaryText,
        fontWeight: FontWeight.normal,
        fontSize: 14.0,
      );

  @override
  String get bodyText2Family => 'Inter';
  @override
  TextStyle get bodyText2 => GoogleFonts.inter(
        color: theme.secondaryText,
        fontWeight: FontWeight.normal,
        fontSize: 12.0,
      );
}

extension TextStyleHelper on TextStyle {
  TextStyle override({
    String? fontFamily,
    Color? color,
    double? fontSize,
    FontWeight? fontWeight,
    double? letterSpacing,
    FontStyle? fontStyle,
    bool useGoogleFonts = true,
    TextDecoration? decoration,
    double? lineHeight,
  }) =>
      useGoogleFonts
          ? GoogleFonts.getFont(
              fontFamily ?? 'Inter',
              color: color ?? this.color,
              fontSize: fontSize ?? this.fontSize,
              letterSpacing: letterSpacing ?? this.letterSpacing,
              fontWeight: fontWeight ?? this.fontWeight,
              fontStyle: fontStyle ?? this.fontStyle,
              decoration: decoration,
              height: lineHeight,
            )
          : copyWith(
              fontFamily: fontFamily,
              color: color,
              fontSize: fontSize,
              letterSpacing: letterSpacing,
              fontWeight: fontWeight,
              fontStyle: fontStyle,
              decoration: decoration,
              height: lineHeight,
            );
}

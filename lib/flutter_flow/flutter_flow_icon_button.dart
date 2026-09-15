import 'package:flutter/material.dart';

class FlutterFlowIconButton extends StatelessWidget {
  const FlutterFlowIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.borderColor,
    this.borderWidth,
    this.borderRadius,
    this.buttonSize,
    this.fillColor,
    this.disabledColor,
    this.disabledIconColor,
  });

  final Widget icon;
  final double? borderRadius;
  final double? buttonSize;
  final Color? fillColor;
  final Color? disabledColor;
  final Color? borderColor;
  final double? borderWidth;
  final Color? disabledIconColor;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final size = buttonSize ?? 44.0;
    return Material(
      borderRadius: BorderRadius.circular(borderRadius ?? 12.0),
      color: Colors.transparent,
      clipBehavior: Clip.antiAlias,
      child: Ink(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: onPressed != null ? fillColor : (disabledColor ?? Colors.transparent),
          borderRadius: BorderRadius.circular(borderRadius ?? 12.0),
          border: Border.all(
            color: borderColor ?? Colors.transparent,
            width: borderWidth ?? 0.0,
          ),
        ),
        child: IconButton(
          icon: icon,
          onPressed: onPressed,
          splashRadius: size / 2,
          padding: EdgeInsets.zero,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class FFButtonOptions {
  const FFButtonOptions({
    this.textStyle,
    this.elevation,
    this.height,
    this.width,
    this.padding,
    this.color,
    this.disabledColor,
    this.disabledTextColor,
    this.splashColor,
    this.iconSize,
    this.iconColor,
    this.iconPadding,
    this.borderRadius,
    this.borderSide,
  });

  final TextStyle? textStyle;
  final double? elevation;
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final Color? disabledColor;
  final Color? disabledTextColor;
  final Color? splashColor;
  final double? iconSize;
  final Color? iconColor;
  final EdgeInsetsGeometry? iconPadding;
  final BorderRadius? borderRadius;
  final BorderSide? borderSide;
}

class FFButtonWidget extends StatelessWidget {
  const FFButtonWidget({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.iconData,
    required this.options,
    this.showLoadingIndicator = false,
    this.loading = false,
  });

  final String text;
  final Widget? icon;
  final IconData? iconData;
  final VoidCallback? onPressed;
  final FFButtonOptions options;
  final bool showLoadingIndicator;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    Widget textWidget = loading
        ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              strokeWidth: 2.2,
            ),
          )
        : Text(
            text,
            style: options.textStyle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          );

    final effectiveBorderRadius = options.borderRadius ?? BorderRadius.circular(12.0);
    final effectiveBorderSide = options.borderSide ?? BorderSide.none;

    final child = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null && !loading)
          Padding(
            padding: options.iconPadding ?? const EdgeInsets.only(right: 8.0),
            child: icon!,
          )
        else if (iconData != null && !loading)
          Padding(
            padding: options.iconPadding ?? const EdgeInsets.only(right: 8.0),
            child: Icon(
              iconData,
              size: options.iconSize ?? 20.0,
              color: options.iconColor ?? options.textStyle?.color,
            ),
          ),
        Flexible(child: textWidget),
      ],
    );

    return SizedBox(
      height: options.height ?? 48.0,
      width: options.width,
      child: ElevatedButton(
        onPressed: loading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: options.textStyle?.color,
          backgroundColor: options.color,
          disabledBackgroundColor: options.disabledColor ?? Colors.grey.shade700,
          disabledForegroundColor: options.disabledTextColor ?? Colors.grey.shade400,
          elevation: options.elevation ?? 2.0,
          padding: options.padding ?? const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          shape: RoundedRectangleBorder(
            borderRadius: effectiveBorderRadius,
            side: effectiveBorderSide,
          ),
        ),
        child: child,
      ),
    );
  }
}

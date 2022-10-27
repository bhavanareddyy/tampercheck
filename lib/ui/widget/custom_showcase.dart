 
import 'package:blink_comparison/ui/theme.dart';
import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';

class CustomShowcase extends StatelessWidget {
  final GlobalKey showcaseKey;
  final Widget child;
  final String? title;
  final String? description;
  final ShapeBorder? shapeBorder;
  final BorderRadius? radius;
  final TextStyle? titleTextStyle;
  final TextStyle? descTextStyle;
  final EdgeInsets? contentPadding;
  final Color overlayColor;
  final double overlayOpacity;
  final Color? showcaseBackgroundColor;
  final Color? textColor;
  final bool showArrow;
  final Duration animationDuration;
  final VoidCallback? onToolTipClick;
  final VoidCallback? onTargetClick;
  final bool? disposeOnTap;
  final bool disableAnimation;
  final EdgeInsets overlayPadding;
  final double? blurValue;

  const CustomShowcase({
    Key? key,
    required this.showcaseKey,
    required this.child,
    this.title,
    required this.description,
    this.shapeBorder,
    this.overlayColor = Colors.black45,
    this.overlayOpacity = 0.75,
    this.titleTextStyle,
    this.descTextStyle,
    this.showcaseBackgroundColor,
    this.textColor,
    this.showArrow = true,
    this.onTargetClick,
    this.disposeOnTap,
    this.animationDuration = const Duration(milliseconds: 2000),
    this.disableAnimation = false,
    this.contentPadding,
    this.onToolTipClick,
    this.overlayPadding = EdgeInsets.zero,
    this.blurValue,
    this.radius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.getThemeData();
    return Showcase(
      key: showcaseKey,
      child: child,
      title: title,
      description: description,
      shapeBorder: shapeBorder,
      overlayColor: overlayColor,
      overlayOpacity: overlayOpacity,
      titleTextStyle: titleTextStyle,
      descTextStyle: descTextStyle ??
          TextStyle(
            fontSize: 18,
            color: textColor ?? theme.colorScheme.onBackground,
          ),
      showcaseBackgroundColor:
          showcaseBackgroundColor ?? theme.colorScheme.background,
      textColor: textColor ?? theme.colorScheme.onBackground,
      showArrow: showArrow,
      onTargetClick: onTargetClick,
      disposeOnTap: disposeOnTap,
      animationDuration: animationDuration,
      contentPadding: contentPadding ?? const EdgeInsets.all(12.0),
      onToolTipClick: onToolTipClick ??
          () => ShowCaseWidget.of(context)?.completed(showcaseKey),
      overlayPadding: overlayPadding,
      blurValue: blurValue,
      radius: radius,
    );
  }
}

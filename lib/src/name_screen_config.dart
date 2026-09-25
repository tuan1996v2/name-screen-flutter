import 'package:flutter/material.dart';

/// Configuration for [NameScreen] badge appearance and behavior.
class NameScreenConfig {
  /// Whether the badge can be dragged freely across the screen. Defaults to `true`.
  final bool isDraggable;

  /// Background color of the badge.
  final Color backgroundColor;

  /// Text color for the screen name.
  final Color textColor;

  /// Indicator dot color when in normal state.
  final Color indicatorColor;

  /// Background color when 'Copied!' state is active.
  final Color copiedBackgroundColor;

  /// Text and indicator color when 'Copied!' state is active.
  final Color copiedTextColor;

  /// Font size of the route text. Defaults to `11.0`.
  final double fontSize;

  /// Maximum characters to show before truncating with '...'. Defaults to `28`.
  final int maxDisplayLength;

  /// Corner radius of the badge. Defaults to `12.0`.
  final double borderRadius;

  /// Initial top padding from status bar / safe area. Defaults to `6.0`.
  final double initialTop;

  /// Initial right padding from screen edge. Defaults to `8.0`.
  final double initialRight;

  /// Duration to show 'Copied!' message before reverting to route name.
  final Duration copiedFeedbackDuration;

  const NameScreenConfig({
    this.isDraggable = true,
    this.backgroundColor = const Color(0xC0000000), // Black ~75% opacity
    this.textColor = Colors.white,
    this.indicatorColor = Colors.greenAccent,
    this.copiedBackgroundColor = const Color(0xE62979FF), // BlueAccent
    this.copiedTextColor = Colors.white,
    this.fontSize = 11.0,
    this.maxDisplayLength = 28,
    this.borderRadius = 12.0,
    this.initialTop = 6.0,
    this.initialRight = 8.0,
    this.copiedFeedbackDuration = const Duration(milliseconds: 1500),
  });
}

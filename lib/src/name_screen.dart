import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'name_screen_config.dart';
import 'name_screen_observer.dart';

/// Floating overlay badge displaying the current screen name.
///
/// Tap the badge to copy the screen name to the clipboard.
/// Can be dragged around the screen to avoid obscuring critical UI elements.
class NameScreen extends StatefulWidget {
  /// The app or screen widget to wrap.
  final Widget child;

  /// Whether the badge is enabled. Defaults to `kDebugMode`.
  final bool? enabled;

  /// Optional configuration for styling and dragging behavior.
  final NameScreenConfig config;

  const NameScreen({
    super.key,
    required this.child,
    this.enabled,
    this.config = const NameScreenConfig(),
  });

  @override
  State<NameScreen> createState() => _NameScreenState();
}

// Backward compatibility alias
typedef DebugScreenNameOverlay = NameScreen;

class _NameScreenState extends State<NameScreen> {
  bool _isCopied = false;
  Timer? _copiedTimer;
  Offset? _position;

  bool get _isEnabled => widget.enabled ?? kDebugMode;

  @override
  void dispose() {
    _copiedTimer?.cancel();
    super.dispose();
  }

  void _copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    _copiedTimer?.cancel();
    if (!mounted) return;
    setState(() {
      _isCopied = true;
    });
    _copiedTimer = Timer(widget.config.copiedFeedbackDuration, () {
      if (mounted) {
        setState(() {
          _isCopied = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isEnabled) {
      return widget.child;
    }

    final mediaQuery = MediaQuery.of(context);
    final topPadding = mediaQuery.padding.top;
    final screenSize = mediaQuery.size;

    return Stack(
      children: [
        widget.child,
        ValueListenableBuilder<String?>(
          valueListenable: NameScreenObserver.currentRouteName,
          builder: (context, routeName, _) {
            final displayName = routeName ?? 'Loading...';
            final maxLength = widget.config.maxDisplayLength;
            final shortName = displayName.length > maxLength
                ? '...${displayName.substring(displayName.length - (maxLength - 3))}'
                : displayName;

            // Default initial position if user hasn't dragged
            final initialX = screenSize.width - 150 - widget.config.initialRight;
            final initialY = topPadding + widget.config.initialTop;
            final currentPos = _position ?? Offset(initialX.clamp(0.0, double.infinity), initialY);

            Widget badge = Material(
              color: Colors.transparent,
              child: GestureDetector(
                onTap: () => _copyToClipboard(displayName),
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _isCopied
                        ? widget.config.copiedBackgroundColor
                        : widget.config.backgroundColor,
                    borderRadius: BorderRadius.circular(widget.config.borderRadius),
                    border: Border.all(
                      color: _isCopied
                          ? widget.config.copiedTextColor.withOpacity(0.3)
                          : widget.config.textColor.withOpacity(0.15),
                      width: 0.8,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: _isCopied
                              ? widget.config.copiedTextColor
                              : widget.config.indicatorColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _isCopied ? 'Copied!' : shortName,
                        style: TextStyle(
                          color: _isCopied
                              ? widget.config.copiedTextColor
                              : widget.config.textColor,
                          fontSize: widget.config.fontSize,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'monospace',
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );

            if (widget.config.isDraggable) {
              return Positioned(
                left: currentPos.dx.clamp(0.0, (screenSize.width - 60).clamp(0.0, double.infinity)),
                top: currentPos.dy.clamp(topPadding, (screenSize.height - 40).clamp(0.0, double.infinity)),
                child: GestureDetector(
                  onPanUpdate: (details) {
                    setState(() {
                      final newX = (currentPos.dx + details.delta.dx)
                          .clamp(0.0, screenSize.width - 60);
                      final newY = (currentPos.dy + details.delta.dy)
                          .clamp(topPadding, screenSize.height - 40);
                      _position = Offset(newX, newY);
                    });
                  },
                  child: badge,
                ),
              );
            }

            return Positioned(
              top: topPadding + widget.config.initialTop,
              right: widget.config.initialRight,
              child: badge,
            );
          },
        ),
      ],
    );
  }
}

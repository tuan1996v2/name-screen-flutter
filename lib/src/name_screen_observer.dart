import 'package:flutter/material.dart';

/// NavigatorObserver that listens for route transitions and updates [currentRouteName].
class NameScreenObserver extends NavigatorObserver {
  /// Global listenable holding the current route name.
  static final ValueNotifier<String?> currentRouteName = ValueNotifier<String?>(null);

  /// Optional custom extractor to format or map route name from a [Route].
  final String? Function(Route<dynamic> route)? routeNameExtractor;

  /// If true, modal bottom sheets and dialogs without an explicit route name
  /// will be ignored so they don't overwrite the active screen name.
  /// Defaults to `true`.
  final bool ignoreUnnamedPopups;

  NameScreenObserver({
    this.routeNameExtractor,
    this.ignoreUnnamedPopups = true,
  });

  /// Manually update or override the current screen name if needed.
  static void updateCurrentRouteName(String? name) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      currentRouteName.value = name;
    });
  }

  void _updateRoute(Route<dynamic>? route) {
    if (route == null) return;

    if (ignoreUnnamedPopups && route is PopupRoute && route.settings.name == null) {
      return;
    }

    final name = routeNameExtractor?.call(route) ??
        route.settings.name ??
        route.runtimeType.toString();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      currentRouteName.value = name;
    });
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _updateRoute(route);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _updateRoute(previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _updateRoute(newRoute);
  }
}

/// Backwards compatibility alias
typedef NameScreenRouteObserver = NameScreenObserver;

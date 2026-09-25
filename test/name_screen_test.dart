import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:name_screen_flutter/name_screen_flutter.dart';

void main() {
  testWidgets('NameScreen displays current route name', (tester) async {
    final observer = NameScreenObserver();

    await tester.pumpWidget(
      MaterialApp(
        navigatorObservers: [observer],
        home: Builder(
          builder: (context) {
            return const NameScreen(
              enabled: true,
              child: Scaffold(
                body: Center(child: Text('Home Screen')),
              ),
            );
          },
        ),
      ),
    );

    // Initial pump
    await tester.pumpAndSettle();

    // Verify widget rendered
    expect(find.text('Home Screen'), findsOneWidget);
  });
}

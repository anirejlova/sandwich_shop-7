import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/views/settings_screen.dart';
import 'package:sandwich_shop/views/app_styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({'fontSize': 16.0});
    await AppStyles.loadFontSize();
  });

  group('SettingsScreen - Initial State', () {
    testWidgets('displays the initial UI elements correctly',
        (WidgetTester tester) async {
      const SettingsScreen settingsScreen = SettingsScreen();
      const MaterialApp app = MaterialApp(home: settingsScreen);
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('Font Size'), findsOneWidget);
      expect(find.byType(Slider), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
      expect(find.text('Back to Order'), findsOneWidget);
    });

    testWidgets('shows loading indicator initially',
        (WidgetTester tester) async {
      const SettingsScreen settingsScreen = SettingsScreen();
      const MaterialApp app = MaterialApp(home: settingsScreen);
      await tester.pumpWidget(app);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pumpAndSettle();

      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('displays default font size correctly',
        (WidgetTester tester) async {
      const SettingsScreen settingsScreen = SettingsScreen();
      const MaterialApp app = MaterialApp(home: settingsScreen);
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      expect(find.text('Current size: 16px'), findsOneWidget);
    });
  });

  group('SettingsScreen - Font Size Slider', () {
    testWidgets('slider has correct properties', (WidgetTester tester) async {
      const SettingsScreen settingsScreen = SettingsScreen();
      const MaterialApp app = MaterialApp(home: settingsScreen);
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final Finder sliderFinder = find.byType(Slider);
      final Slider slider = tester.widget<Slider>(sliderFinder);

      expect(slider.value, equals(16.0));
      expect(slider.min, equals(12.0));
      expect(slider.max, equals(24.0));
      expect(slider.divisions, equals(6));
    });

    testWidgets('updates font size display when slider is moved',
        (WidgetTester tester) async {
      const SettingsScreen settingsScreen = SettingsScreen();
      const MaterialApp app = MaterialApp(home: settingsScreen);
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      expect(find.text('Current size: 16px'), findsOneWidget);

      final Finder sliderFinder = find.byType(Slider);
      await tester.drag(sliderFinder, const Offset(100.0, 0.0));
      await tester.pumpAndSettle();

      expect(find.text('Current size: 16px'), findsNothing);
    });
  });

  group('SettingsScreen - Navigation', () {
    testWidgets('back button navigates to previous screen',
        (WidgetTester tester) async {
      const SettingsScreen settingsScreen = SettingsScreen();
      final MaterialApp app = MaterialApp(
        home: Builder(
          builder: (BuildContext context) {
            return Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => settingsScreen,
                      ),
                    );
                  },
                  child: const Text('Go to Settings'),
                ),
              ),
            );
          },
        ),
      );
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Go to Settings'));
      await tester.pumpAndSettle();

      expect(find.text('Settings'), findsOneWidget);

      await tester.tap(find.text('Back to Order'));
      await tester.pumpAndSettle();

      expect(find.text('Settings'), findsNothing);
      expect(find.text('Go to Settings'), findsOneWidget);
    });
  });

  group('SettingsScreen - Text Display', () {
    testWidgets('displays sample text for preview',
        (WidgetTester tester) async {
      const SettingsScreen settingsScreen = SettingsScreen();
      const MaterialApp app = MaterialApp(home: settingsScreen);
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      expect(find.text('This is sample text to preview the font size.'),
          findsOneWidget);
    });

    testWidgets('displays instructions text', (WidgetTester tester) async {
      const SettingsScreen settingsScreen = SettingsScreen();
      const MaterialApp app = MaterialApp(home: settingsScreen);
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      expect(
        find.text(
            'Font size changes are saved automatically. Restart the app to see changes in all screens.'),
        findsOneWidget,
      );
    });
  });
}

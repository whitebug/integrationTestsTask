import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test_task_flutter/colors.dart';
import 'package:test_task_flutter/keys.dart';
import 'package:test_task_flutter/random_number_generator.dart';
import 'package:test_task_flutter/yellow_screen.dart';

// Mock [Generator] class
class MockGenerator extends Mock implements RandomNumberGenerator {}

// Smart generator
class SmartRandomNumberGeneratorImpl implements RandomNumberGenerator {
  @override
  int generate() => Random().nextInt(50);
}

const String randomNumberText = 'Случайное число';

void main() {
  late MockGenerator generator;
  late SmartRandomNumberGeneratorImpl smartGen;
  setUpAll(() {
    generator = MockGenerator();
    smartGen = SmartRandomNumberGeneratorImpl();
  });
  group('Yellow widget test: ', () {
    testWidgets(
        "1. It's required to have yellow screen with yellow background"
        "and with a button called 'случайное число'"
        "and a back button", (tester) async {
      when(() => generator.generate()).thenReturn(4);
      await tester.pumpWidget(
        MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: YellowScreen(generator: generator),
        ),
      );
      // Check if there is a button 'случайное число'
      final Finder randomButton = find.widgetWithText(ElevatedButton, randomNumberText);
      expect(randomButton, findsOneWidget);

      // Check if [Container]'s color is yellow
      final Finder yellowContainer = find.byWidgetPredicate(
        (widget) => widget is Container && widget.color == yellowColor,
      );
      expect(yellowContainer, findsOneWidget);

      // Check if there is a back button
      final Finder backButton = find.widgetWithIcon(IconButton, Icons.arrow_back);
      expect(backButton, findsOneWidget);
    });
    testWidgets(
        "2. Tap on button called 'случайное число' and check if a random number from 0 to 49 appeared"
            "having text in blue color", (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: YellowScreen(generator: smartGen),
        ),
      );
      // Check if there is a button 'случайное число'
      final Finder randomButton = find.widgetWithText(ElevatedButton, randomNumberText);
      expect(randomButton, findsOneWidget);
      // Tap on [randomButton]
      await tester.tap(randomButton);
      await tester.pumpAndSettle();

      final Finder textContainer = find.byKey(const Key(Keys.randomNumberContainerKey));
      final Finder text = find.descendant(of: textContainer, matching: find.byWidgetPredicate((widget) {
        final bool checkIfTextIsNumber =
            widget is Text && widget.data != null && int.tryParse(widget.data!) != null;
        if (!checkIfTextIsNumber) {
          // It seems that text is not a number
          return false;
        }
        // Check if the number in required limits
        final int number = int.parse(widget.data!);
        final bool numberWithinLimits = number >= 0 && number <= 49;
        if (!numberWithinLimits) {
          return false;
        }
        final Color? numberColor = widget.style?.color;
        final bool requiredColor = numberColor != null && numberColor == blueColor;
        if (!requiredColor) {
          return false;
        }
        return true;
      }));
      expect(text, findsOneWidget);
    });
  });
}

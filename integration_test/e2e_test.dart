import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_task_flutter/colors.dart';
import 'package:test_task_flutter/keys.dart';
import 'package:test_task_flutter/main.dart' as app;

const String greenButtonText = 'зеленый';
const String greenScreenText = 'Зеленый экран';
const String yellowButtonText = 'желтый';
const String yellowScreenText = 'Желтый экран';
const String homeScreenText = 'Стартовый экран';
const String randomNumberText = 'Случайное число';

void main() {
  group('e2e tests: ', () {
    testWidgets(
      "1. Tap on 'зеленый' button to open a screen with white text 'зеленый экран' and green background"
      "finding the button by text",
      (WidgetTester tester) async {
        app.main();
        await tester.pumpAndSettle();
        // Verify if there is a 'зеленый' button on the screen
        expect(find.text(greenButtonText), findsOneWidget);

        // Find the button 'зеленый'
        final Finder greenButton = find.widgetWithText(ElevatedButton, greenButtonText);

        // Tap on the button
        await tester.tap(greenButton);
        // Wait for the screen
        await tester.pumpAndSettle();

        // Check if we are on the green screen
        final Finder greenContainer = find.byWidgetPredicate(
          (widget) => widget is Container && widget.color == greenColor,
        );
        final Finder greenScreen = find.descendant(
          of: greenContainer,
          matching: find.text(greenScreenText),
        );
        expect(greenScreen, findsOneWidget);
      },
    );
    testWidgets(
      '2. Tapping on back button should lead to home screen',
      (WidgetTester tester) async {
        app.main();
        await tester.pumpAndSettle();
        // Find the button 'зеленый'
        final Finder greenButton = find.widgetWithText(ElevatedButton, greenButtonText);
        // Tap on the button
        await tester.tap(greenButton);
        await tester.pumpAndSettle();

        // Check if we are on the green screen
        final Finder greenContainer = find.byWidgetPredicate(
          (widget) => widget is Container && widget.color == greenColor,
        );
        final Finder greenScreen = find.descendant(
          of: greenContainer,
          matching: find.text(greenScreenText),
        );
        expect(greenScreen, findsOneWidget);

        // Verify if there is a back button
        final Finder backButton = find.widgetWithIcon(IconButton, Icons.arrow_back);
        expect(backButton, findsOneWidget);
        // Tap on back button
        await tester.tap(backButton);
        await tester.pumpAndSettle();
        // Check if we are on home screen
        expect(find.text(homeScreenText), findsOneWidget);
      },
    );
    testWidgets(
      "3. Tap on 'желтый' button to open a screen with a button called 'случайное число'"
      "with no any text in screen center",
      (WidgetTester tester) async {
        app.main();
        await tester.pumpAndSettle();
        // Verify if there is a 'желтый' button on the screen
        expect(find.text(yellowButtonText), findsOneWidget);

        // Find the button 'желтый'
        final Finder yellowButton = find.widgetWithText(ElevatedButton, yellowButtonText);

        // Tap on the button
        await tester.tap(yellowButton);
        await tester.pumpAndSettle();

        // Check if we are on the green screen
        final Finder yellowAppBar = find.byWidgetPredicate(
          (widget) => widget is AppBar && widget.backgroundColor == yellowColor,
        );
        final Finder yellowText = find.descendant(
          of: yellowAppBar,
          matching: find.text(yellowScreenText),
        );
        expect(yellowText, findsOneWidget);

        // Check if there is a button called случайное число
        final Finder randomButton = find.widgetWithText(ElevatedButton, randomNumberText);
        expect(randomButton, findsOneWidget);
        // Check if there is no text in the center of the screen
        final Finder center = find.byKey(const Key(Keys.randomNumberContainerKey));
        expect(center, findsOneWidget);
        final Finder noText = find.descendant(of: center, matching: find.byType(Text));
        expect(noText, findsNothing);
      },
    );
    testWidgets(
      "4. Tap on 'случайное число' button to get a text with a number in range 0 to 99 in the screen center",
      (WidgetTester tester) async {
        app.main();
        await tester.pumpAndSettle();
        // Verify if there is a 'желтый' button on the screen
        expect(find.text(yellowButtonText), findsOneWidget);

        // Find the button 'желтый'
        final Finder yellowButton = find.widgetWithText(ElevatedButton, yellowButtonText);

        // Tap on the button
        await tester.tap(yellowButton);
        await tester.pumpAndSettle();

        // Check if we are on the green screen
        final Finder yellowAppBar = find.byWidgetPredicate(
          (widget) => widget is AppBar && widget.backgroundColor == yellowColor,
        );
        final Finder yellowText = find.descendant(
          of: yellowAppBar,
          matching: find.text(yellowScreenText),
        );
        expect(yellowText, findsOneWidget);

        // Check if there is a button called случайное число
        final Finder randomButton = find.widgetWithText(ElevatedButton, randomNumberText);
        expect(randomButton, findsOneWidget);
        // Check if there is no text in the center of the screen
        final Finder center = find.byKey(const Key(Keys.randomNumberContainerKey));
        expect(center, findsOneWidget);
        final Finder noText = find.descendant(of: center, matching: find.byType(Text));
        expect(noText, findsNothing);

        // Tap on 'случайное число' button
        await tester.tap(randomButton);
        await tester.pumpAndSettle();
        // Check if text with number is on screen
        final Finder centerText = find.descendant(of: center, matching: find.byType(Text));
        expect(centerText, findsOneWidget);

        final Finder textContainer = find.byKey(const Key(Keys.randomNumberContainerKey));
        final Finder text = find.descendant(of: textContainer, matching: find.byType(Text));

        final Text textWidget = text.evaluate().single.widget as Text;
        // Check if text is number
        final bool ifNumber = textWidget.data != null && int.tryParse(textWidget.data!) != null;
        expect(ifNumber, true);
        // Check if number within required limits
        final int number = int.parse(textWidget.data!);
        final bool ifWithinLimits = number >= 0 && number <= 99;
        expect(ifWithinLimits, true);
      },
    );
    testWidgets(
      '5. Tab on back button to get the home screen after yellow screen',
      (WidgetTester tester) async {
        app.main();
        await tester.pumpAndSettle();
        // Verify if there is a 'желтый' button on the screen
        expect(find.text(yellowButtonText), findsOneWidget);

        // Find the button 'желтый'
        final Finder yellowButton = find.widgetWithText(ElevatedButton, yellowButtonText);

        // Tap on the button
        await tester.tap(yellowButton);
        await tester.pumpAndSettle();

        // Check if we are on the green screen
        final Finder yellowAppBar = find.byWidgetPredicate(
          (widget) => widget is AppBar && widget.backgroundColor == yellowColor,
        );
        final Finder yellowText = find.descendant(
          of: yellowAppBar,
          matching: find.text(yellowScreenText),
        );
        expect(yellowText, findsOneWidget);
        // Verify if there is a back button
        final Finder backButton = find.widgetWithIcon(IconButton, Icons.arrow_back);
        expect(backButton, findsOneWidget);
        // Tap on back button
        await tester.tap(backButton);
        await tester.pumpAndSettle();
        // Check if we are on home screen
        expect(find.text(homeScreenText), findsOneWidget);
      },
    );
  });
}

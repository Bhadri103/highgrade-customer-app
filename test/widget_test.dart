import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highgrade_fitness_app/src/highgrade/highgrade_app.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('shows Highgrade authentication screen', (tester) async {
    await tester.pumpWidget(const HighgradeMobileApp());
    await tester.pumpAndSettle();

    expect(find.byType(Image), findsWidgets);
    expect(find.text('Train with Manoj'), findsOneWidget);
    expect(find.text('Login to Highgrade'), findsOneWidget);
    expect(find.text('OTP Login'), findsOneWidget);
    expect(find.text('Biometric Login'), findsNothing);
  });

  testWidgets('dummy login opens the dashboard', (tester) async {
    await tester.pumpWidget(const HighgradeMobileApp());
    await tester.pumpAndSettle();

    final loginButton = find.text('Login to Highgrade');
    await tester.ensureVisible(loginButton);
    await tester.pumpAndSettle();
    await tester.tap(loginButton);
    await tester.pumpAndSettle();

    expect(find.text('Dashboard'), findsOneWidget);
    expect(find.textContaining('Welcome'), findsOneWidget);
    expect(find.text('Daily Summary'), findsOneWidget);
    expect(find.text('Upcoming Workout'), findsOneWidget);
  });
}

import 'package:EazySupplies/core/routes/app_routes.dart';
import 'package:EazySupplies/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App builds with the onboarding route', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MyApp(initialRoute: AppRoutes.onboarding),
    );

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}

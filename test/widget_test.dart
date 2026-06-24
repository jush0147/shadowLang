import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_lang/app.dart';

void main() {
  testWidgets('shows seeded library content', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: ShadowLangApp()));

    expect(find.text('ShadowLang'), findsOneWidget);
    expect(find.text('Test English Clip'), findsOneWidget);
    expect(find.byIcon(Icons.video_library), findsOneWidget);
  });
}

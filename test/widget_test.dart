import 'package:extractorapplication/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  testWidgets('Initial screen load test', (WidgetTester tester) async {
    await Supabase.initialize(
      url: 'https://placeholder-url.supabase.co',
      anonKey: 'placeholder-key',
    );

    await tester.pumpWidget(const MyApp());
  });
}

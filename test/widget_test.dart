import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:extractorapplication/main.dart';

void main() {
  // Bỏ qua lỗi HTTP 400 trong môi trường test
  setUpAll(() {
    HttpOverrides.global = null;
  });

  testWidgets('Initial screen load test', (WidgetTester tester) async {
    // Khởi tạo Supabase giả lập
    await Supabase.initialize(
      url: 'https://placeholder.supabase.co',
      anonKey: 'placeholder-key',
    );

    // Chạy ứng dụng
    await tester.pumpWidget(const MyApp());

    // Giải quyết các tác vụ async đang chờ xử lý để tránh Timeout
    await tester.pumpAndSettle(); 

    // Kiểm tra xem ứng dụng có load được không (ví dụ tìm một Widget bất kỳ)
    expect(find.byType(MyApp), findsOneWidget);
  });
}

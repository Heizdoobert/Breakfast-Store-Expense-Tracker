import 'package:extractorapplication/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  testWidgets('Initial screen load test', (WidgetTester tester) async {
    // Khởi tạo Supabase giả lập để tránh lỗi "You must initialize the supabase instance"
    await Supabase.initialize(
      url: 'https://placeholder-url.supabase.co',
      anonKey: 'placeholder-key',
    );

    // Build ứng dụng của bạn
    await tester.pumpWidget(const MyApp());

    // Vì ứng dụng của bạn bắt đầu bằng màn hình Login hoặc Splash
    // chứ không phải Counter, bạn nên tìm một text có trong màn hình đầu tiên.
    // Ví dụ: Tìm chữ "Đăng nhập" thay vì tìm số "0"
    // expect(find.text('Đăng nhập'), findsOneWidget);
  });
}

import 'package:intl/intl.dart';

class DateFormatter {
  /// Định dạng ngày theo pattern (mặc định: dd/MM/yyyy)
  static String formatDate(DateTime date, {String pattern = 'dd/MM/yyyy'})  {
    return DateFormat(pattern).format(date);
  }

  /// Định dạng giờ theo pattern (mặc định: HH:mm)
  String formatTime(DateTime date, {String pattern = 'HH:mm'}) {
    return DateFormat(pattern).format(date);
  }

  /// Định dạng ngày + giờ (mặc định: dd/MM/yyyy HH:mm)
  String formatDateTime(DateTime date, {String pattern = 'dd/MM/yyyy HH:mm'}) {
    return DateFormat(pattern).format(date);
  }

  /// Chuyển chuỗi thành DateTime theo pattern
  DateTime parseDate(String dateStr, {String pattern = 'dd/MM/yyyy'}) {
    return DateFormat(pattern).parse(dateStr);
  }

  /// Hiển thị thời gian tương đối (ví dụ: "2 giờ trước")
  String timeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inSeconds < 60) return '${diff.inSeconds}s trước';
    if (diff.inMinutes < 60) return '${diff.inMinutes} phút trước';
    if (diff.inHours < 24) return '${diff.inHours} giờ trước';
    if (diff.inDays < 7) return '${diff.inDays} ngày trước';
    if (diff.inDays < 30) return '${(diff.inDays / 7).floor()} tuần trước';
    if (diff.inDays < 365) return '${(diff.inDays / 30).floor()} tháng trước';
    return '${(diff.inDays / 365).floor()} năm trước';
  }
}
// G:/Project/Breakfast-Store-Expense-Tracker/lib/views/owner/dashboard/widgets/recent_notes_view.dart

import 'package:flutter/material.dart';

import '../../../../../Model/note_model.dart';

// Tên widget `RecentNotesView` đã rất phù hợp.
class RecentNotesView extends StatelessWidget {
  final List<Note> notes;

  const RecentNotesView({super.key, required this.notes});

  @override
  Widget build(BuildContext context) {
    // Sử dụng ListView.builder để tối ưu hiệu suất nếu danh sách ghi chú rất dài.
    // Dùng Column nếu bạn chắc chắn danh sách luôn ngắn.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '📌 Ghi chú gần đây:',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),

        // Xử lý trường hợp không có ghi chú nào.
        if (notes.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Center(
              child: Text(
                'Không có ghi chú nào để hiển thị.',
                style:
                    TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
              ),
            ),
          )
        // Nếu có ghi chú, hiển thị chúng.
        else
          // Bọc trong ListView để tránh lỗi tràn màn hình nếu có nhiều ghi chú.
          // `shrinkWrap: true` và `physics` để nó hoạt động bên trong một `SingleChildScrollView` khác.
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];

              // === SỬA ĐỔI CHÍNH NẰM Ở ĐÂY: Dùng Card và ListTile ===
              // Thay vì dùng Text, chúng ta dùng Card để tạo ra một "bảng nhỏ" cho mỗi ghi chú.
              return Card(
                margin: const EdgeInsets.only(bottom: 10.0),
                elevation: 2.0, // Thêm một chút bóng đổ cho đẹp.
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: ListTile(
                  // Biểu tượng ở đầu dòng.
                  leading: Icon(
                    Icons.note_alt_outlined,
                    color: Theme.of(context).primaryColor,
                  ),

                  // Tiêu đề của ghi chú.
                  // Dùng `note.title ?? 'Không có tiêu đề'` để xử lý trường hợp title là null.
                  title: Text(
                    note.title ?? 'Không có tiêu đề',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  // Nội dung của ghi chú.
                  subtitle: Text(
                    note.content,
                    maxLines: 2, // Giới hạn 2 dòng để không bị quá dài.
                    overflow: TextOverflow.ellipsis,
                  ),

                  // Bạn có thể thêm hành động khi nhấn vào, ví dụ:
                  onTap: () {
                    // Hiện tại chỉ in ra console, sau này bạn có thể điều hướng đến trang chi tiết ghi chú.
                    debugPrint('Tapped on note with id: ${note.id}');
                  },
                ),
              );
            },
          ),
      ],
    );
  }
}

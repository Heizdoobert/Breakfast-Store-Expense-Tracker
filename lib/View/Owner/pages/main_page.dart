import 'package:extractorapplication/Controller/ExpenseController.dart';
import 'package:extractorapplication/Controller/NoteController.dart';
import 'package:extractorapplication/Database/db_help.dart';
import 'package:extractorapplication/View/Note/AddNoteDialog.dart';
import 'package:extractorapplication/View/Note/add_expanse_dialog.dart';
import 'package:flutter/material.dart';
import 'package:extractorapplication/View/Components/header.dart';

import '../../../Model/Note.dart';

class MainPage extends StatelessWidget {
  MainPage({super.key});
  final NoteController noteController = NoteController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header (giữ nguyên)
              Header(),
              const SizedBox(height: 24),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.orange.shade200, width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: DailyExpenseCard(
                    controller: ExpenseController(DBHelper()),
                    groupId: 1,
                    userId: 1,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              /// Ghi chú
              FutureBuilder<List<Note>>(
                future: noteController.getTodayNotes(), // dữ liệu lấy từ controller
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final notes = snapshot.data ?? [];

                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.blue.shade200, width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Tiêu đề
                        const Text(
                          "📝 Ghi chú hôm nay",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.deepPurple,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Danh sách ghi chú
                        if (notes.isEmpty)
                          const Text(
                            "Chưa có ghi chú nào hôm nay.",
                            style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                          )
                        else
                          ...notes.map(
                                (note) => Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Text("- ${note.title}", style: const TextStyle(fontSize: 14)),
                            ),
                          ),

                        const SizedBox(height: 16),

                        // Hàng nút chức năng
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  AddNoteDialog.show(
                                    context,
                                    onSave: (noteData) async {
                                      await noteController.addNote(
                                        noteData['title'],
                                        noteData['content'],
                                        noteData['category'] ?? '',
                                        noteData['priority'] ?? '',
                                      );
                                      // Không setState ở đây nữa
                                      // Việc load lại sẽ do widget cha xử lý
                                    },
                                  );
                                },
                                icon: const Icon(Icons.add),
                                label: const Text("Thêm ghi chú"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.deepPurple,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            OutlinedButton.icon(
                              onPressed: () {
                                // Không setState ở đây nữa
                                // Nếu muốn load lại, gọi hàm reload từ widget cha
                              },
                              icon: const Icon(Icons.refresh),
                              label: const Text("Làm mới"),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                side: BorderSide(color: Colors.blue.shade300),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),

              /// Thống kê chi tiết
              const Padding(
                padding: EdgeInsets.only(left: 4.0),
                child: Text(
                  "📈 Thống kê chi tiết",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.deepPurple,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                height: 180,
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.purple.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(color: Colors.purple.shade100, width: 1.5),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.bar_chart,
                      size: 40,
                      color: Colors.purple.shade300,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "Biểu đồ doanh thu / chi phí sẽ hiển thị ở đây",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.purple,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Doanh thu: 0đ | Chi phí: 0đ", // Placeholder for stats
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.purple.shade700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              /// Lịch
              const Padding(
                padding: EdgeInsets.only(left: 4.0),
                child: Text(
                  "📅 Lịch làm việc",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.deepPurple,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                height: 250,
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.green.shade200, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 40,
                      color: Colors.green.shade500,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "Lịch (calendar) sẽ được tích hợp ở đây",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Hôm nay: 0 sự kiện", // Placeholder for calendar events
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.green.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// lib/views/owner/ownerHome/home_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../Controller/financialController.dart';
import '../../../Controller/noteController.dart'; // Import NoteController
import '../../../Model/Note.dart'; // Import Note model
import 'widget/home_page_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key}); // Thêm key nếu cần

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = FinanceController();
  final NoteController _noteController = NoteController(); // Khởi tạo NoteController

  List<Note> _notes = []; // Danh sách ghi chú
  bool _isLoadingNotes = true; // Trạng thái tải ghi chú

  @override
  void initState() {
    super.initState();
    _loadNotes(); // Tải ghi chú khi khởi tạo
  }

  // Hàm tải ghi chú
  Future<void> _loadNotes() async {
    setState(() {
      _isLoadingNotes = true;
    });
    try {
      final notes = await _noteController.getAllNotes();
      setState(() {
        _notes = notes;
        _isLoadingNotes = false;
      });
    } catch (e) {
      print('Error loading notes: $e');
      setState(() {
        _isLoadingNotes = false;
      });
    }
  }

  Future<int?> getUserIdFromSession() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int?>(
      future: getUserIdFromSession(),
      builder: (context, userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (userSnapshot.hasError) {
          return Center(child: Text('Lỗi khi lấy userId: ${userSnapshot.error}'));
        }
        if (!userSnapshot.hasData || userSnapshot.data == null) {
          return const Center(child: Text('Không tìm thấy userId trong session'));
        }

        final userId = userSnapshot.data!;

        return FutureBuilder(
          future: controller.fetchFinanceData(userId),
          builder: (context, financeSnapshot) {
            if (financeSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (financeSnapshot.hasError) {
              return Center(child: Text('Lỗi khi tải dữ liệu tài chính: ${financeSnapshot.error}'));
            }
            if (!financeSnapshot.hasData || financeSnapshot.data == null) {
              return const Center(child: Text('Không có dữ liệu tài chính'));
            }

            final model = financeSnapshot.data!;
            final spots = List.generate(
              model.trendValues.length,
                  (i) => FlSpot(i.toDouble(), model.trendValues[i] / 1000),
            );
            final daysLeft = DateTime(DateTime.now().year, DateTime.now().month + 1, 0)
                .difference(DateTime.now())
                .inDays;

            return Scaffold(
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Căn lề trái cho các mục
                  children: [
                    FinancialOverviewCard(
                      availableBalance: model.availableBalance,
                      daysLeft: daysLeft,
                      totalBudget: model.totalBudget,
                      spentAmount: model.spentAmount,
                      netWorthTrend: spots,
                      xLabels: model.trendLabels,
                      periodLabel: 'Month',
                      netWorthChangePercent: model.netWorthChangePercent,
                    ),
                    const SizedBox(height: 32), // Khoảng cách
                    const Text('Các ghi chú gần đây:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    // Hiển thị danh sách ghi chú
                    if (_isLoadingNotes)
                      const Center(child: CircularProgressIndicator())
                    else if (_notes.isEmpty)
                      const Center(child: Text('Chưa có ghi chú nào.'))
                    else
                      ListView.builder(
                        shrinkWrap: true, // Quan trọng
                        physics: const NeverScrollableScrollPhysics(), // Để SingleChildScrollView hoạt động
                        itemCount: _notes.length,
                        itemBuilder: (context, index) {
                          final note = _notes[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0), // Thêm margin ngang cho card
                            elevation: 4, // Thêm đổ bóng cho card
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0), // Bo góc card
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0), // Padding bên trong card
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          note.title,
                                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                      // Icon xóa
                                      IconButton(
                                        icon: const Icon(Icons.delete_outline, color: Colors.red, size: 22),
                                        tooltip: 'Xóa ghi chú',
                                        onPressed: () async {
                                          final confirm = await showDialog<bool>(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: const Text('Xác nhận xóa'),
                                              content: const Text('Bạn có chắc muốn xóa ghi chú này?'),
                                              actions: [
                                                TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Hủy')),
                                                TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Xóa')),
                                              ],
                                            ),
                                          );

                                          if (confirm == true) {
                                            await _noteController.deleteNote(note.id!);
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(content: Text('Đã xóa ghi chú')),
                                            );

                                            Obx(() => ListView.builder(
                                              itemCount: _noteController.notes.length,
                                              itemBuilder: (context, index) {
                                                final note = _noteController.notes[index];
                                              }
                                            ));
                                          }
                                        },
                                      ),

                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  // Nội dung ghi chú
                                  Text(
                                    note.content ?? 'Không có nội dung',
                                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                                    maxLines: 3, // Giới hạn số dòng hiển thị nội dung
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 12),
                                  // Thông tin thêm (Danh mục, Ưu tiên)
                                  Wrap(
                                    spacing: 8.0, // Khoảng cách giữa các tag
                                    runSpacing: 4.0,
                                    children: [
                                      if (note.category != null && note.category!.isNotEmpty)
                                        Chip(label: Text(note.category!), backgroundColor: Colors.blue.shade100, padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2)),
                                      if (note.priority.isNotEmpty)
                                        Chip(label: Text(note.priority!), backgroundColor: _getPriorityColor(note.priority), padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
              floatingActionButton: const AddOptionsButton(),
            );
          },
        );
      },
    );
  }

  // Hàm để lấy màu cho chip độ ưu tiên
  Color _getPriorityColor(String? priority) {
    switch (priority) {
      case 'Cao':
        return Colors.red.shade300;
      case 'Trung bình':
        return Colors.orange.shade300;
      case 'Thấp':
        return Colors.green.shade300;
      default:
        return Colors.grey.shade300;
    }
  }
}

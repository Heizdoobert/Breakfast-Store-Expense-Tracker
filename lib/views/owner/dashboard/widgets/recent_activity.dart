// G:/Project/Breakfast-Store-Expense-Tracker/lib/views/owner/dashboard/widgets/recent_notes_view.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../Controller/owner/note_management_controller.dart';
import '../../../../../Model/note_model.dart';
import '../../edit_note.dart';

class RecentNotesView extends StatelessWidget {
  final List<Note> notes;

  const RecentNotesView({super.key, required this.notes});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<NoteManagementController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '📌 Ghi chú gần đây:',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
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
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 10.0),
                elevation: 2.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: ListTile(
                  leading: Icon(
                    Icons.note_alt_outlined,
                    color: Theme.of(context).primaryColor,
                  ),
                  title: Text(
                    note.title ?? 'Không có tiêu đề',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    note.content,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon:
                            const Icon(Icons.edit_outlined, color: Colors.blue),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditNoteView(note: note),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon:
                            const Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext dialogContext) {
                              return AlertDialog(
                                title: const Text('Xác nhận xóa'),
                                content: Text(
                                    'Bạn có chắc chắn muốn xóa ghi chú "${note.title ?? 'này'}" không?'),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('Hủy'),
                                    onPressed: () {
                                      Navigator.of(dialogContext).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: const Text('Xóa',
                                        style: TextStyle(color: Colors.red)),
                                    onPressed: () {
                                      Navigator.of(dialogContext).pop();
                                      controller.deleteNote(note.id);
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}

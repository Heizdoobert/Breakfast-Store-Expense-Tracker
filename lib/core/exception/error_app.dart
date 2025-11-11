import 'package:flutter/material.dart';

import '../services/file_service.dart';

/// xu ly ngoai le khi khoi tao app
class ErrorApp extends StatelessWidget {
  final Object error;

  const ErrorApp({super.key, required this.error});

  Future<String?> _loadFileContent() async {
    return await FileService().readFile('path/to/file.txt');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: FutureBuilder<String?>(
          future: _loadFileContent(),
          builder: (context, snapshot) {
            final fileContent = snapshot.data ?? 'Không đọc được nội dung file';

            return Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(
                        'Lỗi khởi tạo Supabase:\n${error.toString()}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16, color: Colors.red),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Nội dung file lỗi:\n$fileContent',
                        textAlign: TextAlign.center,
                        style:
                            const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

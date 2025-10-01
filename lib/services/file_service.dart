import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FileService {
  Future<String?> readFile(String filename) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$filename');

    await file.parent.create(recursive: true);

    if (!await file.exists()) {
      await file.writeAsString('');
    }

    return await file.readAsString();
  }

  Future<void> writeFile(String filename, String content) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$filename');

    await file.parent.create(recursive: true);
    await file.writeAsString(content);
  }
}
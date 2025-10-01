import 'package:extractorapplication/supabase/supabase_client.dart';

class DatabaseService {
  final supabase = SupabaseManager.client;

  ///truy van toan bo bang
  Future<List<Map<String, dynamic>>> getAll(String table) async {
    try {
      return await supabase.from(table).select();
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }

  ///truy van mot dong theo id
  Future<Map<String, dynamic>?> getById(String table, dynamic id) async {
    return await supabase.from(table).select().eq('id', id).maybeSingle();
  }

  ///truy van theo dieu kien
  Future<List<Map<String, dynamic>>> queryBuilder({
    required String table,
    required String column,
    required dynamic value,
    List<String>? fields,
    String? orderBy,
    bool ascending = true,
    int? limit,
  }) {
    final fieldsString = fields != null ? fields.join(',') : '*';

    var query = supabase
        .from(table)
        .select(fieldsString)
        .eq(column, value)
        .order(orderBy ?? 'id', ascending: ascending)
        .limit(limit ?? 100);

     return query;
  }

  ///them du lieu
  Future<void> insert(String table, Map<String, dynamic> data) async {
    await supabase.from(table).insert(data);
  }

  ///cap nhat du lieu theo id
  Future<void> update(
    String table,
    dynamic id,
    Map<String, dynamic> data,
  ) async {
    await supabase.from(table).update(data).eq('id', id);
  }

  ///xoa du lieu theo id
  Future<void> delete(String table, dynamic id) async {
    await supabase.from(table).delete().eq('id', id);
  }
}

import '../exception/login_exception.dart';
import '../supabase/supabase_client.dart';

class DatabaseService {
  final supabase = SupabaseManager.client;
  bool isLoading = false;

  ///truy van toan bo bang
  Future<List<Map<String, dynamic>>> getAll(String table) async {
    try {
      isLoading = true;
      return await supabase.from(table).select();
    } catch (e) {
      isLoading = false;
      throw ServerException('Error fetching data: $e');
    }
  }

  ///truy van mot dong theo id
  Future<Map<String, dynamic>?> getById(String table, dynamic id) async {
    try {
      isLoading = true;
      return await supabase.from(table).select().eq('id', id).maybeSingle();
    } catch (e) {
      isLoading = false;
      throw ServerException('Error fetching data: $e');
    }
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
    try {
      isLoading = true;
      final fieldsString = fields != null ? fields.join(',') : '*';

      var query = supabase
          .from(table)
          .select(fieldsString)
          .eq(column, value)
          .order(orderBy ?? 'id', ascending: ascending)
          .limit(limit ?? 100);

      return query;
    } catch (e) {
      isLoading = false;
      throw ServerException('Error fetching data: $e');
    }
  }

  ///them du lieu
  Future<void> insert(String table, Map<String, dynamic> data) async {
    try {
      isLoading = true;
      await supabase.from(table).insert(data);
    } catch (e) {
      isLoading = false;
      throw ServerException('Error inserting data: $e');
    }
  }

  ///cap nhat du lieu theo id
  Future<void> update(
    String table,
    dynamic id,
    Map<String, dynamic> data,
  ) async {
    try {
      isLoading = true;
      await supabase.from(table).update(data).eq('id', id);
    } catch (e) {
      isLoading = false;
      throw ServerException('Error updating data: $e');
    }
  }

  ///xoa du lieu theo id
  Future<void> delete(String table, dynamic id) async {
    try {
      isLoading = true;
      await supabase.from(table).delete().eq('id', id);
    } catch (e) {
      isLoading = false;
      throw ServerException('Error deleting data: $e');
    }
  }
}

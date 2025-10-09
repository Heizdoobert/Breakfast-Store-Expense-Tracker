import '../exception/login_exception.dart';
import '../supabase/supabase_client.dart';

///tang thuc thi cau lenh truy van
///tai day tra ve du lieu hoac loi
///tiep nhan request tu service de trao doi du lieu len tren db
class DatabaseService {
  final supabase = SupabaseManager.client;

  ///truy van toan bo bang
  Future<List<Map<String, dynamic>>> getAll(String table) async {
    try {
      return await supabase.from(table).select();
    } catch (e) {
      throw ServerException('Error fetching data from $table: $e');
    }
  }

  ///truy van mot dong theo id
  Future<Map<String, dynamic>?> getById(String table, dynamic id) async {
    try {
      return await supabase.from(table).select().eq('id', id).maybeSingle();
    } catch (e) {
      throw ServerException('Error fetching data from $table by id $id: $e');
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
  }) async {
    try {
      final fieldsString = fields != null ? fields.join(',') : '*';

      var query = supabase
          .from(table)
          .select(fieldsString)
          .eq(column, value)
          .order(orderBy ?? 'id', ascending: ascending)
          .limit(limit ?? 100);

      return await query;
    } catch (e) {
      throw ServerException('Error fetching data $table: $e');
    }
  }

  ///them du lieu
  Future<Map<String, dynamic>> insert(String table, Map<String, dynamic> data) async {
    try {
      return await supabase.from(table).insert(data).select().single();
    } catch (e) {
      throw ServerException('Error inserting data into $table: $e');
    }
  }

  ///cap nhat du lieu theo id
  Future<Map<String, dynamic>> update(
    String table,
    dynamic id,
    Map<String, dynamic> data,
  ) async {
    try {
      return await supabase.from(table).update(data).eq('id', id).select().single();
    } catch (e) {
      throw ServerException('Error updating $table with id $id: $e');
    }
  }

  ///xoa du lieu theo id
  Future<void> delete(String table, dynamic id) async {
    try {
      await supabase.from(table).delete().eq('id', id);
    } catch (e) {
      throw ServerException('Error deleting $table with id $id data: $e');
    }
  }

  //xoa du lieu tai diem goi
  Future<void> deleteWhere(String table,Map<String, dynamic> conditions) async {
    try {
      var query = supabase.from(table).delete();
      conditions.forEach((key, value) {
        query = query.eq(key, value);
      });
      await query;
    } catch (e) {
      throw ServerException('Error deleting data from $table with conditions: $e');
    }
  }

  //tinh so lieu tren db
  Future<double> getAggregate({
    required String table, required String column
}) async {
    try {
      final response = await supabase.from(table).select(column);

      if(response.isEmpty){
        return 0.0;
      }

      double total = 0.0;
      for(var row in response){
        if(row[column] != null )
          {
            total += (row[column] as num).toDouble();
          }
      }
      return total;
    } catch (e) {
      throw ServerException('Error performing aggregation on $table: $e');
    }
  }
}

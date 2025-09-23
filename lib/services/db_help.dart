import 'package:extractorapplication/Controller/AuthController.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../Model/Note.dart';
import '../Model/User.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  static Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  get rows => null;

  Future<Database> _initDb() async {
    String path = join(await getDatabasesPath(), 'warehouse.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    var batch = db.batch();

    // Bảng users
    batch.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL UNIQUE,
        email TEXT,
        password_hash TEXT NOT NULL,
        full_name TEXT,
        role TEXT NOT NULL,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        updated_at TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    // Bảng groups
    batch.execute('''
      CREATE TABLE groups(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    // Bảng group_members
    batch.execute('''
      CREATE TABLE group_members(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        group_id INTEGER,
        user_id INTEGER,
        FOREIGN KEY (group_id) REFERENCES groups(id),
        FOREIGN KEY (user_id) REFERENCES users(id)
      )
    ''');

    // Bảng expenses
    batch.execute('''
      CREATE TABLE expenses(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        group_id INTEGER,
        user_id INTEGER,
        amount REAL NOT NULL,
        description TEXT,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (group_id) REFERENCES groups(id),
        FOREIGN KEY (user_id) REFERENCES users(id)
      )
    ''');

    // Bảng budgets
    batch.execute('''
      CREATE TABLE budgets(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        group_id INTEGER,
        amount REAL NOT NULL,
        month INTEGER,
        year INTEGER,
        FOREIGN KEY (group_id) REFERENCES groups(id)
      )
    ''');

    // Bảng debts
    batch.execute('''
      CREATE TABLE debts(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        from_user_id INTEGER,
        to_user_id INTEGER,
        amount REAL NOT NULL,
        is_settled INTEGER DEFAULT 0,
        FOREIGN KEY (from_user_id) REFERENCES users(id),
        FOREIGN KEY (to_user_id) REFERENCES users(id)
      )
    ''');

    // Bảng saving_plans
    batch.execute('''
      CREATE TABLE saving_plans(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        group_id INTEGER,
        target_amount REAL NOT NULL,
        saved_amount REAL DEFAULT 0,
        deadline TEXT,
        FOREIGN KEY (group_id) REFERENCES groups(id)
      )
    ''');

    // Bảng notifications
    batch.execute('''
      CREATE TABLE notifications(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER,
        message TEXT NOT NULL,
        is_read INTEGER DEFAULT 0,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (user_id) REFERENCES users(id)
      )
    ''');

    batch.execute('''
    CREATE TABLE notes(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id INTEGER,
      title TEXT NOT NULL,
      content TEXT,
      category TEXT,
      priority TEXT,
      is_completed INTEGER DEFAULT 0,
      created_at TEXT DEFAULT CURRENT_TIMESTAMP,
      updated_at TEXT DEFAULT CURRENT_TIMESTAMP,
      FOREIGN KEY (user_id) REFERENCES users(id)
     )
    ''');

    // --- Thêm 4 user mặc định ---
    batch.insert('users', {
      'username': 'super_owner',
      'email': 'owner@example.com',
      'password_hash': '123456',
      'full_name': 'Owner Account',
      'role': 'owner',
    });

    batch.insert('users', {
      'username': 'super_admin',
      'email': 'admin@example.com',
      'password_hash': '123456',
      'full_name': 'Admin Account',
      'role': 'admin',
    });

    batch.insert('users', {
      'username': 'manager',
      'email': 'manager@example.com',
      'password_hash': '123456',
      'full_name': 'Manager Account',
      'role': 'manager',
    });

    batch.insert('users', {
      'username': 'staff',
      'email': 'staff@example.com',
      'password_hash': '123456',
      'full_name': 'Staff Account',
      'role': 'staff',
    });

    await batch.commit();
  }

  // ================= CRUD USERS =================
  Future<int> insertUser(User user) async {
    final dbClient = await db;
    return await dbClient.insert('users', user.toMap());
  }

  Future<User?> getUserByUsername(String username) async {
    final dbClient = await db;
    final res = await dbClient.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );
    return res.isNotEmpty ? User.fromMap(res.first) : null;
  }

  Future<User?> updateUser(User user) async {
    final dbClient = await db;
    final res = await dbClient.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.user_id],
    );
    return res > 0 ? user : null;
  }

  Future<User> checkUser(User user) async {
    final dbClient = await db;
    List<Map<String, dynamic>> result = await dbClient.query("User", where: "username = ? AND password = ?", whereArgs: [user.username, user.password_hash]);

    print(result);

    for(var row in result){
      return new Future<User>.value(User.fromMap(row));
    }

    return new Future<User>.error("User not found");
  }

  Future<List<User>> getAllUsers() async {
    final dbClient = await db;
    final res = await dbClient.query('users');
    return res.map((map) => User.fromMap(map)).toList();
  }

  Future<int> deleteUser(int id) async {
    final dbClient = await db;
    return await dbClient.delete('users', where: 'id = ?', whereArgs: [id]);
  }

  // ================= CRUD EXPENSE =================
  Future<int> insertExpense(Map<String, dynamic> expense) async {
    final dbClient = await db;
    return await dbClient.insert('expenses', expense);
  }

  Future<List<Map<String, dynamic>>> getExpenses() async {
    final dbClient = await db;
    return await dbClient.query('expenses');
  }

  // ================= CRUD GROUP =================
  Future<int> insertGroup(Map<String, dynamic> group) async {
    final dbClient = await db;
    return await dbClient.insert('groups', group);
  }

  Future<List<Map<String, dynamic>>> getGroups() async {
    final dbClient = await db;
    return await dbClient.query('groups');
  }

  // ================= CRUD SAVING PLAN =================
  Future<int> insertSavingPlan(Map<String, dynamic> plan) async {
    final dbClient = await db;
    return await dbClient.insert('saving_plans', plan);
  }

  Future<List<Map<String, dynamic>>> getSavingPlans() async {
    final dbClient = await db;
    return await dbClient.query('saving_plans');
  }

  // ================= CRUD NOTIFICATION =================
  Future<int> insertNotification(Map<String, dynamic> notification) async {
    final dbClient = await db;
    return await dbClient.insert('notifications', notification);
  }

  Future<List<Map<String, dynamic>>> getNotifications(int userId) async {
    final dbClient = await db;
    return await dbClient.query(
      'notifications',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
  }

  //note for sum of today account
  Future<List<Map<String, dynamic>>> getTodayExpenseDetails({required int groupId}) async {
    final dbClient = await db;
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final todayEnd = todayStart.add(const Duration(days: 1));
    return await dbClient.query(
      'expenses',
      where: 'group_id = ? AND created_at BETWEEN ? AND ?',
      whereArgs: [groupId, todayStart.toIso8601String(), todayEnd.toIso8601String()]);
  }

  Future<double> getTodayTotalExpense({required int groupId}) async {
    final dbClient = await db;
    final now       = DateTime.now();
    final startOfDay     = DateTime(now.year, now.month, now.day).toIso8601String();
    final startOfTomorrow= DateTime(now.year, now.month, now.day)
        .add(const Duration(days: 1))
        .toIso8601String();

    // Chạy query
    final result = await dbClient.rawQuery('''
    SELECT SUM(amount) AS total
    FROM expenses
    WHERE group_id = ? AND created_at >= ? AND created_at < ?
  ''', [groupId, startOfDay, startOfTomorrow]);

    // Xử lý kết quả
    if (result.isNotEmpty) {
      final totalValue = result.first['total'];
      if (totalValue != null) {
        return (totalValue as num).toDouble();
      }
    }
    return 0.0;
  }

  //lay note theo ngay hom nay
  // Lấy ghi chú của user hiện tại trong ngày hôm nay
  Future<List<Note>> getTodayNotes() async {
    final db = await DBHelper._instance.db;
    final currentUser = AuthController().currentUser;

    if (currentUser == null) {
      return [];
    }

    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day).toIso8601String();
    final startOfTomorrow = DateTime(now.year, now.month, now.day)
        .add(const Duration(days: 1))
        .toIso8601String();

    var res = await db!.query(
      'notes',
      where: 'user_id = ? AND created_at >= ? AND created_at < ?',
      whereArgs: [currentUser.id, startOfDay, startOfTomorrow],
      orderBy: 'created_at DESC',
    );

    return res.map((noteMap) => Note.fromMap(noteMap)).toList();
  }

  // Future<int> getTodayNotes({required int userId}) async {
  //   final dbClient = await db;
  //   final startOfDay      = DateTime.now().toIso8601String();
  //   final startOfTomorrow = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
  //       .add(const Duration(days: 1))
  //       .toIso8601String();
  //   // Chạy query
  //   final result = await dbClient.rawQuery('''
  //   SELECT COUNT(*) AS total
  //   FROM notes
  //   WHERE user_id = ? AND created_at >= ? AND created_at < ?
  // ''', [userId, startOfDay, startOfTomorrow]);
  //
  //   if (result.isNotEmpty) {
  //     return (result.first['total'] as int?) ?? 0;
  //   }
  //   return 0;
  //
  // }
}

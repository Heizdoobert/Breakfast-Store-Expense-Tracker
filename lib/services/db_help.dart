import 'package:fl_chart/fl_chart.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


class DatabaseHelper {
  // --- 1. Cấu hình Singleton và Database Initialization ---
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  static Future<void> initialize() async {
    final dbHelper = DatabaseHelper();
    final path = join(await getDatabasesPath(), 'myExpenseDatabase.db');

    await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await dbHelper._onCreate(db, version);
      },
    );
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'myExpenseDatabase.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  // --- 2. Định nghĩa và Khởi tạo Bảng (Database Schema) ---
  Future<void> _onCreate(Database db, int version) async {
    final batch = db.batch();

    // Bảng users
    batch.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userName TEXT NOT NULL UNIQUE,
        email TEXT,
        passwordHash TEXT NOT NULL,
        fullName TEXT,
        role TEXT DEFAULT 'owner',
        createdAt TEXT DEFAULT CURRENT_TIMESTAMP,
        updatedAt TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    // Bảng groups
    batch.execute('''
      CREATE TABLE groups(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        createdAt TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    // Bảng group_members
    batch.execute('''
      CREATE TABLE groupMembers(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        groupId INTEGER,
        userId INTEGER,
        FOREIGN KEY (groupId) REFERENCES groups(id) ON DELETE CASCADE,
        FOREIGN KEY (userId) REFERENCES users(id) ON DELETE CASCADE
      )
    ''');

    // Bảng expenses
    batch.execute('''
      CREATE TABLE expenses(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        groupId INTEGER,
        userId INTEGER,
        amount REAL NOT NULL,
        description TEXT,
        createdAt TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (groupId) REFERENCES groups(id) ON DELETE CASCADE,
        FOREIGN KEY (userId) REFERENCES users(id) ON DELETE CASCADE
      )
    ''');

    // Bảng budgets
    batch.execute('''
      CREATE TABLE budgets(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        groupId INTEGER,
        amount REAL NOT NULL,
        month INTEGER,
        year INTEGER,
        FOREIGN KEY (groupId) REFERENCES groups(id) ON DELETE CASCADE
      )
    ''');

    // Bảng debts
    batch.execute('''
      CREATE TABLE debts(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        fromUserId INTEGER,
        toUserId INTEGER,
        amount REAL NOT NULL,
        isSettled INTEGER DEFAULT 0,
        FOREIGN KEY (fromUserId) REFERENCES users(id) ON DELETE CASCADE,
        FOREIGN KEY (toUserId) REFERENCES users(id) ON DELETE CASCADE
      )
    ''');

    // Bảng saving_plans
    batch.execute('''
      CREATE TABLE savingPlans(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        groupId INTEGER,
        targetAmount REAL NOT NULL,
        savedAmount REAL DEFAULT 0,
        deadline TEXT,
        FOREIGN KEY (groupId) REFERENCES groups(id) ON DELETE CASCADE
      )
    ''');

    // Bảng notifications
    batch.execute('''
      CREATE TABLE notifications(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER,
        message TEXT NOT NULL,
        isRead INTEGER DEFAULT 0,
        createdAt TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (userId) REFERENCES users(id) ON DELETE CASCADE
      )
    ''');

    // Bảng notes
    batch.execute('''
    CREATE TABLE notes(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      userId INTEGER,
      title TEXT NOT NULL,
      content TEXT,
      category TEXT,
      priority TEXT,
      isCompleted INTEGER DEFAULT 0,
      createdAt TEXT DEFAULT CURRENT_TIMESTAMP,
      updatedAt TEXT DEFAULT CURRENT_TIMESTAMP,
      FOREIGN KEY (userId) REFERENCES users(id) ON DELETE CASCADE
     )
    ''');

    // --- 3. Dữ liệu mặc định (Initial Data) ---
    // Thêm 4 user mặc định
    batch.insert('users', {
      'userName': 'super_owner',
      'email': 'owner@example.com',
      'passwordHash': '123456',
      'fullName': 'Owner Account',
      'role': 'owner',
    });

    batch.insert('users', {
      'userName': 'kitchen',
      'email': 'kitchen@example.com',
      'passwordHash': '123456',
      'fullName': 'Kitchen Account',
      'role': 'kitchen',
    });

    batch.insert('users', {
      'userName': 'manager',
      'email': 'manager@example.com',
      'passwordHash': '123456',
      'fullName': 'Manager Account',
      'role': 'manager',
    });

    batch.insert('users', {
      'userName': 'staff',
      'email': 'staff@example.com',
      'passwordHash': '123456',
      'fullName': 'Staff Account',
      'role': 'staff',
    });

    await batch.commit();
  }

// ==========================================================
// --- 4. Các phương thức CRUD cho thực thể User ---
// ==========================================================

}
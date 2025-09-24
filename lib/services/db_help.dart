import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../Model/User.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();
  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'myDatabase.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

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
        FOREIGN KEY (groupId) REFERENCES groups(id),
        FOREIGN KEY (userId) REFERENCES users(id)
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
        FOREIGN KEY (groupId) REFERENCES groups(id),
        FOREIGN KEY (userId) REFERENCES users(id)
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
        FOREIGN KEY (groupId) REFERENCES groups(id)
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
        FOREIGN KEY (fromUserId) REFERENCES users(id),
        FOREIGN KEY (toUserId) REFERENCES users(id)
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
        FOREIGN KEY (groupId) REFERENCES groups(id)
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
        FOREIGN KEY (userId) REFERENCES users(id)
      )
    ''');

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
      FOREIGN KEY (userId) REFERENCES users(id)
     )
    ''');

    // --- Thêm 4 user mặc định ---
    batch.insert('users', {
      'userName': 'super_owner',
      'email': 'owner@example.com',
      'passwordHash': '123456',
      'fullName': 'Owner Account',
      'role' : 'owner',
    });

    batch.insert('users', {
      'userName': 'kitchen',
      'email': 'kitchen@example.com',
      'passwordHash': '123456',
      'fullName': 'Kitchen Account',
      'role': 'kitchen',
    });

    batch.insert('users', {
      'username': 'manager',
      'email': 'manager@example.com',
      'passwordHash': '123456',
      'fullName': 'Manager Account',
      'role': 'manager',
    });

    batch.insert('users', {
      'username': 'staff',
      'email': 'staff@example.com',
      'passwordHash': '123456',
      'fullName': 'Staff Account',
      'role': 'staff',
    });

    await batch.commit();
  }

  //============CRUD User===================
  Future<User?> getUserByUserName(String userName) async {
    final db = await database;
    final maps = await db.query(
      'users',
      where: 'userName = ?',
      whereArgs: [userName],
    );
    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  Future<int> insertUser(User user) async {
    final db = await database;
    return await db.insert('users', user.toMap());
  }

  Future<List<User>> getAllUsers() async {
    final db = await database;
    final maps = await db.query('users');
    return maps.map((map) => User.fromMap(map)).toList();
  }
}

import 'package:fl_chart/fl_chart.dart';
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
    final path = join(databasePath, 'myExpenseDatabase.db');

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

  //financial overview
  Future<double> getAvailableBalance(int userId) async {
    final db = await database;

    final savingsResult = await db.rawQuery(
      'SELECT SUM(savedAmount) as total FROM savingPlans WHERE groupId IN (SELECT groupId FROM groupMembers WHERE userId = ?)',
      [userId],
    );
    final budgetResult = await db.rawQuery(
      'SELECT SUM(amount) as total FROM budgets WHERE groupId IN (SELECT groupId FROM groupMembers WHERE userId = ?)',
      [userId],
    );
    final expenseResult = await db.rawQuery(
      'SELECT SUM(amount) as total FROM expenses WHERE userId = ?',
      [userId],
    );

    final savings = savingsResult.first['total'] as double? ?? 0;
    final budget = budgetResult.first['total'] as double? ?? 0;
    final expenses = expenseResult.first['total'] as double? ?? 0;

    return savings + budget - expenses;
  }

  Future<double> getTotalBudget(int userId) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT SUM(amount) as total FROM budgets WHERE groupId IN (SELECT groupId FROM groupMembers WHERE userId = ?)',
      [userId],
    );
    return result.first['total'] as double? ?? 0;
  }

  Future<double> getSpentAmount(int userId) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT SUM(amount) as total FROM expenses WHERE userId = ?',
      [userId],
    );
    return result.first['total'] as double? ?? 0;

  }

  Future<double> getRemainingBudget(int userId) async {
    final db = await database;

    final budgetResult = await db.rawQuery(
      'SELECT SUM(amount) as total FROM budgets WHERE groupId IN (SELECT groupId FROM groupMembers WHERE userId = ?)',
      [userId],
    );
    final expenseResult = await db.rawQuery(
      'SELECT SUM(amount) as total FROM expenses WHERE userId = ?',
      [userId],
    );

    final totalBudget = budgetResult.first['total'] as double? ?? 0;
    final totalExpenses = expenseResult.first['total'] as double? ?? 0;

    return totalBudget - totalExpenses;
  }

  Future<List<String>> getDateLabels(int userId) async {
    final db = await database;
    final result = await db.rawQuery('''
      SELECT DATE(createdAt) as date
      FROM expenses
      WHERE userId = ?
      GROUP BY DATE(createdAt)
      ORDER BY DATE(createdAt)
    ''', [userId]);
    return result.map((row) => row['date'] as String).toList();
  }

  Future<double> getNetWorthChangePercent(int userId) async {
    // Tạm thời trả về giá trị cố định, bạn có thể tính theo thời gian
    return -1.4;
  }

  Future<double> getNetWorth(int userId) async {
    final db = await database;

    final savings = await db.rawQuery(
      'SELECT SUM(savedAmount) as total FROM savingPlans WHERE groupId IN (SELECT groupId FROM groupMembers WHERE userId = ?)',
      [userId],
    );
    final debts = await db.rawQuery(
      'SELECT SUM(amount) as total FROM debts WHERE fromUserId = ? AND isSettled = 0',
      [userId],
    );

    final savingsTotal = savings.first['total'] as double? ?? 0;
    final debtsTotal = debts.first['total'] as double? ?? 0;

    final remainingBudget = await getRemainingBudget(userId);

    return savingsTotal + remainingBudget - debtsTotal;
  }

  Future<List<FlSpot>> getNetWorthTrend(int userId) async {
    final db = await database;

    final result = await db.rawQuery('''
    SELECT DATE(createdAt) as date, SUM(amount) as total
    FROM expenses
    WHERE userId = ?
    GROUP BY DATE(createdAt)
    ORDER BY DATE(createdAt)
  ''', [userId]);

    List<FlSpot> spots = [];
    for (int i = 0; i < result.length; i++) {
      final row = result[i];
      final amount = row['total'] as double? ?? 0;
      spots.add(FlSpot(i.toDouble(), amount / 1000)); // scale về đơn vị 'k'
    }

    return spots;
  }
}

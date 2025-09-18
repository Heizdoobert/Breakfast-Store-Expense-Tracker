import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

//dua model vao
import '../Model/User.dart';
import '../Model/Expense.dart';
import '../Model/Group.dart';
import '../Model/GroupMember.dart';
import '../Model/Budget.dart';
import '../Model/Debt.dart';
import '../Model/SavingPlan.dart';
import '../Model/Notification.dart';

class DBHelper{
  //tao connection
  static final DBHelper _instance = DBHelper.internal();
  factory DBHelper() => _instance;
  DBHelper.internal();

  static Database? _db;

  //luu tru connection
  Future<Database?> get db async {
    if(_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;;
  }

  //tao bang
  Future<Database> initDb() async {
    String path = await getDatabasesPath() + 'mydb.db';
    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
          '''CREATE TABLE users(
          user_id INTEGER PRIMARY KEY AUTOINCREMENT,
          username VARCHAR(255), 
          email VARCHAR(255),
          password_hash VARCHAR(255),
          full_name VARCHAR(255),
          role ENUM('owner','manager', 'staff', 'kitchen'),
          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
          updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP 
          ),
          CREATE TABLE groups(
          group_id INTEGER PRIMARY KEY AUTOINCREMENT,
          group_name VARCHAR(255),
          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
          updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
          ),
          CREATE TABLE group_members(
          group_member_id INTEGER PRIMARY KEY AUTOINCREMENT,
          group_id INTEGER FOREIGN KEY REFERENCES groups(group_id),
          user_id INTEGER FOREIGN KEY REFERENCES users(user_id),
          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
          updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
          ),
          CREATE TABLE expense(
          expense_id INTEGER PRIMARY KEY AUTOINCREMENT,
          user_id INTEGER FOREIGN KEY REFERENCES users(user_id),
          group_id INTEGER FOREIGN KEY REFERENCES groups(group_id),
          title TEXT NOT NULL,
          amount REAL NOT NULL,
          category TEXT,
          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
          ),
          CREATE TABLE budgets(
          budget_id INTEGER PRIMARY KEY AUTOINCREMENT,
          user_id INTEGER FOREIGN KEY REFERENCES users(user_id),
          group_id INTEGER FOREIGN KEY REFERENCES groups(group_id),
          category TEXT NOT NULL,
          limit_amount REAL NOT NULL,
          start_date DATE NOT NULL,
          end_date DATE NOT NULL,
          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
          ),
          CREATE TABLE debts(
          debt_id INTEGER PRIMARY KEY AUTOINCREMENT,
          user_id INTEGER FOREIGN KEY REFERENCES users(user_id),
          lender TEXT NOT NULL,
          amount REAL NOT NULL,
          due_date TEXT,
          status TEXT DEFAULT 'unpaid', --unpaid, paid, overdue
          ),
          CREATE TABLE saving_plans(
          plan_id INTEGER PRIMARY KEY AUTOINCREMENT,
          user_id INTEGER FOREIGN KEY REFERENCES users(user_id),
          goal TEXT NOT NULL,
          target_amount REAL NOT NULL,
          current_amount REAL NOT NULL,
          deadline TEXT NOT NULL,
          ),
          CREATE TABLE notifications(
          notification_id INTEGER PRIMARY KEY AUTOINCREMENT,
          user_id INTEGER FOREIGN KEY REFERENCES users(user_id),
          message TEXT NOT NULL,
          type TEXT,  --alert, reminder, info
          is_read BOOLEAN DEFAULT FALSE,
          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
          ),
          '''
        );
      },
    );
  }

  //chen vao bang
  //user
  Future<int> insertUser(User user) async {
    var conn = await db;
    return await conn!.insert("user", user.toMap());
  }

  //groups
  Future<int> insertGroup(Group group) async {
    var conn = await db;
    return await conn!.insert("group", group.toMap());
  }
  //group_members
  Future<int> insertGroupMember(GroupMember groupMember) async {
    var conn = await db;
    return await conn!.insert("group_member", groupMember.toMap());
  }
  //budget
  Future<int> insertBudget(Budget budget) async {
    var conn = await db;
    return await conn!.insert("budget", budget.toMap());
  }
  //debt
  Future<int> insertDebt(Debt debt) async {
    var conn = await db;
    return await conn!.insert("debt", debt.toMap());
  }
  //expense
  Future<int> insertExpense(Expense expense) async {
    var conn = await db;
    return await conn!.insert("expense", expense.toMap());
  }
  //notification
  Future<int> insertNotification(Notification notification) async {
    var conn = await db;
    return await conn!.insert("notification", notification.toMap());
  }
  //saving_plans
  Future<int> insertSavingPlan(SavingPlan savingPlan) async {
    var conn = await db;
    return await conn!.insert("saving_plan", savingPlan.toMap());
  }

  //hien thi bang
  //user
  Future<List<User>> getUser() async {
    var conn = await db;
    final List<Map<String, dynamic>> maps = await conn!.query('user');

    return List.generate(maps.length, (i) {
      return User.fromMap(maps[i]);
    });
  }

  //groups
  Future<List<Group>> getGroup() async {
    var conn = await db;
    final List<Map<String, dynamic>> maps = await conn!.query('group');

    return List.generate(maps.length, (i) {
      return Group.fromMap(maps[i]);
    });
  }

  //group_members
  Future<List<GroupMember>> getGroupMember() async {
    var conn = await db;
    final List<Map<String, dynamic>> maps = await conn!.query('group_member');
    return List.generate(maps.length, (i) {
      return GroupMember.fromMap(maps[i]);
    });
  }

  //expense
  Future<List<Expense>> getExpense() async {
    var conn = await db;
    final List<Map<String, dynamic>> maps = await conn!.query('expense');
    return List.generate(maps.length, (i) {
      return Expense.fromMap(maps[i]);
    });
  }

  //budget
  Future<List<Budget>> getBudget() async {
    var conn = await db;
    final List<Map<String, dynamic>> maps = await conn!.query('budget');
    return List.generate(maps.length, (i) {
      return Budget.fromMap(maps[i]);
    });
  }

  //debt
  Future<List<Debt>> getDebt() async {
    var conn = await db;
    final List<Map<String, dynamic>> maps = await conn!.query('debt');
    return List.generate(maps.length, (i) {
      return Debt.fromMap(maps[i]);
    });
  }

  //saving_plans
  Future<List<SavingPlan>> getSavingPlan() async {
    var conn = await db;
    final List<Map<String, dynamic>> maps = await conn!.query('saving_plan');
    return List.generate(maps.length, (i) {
      return SavingPlan.fromMap(maps[i]);
    });
  }

  //notifications
  Future<List<Notification>> getNotification() async {
    var conn = await db;
    final List<Map<String, dynamic>> maps = await conn!.query('notification');
    return List.generate(maps.length, (i) {
      return Notification.fromMap(maps[i]);
    });
  }


  //xoa bang theo id
  Future<int> delete(String table, int id) async {
    var conn = await db;
    return await conn!.delete(table, where: 'id = ?', whereArgs: [id]);
  }
}
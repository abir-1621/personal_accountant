
import 'package:sqflite/sqflite.dart';
import '../model/DebtData.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final String path = join(await getDatabasesPath(), 'my_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute(
      'CREATE TABLE my_table(id INTEGER PRIMARY KEY, name TEXT, amount INTEGER, debt_taken_date TEXT, owe_date TEXT ,type TEXT)',
    );
    await db.execute(
      'CREATE TABLE types (id INTEGER PRIMARY KEY,type TEXT)',
    );
  }

  Future<int> insertData(DebtData debt) async {
    final db = await instance.database;
    final Map<String, dynamic> row = {
      'name': debt.name,
      'amount': debt.amount,
      'debt_taken_date': debt.debtTakenDate.toIso8601String(),
      'owe_date': debt.oweDate.toIso8601String(),
      'type': debt.type
    };
    return await db.insert('my_table', row);
  }

  Future<List<DebtData>> queryData() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> results = await db.rawQuery('SELECT * FROM my_table');
    return results.map((row) => DebtData(
      id: row['id'],
      name: row['name'],
      amount: row['amount'],
      debtTakenDate: DateTime.parse(row['debt_taken_date']),
      oweDate: DateTime.parse(row['owe_date']),
      type: row['type']
    )).toList();
  }

  Future<void> insertType(String type) async {
    final db = await database;
    await db.insert('types', {'type': type});
  }

  Future<List<String>> getTypes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('types');
    return List.generate(maps.length, (index) => maps[index]['type'] as String);
  }
}




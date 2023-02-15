import 'package:sqflite/sqflite.dart' as sql;

class sqlhelper {
  static Future<sql.Database> db() async {
    return sql.openDatabase("mydatabase.db", version: 1,
        onCreate: (sql.Database database, int version) async {
      await createTable(database);
    });
  }

  static Future<void> createTable(sql.Database database) async {
    await database.execute('''
  CREATE TABLE items (
  id INTEGER PRIMARY KEY AUTOINCRIMENT NOTNULL,
  title TEXT,
  description TEXT,
  )
  ''');
  }

  static Future<List<Map<String, dynamic>>> getItemss() async {
    final db = await sqlhelper.db();
    return db.query("items", orderBy: 'id');
  }

  static add_items(String title, String description) async {
    final db = await sqlhelper.db();
    final data = {"title": title, "description": description};
    final id = await db.insert("items", data);
    return id;
  }
}

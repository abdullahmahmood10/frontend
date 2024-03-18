import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

class DatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'chat_database.db');
    print(path);
    return await openDatabase(
      path,
      version: 2,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE chat_messages(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            sender TEXT,
            message TEXT,
            time TEXT,
            username TEXT,
            audio_path TEXT,
            audio_duration INTEGER
          )
        ''');
      },
    );
  }

  Future<void> insertMessage(
      String sender, String message, String time, String username,
      {String? audioPath, int? audioDuration}) async {
    final Database db = await database;
    await db.insert(
      'chat_messages',
      {
        'sender': sender,
        'message': message,
        'time': time,
        'username': username,
        'audio_path': audioPath,
        'audio_duration': audioDuration,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getMessages(String username) async {
    final Database db = await database;
    return db
        .query('chat_messages', where: 'username = ?', whereArgs: [username]);
  }

  Future<void> deleteAllMessages() async {
    final Database db = await database;
    await db.delete('chat_messages');
  }
}

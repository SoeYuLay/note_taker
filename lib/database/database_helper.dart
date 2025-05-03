import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../model/note.dart';

class DatabaseHelper{
  static final _databaseVersion = 1;
  static final _databaseName = "note.db";
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper _instance = DatabaseHelper._privateConstructor();

  factory DatabaseHelper(){
    return _instance;
  }

  Database? _database;

  Future<Database> _initDatabase() async{
    final databasePath = await getDatabasesPath();
    final path = join(databasePath,_databaseName);
    return await openDatabase(path,
      onCreate: (db,version) async{
        await db.execute('''
        CREATE TABLE note(
         id INTEGER PRIMARY KEY AUTOINCREMENT,
         title TEXT,
         description TEXT,
         time TEXT
        )
        ''');
      },
      version: _databaseVersion
    );
  }

  Future<Database> get database async{
    if(_database!=null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<List<Note>> fetchNote() async{
    final db = await _instance.database;
    List<Map<String,dynamic>> jsons = await db.query('note');
    List<Note> note = [];
    for(Map<String,dynamic> json in jsons){
      note.add(Note.fromJson(json));
    }
    return note;
  }

  Future<int> insertNote(Note note) async{
    final db = await _instance.database;
    return await db.insert('note', note.toJson());
  }

  Future<int> updateNote(Note note) async{
    final db = await _instance.database;
    return await db.update(
        'note',
        note.toJson(),
        where: 'id = ?',
        whereArgs: [note.id]);
  }

  Future<int> deleteMultipleNote(List<int> idList) async{
    if(idList.isEmpty) return 0;
    final db = await _instance.database;
    String placeholder = List.filled(idList.length, '?').join(', ');
    return await db.delete(
      'note',
      where: 'id IN ($placeholder)',
      whereArgs: idList
    );
  }
}
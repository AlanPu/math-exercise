import 'package:math_exercise/model/score.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocalDb {
  final String _tableName = 'scores';

  Future<Database> _openDb() async {
    return openDatabase(
      join(await getDatabasesPath(), 'math_exercise.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE scores(date TEXT, total TEXT, correct TEXT, combo TEXT, score TEXT)",
        );
      },
      version: 1,
    );
  }

  Future<void> insert(Score score) async {
    // Get a reference to the database.
    final Database db = await _openDb();

    await db.insert(
      _tableName,
      score.toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<List<Score>> getAll() async {
    // Get a reference to the database.
    final Database db = await _openDb();

    // Query the table for all the scores.
    final List<Map<String, dynamic>> maps = await db.query(_tableName);

    // Convert the List<Map<String, dynamic> into a List<Score>.
    return List.generate(maps.length, (i) {
      return Score(
        total: int.parse(maps[i]['total']),
        correct: int.parse(maps[i]['correct']),
        combo: int.parse(maps[i]['combo']),
        score: double.parse(maps[i]['score']),
        date: maps[i]['date'],
      );
    });
  }
}

import 'package:path/path.dart';
import 'package:pluton_mobile_app/model/posts_model.dart';
import 'package:sqflite/sqflite.dart';

class OfflineService {
  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDB();
    return _database;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'posts.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE posts (
            id INTEGER PRIMARY KEY,
            title TEXT,
            body TEXT,
            likes INTEGER,          
            dislikes INTEGER         
          )
        ''');
      },
    );
  }

  // Inserting posts into the database
  Future<void> insertPosts(List<Post> posts) async {
    final db = await database;
    for (var post in posts) {
      await db?.insert('posts', {
        'id': post.id,
        'title': post.title,
        'body': post.body,
        'likes': post.likes,          
        'dislikes': post.dislikes     
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  Future<List<Post>> fetchLocalPosts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db!.query('posts');

    return List.generate(maps.length, (i) {
      return Post(
        id: maps[i]['id'],
        title: maps[i]['title'],
        body: maps[i]['body'],
        likes: maps[i]['likes'],
        dislikes: maps[i]['dislikes'],
      );
    });
  }

  Future<void> deletePost(int id) async {
    final db = await database;
    await db?.delete('posts', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteAllPosts() async {
    final db = await database;
    await db?.delete('posts');
  }
}

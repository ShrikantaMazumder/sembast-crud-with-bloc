import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class NoteDB {
  // Singleton instance
  static final NoteDB _singleton = NoteDB._internal();

  // Singleton accessor
  static NoteDB get instance => _singleton;

  NoteDB._internal();

  static Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDB();
    return _db;
  }

  Future<Database> initDB() async {
    final documentDIR = await getApplicationDocumentsDirectory();
    final dbPath = join(documentDIR.path, 'note.db');
    final database = await databaseFactoryIo.openDatabase(dbPath);
    return database;
  }
}

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:wallet/models/item.dart';

class DBProvide {
  DBProvide._();
  static final DBProvide db = DBProvide._();
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  initDB() async {
    return await openDatabase(join(await getDatabasesPath(), 'wallet.db'),
        onCreate: (db, version) async {
      await db.execute(''' 
            CREATE TABLE itens (
              id INTEGER PRIMARY KEY AUTOINCREMENT, nome TEXT NOT NULL, valor REAL NOT NULL, 
              categoria TEXT NOT NULL, data DATETIME NOT NULL
            )
          ''');
    }, version: 1);
  }

  insertItem(ItemModel item) async {
    final db = await database;

    var res = await db.rawInsert('''
      INSERT INTO itens (nome,valor,categoria,data) VALUES (?,?,?,?)
     ''', [item.nome, item.valor, item.categoria, item.data]);

    return res;
  }

  updateItem(ItemModel item) async {
    final db = await database;

    var res = await db.rawUpdate(
        '''UPDATE itens SET nome = ?, valor = ?, categoria = ?, data = ? WHERE id = ?''',
        [item.nome, item.valor, item.categoria, item.data, item.id]);

    return res;
  }

  Future<dynamic> deleteItem(ItemModel item) async {
    final db = await database;

    var res =
        await db.rawDelete('''DELETE FROM itens WHERE id = ?''', [item.id]);

    return res;
  }

  Future<List<ItemModel>> getItens() async {
    final db = await database;
    List<ItemModel> list = new List();
    var res = await db.query("itens");

    for (var r in res) {
      list.add(new ItemModel(
          id: r['id'],
          nome: r['nome'],
          valor: r['valor'],
          categoria: r['categoria'],
          data: r['data']));
    }
    return list;
  }
}


import 'package:path_provider/path_provider.dart';
import 'package:shopping_cart_with_provider_app/models/cart_model.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;
import 'package:path/path.dart';

class DBHelper {

  // DATABASE INSTANCE
  static Database? _db;

  // CHECK DATABASE IS NULL OR NOT
  Future<Database?> get db async {

    if(_db != null){
      return _db!;
    }

    _db = await initDatabase();
  }

  // INTIALIZING THE DATABASE
  initDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'cart.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  // CREATE TABLE TO STORE DATA
  _onCreate(Database db, int version) async {

    await db.execute(
      'CREATE TABLE cart (id INTEGER PRIMARY KEY , productId VARCHAR UNIQUE,productName TEXT,initialPrice INTEGER, productPrice INTEGER , quantity INTEGER, unitTag TEXT , image TEXT )'
    );
  }


  // POST DATA IN CART LIST
  Future<Cart> insert(Cart cart) async {

    print(cart.toMap());

    var dbClient = await db;

    await dbClient?.insert('cart', cart.toMap());

    return cart;
  }

  // GET CART LIST DATA
  Future<List<Cart>> getCartList() async {

    var dbClient = await db;

    final List<Map<String, Object?>> queryResult = await dbClient!.query('cart'); 

    return queryResult.map((e) => Cart.fromMap(e)).toList();
  }

  // DELETE DATA FROM CART LIST
  Future<int> delete(int id) async {
    
    var dbClient = await db;

    return await dbClient!.delete(
      'cart',
      where: 'id = ?',
      whereArgs: [id]
    );
  }

  // UPDATE QUANTITY
  Future<int> updateQunatity(Cart cart) async {
    
    var dbClient = await db;

    return await dbClient!.update(
      'cart',
      cart.toMap(),
      where: 'id = ?',
      whereArgs: [cart.id]
    );
  }
}
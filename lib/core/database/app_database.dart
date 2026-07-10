import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import '../constants/app_constants.dart';

/// Owns the single Sqflite [Database] instance and its schema.
class AppDatabase {
  Database? _db;

  Future<Database> get database async {
    return _db ??= await _open();
  }

  Future<Database> _open() async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, AppConstants.dbName);
    return openDatabase(
      path,
      version: AppConstants.dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE ${AppConstants.cartTable} (
        product_id INTEGER PRIMARY KEY,
        title TEXT NOT NULL,
        price REAL NOT NULL,
        image TEXT NOT NULL,
        quantity INTEGER NOT NULL
      )
    ''');
    await _createOrderTables(db);
  }

  /// Applies incremental schema changes for existing installs.
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await _createOrderTables(db);
    }
  }

  /// Creates the orders + order_items tables. Order line items live in a
  /// separate table linked back to the parent order via [order_id].
  Future<void> _createOrderTables(Database db) async {
    await db.execute('''
      CREATE TABLE ${AppConstants.ordersTable} (
        id TEXT PRIMARY KEY,
        total REAL NOT NULL,
        item_count INTEGER NOT NULL,
        created_at INTEGER NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE ${AppConstants.orderItemsTable} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        order_id TEXT NOT NULL,
        product_id INTEGER NOT NULL,
        title TEXT NOT NULL,
        price REAL NOT NULL,
        image TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        FOREIGN KEY (order_id) REFERENCES ${AppConstants.ordersTable} (id)
          ON DELETE CASCADE
      )
    ''');
  }
}

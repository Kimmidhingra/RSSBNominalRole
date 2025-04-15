import 'package:flutter/material.dart';
import 'package:nominal_role/model/NominalRole.dart';
import 'package:nominal_role/model/Sewadar.dart';
import 'package:sqflite/sqflite.dart';

import 'package:path/path.dart';

class DatabaseService {
  // Singleton pattern
  static final DatabaseService _databaseService = DatabaseService._internal();
  factory DatabaseService() => _databaseService;
  DatabaseService._internal();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    // Initialize the DB first time it is accessed
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();

    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    final path = join(databasePath, 'flutter_sqflite_database.db');

    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    return await openDatabase(
      path,
      onCreate: _onCreate,
      version: 1,
      onConfigure: (db) async => await db.execute('PRAGMA foreign_keys = ON'),
    );
  }

  // When the database is first created, create a table to store breeds
  // and a table to store dogs.
  Future<void> _onCreate(Database db, int version) async {
    // Run the CREATE {breeds} TABLE statement on the database.
    await db.execute(
      'CREATE TABLE nominal_role(id INTEGER PRIMARY KEY, jathedar_name TEXT, jathedar_phone_no TEXT, vehicle_type Text, vehicle_number TEXT, driver_name TEXT, driver_phone_number TEXT, zone STEXT, area TEXT, sewaType String, sewa_start_date TEXT, sewa_end_date TEXT, number_of_days INTEGER )',
    );
    await db.execute(
      'CREATE TABLE sewadar_master_list (id INTEGER PRIMARY KEY, adhar_badge TEXT, sewadar_name TEXT, guardian_name TEXT, address TEXT, contact TEXT, remarks TEXT, gender TEXT, age INTEGER, adhar_no TEXT, badge_no TEXT)',
    );

    await db.execute(
        'CREATE TABLE sewadar_assigned_to_sewa (id INTEGER PRIMARY KEY, nominal_role_id INTEGER, sewadar_id INTEGER, FOREIGN KEY (nominal_role_id) REFERENCES nominal_role(id) ON DELETE CASCADE, FOREIGN KEY (sewadar_id) REFERENCES sewadar_master_list(id) ON DELETE CASCADE )');
  }

// =============================nominal role===========================
  // Define a function that inserts nominal roles into the database
  Future<int> insertNominalRole(NominalRole nominalRole) async {
    // Get a reference to the database.
    // Ensure that the background isolate can use Flutter APIs
    WidgetsFlutterBinding.ensureInitialized();
    final db = await _databaseService.database;
    return await db.insert(
      'nominal_role',
      nominalRole.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

// update nominal role
  Future<void> updateNominalRole(NominalRole nominalRole) async {
    // Get a reference to the database.
    final db = await _databaseService.database;

    // Update the given breed
    await db.update(
      'nominal_role',
      nominalRole.toMap(),
      // Ensure that the Breed has a matching id.
      where: 'id = ?',
      // Pass the Breed's id as a whereArg to prevent SQL injection.
      whereArgs: [nominalRole.id],
    );
  }

  Future<List<NominalRole>> nominalRoles() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query('nominal_role');
    return List.generate(
        maps.length, (index) => NominalRole.fromMap(maps[index]));
  }

  // A method that delete a nominal Role data from the nominal_role table.
  Future<void> deleteNominalRole(int id) async {
    // Get a reference to the database.
    final db = await _databaseService.database;
    await db.delete(
      'nominal_role',
      // Use a `where` clause to delete a specific nominal role.
      where: 'id = ?',
      // Pass the nominal role's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }

// ========================sewadar master list===================
  Future<void> insertSewadarMasterList(List<Sewadar> sewadars) async {
    final db = await _databaseService.database;
    Batch batch = db.batch();
    for (var sewadar in sewadars) {
      batch.insert(
        'sewadar_master_list',
        sewadar.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit();
  }

  Future<List<Sewadar>> getSewadarMasterList() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps =
        await db.query('sewadar_master_list');
    return List.generate(maps.length, (index) => Sewadar.fromMap(maps[index]));
  }

  // ====================== Assigned sewa to sewadar =====================
  Future<void> assignSewaToSewadar(
      List<Sewadar> sewadars, int nominalRoleId) async {
    // Get a reference to the database.
    final db = await _databaseService.database;
    Batch batch = db.batch();
    for (var sewadar in sewadars) {
      print(sewadar);
      batch.insert(
        'sewadar_assigned_to_sewa',
        {'sewadar_id': sewadar.id, 'nominal_role_id': nominalRoleId},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit();
  }

  Future<List<Sewadar>> getSewadarAssignedToNominalRole(
      int nominalRoleId) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> result = await db.rawQuery('''
    SELECT sewadar.*
    FROM sewadar_master_list sewadar
    JOIN sewadar_assigned_to_sewa ON sewadar.id = sewadar_assigned_to_sewa.sewadar_id
    WHERE sewadar_assigned_to_sewa.nominal_role_id = ?
  ''', [nominalRoleId]);
    return result.map((e) => Sewadar.fromMap(e)).toList();
  }
}

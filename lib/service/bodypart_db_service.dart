import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gym_raiser/model/bodypart_model.dart';
import 'package:gym_raiser/model/set_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class BodyPartService {
  static final BodyPartService bodyPartService = BodyPartService._init();
  static Database? _database;

  BodyPartService._init();

  final String _tableName = 'BodyPart';
  final String _databaseName = 'bodypart.db';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await open(_databaseName);
    return _database!;
  }

  Future<Database> open(String dbName) async {
    debugPrint('Service Açıldı');
    Directory? directory = await getApplicationDocumentsDirectory();
    String databasePath = join(directory.path, _databaseName);
    debugPrint(databasePath);
    return await openDatabase(
      databasePath,
      version: 1,
      onCreate: createDb,
      onOpen: (db) async {
        // const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
        // const intType = 'INTEGER';
        // const boolType = 'INTEGER';
        // const textType = 'TEXT';

        // debugPrint('open Açıldı');
        // await db.execute(
        //     "CREATE TABLE SingleSet (${SingleSetFields.id} $idType,${SingleSetFields.bodypartID} $intType ,${SingleSetFields.workoutID} $intType,${SingleSetFields.setNum} $intType,${SingleSetFields.status} $boolType, ${SingleSetFields.repeatNum} $textType,${SingleSetFields.weightList} $textType,${SingleSetFields.intensityRate} $textType,${SingleSetFields.date} $textType)");
      },
    );
  }

  Future<void> close() async {
    final db = await bodyPartService.database;
    await db.close();
  }

  Future<void> createDb(Database database, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const partType = 'VARCHAR(20)';

    debugPrint('createDb Açıldı');
    await database.execute(
        "CREATE TABLE $_tableName (${BodyPartFields.id} $idType ,${BodyPartFields.bodyPartName} $partType)");
  }

  Future<BodyPart?> insert(BodyPart bodyPart) async {
    try {
      var db = await bodyPartService.database;
      final id = await db.insert(_tableName, bodyPart.toMap());
      return bodyPart.copy(id: id);
    } catch (e) {
      debugPrint('Insert Error: $e');
      return null;
    }
  }

  Future<List<BodyPart?>> readAll() async {
    try {
      var db = await bodyPartService.database;
      final mapList =
          await db.query(_tableName, columns: BodyPartFields.values);
      return mapList
          .map((Map<String, Object?> singleMap) => BodyPart.fromMap(singleMap))
          .toList();
    } catch (e) {
      debugPrint('readAll Error: $e');
      return [];
    }
  }

  Future<BodyPart?> readbyID(int id) async {
    try {
      var db = await bodyPartService.database;
      final map = await db.query(_tableName,
          columns: BodyPartFields.values,
          where: '${BodyPartFields.id}= ?',
          whereArgs: [id]);

      if (map.isNotEmpty) {
        return BodyPart.fromMap(map.first);
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('readbyID Error: $e');
      return null;
    }
  }

  Future<List<BodyPart?>> getAllTableRaw() async {
    try {
      var db = await bodyPartService.database;
      var result = await db.rawQuery('SELECT * FROM $_tableName');
      return result.map((map) => BodyPart.fromMap(map)).toList();
    } catch (e) {
      debugPrint('GetAllTableRaw Error: $e');
      return [];
    }
  }

  Future<int?> update(BodyPart bodyPart) async {
    try {
      var db = await bodyPartService.database;
      return await db.update(
        _tableName,
        bodyPart.toMap(),
        where: 'id = ?',
        whereArgs: [bodyPart.id],
      );
    } catch (e) {
      debugPrint('updateData Error: $e');
      return null;
    }
  }

  Future<int?> delete(BodyPart bodyPart) async {
    try {
      var db = await bodyPartService.database;
      return await db
          .delete(_tableName, where: 'id= ?', whereArgs: [bodyPart.id]);
    } catch (e) {
      debugPrint('deleteRow Error: $e');
      return null;
    }
  }

  Future<void> deleteTable() async {
    var db = await bodyPartService.database;
    await db.execute('DROP TABLE IF EXISTS $_tableName');
  }
}

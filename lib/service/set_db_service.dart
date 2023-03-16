import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gym_raiser/model/set_model.dart';
import 'package:gym_raiser/service/base_db_provider.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class SetService extends BaseDBProvider<SingleSet> {
  static final SetService setService = SetService._init();
  static Database? _database;

  SetService._init();

  final String _tableName = 'SingleSet';
  final String _databaseName = 'bodypart.db';

  @override
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await open(_databaseName);
    return _database!;
  }

  @override
  Future<Database> open(String dbName) async {
    Directory? directory = await getApplicationDocumentsDirectory();
    String databasePath = join(directory.path, _databaseName);
    debugPrint(databasePath);
    return await openDatabase(
      databasePath,
      version: 1,
      onCreate: createDb,
      onOpen: (db) async {},
    );
  }

  @override
  Future<void> close() async {
    final db = await setService.database;
    await db.close();
  }

  Future<void> createDb(Database database, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const intType = 'INTEGER';
    const boolType = 'INTEGER';
    const textType = 'TEXT';

    debugPrint('createDb Açıldı');
    await database.execute(
        "CREATE TABLE $_tableName (${SingleSetFields.id} $idType, ${SingleSetFields.bodypartID} $intType ,${SingleSetFields.workoutID} $intType,${SingleSetFields.setNum} $intType,${SingleSetFields.status} $boolType, ${SingleSetFields.repeatNum} $textType,${SingleSetFields.weightList} $textType,${SingleSetFields.intensityRate} $textType,${SingleSetFields.date} $textType)");
  }

  @override
  Future<SingleSet?> insert(SingleSet dataModel) async {
    try {
      var db = await setService.database;
      final id = await db.insert(_tableName, dataModel.toMap());
      return dataModel.copyWith(id: id);
    } catch (e) {
      debugPrint('Insert Error: $e');
      return null;
    }
  }

  @override
  Future<List<SingleSet?>> readAll() async {
    try {
      var db = await setService.database;
      final mapList =
          await db.query(_tableName, columns: SingleSetFields.values);
      return mapList
          .map((Map<String, Object?> singleMap) => SingleSet.fromMap(singleMap))
          .toList();
    } catch (e) {
      debugPrint('readAll Error: $e');
      return [];
    }
  }

  Future<List<SingleSet>?> readbyWorkoutID(int id) async {
    var db = await setService.database;
    final mapList = await db.query(_tableName,
        columns: SingleSetFields.values,
        orderBy: '${SingleSetFields.date} DESC',
        where: '${SingleSetFields.workoutID}= ?',
        whereArgs: [id]);

    if (mapList.isNotEmpty) {
      return mapList
          .map((Map<String, Object?> singleMap) => SingleSet.fromMap(singleMap))
          .toList();
    } else {
      return null;
    }
  }

  @override
  Future<List<SingleSet?>> getAllTableRaw() async {
    try {
      var db = await setService.database;
      var result = await db.rawQuery('SELECT * FROM $_tableName');
      return result.map((map) => SingleSet.fromMap(map)).toList();
    } catch (e) {
      debugPrint('GetAllTableRaw Error: $e');
      return [];
    }
  }

  @override
  Future<int?> update(SingleSet dataModel) async {
    try {
      var db = await setService.database;
      return await db.update(
        _tableName,
        dataModel.toMap(),
        where: 'id = ?',
        whereArgs: [dataModel.id],
      );
    } catch (e) {
      debugPrint('updateData Error: $e');
      return null;
    }
  }

  @override
  Future<int?> delete(SingleSet dataModel) async {
    try {
      var db = await setService.database;
      return await db.delete(_tableName,
          where: '${SingleSetFields.id}= ?', whereArgs: [dataModel.id]);
    } catch (e) {
      debugPrint('deleteRow Error: $e');
      return null;
    }
  }

  @override
  Future<void> deleteTable() async {
    var db = await setService.database;
    await db.execute('DROP TABLE IF EXISTS $_tableName');
  }

  @override
  Future<SingleSet?> readbyID(int id) {
    throw UnimplementedError();
  }
}

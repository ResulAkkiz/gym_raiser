import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gym_raiser/model/workout_model.dart';
import 'package:gym_raiser/service/base_db_provider.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class WorkoutService extends BaseDBProvider<Workout> {
  static final WorkoutService workoutService = WorkoutService._init();
  static Database? _database;

  WorkoutService._init();

  final String _tableName = 'Workout';
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
    );
  }

  @override
  Future<void> close() async {
    final db = await workoutService.database;
    await db.close();
  }

  Future<void> createDb(Database database, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const bodyPartIdType = 'INTEGER';
    const workoutNameType = 'VARCHAR(20)';
    const boolType = 'INTEGER';
    const blobType = 'BLOB';

    debugPrint('createDb Açıldı');
    await database.execute(
        "CREATE TABLE $_tableName (${WorkoutFields.id} $idType,${WorkoutFields.bodypartID} $bodyPartIdType,${WorkoutFields.workoutName} $workoutNameType,${WorkoutFields.workoutImage} $blobType,${WorkoutFields.workoutStatus} $boolType)");
  }

  @override
  Future<Workout?> insert(Workout dataModel) async {
    try {
      var db = await workoutService.database;
      final id = await db.insert(_tableName, dataModel.toMap());
      return dataModel.copy(id: id);
    } catch (e) {
      debugPrint('Insert Error: $e');
      return null;
    }
  }

  @override
  Future<List<Workout?>> readAll() async {
    try {
      var db = await workoutService.database;
      final mapList = await db.query(_tableName, columns: WorkoutFields.values);
      return mapList
          .map((Map<String, Object?> singleMap) => Workout.fromMap(singleMap))
          .toList();
    } catch (e) {
      debugPrint('readAll Error: $e');
      return [];
    }
  }

  @override
  Future<Workout?> readbyID(int id) async {
    try {
      var db = await workoutService.database;
      final map = await db.query(_tableName,
          columns: WorkoutFields.values,
          where: '${WorkoutFields.id}= ?',
          whereArgs: [id]);

      if (map.isNotEmpty) {
        return Workout.fromMap(map.first);
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('readbyID Error: $e');
      return null;
    }
  }

  Future<List<Workout>?> readbyWorkoutID(int bodypartID) async {
    try {
      var db = await workoutService.database;
      final mapList = await db.query(_tableName,
          columns: WorkoutFields.values,
          where: '${WorkoutFields.bodypartID}= ?',
          whereArgs: [bodypartID]);

      if (mapList.isNotEmpty) {
        return mapList
            .map((Map<String, Object?> singleMap) => Workout.fromMap(singleMap))
            .toList();
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('readbyID Error: $e');
      return null;
    }
  }

  @override
  Future<List<Workout?>> getAllTableRaw() async {
    try {
      var db = await workoutService.database;
      var result = await db.rawQuery('SELECT * FROM $_tableName');
      return result.map((map) => Workout.fromMap(map)).toList();
    } catch (e) {
      debugPrint('GetAllTableRaw Error: $e');
      return [];
    }
  }

  @override
  Future<int?> update(Workout dataModel) async {
    try {
      var db = await workoutService.database;
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
  Future<int?> delete(Workout dataModel) async {
    try {
      var db = await workoutService.database;
      return await db.delete(_tableName,
          where: '${WorkoutFields.id}= ?', whereArgs: [dataModel.id]);
    } catch (e) {
      debugPrint('deleteRow Error: $e');
      return null;
    }
  }

  @override
  Future<void> deleteTable() async {
    var db = await workoutService.database;
    await db.execute('DROP TABLE IF EXISTS $_tableName');
  }
}

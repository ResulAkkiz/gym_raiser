import 'package:gym_raiser/model/data_model.dart';
import 'package:sqflite/sqflite.dart';

abstract class BaseDBProvider<T extends DataModel> {
  Future<T?> insert(T dataModel);
  Future<List<T?>> readAll();
  Future<T?> readbyID(int id);
  Future<int?> update(T dataModel);
  Future<int?> delete(T dataModel);
  Future<void> deleteTable();
  Future<List<T?>> getAllTableRaw();
  Future<void> close();
  Future<Database> open(String dbName);
  Future<Database> get database;
}

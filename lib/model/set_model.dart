// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:gym_raiser/model/data_model.dart';

class SingleSetFields {
  static String id = '_id';
  static String bodypartID = 'bodypart_id';
  static String workoutID = 'workout_id';
  static String repeatNum = 'repeat_num';
  static String weightList = 'weight_list';
  static String setNum = 'set_num';
  static String intensityRate = 'intesity_rate';
  static String status = 'status';
  static String date = 'date';

  static List<String> values = [
    id,
    bodypartID,
    workoutID,
    repeatNum,
    setNum,
    intensityRate,
    weightList,
    status,
    date
  ];
}

class SingleSet extends DataModel<SingleSet> {
  int? id;
  int bodypartID;
  int workoutID;
  int setNum;
  List<double> weightList;
  List<int> repeatNum;
  List<int> intensityRate;
  DateTime date;
  bool status;
  SingleSet({
    this.id,
    required this.bodypartID,
    required this.workoutID,
    required this.repeatNum,
    required this.setNum,
    required this.weightList,
    required this.intensityRate,
    required this.date,
    required this.status,
  });

  @override
  SingleSet fromMap(Map<String, dynamic> map) {
    return SingleSet.fromMap(map);
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      SingleSetFields.id: id,
      SingleSetFields.bodypartID: bodypartID,
      SingleSetFields.workoutID: workoutID,
      SingleSetFields.setNum: setNum,
      SingleSetFields.repeatNum: repeatNum.join(','),
      SingleSetFields.weightList: weightList.join(','),
      SingleSetFields.intensityRate: intensityRate.join(','),
      SingleSetFields.date: date.toIso8601String(),
      SingleSetFields.status: status ? 1 : 0,
    };
  }

  SingleSet copyWith({
    int? id,
    int? bodypartID,
    int? workoutID,
    List<int>? repeatNum,
    List<double>? weightList,
    int? setNum,
    List<int>? intensityRate,
    DateTime? date,
    bool? status,
  }) {
    return SingleSet(
      id: id ?? this.id,
      bodypartID: bodypartID ?? this.bodypartID,
      workoutID: workoutID ?? this.workoutID,
      repeatNum: repeatNum ?? this.repeatNum,
      setNum: setNum ?? this.setNum,
      intensityRate: intensityRate ?? this.intensityRate,
      date: date ?? this.date,
      status: status ?? this.status,
      weightList: weightList ?? this.weightList,
    );
  }

  factory SingleSet.fromMap(Map<String, dynamic> map) {
    return SingleSet(
      id: map[SingleSetFields.id] != null
          ? map[SingleSetFields.id] as int
          : null,
      bodypartID: map[SingleSetFields.bodypartID] as int,
      workoutID: map[SingleSetFields.workoutID] as int,
      setNum: map[SingleSetFields.setNum] as int,
      weightList: List<double>.from((map[SingleSetFields.weightList] as String)
          .split(',')
          .map((e) => double.parse(e))
          .toList()),
      intensityRate: List<int>.from(
          (map[SingleSetFields.intensityRate] as String)
              .split(',')
              .map((e) => int.parse(e))
              .toList()),
      repeatNum: List<int>.from((map[SingleSetFields.repeatNum] as String)
          .split(',')
          .map((e) => int.parse(e))
          .toList()),
      date: DateTime.parse(map[SingleSetFields.date] as String),
      status: map[SingleSetFields.status] == 1,
    );
  }

  String toJson() => json.encode(toMap());

  factory SingleSet.fromJson(String source) =>
      SingleSet.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SingleSet(_id: $id, bodypartID: $bodypartID, workoutID: $workoutID, repeatNum: $repeatNum, setNum: $setNum, intensityRate: $intensityRate, date: $date, status: $status)';
  }
}

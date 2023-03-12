// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:gym_raiser/model/data_model.dart';

class WorkoutFields {
  static const String id = '_id';
  static const String bodypartID = 'bodypart_id';
  static const String workoutName = 'workout_name';
  static const String workoutImage = 'workout_image_path';
  static const String workoutStatus = 'workout_status';
  static List<String> values = [id, bodypartID, workoutName, workoutImage];
}

class Workout extends DataModel<Workout> {
  int? id;
  int bodypartID;
  String workoutName;
  List<int>? workoutImage;
  bool workoutStatus;
  Workout(
      {this.id,
      required this.bodypartID,
      required this.workoutName,
      required this.workoutStatus,
      this.workoutImage});

  factory Workout.fromMap(Map<String, dynamic> map) {
    return Workout(
      id: map[WorkoutFields.id] as int,
      workoutStatus: map[WorkoutFields.workoutStatus] == 1,
      bodypartID: map[WorkoutFields.bodypartID] as int,
      workoutName: map[WorkoutFields.workoutName] as String,
      workoutImage: map[WorkoutFields.workoutImage],
    );
  }

  @override
  Workout fromMap(Map<String, dynamic> map) {
    return Workout.fromMap(map);
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      WorkoutFields.id: id,
      WorkoutFields.bodypartID: bodypartID,
      WorkoutFields.workoutName: workoutName,
      WorkoutFields.workoutImage: workoutImage,
      WorkoutFields.workoutStatus: workoutStatus ? 1 : 0,
    };
  }

  Workout copy(
          {int? id,
          int? bodypartID,
          String? workoutName,
          List<int>? workoutImage,
          bool? workoutStatus}) =>
      Workout(
          id: id ?? this.id,
          workoutStatus: workoutStatus ?? this.workoutStatus,
          workoutName: workoutName ?? this.workoutName,
          workoutImage: workoutImage ?? this.workoutImage,
          bodypartID: bodypartID ?? this.bodypartID);
}

//_id
//bodypart_id
//workout_id
//repeat_num
//set_num
//intesity_rate
//status
//date
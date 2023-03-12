import 'package:gym_raiser/model/data_model.dart';

class BodyPartFields {
  static const String id = '_id';
  static const String bodyPartName = 'bodypart_name';
  static List<String> values = [id, bodyPartName];
}

class BodyPart extends DataModel<BodyPart> {
  int? id;
  String bodyPartName;

  BodyPart({
    this.id,
    required this.bodyPartName,
  });

  factory BodyPart.fromMap(Map<String, dynamic> map) {
    return BodyPart(
      id: map[BodyPartFields.id] as int,
      bodyPartName: map[BodyPartFields.bodyPartName] as String,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      BodyPartFields.id: id,
      BodyPartFields.bodyPartName: bodyPartName,
    };
  }

  @override
  BodyPart fromMap(Map<String, dynamic> map) {
    return BodyPart.fromMap(map);
  }

  BodyPart copy({int? id, String? bodyPartName}) => BodyPart(
      id: id ?? this.id, bodyPartName: bodyPartName ?? this.bodyPartName);
}

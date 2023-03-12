import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gym_raiser/core/app_contants.dart';
import 'package:gym_raiser/model/bodypart_model.dart';
import 'package:gym_raiser/model/workout_model.dart';
import 'package:gym_raiser/pages/workout_detail_page.dart';
import 'package:gym_raiser/service/workout_db_service.dart';

class WorkoutPage extends StatefulWidget {
  final BodyPart bodyPart;
  const WorkoutPage({super.key, required this.bodyPart});

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  late WorkoutService sqlService;
  late BodyPart bodyPart;
  List<Workout> listWorkout = [];
  bool isLoading = false;
  @override
  void initState() {
    bodyPart = widget.bodyPart;
    sqlService = WorkoutService.workoutService;
    refreshTable();
    super.initState();
  }

  Future<void> refreshTable() async {
    setState(() => isLoading = true);
    listWorkout = (await sqlService.readbyWorkoutID(bodyPart.id!)) ?? [];
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          bodyPart.bodyPartName,
          style: TextStyles.appBarStyle,
        ),
      ),
      body: !isLoading
          ? ListView.builder(
              itemCount: listWorkout.length,
              itemBuilder: (context, index) {
                var result = listWorkout[index];

                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => WorkoutDetailPage(workout: result),
                    ));
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 6.0, horizontal: 12.0),
                    decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(color: Colors.black38, offset: Offset(4, 4)),
                      ],
                      borderRadius: BorderRadius.circular(12.0),
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 12.0),
                    child: Flex(
                      direction: Axis.horizontal,
                      children: [
                        Expanded(
                          flex: 8,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(result.workoutName,
                                  style: TextStyles.listileTitleTextStyle),
                              // Text('16 Egzersiz',
                              //     style: TextStyles.listileSubtitleTextStyle),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12.0),
                            child: Image(
                              height: 150,
                              width: 75,
                              fit: BoxFit.fill,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },
                              image: result.workoutImage != null
                                  ? MemoryImage(
                                      Uint8List.fromList(result.workoutImage!))
                                  : const AssetImage(
                                          'assets/images/im_placeholder.png')
                                      as ImageProvider,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}

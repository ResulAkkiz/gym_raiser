import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gym_raiser/core/app_contants.dart';
import 'package:gym_raiser/model/bodypart_model.dart';
import 'package:gym_raiser/model/workout_model.dart';
import 'package:gym_raiser/pages/workout_detail_page.dart';
import 'package:gym_raiser/service/workout_db_service.dart';
import 'package:image_picker/image_picker.dart';

class WorkoutPage extends StatefulWidget {
  final BodyPart bodyPart;
  const WorkoutPage({super.key, required this.bodyPart});

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late WorkoutService sqlService;
  late BodyPart bodyPart;
  File? photo;
  ImagePicker imagePicker = ImagePicker();
  late TextEditingController workoutNameController;
  List<Workout> listWorkout = [];
  bool isEditable = false;
  bool isLoading = false;
  @override
  void initState() {
    workoutNameController = TextEditingController();
    bodyPart = widget.bodyPart;
    sqlService = WorkoutService.workoutService;
    refreshTable();
    super.initState();
  }

  @override
  void dispose() {
    isEditable = false;
    super.dispose();
  }

  void _kameradanCek() async {
    var yeniResim = await imagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 1024, maxWidth: 1024);
    setState(() {
      if (yeniResim != null) {
        photo = File(yeniResim.path);
      }
    });
  }

  void _galeridenSec() async {
    var yeniResim = await imagePicker.pickImage(
        source: ImageSource.gallery, maxHeight: 1024, maxWidth: 1024);
    setState(() {
      if (yeniResim != null) {
        photo = File(yeniResim.path);
        debugPrint(yeniResim.path);
        debugPrint(photo!.path);
      }
    });
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
          ? SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: listWorkout.length,
                      itemBuilder: (context, index) {
                        var result = listWorkout[index];
                        return InkWell(
                          onTap: () async {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  WorkoutDetailPage(workout: result),
                            ));
                          },
                          child: Stack(
                            children: [
                              Container(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 6.0, horizontal: 12.0),
                                decoration: BoxDecoration(
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Colors.black38,
                                        offset: Offset(4, 4)),
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
                                      child: Center(
                                        child: Text(result.workoutName,
                                            style: TextStyles
                                                .listileTitleTextStyle),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 5,
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        child: Image(
                                          height: 150,
                                          width: 75,
                                          fit: BoxFit.fill,
                                          image: result.workoutImage != null
                                              ? MemoryImage(Uint8List.fromList(
                                                  result.workoutImage!))
                                              : const AssetImage(
                                                      'assets/images/im_placeholder.png')
                                                  as ImageProvider,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              IconButton(
                                  padding: const EdgeInsets.all(24.0),
                                  onPressed: () async {
                                    await sqlService.delete(result);
                                    await refreshTable();
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ))
                            ],
                          ),
                        );
                      },
                    ),
                    if (!isEditable)
                      Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 6.0, horizontal: 12.0),
                        decoration: BoxDecoration(
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.black38, offset: Offset(4, 4)),
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
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        isEditable = true;
                                      });
                                    },
                                    child: Text(
                                      'Antreman Ekle',
                                      style: TextStyles.listileTitleTextStyle,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12.0),
                                child: Container(
                                  height: 150,
                                  width: 75,
                                  decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(0.7)),
                                  child: const Icon(
                                    Icons.add_rounded,
                                    size: 70,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    else
                      Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 6.0, horizontal: 12.0),
                        decoration: BoxDecoration(
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.black38, offset: Offset(4, 4)),
                          ],
                          borderRadius: BorderRadius.circular(12.0),
                          color: Colors.white,
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 12.0),
                        child: Column(
                          children: [
                            Flex(
                              direction: Axis.horizontal,
                              children: [
                                Expanded(
                                  flex: 8,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextFormField(
                                          validator: (value) {
                                            if (value == null || value == '') {
                                              return 'Lütfen antreman ismi giriniz.';
                                            }
                                            return null;
                                          },
                                          controller: workoutNameController,
                                          keyboardType: TextInputType.name,
                                          decoration: InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 2.0,
                                                      horizontal: 10.0),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(50.0),
                                                borderSide: const BorderSide(
                                                  width: 3,
                                                ),
                                              ),
                                              hintText: 'Antreman İsmi'),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 5,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12.0),
                                    child: photo == null
                                        ? InkWell(
                                            onTap: () {
                                              showModalBottomSheet(
                                                  backgroundColor:
                                                      Theme.of(context)
                                                          .primaryColor,
                                                  context: context,
                                                  builder: (context) {
                                                    return ListView(
                                                      physics:
                                                          const NeverScrollableScrollPhysics(),
                                                      shrinkWrap: true,
                                                      children: [
                                                        ListTile(
                                                          leading: const Icon(
                                                            Icons.camera,
                                                            color: Colors.white,
                                                          ),
                                                          title: const Text(
                                                              'Kamera'),
                                                          onTap: () {
                                                            _kameradanCek();
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                        ListTile(
                                                          leading: const Icon(
                                                              Icons.photo_album,
                                                              color:
                                                                  Colors.white),
                                                          title: const Text(
                                                              'Galeri'),
                                                          onTap: () {
                                                            _galeridenSec();
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  });
                                            },
                                            child: Container(
                                              height: 150,
                                              width: 75,
                                              decoration: BoxDecoration(
                                                  color: Colors.grey
                                                      .withOpacity(0.7)),
                                              child: const Icon(
                                                Icons.add_rounded,
                                                size: 70,
                                                color: Colors.white,
                                              ),
                                            ),
                                          )
                                        : Image(
                                            height: 150,
                                            width: 75,
                                            fit: BoxFit.fill,
                                            image: photo != null
                                                ? FileImage(photo!)
                                                : const AssetImage(
                                                        'assets/images/im_placeholder.png')
                                                    as ImageProvider,
                                          ),
                                  ),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  constraints: const BoxConstraints(),
                                  onPressed: () async {
                                    isEditable = false;
                                    workoutNameController.clear();
                                    setState(() {});
                                  },
                                  icon: const Icon(
                                    size: 34,
                                    Icons.cancel,
                                    color: Colors.red,
                                  ),
                                ),
                                IconButton(
                                    constraints: const BoxConstraints(),
                                    onPressed: () async {
                                      formKey.currentState!.save();
                                      if (formKey.currentState!.validate()) {
                                        Workout workout = Workout(
                                          bodypartID: bodyPart.id!,
                                          workoutName:
                                              workoutNameController.text,
                                          workoutStatus: true,
                                          workoutImage:
                                              await photo?.readAsBytes(),
                                        );
                                        await sqlService.insert(workout);
                                        isEditable = false;
                                        photo = null;
                                        refreshTable();
                                        setState(() {});
                                      }
                                    },
                                    icon: const Icon(
                                      size: 34,
                                      Icons.check_circle_rounded,
                                      color: Colors.green,
                                    ))
                              ],
                            )
                          ],
                        ),
                      )
                  ],
                ),
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}

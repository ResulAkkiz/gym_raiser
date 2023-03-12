import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gym_raiser/model/workout_model.dart';
import 'package:gym_raiser/service/workout_db_service.dart';
import 'package:image_picker/image_picker.dart';

class ProcessPage extends StatefulWidget {
  const ProcessPage({super.key});

  @override
  State<ProcessPage> createState() => _ProcessPageState();
}

class _ProcessPageState extends State<ProcessPage> {
  File? photo;
  ImagePicker imagePicker = ImagePicker();
  late WorkoutService sqlService;
  List<Workout?> listWorkout = [];
  bool isLoading = false;

  TextEditingController bodyPartidController = TextEditingController();
  TextEditingController workoutNameController = TextEditingController();

  void _kameradanCek() async {
    var yeniResim = await imagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      if (yeniResim != null) {
        photo = File(yeniResim.path);
      }
    });
  }

  void _galeridenSec() async {
    var yeniResim = await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (yeniResim != null) {
        photo = File(yeniResim.path);
        debugPrint(yeniResim.path);
        debugPrint(photo!.path);
      }
    });
  }

  @override
  void initState() {
    sqlService = WorkoutService.workoutService;
    refreshTable();
    super.initState();
  }

  Future<void> refreshTable() async {
    setState(() => isLoading = true);
    listWorkout = await sqlService.readAll();
    setState(() => isLoading = false);
  }

  Future insert() async {
    final workoutModel = Workout(
        workoutStatus: true,
        workoutImage: await photo?.readAsBytes(),
        bodypartID: int.parse(bodyPartidController.text),
        workoutName: workoutNameController.text);
    await sqlService.insert(workoutModel);
    refreshTable();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await insert();
        },
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    color: Colors.amber),
                child: Column(
                  children: [
                    TextField(
                      controller: bodyPartidController,
                      decoration: const InputDecoration(
                          hintText: 'id', icon: Icon(Icons.add_alert_rounded)),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    TextField(
                      controller: workoutNameController,
                      decoration: const InputDecoration(
                          hintText: 'BodyPart Name',
                          icon: Icon(Icons.add_alert_rounded)),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          showModalBottomSheet(
                              backgroundColor: Theme.of(context).primaryColor,
                              context: context,
                              builder: (context) {
                                return ListView(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  children: [
                                    ListTile(
                                      leading: const Icon(
                                        Icons.camera,
                                        color: Colors.white,
                                      ),
                                      title: const Text('Kamera'),
                                      onTap: () {
                                        _kameradanCek();
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    ListTile(
                                      leading: const Icon(Icons.photo_album,
                                          color: Colors.white),
                                      title: const Text('Galeri'),
                                      onTap: () {
                                        _galeridenSec();
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              });
                        },
                        child: const Text('Foto Yükle'))
                  ],
                ),
              ),
              const SizedBox(
                height: 25.0,
              ),
              !isLoading
                  ? ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: listWorkout.length,
                      itemBuilder: (context, index) {
                        var currentValue = listWorkout[index];
                        return ListTile(
                          leading: CircleAvatar(
                            child: Text(currentValue!.id.toString()),
                          ),
                          tileColor: Colors.blue,
                          title: Text(currentValue.workoutName),
                        );
                      },
                    )
                  : const Center(
                      child: CircularProgressIndicator(
                        color: Colors.red,
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gym_raiser/service/workout_db_service.dart';
import 'package:image_picker/image_picker.dart';

class ImagePage extends StatefulWidget {
  const ImagePage({super.key});

  @override
  State<ImagePage> createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {
  File? photo;
  ImagePicker imagePicker = ImagePicker();
  late WorkoutService sqlService;
  @override
  void initState() {
    sqlService = WorkoutService.workoutService;
    super.initState();
  }

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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
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
            child: const Text('Foto Yükle')),
      ),
    );
  }
}

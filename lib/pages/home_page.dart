import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gym_raiser/core/app_contants.dart';
import 'package:gym_raiser/model/bodypart_model.dart';
import 'package:gym_raiser/pages/workout_page.dart';
import 'package:gym_raiser/service/bodypart_db_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late BodyPartService sqlService;
  List<BodyPart?> listBodyPart = [];
  bool isLoading = false;
  @override
  void initState() {
    sqlService = BodyPartService.bodyPartService;
    refreshTable();
    super.initState();
  }

  Future<void> refreshTable() async {
    setState(() => isLoading = true);
    listBodyPart = await sqlService.readAll();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: !isLoading
          ? ListView.builder(
              itemCount: listBodyPart.length,
              itemBuilder: (context, index) {
                var result = listBodyPart[index];
                return InkWell(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => WorkoutPage(
                      bodyPart: result,
                    ),
                  )),
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
                              Text(result!.bodyPartName,
                                  style: TextStyles.listileTitleTextStyle),
                              // Text('16 Egzersiz',
                              //     style: TextStyles.listileSubtitleTextStyle),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: SvgPicture.asset(
                            'assets/images/im_${result.bodyPartName}.svg',
                            height: 150,
                            width: 75,
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

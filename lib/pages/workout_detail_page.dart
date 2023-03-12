// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:gym_raiser/core/app_contants.dart';
import 'package:gym_raiser/model/set_model.dart';
import 'package:gym_raiser/model/workout_model.dart';
import 'package:gym_raiser/service/set_db_service.dart';

class WorkoutDetailPage extends StatefulWidget {
  final Workout workout;

  const WorkoutDetailPage({super.key, required this.workout});

  @override
  State<WorkoutDetailPage> createState() => _WorkoutDetailPageState();
}

class _WorkoutDetailPageState extends State<WorkoutDetailPage> {
  late Workout workout;
  late SetService sqlService;
  List<SingleSet> listSingleSet = [];
  bool isSetsReady = false;
  bool isSetDrop = false;
  int setNumber = 1;
  late TextEditingController setNumController;
  List<TextEditingController> repControllerList = [];
  List<TextEditingController> kgControllerList = [];
  List<TextEditingController> rateControllerList = [];

  @override
  void initState() {
    workout = widget.workout;
    sqlService = SetService.setService;
    generateControllerList(setNumber);

    setNumController = TextEditingController();
    getAllSetByWorkoutID(workout.id!);
    super.initState();
  }

  void generateControllerList(int setNumber) {
    repControllerList.clear();
    kgControllerList.clear();
    rateControllerList.clear();
    repControllerList = List<TextEditingController>.generate(
        setNumber, (index) => TextEditingController());
    kgControllerList = List<TextEditingController>.generate(
        setNumber, (index) => TextEditingController());
    rateControllerList = List<TextEditingController>.generate(
        setNumber, (index) => TextEditingController());
  }

  Future getAllSetByWorkoutID(int workoutID) async {
    setState(() => isSetsReady = false);
    listSingleSet = await sqlService.readbyWorkoutID(workoutID) ?? [];
    setState(() => isSetsReady = true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(workout.workoutName),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: SafeArea(
          child: Column(
            children: [
              //
              Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    color: Colors.white),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              const Text('Drop Set'),
                              SizedBox.square(
                                dimension: 24,
                                child: Checkbox(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(2.0),
                                  ),
                                  side: MaterialStateBorderSide.resolveWith(
                                    (states) => BorderSide(
                                      width: 1.2,
                                      color: ThemeColor.mintBlue,
                                    ),
                                  ),
                                  fillColor:
                                      MaterialStateProperty.all(Colors.white),
                                  checkColor: ThemeColor.mintBlue,
                                  value: isSetDrop,
                                  onChanged: (value) {
                                    isSetDrop = value!;
                                    if (!isSetDrop) {
                                      setNumber = 1;
                                    }
                                    debugPrint(isSetDrop.toString());
                                    setState(() {});
                                  },
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            width: 18.0,
                          ),
                          DropdownButton<int>(
                            items: const [
                              DropdownMenuItem<int>(
                                value: 1,
                                child: Text('1'),
                              ),
                              DropdownMenuItem<int>(
                                value: 2,
                                child: Text('2'),
                              ),
                              DropdownMenuItem<int>(
                                value: 3,
                                child: Text('3'),
                              ),
                              DropdownMenuItem<int>(
                                value: 4,
                                child: Text('4'),
                              ),
                            ],
                            onChanged: isSetDrop
                                ? (value) {
                                    setNumber = value!;
                                    generateControllerList(setNumber);
                                    setState(() {});
                                  }
                                : null,
                            value: setNumber,
                          )
                        ],
                      ),
                    ),
                    Flex(
                      direction: Axis.horizontal,
                      children: [
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            controller: setNumController,
                            maxLength: 2,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              counterText: "",
                              hintText: 'Set',
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: setNumber,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4.0),
                                child: Flex(
                                  direction: Axis.horizontal,
                                  children: [
                                    const Spacer(),
                                    Expanded(
                                        flex: 5,
                                        child: TextFormField(
                                          controller: repControllerList[index],
                                          maxLength: 2,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            counterText: "",
                                            hintText: 'Rep',
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 12.0),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                            ),
                                          ),
                                        )),
                                    const Spacer(),
                                    Expanded(
                                        flex: 5,
                                        child: TextFormField(
                                          controller: kgControllerList[index],
                                          keyboardType: TextInputType.number,
                                          maxLength: 3,
                                          decoration: InputDecoration(
                                            counterText: "",
                                            hintText: 'Kg',
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 12.0),
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        12.0)),
                                          ),
                                        )),
                                    const Spacer(),
                                    Expanded(
                                        flex: 5,
                                        child: TextFormField(
                                          controller: rateControllerList[index],
                                          keyboardType: TextInputType.number,
                                          maxLength: 2,
                                          decoration: InputDecoration(
                                            counterText: "",
                                            hintText: 'Rate',
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 12.0),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                            ),
                                          ),
                                        )),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                            color: ThemeColor.blueGray,
                            onPressed: () async {
                              List<int> listRep = repControllerList
                                  .map((controller) =>
                                      int.parse(controller.text))
                                  .toList();
                              List<int> listRate = rateControllerList
                                  .map((controller) =>
                                      int.parse(controller.text))
                                  .toList();
                              List<double> listKg = kgControllerList
                                  .map((controller) =>
                                      double.parse(controller.text))
                                  .toList();

                              SingleSet singleSet = SingleSet(
                                  bodypartID: workout.bodypartID,
                                  workoutID: workout.id!,
                                  repeatNum: listRep,
                                  weightList: listKg,
                                  intensityRate: listRate,
                                  setNum: int.parse(setNumController.text),
                                  date: DateTime.now(),
                                  status: true);

                              await sqlService.insert(singleSet);
                              clearControllers();
                              await getAllSetByWorkoutID(workout.id!);
                              setNumber = 1;
                              setState(() {});
                            },
                            icon: Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        width: 2, color: ThemeColor.blueGray)),
                                child: const Center(
                                  child: Icon(
                                    Icons.add,
                                  ),
                                )))
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: listSingleSet.length,
                itemBuilder: (context, index) {
                  var singleSet = listSingleSet[index];
                  return Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        color: Colors.white),
                    child: Flex(
                      direction: Axis.horizontal,
                      children: [
                        Expanded(
                            flex: 3, child: Text(singleSet.setNum.toString())),
                        const Spacer(),
                        Expanded(
                          flex: 5,
                          child: Text(singleSet.repeatNum.toString()),
                        ),
                        const Spacer(),
                        Expanded(
                            flex: 5,
                            child: Text(singleSet.weightList.toString())),
                        const Spacer(),
                        Expanded(
                            flex: 5,
                            child: Text(singleSet.intensityRate.toString())),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void clearControllers() {
    for (var index = 0; index < repControllerList.length; index++) {
      rateControllerList[index].clear();
      repControllerList[index].clear();
      kgControllerList[index].clear();
    }
    setNumController.clear();
  }
}

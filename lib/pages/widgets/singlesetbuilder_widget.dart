import 'package:flutter/material.dart';
import 'package:gym_raiser/model/set_model.dart';

class SingleSetBuilder extends StatelessWidget {
  const SingleSetBuilder({
    super.key,
    required this.singleSet,
  });

  final SingleSet singleSet;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: singleSet.repeatNum.length,
      itemBuilder: (BuildContext context, int index) {
        return Flex(
          direction: Axis.horizontal,
          children: [
            Expanded(
              child: Center(
                child: Text(singleSet.repeatNum[index].toString()),
              ),
            ),
            Expanded(
                child: Center(
              child: Text(singleSet.weightList[index].toString()),
            )),
            Expanded(
                child: Center(
              child: Text(singleSet.intensityRate[index].toString()),
            )),
          ],
        );
      },
    );
  }
}

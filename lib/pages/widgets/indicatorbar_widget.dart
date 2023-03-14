import 'package:flutter/material.dart';
import 'package:gym_raiser/core/app_contants.dart';

class IndicatorBarWidget extends StatelessWidget {
  const IndicatorBarWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.horizontal,
      children: [
        Expanded(
          flex: 1,
          child: Text('Set', style: TextStyles.bannerTextStyle),
        ),
        Expanded(
          flex: 8,
          child: Flex(direction: Axis.horizontal, children: [
            Expanded(
              child: Center(
                  child: Text(
                'Tekrar',
                style: TextStyles.bannerTextStyle,
              )),
            ),
            Expanded(
              child: Center(
                  child: Text('Ağırlık', style: TextStyles.bannerTextStyle)),
            ),
            Expanded(
              child: Center(
                  child: Text('Rate', style: TextStyles.bannerTextStyle)),
            ),
          ]),
        ),
        const Expanded(
          flex: 1,
          child: SizedBox(),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../responsive/Color.dart';

class LoadingIndicatorW extends StatelessWidget {
  const LoadingIndicatorW({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LoadingIndicator(
      indicatorType: Indicator.ballClipRotate,
      colors: [
        ColorSelect.primaryColorVaco,
        const Color.fromARGB(255, 155, 155, 155)
      ],
    );
  }
}

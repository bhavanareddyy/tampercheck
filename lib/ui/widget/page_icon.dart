 
import 'dart:math';

import 'package:flutter/material.dart';

class PageIcon extends StatelessWidget {
  final IconData icon;
  final double ratio;

  const PageIcon({
    Key? key,
    required this.icon,
    this.ratio = 2.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenSize = MediaQuery.of(context).size;
        final sizeList = [
          screenSize.width,
          screenSize.height,
          constraints.maxWidth,
          constraints.maxHeight,
        ];
        final minSize = sizeList.fold(sizeList[0], min);
        final size = minSize / ratio;
        return SizedBox(
          width: size,
          height: size,
          child: FittedBox(
            child: Icon(
              icon,
              color: Theme.of(context).iconTheme.color!.withOpacity(0.1),
            ),
          ),
        );
      },
    );
  }
}

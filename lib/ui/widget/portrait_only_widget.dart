 
import 'package:flutter/material.dart';

enum RotateDirection {
  clockwise,
  counterclockwise,
}

class PortraitOnlyWidget extends StatelessWidget {
  final Widget child;
  final RotateDirection direction;

  const PortraitOnlyWidget({
    Key? key,
    required this.child,
    this.direction = RotateDirection.counterclockwise,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, _) {
        // Get global (device) orientation
        final orientation = MediaQuery.of(context).orientation;
        return RotatedBox(
          quarterTurns:
              orientation == Orientation.portrait ? 0 : _getTurnsDirection(),
          child: child,
        );
      },
    );
  }

  int _getTurnsDirection() {
    switch (direction) {
      case RotateDirection.clockwise:
        return 1;
      case RotateDirection.counterclockwise:
        return -1;
    }
  }
}

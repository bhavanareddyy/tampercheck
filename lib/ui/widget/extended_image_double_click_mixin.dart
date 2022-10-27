
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

mixin ExtendedImageDoubleClickMixin<T extends StatefulWidget> on State<T>
    implements TickerProvider {
  late AnimationController _doubleClickAnimationController;
  late VoidCallback _doubleClickAnimationListener;
  Animation<double>? _doubleClickAnimation;

  @override
  void initState() {
    super.initState();

    _doubleClickAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _doubleClickAnimationController.dispose();

    super.dispose();
  }

  void onDoubleTap({
    required double scaleUp,
    required double scaleDown,
    required ExtendedImageGestureState state,
  }) {
    final Offset? pointerDownPosition = state.pointerDownPosition;
    final double? begin = state.gestureDetails!.totalScale;
    double end;

    _doubleClickAnimation?.removeListener(_doubleClickAnimationListener);
    _doubleClickAnimationController.stop();
    _doubleClickAnimationController.reset();

    if (begin == scaleDown) {
      end = scaleUp;
    } else {
      end = scaleDown;
    }

    _doubleClickAnimationListener = () {
      state.handleDoubleTap(
        scale: _doubleClickAnimation!.value,
        doubleTapPosition: pointerDownPosition,
      );
    };
    _doubleClickAnimation = _doubleClickAnimationController.drive(
      Tween<double>(
        begin: begin,
        end: end,
      ),
    );

    _doubleClickAnimation!.addListener(_doubleClickAnimationListener);
    _doubleClickAnimationController.forward();
  }
}

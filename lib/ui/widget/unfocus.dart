 
import 'package:flutter/material.dart';

class Unfocus extends StatelessWidget {
  final Widget? child;

  const Unfocus({Key? key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: child,
    );
  }
}

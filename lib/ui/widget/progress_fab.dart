 
import 'package:flutter/material.dart';

class ProgressFab extends StatelessWidget {
  const ProgressFab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const size = kFloatingActionButtonMargin * 1.5;
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.26),
      ),
    );
  }
}

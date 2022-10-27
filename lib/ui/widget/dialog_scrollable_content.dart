 
import 'package:flutter/material.dart';

class DialogScrollableContent extends StatelessWidget {
  final Widget child;
  final double? borderPadding;

  const DialogScrollableContent({
    Key? key,
    required this.child,
    this.borderPadding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: borderPadding == null
          ? null
          : EdgeInsets.only(bottom: borderPadding!),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
          ),
        ),
      ),
      child: Scrollbar(
        child: SingleChildScrollView(child: child),
      ),
    );
  }
}

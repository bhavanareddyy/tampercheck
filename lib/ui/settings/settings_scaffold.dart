
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class SettingsScaffold extends StatelessWidget {
  final AppBar appBar;
  final Widget body;

  const SettingsScaffold({
    Key? key,
    required this.appBar,
    required this.body,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: appBar.preferredSize,
        child: ScreenTypeLayout(
          mobile: appBar,
          tablet: const SizedBox.shrink(),
        ),
      ),
      body: body,
    );
  }
}

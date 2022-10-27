 
import 'package:flutter/material.dart';
import 'package:swipe/swipe.dart';

import 'auto_hide_app_bar_wrapper.dart';

class SlideAppBar extends StatefulWidget {
  final List<Widget>? actions;
  final bool showFirstTime;
  final Widget? leading;

  const SlideAppBar({
    Key? key,
    this.actions,
    this.showFirstTime = true,
    this.leading,
  }) : super(key: key);

  @override
  State<SlideAppBar> createState() => _SlideAppBarState();
}

class _SlideAppBarState extends State<SlideAppBar> {
  final _appBarKey = GlobalKey<AutoHideAppBarWrapperState>();

  @override
  Widget build(BuildContext context) {
    final color =
        Theme.of(context).appBarTheme.backgroundColor?.withOpacity(0.54);
    final appBar = AppBar(
      backgroundColor: color,
      actions: widget.actions,
      leading: widget.leading,
    );
    return Swipe(
      behavior: HitTestBehavior.opaque,
      verticalMaxWidthThreshold: 100,
      verticalMinVelocity: 50,
      onSwipeDown: () => _appBarKey.currentState?.reset(),
      child: Container(
        constraints: BoxConstraints(
          minHeight: appBar.preferredSize.height,
        ),
        child: AutoHideAppBarWrapper(
          key: _appBarKey,
          transformHitTests: false,
          showFirstTime: widget.showFirstTime,
          child: appBar,
        ),
      ),
    );
  }
}

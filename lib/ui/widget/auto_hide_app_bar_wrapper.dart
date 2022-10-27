
import 'package:async/async.dart';
import 'package:flutter/material.dart';

class AutoHideAppBarWrapper extends StatefulWidget
    implements PreferredSizeWidget {
  final PreferredSizeWidget child;
  final bool transformHitTests;
  final bool showFirstTime;

  const AutoHideAppBarWrapper({
    Key? key,
    required this.child,
    this.transformHitTests = true,
    this.showFirstTime = true,
  }) : super(key: key);

  @override
  Size get preferredSize => child.preferredSize;

  @override
  State<AutoHideAppBarWrapper> createState() => AutoHideAppBarWrapperState();
}

class AutoHideAppBarWrapperState extends State<AutoHideAppBarWrapper>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    duration: const Duration(milliseconds: 200),
    vsync: this,
  );
  late final _animation = Tween<Offset>(
    begin: const Offset(0, -1),
    end: Offset.zero,
  ).animate(
    CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    ),
  );
  RestartableTimer? _timer;
  bool _visible = false;
  bool _offstage = true;

  @override
  void initState() {
    super.initState();

    _controller.addListener(_controllerListener);
    if (widget.showFirstTime) {
      reset();
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_controllerListener);
    _controller.dispose();
    super.dispose();
  }

  void _controllerListener() {
    if (_controller.status == AnimationStatus.forward) {
      setState(() => _offstage = false);
    } else if (_controller.isDismissed) {
      setState(() => _offstage = true);
    }
  }

  void reset() {
    if (!mounted || _visible || _timer?.isActive == true) {
      return;
    }
    _visible = true;
    _slide();
    if (_timer == null) {
      _timer = RestartableTimer(const Duration(milliseconds: 2500), _switch);
    } else {
      _timer?.reset();
    }
  }

  void _switch() {
    _visible = !_visible;
    _slide();
  }

  void _slide() {
    if (!mounted) {
      return;
    }
    _visible ? _controller.forward() : _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _animation,
      transformHitTests: widget.transformHitTests,
      child: Offstage(
        offstage: _offstage,
        child: widget.child,
      ),
    );
  }
}

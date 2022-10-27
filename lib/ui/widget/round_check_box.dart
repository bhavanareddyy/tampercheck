
import 'package:flutter/material.dart';

class RoundCheckBox extends StatefulWidget {
  static const animationDuration = Duration(milliseconds: 150);

  final bool isSelected;
  final VoidCallback? onSelected;
  final bool animate;
  final BorderSide? side;

  const RoundCheckBox({
    Key? key,
    this.isSelected = false,
    this.onSelected,
    this.animate = true,
    this.side,
  }) : super(key: key);

  @override
  _RoundCheckBoxState createState() => _RoundCheckBoxState();
}

class _RoundCheckBoxState extends State<RoundCheckBox>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    duration: RoundCheckBox.animationDuration,
    vsync: this,
  )..addStatusListener(_statusListener);

  late final _pressAnimation = Tween(
    begin: 1.2,
    end: 0.6,
  ).animate(
    CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInBack,
    ),
  );

  void _statusListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _controller.reverse();
    }
  }

  @override
  void initState() {
    super.initState();

    _setControllerDuration();
  }

  @override
  void dispose() {
    _controller.removeStatusListener(_statusListener);
    _controller.dispose();

    super.dispose();
  }

  @override
  void didUpdateWidget(covariant RoundCheckBox oldWidget) {
    if (oldWidget.animate != widget.animate) {
      _setControllerDuration();
    }
    if (oldWidget.isSelected != widget.isSelected) {
      _controller.forward();
    }

    super.didUpdateWidget(oldWidget);
  }

  void _setControllerDuration() {
    _controller.duration =
        widget.animate ? RoundCheckBox.animationDuration : Duration.zero;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pressAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pressAnimation.value,
          child: Checkbox(
            value: widget.isSelected,
            fillColor: MaterialStateProperty.all(
              Theme.of(context).colorScheme.secondary,
            ),
            checkColor: Theme.of(context).colorScheme.onSecondary,
            side: widget.side,
            onChanged: widget.onSelected == null
                ? null
                : (value) {
                    _controller.forward();
                    widget.onSelected?.call();
                  },
            shape: const CircleBorder(),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        );
      },
    );
  }
}

 
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../locale.dart';
import 'ref_image_options_cubit.dart';

class OpacityBar extends StatefulWidget {
  const OpacityBar({Key? key}) : super(key: key);

  @override
  State<OpacityBar> createState() => _OpacityBarState();
}

class _OpacityBarState extends State<OpacityBar> {
  late final RestartableTimer _closeTimer;
  bool _readyToClose = true;

  @override
  void initState() {
    super.initState();

    _closeTimer = RestartableTimer(
      const Duration(seconds: 3),
      () {
        if (mounted && _readyToClose) {
          Navigator.of(context).maybePop();
        }
      },
    );
  }

  @override
  void dispose() {
    _closeTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: BlocBuilder<RefImageOptionsCubit, RefImageOptionsState>(
              buildWhen: (prev, next) =>
                  next is RefImageOptionsStateOpacityChanged,
              builder: (context, state) {
                final opacity = state.options.opacity;
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Padding(
                        padding:
                            const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
                        child: Text(
                          S.of(context).imageOverlayOpacity,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ),
                    ),
                    Slider(
                      value: opacity,
                      divisions: 100,
                      label: _formatLabel(opacity),
                      semanticFormatterCallback: _formatLabel,
                      onChangeStart: (value) {
                        _readyToClose = false;
                      },
                      onChanged: (value) {
                        context
                            .read<RefImageOptionsCubit>()
                            .setOpacity(value, saveInSettings: false);
                      },
                      onChangeEnd: (value) {
                        context.read<RefImageOptionsCubit>().setOpacity(value);
                        _readyToClose = true;
                        _closeTimer.reset();
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
      onClosing: () {
        _readyToClose = true;
        _closeTimer.cancel();
      },
    );
  }

  String _formatLabel(double opacity) => '${(opacity * 100).toInt()} %';
}

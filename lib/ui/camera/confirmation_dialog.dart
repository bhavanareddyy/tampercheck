
import 'package:blink_comparison/ui/widget/widget.dart';
import 'package:blink_comparison/ui/xfile_provider.dart';
import 'package:cross_file/cross_file.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../locale.dart';

class ConfirmationDialog extends StatefulWidget {
  final XFile photoFile;
  final VoidCallback? onRetry;
  final VoidCallback? onAccept;

  const ConfirmationDialog({
    Key? key,
    required this.photoFile,
    this.onRetry,
    this.onAccept,
  }) : super(key: key);

  @override
  State<ConfirmationDialog> createState() => _ConfirmationDialogState();
}

class _ConfirmationDialogState extends State<ConfirmationDialog>
    with TickerProviderStateMixin, ExtendedImageDoubleClickMixin {
  static const _minScale = 1.0;
  static const _maxScale = 5.0;
  static const _doubleClickScale = (_maxScale - _minScale) / 2;

  late final _controller = AnimationController(
    duration: const Duration(milliseconds: 500),
    vsync: this,
  );

  late final _fadeImageAnimation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeIn,
  );

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: ExtendedImage(
            image: XFileImage(widget.photoFile),
            enableLoadState: true,
            opacity: _fadeImageAnimation,
            mode: ExtendedImageMode.gesture,
            fit: BoxFit.contain,
            initGestureConfigHandler: (state) {
              return GestureConfig(
                minScale: _minScale,
                maxScale: _maxScale,
              );
            },
            onDoubleTap: (state) => onDoubleTap(
              scaleDown: _minScale,
              scaleUp: _doubleClickScale,
              state: state,
            ),
            loadStateChanged: (state) {
              switch (state.extendedImageLoadState) {
                case LoadState.loading:
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                case LoadState.completed:
                  _controller.forward();
                  break;
                case LoadState.failed:
                  return const _OpenImageError();
              }
              return null;
            },
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: _ButtonBar(
              onRetry: widget.onRetry,
              onAccept: widget.onAccept,
            ),
          ),
        ),
      ],
    );
  }
}

class _ButtonBar extends StatelessWidget {
  final VoidCallback? onRetry;
  final VoidCallback? onAccept;

  const _ButtonBar({
    Key? key,
    this.onRetry,
    this.onAccept,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (context, sizingInfo) {
      final orientation = MediaQuery.of(context).orientation;
      return SizedBox(
        width: _getAdaptiveWidth(
          sizingInfo: sizingInfo,
          orientation: orientation,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: Text(S.of(context).retry),
              style: _buildButtonTheme(context),
            ),
            OutlinedButton.icon(
              onPressed: onAccept,
              icon: const Icon(Icons.done),
              label: Text(S.of(context).accept),
              style: _buildButtonTheme(context),
            ),
          ],
        ),
      );
    });
  }

  ButtonStyle _buildButtonTheme(BuildContext context) {
    return OutlinedButton.styleFrom(
      backgroundColor: Colors.black38,
      primary: Colors.white,
    );
  }

  double? _getAdaptiveWidth({
    required SizingInformation sizingInfo,
    required Orientation orientation,
  }) {
    if (sizingInfo.isMobile) {
      if (orientation == Orientation.landscape) {
        return sizingInfo.screenSize.width / 2;
      } else {
        return null;
      }
    } else {
      return sizingInfo.screenSize.width / 2.5;
    }
  }
}

class _OpenImageError extends StatelessWidget {
  const _OpenImageError({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              color: theme.errorColor,
              size: 64,
            ),
            const SizedBox(height: 8.0),
            Text(
              S.of(context).openCameraError,
              style: theme.textTheme.headline6!.copyWith(
                color: theme.errorColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

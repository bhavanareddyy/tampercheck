 
import 'package:auto_route/auto_route.dart';
import 'package:blink_comparison/ui/cubit/showcase_cubit.dart';
import 'package:blink_comparison/ui/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../injector.dart';
import '../../locale.dart';
import '../theme.dart';
import 'blink_comparison_cubit.dart';
import 'comparison_settings_cubit.dart';

final _refImageBorderShowcaseKey = GlobalKey();
final _blinkComparisonShowcaseKey = GlobalKey();

class BlinkComparisonPage extends StatefulWidget with AutoRouteWrapper {
  final ImageProvider refImage;
  final ImageProvider takenPhoto;
  final double aspectRatio;

  const BlinkComparisonPage({
    Key? key,
    required this.refImage,
    required this.takenPhoto,
    required this.aspectRatio,
  }) : super(key: key);

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<BlinkComparisonCubit>(
          create: (context) => getIt<BlinkComparisonCubit>(),
        ),
        BlocProvider<ComparisonSettingsCubit>(
          create: (context) => getIt<ComparisonSettingsCubit>(),
        ),
        BlocProvider<ShowcaseCubit>(
          create: (context) => getIt<ShowcaseCubit>(),
        ),
      ],
      child: this,
    );
  }

  @override
  State<BlinkComparisonPage> createState() => _BlinkComparisonPageState();
}

class _BlinkComparisonPageState extends State<BlinkComparisonPage> {
  @override
  void didChangeDependencies() {
    Future.wait([
      precacheImage(widget.takenPhoto, context),
      precacheImage(widget.refImage, context),
    ]).then(
      (_) {
        final cubit = context.read<BlinkComparisonCubit>();
        cubit.state.maybeWhen(
          initial: () => cubit.switchImage(),
          orElse: () {},
        );
      },
    );

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ComparisonSettingsCubit, ComparisonSettingsState>(
      builder: (context, state) {
        final refImageWidget = _Image(
          image: widget.refImage,
          aspectRatio: widget.aspectRatio,
          frameColor: Color(state.refImageBorderColor),
        );
        final takenPhotoWidget = _Image(
          image: widget.takenPhoto,
          aspectRatio: widget.aspectRatio,
        );
        return ShowCaseWidget(
          builder: Builder(builder: (context) {
            return _Body(
              refImageWidget: refImageWidget,
              takenPhotoWidget: takenPhotoWidget,
            );
          }),
          onComplete: (i, key) {
            final cubit = context.read<ShowcaseCubit>();
            if (key == _refImageBorderShowcaseKey) {
              cubit.completed(const ShowcaseType.refImageBorder());
            } else if (key == _blinkComparisonShowcaseKey) {
              cubit.completed(const ShowcaseType.blinkComparison());
            }
          },
        );
      },
    );
  }
}

class _Body extends StatefulWidget {
  final Widget refImageWidget;
  final Widget takenPhotoWidget;

  const _Body({
    Key? key,
    required this.refImageWidget,
    required this.takenPhotoWidget,
  }) : super(key: key);

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 400), _startShowcase);
    });
  }

  void _startShowcase() {
    final completed = context.read<ShowcaseCubit>().state.completed;
    final showcases = [
      if (!completed.contains(const ShowcaseType.blinkComparison()))
        _blinkComparisonShowcaseKey,
      if (!completed.contains(const ShowcaseType.refImageBorder()))
        _refImageBorderShowcaseKey,
    ];
    if (showcases.isNotEmpty) {
      ShowCaseWidget.of(context)?.startShowCase(showcases);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.blackTheme(),
      child: Scaffold(
        body: Stack(
          children: [
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => _onSwitchImage(context),
              child: Center(
                child: BlocBuilder<BlinkComparisonCubit, BlinkComparisonState>(
                  builder: (context, state) {
                    return state.when(
                      initial: () => const CircularProgressIndicator(),
                      showRefImage: () => widget.refImageWidget,
                      showTakenPhoto: () => widget.takenPhotoWidget,
                    );
                  },
                ),
              ),
            ),
            const Positioned(
              top: 0.0,
              left: 0.0,
              right: 0.0,
              child: SlideAppBar(
                showFirstTime: false,
              ),
            ),
            Center(
              child: CustomShowcase(
                showcaseKey: _blinkComparisonShowcaseKey,
                description: S.of(context).blinkComparisonCaseTooltip,
                shapeBorder: const CircleBorder(),
                child: const SizedBox(width: 64.0, height: 64.0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onSwitchImage(BuildContext context) {
    final cubit = context.read<BlinkComparisonCubit>();
    cubit.state.maybeWhen(
      initial: () => null,
      orElse: () => cubit.switchImage(),
    );
  }
}

class _Image extends StatelessWidget {
  final ImageProvider image;
  final double aspectRatio;
  final Color? frameColor;

  const _Image({
    Key? key,
    required this.image,
    required this.aspectRatio,
    this.frameColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: frameColor == null
            ? null
            : Border.all(color: frameColor!, width: 2.0),
      ),
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: Stack(
          children: [
            Image(
              image: image,
              height: double.infinity,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            if (frameColor != null)
              Align(
                alignment: Alignment.topCenter,
                child: CustomShowcase(
                  showcaseKey: _refImageBorderShowcaseKey,
                  description: S.of(context).referenceImageBorderCaseTooltip,
                  child: const SizedBox.shrink(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

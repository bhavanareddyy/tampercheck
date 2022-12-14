 
import 'package:auto_route/auto_route.dart';
import 'package:blink_comparison/ui/camera/camera.dart';
import 'package:blink_comparison/ui/cubit/error_report_cubit.dart';
import 'package:blink_comparison/ui/cubit/showcase_cubit.dart';
import 'package:blink_comparison/ui/theme.dart';
import 'package:blink_comparison/ui/widget/widget.dart';
import 'package:blink_comparison/ui/xfile_provider.dart';
import 'package:cross_file/cross_file.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../injector.dart';
import '../../locale.dart';
import '../app_router.dart';
import 'opacity_bar.dart';
import 'ref_image_cubit.dart';
import 'ref_image_options_cubit.dart';

final _opacityShowcaseKey = GlobalKey();

class RefImagePreviewPage extends StatelessWidget implements AutoRouteWrapper {
  final String imageId;

  const RefImagePreviewPage({
    Key? key,
    required this.imageId,
  }) : super(key: key);

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<RefImageCubit>(
          create: (context) => getIt<RefImageCubit>(),
        ),
        BlocProvider<CameraProviderCubit>(
          create: (context) => getIt<CameraProviderCubit>(),
        ),
        BlocProvider<ErrorReportCubit>(
          create: (context) => getIt<ErrorReportCubit>(),
        ),
        BlocProvider<RefImageOptionsCubit>(
          create: (context) => getIt<RefImageOptionsCubit>(),
        ),
        BlocProvider<ShowcaseCubit>(
          create: (context) => getIt<ShowcaseCubit>(),
        ),
      ],
      child: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.blackTheme(),
      child: Scaffold(
        body: ShowCaseWidget(
          builder: Builder(
            builder: (context) {
              return _Body(imageId: imageId);
            },
          ),
          onComplete: (i, key) {
            final cubit = context.read<ShowcaseCubit>();
            if (key == _opacityShowcaseKey) {
              cubit.completed(const ShowcaseType.opacity());
            }
          },
        ),
        endDrawerEnableOpenDragGesture: true,
      ),
    );
  }
}

class _Body extends StatefulWidget {
  final String imageId;

  const _Body({Key? key, required this.imageId}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  ExtendedImageProvider? _refImage;
  Size? _refImageSize;

  @override
  void initState() {
    super.initState();

    context.read<RefImageCubit>().load(widget.imageId);
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 400), _startShowcase);
    });
  }

  void _startShowcase() {
    final completed = context.read<ShowcaseCubit>().state.completed;
    final showcases = [
      if (!completed.contains(const ShowcaseType.opacity()))
        _opacityShowcaseKey,
    ];
    if (showcases.isNotEmpty) {
      ShowCaseWidget.of(context)?.startShowCase(showcases);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BlocBuilder<RefImageCubit, RefImageState>(
          builder: (context, state) {
            return state.when(
              initial: () => const Center(
                child: CircularProgressIndicator(),
              ),
              loading: () => const _DecodeImageProgress(),
              loaded: (image) {
                _refImage = ExtendedMemoryImageProvider(image.bytes);
                return CameraView(
                  overlayChild: _ImageView(
                    image: _refImage!,
                    onImageLoaded: (info) {
                      _refImageSize = getImageSize(info);
                    },
                  ),
                  showConfirmationDialog: false,
                  onTakePhoto: _onTakePhoto,
                );
              },
              loadFailed: (error) => _LoadRefImageError(
                error: error,
              ),
            );
          },
        ),
        const Positioned(
          top: 0.0,
          left: 0.0,
          right: 0.0,
          child: SlideAppBar(
            leading: BackButton(),
            actions: [
              _OpenOpacityBarButton(),
            ],
          ),
        ),
      ],
    );
  }

  void _onTakePhoto(XFile file) {
    if (_refImage == null) {
      return;
    }
    context.replaceRoute(
      BlinkComparisonRoute(
        refImage: _refImage!,
        takenPhoto: XFileImage(file),
        aspectRatio: _refImageSize?.aspectRatio ?? 1,
      ),
    );
  }

  Size? getImageSize(ImageInfo? info) {
    final image = info?.image;
    return image == null
        ? null
        : Size(
            image.width.toDouble(),
            image.height.toDouble(),
          );
  }
}

class _OpenOpacityBarButton extends StatelessWidget {
  const _OpenOpacityBarButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RefImageOptionsCubit>();
    return IconButton(
      icon: const Icon(Icons.opacity_outlined),
      tooltip: S.of(context).imageOverlayOpacity,
      onPressed: () {
        showModalBottomSheet(
          context: context,
          barrierColor: Colors.transparent,
          constraints: const BoxConstraints(maxWidth: 480),
          builder: (context) {
            return BlocProvider.value(
              value: cubit,
              child: const OpacityBar(),
            );
          },
        );
      },
    );
  }
}

class _DecodeImageProgress extends StatelessWidget {
  const _DecodeImageProgress({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16.0),
            Text(
              S.of(context).loadingReferenceImage,
              style: Theme.of(context).textTheme.subtitle1,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ImageView extends StatefulWidget {
  final ExtendedImageProvider image;
  final ValueChanged<ImageInfo?>? onImageLoaded;

  const _ImageView({
    Key? key,
    required this.image,
    this.onImageLoaded,
  }) : super(key: key);

  @override
  State<_ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<_ImageView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 500),
    vsync: this,
  );
  late final Animation<double> _fadeImageAnimation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeIn,
  );
  late final _backgroundColorAnimation = ColorTween(
    begin: Theme.of(context).backgroundColor,
    end: Colors.transparent,
  ).animate(
    CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ),
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
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Container(
              width: double.infinity,
              height: double.infinity,
              color: _backgroundColorAnimation.value,
            );
          },
        ),
        Positioned.fill(
          child: BlocBuilder<RefImageOptionsCubit, RefImageOptionsState>(
            buildWhen: (prev, next) =>
                next is RefImageOptionsStateOpacityChanged,
            builder: (context, state) {
              return ExtendedImage(
                image: widget.image,
                enableLoadState: true,
                opacity: _fadeImageAnimation,
                color: Colors.black.withOpacity(state.options.opacity),
                colorBlendMode: BlendMode.dstATop,
                fit: BoxFit.contain,
                beforePaintImage: (canvas, imageRect, image, paint) {
                  _drawOverlayFrame(canvas, imageRect);
                  return false;
                },
                loadStateChanged: (state) {
                  switch (state.extendedImageLoadState) {
                    case LoadState.loading:
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    case LoadState.completed:
                      _controller.forward();
                      widget.onImageLoaded?.call(state.extendedImageInfo);
                      break;
                    case LoadState.failed:
                      return const _LoadRefImageError();
                  }
                  return null;
                },
              );
            },
          ),
        ),
        Center(
          child: CustomShowcase(
            showcaseKey: _opacityShowcaseKey,
            description: S.of(context).imageOverlayOpacityCaseTooltip,
            child: const SizedBox.shrink(),
          ),
        ),
      ],
    );
  }

  void _drawOverlayFrame(Canvas canvas, Rect imageRect) {
    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        Path()..addRect(Rect.largest),
        Path()
          ..addRect(imageRect)
          ..close(),
      ),
      Paint()..color = Colors.black45,
    );
  }
}

class _LoadRefImageError extends StatelessWidget {
  final LoadRefImageError? error;

  const _LoadRefImageError({
    Key? key,
    this.error,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late String errorMsg;
    _ErrorReportButton? reportButton;
    if (error == null) {
      errorMsg = S.of(context).loadReferenceImageFailed;
    } else {
      error!.when(
        notFound: () {
          errorMsg = S.of(context).referenceImageNotFound;
        },
        database: (e, stackTrace) {
          errorMsg = S.of(context).loadReferenceImageFailed;
          if (e != null) {
            reportButton = _ErrorReportButton(
              error: e,
              stackTrace: stackTrace,
              reportMsg: 'Unable to load reference image',
            );
          }
        },
        fs: (e) => e.when(
          io: (e, stackTrace) {
            errorMsg = S.of(context).loadReferenceImageFailedIO;
            if (e != null) {
              reportButton = _ErrorReportButton(
                error: e,
                stackTrace: stackTrace,
                reportMsg: 'Unable to load reference image: I/O error',
              );
            }
          },
        ),
        noSecureKey: () {
          errorMsg = S.of(context).decryptReferenceImageNoEncryptKey;
        },
        decrypt: (e) => e.when(
          (e, stackTrace) {
            errorMsg = S.of(context).decryptReferenceImageFailed;
            if (e != null) {
              reportButton = _ErrorReportButton(
                error: e,
                stackTrace: stackTrace,
                reportMsg: 'Unable to decrypt reference image',
              );
            }
          },
          invalidKey: () {
            errorMsg = S.of(context).decryptReferenceImageInvalidKey;
          },
        ),
      );
    }
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
              errorMsg,
              style: theme.textTheme.headline6!.copyWith(
                color: theme.errorColor,
              ),
              textAlign: TextAlign.center,
            ),
            if (reportButton != null) ...[
              const SizedBox(
                height: 16.0,
              ),
              reportButton!,
            ],
          ],
        ),
      ),
    );
  }
}

class _ErrorReportButton extends StatelessWidget {
  final Object error;
  final StackTrace? stackTrace;
  final String? reportMsg;

  const _ErrorReportButton({
    Key? key,
    required this.error,
    this.stackTrace,
    this.reportMsg,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        context.read<ErrorReportCubit>().sendReport(
              error: error,
              stackTrace: stackTrace,
              message: reportMsg,
            );
      },
      child: Text(S.of(context).crashDialogReport),
    );
  }
}

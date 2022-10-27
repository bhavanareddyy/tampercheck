 
import 'package:auto_route/auto_route.dart';
import 'package:blink_comparison/ui/camera/camera.dart';
import 'package:blink_comparison/ui/cubit/error_report_cubit.dart';
import 'package:blink_comparison/ui/widget/widget.dart';
import 'package:cross_file/cross_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../injector.dart';
import '../theme.dart';

class CameraPickerPage extends StatefulWidget implements AutoRouteWrapper {
  final ValueChanged<XFile>? onTakePhoto;

  const CameraPickerPage({
    Key? key,
    this.onTakePhoto,
  }) : super(key: key);

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CameraProviderCubit>(
          create: (context) => getIt<CameraProviderCubit>(),
        ),
        BlocProvider<ErrorReportCubit>(
          create: (context) => getIt<ErrorReportCubit>(),
        ),
      ],
      child: this,
    );
  }

  @override
  _CameraPickerPageState createState() => _CameraPickerPageState();
}

class _CameraPickerPageState extends State<CameraPickerPage> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.blackTheme(),
      child: Scaffold(
        body: Stack(
          children: [
            CameraView(
              onTakePhoto: (file) {
                widget.onTakePhoto?.call(file);
                Navigator.of(context).pop();
              },
            ),
            const Positioned(
              top: 0.0,
              left: 0.0,
              right: 0.0,
              child: SlideAppBar(),
            ),
          ],
        ),
      ),
    );
  }
}

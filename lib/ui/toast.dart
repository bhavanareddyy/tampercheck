 
import 'package:blink_comparison/core/platform_info.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart' as fluttertoast;

import '../injector.dart';

const _shortDuration = Duration(seconds: 2);
const _longDuration = Duration(seconds: 5);

class Toast {
  final BuildContext context;

  Toast.of(this.context);

  void show({
    required String text,
    bool isLong = false,
  }) {
    final platform = getIt<PlatformInfo>();
    if (platform.isAndroid || platform.isIOS || kIsWeb) {
      fluttertoast.Fluttertoast.showToast(
        msg: text,
        toastLength: isLong
            ? fluttertoast.Toast.LENGTH_LONG
            : fluttertoast.Toast.LENGTH_SHORT,
      );
    } else {
      _showFallbackToast(text: text, isLong: isLong);
    }
  }

  void _showFallbackToast({
    required String text,
    required bool isLong,
  }) {
    final toast = fluttertoast.FToast();
    toast.init(context);

    toast.showToast(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: Theme.of(context).cardColor.withOpacity(0.8),
        ),
        padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 16.0),
        child: Text(text),
      ),
      toastDuration: isLong ? _longDuration : _shortDuration,
    );
  }
}

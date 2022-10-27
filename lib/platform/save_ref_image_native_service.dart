 
import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:blink_comparison/core/platform_info.dart';
import 'package:blink_comparison/core/service/save_ref_image_service.dart';
import 'package:blink_comparison/locale.dart';
import 'package:flutter/services.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

@injectable
class SaveRefImageNativeService {
  @visibleForTesting
  final channel = const MethodChannel(
    ' org.tamper_check/save_ref_image_service',
  );
  final queueChannel = const EventChannel(
    ' org.tamper_check/save_ref_image_service/queue',
  );
  final resultChannel = const EventChannel(
    ' org.tamper_check/save_ref_image_service/result',
  );

  final PlatformInfo _platform;

  SaveRefImageNativeService(this._platform);

  Future<void> start({
    required Function callbackDispatcher,
  }) async {
    final handle = PluginUtilities.getCallbackHandle(callbackDispatcher);
    if (handle == null) {
      throw 'Callback must be a static or top-level function';
    }

    final locale = await AppLocale.loadLocale(
      await _platform.currentLocale ?? 'en_US',
    );
    await channel.invokeMethod(
      'start',
      {
        'callbackHandle': handle.toRawHandle(),
        'notificationTitle': locale.saveRefImageNotificationTitle,
        'notificationChannelName': locale.foregroundNotificationChannel,
      },
    );
  }

  Future<void> stop() async {
    await channel.invokeMethod('stop');
  }

  Future<bool> isRunning() async {
    return await channel.invokeMethod('isRunning');
  }

  Future<void> pushQueue(ServiceRequest info) async {
    await channel.invokeMethod('pushQueue', info.toJson());
  }

  Stream<ServiceRequest> observeQueue() {
    return queueChannel
        .receiveBroadcastStream('observeQueue')
        .map((json) => ServiceRequest.fromJson(jsonDecode(json)));
  }

  Future<List<ServiceRequest>> getAllInProgress() async {
    final List<Object?> list = await channel.invokeMethod('getAllInProgress');
    return list
        .map((json) => ServiceRequest.fromJson(jsonDecode(json as String)))
        .toList();
  }

  Future<void> sendResult(ServiceResult result) async {
    await channel.invokeMethod(
      'sendResult',
      {
        'saveImageRequest': result.request.toJson(),
        'saveImageResult': result.toJson(),
      },
    );
  }

  Stream<ServiceResult> observeResult() {
    return resultChannel
        .receiveBroadcastStream('observeResult')
        .map((json) => ServiceResult.fromJson(jsonDecode(json)));
  }
}

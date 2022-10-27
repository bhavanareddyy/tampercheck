
import 'package:injectable/injectable.dart';

import '../../env.dart';
import '../platform_info.dart';
import 'crash_report_id_generator.dart';
import 'crash_report_manager.dart';

abstract class CrashReportBuilder {
  Future<CrashReport> build(CrashInfo info);
}

abstract class CrashReportBuilderImpl implements CrashReportBuilder {
  final PlatformInfo _platform;
  final CrashReportIdGenerator _idGenerator;

  CrashReportBuilderImpl(this._platform, this._idGenerator);

  String get _email;

  @override
  Future<CrashReport> build(CrashInfo info) async {
    final appInfo = await _platform.appInfo;
    return CrashReport(
      email: _email,
      subject: '${appInfo.packageName} Crash Report',
      data: CrashReportData(
        reportId: _idGenerator.random(),
        packageName: appInfo.packageName,
        appName: appInfo.appName,
        version: appInfo.version,
        buildNumber: appInfo.buildNumber,
        error: info.error.toString(),
        stackTrace: info.stackTrace?.toString(),
        comment: info.message,
        deviceInfo: _toReportableInfo(await _platform.deviceInfo),
      ),
    );
  }

  ReportableInfo _toReportableInfo(DeviceInfo info) {
    return info.map(
      unknown: (_) => const ReportableInfo.unknown(),
      android: (value) => ReportableInfo.android(
        systemVersion: value.systemVersion,
        supportedAbis: value.supportedAbis,
        brand: value.brand,
        device: value.device,
        model: value.model,
        hardware: value.hardware,
        product: value.product,
      ),
      iOS: (value) => ReportableInfo.iOS(
        deviceName: value.deviceName,
        deviceModel: value.deviceModel,
        systemName: value.systemName,
        systemVersion: value.systemVersion,
      ),
      linux: (value) => ReportableInfo.linux(
        osName: value.osName,
        kernelVersion: value.kernelVersion,
        osVersion: value.osVersion,
      ),
      windows: (value) => ReportableInfo.windows(
        osVersion: value.osVersion,
      ),
      macOS: (value) => ReportableInfo.macOS(
        arch: value.arch,
        kernelVersion: value.kernelVersion,
        osVersion: value.osVersion,
        model: value.model,
      ),
      web: (value) => ReportableInfo.web(
        browserName: value.browserName,
        platform: value.platform,
        vendor: value.vendor,
      ),
    );
  }
}

@Injectable(as: CrashReportBuilder, env: [Env.prod])
class ProdCrashReportBuilder extends CrashReportBuilderImpl {
  ProdCrashReportBuilder(
    PlatformInfo platform,
    CrashReportIdGenerator idGenerator,
  ) : super(platform, idGenerator);

  @override
  String get _email => CrashReportManager.reportEmail;
}

@Injectable(as: CrashReportBuilder, env: [Env.dev])
class DevCrashReportBuilder extends CrashReportBuilderImpl {
  DevCrashReportBuilder(
    PlatformInfo platform,
    CrashReportIdGenerator idGenerator,
  ) : super(platform, idGenerator);

  @override
  String get _email => 'foo@bar.com';
}

@Injectable(as: CrashReportBuilder, env: [Env.test])
class TestCrashReportBuilder extends DevCrashReportBuilder {
  TestCrashReportBuilder(
    PlatformInfo platform,
    CrashReportIdGenerator idGenerator,
  ) : super(platform, idGenerator);
}

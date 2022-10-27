 
import 'package:blink_comparison/core/crash_report/crash_report_builder.dart';
import 'package:blink_comparison/core/crash_report/crash_report_id_generator.dart';
import 'package:blink_comparison/core/crash_report/model.dart';
import 'package:blink_comparison/core/platform_info.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../mock/mock.dart';

void main() {
  group('Crash report builder |', () {
    late CrashReportIdGenerator mockIdGenerator;
    late PlatformInfo mockPlatformInfo;
    late CrashReportBuilder builder;

    setUpAll(() {
      mockIdGenerator = MockCrashReportIdGenerator();
      mockPlatformInfo = MockPlatformInfo();
      builder = TestCrashReportBuilder(mockPlatformInfo, mockIdGenerator);
    });

    test('Build', () async {
      final info = CrashInfo(
        error: Exception('Error'),
        stackTrace: StackTrace.fromString('Stack Trace'),
        message: 'Comment',
      );
      const data = CrashReportData(
        reportId: CrashReportId('1'),
        packageName: 'org.proninyaroslav.test',
        appName: 'Test',
        version: '1.0',
        buildNumber: '1',
        error: 'Exception: Error',
        comment: 'Comment',
        stackTrace: 'Stack Trace',
        deviceInfo: ReportableInfo.linux(
          osName: 'Fedora',
          kernelVersion: '5.0',
        ),
      );
      const expectedReport = CrashReport(
        email: 'foo@bar.com',
        subject: 'org.proninyaroslav.test Crash Report',
        data: data,
      );

      when(() => mockIdGenerator.random()).thenReturn(data.reportId);
      when(
        () => mockPlatformInfo.appInfo,
      ).thenAnswer(
        (_) async => AppInfo(
          packageName: data.packageName,
          appName: data.appName,
          version: data.version,
          buildNumber: data.buildNumber,
        ),
      );
      when(
        () => mockPlatformInfo.deviceInfo,
      ).thenAnswer(
        (_) async => const DeviceInfo.linux(
          osName: 'Fedora',
          kernelVersion: '5.0',
        ),
      );

      expect(await builder.build(info), expectedReport);
    });

    group('Reportable device info |', () {
      const stub = 'test';
      const info = CrashInfo(error: 'Error');
      const data = CrashReportData(
        reportId: CrashReportId('1'),
        packageName: 'com.example.test',
        appName: 'Test',
        version: '1.0',
        buildNumber: '1',
        error: 'Error',
        deviceInfo: ReportableInfo.unknown(),
      );

      CrashReport expectedReport(CrashReportData data) {
        return CrashReport(
          email: 'foo@bar.com',
          subject: 'com.example.test Crash Report',
          data: data,
        );
      }

      setUp(() {
        when(() => mockIdGenerator.random()).thenReturn(data.reportId);
        when(
          () => mockPlatformInfo.appInfo,
        ).thenAnswer(
          (_) async => AppInfo(
            packageName: data.packageName,
            appName: data.appName,
            version: data.version,
            buildNumber: data.buildNumber,
          ),
        );
      });

      test('Android', () async {
        final dataAndroid = data.copyWith(
          deviceInfo: const ReportableInfo.android(
            systemVersion: stub,
            supportedAbis: [stub],
            brand: stub,
            device: stub,
            model: stub,
            hardware: stub,
            product: stub,
          ),
        );
        const deviceInfoAndroid = DeviceInfo.android(
          systemVersion: stub,
          supportedAbis: [stub],
          brand: stub,
          device: stub,
          model: stub,
          hardware: stub,
          product: stub,
        );
        when(
          () => mockPlatformInfo.deviceInfo,
        ).thenAnswer(
          (_) async => deviceInfoAndroid,
        );
        expect(await builder.build(info), expectedReport(dataAndroid));
      });

      test('iOS', () async {
        final dataIOS = data.copyWith(
          deviceInfo: const ReportableInfo.iOS(
            deviceName: stub,
            deviceModel: stub,
            systemName: stub,
            systemVersion: stub,
          ),
        );
        const deviceInfoIOS = DeviceInfo.iOS(
          deviceName: stub,
          deviceModel: stub,
          systemName: stub,
          systemVersion: stub,
        );
        when(
          () => mockPlatformInfo.deviceInfo,
        ).thenAnswer(
          (_) async => deviceInfoIOS,
        );
        expect(await builder.build(info), expectedReport(dataIOS));
      });

      test('Linux', () async {
        final dataLinux = data.copyWith(
          deviceInfo: const ReportableInfo.linux(
            osName: stub,
            kernelVersion: stub,
            osVersion: stub,
          ),
        );
        const deviceInfoLinux = DeviceInfo.linux(
          osName: stub,
          kernelVersion: stub,
          osVersion: stub,
        );
        when(
          () => mockPlatformInfo.deviceInfo,
        ).thenAnswer(
          (_) async => deviceInfoLinux,
        );
        expect(await builder.build(info), expectedReport(dataLinux));
      });

      test('Windows', () async {
        final dataWindows = data.copyWith(
          deviceInfo: const ReportableInfo.windows(
            osVersion: stub,
          ),
        );
        const deviceInfoWindows = DeviceInfo.windows(
          osVersion: stub,
        );
        when(
          () => mockPlatformInfo.deviceInfo,
        ).thenAnswer(
          (_) async => deviceInfoWindows,
        );
        expect(await builder.build(info), expectedReport(dataWindows));
      });

      test('macOS', () async {
        final dataMacOS = data.copyWith(
          deviceInfo: const ReportableInfo.macOS(
            arch: stub,
            kernelVersion: stub,
            osVersion: stub,
            model: stub,
          ),
        );
        const deviceInfoMacOS = DeviceInfo.macOS(
          arch: stub,
          kernelVersion: stub,
          osVersion: stub,
          model: stub,
        );
        when(
          () => mockPlatformInfo.deviceInfo,
        ).thenAnswer(
          (_) async => deviceInfoMacOS,
        );
        expect(await builder.build(info), expectedReport(dataMacOS));
      });

      test('Web', () async {
        final dataWeb = data.copyWith(
          deviceInfo: const ReportableInfo.web(
            browserName: stub,
            platform: stub,
            vendor: stub,
          ),
        );
        const deviceWeb = DeviceInfo.web(
          browserName: stub,
          platform: stub,
          vendor: stub,
        );
        when(
          () => mockPlatformInfo.deviceInfo,
        ).thenAnswer(
          (_) async => deviceWeb,
        );
        expect(await builder.build(info), expectedReport(dataWeb));
      });
    });
  });
}

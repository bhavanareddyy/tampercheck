 
import 'package:blink_comparison/core/crash_report/crash_report_manager.dart';
import 'package:blink_comparison/ui/cubit/error_report_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mock/mock.dart';

void main() {
  group('ErrorReportCubit |', () {
    late CrashReportManager mockReportManager;
    late ErrorReportCubit cubit;

    setUpAll(() {
      mockReportManager = MockCrashReportManager();
    });

    setUp(() {
      cubit = ErrorReportCubit(mockReportManager);
    });

    blocTest(
      'Initial state',
      build: () => cubit,
      expect: () => [],
    );

    blocTest(
      'Report success',
      build: () => cubit,
      act: (ErrorReportCubit cubit) async {
        const info = CrashInfo(
          error: 'test',
          message: 'comment',
        );
        when(
          () => mockReportManager.sendReport(info),
        ).thenAnswer(
          (_) async => const CrashReportSendResult.success(),
        );
        await cubit.sendReport(
          error: info.error,
          stackTrace: info.stackTrace,
          message: info.message,
        );
      },
      expect: () => [
        const ErrorReportState.inProgress(),
        const ErrorReportState.success(),
      ],
    );

    blocTest(
      'Email unsupported',
      build: () => cubit,
      act: (ErrorReportCubit cubit) async {
        const info = CrashInfo(error: 'test');
        when(
          () => mockReportManager.sendReport(info),
        ).thenAnswer(
          (_) async => const CrashReportSendResult.emailUnsupported(),
        );
        await cubit.sendReport(error: info.error);
      },
      expect: () => [
        const ErrorReportState.inProgress(),
        const ErrorReportState.emailUnsupported(),
      ],
    );
  });
}

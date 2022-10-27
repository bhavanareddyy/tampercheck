
import 'package:blink_comparison/core/crash_report/crash_report_manager.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'error_report_cubit.freezed.dart';

@freezed
class ErrorReportState with _$ErrorReportState {
  const factory ErrorReportState.initial() = ErrorReportStateInitial;

  const factory ErrorReportState.inProgress() = ErrorReportStateInProgress;

  const factory ErrorReportState.success() = ErrorReportStateSuccess;

  const factory ErrorReportState.emailUnsupported() =
      ErrorReportStateEmailUnsupported;
}

@injectable
class ErrorReportCubit extends Cubit<ErrorReportState> {
  final CrashReportManager _reportManager;

  ErrorReportCubit(this._reportManager)
      : super(const ErrorReportState.initial());

  Future<void> sendReport({
    required Object error,
    StackTrace? stackTrace,
    String? message,
  }) async {
    emit(const ErrorReportState.inProgress());
    final res = await _reportManager.sendReport(
      CrashInfo(
        error: error,
        stackTrace: stackTrace,
        message: message,
      ),
    );
    emit(
      res.when(
        success: () => const ErrorReportState.success(),
        emailUnsupported: () => const ErrorReportState.emailUnsupported(),
      ),
    );
  }
}

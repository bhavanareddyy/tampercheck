 
import 'package:injectable/injectable.dart';

import 'crash_report_builder.dart';
import 'crash_report_sender.dart';
import 'model.dart';

export 'model.dart';

abstract class CrashReportManager {
  static const reportEmail = 'proninyaroslav@mail.ru';

  Future<CrashReportSendResult> sendReport(CrashInfo info);
}

@Injectable(as: CrashReportManager)
class CrashReportManagerImpl implements CrashReportManager {
  final CrashReportBuilder _builder;
  final CrashReportSender _sender;

  CrashReportManagerImpl(this._builder, this._sender);

  @override
  Future<CrashReportSendResult> sendReport(CrashInfo info) async {
    final report = await _builder.build(info);
    return _sender.send(report);
  }
}

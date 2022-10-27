 
import 'package:blink_comparison/core/crash_report/crash_report_id_generator.dart';
import 'package:blink_comparison/core/crash_report/model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Crash report ID generator |', () {
    late CrashReportIdGenerator generator;

    setUpAll(() async {
      generator = CrashReportIdGeneratorImpl();
    });

    test('Random', () {
      final idSet = <CrashReportId>{};
      const size = 5;
      for (var i = 0; i < size; i++) {
        idSet.add(generator.random());
      }
      expect(idSet.length, size);
    });
  });
}

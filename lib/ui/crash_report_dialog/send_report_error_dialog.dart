
import 'package:blink_comparison/core/crash_report/crash_report_manager.dart';
import 'package:blink_comparison/ui/widget/widget.dart';
import 'package:flutter/material.dart';

import '../../locale.dart';

class SendReportErrorDialog extends StatelessWidget {
  const SendReportErrorDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(S.of(context).error),
      scrollable: true,
      content: ConstrainedBox(
        constraints: const BoxConstraints.tightFor(width: 300),
        child: LinkText(
          text: S.of(context).crashDialogNoEmailApp(
                CrashReportManager.reportEmail,
                S.of(context).projectIssuesPage,
              ),
          selectable: true,
          style: Theme.of(context).textTheme.subtitle1,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            MaterialLocalizations.of(context).okButtonLabel,
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}

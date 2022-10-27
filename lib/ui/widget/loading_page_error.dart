
import 'package:blink_comparison/ui/theme.dart';
import 'package:flutter/material.dart';

import '../../locale.dart';
import '../theme.dart';

class LoadingPageError extends StatelessWidget {
  final VoidCallback? onRefresh;

  const LoadingPageError({
    Key? key,
    this.onRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pageHeadlineText = AppTheme.pageHeadlineText(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: pageHeadlineText.color,
                ),
                const SizedBox(width: 8.0),
                Flexible(
                  child: Text(
                    S.of(context).loadPageFailed,
                    style: pageHeadlineText,
                  ),
                ),
              ],
            ),
            OutlinedButton.icon(
              onPressed: onRefresh,
              icon: const Icon(Icons.refresh),
              label: Text(S.of(context).refresh),
            ),
          ],
        ),
      ),
    );
  }
}

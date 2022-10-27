 
import 'package:blink_comparison/ui/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../locale.dart';
import '../../logger.dart';

class LinkText extends StatelessWidget {
  final String text;
  final bool selectable;
  final TextStyle? style;

  const LinkText({
    Key? key,
    required this.text,
    this.selectable = false,
    this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final linkStyle = TextStyle(
      color: AppTheme.isDark(context)
          ? colorScheme.primary
          : colorScheme.secondaryContainer,
    );
    Future<void> onOpen(LinkableElement link) async {
      try {
        await launch(link.url);
      } on PlatformException catch (e, stackTrace) {
        log().w('Unable to open $link', e, stackTrace);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(S.of(context).openLinkFailed),
          ),
        );
      }
    }

    if (selectable) {
      return SelectableLinkify(
        text: text,
        linkStyle: linkStyle,
        style: style,
        onOpen: onOpen,
      );
    } else {
      return Linkify(
        text: text,
        linkStyle: linkStyle,
        style: style,
        onOpen: onOpen,
      );
    }
  }
}

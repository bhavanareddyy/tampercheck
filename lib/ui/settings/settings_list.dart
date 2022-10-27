
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../theme.dart';
import '../utils.dart';

class SettingsList extends StatelessWidget {
  final List<SettingsListGroup> groups;

  const SettingsList({
    Key? key,
    required this.groups,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: SafeArea(
        child: AnimationLimiter(
          child: ListView.separated(
            key: key,
            padding: const EdgeInsets.all(8.0),
            itemCount: groups.length,
            itemBuilder: (context, position) {
              return AnimationConfiguration.staggeredList(
                position: position,
                duration: UiUtils.defaultAnimatedListDuration,
                child: SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(child: groups[position]),
                ),
              );
            },
            separatorBuilder: (context, position) {
              return const SizedBox(height: 8.0);
            },
          ),
        ),
      ),
    );
  }
}

class SettingsListGroup extends StatelessWidget {
  final String? title;
  final List<Widget> items;

  const SettingsListGroup({
    Key? key,
    this.title,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              title!,
              style: Theme.of(context).textTheme.overline!.copyWith(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                    color: AppTheme.textPrimaryColorLight(context),
                  ),
            ),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: items.length,
            itemBuilder: (context, position) => Material(
              shape: Theme.of(context).cardTheme.shape,
              clipBehavior: Clip.antiAlias,
              color: Colors.transparent,
              child: items[position],
            ),
          ),
        ),
      ],
    );
  }
}

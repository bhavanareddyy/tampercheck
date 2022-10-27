 
import 'package:blink_comparison/core/settings/model.dart';
import 'package:blink_comparison/locale.dart';
import 'package:blink_comparison/ui/utils.dart';
import 'package:blink_comparison/ui/widget/widget.dart';
import 'package:flutter/material.dart' hide Locale;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../settings_list.dart';
import '../settings_scaffold.dart';
import 'appearance_cubit.dart';

class AppearanceSettingsPage extends StatelessWidget {
  const AppearanceSettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SettingsScaffold(
      appBar: AppBar(
        title: Text(S.of(context).settingsAppearance),
      ),
      body: SettingsList(
        key: const PageStorageKey('appearance_list'),
        groups: [
          SettingsListGroup(
            items: [
              _buildThemeOption(context),
              _buildLanguageOption(context),
            ],
          ),
          SettingsListGroup(
            title: S.of(context).settingsBlinkComparisonPage,
            items: [
              _buildRefImageBorderOption(context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildThemeOption(BuildContext context) {
    return ListTile(
      title: Text(S.of(context).settingsTheme),
      subtitle: BlocBuilder<AppearanceSettingsCubit, AppearanceState>(
        buildWhen: (prev, current) => current is AppearanceStateThemeChanged,
        builder: (context, state) {
          return Text(
            state.info.theme.toLocalizedString(context),
          );
        },
      ),
      leading: const Icon(Icons.palette_outlined),
      onTap: () => _showThemeDialog(context),
    );
  }

  void _showThemeDialog(BuildContext context) {
    final cubit = context.read<AppearanceSettingsCubit>();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(S.of(context).settingsTheme),
          contentPadding: const EdgeInsets.only(top: 16.0),
          content: DialogScrollableContent(
            child: BlocBuilder<AppearanceSettingsCubit, AppearanceState>(
              bloc: cubit,
              buildWhen: (prev, current) =>
                  current is AppearanceStateThemeChanged,
              builder: (context, state) {
                return _ThemeList(
                  initialValue: state.info.theme,
                  onSelected: (theme) {
                    cubit.setTheme(theme);
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                S.of(context).cancel,
                textAlign: TextAlign.end,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLanguageOption(BuildContext context) {
    return ListTile(
      title: Text(S.of(context).settingsLanguage),
      subtitle: BlocBuilder<AppearanceSettingsCubit, AppearanceState>(
        buildWhen: (prev, current) => current is AppearanceStateLocaleChanged,
        builder: (context, state) {
          return Text(
            state.info.locale.when(
              system: () => S.of(context).settingsSystemLanguageOption,
              inner: (locale) =>
                  UiUtils.localeToLocalizedStr(locale.toString()),
            ),
          );
        },
      ),
      leading: const Icon(Icons.language),
      onTap: () => _showLanguageDialog(context),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    final cubit = context.read<AppearanceSettingsCubit>();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(S.of(context).settingsLanguage),
          contentPadding: const EdgeInsets.only(top: 16.0),
          content: DialogScrollableContent(
            child: BlocBuilder<AppearanceSettingsCubit, AppearanceState>(
              bloc: cubit,
              buildWhen: (prev, current) =>
                  current is AppearanceStateLocaleChanged,
              builder: (context, state) {
                return _LanguageList(
                  initialValue: state.info.locale,
                  onSelected: (locale) {
                    cubit.setLocale(locale);
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                S.of(context).cancel,
                textAlign: TextAlign.end,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildRefImageBorderOption(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        vertical: 4.0,
        horizontal: 16.0,
      ),
      title: Text(S.of(context).settingsReferenceImageBorderColor),
      subtitle: BlocBuilder<AppearanceSettingsCubit, AppearanceState>(
        buildWhen: (prev, current) =>
            current is AppearanceStateRefImageBorderColorChanged,
        builder: (context, state) => _ColorView(
          color: Color(state.info.refImageBorderColor),
        ),
      ),
      leading: const Icon(Icons.image_outlined),
      onTap: () => _showColorPickerDialog(context),
    );
  }

  void _showColorPickerDialog(BuildContext context) {
    final cubit = context.read<AppearanceSettingsCubit>();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(S.of(context).settingsReferenceImageBorderColor),
          contentPadding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 0.0),
          content: DialogScrollableContent(
            child: BlocBuilder<AppearanceSettingsCubit, AppearanceState>(
              bloc: cubit,
              buildWhen: (prev, current) =>
                  current is AppearanceStateRefImageBorderColorChanged,
              builder: (context, state) {
                return ColorPicker(
                  pickerColor: Color(state.info.refImageBorderColor),
                  enableAlpha: false,
                  onColorChanged: (color) {
                    cubit.setRefImageBorderColor(color.value);
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                S.of(context).close,
                textAlign: TextAlign.end,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ColorView extends StatelessWidget {
  final Color color;

  const _ColorView({
    Key? key,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      alignment: AlignmentDirectional.centerStart,
      child: CircleAvatar(
        backgroundColor: Theme.of(context).dividerColor,
        radius: 12.0,
        child: CircleAvatar(
          backgroundColor: color,
          radius: 11.0,
        ),
      ),
    );
  }
}

class _ThemeList extends StatefulWidget {
  final AppThemeType initialValue;
  final ValueChanged<AppThemeType>? onSelected;

  const _ThemeList({
    Key? key,
    required this.initialValue,
    this.onSelected,
  }) : super(key: key);

  @override
  _ThemeListState createState() => _ThemeListState();
}

class _ThemeListState extends State<_ThemeList> {
  final _values = const [
    AppThemeType.system(),
    AppThemeType.light(),
    AppThemeType.dark(),
  ];

  late AppThemeType _currentTheme;

  @override
  void initState() {
    super.initState();

    _currentTheme = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: _values
          .map(
            (value) => RadioListTile(
              value: value,
              groupValue: _currentTheme,
              title: Text(value.toLocalizedString(context)),
              onChanged: (_) {
                setState(() => _currentTheme = value);
                widget.onSelected?.call(value);
              },
            ),
          )
          .toList(),
    );
  }
}

class _LanguageList extends StatefulWidget {
  final AppLocaleType initialValue;
  final ValueChanged<AppLocaleType>? onSelected;

  const _LanguageList({
    Key? key,
    required this.initialValue,
    this.onSelected,
  }) : super(key: key);

  @override
  _LanguageListState createState() => _LanguageListState();
}

class _LanguageListState extends State<_LanguageList> {
  late AppLocaleType _currentLocale;
  late List<MapEntry<AppLocaleType, String>> _localesList;

  @override
  void initState() {
    super.initState();

    _currentLocale = widget.initialValue;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _localesList = [
      MapEntry(
        const AppLocaleType.system(),
        S.of(context).settingsSystemLanguageOption,
      ),
      ...UiUtils.supportedLocales.map(
        (entry) => MapEntry(
          AppLocaleType.inner(locale: entry.key),
          entry.value,
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: _localesList.map((entry) {
        final locale = entry.key;
        final localeStr = entry.value;
        return RadioListTile(
          value: locale,
          groupValue: _currentLocale,
          title: Text(localeStr),
          onChanged: (_) => _onChanged(locale),
        );
      }).toList(),
    );
  }

  void _onChanged(AppLocaleType locale) {
    setState(() => _currentLocale = locale);
    widget.onSelected?.call(locale);
  }
}

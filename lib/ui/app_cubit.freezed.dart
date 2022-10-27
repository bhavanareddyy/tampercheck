// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'app_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$AppStateTearOff {
  const _$AppStateTearOff();

  AppStateInitial initial(
      {required AppThemeType theme,
      required AppLocaleType locale,
      required bool cameraFullscreenMode}) {
    return AppStateInitial(
      theme: theme,
      locale: locale,
      cameraFullscreenMode: cameraFullscreenMode,
    );
  }

  AppStateChanged changed(
      {required AppThemeType theme,
      required AppLocaleType locale,
      required bool cameraFullscreenMode}) {
    return AppStateChanged(
      theme: theme,
      locale: locale,
      cameraFullscreenMode: cameraFullscreenMode,
    );
  }
}

/// @nodoc
const $AppState = _$AppStateTearOff();

/// @nodoc
mixin _$AppState {
  AppThemeType get theme => throw _privateConstructorUsedError;
  AppLocaleType get locale => throw _privateConstructorUsedError;
  bool get cameraFullscreenMode => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            AppThemeType theme, AppLocaleType locale, bool cameraFullscreenMode)
        initial,
    required TResult Function(
            AppThemeType theme, AppLocaleType locale, bool cameraFullscreenMode)
        changed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(AppThemeType theme, AppLocaleType locale,
            bool cameraFullscreenMode)?
        initial,
    TResult Function(AppThemeType theme, AppLocaleType locale,
            bool cameraFullscreenMode)?
        changed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(AppThemeType theme, AppLocaleType locale,
            bool cameraFullscreenMode)?
        initial,
    TResult Function(AppThemeType theme, AppLocaleType locale,
            bool cameraFullscreenMode)?
        changed,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AppStateInitial value) initial,
    required TResult Function(AppStateChanged value) changed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(AppStateInitial value)? initial,
    TResult Function(AppStateChanged value)? changed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AppStateInitial value)? initial,
    TResult Function(AppStateChanged value)? changed,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AppStateCopyWith<AppState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppStateCopyWith<$Res> {
  factory $AppStateCopyWith(AppState value, $Res Function(AppState) then) =
      _$AppStateCopyWithImpl<$Res>;
  $Res call(
      {AppThemeType theme, AppLocaleType locale, bool cameraFullscreenMode});

  $AppThemeTypeCopyWith<$Res> get theme;
  $AppLocaleTypeCopyWith<$Res> get locale;
}

/// @nodoc
class _$AppStateCopyWithImpl<$Res> implements $AppStateCopyWith<$Res> {
  _$AppStateCopyWithImpl(this._value, this._then);

  final AppState _value;
  // ignore: unused_field
  final $Res Function(AppState) _then;

  @override
  $Res call({
    Object? theme = freezed,
    Object? locale = freezed,
    Object? cameraFullscreenMode = freezed,
  }) {
    return _then(_value.copyWith(
      theme: theme == freezed
          ? _value.theme
          : theme // ignore: cast_nullable_to_non_nullable
              as AppThemeType,
      locale: locale == freezed
          ? _value.locale
          : locale // ignore: cast_nullable_to_non_nullable
              as AppLocaleType,
      cameraFullscreenMode: cameraFullscreenMode == freezed
          ? _value.cameraFullscreenMode
          : cameraFullscreenMode // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }

  @override
  $AppThemeTypeCopyWith<$Res> get theme {
    return $AppThemeTypeCopyWith<$Res>(_value.theme, (value) {
      return _then(_value.copyWith(theme: value));
    });
  }

  @override
  $AppLocaleTypeCopyWith<$Res> get locale {
    return $AppLocaleTypeCopyWith<$Res>(_value.locale, (value) {
      return _then(_value.copyWith(locale: value));
    });
  }
}

/// @nodoc
abstract class $AppStateInitialCopyWith<$Res>
    implements $AppStateCopyWith<$Res> {
  factory $AppStateInitialCopyWith(
          AppStateInitial value, $Res Function(AppStateInitial) then) =
      _$AppStateInitialCopyWithImpl<$Res>;
  @override
  $Res call(
      {AppThemeType theme, AppLocaleType locale, bool cameraFullscreenMode});

  @override
  $AppThemeTypeCopyWith<$Res> get theme;
  @override
  $AppLocaleTypeCopyWith<$Res> get locale;
}

/// @nodoc
class _$AppStateInitialCopyWithImpl<$Res> extends _$AppStateCopyWithImpl<$Res>
    implements $AppStateInitialCopyWith<$Res> {
  _$AppStateInitialCopyWithImpl(
      AppStateInitial _value, $Res Function(AppStateInitial) _then)
      : super(_value, (v) => _then(v as AppStateInitial));

  @override
  AppStateInitial get _value => super._value as AppStateInitial;

  @override
  $Res call({
    Object? theme = freezed,
    Object? locale = freezed,
    Object? cameraFullscreenMode = freezed,
  }) {
    return _then(AppStateInitial(
      theme: theme == freezed
          ? _value.theme
          : theme // ignore: cast_nullable_to_non_nullable
              as AppThemeType,
      locale: locale == freezed
          ? _value.locale
          : locale // ignore: cast_nullable_to_non_nullable
              as AppLocaleType,
      cameraFullscreenMode: cameraFullscreenMode == freezed
          ? _value.cameraFullscreenMode
          : cameraFullscreenMode // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$AppStateInitial implements AppStateInitial {
  const _$AppStateInitial(
      {required this.theme,
      required this.locale,
      required this.cameraFullscreenMode});

  @override
  final AppThemeType theme;
  @override
  final AppLocaleType locale;
  @override
  final bool cameraFullscreenMode;

  @override
  String toString() {
    return 'AppState.initial(theme: $theme, locale: $locale, cameraFullscreenMode: $cameraFullscreenMode)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AppStateInitial &&
            const DeepCollectionEquality().equals(other.theme, theme) &&
            const DeepCollectionEquality().equals(other.locale, locale) &&
            const DeepCollectionEquality()
                .equals(other.cameraFullscreenMode, cameraFullscreenMode));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(theme),
      const DeepCollectionEquality().hash(locale),
      const DeepCollectionEquality().hash(cameraFullscreenMode));

  @JsonKey(ignore: true)
  @override
  $AppStateInitialCopyWith<AppStateInitial> get copyWith =>
      _$AppStateInitialCopyWithImpl<AppStateInitial>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            AppThemeType theme, AppLocaleType locale, bool cameraFullscreenMode)
        initial,
    required TResult Function(
            AppThemeType theme, AppLocaleType locale, bool cameraFullscreenMode)
        changed,
  }) {
    return initial(theme, locale, cameraFullscreenMode);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(AppThemeType theme, AppLocaleType locale,
            bool cameraFullscreenMode)?
        initial,
    TResult Function(AppThemeType theme, AppLocaleType locale,
            bool cameraFullscreenMode)?
        changed,
  }) {
    return initial?.call(theme, locale, cameraFullscreenMode);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(AppThemeType theme, AppLocaleType locale,
            bool cameraFullscreenMode)?
        initial,
    TResult Function(AppThemeType theme, AppLocaleType locale,
            bool cameraFullscreenMode)?
        changed,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(theme, locale, cameraFullscreenMode);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AppStateInitial value) initial,
    required TResult Function(AppStateChanged value) changed,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(AppStateInitial value)? initial,
    TResult Function(AppStateChanged value)? changed,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AppStateInitial value)? initial,
    TResult Function(AppStateChanged value)? changed,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class AppStateInitial implements AppState {
  const factory AppStateInitial(
      {required AppThemeType theme,
      required AppLocaleType locale,
      required bool cameraFullscreenMode}) = _$AppStateInitial;

  @override
  AppThemeType get theme;
  @override
  AppLocaleType get locale;
  @override
  bool get cameraFullscreenMode;
  @override
  @JsonKey(ignore: true)
  $AppStateInitialCopyWith<AppStateInitial> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppStateChangedCopyWith<$Res>
    implements $AppStateCopyWith<$Res> {
  factory $AppStateChangedCopyWith(
          AppStateChanged value, $Res Function(AppStateChanged) then) =
      _$AppStateChangedCopyWithImpl<$Res>;
  @override
  $Res call(
      {AppThemeType theme, AppLocaleType locale, bool cameraFullscreenMode});

  @override
  $AppThemeTypeCopyWith<$Res> get theme;
  @override
  $AppLocaleTypeCopyWith<$Res> get locale;
}

/// @nodoc
class _$AppStateChangedCopyWithImpl<$Res> extends _$AppStateCopyWithImpl<$Res>
    implements $AppStateChangedCopyWith<$Res> {
  _$AppStateChangedCopyWithImpl(
      AppStateChanged _value, $Res Function(AppStateChanged) _then)
      : super(_value, (v) => _then(v as AppStateChanged));

  @override
  AppStateChanged get _value => super._value as AppStateChanged;

  @override
  $Res call({
    Object? theme = freezed,
    Object? locale = freezed,
    Object? cameraFullscreenMode = freezed,
  }) {
    return _then(AppStateChanged(
      theme: theme == freezed
          ? _value.theme
          : theme // ignore: cast_nullable_to_non_nullable
              as AppThemeType,
      locale: locale == freezed
          ? _value.locale
          : locale // ignore: cast_nullable_to_non_nullable
              as AppLocaleType,
      cameraFullscreenMode: cameraFullscreenMode == freezed
          ? _value.cameraFullscreenMode
          : cameraFullscreenMode // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$AppStateChanged implements AppStateChanged {
  const _$AppStateChanged(
      {required this.theme,
      required this.locale,
      required this.cameraFullscreenMode});

  @override
  final AppThemeType theme;
  @override
  final AppLocaleType locale;
  @override
  final bool cameraFullscreenMode;

  @override
  String toString() {
    return 'AppState.changed(theme: $theme, locale: $locale, cameraFullscreenMode: $cameraFullscreenMode)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AppStateChanged &&
            const DeepCollectionEquality().equals(other.theme, theme) &&
            const DeepCollectionEquality().equals(other.locale, locale) &&
            const DeepCollectionEquality()
                .equals(other.cameraFullscreenMode, cameraFullscreenMode));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(theme),
      const DeepCollectionEquality().hash(locale),
      const DeepCollectionEquality().hash(cameraFullscreenMode));

  @JsonKey(ignore: true)
  @override
  $AppStateChangedCopyWith<AppStateChanged> get copyWith =>
      _$AppStateChangedCopyWithImpl<AppStateChanged>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            AppThemeType theme, AppLocaleType locale, bool cameraFullscreenMode)
        initial,
    required TResult Function(
            AppThemeType theme, AppLocaleType locale, bool cameraFullscreenMode)
        changed,
  }) {
    return changed(theme, locale, cameraFullscreenMode);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(AppThemeType theme, AppLocaleType locale,
            bool cameraFullscreenMode)?
        initial,
    TResult Function(AppThemeType theme, AppLocaleType locale,
            bool cameraFullscreenMode)?
        changed,
  }) {
    return changed?.call(theme, locale, cameraFullscreenMode);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(AppThemeType theme, AppLocaleType locale,
            bool cameraFullscreenMode)?
        initial,
    TResult Function(AppThemeType theme, AppLocaleType locale,
            bool cameraFullscreenMode)?
        changed,
    required TResult orElse(),
  }) {
    if (changed != null) {
      return changed(theme, locale, cameraFullscreenMode);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AppStateInitial value) initial,
    required TResult Function(AppStateChanged value) changed,
  }) {
    return changed(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(AppStateInitial value)? initial,
    TResult Function(AppStateChanged value)? changed,
  }) {
    return changed?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AppStateInitial value)? initial,
    TResult Function(AppStateChanged value)? changed,
    required TResult orElse(),
  }) {
    if (changed != null) {
      return changed(this);
    }
    return orElse();
  }
}

abstract class AppStateChanged implements AppState {
  const factory AppStateChanged(
      {required AppThemeType theme,
      required AppLocaleType locale,
      required bool cameraFullscreenMode}) = _$AppStateChanged;

  @override
  AppThemeType get theme;
  @override
  AppLocaleType get locale;
  @override
  bool get cameraFullscreenMode;
  @override
  @JsonKey(ignore: true)
  $AppStateChangedCopyWith<AppStateChanged> get copyWith =>
      throw _privateConstructorUsedError;
}

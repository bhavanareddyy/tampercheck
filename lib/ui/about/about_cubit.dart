 
import 'package:blink_comparison/core/platform_info.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'about_cubit.freezed.dart';

@freezed
class AboutState with _$AboutState {
  const factory AboutState.initial() = AboutStateInitial;

  const factory AboutState.loading() = AboutStateLoading;

  const factory AboutState.loaded({
    required String appName,
    required String appVersion,
  }) = AboutStateLoaded;
}

@injectable
class AboutCubit extends Cubit<AboutState> {
  final PlatformInfo _platform;

  AboutCubit(this._platform) : super(const AboutState.initial());

  Future<void> load() async {
    emit(const AboutState.loading());
    final appInfo = await _platform.appInfo;
    emit(AboutState.loaded(
      appName: appInfo.appName,
      appVersion: appInfo.version,
    ));
  }
}

 
import 'dart:async';
import 'dart:typed_data';

import 'package:blink_comparison/core/date_time_provider.dart';
import 'package:blink_comparison/core/encrypt/password_hasher.dart';
import 'package:blink_comparison/core/encrypt/secure_key.dart';
import 'package:blink_comparison/core/entity/entity.dart';
import 'package:blink_comparison/core/storage/password_repository.dart';
import 'package:blink_comparison/core/storage/ref_image_secure_storage.dart';
import 'package:bloc/bloc.dart';
import 'package:convert/convert.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'auth_cubit.freezed.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = AuthStateInitial;

  const factory AuthState.noPassword() = AuthStateNoPassword;

  const factory AuthState.passwordNotLoaded() = AuthStatePasswordNotLoaded;

  const factory AuthState.passwordLoaded({
    required PasswordInfo info,
  }) = AuthStatePasswordLoaded;

  const factory AuthState.loadPasswordFailed({
    Exception? exception,
    StackTrace? stackTrace,
  }) = AuthStateLoadPasswordFailed;

  const factory AuthState.authInProgress({
    required PasswordInfo info,
  }) = AuthStateAuthInProgress;

  const factory AuthState.authSuccess({
    required PasswordInfo info,
  }) = AuthStateAuthSuccess;

  const factory AuthState.authFailed({
    required PasswordInfo info,
    required AuthError reason,
  }) = AuthStateAuthFailed;
}

@freezed
class AuthError with _$AuthError {
  const factory AuthError.emptyPassword() = _AuthErrorEmptyPassword;

  const factory AuthError.wrongPassword() = _AuthErrorWrongPassword;
}

@injectable
class AuthCubit extends Cubit<AuthState> {
  static const _authFailedDelay = Duration(seconds: 3);

  final PasswordRepository _passwordRepo;
  final PasswordHasher _hasher;
  final RefImageSecureStorage _secureStorage;
  final DateTimeProvider _dateTimeProvider;

  AuthCubit(
    this._passwordRepo,
    this._hasher,
    this._secureStorage,
    this._dateTimeProvider,
  ) : super(const AuthState.initial());

  Future<void> loadPassword() async {
    final res = await _passwordRepo.getByType(const PasswordType.encryptKey());
    res.when(
      (info) {
        emit(
          info == null
              ? const AuthState.noPassword()
              : AuthState.passwordLoaded(info: info),
        );
      },
      error: (e) => e.when(
        database: (e, stackTrace) {
          emit(
            AuthState.loadPasswordFailed(
              exception: e,
              stackTrace: stackTrace,
            ),
          );
        },
        fs: (e) => e.when(io: (e, stackTrace) {
          emit(
            AuthState.loadPasswordFailed(
              exception: e,
              stackTrace: stackTrace,
            ),
          );
        }),
      ),
    );
  }

  Future<void> auth(String password) async {
    await state.maybeWhen(
      passwordLoaded: (info) => _auth(password, info),
      authInProgress: (info) {},
      authSuccess: (info) {},
      authFailed: (info, reason) => _auth(password, info),
      orElse: () async => emit(const AuthState.passwordNotLoaded()),
    );
  }

  Future<void> _auth(String password, PasswordInfo info) async {
    emit(AuthState.authInProgress(info: info));
    if (password.isEmpty) {
      emit(AuthState.authFailed(
        info: info,
        reason: const AuthError.emptyPassword(),
      ));
      return;
    }
    final startTime = _dateTimeProvider.now().toUtc();
    final hash = await _hasher.calculate(
      password: password,
      salt: Uint8List.fromList(hex.decode(info.salt)),
    );
    if (hash == info.hash) {
      _secureStorage.setSecureKey(SecureKey.password(password));
      emit(AuthState.authSuccess(info: info));
    } else {
      await _delayAfterFailed(startTime);
      emit(AuthState.authFailed(
        info: info,
        reason: const AuthError.wrongPassword(),
      ));
    }
  }

  Future<void> _delayAfterFailed(DateTime startTime) async {
    final endTime = _dateTimeProvider.now().toUtc();
    final calcDuration = endTime.difference(startTime);
    final delay = _authFailedDelay - calcDuration;
    if (!delay.isNegative) {
      await Future.delayed(delay);
    }
  }
}

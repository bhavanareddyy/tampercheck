 
import 'dart:typed_data';

import 'package:blink_comparison/core/date_time_provider.dart';
import 'package:blink_comparison/core/encrypt/password_hasher.dart';
import 'package:blink_comparison/core/encrypt/secure_key.dart';
import 'package:blink_comparison/core/entity/entity.dart';
import 'package:blink_comparison/core/storage/password_repository.dart';
import 'package:blink_comparison/core/storage/ref_image_secure_storage.dart';
import 'package:blink_comparison/core/storage/storage_result.dart';
import 'package:blink_comparison/ui/auth/auth_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:convert/convert.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mock/mock.dart';

void main() {
  group('AuthCubit |', () {
    late PasswordRepository mockPasswordRepo;
    late PasswordHasher mockHasher;
    late RefImageSecureStorage mockSecureStorage;
    late DateTimeProvider mockDateTimeProvider;
    late AuthCubit cubit;

    setUpAll(() {
      mockPasswordRepo = MockPasswordRepository();
      mockHasher = MockPasswordHasher();
      mockSecureStorage = MockRefImageSecureStorage();
      mockDateTimeProvider = MockDateTimeProvider();
    });

    setUp(() {
      cubit = AuthCubit(
        mockPasswordRepo,
        mockHasher,
        mockSecureStorage,
        mockDateTimeProvider,
      );
    });

    blocTest(
      'Initial state',
      build: () => cubit,
      expect: () => [],
    );

    blocTest(
      'Load password',
      build: () => cubit,
      act: (AuthCubit cubit) async {
        when(
          () => mockPasswordRepo.getByType(const PasswordType.encryptKey()),
        ).thenAnswer(
          (_) async => const StorageResult(
            PasswordInfo(
              id: 'test',
              hash: 'hash',
              salt: 'salt',
            ),
          ),
        );
        await cubit.loadPassword();
      },
      expect: () => [
        const AuthState.passwordLoaded(
          info: PasswordInfo(
            id: 'test',
            hash: 'hash',
            salt: 'salt',
          ),
        ),
      ],
    );

    blocTest(
      'Load password failed',
      build: () => cubit,
      act: (AuthCubit cubit) async {
        when(
          () => mockPasswordRepo.getByType(const PasswordType.encryptKey()),
        ).thenAnswer(
          (_) async => StorageResult.error(
            StorageError.database(
              exception: Exception('Failed to get password'),
            ),
          ),
        );
        await cubit.loadPassword();
      },
      expect: () => [
        isA<AuthStateLoadPasswordFailed>(),
      ],
    );

    blocTest(
      'No password',
      build: () => cubit,
      act: (AuthCubit cubit) async {
        when(
          () => mockPasswordRepo.getByType(const PasswordType.encryptKey()),
        ).thenAnswer(
          (_) async => const StorageResult<PasswordInfo?>(null),
        );
        await cubit.loadPassword();
      },
      expect: () => [
        const AuthState.noPassword(),
      ],
    );

    blocTest(
      'Password not loaded',
      build: () => cubit,
      act: (AuthCubit cubit) async {
        await cubit.auth('password');
      },
      expect: () => [
        const AuthState.passwordNotLoaded(),
      ],
    );

    blocTest(
      'Failed auth',
      build: () => cubit,
      act: (AuthCubit cubit) async {
        final salt = Uint8List.fromList([1, 2, 3]);
        const password = 'password';
        final info = PasswordInfo(
          id: 'test',
          hash: 'hash',
          salt: hex.encode(salt),
        );
        when(
          () => mockPasswordRepo.getByType(const PasswordType.encryptKey()),
        ).thenAnswer(
          (_) async => StorageResult(info),
        );
        when(
          () => mockHasher.calculate(
            password: password,
            salt: salt,
          ),
        ).thenAnswer((_) async => 'another_hash');

        final startTime = DateTime.now().toUtc();
        when(() => mockDateTimeProvider.now()).thenReturn(startTime);
        await cubit.loadPassword();
        await cubit.auth(password);
        final endTime = DateTime.now().toUtc();
        final delay = endTime.difference(startTime);
        expect(
          delay >= const Duration(seconds: 3),
          isTrue,
        );
      },
      expect: () => [
        AuthState.passwordLoaded(
          info: PasswordInfo(
            id: 'test',
            hash: 'hash',
            salt: hex.encode(Uint8List.fromList([1, 2, 3])),
          ),
        ),
        AuthState.authInProgress(
          info: PasswordInfo(
            id: 'test',
            hash: 'hash',
            salt: hex.encode(Uint8List.fromList([1, 2, 3])),
          ),
        ),
        AuthState.authFailed(
          info: PasswordInfo(
            id: 'test',
            hash: 'hash',
            salt: hex.encode(Uint8List.fromList([1, 2, 3])),
          ),
          reason: const AuthError.wrongPassword(),
        ),
      ],
    );

    blocTest(
      'Success auth',
      build: () => cubit,
      act: (AuthCubit cubit) async {
        final salt = Uint8List.fromList([1, 2, 3]);
        const password = 'password';
        final info = PasswordInfo(
          id: 'test',
          hash: 'hash',
          salt: hex.encode(salt),
        );
        when(
          () => mockPasswordRepo.getByType(const PasswordType.encryptKey()),
        ).thenAnswer(
          (_) async => StorageResult(info),
        );
        when(
          () => mockHasher.calculate(
            password: password,
            salt: salt,
          ),
        ).thenAnswer((_) async => info.hash);
        when(
          () => mockSecureStorage.setSecureKey(
            const SecureKey.password(password),
          ),
        ).thenAnswer((_) => {});
        when(() => mockDateTimeProvider.now()).thenReturn(DateTime(2021));

        await cubit.loadPassword();
        await cubit.auth(password);

        verify(
          () => mockSecureStorage.setSecureKey(
            const SecureKey.password(password),
          ),
        ).called(1);
      },
      expect: () => [
        AuthState.passwordLoaded(
          info: PasswordInfo(
            id: 'test',
            hash: 'hash',
            salt: hex.encode(Uint8List.fromList([1, 2, 3])),
          ),
        ),
        AuthState.authInProgress(
          info: PasswordInfo(
            id: 'test',
            hash: 'hash',
            salt: hex.encode(Uint8List.fromList([1, 2, 3])),
          ),
        ),
        AuthState.authSuccess(
          info: PasswordInfo(
            id: 'test',
            hash: 'hash',
            salt: hex.encode(Uint8List.fromList([1, 2, 3])),
          ),
        ),
      ],
    );

    blocTest(
      'Success auth after failed auth',
      build: () => cubit,
      act: (AuthCubit cubit) async {
        final salt = Uint8List.fromList([1, 2, 3]);
        const password = 'password';
        final info = PasswordInfo(
          id: 'test',
          hash: 'hash',
          salt: hex.encode(salt),
        );
        when(
          () => mockPasswordRepo.getByType(const PasswordType.encryptKey()),
        ).thenAnswer(
          (_) async => StorageResult(info),
        );
        when(() => mockDateTimeProvider.now()).thenReturn(DateTime(2021));

        await cubit.loadPassword();

        when(
          () => mockHasher.calculate(
            password: password,
            salt: salt,
          ),
        ).thenAnswer((_) async => 'another_hash');
        await cubit.auth(password);

        when(
          () => mockHasher.calculate(
            password: password,
            salt: salt,
          ),
        ).thenAnswer((_) async => info.hash);
        await cubit.auth(password);
      },
      expect: () => [
        AuthState.passwordLoaded(
          info: PasswordInfo(
            id: 'test',
            hash: 'hash',
            salt: hex.encode(Uint8List.fromList([1, 2, 3])),
          ),
        ),
        AuthState.authInProgress(
          info: PasswordInfo(
            id: 'test',
            hash: 'hash',
            salt: hex.encode(Uint8List.fromList([1, 2, 3])),
          ),
        ),
        AuthState.authFailed(
          info: PasswordInfo(
            id: 'test',
            hash: 'hash',
            salt: hex.encode(Uint8List.fromList([1, 2, 3])),
          ),
          reason: const AuthError.wrongPassword(),
        ),
        AuthState.authInProgress(
          info: PasswordInfo(
            id: 'test',
            hash: 'hash',
            salt: hex.encode(Uint8List.fromList([1, 2, 3])),
          ),
        ),
        AuthState.authSuccess(
          info: PasswordInfo(
            id: 'test',
            hash: 'hash',
            salt: hex.encode(Uint8List.fromList([1, 2, 3])),
          ),
        ),
      ],
    );

    blocTest(
      'Password is empty',
      build: () => cubit,
      act: (AuthCubit cubit) async {
        when(
          () => mockPasswordRepo.getByType(const PasswordType.encryptKey()),
        ).thenAnswer(
          (_) async => const StorageResult(
            PasswordInfo(
              id: 'test',
              hash: 'hash',
              salt: 'salt',
            ),
          ),
        );
        await cubit.loadPassword();
        await cubit.auth('');
      },
      expect: () => [
        const AuthState.passwordLoaded(
          info: PasswordInfo(
            id: 'test',
            hash: 'hash',
            salt: 'salt',
          ),
        ),
        const AuthState.authInProgress(
          info: PasswordInfo(
            id: 'test',
            hash: 'hash',
            salt: 'salt',
          ),
        ),
        const AuthState.authFailed(
          info: PasswordInfo(
            id: 'test',
            hash: 'hash',
            salt: 'salt',
          ),
          reason: AuthError.emptyPassword(),
        ),
      ],
    );
  });
}

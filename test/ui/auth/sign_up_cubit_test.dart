 
import 'package:blink_comparison/core/entity/entity.dart';
import 'package:blink_comparison/core/storage/password_repository.dart';
import 'package:blink_comparison/core/storage/storage_result.dart';
import 'package:blink_comparison/ui/auth/sign_up_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mock/mock.dart';

void main() {
  group('SignUpCubit |', () {
    late final PasswordRepository mockPasswordRepo;
    late SignUpCubit cubit;

    setUpAll(() {
      mockPasswordRepo = MockPasswordRepository();
    });

    setUp(() {
      cubit = SignUpCubit(mockPasswordRepo);
    });

    blocTest(
      'Initial state',
      build: () => cubit,
      expect: () => [],
    );

    blocTest(
      'Change password',
      build: () => cubit,
      act: (SignUpCubit cubit) {
        cubit.passwordChanged('123');
        cubit.passwordChanged('12345');
      },
      expect: () => [
        const SignUpState.passwordChanged(
          password: Password(value: '123'),
          repeatPassword: RepeatPassword(),
        ),
        const SignUpState.passwordChanged(
          password: Password(value: '12345'),
          repeatPassword: RepeatPassword(),
        ),
      ],
    );

    blocTest(
      'Change repeat password',
      build: () => cubit,
      act: (SignUpCubit cubit) {
        cubit.repeatPasswordChanged('123');
        cubit.repeatPasswordChanged('12345');
      },
      expect: () => [
        const SignUpState.passwordChanged(
          password: Password(),
          repeatPassword: RepeatPassword(value: '123'),
        ),
        const SignUpState.passwordChanged(
          password: Password(),
          repeatPassword: RepeatPassword(value: '12345'),
        ),
      ],
    );

    blocTest(
      'Submit empty password',
      build: () => cubit,
      act: (SignUpCubit cubit) async {
        await cubit.submit();
        cubit.repeatPasswordChanged('123');
        await cubit.submit();
      },
      expect: () => [
        const SignUpState.invalidPassword(
          password: Password(
            error: PasswordError.empty(),
          ),
          repeatPassword: RepeatPassword(
            error: RepeatPasswordError.empty(),
          ),
        ),
        const SignUpState.passwordChanged(
          password: Password(
            error: PasswordError.empty(),
          ),
          repeatPassword: RepeatPassword(value: '123'),
        ),
        const SignUpState.invalidPassword(
          password: Password(
            error: PasswordError.empty(),
          ),
          repeatPassword: RepeatPassword(value: '123'),
        )
      ],
    );

    blocTest(
      'Submit too short password',
      build: () => cubit,
      act: (SignUpCubit cubit) async {
        cubit.passwordChanged(List.filled(Password.minLength - 1, '0').join());
        cubit.repeatPasswordChanged('123');
        await cubit.submit();
      },
      expect: () => [
        SignUpState.passwordChanged(
          password: Password(
            value: List.filled(Password.minLength - 1, '0').join(),
          ),
          repeatPassword: const RepeatPassword(),
        ),
        SignUpState.passwordChanged(
          password: Password(
            value: List.filled(Password.minLength - 1, '0').join(),
          ),
          repeatPassword: const RepeatPassword(value: '123'),
        ),
        SignUpState.invalidPassword(
          password: Password(
            value: List.filled(Password.minLength - 1, '0').join(),
            error: const PasswordError.tooShort(),
          ),
          repeatPassword: const RepeatPassword(value: '123'),
        )
      ],
    );

    blocTest(
      'Submit too long password',
      build: () => cubit,
      act: (SignUpCubit cubit) async {
        cubit.passwordChanged(List.filled(Password.maxLength + 1, '0').join());
        cubit.repeatPasswordChanged('123');
        await cubit.submit();
      },
      expect: () => [
        SignUpState.passwordChanged(
          password: Password(
            value: List.filled(Password.maxLength + 1, '0').join(),
          ),
          repeatPassword: const RepeatPassword(),
        ),
        SignUpState.passwordChanged(
          password: Password(
            value: List.filled(Password.maxLength + 1, '0').join(),
          ),
          repeatPassword: const RepeatPassword(value: '123'),
        ),
        SignUpState.invalidPassword(
          password: Password(
            value: List.filled(Password.maxLength + 1, '0').join(),
            error: const PasswordError.tooLong(),
          ),
          repeatPassword: const RepeatPassword(value: '123'),
        )
      ],
    );

    blocTest(
      'Submit',
      build: () => cubit,
      act: (SignUpCubit cubit) async {
        const password = '12345';
        when(
          () => mockPasswordRepo.insert(
            type: const PasswordType.encryptKey(),
            password: password,
          ),
        ).thenAnswer(
          (_) async => const StorageResult(
            PasswordInfo(
              id: 'test',
              hash: 'hash',
              salt: 'salt',
            ),
          ),
        );
        cubit.passwordChanged(password);
        cubit.repeatPasswordChanged(password);
        await cubit.submit();
        verify(
          () => mockPasswordRepo.insert(
            type: const PasswordType.encryptKey(),
            password: password,
          ),
        ).called(1);
      },
      expect: () => [
        const SignUpState.passwordChanged(
          password: Password(value: '12345'),
          repeatPassword: RepeatPassword(),
        ),
        const SignUpState.passwordChanged(
          password: Password(value: '12345'),
          repeatPassword: RepeatPassword(value: '12345'),
        ),
        const SignUpState.savingPassword(),
        const SignUpState.passwordSaved(),
      ],
    );

    blocTest(
      'Password mismatch',
      build: () => cubit,
      act: (SignUpCubit cubit) async {
        const password = '12345';
        when(
          () => mockPasswordRepo.insert(
            type: const PasswordType.encryptKey(),
            password: password,
          ),
        ).thenAnswer(
          (_) async => const StorageResult(
            PasswordInfo(
              id: 'test',
              hash: 'hash',
              salt: 'salt',
            ),
          ),
        );
        cubit.passwordChanged(password);
        cubit.repeatPasswordChanged('123');
        await cubit.submit();
      },
      expect: () => [
        const SignUpState.passwordChanged(
          password: Password(value: '12345'),
          repeatPassword: RepeatPassword(),
        ),
        const SignUpState.passwordChanged(
          password: Password(value: '12345'),
          repeatPassword: RepeatPassword(value: '123'),
        ),
        const SignUpState.passwordMismatch(
          password: Password(value: '12345'),
          repeatPassword: RepeatPassword(
            value: '123',
            error: RepeatPasswordError.mismatch(),
          ),
        ),
      ],
    );

    blocTest(
      'Submit after failed saving',
      build: () => cubit,
      act: (SignUpCubit cubit) async {
        const password = '12345';
        when(
          () => mockPasswordRepo.insert(
            type: const PasswordType.encryptKey(),
            password: password,
          ),
        ).thenAnswer(
          (_) async => StorageResult.error(
            StorageError.database(
              exception: Exception('Failed to insert password'),
            ),
          ),
        );
        cubit.passwordChanged(password);
        cubit.repeatPasswordChanged(password);
        await cubit.submit();

        when(
          () => mockPasswordRepo.insert(
            type: const PasswordType.encryptKey(),
            password: password,
          ),
        ).thenAnswer(
          (_) async => const StorageResult(
            PasswordInfo(
              id: 'test',
              hash: 'hash',
              salt: 'salt',
            ),
          ),
        );
        await cubit.submit();
      },
      expect: () => [
        const SignUpState.passwordChanged(
          password: Password(value: '12345'),
          repeatPassword: RepeatPassword(),
        ),
        const SignUpState.passwordChanged(
          password: Password(value: '12345'),
          repeatPassword: RepeatPassword(value: '12345'),
        ),
        const SignUpState.savingPassword(),
        isA<SignUpStateSavePasswordFailed>(),
        const SignUpState.savingPassword(),
        const SignUpState.passwordSaved(),
      ],
    );

    blocTest(
      'Password changed after success saving',
      build: () => cubit,
      act: (SignUpCubit cubit) async {
        const password = '12345';
        when(
          () => mockPasswordRepo.insert(
            type: const PasswordType.encryptKey(),
            password: password,
          ),
        ).thenAnswer(
          (_) async => const StorageResult(
            PasswordInfo(
              id: 'test',
              hash: 'hash',
              salt: 'salt',
            ),
          ),
        );
        cubit.passwordChanged(password);
        cubit.repeatPasswordChanged(password);
        await cubit.submit();
        cubit.passwordChanged('123456');
      },
      expect: () => [
        const SignUpState.passwordChanged(
          password: Password(value: '12345'),
          repeatPassword: RepeatPassword(),
        ),
        const SignUpState.passwordChanged(
          password: Password(value: '12345'),
          repeatPassword: RepeatPassword(value: '12345'),
        ),
        const SignUpState.savingPassword(),
        const SignUpState.passwordSaved(),
      ],
    );
  });
}

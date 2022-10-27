
import 'package:blink_comparison/core/encrypt/encrypt.dart';
import 'package:blink_comparison/core/encrypt/encrypt_key_derivation.dart';
import 'package:injectable/injectable.dart';

abstract class EncryptModuleProvider {
  EncryptModule getByKey(SecureKey key);
}

@Singleton(as: EncryptModuleProvider)
class EncryptModuleProviderImpl implements EncryptModuleProvider {
  final EncryptKeyDerivation _derivation;

  EncryptModuleProviderImpl(this._derivation);

  @override
  EncryptModule getByKey(SecureKey key) {
    return key.when(
      password: (password) => PBEModule(password, _derivation),
    );
  }
}

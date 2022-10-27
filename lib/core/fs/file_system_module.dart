
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:injectable/injectable.dart';

@module
abstract class FileSystemModule {
  @injectable
  FileSystem get fs => const LocalFileSystem();
}

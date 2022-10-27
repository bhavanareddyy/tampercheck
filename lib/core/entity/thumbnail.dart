
import 'package:cross_file/cross_file.dart';
import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

@immutable
class Thumbnail extends Equatable {
  final String refImageId;

  final XFile file;

  const Thumbnail({
    required this.refImageId,
    required this.file,
  });

  @override
  List<Object?> get props => [refImageId];

  @override
  bool? get stringify => true;
}

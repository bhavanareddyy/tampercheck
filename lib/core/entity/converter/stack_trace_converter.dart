 
import 'package:freezed_annotation/freezed_annotation.dart';

class StackTraceConverter implements JsonConverter<StackTrace?, String?> {
  const StackTraceConverter();

  @override
  StackTrace? fromJson(String? json) =>
      json == null ? null : StackTrace.fromString(json);

  @override
  String? toJson(StackTrace? object) => object?.toString();
}

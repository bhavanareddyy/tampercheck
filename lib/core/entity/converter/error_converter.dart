 
import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

class ErrorConverter implements JsonConverter<Object, String> {
  const ErrorConverter();

  @override
  Object fromJson(String json) {
    try {
      return jsonDecode(json);
    } catch (e) {
      return json;
    }
  }

  @override
  String toJson(Object object) => object.toString();
}

class ExceptionConverter implements JsonConverter<Exception?, String?> {
  const ExceptionConverter();

  @override
  Exception? fromJson(String? json) {
    try {
      return json == null ? null : jsonDecode(json);
    } catch (e) {
      return _Exception(json);
    }
  }

  @override
  String? toJson(Object? object) => object?.toString();
}

class _Exception implements Exception {
  final dynamic message;

  _Exception(this.message);

  @override
  String toString() => "$message";
}

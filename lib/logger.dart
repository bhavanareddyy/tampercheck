
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

final _filter = kDebugMode ? DevelopmentFilter() : ProductionFilter();
const _level = kDebugMode ? Level.verbose : Level.info;

final _logger = Logger(
  printer: PrettyPrinter(),
  filter: _filter,
  level: _level,
);
final _loggerWithoutStack = Logger(
  printer: PrettyPrinter(methodCount: 0),
  filter: _filter,
  level: _level,
);

Logger log({bool withStack = true}) =>
    withStack ? _logger : _loggerWithoutStack;

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

void loggerSetup() {
  Logger.root.level = Level.ALL;
  hierarchicalLoggingEnabled = true;
  Logger.root.onRecord.listen((record) => debugPrint(
      '${record.level.name}: ${record.loggerName}: ${record.message}'));
}

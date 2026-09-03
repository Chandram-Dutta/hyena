import 'dart:async';
import 'dart:io';

import 'package:hyena_dart_adapter/hyena_dart_adapter.dart';

Future<void> main() async {
  try {
    await runZoned(
      runAdapterServer,
      zoneSpecification: ZoneSpecification(
        print: (self, parent, zone, line) => stderr.writeln(line),
      ),
    );
  } catch (error, stackTrace) {
    stderr.writeln('hyena-dart-adapter: $error');
    stderr.writeln(stackTrace);
    exitCode = 1;
  }
}

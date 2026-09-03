# Hyena Dart adapter

This package is the reference compiler-backed frontend for Dart. It runs as a supervised subprocess and communicates with the Rust host through experimental `hyena.adapter.v0` Protobuf frames on stdin/stdout.

Stdout is protocol-only. Human-readable diagnostics belong on stderr.

## Development

```bash
dart pub get
dart format --output=none --set-exit-if-changed .
dart analyze --fatal-infos
dart test
dart compile exe bin/hyena_dart_adapter.dart -o ../../target/hyena-dart-adapter
```

Generated Protobuf files are committed so consumers do not need `protoc`. To regenerate them, install `protoc`, run `dart pub global activate protoc_plugin`, and execute `../../tool/generate-dart-protocol.sh` from any directory.

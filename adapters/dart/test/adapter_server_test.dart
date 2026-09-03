import 'dart:io';

import 'package:fixnum/fixnum.dart';
import 'package:hyena_dart_adapter/hyena_dart_adapter.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

void main() {
  test('requires a compatible handshake before analysis', () async {
    final server = AdapterServer();
    final response = await server.handle(
      Envelope(
        requestId: Int64.ONE,
        analyzeRequest: AnalyzeRequest(workspaceRoot: '.', target: '.'),
      ),
    );

    expect(response.single.error.code, 'handshake_required');
  });

  test('returns one terminal error response when analysis fails', () async {
    final missingWorkspace = await Directory.systemTemp.createTemp(
      'hyena_missing_workspace_',
    );
    await missingWorkspace.delete();
    final server = AdapterServer();
    await server.handle(
      Envelope(
        requestId: Int64.ONE,
        hello: Hello(
          supportedVersions: [ProtocolVersion(major: 0, minor: 1)],
          maxFrameBytes: defaultMaxFrameBytes,
        ),
      ),
    );

    final responses = await server.handle(
      Envelope(
        requestId: Int64(2),
        analyzeRequest: AnalyzeRequest(
          workspaceRoot: missingWorkspace.path,
          target: '.',
        ),
      ),
    );

    expect(responses, hasLength(1));
    expect(responses.single.whichMessage(), Envelope_Message.error);
    expect(responses.single.error.code, 'analysis_failed');
  });

  test('negotiates v0.1 and streams ordered fact batches', () async {
    final fixture = await Directory.systemTemp.createTemp('hyena_server_');
    addTearDown(() => fixture.delete(recursive: true));
    await File(p.join(fixture.path, 'pubspec.yaml')).writeAsString('''
name: server_fixture
environment:
  sdk: ^3.10.0
''');
    final library = await Directory(p.join(fixture.path, 'lib')).create();
    await File(
      p.join(library.path, 'main.dart'),
    ).writeAsString('void main() {}');
    final pub = await Process.run(Platform.resolvedExecutable, [
      'pub',
      'get',
    ], workingDirectory: fixture.path);
    expect(pub.exitCode, 0, reason: '${pub.stderr}');

    final server = AdapterServer();
    final ready = await server.handle(
      Envelope(
        requestId: Int64.ONE,
        hello: Hello(
          supportedVersions: [ProtocolVersion(major: 0, minor: 1)],
          maxFrameBytes: defaultMaxFrameBytes,
        ),
      ),
    );
    expect(ready.single.whichMessage(), Envelope_Message.ready);
    expect(ready.single.ready.selectedVersion.minor, 1);

    final responses = await server.handle(
      Envelope(
        requestId: Int64(2),
        analyzeRequest: AnalyzeRequest(
          workspaceRoot: fixture.path,
          target: 'lib',
          variantId: 'default',
        ),
      ),
    );
    final batches = responses
        .where((response) => response.hasFactBatch())
        .map((response) => response.factBatch)
        .toList();

    expect(batches, isNotEmpty);
    expect(
      batches.map((batch) => batch.sequence.toInt()),
      List.generate(batches.length, (index) => index),
    );
    expect(responses.last.whichMessage(), Envelope_Message.complete);
    expect(
      responses.last.complete.status,
      CompletionStatus.COMPLETION_STATUS_PARTIAL,
    );
  });
}

import 'dart:io';
import 'dart:math' as math;

import 'package:fixnum/fixnum.dart';

import 'dart_semantic_analyzer.dart';
import 'framing.dart';
import 'generated/hyena_adapter.pb.dart';

const protocolMajor = 0;
const protocolMinor = 1;
const adapterVersion = '0.0.1';

const _capabilities = <(String, int)>[
  ('hyena.artifacts', 1),
  ('hyena.semantic.symbols', 1),
  ('hyena.semantic.retention', 1),
  ('hyena.semantic.roots', 1),
];

class AdapterServer {
  final DartSemanticAnalyzer analyzer;
  var _negotiated = false;
  var _maxFrameBytes = defaultMaxFrameBytes;

  AdapterServer({DartSemanticAnalyzer? analyzer})
    : analyzer = analyzer ?? DartSemanticAnalyzer();

  int get maxFrameBytes => _maxFrameBytes;

  Future<List<Envelope>> handle(Envelope request) async {
    switch (request.whichMessage()) {
      case Envelope_Message.hello:
        return [_handleHello(request)];
      case Envelope_Message.analyzeRequest:
        if (!_negotiated) {
          return [_error(request.requestId, 'handshake_required', false)];
        }
        return _handleAnalyze(request);
      case Envelope_Message.cancel:
        return [_error(request.requestId, 'no_active_request', false)];
      case Envelope_Message.ready:
      case Envelope_Message.complete:
      case Envelope_Message.error:
      case Envelope_Message.factBatch:
      case Envelope_Message.notSet:
        return [_error(request.requestId, 'unexpected_message', false)];
    }
  }

  Envelope _handleHello(Envelope request) {
    final hello = request.hello;
    final compatible = hello.supportedVersions.any(
      (version) =>
          version.major == protocolMajor && version.minor >= protocolMinor,
    );
    if (!compatible) {
      return _error(request.requestId, 'incompatible_protocol', false);
    }

    _maxFrameBytes = math.min(
      defaultMaxFrameBytes,
      hello.maxFrameBytes == 0 ? defaultMaxFrameBytes : hello.maxFrameBytes,
    );
    _negotiated = true;
    return Envelope(
      requestId: request.requestId,
      ready: Ready(
        adapter: AdapterInfo(
          name: 'hyena-dart-adapter',
          version: adapterVersion,
          buildId: adapterVersion,
        ),
        selectedVersion: ProtocolVersion(
          major: protocolMajor,
          minor: protocolMinor,
        ),
        capabilities: [
          for (final (id, version) in _capabilities)
            Capability(id: id, version: version),
        ],
      ),
    );
  }

  Future<List<Envelope>> _handleAnalyze(Envelope request) async {
    try {
      final facts = await analyzer.analyze(request.analyzeRequest);
      final responses = <Envelope>[];
      var sequence = 0;

      void addBatch(FactBatch batch) {
        batch.sequence = Int64(sequence++);
        responses.add(Envelope(requestId: request.requestId, factBatch: batch));
      }

      for (final artifact in facts.artifacts) {
        addBatch(FactBatch(artifacts: [artifact]));
      }
      for (final chunk in _chunks(facts.symbols, 500)) {
        addBatch(FactBatch(symbols: chunk));
      }
      for (final chunk in _chunks(facts.retentionEdges, 500)) {
        addBatch(FactBatch(retentionEdges: chunk));
      }
      for (final chunk in _chunks(facts.roots, 500)) {
        addBatch(FactBatch(roots: chunk));
      }
      for (final chunk in _chunks(facts.diagnostics, 100)) {
        addBatch(FactBatch(diagnostics: chunk));
      }
      responses.add(
        Envelope(
          requestId: request.requestId,
          complete: Complete(
            status: facts.isPartial
                ? CompletionStatus.COMPLETION_STATUS_PARTIAL
                : CompletionStatus.COMPLETION_STATUS_SUCCEEDED,
            dimensions: facts.completeness,
          ),
        ),
      );
      return responses;
    } catch (error, stackTrace) {
      stderr.writeln('Dart adapter analysis failed: $error');
      stderr.writeln(stackTrace);
      return [_error(request.requestId, 'analysis_failed', false, '$error')];
    }
  }

  Envelope _error(
    Int64 requestId,
    String code,
    bool retryable, [
    String? message,
  ]) => Envelope(
    requestId: requestId,
    error: AdapterError(
      code: code,
      message: message ?? code,
      retryable: retryable,
    ),
  );
}

Iterable<List<T>> _chunks<T>(List<T> values, int size) sync* {
  for (var start = 0; start < values.length; start += size) {
    final end = math.min(start + size, values.length);
    yield values.sublist(start, end);
  }
}

Future<void> runAdapterServer({
  Stream<List<int>>? input,
  IOSink? output,
}) async {
  final server = AdapterServer();
  final reader = EnvelopeReader(input ?? stdin);
  final sink = output ?? stdout;

  while (true) {
    final request = await reader.read(maxFrameBytes: server.maxFrameBytes);
    if (request == null) return;
    for (final response in await server.handle(request)) {
      sink.add(
        encodeEnvelopeFrame(response, maxFrameBytes: server.maxFrameBytes),
      );
      await sink.flush();
    }
  }
}

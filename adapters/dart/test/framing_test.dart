import 'dart:async';

import 'package:fixnum/fixnum.dart';
import 'package:hyena_dart_adapter/hyena_dart_adapter.dart';
import 'package:test/test.dart';

void main() {
  Envelope hello() => Envelope(
    requestId: Int64.ONE,
    hello: Hello(
      engineName: 'hyena',
      engineVersion: '0.1.0',
      supportedVersions: [ProtocolVersion(major: 0, minor: 1)],
      maxFrameBytes: defaultMaxFrameBytes,
    ),
  );

  test('round trips frames split across arbitrary chunks', () async {
    final expected = hello();
    final frame = encodeEnvelopeFrame(expected);
    final chunks = <List<int>>[
      frame.sublist(0, 1),
      frame.sublist(1, 4),
      frame.sublist(4, 9),
      frame.sublist(9),
    ];
    final reader = EnvelopeReader(Stream.fromIterable(chunks));

    final actual = await reader.read();

    expect(actual, expected);
    expect(await reader.read(), isNull);
  });

  test('rejects an oversized frame before reading its payload', () async {
    final frame = encodeEnvelopeFrame(hello());
    final reader = EnvelopeReader(Stream.value(frame));

    await expectLater(
      reader.read(maxFrameBytes: 1),
      throwsA(isA<FrameException>()),
    );
  });

  test('rejects a truncated prefix', () async {
    final reader = EnvelopeReader(Stream.value([0, 0]));

    await expectLater(reader.read(), throwsA(isA<FrameException>()));
  });

  test('rejects envelopes without an identity or message', () {
    expect(
      () => encodeEnvelopeFrame(Envelope()),
      throwsA(isA<FrameException>()),
    );
  });
}

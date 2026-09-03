import 'dart:async';
import 'dart:typed_data';

import 'generated/hyena_adapter.pb.dart';

const defaultMaxFrameBytes = 4 * 1024 * 1024;

Uint8List encodeEnvelopeFrame(
  Envelope envelope, {
  int maxFrameBytes = defaultMaxFrameBytes,
}) {
  _validateEnvelope(envelope);
  final payload = envelope.writeToBuffer();
  if (payload.length > maxFrameBytes || payload.length > 0xffffffff) {
    throw FrameException(
      'adapter frame is ${payload.length} bytes, exceeding the '
      '$maxFrameBytes-byte limit',
    );
  }

  final frame = Uint8List(4 + payload.length);
  ByteData.sublistView(frame).setUint32(0, payload.length, Endian.big);
  frame.setRange(4, frame.length, payload);
  return frame;
}

class EnvelopeReader {
  final StreamIterator<List<int>> _chunks;
  List<int> _current = const [];
  int _offset = 0;

  EnvelopeReader(Stream<List<int>> input) : _chunks = StreamIterator(input);

  Future<Envelope?> read({int maxFrameBytes = defaultMaxFrameBytes}) async {
    final prefix = await _readExact(4, allowCleanEof: true);
    if (prefix == null) return null;

    final frameBytes = ByteData.sublistView(prefix).getUint32(0, Endian.big);
    if (frameBytes > maxFrameBytes) {
      throw FrameException(
        'adapter frame is $frameBytes bytes, exceeding the '
        '$maxFrameBytes-byte limit',
      );
    }

    final payload = await _readExact(frameBytes, allowCleanEof: false);
    try {
      final envelope = Envelope.fromBuffer(payload!);
      _validateEnvelope(envelope);
      return envelope;
    } on FrameException {
      rethrow;
    } catch (error) {
      throw FrameException('adapter protocol decoding failed: $error');
    }
  }

  Future<Uint8List?> _readExact(
    int length, {
    required bool allowCleanEof,
  }) async {
    final result = Uint8List(length);
    var written = 0;
    while (written < length) {
      if (_offset == _current.length) {
        if (!await _chunks.moveNext()) {
          if (allowCleanEof && written == 0) return null;
          throw FrameException(
            'adapter protocol ended after $written of $length expected bytes',
          );
        }
        _current = _chunks.current;
        _offset = 0;
        if (_current.isEmpty) continue;
      }

      final available = _current.length - _offset;
      final take = available < length - written ? available : length - written;
      result.setRange(written, written + take, _current, _offset);
      written += take;
      _offset += take;
    }
    return result;
  }
}

void _validateEnvelope(Envelope envelope) {
  if (envelope.requestId.isZero) {
    throw const FrameException('request_id must be greater than zero');
  }
  if (envelope.whichMessage() == Envelope_Message.notSet) {
    throw const FrameException('envelope message must be present');
  }
}

class FrameException implements Exception {
  final String message;

  const FrameException(this.message);

  @override
  String toString() => 'FrameException: $message';
}

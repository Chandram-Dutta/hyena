#![forbid(unsafe_code)]

use std::io::{self, Read, Write};

use prost::Message;
use thiserror::Error;

pub mod adapter {
    include!(concat!(env!("OUT_DIR"), "/hyena.adapter.v0.rs"));
}

pub const PROTOCOL_MAJOR: u32 = 0;
pub const PROTOCOL_MINOR: u32 = 1;
pub const DEFAULT_MAX_FRAME_BYTES: usize = 4 * 1024 * 1024;

/// Writes one big-endian u32 length-delimited Protobuf envelope.
pub fn write_envelope(
    mut writer: impl Write,
    envelope: &adapter::Envelope,
    max_frame_bytes: usize,
) -> Result<(), FrameError> {
    validate_envelope(envelope)?;

    let encoded_len = envelope.encoded_len();
    if encoded_len > max_frame_bytes || encoded_len > u32::MAX as usize {
        return Err(FrameError::FrameTooLarge { frame_bytes: encoded_len, max_frame_bytes });
    }

    let payload = envelope.encode_to_vec();
    writer.write_all(&(encoded_len as u32).to_be_bytes())?;
    writer.write_all(&payload)?;
    writer.flush()?;
    Ok(())
}

/// Reads one framed envelope. A clean EOF before a frame returns `None`.
pub fn read_envelope(
    mut reader: impl Read,
    max_frame_bytes: usize,
) -> Result<Option<adapter::Envelope>, FrameError> {
    let mut prefix = [0_u8; 4];
    match reader.read(&mut prefix[..1]) {
        Ok(0) => return Ok(None),
        Ok(1) => {}
        Ok(_) => unreachable!("the read buffer contains one byte"),
        Err(error) => return Err(FrameError::Io(error)),
    }
    reader.read_exact(&mut prefix[1..])?;

    let frame_bytes = u32::from_be_bytes(prefix) as usize;
    if frame_bytes > max_frame_bytes {
        return Err(FrameError::FrameTooLarge { frame_bytes, max_frame_bytes });
    }

    let mut payload = vec![0_u8; frame_bytes];
    reader.read_exact(&mut payload)?;
    let envelope = adapter::Envelope::decode(payload.as_slice())?;
    validate_envelope(&envelope)?;
    Ok(Some(envelope))
}

fn validate_envelope(envelope: &adapter::Envelope) -> Result<(), FrameError> {
    if envelope.request_id == 0 {
        return Err(FrameError::InvalidEnvelope("request_id must be greater than zero"));
    }
    if envelope.message.is_none() {
        return Err(FrameError::InvalidEnvelope("message must be present"));
    }
    Ok(())
}

#[derive(Debug, Error)]
pub enum FrameError {
    #[error("adapter protocol I/O failed: {0}")]
    Io(#[from] io::Error),
    #[error("adapter protocol decoding failed: {0}")]
    Decode(#[from] prost::DecodeError),
    #[error("adapter frame is {frame_bytes} bytes, exceeding the {max_frame_bytes}-byte limit")]
    FrameTooLarge { frame_bytes: usize, max_frame_bytes: usize },
    #[error("invalid adapter envelope: {0}")]
    InvalidEnvelope(&'static str),
}

#[cfg(test)]
mod tests {
    use std::io::Cursor;

    use super::{adapter, *};

    fn hello_envelope() -> adapter::Envelope {
        adapter::Envelope {
            request_id: 1,
            message: Some(adapter::envelope::Message::Hello(adapter::Hello {
                engine_name: "hyena".to_owned(),
                engine_version: "0.1.0".to_owned(),
                supported_versions: vec![adapter::ProtocolVersion {
                    major: PROTOCOL_MAJOR,
                    minor: PROTOCOL_MINOR,
                }],
                max_frame_bytes: DEFAULT_MAX_FRAME_BYTES as u32,
            })),
        }
    }

    #[test]
    fn frame_round_trip_preserves_the_envelope() {
        let envelope = hello_envelope();
        let mut frame = Vec::new();
        write_envelope(&mut frame, &envelope, DEFAULT_MAX_FRAME_BYTES)
            .expect("fixture envelope must encode");

        let decoded = read_envelope(Cursor::new(frame), DEFAULT_MAX_FRAME_BYTES)
            .expect("fixture frame must decode")
            .expect("fixture contains one frame");

        assert_eq!(decoded, envelope);
    }

    #[test]
    fn clean_eof_is_not_a_protocol_error() {
        assert_eq!(
            read_envelope(Cursor::new(Vec::<u8>::new()), DEFAULT_MAX_FRAME_BYTES)
                .expect("clean EOF must be accepted"),
            None
        );
    }

    #[test]
    fn oversized_frame_is_rejected_before_allocation() {
        let prefix = ((DEFAULT_MAX_FRAME_BYTES + 1) as u32).to_be_bytes();
        assert!(matches!(
            read_envelope(Cursor::new(prefix), DEFAULT_MAX_FRAME_BYTES),
            Err(FrameError::FrameTooLarge { .. })
        ));
    }

    #[test]
    fn envelope_requires_an_identity_and_message() {
        let invalid = adapter::Envelope { request_id: 0, message: None };
        assert!(matches!(
            write_envelope(Vec::new(), &invalid, DEFAULT_MAX_FRAME_BYTES),
            Err(FrameError::InvalidEnvelope(_))
        ));
    }
}

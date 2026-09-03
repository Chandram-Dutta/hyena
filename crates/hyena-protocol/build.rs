use std::{error::Error, path::PathBuf};

fn main() -> Result<(), Box<dyn Error>> {
    let manifest_dir = PathBuf::from(std::env::var("CARGO_MANIFEST_DIR")?);
    let proto_root = manifest_dir.join("../../proto");
    let adapter_proto = proto_root.join("hyena_adapter.proto");

    println!("cargo:rerun-if-changed={}", adapter_proto.display());

    let mut config = prost_build::Config::new();
    config.protoc_executable(protoc_bin_vendored::protoc_bin_path()?);
    config.compile_protos(&[adapter_proto], &[proto_root])?;
    Ok(())
}

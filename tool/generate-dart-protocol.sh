#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
output="$repo_root/adapters/dart/lib/src/generated"
protoc="${PROTOC:-protoc}"

if ! command -v "$protoc" >/dev/null 2>&1 && [[ ! -x "$protoc" ]]; then
  printf 'protoc was not found; set PROTOC to an executable path\n' >&2
  exit 1
fi
if ! command -v protoc-gen-dart >/dev/null 2>&1; then
  printf 'protoc-gen-dart was not found; run dart pub global activate protoc_plugin\n' >&2
  exit 1
fi

mkdir -p "$output"
"$protoc" \
  --proto_path="$repo_root/proto" \
  --dart_out="$output" \
  "$repo_root/proto/hyena_adapter.proto"
dart format "$output"

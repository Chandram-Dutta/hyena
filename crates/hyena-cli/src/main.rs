#![forbid(unsafe_code)]

use std::{
    fs,
    io::{self, Write},
    path::PathBuf,
    process::ExitCode,
};

use clap::{Parser, Subcommand, ValueEnum};
use hyena_protocol::{PROTOCOL_MAJOR, PROTOCOL_MINOR};
use hyena_syntax::{SyntaxError, SyntaxLanguage, parse_summary};
use thiserror::Error;

#[derive(Debug, Parser)]
#[command(
    name = "hyena",
    version,
    about = "Fast, reliable multi-language static analysis",
    long_about = "Hyena is an experimental multi-language static-analysis engine. Phase 0 provides a validated core model, an experimental adapter handshake, and syntax inspection; semantic dead-code analysis is not exposed yet."
)]
struct Cli {
    #[command(subcommand)]
    command: Command,
}

#[derive(Debug, Subcommand)]
enum Command {
    /// Show installed engine capabilities and experimental protocol version.
    Doctor,
    /// Parse one file using a bundled Tree-sitter grammar.
    Syntax {
        #[arg(value_enum, long)]
        language: LanguageArgument,
        path: PathBuf,
    },
}

#[derive(Clone, Copy, Debug, ValueEnum)]
enum LanguageArgument {
    Dart,
}

impl From<LanguageArgument> for SyntaxLanguage {
    fn from(language: LanguageArgument) -> Self {
        match language {
            LanguageArgument::Dart => Self::Dart,
        }
    }
}

fn main() -> ExitCode {
    match run(Cli::parse()) {
        Ok(()) => ExitCode::SUCCESS,
        Err(error) => {
            eprintln!("hyena: {error}");
            ExitCode::FAILURE
        }
    }
}

fn run(cli: Cli) -> Result<(), CliError> {
    match cli.command {
        Command::Doctor => {
            println!("Hyena {}", env!("CARGO_PKG_VERSION"));
            println!("adapter protocol: {PROTOCOL_MAJOR}.{PROTOCOL_MINOR} (experimental)");
            println!("syntax languages: dart");
            println!("semantic adapters: none (Phase 0)");
            Ok(())
        }
        Command::Syntax { language, path } => {
            let source = fs::read(&path)
                .map_err(|source| CliError::ReadSource { path: path.clone(), source })?;
            let summary = parse_summary(language.into(), &source)?;
            let stdout = io::stdout();
            let mut output = stdout.lock();
            serde_json::to_writer_pretty(&mut output, &summary)?;
            writeln!(output)?;
            Ok(())
        }
    }
}

#[derive(Debug, Error)]
enum CliError {
    #[error("could not read {path}: {source}")]
    ReadSource { path: PathBuf, source: io::Error },
    #[error(transparent)]
    Syntax(#[from] SyntaxError),
    #[error("could not serialize syntax summary: {0}")]
    Serialize(#[from] serde_json::Error),
    #[error("could not write command output: {0}")]
    Write(#[from] io::Error),
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn language_arguments_map_to_syntax_languages() {
        assert_eq!(SyntaxLanguage::from(LanguageArgument::Dart), SyntaxLanguage::Dart);
    }
}

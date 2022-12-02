FROM rust as builder
RUN rustup toolchain add nightly
RUN rustup default nightly
RUN cargo +nightly install -f cargo-fuzz

ADD . /parity-signer
WORKDIR /parity-signer/rust/qr_reader_phone/fuzz

RUN cargo fuzz build fuzz_parser

# Package Stage
FROM ubuntu:20.04

COPY --from=builder /parity-signer/rust/qr_reader_phone/fuzz/target/x86_64-unknown-linux-gnu/release/fuzz_parser /
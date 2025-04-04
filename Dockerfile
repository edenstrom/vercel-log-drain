ARG RUST_VERSION=1.80.0
ARG BUILD_ARGS=""

FROM rust:${RUST_VERSION}-slim-bookworm AS builder
WORKDIR /app
COPY Cargo.lock Cargo.toml /app/
COPY src /app/src/
ARG BUILD_ARGS
RUN set -eux && \
    cargo build --release ${BUILD_ARGS} && \
    cp ./target/release/vercel-log-drain /vercel-log-drain

FROM debian:bookworm-slim
RUN apt-get update && apt-get install -y ca-certificates
COPY --from=builder /vercel-log-drain /usr/local/bin/vercel-log-drain
ENTRYPOINT [ "vercel-log-drain" ]

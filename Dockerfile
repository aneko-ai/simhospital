# syntax=docker/dockerfile:1.6

########################
# Build stage
########################
FROM golang:1.22-bookworm AS builder

# Use GOPATH mode because the repo has no go.mod/go.sum
ENV GO111MODULE=off

# Place code at its canonical GOPATH path so imports work
WORKDIR /go/src/github.com/google/simhospital

# Copy the entire repo into place
COPY . .

# Build the simulator binary for the current architecture
# (no cross-compilation here – let Docker pick the arch)
RUN CGO_ENABLED=0 go build -o /out/health/simulator ./cmd/simulator

########################
# Runtime stage
########################
FROM debian:bookworm-slim

# Minimal runtime deps + non-root user
RUN useradd -u 10001 -r -s /usr/sbin/nologin simhospital \
 && apt-get update \
 && apt-get install -y --no-install-recommends ca-certificates \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /

# Copy the built binary to /health/simulator (matches original images)
COPY --from=builder /out/health /health

# Copy configs and web assets so the dashboard + default pathways work
COPY --from=builder /go/src/github.com/google/simhospital/configs /configs
COPY --from=builder /go/src/github.com/google/simhospital/web     /web

USER simhospital

EXPOSE 8000

# By default this starts the simulator with its built-in config & dashboard
ENTRYPOINT ["/health/simulator"]
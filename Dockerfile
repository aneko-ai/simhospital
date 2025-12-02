# syntax=docker/dockerfile:1.6

########################
# Build stage
########################
FROM golang:1.22-bookworm AS builder

WORKDIR /src

# Use the module files first for better caching
COPY go.mod go.sum ./
RUN go mod download

# Now bring in the rest of the source
COPY . .

# Let buildx inject target OS/arch; sensible defaults for plain docker build
ARG TARGETOS=linux
ARG TARGETARCH=amd64

# Build the simulator binary
# This corresponds to the cmd/simulator command documented for SimHospital.
RUN CGO_ENABLED=0 GOOS=$TARGETOS GOARCH=$TARGETARCH \
    go build -o /out/health/simulator ./cmd/simulator

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
COPY --from=builder /src/configs /configs
COPY --from=builder /src/web     /web

USER simhospital

EXPOSE 8000

# By default this starts the simulator with its built-in config & dashboard
ENTRYPOINT ["/health/simulator"]
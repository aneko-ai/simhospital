# ========= Builder =========
FROM golang:1.25-bookworm AS builder

WORKDIR /app

# Copy the repo into the container
COPY . .

# If there is no go.mod (original repo), create one and tidy deps only inside the image.
RUN if [ ! -f go.mod ]; then \
      go mod init github.com/google/simhospital && \
      go mod tidy; \
    fi

# Build the simulator binary
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 \
    go build -o /app/simhospital ./cmd/simulator

# ========= Runtime =========
FROM debian:bookworm-slim

RUN useradd -u 10001 -r -s /usr/sbin/nologin simhospital \
 && apt-get update \
 && apt-get install -y --no-install-recommends ca-certificates curl \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy binary and configs
COPY --from=builder /app/simhospital /usr/local/bin/simhospital
COPY configs ./configs
COPY web ./web

USER simhospital

# Dashboard + metrics ports
EXPOSE 8000 9095

# Run the actual simulator engine by default
ENTRYPOINT ["/usr/local/bin/simhospital", "health/simulator"]

# Default: start dashboard + metrics
CMD ["-dashboard_address=:8000", "-dashboard_uri=simulated-hospital", "-metrics_listen_address=:9095"]
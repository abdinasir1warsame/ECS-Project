# Stage 1: build
FROM golang:1.25-alpine AS builder
WORKDIR /app
COPY ./app/memos/go.mod ./app/memos/go.sum ./
RUN go mod download
COPY ./app/memos/cmd/memos ./cmd/memos
COPY ./app/memos/server/ ./server/
COPY ./app/memos/internal/ ./internal/
COPY ./app/memos/plugin/ ./plugin/
COPY ./app/memos/proto/ ./proto/
COPY ./app/memos/store/ ./store/
# Build the binary
RUN CGO_ENABLED=0 GOOS=linux go build -o /docker-gs-ping ./cmd/memos

# Stage 2: runtime
FROM alpine:3.20
WORKDIR /app

# Copy binary from builder
COPY --from=builder /docker-gs-ping /app/memos-server
RUN chmod +x /app/memos-server

# Create non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
RUN mkdir -p /app/data && chown -R appuser:appgroup /app

# Expose the correct port
EXPOSE 8081 

# Switch to non-root user
USER appuser

# Run with proper port configuration
CMD ["/app/memos-server", "--port", "8081", "--mode", "prod", "--data", "/app/data"]

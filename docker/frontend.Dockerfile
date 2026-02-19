# =========================
# Stage 1: Build React app
# =========================
FROM node:20-alpine AS builder

WORKDIR /app

COPY ./app/memos/web/package.json ./
RUN npm install

COPY ./app/memos/web/ ./
RUN npm run build

# =========================
# Stage 2: Nginx runtime
# =========================
FROM nginx:alpine

# Install envsubst for runtime env var substitution
RUN apk add --no-cache gettext

# Remove default config
RUN rm /etc/nginx/conf.d/default.conf

# Copy nginx config AS a template (no need to rename on disk)
COPY ./docker/nginx.conf /etc/nginx/templates/nginx.conf.template

# Copy built frontend files
COPY --from=builder /app/dist /usr/share/nginx/html

# Expose non-privileged port
EXPOSE 8080

# Generate nginx config at runtime and start nginx
CMD ["/bin/sh", "-c", "envsubst '${BACKEND_API_URL}' < /etc/nginx/templates/nginx.conf.template > /etc/nginx/conf.d/default.conf && nginx -g 'daemon off;'"]

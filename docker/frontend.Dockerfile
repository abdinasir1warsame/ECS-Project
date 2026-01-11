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

# Remove default config
RUN rm /etc/nginx/conf.d/default.conf

# Copy custom config
COPY ./docker/nginx.conf /etc/nginx/conf.d/

# Copy built files
COPY --from=builder /app/dist /usr/share/nginx/html

# Nginx already runs as nginx user in alpine image
# Expose port
EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]
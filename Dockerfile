# --------- Build stage ---------
FROM node:18-alpine AS builder

WORKDIR /app

# Copy dependency files and install
COPY package.json package-lock.json ./
RUN npm ci

# Copy all source code
COPY . .

# Build Vite app (outputs to /app/dist)
RUN npm run build

# --------- Nginx stage ---------
FROM nginx:stable-alpine

# Copy built files from /app/dist to Nginx HTML folder
COPY --from=builder /app/dist /usr/share/nginx/html

# Optional: custom Nginx config for SPA routing
# Make sure nginx.conf exists in the same folder as Dockerfile
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]

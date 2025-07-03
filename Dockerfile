FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install curl, nginx, and nodejs
RUN apt-get update && \
    apt-get install -y curl gnupg2 ca-certificates nginx && \
    curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - && \
    apt-get install -y nodejs

# Set working directory
WORKDIR /app

# Copy Node.js app
COPY app.js .
COPY package.json .
RUN npm install

# Copy nginx config
COPY nginx.conf /etc/nginx/nginx.conf

# Expose ports inside container
EXPOSE 80
EXPOSE 443

# Start services
CMD service nginx start && npm start

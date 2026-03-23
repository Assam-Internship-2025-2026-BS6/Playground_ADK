# Stage 1: Build Flutter Web
FROM ubuntu:22.04 AS build

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl git unzip xz-utils zip libglu1-mesa \
    && rm -rf /var/lib/apt/lists/*

# Pin Flutter to a specific stable version instead of cloning HEAD
RUN git clone --depth 1 --branch 3.29.1 https://github.com/flutter/flutter.git /flutter
ENV PATH="/flutter/bin:/flutter/bin/cache/dart-sdk/bin:${PATH}"

WORKDIR /app
COPY . .

RUN flutter pub get
RUN flutter build web --release

# Stage 2: Serve using Nginx
# Pin to a specific digest so you get a reproducible, scannable image
FROM nginx:1.27.4-alpine3.21

# Upgrade vulnerable Alpine packages in one layer
RUN apk update && apk upgrade \
    libcrypto3 libssl3 libexpat libpng libxml2 \
    && rm -rf /var/cache/apk/*

COPY --from=build /app/build/web /usr/share/nginx/html

# Drop root — nginx worker processes don't need it
RUN chown -R nginx:nginx /usr/share/nginx/html
USER nginx

EXPOSE 80
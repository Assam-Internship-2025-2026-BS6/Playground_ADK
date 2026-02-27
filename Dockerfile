# Stage 1: Build Flutter Web
FROM ubuntu:22.04 as build

RUN apt update && apt install -y curl git unzip xz-utils zip libglu1-mesa

# Install Flutter
RUN git clone https://github.com/flutter/flutter.git /flutter
ENV PATH="/flutter/bin:/flutter/bin/cache/dart-sdk/bin:${PATH}"

WORKDIR /app

# Copy playground project
COPY . .

RUN flutter pub get
RUN flutter build web --release

# Stage 2: Serve using Nginx
FROM nginx:alpine
COPY --from=build /app/build/web /usr/share/nginx/html
EXPOSE 80 
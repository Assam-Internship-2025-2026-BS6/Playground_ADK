# Stage 1: Build Flutter Web
FROM ubuntu:22.04 as build

RUN apt update && apt install -y curl git unzip xz-utils zip libglu1-mesa

RUN git clone https://github.com/flutter/flutter.git /flutter

ENV PATH="/flutter/bin:/flutter/bin/cache/dart-sdk/bin:${PATH}"

WORKDIR /app

COPY . .

RUN flutter pub get
RUN flutter build web --release


# Stage 2: Serve using Nginx
FROM nginx:1.27-alpine

COPY --from=build /app/build/web /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

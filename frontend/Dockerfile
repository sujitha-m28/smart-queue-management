FROM ubuntu:24.04 AS build

WORKDIR /app

RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    xz-utils \
    zip \
    libglu1-mesa \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/flutter/flutter.git \
    -b 3.47.5 \
    --depth 1 /flutter

ENV PATH="/flutter/bin:/flutter/bin/cache/dart-sdk/bin:$PATH"

RUN flutter doctor
RUN flutter config --enable-web

COPY pubspec.* ./
RUN flutter pub get

COPY . .

RUN flutter build web --release

FROM nginx:alpine

COPY --from=build /app/build/web /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]

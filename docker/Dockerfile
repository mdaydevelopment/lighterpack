FROM node:16-bullseye-slim

ENV HOSTNAME=lighterpack

WORKDIR /var/www/lighterpack

# Install dependencies first for better layer caching.
# Dev dependencies are required: app.js requires webpack/webpack-dev-server at runtime.
COPY package.json package-lock.json ./
RUN npm ci

COPY . .

# Build production assets (public/dist), required when running with
# config environment=production
RUN npm run build

# Web
EXPOSE 3000

CMD ["node", "app.js"]

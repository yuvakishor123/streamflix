# Step 1: Build React app
FROM node:16.17.0-alpine AS builder

WORKDIR /app

COPY package.json ./
COPY yarn.lock* package-lock.json* ./

RUN if [ -f yarn.lock ]; then yarn install --frozen-lockfile; \
    else npm install; fi

COPY . .

ARG TMDB_V3_API_KEY
ENV VITE_APP_TMDB_V3_API_KEY=${TMDB_V3_API_KEY}
ENV VITE_APP_API_ENDPOINT_URL="https://api.themoviedb.org/3"

RUN yarn build || npm run build

# Step 2: Serve with Nginx
FROM nginx:stable-alpine

COPY --from=builder /app/dist /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

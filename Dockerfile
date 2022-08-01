FROM node:16-alpine AS base

WORKDIR /app
COPY package*.json ./
RUN npm install && npm cache clean --force

WORKDIR /app
COPY . .
RUN npm run build

FROM node:16-alpine AS application
COPY --from=base /app/package*.json ./
RUN npm i --only=production
RUN npm i pm2 -g
COPY --from=base /app/dist ./dist

USER node
ENV PORT=8080
EXPOSE 8080
ENTRYPOINT ["pm2-runtime", "dist/main.js"]
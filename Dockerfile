FROM node:22-slim

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY app ./app
COPY .env .env

EXPOSE 8000
CMD ["node", "app/server.js"]

# Build dan Jalankan Docker
# docker build -t restful-ai .
# docker run -d -p 8000:8000 --name ai-api-node restful-ai

# =====================================================================
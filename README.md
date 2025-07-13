# revisi kode



## Struktur project:
```bash
Restful-API-nodejs/
├── app/
│   ├── controllers/
│   │   └── aiController.js
│   ├── middlewares/
│   │   ├── auth.js
│   │   └── validatePrompt.js
│   ├── routes/
│   │   └── apiRoutes.js
│   ├── utils/
│   │   └── hfClient.js
│   └── server.js
├── .env
├── package.json
└── README.md
```
---
## start.sh (versi embed-ready)
```bash
#!/bin/bash

# === Load variabel dari .env (jika tidak diset dari luar) ===
if [ -f .env ]; then
  export $(grep -v '^#' .env | xargs)
fi

# === Validasi ===
if [ -z "$PORT" ] || [ -z "$NGROK_AUTH_TOKEN" ]; then
  echo "❌ Pastikan .env atau environment berisi PORT dan NGROK_AUTH_TOKEN"
  exit 1
fi

# === Token ngrok ===
echo "🔐 Menambahkan token ngrok..."
ngrok config add-authtoken "$NGROK_AUTH_TOKEN"

# === Jalankan Node.js server di background ===
echo "🚀 Menjalankan server Node.js di port $PORT..."
node app/server.js &

# Tunggu server siap
sleep 3

# === Jalankan ngrok ===
if [ -n "$DOMAIN" ]; then
  echo "🌍 Menjalankan ngrok dengan domain: $DOMAIN"
  ngrok http --region=us --domain=$DOMAIN $PORT
else
  echo "🌍 Menjalankan ngrok dengan domain random..."
  ngrok http --region=us $PORT
fi
```
---
## Dockerfile (versi embed ngrok + Node.js)
```bash
# Gunakan base image Node.js
FROM node:22

# Install ngrok dan alat bantu
RUN apt update && apt install -y curl unzip \
 && curl -s https://ngrok-agent.s3.amazonaws.com/ngrok.asc | tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null \
 && echo "deb https://ngrok-agent.s3.amazonaws.com buster main" | tee /etc/apt/sources.list.d/ngrok.list \
 && apt update && apt install -y ngrok

# Set direktori kerja
WORKDIR /app

# Copy semua file ke container
COPY . .

# Install dependency project
RUN npm install

# Izin eksekusi untuk start.sh
RUN chmod +x start.sh

# Jalankan start.sh saat container dijalankan
CMD ["./start.sh"]
```
---

## build yang embed ngrok
```bash
docker build -t restful-ngrok-server .
```
## Jalankan Container
```bash
docker run -it --rm --env-file .env -p 8000:8000 restful-ngrok-server
```



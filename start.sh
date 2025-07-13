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

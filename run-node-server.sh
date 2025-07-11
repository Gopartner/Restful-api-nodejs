#!/bin/bash

# === Konfigurasi Awal ===
APP_NAME="Restful-API-Nodejs"
DOCKER_IMAGE="restful-ai-nodejs"
DOCKERFILE_PATH="."       # Folder Dockerfile
ENV_FILE=".env"
NGROK_REGION="us"

# === Load .env ===
if [ -f "$ENV_FILE" ]; then
  export $(grep -v '^#' "$ENV_FILE" | xargs)
else
  echo "❌ File .env tidak ditemukan!"
  exit 1
fi

# Validasi variabel penting
if [ -z "$PORT" ] || [ -z "$NGROK_AUTH_TOKEN" ]; then
  echo "❌ Pastikan .env berisi PORT dan NGROK_AUTH_TOKEN"
  exit 1
fi

# === Fungsi ===

build_docker() {
  echo "📦 Build Docker image '$DOCKER_IMAGE'..."
  docker build -t $DOCKER_IMAGE $DOCKERFILE_PATH
}

start_container() {
  echo "🚀 Menjalankan container '$APP_NAME'..."

  mkdir -p logs
  docker rm -f $APP_NAME 2>/dev/null

  docker run -d \
    -p $PORT:$PORT \
    --env-file $ENV_FILE \
    --name $APP_NAME \
    $DOCKER_IMAGE

  echo "✅ Container '$APP_NAME' aktif di port $PORT"

  # Aktifkan ngrok
  echo "🌐 Menyiapkan ngrok..."
  ngrok config add-authtoken "$NGROK_AUTH_TOKEN"

  sleep 3

  if [ -n "$DOMAIN" ]; then
    echo "🌍 Menggunakan domain custom: $DOMAIN"
    ngrok http --region=$NGROK_REGION --domain=$DOMAIN $PORT > /dev/null &
  else
    echo "🌍 Menggunakan domain ngrok default (random)"
    ngrok http --region=$NGROK_REGION $PORT > /dev/null &
  fi

  sleep 2
}

show_info() {
  echo -e "\n🌍 \e[1mAkses API:\e[0m"

  IP_HOST=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}')
  IP_WSL=$(ip addr show eth0 | grep 'inet ' | awk '{print $2}' | cut -d/ -f1)

  echo -e "📎 Localhost:  \e[32mhttp://localhost:$PORT\e[0m"
  echo -e "📎 Host LAN:   \e[32mhttp://$IP_HOST:$PORT\e[0m"
  echo -e "📎 IP WSL:     \e[32mhttp://$IP_WSL:$PORT\e[0m"

  echo -e "\n🔗 \e[1mNgrok URL:\e[0m"

  if [ -n "$DOMAIN" ]; then
    echo -e "🌍 \e[32mhttps://$DOMAIN/ask\e[0m"
  else
    PUBLIC_URL=$(curl -s http://localhost:4040/api/tunnels | grep -o 'https://[^"]*' | head -n1)
    echo -e "🌍 \e[32m$PUBLIC_URL/ask\e[0m"
  fi

  echo -e "\n📜 Logs: docker logs -f $APP_NAME"
  echo -e "🧪 Test API:\ncurl -X POST http://localhost:$PORT/ask -H 'Content-Type: application/json' -d '{\"prompt\":\"Halo\"}'"
}

stop_all() {
  echo "🛑 Menghentikan container dan ngrok..."
  docker rm -f $APP_NAME 2>/dev/null
  pkill ngrok 2>/dev/null
  echo "✅ Semua layanan dimatikan."
}

# === Menu Interaktif ===
while true; do
  echo -e "\n========= 🚀  \e[1mAI API SERVER MENU\e[0m ========="
  echo "1) 🔨 Build + Run API (Docker + Ngrok)"
  echo "2) 📡 Tampilkan Info Akses"
  echo "3) 🛑 Stop Semua"
  echo "4) 🚪 Keluar"
  echo -n "#? "
  read opt
  case $opt in
    1) build_docker && start_container && show_info ;;
    2) show_info ;;
    3) stop_all ;;
    4) echo "👋 Bye!"; exit ;;
    *) echo "❌ Pilihan tidak valid" ;;
  esac
done

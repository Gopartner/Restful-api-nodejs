#!/bin/bash

# === Konfigurasi ===
APP_NAME="ai-api-ngrok"
DOCKER_IMAGE="restful-ai-ngrok"
NODE_PORT=8000
DOCKERFILE_PATH="."  # bisa diganti jika Dockerfile ada di tempat lain
ENV_FILE=".env"

# === Fungsi ===

build_docker() {
  echo "📦 Build Docker image '$DOCKER_IMAGE'..."
  docker build -t $DOCKER_IMAGE $DOCKERFILE_PATH
}

start_container() {
  echo "🚀 Menjalankan container '$APP_NAME'..."

  mkdir -p logs

  # Stop dan hapus container lama jika ada
  docker rm -f $APP_NAME 2>/dev/null

  # Jalankan container baru
  docker run -d \
    -p $NODE_PORT:$NODE_PORT \
    --env-file $ENV_FILE \
    --name $APP_NAME \
    $DOCKER_IMAGE

  echo "✅ Container '$APP_NAME' aktif di port $NODE_PORT"
}

show_info() {
  echo -e "\n🌍 \e[1mAkses API:\e[0m"

  IP_HOST=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}')
  IP_WSL=$(ip addr show eth0 | grep 'inet ' | awk '{print $2}' | cut -d/ -f1)

  echo -e "📎 Localhost:  \e[32mhttp://localhost:$NODE_PORT\e[0m"
  echo -e "📎 Host LAN:   \e[32mhttp://$IP_HOST:$NODE_PORT\e[0m"
  echo -e "📎 IP WSL:     \e[32mhttp://$IP_WSL:$NODE_PORT\e[0m"

  echo -e "\n🔗 \e[1mNgrok URL:\e[0m"
  echo -e "🌍 \e[32mhttps://free-crisp-sailfish.ngrok-free.app/ask\e[0m"

  echo -e "\n📜 Logs: docker logs -f $APP_NAME"
  echo -e "🧪 Test API:\ncurl -X POST http://localhost:$NODE_PORT/ask -H 'Content-Type: application/json' -d '{\"prompt\":\"Halo\"}'"
}

stop_all() {
  echo "🛑 Menghentikan container..."
  docker rm -f $APP_NAME 2>/dev/null
  echo "✅ Container dimatikan."
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


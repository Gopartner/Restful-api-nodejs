#!/bin/bash

# === Konfigurasi ===
APP_NAME="ai-api-node"
DOCKER_IMAGE="restful-ai"
NODE_PORT=8000
DOCKERFILE_PATH="."  # bisa diganti kalau Dockerfile ada di folder lain
TMUX_NGROK="ngrok"
NGROK_DOMAIN="free-crisp-sailfish.ngrok-free.app"
NGROK_REGION="us"
ENV_FILE=".env"

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
    -p $NODE_PORT:$NODE_PORT \
    --env-file $ENV_FILE \
    --name $APP_NAME \
    $DOCKER_IMAGE

  echo "✅ Container '$APP_NAME' aktif di port $NODE_PORT"
}

start_ngrok() {
  mkdir -p logs
  if tmux has-session -t $TMUX_NGROK 2>/dev/null; then
    echo "⚠️  Ngrok sudah aktif di tmux '$TMUX_NGROK'"
  else
    tmux new-session -d -s $TMUX_NGROK "ngrok http --region=$NGROK_REGION --domain=$NGROK_DOMAIN $NODE_PORT" \; pipe-pane -o "cat > logs/ngrok.log"
    echo "🌐 Ngrok aktif di background (tmux '$TMUX_NGROK')"
  fi
}

show_info() {
  echo -e "\n🌍 \e[1mAkses API:\e[0m"

  IP_HOST=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}')
  IP_WSL=$(ip addr show eth0 | grep 'inet ' | awk '{print $2}' | cut -d/ -f1)

  echo -e "📎 Localhost:  \e[32mhttp://localhost:$NODE_PORT\e[0m"
  echo -e "📎 Host LAN:   \e[32mhttp://$IP_HOST:$NODE_PORT\e[0m"
  echo -e "📎 IP WSL:     \e[32mhttp://$IP_WSL:$NODE_PORT\e[0m"

  echo -e "\n🔗 \e[1mNgrok URL:\e[0m"
  echo -e "🌍 \e[32mhttps://$NGROK_DOMAIN\e[0m"

  echo -e "\n📜 Logs: docker logs -f $APP_NAME"
  echo -e "🧪 Test API:\ncurl -X POST http://localhost:$NODE_PORT/ask -H 'Content-Type: application/json' -d '{\"prompt\":\"Halo\"}'"
}

stop_all() {
  echo "🛑 Menghentikan container dan ngrok..."
  docker rm -f $APP_NAME 2>/dev/null
  tmux kill-session -t $TMUX_NGROK 2>/dev/null
  echo "✅ Semua dimatikan."
}

# === Menu Interaktif ===
while true; do
  echo -e "\n========= 🚀  \e[1mAI API SERVER MENU\e[0m ========="
  echo "1) 🔨 Build + Run API (Docker)"
  echo "2) 🌍 Jalankan API + Ngrok"
  echo "3) 📡 Tampilkan Info Akses"
  echo "4) 🛑 Stop Semua"
  echo "5) 🚪 Keluar"
  echo -n "#? "
  read opt
  case $opt in
    1) build_docker && start_container && show_info ;;
    2) build_docker && start_container && start_ngrok && show_info ;;
    3) show_info ;;
    4) stop_all ;;
    5) echo "👋 Bye!"; exit ;;
    *) echo "❌ Pilihan tidak valid" ;;
  esac
done


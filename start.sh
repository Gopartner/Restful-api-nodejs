# #!/bin/bash

# # Tambahkan token ngrok agar domain bisa dipakai
# ngrok config add-authtoken 1qlesJQTeuOYdtETiapQF6xu9DT_5btx4iatrX7JjzgMXPpf2

# # Jalankan server Node.js (karena kamu pakai app/server.js)
# node app/server.js &

# # Tunggu beberapa detik supaya server aktif
# sleep 3

# # Jalankan ngrok dengan domain khusus
# ngrok http --region=us --domain=free-crisp-sailfish.ngrok-free.app 8000


# ============================================================================================
# INI VERSI BARU
#!/bin/bash

# Load variabel dari file .env
if [ -f .env ]; then
  export $(grep -v '^#' .env | xargs)
else
  echo "❌ File .env tidak ditemukan!"
  exit 1
fi

# Cek variabel penting
if [ -z "$NGROK_AUTH_TOKEN" ] || [ -z "$PORT" ]; then
  echo "❌ Pastikan .env berisi NGROK_AUTH_TOKEN dan PORT"
  exit 1
fi

# Tambahkan token ngrok
echo "🔐 Menambahkan token ngrok..."
ngrok config add-authtoken "$NGROK_AUTH_TOKEN"

# Jalankan server Node.js (misalnya app/server.js)
echo "🚀 Menjalankan server Node.js di port $PORT..."
node app/server.js &

# Tunggu server siap
sleep 3

# Jalankan ngrok dengan domain khusus (kalau mau domain ngrok free, bisa pakai --domain, tapi jarang stabil)
echo "🌍 Menjalankan ngrok tunnel..."
ngrok http --region=us $PORT

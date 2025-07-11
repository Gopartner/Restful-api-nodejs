#!/bin/bash

# Tambahkan token ngrok agar domain bisa dipakai
ngrok config add-authtoken 1qlesJQTeuOYdtETiapQF6xu9DT_5btx4iatrX7JjzgMXPpf2

# Jalankan server Node.js (karena kamu pakai app/server.js)
node app/server.js &

# Tunggu beberapa detik supaya server aktif
sleep 3

# Jalankan ngrok dengan domain khusus
ngrok http --region=us --domain=free-crisp-sailfish.ngrok-free.app 8000


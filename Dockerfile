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

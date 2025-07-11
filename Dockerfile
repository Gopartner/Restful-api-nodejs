# Gunakan base image Node.js
FROM node:22

# Install ngrok dan alat bantu
RUN apt update && apt install -y curl unzip

# Install ngrok dari repository resmi
RUN curl -s https://ngrok-agent.s3.amazonaws.com/ngrok.asc | tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null \
 && echo "deb https://ngrok-agent.s3.amazonaws.com buster main" | tee /etc/apt/sources.list.d/ngrok.list \
 && apt update && apt install -y ngrok

# Set direktori kerja
WORKDIR /app

# Copy semua isi project ke container
COPY . .

# Install dependency node
RUN npm install

# Copy dan beri izin untuk script start
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

# Jalankan script start saat container dijalankan
CMD ["./start.sh"]


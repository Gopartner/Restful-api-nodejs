# Membangun RESTful API dengan Node.js yang:

🔌 Endpoint: POST /ask

🧠 Kirim prompt ke model Hugging Face (mistralai/Mistral-7B-Instruct-v0.1)

🔐 Token dibaca dari file ~/.hf_token

🐳 Dikemas pakai Docker

## Struktur Folder
```bash
Restful-API-nodejs/
├── app/
│   └── server.js
├── Dockerfile
├── package.json
```
---

## Build Docker Image
dari folder root project jalankan ini:
```bash
docker build -t restful-ai .
```
---
## Jalankan Container + Mount Token (jika token di simpan di luar project)
```bash
docker run -d -p 8000:8000 \
  -v $HOME/.hf_token:/root/.hf_token:ro \
  --name ai-api-node restful-ai
```
## Tes API dengan curl:
```bash
curl -X POST http://localhost:8000/ask \
  -H "Content-Type: application/json" \
  -d '{"prompt": "Apa itu REST API dalam pengembangan web?"}'
```
atau dengan posman
---

import jwt from 'jsonwebtoken';
import client from '../utils/hfClient.js';

export const ping = (_, res) => res.send('pong');

export const homePage = (req, res) => {
    const port = process.env.PORT || 8000;
    res.send(`
    <h2>👋 Hai! Saya siap membantu.</h2>
    <p>Kirim pertanyaan ke endpoint <code>POST /ask</code></p>
    <pre>
curl -X POST http://localhost:${port}/ask \\
  -H "Content-Type: application/json" \\
  -d '{"prompt": "Apa itu AI?"}'
    </pre>
  `);
};

export const login = (req, res) => {
    const { name } = req.body;
    if (!name) return res.status(400).json({ error: 'Nama diperlukan' });

    const token = jwt.sign({ name }, process.env.JWT_SECRET, { expiresIn: '2h' });
    res.json({ token });
};

export const askAI = async (req, res) => {
    const { prompt } = req.body;
    const name = req.user?.name || null;

    if (!prompt || prompt.trim() === '') {
        const greeting = name
            ? `👋 Hai, ${name}! Senang bisa bantu. Ada yang bisa saya bantu hari ini?`
            : `👋 Hai! Senang bertemu denganmu. Ada yang ingin kamu tanyakan?`;

        return res.json({ role: 'assistant', content: greeting });
    }

    try {
        const response = await client.chatCompletion({
            provider: "fireworks-ai",
            model: "deepseek-ai/DeepSeek-V3",
            messages: [{ role: "user", content: prompt }],
        });

        res.json(response.choices[0].message);
    } catch (error) {
        console.error("❌ Error from HF:", error);
        res.status(500).json({ error: 'Gagal memanggil API HuggingFace', detail: error.message });
    }
};

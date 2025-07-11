import express from 'express';
import dotenv from 'dotenv';
import { InferenceClient } from '@huggingface/inference';

dotenv.config();
const app = express();
app.use(express.json());

const client = new InferenceClient(process.env.HF_TOKEN);

app.post('/ask', async (req, res) => {
  const { prompt } = req.body;

  try {
    const chatCompletion = await client.chatCompletion({
      provider: "fireworks-ai",
      model: "deepseek-ai/DeepSeek-V3",
      messages: [
        {
          role: "user",
          content: prompt,
        },
      ],
    });

    res.json(chatCompletion.choices[0].message);
  } catch (error) {
    console.error("Error from HF:", error);
    res.status(500).json({ error: 'API call failed', detail: error.message });
  }
});

app.listen(8000, () => {
  console.log('Server running on http://localhost:8000');
});

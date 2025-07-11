import { InferenceClient } from '@huggingface/inference';
import dotenv from 'dotenv';

dotenv.config();
const client = new InferenceClient(process.env.HF_TOKEN);

export default client;

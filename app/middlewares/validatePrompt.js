export const validatePrompt = (req, res, next) => {
    const { prompt } = req.body;
    if (prompt && prompt.length > 1000) {
        return res.status(400).json({
            error: 'Prompt terlalu panjang. Maksimal 1000 karakter.'
        });
    }
    next();
};

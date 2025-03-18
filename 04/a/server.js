const express = require('express');
const cors = require('cors');

const app = express();
app.use(cors());

app.get('/events', (req, res) => {
    res.setHeader('Content-Type', 'text/event-stream');
    res.setHeader('Cache-Control', 'no-cache');
    res.setHeader('Connection', 'keep-alive');

    let counter = 0;

    const interval = setInterval(() => {
        counter++;
        res.write(`data: Message ${counter} at ${new Date().toLocaleTimeString()}\n\n`);
    }, 3000);

    req.on('close', () => {
        clearInterval(interval);
    });
});

app.listen(3000, () => console.log('SSE server running on http://localhost:3000'));

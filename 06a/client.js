const WebSocket = require('ws');


const ws = new WebSocket('ws://localhost:8765');

ws.on('open', () => {
  console.log('Connected to WebSocket server');
  const message = 'Hello, WebSocket server!';
  console.log(`Sending: ${message}`);
  ws.send(message);
});


ws.on('message', (data) => {
  console.log(`Received from server: ${data}`);
  ws.close();
});

ws.on('close', () => {
  console.log('Disconnected from WebSocket server');
});

const http = require('http');
const PORT = 13001;

const server = http.createServer((req, res) => {
  res.writeHead(200, { 'Content-Type': 'text/plain' });
  res.end('Hello World\n');
});

server.listen(PORT, () => {
  console.log(`Node.js server running on port ${PORT}`);
});

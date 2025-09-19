const http = require('http');
const port = 3000;

http.createServer((req, res) => {
  res.writeHead(200, {'Content-Type': 'text/plain'});
  res.end('Hello from Jenkins CI/CD!\n');
}).listen(port);

console.log(`Server running at http://localhost:${port}/`);

const fs = require('fs');
const path = require('path');

const logFile = path.join(__dirname,"..", 'logs', 'app.log');

const endpoints = [
  { method: 'GET', path: '/api/products', status: 200 },
  { method: 'POST', path: '/api/orders', status: 201 },
  { method: 'GET', path: '/api/users', status: 404 },
  { method: 'PUT', path: '/api/products/12', status: 200 },
  { method: 'DELETE', path: '/api/products/12', status: 204 },
  { method: 'GET', path: '/api/checkout', status: 500 },
  { method: 'GET', path: '/api/dashboard', status: 200 },
  { method: 'POST', path: '/api/orders', status: 400 },
  { method: 'GET', path: '/api/metrics', status: 200 },
  { method: 'PUT', path: '/api/users/5', status: 500 }
];

function getRandomInt(min, max) {
  return Math.floor(Math.random() * (max - min + 1)) + min;
}

function generateLog() {
  const now = new Date();
  const timestamp = now.toISOString().replace('T', ' ').substring(0, 19);
  const entry = endpoints[Math.floor(Math.random() * endpoints.length)];
  const duration = getRandomInt(0, 400);

  let level = 'INFO';
  if (entry.status >= 500) level = 'ERROR';
  else if (entry.status >= 400) level = 'WARN';

  const logLine = `[${level}] ${timestamp} - ${entry.method} ${entry.path} - status: ${entry.status} - time: ${duration}ms\n`;

  fs.appendFileSync(logFile, logLine);
  console.log(logLine.trim());
}

setInterval(generateLog, 2000); // cada 2 segundos

const fs = require('fs');
const path = require('path');

const logFile = path.join(__dirname,"..", 'logs', 'dataBase.log');
const queries = [
  'SELECT * FROM users',
  'UPDATE orders SET status="shipped" WHERE id=123',
  'DELETE FROM sessions WHERE expired=1',
  'INSERT INTO products (name, price) VALUES ("New Product", 9.99)',
  'INSERT INTO provinces (name, location) VALUES ("Lima", "La Molina")'
];

function randomInt(max) {
  return Math.floor(Math.random() * max);
}

function generateLog() {
  const isError = Math.random() < 0.1; // 10% chance error
  const timestamp = new Date().toISOString().replace('T', ' ').substring(0, 19);

  if (isError) {
    return `[ERROR] ${timestamp} - Connection lost - reconnecting...\n`;
  } else {
    const query = queries[randomInt(queries.length)];
    const duration = randomInt(300) + 20;
    return `[INFO] ${timestamp} - Query executed - ${query} - time: ${duration}ms\n`;
  }
}

function appendLog() {
  const log = generateLog();
  fs.appendFile(logFile, log, err => {
    if (err) console.error('Error writing log:', err);
  });
}

setInterval(appendLog, 1500);

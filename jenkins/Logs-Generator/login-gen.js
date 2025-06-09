const fs = require('fs');
const path = require('path');

const logFile = path.join(__dirname,"..", 'logs', 'login.log');
const users = ['javier', 'jaime', 'gino', 'dylan','orlando'];
const ips = ['192.168.1.20', '10.0.0.5', '172.16.0.3', '192.168.1.50','192.168.1.0'];

function randomInt(max) {
  return Math.floor(Math.random() * max);
}

function generateLog() {
  const timestamp = new Date().toISOString().replace('T', ' ').substring(0, 19);
  const isError = Math.random() < 0.15; // 15% chance login fail
  const user = users[randomInt(users.length)];
  const ip = ips[randomInt(ips.length)];

  if (isError) {
    const reasons = ['wrong password', 'account locked', 'timeout'];
    const reason = reasons[randomInt(reasons.length)];
    return `[ERROR] ${timestamp} - Login failed - user: ${user} - reason: ${reason}\n`;
  } else {
    return `[INFO] ${timestamp} - User login - user: ${user} - ip: ${ip}\n`;
  }
}

function appendLog() {
  const log = generateLog();
  fs.appendFile(logFile, log, err => {
    if (err) console.error('Error writing log:', err);
  });
}

setInterval(appendLog, 2000);

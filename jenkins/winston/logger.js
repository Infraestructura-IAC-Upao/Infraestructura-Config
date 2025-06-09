const { createLogger, format, transports } = require('winston');
const path = require('path');

const logger = createLogger({
  level: 'info',
  format: format.combine(
    format.timestamp(),
    format.json() // ✅ Formato estructurado
  ),
  transports: [
    new transports.Console(),
    new transports.File({ filename: path.join(__dirname, 'logs/app.log') }) // ✅ Ruta donde se guardan
  ]
});

module.exports = logger;
// database/connection.js
const mysql = require("mysql2");

// Determine environment
const isLocal = process.env.USE_LOCALHOST === "true";

if (isLocal) {
  require("dotenv").config();
  console.log("Running in LOCAL mode");
} else {
  console.log("Running in PRODUCTION mode (Elastic Beanstalk)");
}

// Create pool
const pool = mysql.createPool({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  port: process.env.DB_PORT || 3306,
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0,
});

// Wrap pool with promise support
const promisePool = pool.promise();

// Test connection
(async () => {
  try {
    const conn = await promisePool.getConnection();
    console.log("MySQL connected successfully");
    conn.release();
  } catch (err) {
    console.error("MySQL connection failed:", err.message);
  }
})();

module.exports = promisePool;

// database/connection.js
const mysql = require("mysql2");

// Detect environment
const isLocal = process.env.USE_LOCALHOST === "true";

// Only load dotenv for LOCAL development
if (isLocal) {
  require("dotenv").config();
  console.log("Running in LOCAL mode");
} else {
  console.log("Running in PRODUCTION mode (Elastic Beanstalk)");
}

// Build connection config
const connectionConfig = isLocal
  ? {
      host: "localhost",
      user: "root",
      password: process.env.DB_PASSWORD,
      database: "e_commerce",
      port: 3306,
    }
  : {
      host: process.env.DB_HOST,
      user: process.env.DB_USER,
      password: process.env.DB_PASSWORD,
      database: process.env.DB_NAME,
      port: process.env.DB_PORT || 3306,
      waitForConnections: true,
      connectionLimit: 10,
      queueLimit: 0,
    };

// Create connection pool
const pool = mysql.createPool(connectionConfig);

// Test connection
pool.getConnection((err, connection) => {
  if (err) {
    console.error("MySQL connection failed:", err.message);
  } else {
    console.log("MySQL connected successfully");
    connection.release();
  }
});

module.exports = pool.promise();
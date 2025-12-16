// models/userModel.js
const pool = require("../database/connection"); // already promise-based
const bcrypt = require("bcryptjs");
const { generateAccessAndRefreshToken } = require("../utils/token");

exports.register = async (email, password, isAdmin, fname, lname) => {
  try {
    // Check if user already exists
    const [existingUser] = await pool.query("SELECT * FROM users WHERE email = ?", [email]);
    if (existingUser.length > 0) {
      throw new Error("User already exists");
    }

    // Hash password
    const hashedPassword = await bcrypt.hash(password, 8);

    // Insert new user
    const [result] = await pool.query(
      "INSERT INTO users (email, password, isAdmin, fname, lname) VALUES (?,?,?,?,?)",
      [email, hashedPassword, isAdmin, fname, lname]
    );

    return result;
  } catch (err) {
    throw err;
  }
};

exports.login = async (email, password) => {
  try {
    const [rows] = await pool.query(
      "SELECT userId, password, isAdmin FROM users WHERE email = ?",
      [email]
    );

    if (rows.length === 0) {
      throw new Error("Invalid email or password");
    }

    const user = rows[0];
    const isMatch = await bcrypt.compare(password, user.password);

    if (!isMatch) {
      throw new Error("Invalid email or password");
    }

    const userData = { userId: user.userId, isAdmin: user.isAdmin };
    const { token, refreshToken } = generateAccessAndRefreshToken(userData);

    userData.token = token;
    userData.refreshToken = refreshToken;

    return [userData];
  } catch (err) {
    throw err;
  }
};

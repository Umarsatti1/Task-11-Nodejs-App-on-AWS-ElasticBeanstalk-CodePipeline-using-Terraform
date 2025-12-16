// userController.js
const userModel = require("../models/userModel");

exports.register = async (req, res) => {
  try {
    const { email, password, isAdmin, fname, lname } = req.body;

    const result = await userModel.register(email, password, isAdmin, fname, lname);
    console.log("User registered successfully");
    res.status(201).send(result);
  } catch (err) {
    console.error("Register error:", err.message);
    res.status(500).send({ error: err.message });
  }
};

exports.login = async (req, res) => {
  try {
    const { email, password } = req.body;

    const result = await userModel.login(email, password);
    console.log("User logged in successfully");
    res.status(200).send(result);
  } catch (err) {
    console.error("Login error:", err.message);
    res.status(500).send({ error: err.message });
  }
};

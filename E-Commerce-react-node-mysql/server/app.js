const express = require("express");
const path = require("path");       // <-- add this
const cors = require("cors");
const userRoutes = require("./routes/userRoutes");
const productRoutes = require("./routes/productRoutes");
const orderRoutes = require("./routes/orderRoutes");
const cartRoutes = require("./routes/cartRoutes");
const userToken = require("./routes/userTokenRoute");

const app = express();

app.use(cors());
app.use(express.json());

// Mount API routes
app.use("/api/users", userRoutes);
app.use("/api/products", productRoutes);
app.use("/api/orders", orderRoutes);
app.use("/api/cart", cartRoutes);
app.use("/api/token", userToken);

// Serve React frontend
app.use(express.static(path.join(__dirname, "build")));

// Catch-all route for React
app.get("*", (req, res) => {
  res.sendFile(path.join(__dirname, "build", "index.html"));
});

const PORT = process.env.PORT || 3001;
const server = app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
server.timeout = 300000;

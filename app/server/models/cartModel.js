// cartModel.js
const pool = require("../database/connection");

exports.getShoppingCart = async (userId) => {
    try {
        const [rows] = await pool.query(
            "SELECT S.quantity, P.name, P.price, P.productId FROM shopingCart S INNER JOIN product P ON S.productId = P.productId WHERE S.userId = ?",
            [userId]
        );
        return rows;
    } catch (err) {
        console.error("getShoppingCart error:", err.message);
        throw err;
    }
};

exports.addToCart = async (customerId, productId, quantity, isPresent) => {
    try {
        if (isPresent) {
            const [result] = await pool.query(
                "UPDATE shopingCart SET quantity = quantity + ? WHERE productId = ? AND userId = ?",
                [quantity, productId, customerId]
            );
            return result;
        } else {
            const [result] = await pool.query(
                "INSERT INTO shopingCart (userId, productId, quantity) VALUES (?, ?, ?)",
                [customerId, productId, quantity]
            );
            return result;
        }
    } catch (err) {
        console.error("addToCart error:", err.message);
        throw err;
    }
};

exports.removeFromCart = async (productId, userId) => {
    try {
        const [result] = await pool.query(
            "DELETE FROM shopingCart WHERE productId = ? AND userId = ?",
            [productId, userId]
        );
        return result;
    } catch (err) {
        console.error("removeFromCart error:", err.message);
        throw err;
    }
};

exports.buy = async (customerId, address) => {
    try {
        // Create order
        const [orderResult] = await pool.query(
            "INSERT INTO orders (userId, address) VALUES (?, ?);",
            [customerId, address]
        );

        const [productsResult] = await pool.query(
            "INSERT INTO productsInOrder (orderId, productId, quantity, totalPrice) " +
            "SELECT (SELECT max(orderId) FROM orders WHERE userId = ?), S.productId, S.quantity, P.price * S.quantity " +
            "FROM shopingCart S INNER JOIN product P ON S.productId = P.productId " +
            "WHERE S.userId = ?;",
            [customerId, customerId]
        );

        const [totalPriceResult] = await pool.query(
            "UPDATE orders O " +
            "SET totalPrice = (SELECT SUM(P.totalPrice) " +
            "FROM productsInOrder P " +
            "WHERE O.orderId = P.orderId " +
            "GROUP BY O.orderId) " +
            "WHERE userId = ? AND totalPrice IS NULL;",
            [customerId]
        );

        const [clearCartResult] = await pool.query(
            "DELETE FROM shopingCart WHERE userId = ?;",
            [customerId]
        );

        return { orderResult, productsResult, totalPriceResult, clearCartResult };
    } catch (err) {
        console.error("buy error:", err.message);
        throw err;
    }
};

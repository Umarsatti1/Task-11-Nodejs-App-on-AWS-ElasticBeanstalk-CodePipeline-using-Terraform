// orderModel.js
const pool = require("../database/connection");

exports.getAllOrders = async () => {
    try {
        const [rows] = await pool.query(
            "SELECT O.orderId, U.fname, U.lname, O.createdDate, O.totalPrice " +
            "FROM orders O INNER JOIN users U ON O.userId = U.userId;"
        );
        return rows;
    } catch (err) {
        console.error("getAllOrders error:", err.message);
        throw err;
    }
};

exports.getOrderById = async (orderId) => {
    try {
        const [rows] = await pool.query(
            "SELECT U.fname, U.lname, O.totalPrice, U.createdDate, O.address " +
            "FROM orders O INNER JOIN users U ON O.userId = U.userId " +
            "WHERE O.orderId = ?;",
            [orderId]
        );
        return rows;
    } catch (err) {
        console.error("getOrderById error:", err.message);
        throw err;
    }
};

exports.getProductsByOrder = async (orderId) => {
    try {
        const [rows] = await pool.query(
            "SELECT P2.productId, P2.name, P.quantity, P.totalPrice " +
            "FROM orders O INNER JOIN productsInOrder P ON O.orderId = P.orderId " +
            "INNER JOIN product P2 ON P.productId = P2.productId " +
            "WHERE O.orderId = ?;",
            [orderId]
        );
        return rows;
    } catch (err) {
        console.error("getProductsByOrder error:", err.message);
        throw err;
    }
};

exports.updateOrder = async (orderId, newData) => {
    try {
        const [result] = await pool.query("UPDATE orders SET ? WHERE orderId = ?", [newData, orderId]);
        return result;
    } catch (err) {
        console.error("updateOrder error:", err.message);
        throw err;
    }
};

exports.getPastOrdersByCustomerID = async (customerId) => {
    try {
        const [rows] = await pool.query(
            "SELECT O.orderId, P.name, O.createdDate, PIN.quantity, PIN.totalPrice " +
            "FROM orders O INNER JOIN productsInOrder PIN ON O.orderId = PIN.orderId  " +
            "INNER JOIN product P ON PIN.productId = P.productId " +
            "WHERE O.userId = ? " +
            "ORDER BY O.orderID DESC;",
            [customerId]
        );
        return rows;
    } catch (err) {
        console.error("getPastOrdersByCustomerID error:", err.message);
        throw err;
    }
};

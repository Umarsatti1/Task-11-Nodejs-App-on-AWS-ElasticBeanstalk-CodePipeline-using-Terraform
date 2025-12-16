// productModel.js
const pool = require("../database/connection");

exports.getAllProducts = async () => {
    try {
        const [rows] = await pool.query("SELECT * FROM product;");
        return rows;
    } catch (err) {
        console.error("getAllProducts error:", err.message);
        throw err;
    }
};

exports.getProductDetailsById = async (productId) => {
    try {
        const [rows] = await pool.query("SELECT * FROM product WHERE productId = ?", [productId]);
        return rows;
    } catch (err) {
        console.error("getProductDetailsById error:", err.message);
        throw err;
    }
};

exports.allOrderByProductId = async (productId) => {
    try {
        const [rows] = await pool.query(
            "SELECT O.orderId, U.fname, U.lname, O.createdDate, PIN.quantity, PIN.totalPrice " +
            "FROM users U INNER JOIN orders O on U.userId  = O.userId " +
            "INNER JOIN productsInOrder PIN on O.orderId = PIN.orderId " +
            "INNER JOIN product P on PIN.productId = P.productId " +
            "WHERE PIN.productId = ?;",
            [productId]
        );
        return rows;
    } catch (err) {
        console.error("allOrderByProductId error:", err.message);
        throw err;
    }
};

exports.createProduct = async (name, price, description) => {
    try {
        const [result] = await pool.query(
            "INSERT INTO product (name, price, description) VALUES (?,?,?)",
            [name, price, description]
        );
        return result;
    } catch (err) {
        console.error("createProduct error:", err.message);
        throw err;
    }
};

exports.updateProduct = async (productId, name, price, description) => {
    try {
        const [result] = await pool.query(
            "UPDATE product SET name = ?, price = ?, description = ? WHERE productId = ?",
            [name, price, description, productId]
        );
        return result;
    } catch (err) {
        console.error("updateProduct error:", err.message);
        throw err;
    }
};

exports.deleteProduct = async (productId) => {
    try {
        const [result] = await pool.query("DELETE FROM product WHERE productId = ?", [productId]);
        return result;
    } catch (err) {
        console.error("deleteProduct error:", err.message);
        throw err;
    }
};

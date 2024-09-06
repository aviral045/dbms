-- Create a database for a simple e-commerce system
CREATE DATABASE ecommerce;

-- Use the ecommerce database
USE ecommerce;

-- Create tables for customers, orders, and products
CREATE TABLE customers (
  customer_id INT PRIMARY KEY,
  name VARCHAR(50),
  email VARCHAR(100),
  password VARCHAR(255)
);

CREATE TABLE orders (
  order_id INT PRIMARY KEY,
  customer_id INT,
  order_date DATE,
  total DECIMAL(10, 2),
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE products (
  product_id INT PRIMARY KEY,
  name VARCHAR(100),
  description TEXT,
  price DECIMAL(10, 2)
);

CREATE TABLE order_items (
  order_item_id INT PRIMARY KEY,
  order_id INT,
  product_id INT,
  quantity INT,
  FOREIGN KEY (order_id) REFERENCES orders(order_id),
  FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Insert some sample data
INSERT INTO customers (customer_id, name, email, password)
VALUES
  (1, 'John Doe', 'johndoe@example.com', 'password123'),
  (2, 'Jane Smith', 'janesmith@example.com', 'password456');

INSERT INTO orders (order_id, customer_id, order_date, total)
VALUES
  (1, 1, '2022-01-01', 100.00),
  (2, 1, '2022-01-15', 200.00),
  (3, 2, '2022-02-01', 50.00);

INSERT INTO products (product_id, name, description, price)
VALUES
  (1, 'Product A', 'This is product A', 20.00),
  (2, 'Product B', 'This is product B', 30.00),
  (3, 'Product C', 'This is product C', 40.00);

INSERT INTO order_items (order_item_id, order_id, product_id, quantity)
VALUES
  (1, 1, 1, 2),
  (2, 1, 2, 1),
  (3, 2, 3, 3),
  (4, 3, 1, 1);

-- Query to get the total revenue by customer
SELECT c.name, SUM(oi.quantity * p.price) AS total_revenue
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
GROUP BY c.name;

-- Query to get the top 3 products by sales
SELECT p.name, SUM(oi.quantity) AS total_sales
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.name
ORDER BY total_sales DESC
LIMIT 3;

-- Query to get the average order value by month
SELECT MONTH(o.order_date) AS month, AVG(o.total) AS avg_order_value
FROM orders o
GROUP BY MONTH(o.order_date);
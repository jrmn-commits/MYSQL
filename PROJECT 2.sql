#1
SELECT category_name, product_name, list_price
FROM categories INNER JOIN products
	ON categories.category_id = products.category_id
ORDER BY category_name, product_name;

#2
SELECT first_name, last_name, line1, city, state, zip_code
FROM addresses a JOIN customers c
	ON a.customer_id = c.customer_id
WHERE email_address = "allan.sherwood@yahoo.com";

#3
SELECT first_name, last_name, line1, city, state, zip_code
FROM addresses a JOIN customers c
	ON a.customer_id = c.customer_id
    AND c.shipping_address_id = a.address_id;

#4
SELECT last_name, first_name, order_date, product_name, item_price, discount_amount, quantity
FROM customers c
	JOIN orders o
		ON o.customer_id = c.customer_id
	JOIN order_items oi 
		ON oi.order_id = o.order_id
    JOIN products p
		ON p.product_id = oi.product_id
ORDER BY last_name, order_date, product_name;

#5
SELECT DISTINCT p1.product_name, p1.list_price
FROM products p1 JOIN products p2
	ON p1.list_price = p2.list_price
    AND p1.product_name <> p2.product_name
ORDER BY product_name;

#6
SELECT category_name, product_id
FROM categories c LEFT JOIN products p
	ON c.category_id = p.category_id
WHERE product_id IS NULL;

#7
SELECT ship_date AS 'ship_status', order_id, order_date
FROM orders
WHERE  ship_date = 0
UNION
SELECT 'SHIPPED' AS ship_date, order_id, order_date
FROM orders 
WHERE (ship_date IS NOT NULL)
UNION
SELECT 'NOT SHIPPED' AS ship_date, order_id, order_date
FROM orders 
WHERE (ship_date IS NULL)
ORDER BY order_date;
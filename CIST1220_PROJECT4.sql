
#=================================================================================
									#1
# Write a SELECT statement that returns these columns:
# The count of the number of orders in the Orders table
# The sum of the tax_amount columns in the Orders table                                    
#=================================================================================
SELECT COUNT(order_id) AS number_of_orders,
		SUM(tax_amount) AS total_tax_amount
FROM orders;

#=================================================================================
									#2
# Write a SELECT statement that returns one row for each category that has products with these columns:
# The category_name column from the Categories table 
# The count of the products in the Products table 
# The list price of the most expensive product in the Products table
# Sort the result set so the category with the most products appears first.
#=================================================================================
SELECT c.category_name, COUNT(*) AS count_of_products,
		MAX(list_price) AS most_expensive_product
FROM categories c INNER JOIN products p
	ON c.category_id = p.category_id
GROUP BY c.category_name
ORDER BY product_id ASC;

#=================================================================================
									#3
# Write a SELECT statement that returns one row for each customer that has orders with these columns:
# The email_address column from the Customers table
# The sum of the item price in the Order_Items table multiplied by the quantity in the Order_Items table
# The sum of the discount amount column in the Order_Items table multiplied by the quantity in the Order_Items table
# Sort the result set in descending sequence by the item price total for each customer.
#=================================================================================
SELECT c.email_address, 
	SUM(oi.item_price) * COUNT(oi.item_id) AS first_total_count,
    SUM(oi.discount_amount) * COUNT(oi.item_id) AS second_total_count
FROM customers c INNER JOIN orders o ON c.customer_id = o.customer_id
				INNER JOIN order_items oi ON oi.order_id = o.order_id
GROUP BY c.customer_id
ORDER BY SUM(oi.item_price) DESC;

#=================================================================================
									#4
# Write a SELECT statement that returns one row for each customer that has orders with these columns:
# The email_address from the Customers table
# A count of the number of orders
# The total amount for each order (Hint: First, subtract the discount amount from the price. 
# Then, multiply by the quantity.)
# Return only those rows where the customer has more than 1 order. 
# Sort the result set in descending sequence by the sum of the line item amounts.
#=================================================================================
SELECT c.email_address, COUNT(oi.order_id) AS count,
	SUM(oi.item_price - oi.discount_amount) * COUNT(oi.order_id) AS total_amount
FROM customers c INNER JOIN orders o ON c.customer_id = o.customer_id
				INNER JOIN order_items oi ON oi.order_id = o.order_id
GROUP BY c.customer_id
HAVING count > 1
ORDER BY total_amount DESC;

#=================================================================================
									#5
# Modify the solution to exercise 4 so it only counts and totals line items that have an item_price value that’s greater than 400.
#=================================================================================
SELECT c.email_address, COUNT(oi.order_id) AS count,
	SUM(oi.item_price - oi.discount_amount) * COUNT(oi.order_id) AS total_amount
FROM customers c INNER JOIN orders o ON c.customer_id = o.customer_id
				INNER JOIN order_items oi ON oi.order_id = o.order_id
WHERE oi.item_price>400 
GROUP BY c.customer_id
HAVING count > 1
ORDER BY total_amount DESC;

#=================================================================================
									#6
# Write a SELECT statement that answers this question: What is the total amount ordered for each product? Return these columns:
# The product name from the Products table
# The total amount for each product in the Order_Items (Hint: You can calculate the total amount by
# subtracting the discount amount from the item price and then multiplying it by the quantity) 
# Use the WITH ROLLUP operator to include a row that gives the grand total.
#=================================================================================
SELECT COALESCE(p.product_name, "Final Total") AS "Product Name",
	SUM(oi.item_price - oi.discount_amount) * COUNT(oi.item_id) AS "Total Amount"
FROM products p
LEFT JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_name WITH ROLLUP;

#=================================================================================
									#7
# Write a SELECT statement that answers this question: Which customers have ordered more than one product? Return these columns:
# The email address from the Customers table
# The count of distinct products from the customer’s orders
#=================================================================================
SELECT c.email_address, COUNT(DISTINCT oi.product_id) AS count
FROM customers c INNER JOIN orders o ON c.customer_id = o.customer_id
				INNER JOIN order_items oi ON oi.order_id = o.order_id
GROUP BY c.email_address
HAVING count > 1
ORDER BY email_address ASC;

#=================================================================================
									#8
# Write a SELECT statement that answers this question: What is the total quantity purchased for each 
# product within each category? Return these columns:
# The category_name column from the category table
# The product_name column from the products table
# The total quantity purchased for each product with orders in the Order_Items table
# Use the WITH ROLLUP operator to include rows that give a summary for each category name as 
# well as a row that gives the grand total.
# Use the IF and GROUPING functions to replace null values in the category_name and product_name 
# columns with literal values if they’re for summary rows. DELIVERABLE
#=================================================================================
SELECT IF( c.category_name is null, 'All Categories', c.category_name) Category,
       IF( p.product_name is null, 'All Products', p.product_name ) Product, 
       SUM(oi.quantity) as total_amount_purchased,
       SUM((oi.item_price - oi.discount_amount) * oi.quantity) AS total_sales
FROM products p JOIN categories c ON p.category_id = c.category_id
         JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY c.category_name, p.product_name WITH ROLLUP;

#=================================================================================
									#9
# Write a SELECT statement that uses an aggregate window function to get the total amount of each 
# order. Return these columns:
# The order_id column from the Order_Items table
# The total amount for each order item in the Order_Items table (Hint: You can calculate the total 
# amount by subtracting the discount amount from the item price and then multiplying it by the 
# quantity)
# The total amount for each order DELIVERABLE
# Sort the result set in ascending sequence by the order_id column.

#=================================================================================
SELECT o.order_id,
	SUM((oi.item_price - oi.discount_amount) * oi.quantity) OVER(PARTITION BY oi.order_id),
    SUM(oi.item_price * oi.quantity)
FROM order_items oi JOIN orders o
	ON o.order_id = oi.order_id
GROUP BY order_id
ORDER BY order_id ASC;

#=================================================================================
									#10
# Modify the solution to exercise 9 so the column that contains the total amount for each order contains 
# a cumulative total by item amount.
# Add another column to the SELECT statement that uses an aggregate window function to get the 
# average item amount for each order.
# Modify the SELECT statement so it uses a named window for the two aggregate functions. 
# DELIVERABLE

#=================================================================================
SELECT oi.order_id,
	SUM((oi.item_price - oi.discount_amount) * oi.quantity) OVER(PARTITION BY oi.order_id) AS total_orditem_amount,
    AVG(oi.item_price * oi.quantity) AS average_cost,
    SUM(oi.item_price * oi.quantity)  OVER(PARTITION BY oi.item_id) AS cumulative_total
FROM order_items oi JOIN orders o
	ON o.order_id = oi.order_id
GROUP BY order_id
ORDER BY order_id ASC;

#=================================================================================
									#11
#  Write a SELECT statement that uses aggregate window functions to calculate the order total for each 
# customer and the order total for each customer by date. Return these columns:
# The customer_id column from the Orders table
# The order_date column from the Orders table
# The total amount for each order item in the Order_Items table
# The sum of the order totals for each customer DELIVERABLE
# The sum of the order totals for each customer by date (Hint: You can create a peer group to get 
# these values)
#=================================================================================
SELECT o.customer_id, o.order_date,
	SUM((oi.item_price - oi.discount_amount) * oi.quantity) OVER(PARTITION BY oi.order_id)  AS total_orditem_amount,
	SUM((oi.item_price - oi.discount_amount) * oi.quantity) AS total_sales
FROM order_items oi JOIN orders o
	ON o.order_id = oi.order_id
GROUP BY o.order_id
ORDER BY o.order_date ASC;
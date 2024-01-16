create database pizza_sales;
use pizza_sales;
CREATE table orders(
    order_id INT PRIMARY KEY,
    data text,
    time text
);
CREATE table order_details(
    order_details INT PRIMARY KEY,
    order_id int,
    pizza_id text,
    quantity int
);
select * from orders;
select * from pizzas;
select * from pizza_types;
select * from order_details;
create view pizza_details AS
SELECT p.pizza_id,p.pizza_type_id,pt.name,pt.category,p.size,p.price,pt.ingredients
FROM pizzas p
join pizza_types pt
ON pt.pizza_type_id = p.pizza_type_id;
select * from pizza_details ;
alter table orders
modify data DATE;
alter table orders
modify time TIME;
-- total revenue
SELECT round(sum(od.quantity * p.price),2) AS total_revenue
FROM order_details od
JOIN pizza_details p
ON od.pizza_id = p.pizza_id;
-- total no of pizza sold
select sum(od.quantity) AS pizza_sold
FROM order_details od;
-- total orders
select count(distinct(order_id))AS total_orders
FROM order_details;
-- average order value
select sum(od.quantity * p.price)/count(distinct(od.order_id)) as avg_order_value
FROM order_details od
JOIN pizza_details p
ON od.pizza_id = p.pizza_id;
-- average number of pizza per order
SELECT round(sum(od.quantity)/count(distinct (od.order_id)),0) as avg_no_pizza_per_order
FROM order_details od;
-- total revenue and no of orders per category
SELECT p.category , SUM(od.quantity*p.price)as total_revenue,count(distinct(od.order_id)) as total_orders
FROM order_details od
JOIN pizza_details p
ON od.pizza_id = p.pizza_id
GROUP BY p.category;
-- total revenue and number of orders per size
SELECT p.size , SUM(od.quantity*p.price)as total_revenue,count(distinct(od.order_id)) as total_orders
FROM order_details od
JOIN pizza_details p
ON od.pizza_id = p.pizza_id
GROUP BY p.size;
-- hourly,dailyand monthly trend in orders and revenue of pizza
SELECT
    CASE 
	   WHEN HOUR(o.time)BETWEEN 9 AND 12 THEN 'Late Morning'
       WHEN HOUR(o.time)BETWEEN 12 AND 15 THEN 'Lunch'
       WHEN HOUR(o.time)BETWEEN 15 AND 18 THEN 'Mid Afternoon'
       WHEN HOUR(o.time)BETWEEN 18 AND 21 THEN 'Dinner'
       WHEN HOUR(o.time)BETWEEN 21 AND 23 THEN 'Late Night'
       ELSE 'others'
       END AS meal_time,COUNT(DISTINCT(od.order_id)) AS total_orders
FROM order_details od
JOIN orders o ON o.order_id = od.order_id
GROUP BY meal_time
ORDER BY total_orders DESC;
-- weekdays
SELECT dayname(o.data)AS day_name,count(distinct(od.order_id))AS total_orders
FROM order_details od
JOIN orders o
ON o.order_id = od.order_id
GROUP BY DAYNAME(o.data)
ORDER BY total_orders DESC;
-- monthwise trend
SELECT MONTHNAME(o.data)AS day_name,count(distinct(od.order_id))AS total_orders
FROM order_details od
JOIN orders o
ON o.order_id = od.order_id
GROUP BY MONTHNAME(o.data)
ORDER BY total_orders DESC;
-- MOST ORDERED PIZZA
SELECT p.name,p.size,count(od.order_id)AS count_pizzas
FROM order_details od
JOIN pizza_details p
ON od.pizza_id = p.pizza_id
GROUP BY p.name,p.size
ORDER BY count_pizzas DESC;
-- most ordered on the basis of name
SELECT p.name,count(od.order_id)AS count_pizzas
FROM order_details od
JOIN pizza_details p
ON od.pizza_id = p.pizza_id
GROUP BY p.name
ORDER BY count_pizzas DESC
LIMIT 1;
       
-- TOP 5 PIZZAS by revenue
SELECT p.name , SUM(od.quantity*p.price)AS total_revenue
FROM order_details od
JOIN pizza_details p
ON od.pizza_id = p.pizza_id
GROUP BY p.name
ORDER BY total_revenue DESC
LIMIT 5;

-- total pizzas by sale
SELECT p.name , SUM(od.quantity)AS pizzas_sold
FROM order_details od
JOIN pizza_details p
ON od.pizza_id = p.pizza_id
GROUP BY p.name
ORDER BY pizzas_sold DESC
LIMIT 5;

-- pizza analysis
SELECT name,price
FROM pizza_details
ORDER BY price DESC
LIMIT 1;
 -- top used ingredients
SELECT * FROM pizza_details;


CREATE TEMPORARY TABLE numbers AS (
      SELECT 1 AS n UNION ALL
      SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL
      SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL
      SELECT 8 UNION ALL SELECT 9 UNION ALL SELECT 10
);
 SELECT ingredient, COUNT(ingredient)AS ingredient_count
 FROM(
       SELECT SUBSTRING_INDEX(SUBSTRING_INDEX(ingredients,',',n),',',-1)AS ingredient
       FROM order_details
       JOIN pizza_details ON pizza_details.pizza_id = order_details.pizza_id
       JOIN numbers ON CHAR_LENGTH(ingredients) - CHAR_LENGTH(REPLACE(ingredients,',','')) >=n-1
       ) AS subquery
GROUP BY ingredient
ORDER BY ingredient_count DESC












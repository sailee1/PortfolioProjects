--How many pizzas were ordered?
SELECT 
COUNT (*) as pizzas_ordered
FROM customer_orders;

--How many unique customer orders were made?
SELECT
COUNT (DISTINCT order_id) as unique_customer_orders
FROM customer_orders

--How many successful orders were delivered by each runner?
SELECT 
runner_id,
COUNT (ro.order_id) as delivered_orders
FROM runner_orders as ro
WHERE pickup_time <> 'null'
GROUP BY runner_id;

--How many of each type of pizza was delivered?
SELECT 
pn.pizza_name,
COUNT(co.pizza_id) as pizzas_delivered
FROM runner_orders as ro
INNER JOIN customer_orders as co on ro.order_id = co.order_id
INNER JOIN pizza_names as pn on co.pizza_id = pn.pizza_id
WHERE pickup_time <> 'null'
GROUP BY pn.pizza_name;

--How many Vegetarian and Meatlovers were ordered by each customer?
SELECT 
co.customer_id,
pn.pizza_name,
COUNT(co.pizza_id) as pizzas_ordered
FROM customer_orders as co
INNER JOIN pizza_names as pn on co.pizza_id = pn.pizza_id
GROUP BY pn.pizza_name,
co.customer_id;

--What was the maximum number of pizzas delivered in a single order?
SELECT TOP 1
co.order_id,
COUNT(co.pizza_id) as pizzas_ordered
FROM customer_orders as co
INNER JOIN runner_orders as ro on co.order_id = ro.order_id
WHERE pickup_time <> 'null'
GROUP BY co.order_id
ORDER BY COUNT (co.pizza_id) DESC

--For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
SELECT 
  customer_id, 
  SUM(CASE 
    WHEN 
        (
          (exclusions IS NOT NULL AND exclusions<>'null' AND LEN(exclusions)>0) 
        AND (extras IS NOT NULL AND extras<>'null' AND LEN(extras)>0)
        )=TRUE
    THEN 1 
    ELSE 0
  END) as changes, 
  SUM(CASE 
    WHEN 
        (
          (exclusions IS NOT NULL AND exclusions<>'null' AND LEN(exclusions)>0) 
        AND (extras IS NOT NULL AND extras<>'null' AND LEN(extras)>0)
        )=TRUE
    THEN 0 
    ELSE 1
  END) as no_changes 
FROM 
  customer_orders as co 
  INNER JOIN runner_orders as ro on ro.order_id = co.order_id 
WHERE 
  pickup_time<>'null'
GROUP BY 
  customer_id;





--How many pizzas were delivered that had both exclusions and extras?
SELECT 
  COUNT(pizza_id) as pizzas_delivered_with_exclusions_and_extras 
FROM 
  customer_orders as co 
  INNER JOIN runner_orders as ro on ro.order_id = co.order_id 
WHERE 
  pickup_time<>'null'
  AND (exclusions IS NOT NULL AND exclusions<>'null' AND LEN(exclusions)>0) 
  AND (extras IS NOT NULL AND extras<>'null' AND LEN(extras)>0); 
  
-- 9. What was the total volume of pizzas ordered for each hour of the day?
SELECT 
  DATEPART(hh, order_time) as hour, 
  COUNT(*) as ordered_pizzas 
FROM 
  customer_orders 
GROUP BY 
  DATEPART(hh, order_time); 


--What was the volume of orders for each day of the week?
SELECT 
  DATENAME(dw,order_time) as day, 
  COUNT(*) as ordered_pizzas 
FROM 
  customer_orders 
GROUP BY 
  DATENAME(dw, order_time);
create database pizzahutsales;

use pizzahutsales;

create table orders ( 
order_id int not null,
order_date date not null,
order_time time not null,
primary key (order_id) );

create table order_details (
order_details_id int not null,
order_id int not null,
pizza_id text not null,
quantity int not null,
primary key (order_details_id));

-- (1) Retrieve the total number of orders placed.

select count(order_id) as total_orders from orders;


-- (2) Calculate the total revenue generated from pizza sales.
 
 SELECT 
    ROUND(SUM(order_details.quantity * pizzas.price),
            2) AS Total_sales
FROM
    order_details
        JOIN
    pizzas ON pizzas.pizza_id = order_details.pizza_id;
    
-- (3) Identify the highest-priced pizza.
-- Solution 1 with name as well

SELECT 
    pizza_types.name, pizzas.price
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
ORDER BY pizzas.price DESC
LIMIT 1;

-- Solution 2

SELECT 
    MAX(price)
FROM
    pizzas;
    
-- (4) Identify the most common pizza size ordered.

select pizzas.size as Size, count(order_details.pizza_id) as Order_counts
from pizzas
join order_details
on pizzas.pizza_id = order_details.pizza_id
group by Size
order by Order_counts
desc;

-- (5) List the top 5 most ordered pizza types along with their quantities.

SELECT 
    pizza_types.name, SUM(order_details.quantity) AS quantity
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY quantity DESC
LIMIT 5;

-- (6) Join the necessary tables to find the total quantity of each pizza category ordered.

select pizza_types.category,
sum(order_details.quantity) as quantity
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.category order by quantity desc;

select pizza_types.category as Flavor, sum(order_details.quantity) as QTY
from pizza_types 
join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details
on order_details.pizza_id = pizzas.pizza_id
group by Flavor
order by QTY desc;


-- (7) Determine the distribution of orders by hour of the day.

select hour(order_time) as Hour, count(order_id) as Orders_Count
from orders
group by hour(order_time);

-- (8) Join relevant tables to find the category-wise distribution of pizzas.

SELECT 
    category, COUNT(name)
FROM
    pizza_types
GROUP BY category;

-- (9) Group the orders by date 

SELECT 
    orders.order_date, SUM(order_details.quantity) AS QTY
FROM
    orders
        JOIN
    order_details ON orders.order_id = order_details.order_id
GROUP BY orders.order_date;

-- and 

-- calculate the average number of pizzas ordered per day.

SELECT 
    AVG(qty)
FROM
    (SELECT 
        orders.order_date, SUM(order_details.quantity) AS QTY
    FROM
        orders
    JOIN order_details ON orders.order_id = order_details.order_id
    GROUP BY orders.order_date) AS Average_qty_per_day;

-- (10) Determine the top 3 most ordered pizza types based on revenue.

select sum(order_details.quantity * pizzas.price) as revenue, pizza_types.name
from order_details
join pizzas
on pizzas.pizza_id = order_details.pizza_id
join pizza_types
on pizza_types.pizza_type_id = pizzas.pizza_type_id
group by pizza_types.name
order by revenue desc limit 3;
select * from details
Sure! Here are the questions without answers:

### Basic SQL Questions

1. Retrieve all orders placed by a specific customer.

select * from details
where "Customer_Name" = 'Darren Powers'


2. Calculate the total sales for each product.

select "Product_Name" as product, sum("Sales") as totalsales from details
group by product order by totalsales desc



3. Count the number of orders for each shipping mode.

select "Ship_Mode" as shipping_mode, count("Order_ID") as c_ord
from details
group by shipping_mode
order by c_ord desc
 

4. Find the total sales for each region.

select "Region" as region, sum("Sales") as totalsales from details
group by region order by totalsales desc

5. List all unique customer names.

select distinct "Customer_Name" from details

### Intermediate SQL Questions

6. Identify the top 5 most profitable products.

select "Product_Name" as products, sum("Profit") as profit from details
group by products order by profit desc limit 5;



7. Calculate total sales for each month in the dataset.

SELECT TO_CHAR("Order_Date"::timestamp, 'Month') AS order_month,
extract(month from "Order_Date"::timestamp) as months,
sum("Sales") as total_sales
FROM details
group by order_month,months
order by months asc
;



8. Find all orders where a discount was applied.

select * from details
where "Discount" > 0


9. Calculate the average profit per order for each segment.

select "Segment" as segment, round(avg("Profit")::numeric,2) as profits from details
group by segment
order by profits desc


10. Retrieve the total quantity sold for each product category.

select "Category" as category, sum("Quantity") as quantity from details
group by category
order by quantity desc


### Advanced SQL Questions

11. Find the top 3 customers who contributed the highest total sales.

select "Customer_Name" as customers, sum("Sales") as total_sales from details
group by customers
order by total_sales desc limit 3



12. Identify the most frequently ordered product in each region.

select "Region" as region, "Product_Name" as product, sum("Quantity") as total_quantity from details
group  by region,product
order by total_quantity desc


13. Calculate the average shipping time (days) for orders by ship mode.

select "Ship_Mode" as ship_mode, avg("Order_Date"-"Ship_Date") as ship_time from details
group by ship_mode

14. Identify products with a profit margin (profit/sales) below a specified threshold.

SELECT "Product_Name", SUM("Profit") / NULLIF(SUM("Sales"), 0) AS profit_margin
FROM details
GROUP BY "Product_Name"
HAVING (SUM("Profit") / NULLIF(SUM("Sales"), 0)) < 0.2;

select sum("Profit") / NULLIF(sum("Sales"),0) as profit_margin
from details
 



15. Retrieve the total sales, quantity, and profit for each city, ordered by profit.

select "City" as city, sum("Sales") as sales, sum("Quantity") as quantity,
sum("Profit") as profit from details
group by city
order by profit desc



16. Find the top 5 profitable customers for each region.

SELECT *
FROM (
    SELECT "Region" AS region, 
           "Customer_Name" AS customers, 
           SUM("Profit") AS profits,
           DENSE_RANK() OVER (PARTITION BY "Region" ORDER BY SUM("Profit") DESC) AS ranks
    FROM details
    GROUP BY "Region", "Customer_Name"
) AS ranked_customers
WHERE ranks <= 5
ORDER BY region, profits DESC;



17. Calculate the cumulative sales for each product over time.

SELECT "Product_Name", 
       "Order_Date",
       SUM("Sales") OVER (PARTITION BY "Product_Name" ORDER BY "Order_Date" ASC) AS cumulative_sales
FROM details
ORDER BY "Product_Name", "Order_Date";




18. Compare total sales and profit for each category across different regions.

SELECT "Region" AS region, 
       "Category" AS category, 
       SUM("Sales") AS sales, 
       SUM("Profit") AS profit
FROM details
GROUP BY region, category
ORDER BY region, category;





19. Identify the top 3 profitable products for each month.

select * from 
(SELECT TO_CHAR("Order_Date"::timestamp, 'Month') AS months,
extract(month from "Order_Date"::timestamp) as months_no,
       "Product_Name" AS product,
       SUM("Profit") AS total_profit,
       DENSE_RANK() OVER (PARTITION BY TO_CHAR("Order_Date"::timestamp, 'Month') 
                          ORDER BY SUM("Profit") DESC) AS ranks
FROM details
GROUP BY months,months_no,product) as a
where ranks <= 3
order by months_no,ranks asc




20. Determine the customer with the highest average sales per order in each segment.

create view Customer_Avg_Sales AS (
    SELECT "Segment" AS segment, 
           "Customer_Name" AS customers, 
           AVG("Sales") AS avg_sales
    FROM details
    GROUP BY "Segment", "Customer_Name"
)


SELECT segment, 
       customers, 
       avg_sales
FROM (
    SELECT segment, 
           customers, 
           avg_sales,
           ROW_NUMBER() OVER (PARTITION BY segment ORDER BY avg_sales DESC) AS rank
    FROM Customer_Avg_Sales
) AS ranked_customers
WHERE rank = 1
ORDER BY segment;
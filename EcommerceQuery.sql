-- Monthly basic KPIs
SELECT DATENAME(month, order_date) AS month
       ,ROUND(SUM(sales_before_discount), 2) AS sales_before_discount
	   ,ROUND(SUM(profit_after_discount), 2) AS profit_after_discount
	   ,ROUND(SUM(profit_after_discount)/ SUM(sales_before_discount), 2) AS profit_margin	 	  
FROM Orders 
GROUP BY DATENAME(month, order_date)
ORDER BY MIN(order_date);

--Discounts
SELECT DATENAME(month, d.order_date) AS month
      ,ROUND(AVG(d.discount), 2) AS avg_discount
	  ,MAX(d.discount) max_discount_given
	  ,ROUND(SUM(o.sales_before_discount * d.discount), 2) AS discount_$
FROM Discounts AS d
JOIN Orders AS o
ON d.order_id = o.order_id
GROUP BY DATENAME(month, d.order_date)
ORDER BY MIN(d.order_date);



-- Number of Orders, customers, repeating customers, and rate of repeating customers
SELECT DATENAME(month,order_date) AS month
       ,COUNT(DISTINCT order_id) AS number_of_orders
	   ,COUNT(DISTINCT customer_id) AS number_of_customers
	   ,COUNT(DISTINCT order_id) - COUNT(DISTINCT customer_id) AS number_of_repeating_customers
	   ,(COUNT(DISTINCT order_id) - COUNT(DISTINCT customer_id))* 100 / COUNT(DISTINCT customer_id) AS rate_repeating_customers
FROM Customers 
GROUP BY DATENAME(month,order_date)
ORDER BY MIN(order_date);

-- Segments
SELECT cus.segment
       ,COUNT(DISTINCT ord.order_id) AS number_of_orders
	   ,ROUND(SUM(ord.sales_before_discount), 2) AS sales
FROM Customers AS cus
JOIN Orders AS ord
ON cus.order_id = ord.order_id
GROUP BY cus.segment
ORDER BY sales DESC;

-- Categories and sub-categories Sales
SELECT  DATENAME(month,ord.order_date) AS month
        ,ord.category
		,ord.sub_category
		,SUM(ord.quantity) AS number_of_products_sold
		,SUM(ord.sales_before_discount) sales_before_discount
		,ROUND(SUM(ord.profit_after_discount),2) AS profit_after_discount
		,ROUND((SUM(ord.sales_before_discount * dis.discount))/SUM(ord.sales_before_discount),2) AS discount_percent
FROM Orders AS ord
JOIN Discounts AS dis
ON ord.order_id = dis.order_id
GROUP BY DATENAME(month, ord.order_date),
         ord.category
		 ,ord.sub_category
ORDER BY MIN(ord.order_date),
         profit_after_discount DESC;

-- Where are we generating negative profits
SELECT  DATENAME(month,ord.order_date) AS month
        ,ord.category
		,ord.sub_category
		,ord.product_name
		,ROUND(SUM(ord.sales_before_discount),2) AS sales_before_discount
		,ROUND((SUM(ord.sales_before_discount * dis.discount))/SUM(ord.sales_before_discount),2) AS discount_percent
		,ROUND(SUM(ord.sales_before_discount * dis.discount),2) AS discount_$
		,ROUND(SUM(ord.profit_after_discount),2) AS profit_after_discount		
FROM Orders AS ord
JOIN Discounts AS dis
ON ord.order_id = dis.order_id
GROUP BY DATENAME(month, ord.order_date),
         ord.category
		 ,ord.sub_category
		 ,ord.product_name
HAVING SUM(profit_after_discount) <= 0
ORDER BY MIN(ord.order_date);

-- TOP  products sold 2020
SELECT TOP (15) 
       product_name
       ,category
	   ,sub_category
	   ,SUM(quantity) AS number_of_products_sold
	   ,ROUND(SUM(profit_after_discount) / SUM(quantity), 2) AS profit_per_item
	   ,ROUND(SUM(profit_after_discount),2) AS total_profit
FROM Orders
GROUP BY product_name
         ,category
	     ,sub_category
ORDER BY profit_per_item DESC;

-- worst products 2020
SELECT TOP (20) 
       product_name
       ,category
	   ,sub_category
	   ,SUM(quantity) AS number_of_products_sold
	   ,ROUND(SUM(profit_after_discount) / SUM(quantity), 2) AS loss_per_item
	   ,ROUND(SUM(profit_after_discount),2) AS profit_loss
FROM Orders
GROUP BY product_name
         ,category
	     ,sub_category
HAVING SUM(profit_after_discount) <=0
ORDER BY profit_loss ASC;


SELECT DATENAME(month, order_date) AS month
	   ,ROUND(SUM(sales_before_discount), 2) AS sales_before_discount
FROM Orders
GROUP BY DATENAME(month,order_date)
ORDER BY MIN(order_date);
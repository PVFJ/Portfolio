SELECT ord.order_date
       ,ord.order_id
	   ,cust.customer_id
	   ,CONCAT(cust.first_name, ' ', cust.last_name) AS 'customer_name'
	   ,brand.brand_name
	   ,prod.product_name
	   ,cat.category_name AS 'category'
	   ,SUM(item.quantity) AS 'quantity_sold'
	   ,item.list_price
	   ,SUM(item.quantity) * item.list_price AS 'revenue'
	   ,stor.store_name
	   ,stor.state
	   ,CONCAT(sta.first_name, ' ', sta.last_name) AS 'sales_rep'
FROM production.products AS prod
JOIN production.brands AS brand
ON prod.brand_id = brand.brand_id
JOIN production.categories AS cat
ON prod.category_id = cat.category_id
JOIN sales.order_items AS item
ON prod.product_id = item.product_id
JOIN sales.orders AS ord
ON item.order_id = ord.order_id
JOIN sales.customers AS cust
ON ord.customer_id = cust.customer_id
JOIN sales.staffs AS sta
ON ord.staff_id = sta.staff_id
JOIN sales.stores AS stor
ON ord.store_id = stor.store_id
GROUP BY ord.order_date
         ,ord.order_id
	     ,cust.customer_id
	     ,CONCAT(cust.first_name, ' ', cust.last_name)
	     ,brand.brand_name
	     ,prod.product_name
		 ,cat.category_name
		 ,item.list_price
	     ,stor.store_name
	     ,stor.state
	     ,CONCAT(sta.first_name, ' ', sta.last_name);
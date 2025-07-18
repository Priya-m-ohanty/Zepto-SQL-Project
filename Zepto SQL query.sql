CREATE TABLE zepto (
  sku_id SERIAL PRIMARY KEY,
  category VARCHAR(120),
  name VARCHAR(150) NOT NULL,
  mrp NUMERIC(8,2),
  discountPercent NUMERIC(5,2),
  availableQuantity INTEGER,
  discountedSellingPrice NUMERIC(8,2),
  weightInGms INTEGER,
  outOfStock BOOLEAN,
  quantity INTEGER
);

--count rows
SELECT COUNT (*) FROM zepto;

--Limit 20
SELECT * FROM zepto
LIMIT 20;

--check Null Values 

SELECT * FROM zepto
where name Is NULL
Or category Is NULL
Or mrp Is NULL
Or discountpercent Is NULL
Or availablequantity Is NULL;

-- product category
Select category AS Product_category FROM zepto
Group By Category;

---products in stocks vs out of stock
SELECT outofstock, count(sku_id) FROM zepto
GROUP BY 1;

--products present multiple times, representing different SKUs

SELECT name, COUNT(sku_id) as number_of_SKUs
FROM zepto
GROUP BY 1
HAVING COUNT(sku_id) > 1
ORDER BY COUNT(sku_id) DESC; 

---Data cleaning--
SELECT * FROM zepto
where mrp= 0 or discountedSellingPrice= 0;

DELETE FROM zepto
WHERE mrp= 0;

--convert paise to rupees
UPDATE zepto
SET mrp= mrp/100.0,
discountedSellingPrice = discountedSellingPrice/100.0;

SELECT mrp,discountedSellingPrice FROM Zepto;

---Found top 10 best-value products based on discount percentage
SELECT DISTINCT name,mrp, discountpercent FROM zepto
ORDER BY discountpercent DESC
LIMIT 10;

---Identified high-MRP products that are currently out of stock
SELECT DISTINCT name, mrp FROM zepto
WHERE outofstock = TRUE and mrp > 200
ORDER BY mrp DESC;

---Estimated potential revenue for each product category
SELECT category, 
SUM (discountedsellingprice * availablequantity) AS estimated_revenue
FROM zepto 
GROUP BY 1
ORDER BY estimated_revenue;

--Filtered expensive products (MRP > ₹500) with minimal discount is less than 10 

SELECT DISTINCT name, mrp, discountpercent FROM zepto 
WHERE mrp > 500 AND discountpercent < 10
ORDER BY mrp DESC, discountpercent DESC;

---Ranked top 5 categories offering highest average discounts
SELECT category, 
ROUND(AVG(discountpercent),2) As avg_discount_percent FROM zepto
GROUP BY 1
ORDER BY avg_discount_percent DESC
LIMIT 5;

---Calculate price per gram for Product above 100gms to identify value-for-money products
SELECT name, weightInGms, discountedSellingPrice, 
ROUND(discountedSellingPrice/weightInGms,2) AS price_per_grm
FROM zepto
WHERE weightInGms >= 100
ORDER BY price_per_grm;
---Grouped products based on weight into Low, Medium, and Bulk categories
SELECT DISTINCT name, weightInGms,
CASE WHEN weightInGms < 1000 THEN 'low'
     WHEN weightInGms < 5000 THEN 'Medium'
	 ELSE 'Bulk'
	 END AS weight_category FROM zepto; 

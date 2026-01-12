create database zepto_project;

drop table if exists zepto;

create table zepto(
sku_id serial primary key,
Category varchar(120),
name varchar(150) not null,
mrp numeric(8,2),
discountPercent numeric(5,2),
availableQuantity integer,
discountedSellingPrice numeric(8,2),
weightInGms integer,
outOfStock integer,
quantity integer
);

-- Data Exploration

-- count of rows
select count(*) from zepto;

-- sample data
select * from zepto
limit 10;

-- null value
select * from zepto
where Category is null
or
name is null
or
mrp is null
or
discountPercent is null
or
availableQuantity is null
or
discountedSellingPrice is null
or
weightInGms is null
or
outOfStock is null
or
quantity is null;

-- Different Product Categories
SELECT DISTINCT category 
from zepto
order by Category;

-- Product in stock and out of stock
select outOfStock, count(sku_id)
from zepto
group by outOfStock;  

-- product names presents multiple times
select name, count(sku_id) as "Number of SKUs"
FROM zepto
group by name
having count(sku_id) > 1
order by count(sku_id) desc;

-- Data Cleaning

-- Checkingthe Product with price = 0
select * from zepto
where mrp = 0 or discountedSellingPrice = 0;

-- Convert paise to rupees
SET SQL_SAFE_UPDATES = 0;
UPDATE zepto
SET 
mrp = mrp/100.0,
discountedSellingPrice = discountedSellingPrice/100.0;

SET SQL_SAFE_UPDATES = 1;

select mrp, discountedSellingPrice FROM zepto;


-- Q1 Find the top 10 best value product based on the discount percentage
SELECT DISTINCT name, mrp, discountPercent
from zepto
order by discountPercent desc
limit 10;

-- Q2 What are the product with high mrp but Out of Stock
SELECT distinct name, mrp
from zepto
where outOfStock = 0 and mrp > 300
order by mrp desc;

-- Q3 Calculating Estimated Revenue for Each Category
SELECT Category, sum(discountedSellingPrice * availableQuantity) as total_revenue
from zepto
group by Category
order by total_revenue;

-- Q4 Find all products where mrp is greater than 500 and discount is less than 10%
SELECT distinct name, mrp, discountPercent
from zepto
where mrp > 500 and discountPercent < 10
order by mrp desc, discountPercent desc; 

-- Q5 Identify the top 5 categories offering the highest average discount percentage
SELECT distinct category, avg(discountPercent)
from zepto
group by category
order by avg(discountPercent) desc
limit 5;

-- Q6 Find the Price per gram for products above 100g and sort by best value
SELECT distinct name, weightInGms, discountedSellingPrice,
round(discountedSellingPrice/weightInGms,2) as price_per_gram
from zepto
where weightInGms >= 100
order by price_per_gram;

-- Q7 Group the product into categories like low,medium, bulk
select distinct name, weightInGms,
case when weightInGms < 1000 then 'Low'
	when weightInGms < 5000 then 'Medium'
    else 'Bulk'
    end AS weight_category
from zepto;

-- Q8 What is the Total Inventory weight per category
select category, sum(weightInGms * availableQuantity) as total_weight
from zepto
group by category
order by total_weight desc;
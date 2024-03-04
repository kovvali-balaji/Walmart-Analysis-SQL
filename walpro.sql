-- Create database
CREATE DATABASE IF NOT EXISTS walmartSales;

USE walmartSales;

-- Create table
CREATE TABLE IF NOT EXISTS sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct FLOAT(6,4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11,9),
    gross_income DECIMAL(12, 4),
    rating FLOAT(2, 1)
);

-- -------** ANALYZING **------------
SELECT * FROM walmartsales.sales;
select * from sales;
-- cleaning the data
SELECT time,
       (CASE 
            WHEN time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
            WHEN time BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
            ELSE 'Evening'
        END) AS time_of_day 
FROM sales;
ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);
UPDATE sales
SET time_of_day = 
    CASE 
        WHEN time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
        WHEN time BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
        ELSE 'Evening'
    END;
    
    
-- DAY NAME
SELECT 
	date,
    DAYNAME(date) AS dayname
 FROM sales;
 ALTER TABLE sales ADD COLUMN dayname VARCHAR(10);
 UPDATE sales
 SET dayname=DAYNAME(date);
       
-- MONTH NAME---------------------------------------
	SELECT 
		date,
		MONTHNAME(date) AS month_name
		FROM sales;
	ALTER TABLE sales ADD COLUMN month_name VARCHAR(20);

	UPDATE sales SET month_name = MONTHNAME(date);
    
-- -------------------------------
-- GENERAL QUESTIONS -------------
-- 1.HOW MANY UNIQUE CITIES DOES THE DATA HAVE?--

select distinct city as cities_in_data from sales;

-- 2.In which city is each branch?--
 
 select distinct branch from sales;
 select distinct city,branch from sales;
 
 -- ----ABOUT PRODUCTS-------
 -- 1.How many unique product lines does the data have? and Most selling products?
 
 select distinct product_line as products from sales; 
 select count(distinct product_line) as no_of_product from sales;
  select 
	product_line,count( product_line) as product_count from sales
    group by product_line
    order by product_count desc;
select distinct product_line from sales;
    
-- 2.What is the most common method?--
 
 select 
	 payment,count(payment) as payment_count from sales
     group by payment
     order by payment_count desc;

-- 3.What is the total revenue by month?-----
select
	month_name,sum(total) as total_revenue from sales
    group by month_name
    order by total_revenue desc;

-- 4.What month had the largest COGS?-----

select
	month_name,sum(cogs) as total_cogs from sales
    group by month_name
    order by total_cogs desc;
 
 -- 5.What product_line had the largest revenue?
 
 select 
	product_line,
    sum(total) as total_revenue from sales
    group by product_line
    order by total_revenue desc;
 
 -- 6.what is the city with largest revenue?
  
  select  
	city ,sum(total) as total_revenue from sales
	group by city
    order by total_revenue desc;

select  
	city ,branch,sum(total) as total_revenue from sales
	group by city,branch
    order by total_revenue desc;
    
-- 7.What product line  had the largest VAT?
 
 select
	product_line,
    avg(tax_pct) as avg_tax from sales
    group by product_line
    order by avg_tax desc;

-- 8.Which branch sold more product than averge product sold?
 
select 
	branch,
    sum(quantity) as qty from sales
    group by branch
    having qty > (select avg(quantity) from sales);
 
 -- What is the most common product line by gender?
 
 select
	gender,
    product_line,
    count(gender) as total_cnt from sales
    group by gender,product_line
    order by total_cnt desc;
    
-- 9.What is the average rating of each product line?
select 
	round(avg(rating),2) as avg_rating,
    product_line from sales
    group by product_line
    order by avg_rating;

 -- -------------*** SALES ***----------------------
 -- 1.Number if sales made in each time of the day per weekday

select 
	time_of_day,
    count(*) as total_sales from sales
    group by time_of_day
    order by total_sales;
    
-- If you want any perticular day?

select 
	time_of_day,
    count(*) as total_sales from sales
    where dayname="Monday"
    group by time_of_day
    order by total_sales;
    
-- 2.Which type of customer types bring the most revenue?

select 
		customer_type,
        round(sum(total),2) as total_rev from sales
        group by customer_type
        order by total_rev;

-- 3.Which city has a largest tax or VAT?
 select 
  city,
  round(avg(tax_pct),2) as avg_tax from sales
  group by city
  order by avg_tax desc;
  
-- 4.Which customer type pays the most in TAX;
 select 
	customer_type,
    round(avg(tax_pct),2) as avg_tax from sales
  group by customer_type
  order by avg_tax desc;

-- ----------------------------------------------------------  
-- ------------*** CUSTOMERS ***-----------------------------

-- 1.How many unique customer types does the data have?

select 
	distinct customer_type from sales;
    
-- 2.How many unique payment method does the data have?

select 
	distinct payment from sales;

-- 3. What is the most common customer type?

select 
	 customer_type,
     count(*) as cnt from sales
     group by customer_type
     order by cnt desc;
     
-- 4.What gender type buy the most?

select 
	 gender,
     count(*) as cnt from sales
     group by gender
     order by cnt desc;
     
-- 5.What is the gender distribution per branch?

select 
	 gender,
     count(*) as cnt from sales
     where branch="A"
     group by gender
     order by cnt desc;
select 
	 gender,
     count(*) as cnt from sales
     where branch="B"
     group by gender
     order by cnt desc;
select 
	 gender,
     count(*) as cnt from sales
     where branch="C"
     group by gender
     order by cnt desc;
     
-- 6.Which time of the day do customers give most rating?

select 
	time_of_day ,
	round(avg(rating),2) as avg_rating
    group by time_of_day
    order by avg_rating desc;
    
-- 7.Which time of the day do customers give most rating per branch?

select 
	time_of_day ,
	round(avg(rating),2) as avg_rating
    from sales
    where branch="A"
    group by time_of_day
    order by avg_rating desc;

select 
	time_of_day ,
	round(avg(rating),2) as avg_rating
    from sales
    where branch="B"
    group by time_of_day
    order by avg_rating desc;

select 
	time_of_day ,
	round(avg(rating),2) as avg_rating
    from sales
    where branch="C"
    group by time_of_day
    order by avg_rating desc;
    
-- 8.Which day of the week has best avg rating?

select
	dayname,
    avg(rating) as avg_rating from sales
    group by dayname
    order by avg_rating desc;
    
-- 9.Which day of the week has best avg rating per branch?

select
	dayname,
    avg(rating) as avg_rating from sales
    where branch="A"
    group by dayname
    order by avg_rating desc;

select
	dayname,
    avg(rating) as avg_rating from sales
    where branch="B"
    group by dayname
    order by avg_rating desc;
     
select
	dayname,
    avg(rating) as avg_rating from sales
    where branch="C"
    group by dayname
    order by avg_rating desc;
	
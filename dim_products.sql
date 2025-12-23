-- dim_products created
create or replace table analytics_schema.dim_products as 
with products_cte as (
select
try_to_number(c.id) as category_id,
initcap(nullif(trim(c.category_name), '')) as category_name,
try_to_number(p.id) as product_id,
initcap(nullif(trim(p.product_name), '')) as product_name,
try_to_decimal(p.sale_price, 10, 2) as sale_price,
try_to_decimal(p.cost_price, 10, 2) as cost_price,
try_to_number(p.stock_quantity) as stock_quantity,
current_timestamp() as loaded_at
from 
raw_schema.category c join raw_schema.products p on 
try_to_number(c.id) = try_to_number(p.category_id)
),
feature_engineering_cte as (
select 
category_id,
category_name,
product_id,
product_name,
sale_price,
cost_price,
sale_price - cost_price as profit_amount,
round((sale_price - cost_price) * 100.0 / nullif(sale_price, 0), 2) as profit_margin_pct,
stock_quantity,
case 
    when stock_quantity = 0 then 'Out of Stock'
    when stock_quantity < 10 then 'Very Low'
    when stock_quantity < 25 then 'Low'
    when stock_quantity < 50 then 'Medium'
    when stock_quantity < 100 then 'Moderate'
    else 'High Stock'
end as stock_status,
case 
    when sale_price >= 1000 then 'Luxury'
    when sale_price >= 800 then 'Premium'
    when sale_price >= 500 then 'High'
    when sale_price >= 250 then 'In Budget'
    when sale_price >= 100 then 'Economy'
    else 'Low Price'
end as price_segment,
loaded_at
from 
products_cte
)
select 
category_id,
category_name,
product_id,
product_name,
sale_price,
cost_price,
profit_amount,
profit_margin_pct,
stock_quantity,
stock_status,
price_segment,
case 
    when profit_margin_pct > 75 then 'Very High'
    when profit_margin_pct > 50 then 'High Margin'
    when profit_margin_pct > 25 then 'Moderate'
    when profit_margin_pct > 10 then 'Medium'
    when profit_margin_pct >= 0 then 'Low Margin'
    else 'Negative Margin'
end as margin_category,
loaded_at
from 
feature_engineering_cte;

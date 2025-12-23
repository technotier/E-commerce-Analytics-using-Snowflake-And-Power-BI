-- face sales created
create or replace table analytics_schema.fact_sales as 
with base_cte as (
select
try_to_number(o.id) as order_id,
try_to_number(o.customer_id) as customer_id,
to_number(to_char(try_to_date(o.order_date), 'YYYYMMDD')) as date_key,
try_to_date(o.order_date) as order_date,
initcap(nullif(trim(o.order_status), '')) as order_status,
try_to_number(oi.id) as order_item_id,
try_to_number(oi.product_id) as product_id,
try_to_number(oi.quantity) as quantity,
try_to_decimal(oi.unit_price, 10, 2) as unit_price,
try_to_decimal(dp.cost_price, 10, 2) as cost_price,
coalesce(try_to_decimal(discounts, 10, 2), 0) as discounts,
case 
    when discounts > 0 then 'Discounted'
    else 'Full Price'
end as discount_flag,
current_timestamp() as loaded_at
from 
raw_schema.orders o join raw_schema.order_items oi on 
try_to_number(o.id) = try_to_number(oi.order_id) join analytics_schema.dim_products dp on 
try_to_number(oi.product_id) = dp.product_id
),
feature_engineering_cte as (
select
order_id,
customer_id,
date_key,
order_date,
order_status,
order_item_id,
product_id,
quantity,
unit_price,
cost_price,
quantity * unit_price as gross_amount,
discounts,
discount_flag,
(quantity * unit_price) - discounts as net_amount,
quantity * cost_price as total_cost,
case 
    when quantity >= 10 then 'Bulk Order'
    when quantity >= 5 then 'Mid Size'
    when quantity >= 2 then 'Small Order'
    else 'Single Order'
end as order_size,
loaded_at
from 
base_cte
)
select
order_id,
customer_id,
date_key,
order_date,
order_status,
order_item_id,
product_id,
quantity,
unit_price,
cost_price,
gross_amount,
discounts,
discount_flag,
net_amount,
total_cost,
net_amount - total_cost as net_profit,
order_size,
loaded_at
from 
feature_engineering_cte;

with store_orders as (
    select
        order_id
        , order_line_id
        , customer_id
        , product_id
        , cast(order_created_date as date) as order_created_date
        , market
        , currency
        , sales_price_after_discount
        , shipping_city
        , row_number() over (
            partition by order_line_id order by order_created_date desc
        ) as rn
    from {{ source('TIBBER', 'STORE_ORDERS') }}
)
select * from store_orders
where rn = 1

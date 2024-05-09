with fct_order as (
    select
        order_id
        , order_line_id
        , customer_id
        , product_id
        , order_created_date
        , sales_price_after_discount
        , currency
        , shipping_city
        , market
        , active_customer_subscription
    from {{ ref('stg__fct_order') }}
)
select * from fct_order

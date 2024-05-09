with store_orders as (
    select *
    from {{ ref('src__store_orders') }}
)
, subscriptions as (
    select * from {{ ref('stg__subscription_active') }}
)
,
fct_order as (
    select
        store_orders.order_id
        , store_orders.order_line_id
        , store_orders.customer_id
        , store_orders.product_id
        , store_orders.order_created_date
        , store_orders.sales_price_after_discount
        , store_orders.currency
        , store_orders.shipping_city
        , store_orders.market
        , case
            when subscriptions.customer_id is not null then 'Yes'
            else 'No'
        end as active_customer_subscription

    from
        store_orders
    left join
        subscriptions on
        store_orders.customer_id = subscriptions.customer_id
        and store_orders.order_created_date between subscriptions.subscription_validfrom and subscriptions.subscription_validto
)
select * from fct_order

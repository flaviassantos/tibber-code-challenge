with dim_calendar as (
    select * from {{ ref('mart__dim_calendar') }}
)
, fct_order as (
    select * from {{ ref('mart__fct_order') }}
)
, kpi as (
    /* Number of orders per active subscriptions over time (month) */
    select
        dim_calendar.year_month
        , count(distinct fct_order.order_id) as nr_orders
    from fct_order
    left join dim_calendar on fct_order.order_created_date = dim_calendar.date_day
    where fct_order.active_customer_subscription = 'Yes'
    group by dim_calendar.year_month, dim_calendar.year_month_number
    order by dim_calendar.year_month_number asc
)
select * from kpi

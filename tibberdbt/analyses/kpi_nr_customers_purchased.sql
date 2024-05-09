with dim_customer as (
    select * from {{ ref('mart__dim_customer') }}
)
, fct_order as (
    select * from {{ ref('mart__fct_order') }}
)
, kpi_nr_customers_purchased as (
    select count(distinct fct_order.customer_id) as nr_customers_purchased
    from fct_order
    inner join dim_customer on fct_order.customer_id = dim_customer.customer_id
)
select * from kpi_nr_customers_purchased

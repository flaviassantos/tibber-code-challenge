with kpi_nr_orders as (
    select count(distinct order_id) as nr_orders
    from {{ ref('mart__fct_order') }}
)
select * from kpi_nr_orders

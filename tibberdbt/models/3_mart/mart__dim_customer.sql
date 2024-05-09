with dim_customer as (
    select
        customer_id
        , customer_country
        , customer_city
        , acquisition_channel
    from {{ ref('src__customers') }}
)
select * from dim_customer

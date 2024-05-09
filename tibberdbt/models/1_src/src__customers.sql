with customers as (
    select
        customer_id
        , customer_created_date
        , customer_country
        , customer_city
        , acquisition_channel
    from {{ source('TIBBER', 'CUSTOMERS') }}
)
select * from customers

with raw_products as (
    select distinct
        product_id
        , product_name
        , product_category
    from {{ source('TIBBER', 'STORE_ORDERS') }}
)
, products as (
    select
        *
        , count(*) over (partition by product_id) as product_count
        , row_number() over (
            partition by product_id
            order by case when product_name is not null then 0 else 1 end
        ) as rn
    from raw_products
)

, dim_product as (
    select
        product_id
        , case
            when product_count = 1 and product_name is null then '*Product name missing'
            else coalesce(product_name, first_value(product_name) over (partition by product_id order by rn))
        end as product_name
        , case
            when product_count = 1 and product_category is null then '*Product category missing'
            else coalesce(product_category, first_value(product_category) over (partition by product_id order by rn))
        end as product_category
    from products
    where rn = 1
    order by product_name asc
)
select * from dim_product

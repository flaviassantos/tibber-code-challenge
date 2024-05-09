with dim_product as (
    select
        product_id
        , product_name
        , product_category
    from {{ ref('stg__dim_product') }}
)
select * from dim_product

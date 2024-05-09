with dim_product as (
    select
        product_id -- create business key from macros
        , product_name -- needs massive cleaning
        , product_category -- needs massive cleaning
    from {{ ref('src__products') }}
)
select * from dim_product

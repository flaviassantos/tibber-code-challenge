with subscriptions as (
    select
        subsription_id as subscription_id
        , customer_id
        , cast(subscription_createdat as date) as subscription_createdate
        , cast(subscription_validfrom as date) as subscription_validfrom
        , cast(subscription_validto as date)
            as subscription_validto
        , country as subscription_country
    from
        {{ source('TIBBER', 'SUBSCRIPTIONS') }}
)
select * from subscriptions

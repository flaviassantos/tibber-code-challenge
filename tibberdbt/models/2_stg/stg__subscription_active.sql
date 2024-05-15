{{
  config(
    materialized = 'ephemeral'
    )
}}

with subscriptions as (
    select
        *
        , row_number() over (
            partition by
                customer_id
                , subscription_createdate, subscription_validfrom
                , subscription_validto
            order by subscription_id desc
        ) as rn
    from
        {{ ref('src__subscriptions') }}
    where subscription_id is not NULL and subscription_validfrom is not NULL
)
, unique_subscriptions as (
    select
        subscription_id
        , customer_id
        , subscription_createdate
        , subscription_validfrom
        , subscription_validto
        , subscription_country
    from subscriptions
    where rn = 1
    order by subscription_validfrom desc
)
, overlapping_subscription as (
    select distinct
        s1.subscription_id
        , least(s1.subscription_validfrom, s2.subscription_validfrom) as subscription_validfrom
        , greatest(s1.subscription_validto, s2.subscription_validto) as subscription_validto
    from unique_subscriptions as s1
    inner join unique_subscriptions as s2
        on
            s1.customer_id = s2.customer_id
            and s1.subscription_id <> s2.subscription_id
            and s1.subscription_validfrom <= s2.subscription_validto
            and s1.subscription_validto >= s2.subscription_validfrom
)
, active_unique_subscriptions as (
    select distinct
        unique_subscriptions.customer_id
        , unique_subscriptions.subscription_country
        , coalesce(overlapping_subscription.subscription_validfrom, unique_subscriptions.subscription_validfrom) as subscription_validfrom
        , coalesce(overlapping_subscription.subscription_validto, unique_subscriptions.subscription_validto) as subscription_validto
    from unique_subscriptions
    left join overlapping_subscription on unique_subscriptions.subscription_id = overlapping_subscription.subscription_id
)
select * from active_unique_subscriptions

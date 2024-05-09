with dim_calendar as (
    select
        date_day
        , year
        , year_month
        , year_month_number
        , month_name
        , week_day_name
    from {{ ref('src__calendar') }}
)
select * from dim_calendar

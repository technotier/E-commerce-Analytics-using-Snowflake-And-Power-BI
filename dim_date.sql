-- dim_date created
create or replace table analytics_schema.dim_date as
with date_range as (

    select
        min(order_date) as start_date,
        max(order_date) as end_date
    from raw_schema.orders
),

date_spine as (

    select
        dateadd(
            day,
            seq4(),
            (select start_date from date_range)
        ) as full_date
    from table(generator(rowcount => 1000))
    where full_date <= (select end_date from date_range)
)

select
    /* Stable Surrogate Key */
    to_number(to_char(full_date, 'YYYYMMDD'))          as date_key,

    full_date,

    /* Day */
    day(full_date)                                     as day_of_month,
    dayofweekiso(full_date)                            as day_of_week_iso, -- 1=Mon
    dayname(full_date)                                 as day_name,

    iff(dayofweekiso(full_date) >= 6, true, false)     as is_weekend,
    iff(dayofweekiso(full_date) < 6, true, false)      as is_weekday,

    /* Week */
    weekofyear(full_date)                              as week_of_year,

    /* Month */
    month(full_date)                                   as month_number,
    monthname(full_date)                               as month_name,
    to_char(full_date, 'YYYY-MM')                      as year_month,

    /* Quarter */
    quarter(full_date)                                 as quarter_number,
    concat('Q', quarter(full_date))                    as quarter_name,

    /* Year */
    year(full_date)                                    as year_number,

    /* Season */
    case
        when month(full_date) in (12, 1, 2) then 'Winter'
        when month(full_date) in (3, 4, 5) then 'Spring'
        when month(full_date) in (6, 7, 8) then 'Summer'
        else 'Fall'
    end                                                 as season,

    /* Period Boundaries */
    iff(full_date = date_trunc('month', full_date), true, false)
                                                       as is_month_start,
    iff(full_date = last_day(full_date), true, false)
                                                       as is_month_end,

    iff(full_date = date_trunc('quarter', full_date), true, false)
                                                       as is_quarter_start,
    iff(full_date = last_day(full_date, 'quarter'), true, false)
                                                       as is_quarter_end,

    iff(full_date = date_trunc('year', full_date), true, false)
                                                       as is_year_start,
    iff(full_date = last_day(full_date, 'year'), true, false)
                                                       as is_year_end,

    /* Holidays (basic example) */
    case
        when month(full_date) = 1  and day(full_date) = 1  then 'New Year'
        when month(full_date) = 12 and day(full_date) = 25 then 'Christmas'
        else null
    end                                                 as holiday_name,

    current_timestamp()                                as loaded_at

from date_spine
order by full_date;

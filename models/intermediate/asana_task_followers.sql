with task_follower as (
    
    select *
    from {{ var('task_follower') }}

),

user as (

    select * 
    from {{ var('user') }}

),

agg_followers as (

    select
        task_follower.task_id,
        string_agg( concat("'", user.user_name, "'"), ", " ) as followers,
        count(*) as number_of_followers
    from task_follower 
    join user 
        on user.user_id = task_follower.user_id
    group by 1
    
)

select * from agg_followers
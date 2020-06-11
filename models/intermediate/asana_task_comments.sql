with comments as (
    
    select *
    from {{ ref('asana_task_story') }}
    where comment_content is not null -- if the initial logic is pretty simple, feel free to simplify, like so

),

user as (
    
    select *
    from {{ ref('stg_asana_user') }}
),

join_user_comments as (

    select
    comments.target_task_id as task_id,
    comments.created_at as commented_at,
    comments.comment_content,
    user.user_name

    from
    comments
    left join user 
        on user.user_id = comments.created_by_user_id 

   --  order by task_id, comments.created_at asc

),

task_conversation as (

    select
        task_id,
        string_agg(concat(cast(commented_at as string), '  -  ', user_name, ':  ', comment_content), '\n' order by commented_at asc) as conversation,
        count(*) as number_of_comments

    from join_user_comments        
    group by 1
)

select * from task_conversation

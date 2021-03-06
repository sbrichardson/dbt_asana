with task as (

    select * 
    from {{ var('task') }}

    where assignee_user_id is not null
),

user as (

    select *
    from {{ var('user') }}
),

task_assignee as (

    select
        task.task_id,
        task.assignee_user_id,
        user.user_name as assignee_name,
        user.email as assignee_email

    from task join user 
        on task.assignee_user_id = user.user_id
)

select * from task_assignee
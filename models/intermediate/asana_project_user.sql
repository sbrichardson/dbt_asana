-- Note all references to staging tables should be reformatted as variables : {{ ref('stg_asana_project_task') }} --> {{ var('project_task') }}  
-- this is needed now that the update to the dbt_project.yml file has been updated with the variables.
-- this note applies to all model files :)

with project_tasks as (
    
    select *
    from {{ var('project_task') }}  
),

-- pull tags to connect projects <> users
assigned_tasks as (
    
    select * 
    from {{ ref('stg_asana_task') }}
    where assignee_user_id is not null
),

project as (
    
    select *
    from {{ ref('stg_asana_project') }}

),

project_assignee as (

    select
        project_tasks.project_id,
        project_tasks.task_id,
        assigned_tasks.assignee_user_id

    from project_tasks 
    join assigned_tasks 
        on assigned_tasks.task_id = project_tasks.task_id

),

project_owner as (

    select 
        project_id,
        owner_user_id

    from project
    
    where owner_user_id is not null
),

project_user as (
    select
        project_id,
        owner_user_id as user_id,
        'owner' as role
    
    from project_owner

    union all

    select
        project_id,
        assignee_user_id as user_id,
        'task assignee' as role
    
    from project_assignee

)
-- TOOD: should we include task followers? 
select * from project_user
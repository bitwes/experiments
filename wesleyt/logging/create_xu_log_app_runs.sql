-- Create table
create table XU_LOG_APP_RUNS
(
  app_id          VARCHAR2(100) not null,
  run_id          NUMBER not null,
  start_timestamp TIMESTAMP(6)
)
tablespace USERS
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
-- Add comments to the table 
comment on table XU_LOG_APP_RUNS
  is 'Associates a run with an application';
-- Add comments to the columns 
comment on column XU_LOG_APP_RUNS.app_id
  is 'The unique ID of the application this run is for';
comment on column XU_LOG_APP_RUNS.run_id
  is 'The unique ID for this run.  This is generated from <a sequence>.';
comment on column XU_LOG_APP_RUNS.start_timestamp
  is 'The time the run was started';

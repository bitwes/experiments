-- Create table
create table XU_LOG_RUN_MSGS
(
  run_id        NUMBER not null,
  msg_type      NUMBER not null,
  msg_timestamp TIMESTAMP(6) not null,
  module        VARCHAR2(100),
  text          VARCHAR2(2000)
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
comment on table XU_LOG_RUN_MSGS
  is 'Stores all the logging messages per run.';
-- Add comments to the columns 
comment on column XU_LOG_RUN_MSGS.run_id
  is 'The unique ID for this run';
comment on column XU_LOG_RUN_MSGS.msg_type
  is 'The type of message.  ';
comment on column XU_LOG_RUN_MSGS.msg_timestamp
  is 'Timestamp for this message';
comment on column XU_LOG_RUN_MSGS.module
  is 'The module name for this log entry.  This helps seperate out components of an application.';
comment on column XU_LOG_RUN_MSGS.text
  is 'The log message';
-- Create/Recreate primary, unique and foreign key constraints 
alter table XU_LOG_RUN_MSGS
  add constraint XU_RUN_MSGS_PK primary key (RUN_ID, MSG_TIMESTAMP)
  using index 
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );

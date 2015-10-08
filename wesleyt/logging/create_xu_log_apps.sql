-- Create table
create table XU_LOG_APPS
(
  app_id                VARCHAR2(100) not null,
  name                  VARCHAR2(2000) not null,
  description           CLOB,
  log_level             NUMBER default 3 not null,
  purge_older_than_days NUMBER default 182 not null,
  log_to                NUMBER default 0 not null
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
-- Add comments to the columns 
comment on column XU_LOG_APPS.app_id
  is 'Unique ID for the application';
comment on column XU_LOG_APPS.name
  is 'The name of the application';
comment on column XU_LOG_APPS.description
  is 'Description of applicaiton';
comment on column XU_LOG_APPS.log_level
  is 'Valid log levels are defined in <some package>.  This determines what information will be logged for this application.';
comment on column XU_LOG_APPS.purge_older_than_days
  is 'Number of days to wait before automatically purging old logs.  Set to manage manually.';
comment on column XU_LOG_APPS.log_to
  is 'Flag used for debugging to to indicate if logging should occur on the screen.  0:  table only, 1: screen only, 2:  both screen and table';
-- Create/Recreate primary, unique and foreign key constraints 
alter table XU_LOG_APPS
  add constraint PK_XU_LOG_APP primary key (APP_ID)
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

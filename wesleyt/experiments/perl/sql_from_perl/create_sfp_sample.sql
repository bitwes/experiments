-- Create table
create table SFP_SAMPLE_TABLE
(
  number_col NUMBER,
  vc2_col    VARCHAR2(2000),
  date_col   DATE
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
comment on table SFP_SAMPLE_TABLE
  is 'Table used for sample code to illustrate calling SQL from Perl.  Can be dropped at anytime, the sample code recreates when necessary.';

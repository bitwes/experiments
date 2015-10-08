create or replace package xu_log is
  LOG_TO_TABLE        constant number := 0;
  LOG_TO_SCREEN       constant number := 1;
  LOG_TO_SCREEN_TABLE constant number := 2;

  MESG_TYPE_DEBUG          constant number := 1;
  MESG_TYPE_TRACE          constant number := 2;
  MESG_TYPE_LOG            constant number := 3;
  MESG_TYPE_WARNING        constant number := 4;
  MESG_TYPE_ERROR          constant number := 5;
  --Reserved for any error that occurs within
  --this package since no errors are raised.
  MESG_TYPE_INTERNAL_ERROR constant number := 99;

  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  procedure start_run(in_app_id in xu_log_apps.app_id%type default null);

  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  function start_run(in_app_id in xu_log_apps.app_id%type default null)
    return xu_log_app_runs.run_id%type;

  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  function get_current_run_id return xu_log_app_runs.run_id%type;

  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  function get_warning_count return number;

  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  function get_error_count return number;

  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  procedure resume_run(in_run_id in xu_log_app_runs.run_id%type);

  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  procedure debug(in_text   in xu_log_run_msgs.text%type,
                  in_module in xu_log_run_msgs.module%type default null);

  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  procedure trace(in_text   in xu_log_run_msgs.text%type,
                  in_module in xu_log_run_msgs.module%type default null);

  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  procedure print(in_text   in xu_log_run_msgs.text%type,
                  in_module in xu_log_run_msgs.module%type default null);

  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  procedure warning(in_text   in xu_log_run_msgs.text%type,
                    in_module in xu_log_run_msgs.module%type default null);

  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  procedure error(in_text   in xu_log_run_msgs.text%type,
                  in_module in xu_log_run_msgs.module%type default null);

  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  function get_mesg_type_name(in_mesg_type in number) return varchar2;

end xu_log;
/
create or replace package body xu_log is  
  DEFAULT_APPID       constant varchar2(30) := 'DEFAULT_APPID';
  DEFAULT_RUNID       constant number := -1;
    
  --The current run_id for the log
  g_run_id            number := DEFAULT_RUNID;  
  g_app               xu_log_apps%rowtype;
  
  g_error_count       number := 0;
  g_warning_count     number := 0;
  
  g_mesg_type_names  xu_datatype.t_vc2k_array;
----------
--Private
----------
  procedure populate_entry_type_names
  is
  begin
    if(g_mesg_type_names.count = 0) then
      g_mesg_type_names(MESG_TYPE_DEBUG         ) := 'Debug';
      g_mesg_type_names(MESG_TYPE_TRACE         ) := 'Trace';
      g_mesg_type_names(MESG_TYPE_LOG           ) := 'Log';
      g_mesg_type_names(MESG_TYPE_WARNING       ) := 'Warning';
      g_mesg_type_names(MESG_TYPE_ERROR         ) := 'ERROR';
      g_mesg_type_names(MESG_TYPE_INTERNAL_ERROR) := 'INTERNAL ERROR';                              
    end if;
  end;
  
  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  function get_default_app_definition return xu_log_apps%rowtype
  is
    l_return    xu_log_apps%rowtype;
  begin
    --set the current app the default one.
    l_return.app_id      := DEFAULT_APPID;
    l_return.name        := 'Default Application';
    l_return.description := 'This is the default application.  Any log entry that is entered '||
                            'into the table will fall under this name';
    l_return.log_level   := 0;
    l_return.log_to      := LOG_TO_SCREEN;
    l_return.purge_older_than_days := 2000;
  
    return l_return;
  end;
  
  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  function get_app (in_app_id xu_log_apps.app_id%type)return xu_log_apps%rowtype
  is
    l_return    xu_log_apps%rowtype;
  begin
    select * 
      into l_return
      from xu_log_apps 
     where app_id = in_app_id;
    return l_return;
  end;
  
  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  procedure create_app(in_app_row in xu_log_apps%rowtype)
  is PRAGMA AUTONOMOUS_TRANSACTION;
    l_to_insert   xu_log_apps%rowtype := in_app_row;
  begin
    l_to_insert.name := nvl(l_to_insert.name, l_to_insert.app_id);
    l_to_insert.log_level := nvl(l_to_insert.log_level, MESG_TYPE_LOG);
    l_to_insert.purge_older_than_days := nvl(l_to_insert.purge_older_than_days, 182);
    l_to_insert.log_to := nvl(l_to_insert.log_to, LOG_TO_TABLE);
    
    insert into xu_log_apps values l_to_insert;
    commit;
  end;
  
  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  procedure create_app_if_not_exist(in_app_id in xu_log_apps.app_id%type)
  is
    l_count     number;
    l_to_insert xu_log_apps%rowtype;
  begin
    select count(1)
      into l_count
      from xu_log_apps
     where app_id = in_app_id;

    if(l_count = 0)then
      l_to_insert.app_id := in_app_id;
      create_app(l_to_insert);
    end if;
  end;
  
  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  procedure add_entry(in_text   in xu_log_run_msgs.text%type,
                      in_type   in xu_log_run_msgs.msg_type%type default MESG_TYPE_LOG,
                      in_module in xu_log_run_msgs.module%type default null) 
  is PRAGMA AUTONOMOUS_TRANSACTION;
  begin
    insert into xu_log_run_msgs
      (text, msg_type, module,
       run_id, msg_timestamp)
    values
      (in_text, in_type, in_module,
       g_run_id, systimestamp);
    commit;
  end;
  
  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  procedure print_to_screen(in_text   in xu_log_run_msgs.text%type,
                            in_type   in xu_log_run_msgs.msg_type%type default MESG_TYPE_LOG,
                            in_module in xu_log_run_msgs.module%type default null)
  is
    l_module_prefix     varchar2(200);
    l_type_prefix       varchar2(200);
  begin
    if(in_module is not null)then
      l_module_prefix := '['||in_module||']';
    end if;
    l_type_prefix := rpad(g_mesg_type_names(in_type), 10, ' ');
    dbms_output.put_line(l_type_prefix||l_module_prefix||in_text);  
  end;
  
  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  procedure print_or_insert(in_text   in xu_log_run_msgs.text%type,
                            in_type   in xu_log_run_msgs.msg_type%type default MESG_TYPE_LOG,
                            in_module in xu_log_run_msgs.module%type default null) 
  is
  begin
    if(in_type >= g_app.log_level)then
      if(g_app.log_to = LOG_TO_TABLE or g_app.log_to = LOG_TO_SCREEN_TABLE)then
        add_entry(in_text, in_type, in_module);
      end if;

      if(g_app.log_to = LOG_TO_SCREEN or g_app.log_to = LOG_TO_SCREEN_TABLE)then
        print_to_screen(in_text, in_type, in_module);
      end if;    
    end if;
  end;

  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  procedure insert_new_run(in_app_id in xu_log_apps.app_id%type)
  is PRAGMA AUTONOMOUS_TRANSACTION;    
  begin
      insert into xu_log_app_runs
        (app_id, run_id, start_timestamp)
      values
        (in_app_id, xu_log_run_seq.nextval, localtimestamp)
      returning run_id into g_run_id;
      commit;
  end;

  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  procedure init_package
  is PRAGMA AUTONOMOUS_TRANSACTION;
    l_count     number := 0;
  begin
    populate_entry_type_names;

    g_app := get_default_app_definition;    
    g_run_id                  := DEFAULT_RUNID;                
    g_warning_count   := 0;
    g_error_count     := 0;

    --Make sure the default app_id exists always.
    select count(1)
      into l_count
      from xu_log_apps
     where app_id = DEFAULT_APPID;
    
    if(l_count = 0)then
      create_app(g_app);
    end if;

    --Make sure the default run always exists.
    select count(1)
      into l_count
      from xu_log_app_runs
     where app_id = DEFAULT_APPID
       and run_id = DEFAULT_RUNID;
       
    if(l_count = 0)then
      insert into xu_log_app_runs
        (app_id, run_id, start_timestamp)
      values
        (DEFAULT_APPID, DEFAULT_RUNID, systimestamp);
      commit;
    end if;

  end;
  
  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  procedure internal_error(in_text in xu_log_run_msgs.text%type)
  is
    l_cur_log_to     number;
  begin
    l_cur_log_to := g_app.log_to;
    g_app.log_to := LOG_TO_SCREEN_TABLE;
    print_or_insert('INTERNAL ERROR:  '||in_text, MESG_TYPE_INTERNAL_ERROR);
    g_app.log_to := l_cur_log_to;
  end;
    
----------
--Public
----------
  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  procedure start_run(in_app_id in xu_log_apps.app_id%type)
  is
  begin
    if(g_app.app_id = DEFAULT_APPID and in_app_id <> DEFAULT_APPID)then
      create_app_if_not_exist(in_app_id);
      g_app := get_app(in_app_id);
      insert_new_run(in_app_id);
      
      g_warning_count := 0;
      g_error_count := 0;
    elsif (g_app.app_id <> in_app_id)then
      print_or_insert('Cannot start a new run while one is running.  Attempted to start "'||in_app_id||
                      '" while "'||g_app.app_id||'" was running.', MESG_TYPE_INTERNAL_ERROR);
    end if;
  end;      

  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  function start_run(in_app_id in xu_log_apps.app_id%type)return xu_log_app_runs.run_id%type
  is
  begin
    start_run(in_app_id);
    return g_run_id;
  end;
      
  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  procedure resume_run(in_run_id in xu_log_app_runs.run_id%type)
  is
    l_app_id      xu_log_apps.app_id%type;
  begin

    
    --Since the default could have been inserted from anywhere, any value
    --loaded into the counts from the table is meaningless.  The only 
    --time these counts are usful for the default run is during an active 
    --session.
    if(in_run_id <> DEFAULT_RUNID)then
      select app_id
        into l_app_id
        from xu_log_app_runs
       where run_id = in_run_id;

      g_run_id := in_run_id;
      g_app := get_app(l_app_id);

      select count(1)
        into g_error_count
        from xu_log_run_msgs
       where msg_type = MESG_TYPE_ERROR         and run_id = g_run_id;

      select count(1)
        into g_warning_count
        from xu_log_run_msgs
       where msg_type = MESG_TYPE_WARNING         and run_id = g_run_id;     
    else 
      internal_error('Attempt to resume defualt run.  Nothing to resume');
      g_app := get_default_app_definition;
      g_run_id := DEFAULT_RUNID;
    end if; 
  exception
    when no_data_found then
      internal_error('xu_log could not resume run_id '||in_run_id);
      init_package;
  end;
    
  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  procedure debug(in_text in xu_log_run_msgs.text%type, in_module in xu_log_run_msgs.module%type default null)
  is
  begin
    print_or_insert(in_text, MESG_TYPE_DEBUG, in_module);
  end;
  
  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  procedure trace(in_text in xu_log_run_msgs.text%type, in_module in xu_log_run_msgs.module%type default null)
  is
  begin
    print_or_insert(in_text, MESG_TYPE_TRACE, in_module);
  end;
  
  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  procedure print(in_text in xu_log_run_msgs.text%type, in_module in xu_log_run_msgs.module%type default null)
  is
  begin
    print_or_insert(in_text, MESG_TYPE_LOG, in_module);
  end;
  
  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  procedure warning(in_text in xu_log_run_msgs.text%type, in_module in xu_log_run_msgs.module%type default null)
  is
  begin
    g_warning_count := g_warning_count + 1;
    print_or_insert(in_text, MESG_TYPE_WARNING, in_module);
  end;
  
  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  procedure error(in_text in xu_log_run_msgs.text%type, in_module in xu_log_run_msgs.module%type default null)
  is
  begin
    g_error_count := g_error_count + 1;
    print_or_insert(in_text, MESG_TYPE_ERROR, in_module);
  end;
    
  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  function get_warning_count return number
  is
  begin
    return g_warning_count;
  end;

  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  function get_error_count return number
  is
  begin
    return g_error_count;
  end;
  
  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  function get_current_run_id return xu_log_app_runs.run_id%type
  is
  begin
    return g_run_id;
  end;
  
  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  function get_mesg_type_name (in_mesg_type in number)return varchar2
  is
  begin
    return g_mesg_type_names (in_mesg_type);
  exception
    when no_data_found then
      return null;
  end;
----------
--Testing utils
----------  
  -----------------------------------------------------------------------------  
  procedure make_an_entry_of_each_type
  is
  begin
    debug('debug');
    trace('trace');
    print('print');
    warning('warning');
    error('error');
  end;


  -----------------------------------------------------------------------------
  procedure clear_log_tables
  is
  begin
    delete from xu_log_run_msgs;
    delete from xu_log_app_runs;
    delete from xu_log_apps;
  end;

  -----------------------------------------------------------------------------  
  function get_log_entry_count_for_appid(in_appid in varchar2)return number
  is
    l_count     number := 0;
  begin
    select count(1)
      into l_count
      from xu_log_run_msgs
     where run_id =
           (select run_id from xu_log_app_runs where app_id = in_appid);
    return l_count;  
  end;  

  -----------------------------------------------------------------------------  
  function get_log_entry_count_for_runid(in_runid in number)return number
  is
    l_count     number := 0;
  begin
    select count(1)
      into l_count
      from xu_log_run_msgs
     where run_id =
           (select run_id from xu_log_app_runs where run_id = in_runid);
    return l_count;  
  end;  

  procedure print_log_tables
  is
  begin
    xut.p('****');
    xut.p('XU_LOG_APPS');
    for rec in (select * from xu_log_apps) loop
      xut.p(rec.app_id, 2);
    end loop;
    
    xut.p('XU_LOG_APP_RUNS');
    for rec in (select * from xu_log_app_runs) loop
      xut.p(rec.app_id||' - '||rec.run_id, 2);
    end loop;
    
    xut.p('XU_LOG_RUN_MSGS');
    for rec in (select * from xu_log_run_msgs order by run_id, msg_timestamp) loop
      xut.p(rec.run_id||' - '||rec.text, 2);
    end loop;
    xut.p('****');    
  end;  
----------
--Tests
----------  

  -----------------------------------------------------------------------------
  procedure testsetup
  is

  begin
    if(not xut.is_running)then
      return;
    end if;
     
    clear_log_tables;
    init_package;
    create_app_if_not_exist('testapp');
  end;
  
  -----------------------------------------------------------------------------
  procedure testteardown
  is
  begin
    if(not xut.is_running)then
      return;
    end if;    
    
    clear_log_tables;    
    commit;
  end;

  -----------------------------------------------------------------------------
  procedure test_create_app_is_autononmous
  is
    l_count     number := 0;
  begin
    create_app_if_not_exist('asdf');
    rollback;
    select count(1) into l_count from xu_log_apps where app_id = 'asdf';
    
    xut.assert_eq(1, l_count, 'an app should exist');
  end;

  -----------------------------------------------------------------------------
  procedure test_start_run_is_autonomous
  is
    l_count     number := 0;
  begin
    insert_new_run('asdf');
    rollback;
    select count(1) into l_count from xu_log_app_runs where app_id = 'asdf';
    xut.assert_eq(1, l_count, 'There should be one run going');
  end;

  -----------------------------------------------------------------------------
  procedure test_add_entry_is_autonomous
  is
    l_count     number := 0;
  begin
    add_entry('hello');
    rollback;
    select count (1) into l_count from xu_log_run_msgs;
    xut.assert_eq(1, get_log_entry_count_for_appid(g_app.app_id), 'There should have been one log entry made');
  end;
  
  -----------------------------------------------------------------------------
  procedure test_loglvl_dflts_to_log
  is
    l_appid   varchar2(20) := 'asdf';
    l_count   number := 0;
  begin
    create_app_if_not_exist(l_appid);
    select count(1) into l_count from xu_log_apps where log_level = MESG_TYPE_LOG and app_id='asdf';
    xut.assert_eq(1, l_count, 'There should be an app with the name '||l_appid);
  end;

  
  -----------------------------------------------------------------------------
  procedure test_appname_dfts_to_appid
  is
    l_appid   varchar2(20) := 'asdf';
    l_count   number := 0;
  begin
    create_app_if_not_exist(l_appid);
    select count(1) into l_count from xu_log_apps where name = l_appid;
    xut.assert_eq(1, l_count, 'There should be an app with the name '||l_appid);
  end;
  
  -----------------------------------------------------------------------------
  --Make sure the table does not support creating the same app_id twice
  procedure test_not_create_same_appid 
  is
  begin
    insert into xu_log_apps (app_id, name) values ('asdf', 'asdf');  
    insert into xu_log_apps (app_id, name) values ('asdf', 'asdf');
    xut.assert(false, 'Should not have been able to insert same app_id twice');
  exception
    when others then
      xut.assert(true, 'This should error.');
  end;
  
  -----------------------------------------------------------------------------
  --calling set_app_id sets the private package variable
  procedure test_set_app_sets_pkg_var
  is
    l_app   varchar2(100) := 'asdf';
  begin
    start_run(l_app);
    xut.assert_eq(l_app, g_app.app_id, 'App should be set.');    
  end;
  
  -----------------------------------------------------------------------------
  --calling set_app_id creates a row in the app table
  procedure test_set_app_creates_app
  is
    l_count   number;
  begin
    start_run('asdf');
    select count(1) into l_count from xu_log_apps where app_id = 'asdf';
    xut.assert_eq(l_count, 1, 'Should have made an app entry.');
  end;
  
  -----------------------------------------------------------------------------
  --calling set_app_id does not create a row in the app table
  --if one already exists (test_app inserted by setup).
  procedure test_set_app_does_not_create
  is
  begin
    start_run('test_app');
    xut.assert(true, 'This assert indicates the test passed since it didn''t error.');
  end;
  
  -----------------------------------------------------------------------------
  --Setting the app should start a run by entering a variable int
  --the xu_logs_app_runs table.
  procedure test_set_app_starts_run
  is
    l_count       number;
    l_app_id      varchar2(100) := 'asdf';
  begin
    start_run(l_app_id);
    select count(1)
      into l_count
      from xu_log_app_runs
     where xu_log_app_runs.app_id = l_app_id;
     
    xut.assert_eq(l_count, 1, 'Should have created row for a run.');
  end;
  
  -----------------------------------------------------------------------------
  --Setting the app should set the local run_id variable
  procedure test_set_app_sets_run_id  
  is
  begin
    start_run('asdf');
    xut.assert(g_run_id is not null, 'Run ID should be set');
  end;
  
  -----------------------------------------------------------------------------
  --Setting app to the same thing should not reset the run, this allows sub
  --programs to set the app and not interrupt the logging when they are 
  --integrated into the program as a whole.
  procedure test_set_app2_not_reset_run
  is
    l_cur_run_id    number;
    l_app_id        varchar2(100) := 'asdf';
  begin
    start_run(l_app_id);
    l_cur_run_id := g_run_id;
    start_run(l_app_id);
    xut.assert(g_run_id = l_cur_run_id, 'Setting the app_id to the same thing should not reset the run');
  end;
  
  -----------------------------------------------------------------------------
  --We don't want one thing to hijack another's log, so right now 
  --it should error if you try to set the app to something 
  --different when it is already set.  This is subject to change.
  procedure test_set_app_diff_errors
  is
  begin
    start_run('asdf');
    start_run('qwert');
    xut.assert(false, 'Should have errored setting app_id again');
  exception
    when others then
      xut.assert(true, 'This passes if it errors.');
  end;
  
  -----------------------------------------------------------------------------  
  procedure test_add_entry_default_appid
  is
    l_count number;
  begin
    add_entry('hello', 1);
    select count(1) into l_count from xu_log_run_msgs;
    xut.assert_eq(1, l_count, 'A record should have been inserted');
  end;

  -----------------------------------------------------------------------------  
  procedure test_add_entry_forappid
  is
    l_app_id   varchar2(20) := 'someapp';
  begin
    start_run(l_app_id);
    add_entry('hello', MESG_TYPE_LOG);
    xut.assert_eq(1, get_log_entry_count_for_appid(l_app_id), 
                  'Should have a record for this appid');
  end;

  -----------------------------------------------------------------------------  
  procedure test_get_app
  is
    l_app     xu_log_apps%rowtype;
  begin
    l_app := get_app(DEFAULT_APPID);
    xut.assert_eq(DEFAULT_APPID, l_app.app_id, 'The app IDs should be the same');  
  end;    

  -----------------------------------------------------------------------------  
  procedure test_log_to_screen
  is
  begin    
    xut.p('!! SHOULD SEE THE WORD hello TWICE');    
    print('   hello');    
    xut.assert_eq(0, get_log_entry_count_for_appid(DEFAULT_APPID), 'There shouldnt have been an entry made');
    g_app.log_to := LOG_TO_SCREEN_TABLE;
    print('   hello');
    xut.assert_eq(1, get_log_entry_count_for_appid(DEFAULT_APPID), 'There shouldnt have been an entry made');
  end;
  
  -----------------------------------------------------------------------------
  procedure test_log_level
  is
  begin
    g_app.log_to := LOG_TO_TABLE;

    g_app.log_level := 1;
    make_an_entry_of_each_type;
    xut.assert_eq(5, get_log_entry_count_for_appid(g_app.app_id), 'Log messages');

    g_app.log_level := 2;
    make_an_entry_of_each_type;
    xut.assert_eq(9, get_log_entry_count_for_appid(g_app.app_id), 'Log messages');
    
    g_app.log_level := 5;
    make_an_entry_of_each_type;
    xut.assert_eq(10, get_log_entry_count_for_appid(g_app.app_id), 'Log messages');            
  end;
  
  -----------------------------------------------------------------------------  
  procedure test_resume_run
  is
    l_app_id    varchar2(20) := 'asdf';
    l_run_id    number;
  begin
    start_run(l_app_id);
    l_run_id := g_run_id;
    xut.assert(l_run_id <> DEFAULT_RUNID, 'The runid should not be the default one.');
    print('hello');
    init_package; --This is a way to clear everything to simulate ending a session
                  --If this becomes problematic, find another way to simulate starting
                  --a new session.
    resume_run(l_run_id);
    print('world');
    xut.assert_eq(2, get_log_entry_count_for_runid(l_run_id), 'There should be two entries for this run');
  end;
  
  -----------------------------------------------------------------------------  
  procedure test_resume_run_does_not_error
  is
  begin
    xut.print('!! Should be an "INTERNAL ERROR" below');
    --arbitrary nonexistent run_id.  this should result
    --in a package reset.    
    resume_run(-22);

    --default is screen so set to table so we can count 'em
    g_app.log_to := LOG_TO_TABLE;
    print('hello');

    xut.assert_eq(0, get_log_entry_count_for_runid(-22), 'There should not be any entries for that runid.');
    xut.assert_eq(2, get_log_entry_count_for_runid(DEFAULT_RUNID), 
                  'There should be two entries, one for the entry made and one for the internal error');
  exception
    when others then
      xut.assert(false, 'resume_run should not error: '||sqlerrm);
  end;    
  
  -----------------------------------------------------------------------------  
  procedure test_warning_count
  is
  begin
    g_app.log_to := LOG_TO_TABLE;
    
    make_an_entry_of_each_type;
    warning('This is another warning');
    xut.assert_eq(2, get_warning_count, 'There should be two warnings at this point.');
    
    start_run('a_new_app');
    xut.assert_eq(0, get_warning_count, 'There should be no warnings after starting a new run.');    
    warning('I made another warning');
    xut.assert_eq(1, get_warning_count, 'There should be one warning at this point.');
        
    init_package;
    xut.assert_eq(0, get_warning_count, 'There should be no warnings after reset.');
  end;

  -----------------------------------------------------------------------------  
  procedure test_error_count
  is
  begin
    g_app.log_to := LOG_TO_TABLE;
    
    make_an_entry_of_each_type;
    error('This is another warning');
    xut.assert_eq(2, get_error_count, 'There should be two errors at this point.');
    
    start_run('a_new_app');
    xut.assert_eq(0, get_error_count, 'There should be no errors after starting a new run.');    
    error('I made another warning');
    xut.assert_eq(1, get_error_count, 'There should be one error at this point.');
        
    init_package;
    xut.assert_eq(0, get_error_count, 'There should be no errors after reset.');
  end;

  -----------------------------------------------------------------------------
  procedure test_resume_fills_globals
  is
    l_run_id    number;
  begin
    start_run('test_resume_fills_error_count');
    l_run_id := g_run_id;
    print('one log entry');
    error('one error');
    warning('one warning');    

    init_package;
    
    --start another run and put in some entries to make sure they aren't returned
    --when the other one is resumed.
    start_run('another run');
    print('one log entry');
    error('one error');
    warning('one warning');    

    init_package;    
    
    resume_run(l_run_id);
    
    xut.assert_eq(1, g_error_count, 'There should be one error after resuming');
    xut.assert_eq(1, g_warning_count, 'There should be one warning after resuming');    
  end;

  -----------------------------------------------------------------------------  
  procedure test_resume_dflt_resumes_nada
  is
  begin
    g_app.log_to := LOG_TO_TABLE;
    error('there is an error');
        
    init_package;
    xut.p('!! There should be an INERNAL ERROR below');
    resume_run(DEFAULT_RUNID);
    xut.assert_eq(0, g_error_count, 'There shouldnt be any errors in the error count');
  end;

  -----------------------------------------------------------------------------  
  procedure test_entry_names_populated
  is
  begin
    --The array should be populated when the package is laoded so we just need
    --to make sure that there are the expected number of names in the hash.
    xut.assert_eq(6, g_mesg_type_names.count, 
                  'There should be 6 names for the entry level types.');
  end;
  
  
  procedure test_something
  is
  begin
    xut.assert(false, 'fail');
  end;
begin
  init_package;
end xu_log;
/

create or replace package xu_ssb_log is

  procedure pg_apps;
  procedure pg_runs(in_app_id in xu_log_apps.app_id%type);
  procedure pg_msgs(in_run_id in xu_log_app_runs.run_id%type);  
  
end xu_ssb_log;
/
create or replace package body xu_ssb_log is
  TIMESTAMP_FORMAT      constant varchar2(100) := 'mm/dd/yy hh:mi:ss';

  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  function get_runs_link(in_app_id in xu_log_apps.app_id%type,
                         in_app_name in xu_log_apps.name%type)return varchar2
  is
  begin
    return '<a href="xu_ssb_log.pg_runs?in_app_id='||in_app_id||'">'||in_app_name||'</a>';
  end;

  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  function get_msgs_link(in_run_id in xu_log_app_runs.run_id%type)return varchar2
  is
  begin
    return '<a href="xu_ssb_log.pg_msgs?in_run_id='||in_run_id||'">'||in_run_id||'</a>';
  end;

  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  procedure print_apps_table
  is
    cursor c_apps is
      select la.*,
             (select max(start_timestamp)
                from xu_log_app_runs
               where app_id = la.app_id) last_run
        from xu_log_apps la;
  begin
    htp.p('<table border="1px">');    
    htp.p('<tr>');
      xuhtp.print_tag('th', 'Name');
      xuhtp.print_tag('th', 'ID');
      xuhtp.print_tag('th', 'Description');
      xuhtp.print_tag('th', 'Last run');
      xuhtp.print_tag('th', 'Options');
    htp.p('</tr>');    
    for rec in c_apps loop  
      htp.p('<tr>');
        xuhtp.print_tag('td', get_runs_link(rec.app_id, rec.name));
        xuhtp.print_tag('td', rec.app_id);
        xuhtp.print_tag('td', rec.description);            
        xuhtp.print_tag('td', to_char(rec.last_run, TIMESTAMP_FORMAT));
        xuhtp.print_tag('td', '<a href="http://google.com">properties</a><br/>'||
                              '<a href="http://google.com">clear logs</a>');
      htp.p('</tr>');
    end loop;
    htp.print('</table>');
  end;

  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  procedure print_run_table(in_app_id in xu_log_apps.app_id%type)
  is
    cursor c_app_runs is
      select lar.*,
             (select count(1)
                from xu_log_run_msgs lrm
               where run_id = lar.run_id
                 and (lrm.msg_type = xu_log.MESG_TYPE_ERROR
                  or lrm.msg_type = xu_log.MESG_TYPE_INTERNAL_ERROR)) error_count,
             (select count(1)
                from xu_log_run_msgs lrm
               where run_id = lar.run_id
                 and lrm.msg_type = xu_log.MESG_TYPE_WARNING) warning_count
        from xu_log_app_runs lar
       where app_id = in_app_id;      
  begin  
    htp.p('<table>');    
    htp.p('<tr>');
      xuhtp.print_tag('th', 'Run ID');
      xuhtp.print_tag('th', 'Start time');
      xuhtp.print_tag('th', 'Warning count');
      xuhtp.print_tag('th', 'Error count');                  
    htp.p('</tr>');
    for rec in c_app_runs loop  
      htp.p('<tr>');
        xuhtp.print_tag('td', get_msgs_link(rec.run_id));
        xuhtp.print_tag('td', to_char(rec.start_timestamp, TIMESTAMP_FORMAT));
        xuhtp.print_tag('td', rec.warning_count);
        xuhtp.print_tag('td', rec.error_count);
      htp.p('</tr>');
    end loop;
    htp.print('</table>');    
  end;
  
  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  procedure print_msgs_table(in_run_id in xu_log_app_runs.run_id%type)
  is
    cursor c_msgs is
    select * from xu_log_run_msgs where run_id = in_run_id;
  begin
    htp.p('<table>');    
    htp.p('<tr>');
      xuhtp.print_tag('th', 'Type');
      xuhtp.print_tag('th', 'Timestamp');      
      xuhtp.print_tag('th', 'Module');
      xuhtp.print_tag('th', 'Text');
    htp.p('</tr>');    
    for rec in c_msgs loop
      htp.p('<tr>');      
        xuhtp.print_tag('td', xu_log.get_mesg_type_name(rec.msg_type));
        xuhtp.print_tag('td', to_char(rec.msg_timestamp, TIMESTAMP_FORMAT));
        xuhtp.print_tag('td', rec.module);
        xuhtp.print_tag('td', rec.text);
      htp.p('</tr>');
    end loop;
    htp.print('</table>');    
  end;
------------------
--public
------------------

  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  procedure pg_apps
  is
  begin
    print_apps_table;
  end;
  
  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  procedure pg_runs(in_app_id in xu_log_apps.app_id%type)
  is
  begin
    xuhtp.print_tag('h3', 'Application '||in_app_id);
    print_run_table(in_app_id);
  end;
  
  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  procedure pg_msgs(in_run_id in xu_log_app_runs.run_id%type)
  is
  begin
    print_msgs_table(in_run_id);
  end;
end xu_ssb_log;
/

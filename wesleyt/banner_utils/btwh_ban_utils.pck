/*
  e_too_many_owners   exception;
  C_TOO_MANY_OWNERS   NUMBER := -20001;
  C_TOO_MANY_OWNERS_MSG VARCHR2(2000) := 'some error message'; 
  PRAGMA EXCEPTION_INIT(e_too_many_owners, -2001);


raise_application_error(mypkg.c_too_many_owners, mypkg.c_too_many_owners_msg);

catch(mypkg.e_too_many_owners);
*/

create or replace package btwh_ban_utils is
    type t_vc2k_table is table of varchar2(2000) index by binary_integer;

    
    e_too_many_owners exception;
    PRAGMA EXCEPTION_INIT(e_too_many_owners, -2001);
    e_no_owners exception;
    PRAGMA EXCEPTION_INIT(e_no_owners, -2002);
    e_view exception;
    PRAGMA EXCEPTION_INIT(e_view, -2003);

    g_butch_sysdate_date            varchar2(30) := null;
    g_bsysdate_call_count           number := 0;


    -----------------------------------------------------------------------------
    -----------------------------------------------------------------------------    
    procedure set_print_to_file(in_directory in varchar2, in_file in varchar2, in_mode in varchar2 default 'W');

    -----------------------------------------------------------------------------
    -----------------------------------------------------------------------------    
    procedure close_print_file;

    -----------------------------------------------------------------------------
    -----------------------------------------------------------------------------    
    procedure set_print_screen;

    -----------------------------------------------------------------------------
    -----------------------------------------------------------------------------    
    procedure d_print(in_string in varchar2, in_depth in number default 0);

    -----------------------------------------------------------------------------
    -----------------------------------------------------------------------------    
    function my_pidm return number;

    -----------------------------------------------------------------------------
    -----------------------------------------------------------------------------    
    function my_id return varchar2;


    -----------------------------------------------------------------------------
    -----------------------------------------------------------------------------    
    procedure desc_table_html(in_table_name in varchar2, in_owner in varchar2 default '%',
                              in_include_checksheet_cols in boolean default false);

    procedure pg_active_zgbparm(in_module in varchar2, in_date in date default sysdate);

    procedure pg_last_x_parm_values(in_module in varchar2, in_process in varchar2, in_name in varchar2,
                                    in_x in number default 5);
    procedure pg_last_x_parm_values(in_module in varchar2, in_x in number default 5);
    procedure pg_last_x_mths_of_actv_values(in_module in varchar2, in_x in number default 5);
    procedure print_ssb_affected_by_change(in_method_name in varchar2);    

    -----------------------------------------------------------------------------    
    --Prints a query and a count for all tables that contain the specified pidm.  
    --Excludes all views and any columns named "pidm" but are not number fields.
    -----------------------------------------------------------------------------   
    function get_my_pidm return number;
    procedure trace(in_msg in varchar2);    
    procedure clear_trace;    
end btwh_ban_utils;
/
create or replace package body btwh_ban_utils is

    --set to -1 initially.  if not -1 then this package
    --won't look for the table again.
    g_butch_trace_table_count       number := -1;

    --character constants.

    C_DATE_FMT     constant varchar2(100) := 'mm/dd/yyyy';
    C_PRINT_SCREEN constant varchar2(1) := 'S';
    C_PRINT_FILE   constant varchar2(1) := 'F';

    C_MY_ID   constant varchar2(20) := '000580317';

    g_my_pidm        number := 581294;
    v_where_to_print varchar2(1) := C_PRINT_SCREEN;
    v_print_dir      varchar2(1000);
    v_print_file     varchar2(1000);
    v_file_handle    utl_file.file_type;

    v_empty_tbl_num_vc2idx btwh_ora_utils.t_tbl_num_vc2idx;
    v_unique_menus         btwh_ora_utils.t_tbl_num_vc2idx;
    v_unique_pages         btwh_ora_utils.t_tbl_num_vc2idx;
    v_unique_methods       btwh_ora_utils.t_tbl_num_vc2idx;
    v_unique_parent_menus  btwh_ora_utils.t_tbl_num_vc2idx;
    v_unique_tab_names     btwh_ora_utils.t_tbl_num_vc2idx;
------------------
--PRIVATE
------------------

    -----------------------------------------------------------------------------  
    -----------------------------------------------------------------------------      
    procedure print_style is
    begin
        htp.print('
<style>
  table, th, td{
    border: 1px solid black;
  }
  table{
    border-collapse:collapse;
  }
  td{
    padding:10px
  }
  th{
    background-color:black;
    font-size:18px ;
    color:white;
  }
</style>');
    end;

    -----------------------------------------------------------------------------
    --Depth Print
    --Used to print out indented output.  in_depth will determine how far 
    --indented the output will be.
    -----------------------------------------------------------------------------  
    procedure d_print(in_string in varchar2, in_depth in number default 0) 
    is
    begin
        btwh_ora_utils.d_print(in_string, in_depth);
    end;

    -----------------------------------------------------------------------------  
    -----------------------------------------------------------------------------      
    procedure d_print_vc2idx_array(in_array in btwh_ora_utils.t_tbl_num_vc2idx, in_depth in number default 0) is
    begin
        btwh_ora_utils.d_print_vc2idx_array(in_array, in_depth);
    end;

    -----------------------------------------------------------------------------
    --Increments the value of a t_tbl_num_vc2idx array for a given key
    --and returns the new value for the key.  If the key does not exist it 
    --is added to the array.
    -----------------------------------------------------------------------------  
    function increment_vc2idx_array(in_key in varchar2, io_array in out btwh_ora_utils.t_tbl_num_vc2idx) return number is
    begin
        return btwh_ora_utils.increment_vc2idx_array(in_key, io_array);
    end;

    -----------------------------------------------------------------------------
    -----------------------------------------------------------------------------    
    procedure print_active_zgbparm(in_module in varchar2, in_date in date) is
        cursor c_parms is
            select zgbparm_process process,
                   zgbparm_parm_name name,
                   zgbparm_parm_value value,
                   to_char(zgbparm_from_date, c_date_fmt) from_date,
                   to_char(zgbparm_to_date, c_date_fmt) to_date
              from zgbparm
             where upper(zgbparm_module) = upper(in_module)
               and in_date between zgbparm_from_date and zgbparm_to_date
             order by zgbparm_process, zgbparm_parm_name;
    begin
        htp.print('<h3>Active "' || in_module || '" Module Parameters on ' || to_char(in_date, C_DATE_FMT) || '</h3>');
        htp.print('<table>');
        htp.print('<tr><th>Process</th><th>Name</th><th>Value</th><th>From</th><th>To</th></tr>');
        for rec in c_parms loop
            htp.print('<tr>');
            xuhtp.print_tag('td', rec.process);
            xuhtp.print_tag('td', rec.name);
            xuhtp.print_tag('td', rec.value);
            xuhtp.print_tag('td', rec.from_date);
            xuhtp.print_tag('td', rec.to_date);
            htp.print('</tr>');
        end loop;
        htp.print('</table>');
    end;

    -----------------------------------------------------------------------------
    -----------------------------------------------------------------------------    
    procedure print_last_x_parm_values(in_module in varchar2, in_process in varchar2, in_name in varchar2,
                                       in_x in number) is
        cursor c_values is
            select *
              from (select zgbparm_parm_value value,
                           to_char(zgbparm_from_date, c_date_fmt) from_date,
                           to_char(zgbparm_to_date, c_date_fmt) to_date,
                           to_char(zgbparm_activity_date, c_date_fmt) activity_date
                      from zgbparm
                     where zgbparm_module = in_module
                       and zgbparm_process = in_process
                       and zgbparm_parm_name = in_name
                     order by zgbparm_process, zgbparm_to_date desc)
             where rownum < in_x;
    begin
        htp.print('<h3>Last ' || in_x || ' ' || in_module || '.' || in_process || '.' || in_name || ' Values</h3>');
        htp.print('<table>');
        htp.print('<tr><th>Value</th><th>From</th><th>To</th><th>Activity</th></tr>');
        for rec in c_values loop
            htp.print('<tr>');
            xuhtp.print_tag('td', rec.value);
            xuhtp.print_tag('td', rec.from_date);
            xuhtp.print_tag('td', rec.to_date);
            xuhtp.print_tag('td', rec.activity_date);
            htp.print('</tr>');
        end loop;
        htp.print('</table>');
    end;    

    -----------------------------------------------------------------------------
    -----------------------------------------------------------------------------
    procedure print_tabs_for_menu(in_twgrmenu_url in varchar2, in_level in number default 0) is
        cursor c_menus is
            select twgrmenu_name, twgrmenu_url_text
              from twgrmenu
             where lower(twgrmenu_url) = lower(in_twgrmenu_url)
               and twgrmenu_source_ind = 'L';
    
        l_top_lvl     varchar2(100) := 'standalone_role_nav_bar';
        l_dummy_count number;
        l_tab_text    varchar2(4000);
    begin
    
        for rec in c_menus loop
            l_tab_text := rec.twgrmenu_url_text;
            if (rec.twgrmenu_name = l_top_lvl) then
                d_print('*TAB:  ' || rec.twgrmenu_url_text, 2);
                l_dummy_count := increment_vc2idx_array(rec.twgrmenu_url_text, v_unique_tab_names);
            else
                if (increment_vc2idx_array(l_tab_text, v_unique_parent_menus) = 1) then
                    print_tabs_for_menu(rec.twgrmenu_name, in_level + 1);
                end if;
            end if;
        end loop;
    
    end;  
------------------
--PUBLIC GENERAL
------------------    


    -----------------------------------------------------------------------------
    -----------------------------------------------------------------------------    
    procedure set_print_to_file(in_directory in varchar2, in_file in varchar2, in_mode in varchar2 default 'W') is
    begin
        v_where_to_print := C_PRINT_FILE;
        v_print_dir      := in_directory;
        v_print_file     := in_file;
        v_file_handle    := utl_file.fopen(in_directory, in_file, in_mode);
    end;

    -----------------------------------------------------------------------------
    -----------------------------------------------------------------------------    
    procedure close_print_file is
    begin
        utl_file.fclose(v_file_handle);
        v_where_to_print := C_PRINT_SCREEN;
    end;

    -----------------------------------------------------------------------------
    -----------------------------------------------------------------------------    
    procedure set_print_screen is
    begin
        v_where_to_print := C_PRINT_SCREEN;
    end;

    -----------------------------------------------------------------------------
    -----------------------------------------------------------------------------    
    function my_pidm return number is
    begin
        return g_my_pidm;
    end;

    -----------------------------------------------------------------------------
    -----------------------------------------------------------------------------    
    function my_id return varchar2 is
    begin
        return C_MY_ID;
    end;


-----------------------
--Public SSB Related
-----------------------


    -----------------------------------------------------------------------------
    -----------------------------------------------------------------------------
    procedure get_ssb_affected_by_change_to(in_method_name in varchar2) is
        cursor c_ssb_pages(in_lwr_pck_meth in varchar2) is
            select distinct twgbwmnu_desc, twgbwmnu_page_title
              from twgbwmnu
             where lower(twgbwmnu_name) = in_lwr_pck_meth
             group by twgbwmnu_desc, twgbwmnu_page_title;
    
        cursor c_ssb_menus_for_page_url(in_page_url in varchar2) is
            select twgrmenu_name from twgrmenu where lower(twgrmenu_url) = in_page_url;
        l_calls_to     btwh_ora_utils.t_method_calls;

        l_lwr_pck_meth varchar2(2000);
        l_found        boolean;
        l_dummy_count  number;
        l_meth_count   number;

        -------------------------------------------------------------------------
        -------------------------------------------------------------------------    
        function get_all_calls_to(in_thing in varchar2) return btwh_ora_utils.t_method_calls
        is
            l_temp              btwh_ora_utils.t_method_calls;
            l_return            btwh_ora_utils.t_method_calls;
        begin
            for rec in (select owner, object_name, object_type from all_objects where object_type in ('PACKAGE BODY'))loop
                l_temp := btwh_ora_utils.get_calls_to(rec.owner, rec.object_name, rec.object_type, in_thing);
                for i in 1..l_temp.count loop
                    l_return(l_return.count + 1) := l_temp(i);
                end loop;
            end loop;
            return l_return;
        end;
    
    begin
        l_calls_to := get_all_calls_to(in_method_name);
        for i in 1 .. l_calls_to.count loop
            l_lwr_pck_meth := lower(l_calls_to(i).package_name || '.' || l_calls_to(i).method_name);
            l_meth_count   := increment_vc2idx_array(l_lwr_pck_meth, v_unique_methods);
            d_print(l_lwr_pck_meth, 0);
            l_found := false;
            --get all the pages
            d_print('Pages:', 1);
            for page_rec in c_ssb_pages(l_lwr_pck_meth) loop
                l_found := true;
                d_print(page_rec.twgbwmnu_page_title || ' - ' || page_rec.twgbwmnu_desc, 2);
                l_dummy_count := increment_vc2idx_array(page_rec.twgbwmnu_page_title || ' - ' || page_rec.twgbwmnu_desc,
                                                        v_unique_pages);
                --get menu for page
                d_print('Menus:', 1);
                for menu_rec in c_ssb_menus_for_page_url(l_lwr_pck_meth) loop
                    d_print(menu_rec.twgrmenu_name, 2);
                    l_dummy_count := increment_vc2idx_array(menu_rec.twgrmenu_name, v_unique_menus);
                
                    print_tabs_for_menu(menu_rec.twgrmenu_name);
                end loop;
            end loop;
        
            --If we didn't find a menu for this method and this was the 
            --first time we have encountered this method, then repeat
            --the process for this method.
            if (not l_found and l_meth_count = 1) then
                get_ssb_affected_by_change_to(l_lwr_pck_meth);
            end if;
        end loop;
    end;

    -----------------------------------------------------------------------------
    --BROKE, something to do with the changes to get_calls_to
    -----------------------------------------------------------------------------
    procedure print_ssb_affected_by_change(in_method_name in varchar2) is
    begin
        v_unique_menus        := v_empty_tbl_num_vc2idx;
        v_unique_pages        := v_empty_tbl_num_vc2idx;
        v_unique_methods      := v_empty_tbl_num_vc2idx;
        v_unique_parent_menus := v_empty_tbl_num_vc2idx;
        v_unique_tab_names    := v_empty_tbl_num_vc2idx;
        get_ssb_affected_by_change_to(in_method_name);
    
        d_print('---------------------');
        d_print('UNIQUE Menus');
        d_print('---------------------');
        d_print_vc2idx_array(v_unique_menus);
    
        d_print('---------------------');
        d_print('UNIQUE Pages');
        d_print('---------------------');
        d_print_vc2idx_array(v_unique_pages);
    
        d_print('---------------------');
        d_print('UNIQUE Parent Menus');
        d_print('---------------------');
        d_print_vc2idx_array(v_unique_parent_menus);
    
        d_print('---------------------');
        d_print('UNIQUE Tab Names');
        d_print('---------------------');
        d_print_vc2idx_array(v_unique_tab_names);
    end;


---------------------
--Schema related
---------------------

    -----------------------------------------------------------------------------
    -----------------------------------------------------------------------------    
    procedure desc_table_html(in_table_name in varchar2, in_owner in varchar2 default '%',
                              in_include_checksheet_cols in boolean default false) is
        cursor c_column_data is
            select atc.column_name,
                   data_type,
                   data_length,
                   data_precision,
                   data_scale,
                   decode(nullable, 'Y', 'X', '') nullable,
                   data_default,
                   comments
              from all_tab_cols atc, all_col_comments acc
             where atc.table_name = upper(in_table_name)
               and acc.table_name = atc.table_name
               and acc.COLUMN_NAME = atc.COLUMN_NAME
               and atc.owner like upper(in_owner)
               and acc.OWNER = atc.owner
             order by column_id;
    
        function get_table_comment return varchar2 is
            l_return varchar2(4000);
        begin
            select comments
              into l_return
              from all_tab_comments
             where table_name = upper(in_table_name)
               and owner like (upper(in_owner));
        
            return l_return;
        exception
            when no_data_found then
                return null;
            when too_many_rows then
                return 'You should probably specify an owner.  Could not get comments b/c of too many rows.';
            when others then
                return 'Could not get comments:  ' || sqlerrm;
        end;
    begin
        htp.htmlOpen;
        htp.bodyOpen;
        xuhtp.print_tag('h1', in_table_name);
        xuhtp.print_tag('h3', get_table_comment());
    
        htp.p('<table border="1px" cellpadding="1" style="font-size:12px">');
    
        htp.tableRowOpen;
        htp.tableHeader('Column');
        htp.tableHeader('Type');
        if (in_include_checksheet_cols) then
            htp.tableHeader('Fed?');
            htp.tableHeader('Value');
        end if;
        htp.tableHeader('Len');
        htp.tableHeader('Null');
        htp.tableHeader('Comments');
        htp.tableRowClose;
    
        for rec in c_column_data() loop
            htp.tableRowOpen;
            htp.tableData(rec.column_name);
            htp.tableData(rec.data_type);
            if (in_include_checksheet_cols) then
                htp.print('<td>&nbsp;</td><td>&nbsp;</td>');
            end if;
            htp.tableData(rec.data_length);
            htp.tableData(rec.nullable);
            htp.tableData(rec.comments);
            htp.tableRowClose;
        end loop;
        htp.tableClose;
    
        htp.bodyClose;
        htp.htmlClose;
    end;
    
-----------------------
--Public SSB Pages
-----------------------
        
    -----------------------------------------------------------------------------
    -----------------------------------------------------------------------------    
    procedure pg_last_x_parm_values(in_module in varchar2, in_x in number default 5)is
        cursor c_parms is
            select distinct zgbparm_process, zgbparm_parm_name
              from zgbparm
             where zgbparm_module = in_module;
    begin
        htp.print('<html><head>');
        print_style;
        htp.print('</head>');
        htp.print('<body>');

        for rec in c_parms loop
            print_last_x_parm_values(in_module, rec.zgbparm_process, rec.zgbparm_parm_name, in_x);             
        end loop;
        
        htp.print('</body></html>');        
    end;

    -----------------------------------------------------------------------------
    -----------------------------------------------------------------------------    
    procedure pg_last_x_parm_values(in_module in varchar2, in_process in varchar2, in_name in varchar2,
                                    in_x in number default 5) is
    begin
        htp.print('<html><head>');
        print_style;
        htp.print('</head>');
        htp.print('<body>');
        print_last_x_parm_values(in_module, in_process, in_name, in_x);
        htp.print('</body></html>');
    end;

    -----------------------------------------------------------------------------
    -----------------------------------------------------------------------------    
    procedure pg_active_zgbparm(in_module in varchar2, in_date in date default sysdate) is
    begin
        htp.print('<html><head>');
        print_style;
        htp.print('</head>');
        htp.print('<body>');
        print_active_zgbparm(in_module, in_date);
        htp.print('</body></html>');
    end;

    -----------------------------------------------------------------------------
    -----------------------------------------------------------------------------    
    procedure pg_last_x_mths_of_actv_values(in_module in varchar2, in_x in number default 5) is
    begin
        htp.print('<html><head>');
        print_style;
        htp.print('</head>');
        htp.print('<body>');
        for i in 0 .. in_x - 1 loop
            print_active_zgbparm(in_module, add_months(sysdate, -i));
        end loop;
        htp.print('</body></html>');
    end;

    function get_my_pidm return number
    is
    begin
        return g_my_pidm;
    end;
    
----------------------
--Tracing/Logging
----------------------      
    procedure create_log_table_if_dne
    is

    begin
        --if we haven't checked to see if the table exists yet then
        --check, and if it doesn't exist then make it.
        if(g_butch_trace_table_count = -1)then
            select count(1)
              into g_butch_trace_table_count
              from all_tables 
             where table_name = 'BUTCH_TRACE';
                 
            if(g_butch_trace_table_count = 0)then
                execute immediate ('create table BUTCH_TRACE (msg varchar2(4000), insert_date date)');
            end if;
        end if;        
    end;
    
    procedure trace(in_msg in varchar2)
    is
        PRAGMA AUTONOMOUS_TRANSACTION;    
    begin
        create_log_table_if_dne;
        execute immediate('insert into butch_trace(msg, insert_date) values(:msg, sysdate)')using in_msg;
        commit;
    end;
    
    procedure clear_trace
    is
    begin
        execute immediate('drop table butch_trace');
    end;
begin
    select spriden_pidm 
      into g_my_pidm
      from spriden
     where spriden_change_ind is null
       and spriden_id = C_MY_ID;       
end btwh_ban_utils;
/

create or replace package xu_ssb_zgbparm is
    E_BAD_DATE      constant number := -20100;
    E_BAD_VALUE     constant number := -20101;
    E_PARAM_DNE     constant number := -20102;

    procedure print_historic_values_table(in_module in varchar2, in_process in varchar2, in_param in varchar2);    
    procedure pg_modules;
    procedure pg_all_values(in_date in varchar2 default null);
    procedure pg_module(in_module in varchar2, in_date in varchar2 default null);
    procedure pg_process(in_module in varchar2, in_process in varchar2, in_date in varchar2 default null);
    procedure pg_param(in_module in varchar2, in_process in varchar2, in_param in varchar2);
    procedure pg_search_results(in_module in varchar2 default null, 
                                in_process in varchar2 default null, 
                                in_date in varchar2 default null, 
                                in_param_name in varchar2 default null,
                                in_param_value in varchar2 default null);
end xu_ssb_zgbparm;
/
create or replace package body xu_ssb_zgbparm is
    DATE_FMT  constant varchar2(50) := 'mm/dd/yyyy hh:mi:ss am';
    PACK_NAME constant varchar2(20) := 'xu_ssb_zgbparm';
    OTHER_FMT constant varchar2(20) := 'mm/dd/yyyy';
    
    cursor c_modules is
        select distinct zgbparm_module name from zgbparm order by lower(zgbparm_module);


    cursor c_all_current_param_values (in_module_like in varchar2 default null, 
                                       in_process_like in varchar2 default null, 
                                       in_param_name in varchar2 default null)is
          select distinct vars.zgbparm_module,
                                vars.zgbparm_process,
                                vars.zgbparm_parm_name,
                                vals.zgbparm_parm_value,
                                vals.zgbparm_from_date,
                                vals.zgbparm_to_date
                  from zgbparm vars
                  left outer join zgbparm vals
                    on vals.zgbparm_module = vars.zgbparm_module
                   and vals.zgbparm_process = vars.zgbparm_process
                   and vals.zgbparm_parm_name = vars.zgbparm_parm_name
                where upper(vars.zgbparm_module) like (upper('%'||in_module_like||'%'))
                  and upper(vars.zgbparm_process) like (upper('%'||in_process_like||'%'))
                  and upper(vars.zgbparm_parm_name) like (upper('%'||in_param_name||'%'))
                 order by lower(vars.zgbparm_module), lower(vars.zgbparm_process), lower(vars.zgbparm_parm_name),
                 zgbparm_to_date desc, zgbparm_parm_value;

    cursor c_param_search_results (in_module_like in varchar2 default null, 
                                   in_process_like in varchar2 default null, 
                                   in_date in date default sysdate, 
                                   in_param_name in varchar2 default null,
                                   in_param_value in varchar2 default null)is
          select distinct vars.zgbparm_module,
                                vars.zgbparm_process,
                                vars.zgbparm_parm_name,
                                vars.zgbparm_parm_value,
                                vars.zgbparm_from_date,
                                vars.zgbparm_to_date
                                from zgbparm vars
                where upper(vars.zgbparm_module) like (upper('%'||in_module_like||'%'))
                  and upper(vars.zgbparm_process) like (upper('%'||in_process_like||'%'))
                  and upper(vars.zgbparm_parm_name) like (upper('%'||in_param_name||'%'))
                  and nvl(vars.zgbparm_parm_value, 'WONT__BE_MATCHED__') like (nvl(in_param_value, '%'))
                   and vars.zgbparm_from_date <= nvl(in_date, to_date('01/01/2200', OTHER_FMT))
                   and vars.zgbparm_to_date >= nvl(in_date, to_date('01/01/1800', OTHER_FMT))                  
                 order by lower(vars.zgbparm_module), lower(vars.zgbparm_process), lower(vars.zgbparm_parm_name),
                 zgbparm_to_date desc, zgbparm_parm_value;

    cursor c_historic_values(in_module in varchar2, in_process in varchar2, in_param in varchar2) is
        select zgbparm_parm_value value, zgbparm_from_date from_date, zgbparm_to_date to_date
          from zgbparm
         where zgbparm_module = in_module
           and zgbparm_process = in_process
           and zgbparm_parm_name = in_param
         order by zgbparm_to_date desc;
    
    ---------------------------------------------------------------------------
    ---------------------------------------------------------------------------    
    function get_module_link(in_module in varchar2) return varchar2 is
    begin
        return '<a href="' || PACK_NAME || '.pg_module?in_module=' || in_module || '">' || in_module || '</a>';
    end;

    ---------------------------------------------------------------------------
    ---------------------------------------------------------------------------    
    function get_process_link(in_module in varchar2, in_process in varchar2)return varchar2 is
    begin
        return '<a href="'||PACK_NAME||'.pg_process?in_module='||in_module||'&in_process='||in_process||'">'||in_process||'</a>';
    end;    

    ---------------------------------------------------------------------------
    ---------------------------------------------------------------------------    
    function get_param_link(in_module in varchar2, in_process in varchar2, in_param in varchar2)return varchar2 is
    begin
        return '<a href="'||PACK_NAME||'.pg_param?in_module='||in_module||'&in_process='||in_process||'&in_param='||in_param||'">'||in_param||'</a>';
    end;
    
    ---------------------------------------------------------------------------
    ---------------------------------------------------------------------------        
    function get_main_page_link return varchar2
    is
    begin
        return '<a href="'||PACK_NAME||'.pg_modules">Back to start</a>';
    end;
    ---------------------------------------------------------------------------
    ---------------------------------------------------------------------------    
    function get_date_or_sysdate(in_date_str in varchar2) return date
    is
        l_return        date;
    begin
        if(in_date_str is null)then
            l_return := sysdate;
        else
            begin
                l_return := to_date(in_date_str, OTHER_FMT);
            exception
                when others then
                    l_return := sysdate;
            end;
       end if;
       
       return l_return;
    end;

    ---------------------------------------------------------------------------
    ---------------------------------------------------------------------------    
    procedure print_historic_values_table(in_module in varchar2, in_process in varchar2, in_param in varchar2) is
    begin
        htp.print('<table border="1px">');
        htp.print('<tr>');
        xuhtp.print_tag('th', 'Value');
        xuhtp.print_tag('th', 'From Date');
        xuhtp.print_tag('th', 'To Date');
        htp.print('</tr>');
        for rec in c_historic_values(in_module, in_process, in_param) loop
            if (sysdate between rec.from_date and rec.to_date) then
                rec.value := '<b>' || rec.value || '</b>';
            end if;
            htp.print('<tr>');
            xuhtp.print_tag('td', rec.value);
            xuhtp.print_tag('td', to_char(rec.from_date, DATE_FMT));
            xuhtp.print_tag('td', to_char(rec.to_date, DATE_FMT));
            htp.print('</tr>');
        end loop;
    
    end;

    ---------------------------------------------------------------------------
    ---------------------------------------------------------------------------    
    procedure print_all_info(in_module in varchar2 default '%', 
                             in_process in varchar2 default '%', 
                             in_date in date default null,
                             in_show_nulls in boolean default true)
    is
        l_last_module       varchar2(100) := 'NADA';
        l_last_process      varchar2(100) := 'NADA';
    begin
        htp.print('<table border="1px">');
        htp.print('<tr>');
        xuhtp.print_tag('th', 'Module');
        xuhtp.print_tag('th', 'Process');
        xuhtp.print_tag('th', 'Parameter');
        xuhtp.print_tag('th', 'Value');
        xuhtp.print_tag('th', 'From Date');
        xuhtp.print_tag('th', 'To Date');
        htp.print('</tr>');

        for rec in c_all_current_param_values(in_module, in_process)loop        
            if(rec.zgbparm_parm_value is not null or in_show_nulls)then
                htp.print('<tr>');
                
                if(rec.zgbparm_module <> l_last_module)then
                    xuhtp.print_tag('td', get_module_link(rec.zgbparm_module));
                    l_last_process := 'NADA';
                else
                    htp.print('<td/>');
                end if;
                
                if(rec.zgbparm_process <> l_last_process)then
                    xuhtp.print_tag('td', get_process_link(rec.zgbparm_module, rec.zgbparm_process));
                else
                    htp.print('<td/>');
                end if;
                
                xuhtp.print_tag('td', get_param_link(rec.zgbparm_module, rec.zgbparm_process, rec.zgbparm_parm_name));
                xuhtp.print_tag('td', nvl(rec.zgbparm_parm_value, 'NULL'));
                begin
                    xuhtp.print_tag('td', to_char(rec.zgbparm_from_date, DATE_FMT));
                exception
                    when others then
                        xuhtp.print_tag('td', to_char(rec.zgbparm_from_date, OTHER_FMT));
                end;
                begin
                    xuhtp.print_tag('td', to_char(rec.zgbparm_to_date, DATE_FMT));
                exception
                    when others then
                        xuhtp.print_tag('td', to_char(rec.zgbparm_to_date, OTHER_FMT));
                end;
                htp.print('</tr>');
            end if;
            l_last_module := rec.zgbparm_module;
            l_last_process := rec.zgbparm_process;
        end loop;

        htp.print('</table>');
    end; 

    procedure print_search_results(in_module in varchar2 default '%', 
                             in_process in varchar2 default '%', 
                             in_date in date default null,
                             in_param_name in varchar2 default null,
                             in_param_value in varchar2 default null,
                             in_show_nulls in boolean default true)
    is
        l_last_module       varchar2(100) := 'NADA';
        l_last_process      varchar2(100) := 'NADA';
    begin
        htp.print('<table border="1px">');
        htp.print('<tr>');
        --if(in_module= '%')then
            xuhtp.print_tag('th', 'Module');
        --end if;
        --if(in_process = '%')then
            xuhtp.print_tag('th', 'Process');
        --end if;
        xuhtp.print_tag('th', 'Parameter');
        xuhtp.print_tag('th', 'Value');
        xuhtp.print_tag('th', 'From Date');
        xuhtp.print_tag('th', 'To Date');
        htp.print('</tr>');

        for rec in c_param_search_results(in_module, in_process, in_date, in_param_name, in_param_value)loop        
            if(rec.zgbparm_parm_value is not null or in_show_nulls)then
                htp.print('<tr>');
                
                if(rec.zgbparm_module <> l_last_module)then
                    xuhtp.print_tag('td', get_module_link(rec.zgbparm_module));
                    l_last_process := 'NADA';
                else
                    htp.print('<td/>');
                end if;
                
                if(rec.zgbparm_process <> l_last_process)then
                    xuhtp.print_tag('td', get_process_link(rec.zgbparm_module, rec.zgbparm_process));
                else
                    htp.print('<td/>');
                end if;
                
                xuhtp.print_tag('td', get_param_link(rec.zgbparm_module, rec.zgbparm_process, rec.zgbparm_parm_name));
                xuhtp.print_tag('td', nvl(rec.zgbparm_parm_value, 'NULL'));
                begin
                    xuhtp.print_tag('td', to_char(rec.zgbparm_from_date, DATE_FMT));
                exception
                    when others then
                        xuhtp.print_tag('td', to_char(rec.zgbparm_from_date, OTHER_FMT));
                end;
                begin
                    xuhtp.print_tag('td', to_char(rec.zgbparm_to_date, DATE_FMT));
                exception
                    when others then
                        xuhtp.print_tag('td', to_char(rec.zgbparm_to_date, OTHER_FMT));
                end;
                htp.print('</tr>');
            end if;
            l_last_module := rec.zgbparm_module;
            l_last_process := rec.zgbparm_process;
        end loop;

        htp.print('</table>');
    end; 

    ---------------------------------------------------------------------------
    ---------------------------------------------------------------------------    
    function does_parameter_exist(in_module in varchar2, in_process in varchar2, in_param in varchar2) return boolean
    is
        l_count     number := 0;
    begin
        select count(1)
          into l_count
          from zgbparm
         where zgbparm_module = in_module
           and zgbparm_process = in_process
           and zgbparm_parm_name = in_param;
        
        return l_count > 0;
    end;
    

    ---------------------------------------------------------------------------
    ---------------------------------------------------------------------------    
    procedure update_value(in_module in varchar2, 
                        in_process in varchar2, 
                        in_param in varchar2, 
                        in_value in varchar2,
                        in_from_date in varchar2 default null, 
                        in_to_date in varchar2 default null) is
        l_from_date date;
        l_to_date   date;
        l_full_param        varchar2(200);
    begin
        l_full_param := in_module||'.'||in_process||'.'||in_param;
        if (not does_parameter_exist(in_module, in_process, in_param))then
            raise_application_error(E_PARAM_DNE, 'The parameter does not exist.');
        end if;
        
        begin
            if (in_from_date is null) then
                l_from_date := trunc(sysdate);
            else
                l_from_date := to_date(in_from_date, 'mm/dd/yyyy');
            end if;
            l_to_date := to_date(nvl(in_to_date, '12/01/2099'), 'mm/dd/yyyy');
        exception
            when others then
                raise_application_error(E_BAD_DATE,
                                        'The date format provdided for the FROM or TO date is invalid.  ' ||
                                        'It must be of the format mm/dd/yyyy.');
        end;
                        
        update zgbparm
           set zgbparm_to_date = in_from_date
         where zgbparm_module = in_module
           and zgbparm_process = in_process
           and zgbparm_parm_name = in_param
           and zgbparm_to_date = (select max(zgbparm_to_date)
                                    from zgbparm
                                   where zgbparm_module = in_module
                                     and zgbparm_process = in_process
                                     and zgbparm_parm_name = in_param);

        insert into zgbparm
            (zgbparm_process,
             zgbparm_module,
             zgbparm_parm_name,
             zgbparm_parm_value,
             zgbparm_from_date,
             zgbparm_to_date,
             zgbparm_user_id,
             zgbparm_activity_date)
        values
            (in_process, in_module, in_param, in_value, l_from_date, l_to_date, 1, sysdate);
        
        --Have to set the value somehow.  There appears to be 3 different ways to use zgbparm values.
        --maybe all 3 need to be accounted for.  Might also need to 'delete' a parameter.
        --The 3 ways are...normal, array, and some weird way with the from and to dates actually being values.
    exception
        when others then
            raise_application_error(E_BAD_VALUE,
                                    'There was an error setting the value for '|| l_full_param || ':  ' || sqlerrm);
    end;


    procedure print_search_form(in_process in varchar2 default null, 
                                in_module in varchar2 default null, 
                                in_date in date default sysdate, 
                                in_param_name in varchar2 default null,
                                in_param_value in varchar2 default null)
    is
    begin
        xuhtp.print_tag('h2', 'Search');
        htp.print('<form action="xu_ssb_zgbparm.pg_search_results" method="post">');
        htp.print('<table>');
        htp.print('    <tr>');
        htp.print('        <td>Module</td>');
        htp.print('        <td><input name="in_module" type="text" value="'||in_module||'"/></td>');
        htp.print('    </tr>');
        htp.print('    <tr>');
        htp.print('        <td>Process</td>');
        htp.print('        <td><input name="in_process" type="text" value="'||in_process||'"/></td>');
        htp.print('    </tr>');
        htp.print('    <tr>');
        htp.print('        <td>Parameter Name</td>');
        htp.print('        <td><input name="in_param_name" type="text" value="'||in_param_name||'"/></td>');
        htp.print('    </tr>');
        htp.print('    <tr>');
        htp.print('        <td>Parameter Value</td>');
        htp.print('        <td><input name="in_param_value" type="text" value="'||in_param_value||'"/></td>');
        htp.print('    </tr>');
        htp.print('    <tr>');
        htp.print('        <td>Date</td>');
        htp.print('        <td><input name="in_date" type="text" value="'||to_char(in_date, OTHER_FMT)||'">('||OTHER_FMT||')</input></td>');
        htp.print('    </tr>');
        htp.print('    <tr>');
        htp.print('        <td/>');
        htp.print('        <td align="right"><input type="submit" value="Search"/>');
        htp.print('        <a href="xu_ssb_zgbparm.pg_search_results">reset</a></td>');
        htp.print('    </tr>');
        htp.print('</table>');
        htp.print(' </form>');
        htp.hr;
    end;

--------------
--Public
--------------    
    ---------------------------------------------------------------------------
    ---------------------------------------------------------------------------    
    procedure pg_search_results(in_module in varchar2 default null, 
                                in_process in varchar2 default null, 
                                in_date in varchar2 default null, 
                                in_param_name in varchar2 default null,
                                in_param_value in varchar2 default null) is
        l_pidm      number;
        l_date      date := null;
    begin            
        IF NOT twbkwbis.f_validuser(l_pidm) THEN
            RETURN;
        END IF;

        if(in_date is not null)then 
            l_date := to_date(in_date, OTHER_FMT);
        end if;

        bwckfrmt.p_open_doc(PACK_NAME||'.pg_search_results');
        twbkwbis.P_DispInfo(PACK_NAME||'.pg_search_results', 'Default');
        
        print_search_form(in_process => in_process, 
                          in_date => l_date, 
                          in_module => in_module, 
                          in_param_name => in_param_name,
                          in_param_value => in_param_value);htp.br;
        htp.print(get_main_page_link);
        xuhtp.print_tag('h2', 'Search results');  
        print_search_results(in_module => in_module, 
                       in_process => in_process, 
                       in_date => l_date,
                       in_param_name => in_param_name,
                       in_param_value => in_param_value);
    end;
    ---------------------------------------------------------------------------
    ---------------------------------------------------------------------------    
    procedure pg_all_values(in_date in varchar2 default null) is
        l_pidm      number;
        l_date      date := get_date_or_sysdate(in_date);
    begin
        IF NOT twbkwbis.f_validuser(l_pidm) THEN
            RETURN;
        END IF;
        bwckfrmt.p_open_doc(PACK_NAME||'.pg_all_values');
        twbkwbis.P_DispInfo(PACK_NAME||'.pg_all_values', 'Default');
        print_search_form;
                          
        xuhtp.print_tag('h2', 'All Parameters and their current value');
        print_all_info;
    exception
        when others then
            xuhtp.print_error;
    end;

    ---------------------------------------------------------------------------
    ---------------------------------------------------------------------------    
    procedure pg_modules is              
        l_pidm number;
    begin
        IF NOT twbkwbis.f_validuser(l_pidm) THEN
            RETURN;
        END IF;
        bwckfrmt.p_open_doc(PACK_NAME||'.pg_modules');
        twbkwbis.P_DispInfo(PACK_NAME||'.pg_modules', 'Default');

        print_search_form;
        htp.print('<h2><a href="'||PACK_NAME||'.pg_all_values">All Parameters and their current value</a></h3>');        
        htp.hr;
        xuhtp.print_tag('h2', 'Pick a Module');
        for rec in c_modules loop
            htp.print(get_module_link(rec.name));htp.br;          
        end loop;
        htp.br;

    exception
        when others then
            xuhtp.print_error;
    end;    
    ---------------------------------------------------------------------------
    ---------------------------------------------------------------------------    
    procedure pg_module(in_module in varchar2, in_date in varchar2 default null) 
    is
        l_pidm      number;
        l_date      date := get_date_or_sysdate(in_date);    
    begin
        IF NOT twbkwbis.f_validuser(l_pidm) THEN
            RETURN;
        END IF;
        bwckfrmt.p_open_doc(PACK_NAME||'.pg_modules');
        twbkwbis.P_DispInfo(PACK_NAME||'.pg_modules', 'Default');    

        print_search_form;        
        xuhtp.print_tag('h2', in_module);
        htp.print('<i>All parameters and current values</i><br/><br/>');
        htp.print(get_main_page_link);
        print_all_info(in_module => in_module);
    exception
        when others then
            xuhtp.print_error;
    end;

    ---------------------------------------------------------------------------
    ---------------------------------------------------------------------------    
    procedure pg_process(in_module in varchar2, in_process in varchar2, in_date in varchar2 default null) 
    is
        l_pidm      number;
        l_date      date := get_date_or_sysdate(in_date);
    begin
        IF NOT twbkwbis.f_validuser(l_pidm) THEN
            RETURN;
        END IF;
        bwckfrmt.p_open_doc(PACK_NAME||'.pg_process');
        twbkwbis.P_DispInfo(PACK_NAME||'.pg_process', 'Default');
        
        print_search_form;
        xuhtp.print_tag('h2', get_module_link(in_module)||'.'||in_process);
        htp.print('<i>All parameters and current values</i><br/><br/>');
        htp.print(get_main_page_link);
        print_all_info(in_module => in_module, in_process => in_process);
    exception
        when others then
            xuhtp.print_error;
    end;

    ---------------------------------------------------------------------------
    ---------------------------------------------------------------------------    
    procedure pg_param(in_module in varchar2, in_process in varchar2, in_param in varchar2)
    is
        l_pidm      number;
    begin
        IF NOT twbkwbis.f_validuser(l_pidm) THEN
            RETURN;
        END IF;
        bwckfrmt.p_open_doc(PACK_NAME||'.pg_param');
        twbkwbis.P_DispInfo(PACK_NAME||'.pg_param', 'Default');
    
        print_search_form;
        xuhtp.print_tag('h2', get_module_link(in_module)||'.'||get_process_link(in_module, in_process)||'.'||in_param);
        htp.print('<i>All historic values for '||in_param||'.  Current value in bold.</i><br/><br/>');
        htp.print(get_main_page_link);
        print_historic_values_table(in_module, in_process, in_param);
    exception
        when others then
            xuhtp.print_error;
    end;    
end xu_ssb_zgbparm;
/

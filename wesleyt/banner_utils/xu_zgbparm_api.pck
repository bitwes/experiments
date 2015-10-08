create or replace package xu_zgbparm_api is
    STANDARD_END_DATE constant date := to_date('12/31/2099', 'mm/dd/yyyy');

    E_NOT_SINGLE_VAL constant number := -20101;
    E_NOT_MULTI_VAL  constant number := -20102;
    E_PARM_DNE       constant number := -20103;
    E_REQUIRED_FIELD constant number := -20104;
    E_BAD_VALUE      constant number := -20105;
    E_PARM_EXISTS    constant number := -20106;

    -----------------------------------------------------------------------------
    --Creates a new value that will be effective from in_from_date to in_to_date.
    --This also end dates any value that is valid after in_from_date.  Works
    --only with parms that have a single valid value at a time.
    --
    -- %param in_module 
    -- %param in_process 
    -- %param in_parm_name 
    -- %param in_value 
    -- %param in_from_date 
    -- %param in_to_date     
    -----------------------------------------------------------------------------
    procedure set_value(in_module in varchar2, 
                        in_process in varchar2, 
                        in_parm_name in varchar2, 
                        in_value in varchar2,
                        in_from_date in date, 
                        in_to_date in date default STANDARD_END_DATE);

    -----------------------------------------------------------------------------
    --End dates the current value as of sysdate and inserts a new value effective as 
    --of sysdtate.  Works only with parms that have a single valid value at a time.
    --Uses STANDARD_END_DATE for the end date of the new value.
    --
    -- %param in_module 
    -- %param in_process 
    -- %param in_parm_name 
    -- %param in_value     
    ----------------------------------------------------------------------------  
    procedure update_current_value(in_module in varchar2, 
                                   in_process in varchar2, 
                                   in_parm_name in varchar2,
                                   in_value in varchar2);

    ----------------------------------------------------------------------------  
    --Adds a value to an existing multi-value parm.
    --
    --See student.fac_share_groups.facuser for an example
    --
    -- %param in_module 
    -- %param in_process 
    -- %param in_parm_name 
    -- %param in_value 
    -- %param in_from_date 
    -- %param in_to_date     
    ----------------------------------------------------------------------------      
    procedure add_additional_value(in_module in varchar2, 
                                   in_process in varchar2, 
                                   in_parm_name in varchar2,
                                   in_value in varchar2, 
                                   in_from_date in date default sysdate,
                                   in_to_date in date default STANDARD_END_DATE);

    ----------------------------------------------------------------------------
    --Should only be used in very rare cases and never w/o the consent of the team.
    --
    -- %param in_module 
    -- %param in_process 
    -- %param in_parm_name 
    -- %param in_active_date     
    ----------------------------------------------------------------------------          
    procedure delete_value_active_on(in_module in varchar2, 
                                     in_process in varchar2, 
                                     in_parm_name in varchar2,
                                     in_active_date in date);

    ----------------------------------------------------------------------------      
    --Should only be used in very rare cases and never w/o the consent of the team.    
    --
    -- %param in_module 
    -- %param in_process 
    -- %param in_parm_name 
    -- %param in_value 
    ----------------------------------------------------------------------------          
    procedure delete_value(in_module in varchar2, 
                           in_process in varchar2, 
                           in_parm_name in varchar2,
                           in_value in varchar2);
    ----------------------------------------------------------------------------          
    --
    -- %param in_module 
    -- %param in_process 
    -- %param in_parm_name     
    ----------------------------------------------------------------------------              
    function get_value(in_module in varchar2, 
                       in_process in varchar2, 
                       in_parm_name in varchar2) 
                       return varchar2;
    
    ----------------------------------------------------------------------------          
    --
    -- %param in_module 
    -- %param in_process 
    -- %param in_parm_name 
    -- %param in_value 
    -- %param in_from_date 
    -- %param in_to_date     
    ----------------------------------------------------------------------------              
    procedure create_parm(in_module in varchar2, 
                          in_process in varchar2, 
                          in_parm_name in varchar2, 
                          in_value in varchar2,
                          in_from_date in date default sysdate, 
                          in_to_date in date default STANDARD_END_DATE);

end xu_zgbparm_api;
/
create or replace package body xu_zgbparm_api is
    
    -----------------------------------------------------------------------------
    -----------------------------------------------------------------------------    
    function does_param_exist(in_module in varchar2, in_process in varchar2, in_parm_name in varchar2)return boolean
    is
        l_count number;
    begin
        select count(1)
          into l_count
          from zgbparm
         where zgbparm_process = in_process
           and zgbparm_module = in_module
           and zgbparm_parm_name = in_parm_name;
        
        return l_count > 0;
    end;

    -----------------------------------------------------------------------------
    --Checks to see if the specified parm exists.
    -----------------------------------------------------------------------------  
    procedure error_if_not_exist(in_module in varchar2, in_process in varchar2, in_parm_name in varchar2) is
    begin
        if (not does_param_exist(in_module, in_process, in_parm_name)) then
            raise_application_error(E_PARM_DNE,
                                    'Parmeter does not exist:  ' || in_module || '.' || in_process || '.' ||
                                    in_parm_name);
        end if;
    end;

    -----------------------------------------------------------------------------
    --Must infer this by looking to see if the parameter has more than one active
    --value.
    -----------------------------------------------------------------------------
    function is_single_value_parm(in_module in varchar2, in_process in varchar2, in_parm_name in varchar2)
    return boolean
    is
        l_count         number;
    begin
        select count(1)
          into l_count
          from zgbparm
         where zgbparm_process = in_process
           and zgbparm_module = in_module
           and zgbparm_parm_name = in_parm_name
           and sysdate between zgbparm_from_date and zgbparm_to_date;
           
        return l_count = 1;
    end;

    -----------------------------------------------------------------------------
    --Adds a new value for a parameter.  Does not check for or update any existing
    --value.  Used when updating existing values or adding a value for a parm
    --that has multiple values.
    -----------------------------------------------------------------------------
    procedure add_value(in_module in varchar2, in_process in varchar2, in_parm_name in varchar2, in_value in varchar2,
                        in_from_date in date, in_to_date in date) is
    begin
        if (in_from_date is null) then
            raise_application_error(E_REQUIRED_FIELD, 'From Date is required');
        end if;
        if (in_to_date is null) then
            raise_application_error(E_REQUIRED_FIELD, 'To Date is required');
        end if;
        if(in_from_date > in_to_date)then
            raise_application_error(E_BAD_VALUE, 'From Date must be less than To Date');
        end if;
           
        --insert the new value.
        insert into zgbparm
            (zgbparm_process,
             zgbparm_module,
             zgbparm_from_date,
             zgbparm_to_date,
             zgbparm_parm_name,
             zgbparm_parm_value,
             zgbparm_user_id,
             zgbparm_activity_date)
        values
            (in_process, in_module, in_from_date, in_to_date, in_parm_name, in_value, user, sysdate);
    end;

------------
--Public
------------

    -----------------------------------------------------------------------------
    --Creates a new value that will be effective from in_from_date to in_to_date.
    --This also end dates any value that is valid after in_from_date.  Works
    --only with parms that have a single valid value at a time.
    -----------------------------------------------------------------------------
    procedure set_value(in_module in varchar2, in_process in varchar2, in_parm_name in varchar2, in_value in varchar2,
                        in_from_date in date, in_to_date in date default STANDARD_END_DATE) is
    begin
        error_if_not_exist(in_module, in_process, in_parm_name);
        if(not is_single_value_parm(in_module, in_process, in_parm_name)) then
            raise_application_error (E_NOT_SINGLE_VAL, 'Paramter is not a single value parameter.');
        end if;

        --End date any value that is active when this one needs to be active.  
        update zgbparm
           set zgbparm_to_date = in_from_date, 
               zgbparm_activity_date = sysdate, 
               zgbparm_user_id = user
         where zgbparm_process = in_process
           and zgbparm_module = in_module
           and zgbparm_parm_name = in_parm_name
           and (in_from_date between zgbparm_from_date and zgbparm_to_date
                or zgbparm_to_date between in_from_date and in_to_date);
    
        add_value(in_module, in_process, in_parm_name, in_value, in_from_date, in_to_date);
    end;

    -----------------------------------------------------------------------------
    --End dates the current value as of sysdate and inserts a new value effective as 
    --of sysdtate.  Works only with parms that have a single valid value at a time.
    ----------------------------------------------------------------------------  
    procedure update_current_value(in_module in varchar2, in_process in varchar2, in_parm_name in varchar2,
                                   in_value in varchar2) is
    begin
        set_value(in_module, in_process, in_parm_name, in_value, sysdate);
    end;

    ----------------------------------------------------------------------------  
    --Adds a value to an existing multi-value parm.
    --
    --See student.fac_share_groups.facuser for an example
    ----------------------------------------------------------------------------      
    procedure add_additional_value(in_module in varchar2, in_process in varchar2, in_parm_name in varchar2,
                                   in_value in varchar2, in_from_date in date default sysdate,
                                   in_to_date in date default STANDARD_END_DATE) is
    begin
        error_if_not_exist(in_module, in_process, in_parm_name);
        if(is_single_value_parm(in_module, in_process, in_parm_name))then
            raise_application_error(E_NOT_MULTI_VAL, 'Paramter is not a multi value parameter.');
        end if;        
        add_value(in_module, in_process, in_parm_name, in_value, in_from_date, in_to_date);
    end;

    -----------------------------------------------------------------------------
    -----------------------------------------------------------------------------
    procedure delete_value_active_on(in_module in varchar2, 
                           in_process in varchar2, 
                           in_parm_name in varchar2, 
                           in_active_date in date)
    is
    begin
        update zgbparm
           set zgbparm_parm_value = zgbparm_parm_value||' DELETED for active period ('||
                                    to_char(zgbparm_from_date, 'mm/dd/yyyy')||' - '||
                                    to_char(zgbparm_to_date, 'mm/dd/yyyy')||').',
               zgbparm_from_date = null,
               zgbparm_to_date = null
         where zgbparm_process = in_process
           and zgbparm_module = in_module
           and zgbparm_parm_name = in_parm_name
           and in_active_date between zgbparm_from_date and zgbparm_to_date;                                                                              
    end;

    -----------------------------------------------------------------------------
    -----------------------------------------------------------------------------
    procedure delete_value(in_module in varchar2, 
                           in_process in varchar2, 
                           in_parm_name in varchar2,
                           in_value in varchar2)
    is
    begin
        update zgbparm
           set zgbparm_parm_value = zgbparm_parm_value||' DELETED for active period ('||
                                    to_char(zgbparm_from_date, 'mm/dd/yyyy')||' - '||
                                    to_char(zgbparm_to_date, 'mm/dd/yyyy')||').',
               zgbparm_from_date = null,
               zgbparm_to_date = null
         where zgbparm_process = in_process
           and zgbparm_module = in_module
           and zgbparm_parm_name = in_parm_name
           and zgbparm_parm_value = in_value;
        
    end;            
    
    -----------------------------------------------------------------------------
    -----------------------------------------------------------------------------
    procedure create_parm(in_module in varchar2, in_process in varchar2, in_parm_name in varchar2, in_value in varchar2, in_from_date in date default sysdate,
    in_to_date in date default STANDARD_END_DATE) is
    begin
        if (does_param_exist(in_module, in_process, in_parm_name)) then
            raise_application_error(E_PARM_EXISTS, 'Parameter already exists');
        end if;
                
        add_value(in_module, in_process, in_parm_name, in_value, in_from_date , in_to_date);       
    end;

    -----------------------------------------------------------------------------
    -----------------------------------------------------------------------------
    function get_value(in_module in varchar2, 
                       in_process in varchar2, 
                       in_parm_name in varchar2)return varchar2
    is
        l_return        zgbparm.zgbparm_parm_value%type;
    begin
        select zgbparm_parm_value 
          into l_return
          from zgbparm
         where zgbparm_process = in_process
           and zgbparm_module = in_module
           and zgbparm_parm_name = in_parm_name
           and sysdate between zgbparm_from_date and zgbparm_to_date;
        
        return l_return;
    end;
    
end xu_zgbparm_api;
/

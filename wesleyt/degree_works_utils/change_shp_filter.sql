--Update two tables to give new access level, per article 000013141 on ellucian support.
declare
    l_user      varchar2(100);
    l_new_class varchar2(20);
    
    l_shp       shp_user_mst%rowtype;
    l_dap       dap_user_mst%rowtype;
begin    
    l_user := '000129487';  --Mike S
    --l_user := '000575787';  --Mary B
    l_new_class := 'REG';
    
    --Update shp table to have new access level
    update shp_user_mst set shp_filter = l_new_class where trim(shp_access_id) = l_user;    
    if(sql%rowcount <> 1)then
        raise_application_error (-20001, 'did not update shp for the person.');
    end if;
    select * into l_shp from shp_user_mst where trim(shp_access_id) = l_user;
    dbms_output.put_line('shp '||l_user||':  '||l_shp.shp_filter);

    --Update dap table to have new access level
    update dap_user_mst set dap_user_class = l_new_class where trim(dap_stu_id) = l_user;
    if(sql%rowcount <> 1)then
        raise_application_error (-20001, 'did not update dap for the person.');
    end if;
    select * into l_dap from dap_user_mst where trim(dap_stu_id) = l_user;
    dbms_output.put_line('dap '||l_user||':  '||l_dap.dap_user_class);

    commit;
    
exception
    when others then
        rollback;
        raise;
end;
/



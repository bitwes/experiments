declare
    l_new_count     number;
    l_old_count     number := 0;
begin
    while true loop
        begin
            --execute immediate ('select count(1) l_new_count from persona_access_view') into l_new_count;
            execute immediate ('select count(1) l_new_count from xupersona.zgvcdac') into l_new_count;
        exception
            when others then
                --Table or view does not exist, synonym translation not valid
                if(sqlcode in (-942, -980))then
                    l_new_count := sqlcode;
                else
                    raise;
                end if;
        end;
        
        if(l_new_count <> l_old_count)then
            dbms_output.put_line(to_char(sysdate, 'hh:mi:ss')||'  '||l_new_count);
        end if;
        l_old_count := l_new_count;
        dbms_lock.sleep( 0.25 );        
    end loop;
exception
    when others then
        dbms_output.put_line(to_char(sysdate, 'hh:mi:ss')||'  '||sqlerrm);
        raise;
end;

declare
    type t_vc2k_table is table of varchar2(2000) index by binary_integer;
    
    ---------------------------------------------------------------------------
    ---------------------------------------------------------------------------    
    function pad(in_size in number, in_pad in varchar2 default ' ')return varchar2
    is
        l_return        varchar2(200);
    begin
        l_return := lpad(in_pad, in_size, in_pad);
        return l_return;
    end;
    
    ---------------------------------------------------------------------------
    ---------------------------------------------------------------------------    
    function split_by_size(in_string in varchar2, in_size in number)return t_vc2k_table
    is
        l_return        t_vc2k_table;
        l_start         number := 1;
    begin
        while(l_start < length(in_string))loop
            l_return(l_return.count + 1) := substr(in_string, l_start, in_size);
            l_start := l_start + in_size;
        end loop;
        
        return l_return;
    end;
    
    ---------------------------------------------------------------------------
    ---------------------------------------------------------------------------    
    procedure print_vc2k_table(in_array in t_vc2k_table, in_indent in varchar2 default null)is
    begin
        for i in 1..in_array.count loop
            if(trim(in_array(i)) is not null)then
                --dbms_output.put_line(in_indent||rpad(i||'.', 5, ' ')||in_array(i));
                dbms_output.put_line(in_indent||in_array(i));
            end if;
        end loop;
    end;

    ---------------------------------------------------------------------------
    ---------------------------------------------------------------------------    
    procedure print_group(in_group_name in varchar2)
    is
        l_keys      t_vc2k_table;
        l_keys_sorted t_vc2k_table;
        l_op        t_vc2k_table;
        l_output    t_vc2k_table;
        rec shp_group_mst%rowtype;
    begin
        select * 
          into rec
          from shp_group_mst
         where trim(shp_group) = trim(in_group_name);
         
        dbms_output.put_line(trim(rec.shp_group)||' ('||trim(rec.shp_group_lit)||')');
        --keys and ops stored as fixed width data in columns on the group table...horrible.
        l_keys := split_by_size(rec.shp_key_list, 8);
        l_op := split_by_size(rec.shp_key_op, 2);
        
        
        
        --combine keys and ops into one text array.
        for i in 1..l_keys.count loop
            begin
                l_output(i) := rpad(l_keys(i), 10, ' ')||l_op(i);
            exception
                when no_data_found then
                    l_output(i) := l_keys(i);
            end;
        end loop;

        print_vc2k_table(l_output, pad(4));
    exception 
        when no_data_found then
            dbms_output.put_line(in_group_name||' Not found');
    end;

    ---------------------------------------------------------------------------
    ---------------------------------------------------------------------------    
    procedure print_groups
    is
    begin
        for rec in (select shp_group from shp_group_mst order by shp_group)loop
            print_group(rec.shp_group);
        end loop;
    end;

    ---------------------------------------------------------------------------
    ---------------------------------------------------------------------------    
    procedure print_groups(in_groups in t_vc2k_table)
    is
    begin
        for i in 1..in_groups.count loop
            print_group(in_groups(i));
        end loop;
    end;

    ---------------------------------------------------------------------------
    ---------------------------------------------------------------------------    
    procedure main_proc
    is
        l_array     t_vc2k_table;
    begin
        l_array(1) := 'SRNSTU';
        l_array(2) := 'TFADV';
        print_groups(l_array);
        print_groups;
    end;
begin
    main_proc;
end;

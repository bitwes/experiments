declare
    LINE constant varchar2(100) := rpad('-', 60, '-');

    ---------------------------------------------------------------------------
    ---------------------------------------------------------------------------
    procedure print_count(in_name in varchar2, in_count in number) is
    begin
        dbms_output.put_line(rpad(in_name, 50, ' ') || in_count);
    end;

    ---------------------------------------------------------------------------
    ---------------------------------------------------------------------------
    procedure print_all_counts_for_term(in_term in varchar2) is
        cursor c_counts is
            select sfrstcr_user usr, (select stvrsts_desc from stvrsts where stvrsts_code = sfrstcr_rsts_code) rsts_code, count(1) the_count
              from sfrstcr
             where sfrstcr_term_code = in_term
             group by sfrstcr_rsts_code, sfrstcr_user
             order by sfrstcr_user, sfrstcr_rsts_code;
    begin
        dbms_output.put_line(LINE);
        dbms_output.put_line('All Counts for ' || in_term);
        dbms_output.put_line(LINE);
        for rec in c_counts loop
            dbms_output.put_line(rpad(rec.usr, 30, ' ') || rpad(rec.rsts_code, 30, ' ') || rec.the_count);
        end loop;
    end;

    ---------------------------------------------------------------------------
    ---------------------------------------------------------------------------
    function get_total_for_term_date(in_term in varchar2, in_date in date)return number
    is
        l_count     number;
    begin
        select count(1)
          into l_count
          from sfrstcr
         where sfrstcr_term_code = in_term
           and trunc(sfrstcr_activity_date) = trunc(in_date);
        
        return l_count;
    end;
    
    ---------------------------------------------------------------------------
    ---------------------------------------------------------------------------
    procedure print_all_counts_for_term(in_term in varchar2, in_date in date) is
        cursor c_counts is
            select sfrstcr_user usr, sfrstcr_rsts_code rsts_code, count(1) the_count
              from sfrstcr
             where sfrstcr_term_code = in_term
               and trunc(sfrstcr_activity_date) = trunc(in_date)
             group by sfrstcr_rsts_code, sfrstcr_user
             order by sfrstcr_user, sfrstcr_rsts_code;
    begin
        if(get_total_for_term_date(in_term, in_date) = 0)then
            return;
        end if;
    
        dbms_output.put_line(LINE);
        dbms_output.put_line('All Counts for ' || in_term || ' on ' || to_char(in_date, 'mm/dd/yyyy'));
        dbms_output.put_line(LINE);
        for rec in c_counts loop
            dbms_output.put_line(rpad(rec.usr, 30, ' ') || rpad(rec.rsts_code, 10, ' ') || rec.the_count);
        end loop;
    end;

    ---------------------------------------------------------------------------
    ---------------------------------------------------------------------------
    procedure print_sums_for_term(in_term in varchar2, in_date in date) is
        l_count number;
    begin
        if(get_total_for_term_date(in_term, in_date) = 0)then
            return;
        end if;
        
        dbms_output.put_line(LINE);
        dbms_output.put_line('Summary for ' || in_term || ' on ' || to_char(in_date, 'mm/dd/yyyy'));
        dbms_output.put_line(LINE);

        for rec in (select distinct sfrstcr_rsts_code,
                           (select stvrsts_desc from stvrsts where stvrsts_code = sfrstcr_rsts_code) rsts_desc
                     from sfrstcr 
                    where sfrstcr_user = 'MOBILE_USER' 
                      and trunc(sfrstcr_activity_date) = trunc(in_date)
                      and sfrstcr_term_code = in_term)loop        
            select count(1)
              into l_count
              from sfrstcr
             where sfrstcr_term_code = in_term
               and sfrstcr_user = 'MOBILE_USER'
               and sfrstcr_rsts_code = rec.sfrstcr_rsts_code
               and trunc(sfrstcr_activity_date) = trunc(in_date);
            print_count(in_term || ' Mobile '||rec.rsts_desc, l_count);
        end loop;
                
        dbms_output.put_line(' ');
    
        for rec in (select distinct sfrstcr_rsts_code,
                           (select stvrsts_desc from stvrsts where stvrsts_code = sfrstcr_rsts_code) rsts_desc
                      from sfrstcr 
                     where trunc(sfrstcr_activity_date) = trunc(in_date) 
                       and sfrstcr_term_code = in_term)loop            
            select count(1)
              into l_count
              from sfrstcr
             where sfrstcr_term_code = in_term
               and sfrstcr_rsts_code = rec.sfrstcr_rsts_code
               and trunc(sfrstcr_activity_date) = trunc(in_date);
            print_count(in_term || ' Total '||rec.rsts_desc, l_count);
        end loop;    
    end;

    ---------------------------------------------------------------------------
    --Sum up all the registrations made through the mobile app, and all registrations
    --made in general (mobile and not mobile).
    ---------------------------------------------------------------------------
    procedure print_sums_for_term(in_term in varchar2) is
        l_count number;
    begin
        dbms_output.put_line(LINE);
        dbms_output.put_line('Summary for ' || in_term);
        dbms_output.put_line(LINE);
        for rec in (select distinct sfrstcr_rsts_code, (select stvrsts_desc from stvrsts where stvrsts_code = sfrstcr_rsts_code) rsts_desc from sfrstcr where sfrstcr_user = 'MOBILE_USER' and sfrstcr_term_code = in_term)loop        
            select count(1)
              into l_count
              from sfrstcr
             where sfrstcr_term_code = in_term
               and sfrstcr_user = 'MOBILE_USER'
               and sfrstcr_rsts_code = rec.sfrstcr_rsts_code;
            print_count(in_term || ' Mobile '||rec.rsts_desc, l_count);
        end loop;           
    
        dbms_output.put_line(' ');
    
        for rec in (select distinct sfrstcr_rsts_code, (select stvrsts_desc from stvrsts where stvrsts_code = sfrstcr_rsts_code) rsts_desc from sfrstcr where sfrstcr_term_code = in_term)loop            
            select count(1)
              into l_count
              from sfrstcr
             where sfrstcr_term_code = in_term
               and sfrstcr_rsts_code = rec.sfrstcr_rsts_code;
            print_count(in_term || ' Total '||rec.rsts_desc, l_count);
        end loop;  
                
    end;

    ---------------------------------------------------------------------------
    --TD14270 is an issue with mobile waitlisted classes.  count up anyone who
    --waitlisted and warn about them.
    ---------------------------------------------------------------------------
    procedure print_waitlist_warning(in_term in varchar2) 
    is
        l_count         number;
    begin
        select count(1) 
          into l_count
          from sfrstcr
         where sfrstcr_user = 'MOBILE_USER'
           and sfrstcr_term_code = in_term
           and sfrstcr_rsts_code = 'WL';

        if(l_count > 0)then
            dbms_output.put_line('** '||l_count||' waitlisted for '||in_term);
        else
            dbms_output.put_line('0 waitlisted for '||in_term);
        end if;           
    end;

    ---------------------------------------------------------------------------
    --Find the people that don't have the expected sfbetrm records.
    ---------------------------------------------------------------------------
    procedure print_mobile_only_people(in_term in varchar2)
    is
        cursor c_mobile_only is
            select distinct spriden_id banner_id, spriden_pidm pidm, spriden_last_name last_name, spriden_first_name first_name
              from sfrstcr m
              join spriden
                on spriden_pidm = sfrstcr_pidm
               and spriden_change_ind is null
             where sfrstcr_term_code = in_term
               and sfrstcr_user = 'MOBILE_USER'
               and not exists (select 1
                      from sfbetrm
                     where sfbetrm_pidm = m.sfrstcr_pidm
                       and sfbetrm_term_code = m.sfrstcr_term_code)
             order by spriden_last_name, spriden_first_name;
        i number;
    begin
        dbms_output.put_line(LINE);
        dbms_output.put_line('TD 14465 people:  users missing the sfbetrm records for term '||in_term||'.');
        dbms_output.put_line(LINE);

        i := 1;
        for rec in c_mobile_only loop
            dbms_output.put_line(rpad(lpad(i||'.', 3), 4)||
                                 rpad(rec.banner_id, 12, ' ')||
                                 rpad(rec.last_name||', '||rec.first_name, 40, ' ')||
                                 rec.pidm);
            i := i + 1;
        end loop;
    end;
    
    ---------------------------------------------------------------------------
    ---------------------------------------------------------------------------
    procedure print_mobile_regs_for_day(in_day in date)
    is
        cursor c_history_recs is
            select *
              from sfrstca
             where sfrstca_user = 'DUBLABS'
               and trunc(sfrstca_rsts_date) = trunc(in_day)
             order by sfrstca_term_code, sfrstca_pidm, sfrstca_seq_number;

        cursor c_registration_recs is        
            select *
              from sfrstcr
             where sfrstcr_user = 'MOBILE_USER'
               and trunc(sfrstcr_rsts_date) = trunc(in_day)
             order by sfrstcr_term_code, sfrstcr_pidm, sfrstcr_reg_seq;
        
        procedure print_heading
        is
        begin
            dbms_output.put_line(rpad('Term', 10)||rpad('Banner ID', 12)||rpad('Date', 12)||'RSTS'||' '||'CRN');
            dbms_output.put_line(LINE);
        end;
        
        procedure print(in_term in varchar2, in_pidm in number, in_date in date, in_rsts in varchar2, in_crn in varchar2)
        is
            l_banner_id     varchar2(100);
        begin
            select spriden_id
              into l_banner_id
              from spriden
             where spriden_change_ind is null
               and spriden_pidm = in_pidm;
               
            dbms_output.put_line(rpad(in_term, 10)||rpad(l_banner_id, 12)||rpad(to_char(in_date, 'mm/dd/yyyy'), 12)||rpad(in_rsts, 5)||in_crn);
        end;
    begin
        dbms_output.put_line(LINE);
        dbms_output.put_line('Report for '||to_char(in_day, 'mm/dd/yyyy'));


        dbms_output.put_line('Registration activity history recs');
        print_heading;
        for rec in c_registration_recs loop
            print(rec.sfrstcr_term_code, rec.sfrstcr_pidm, rec.sfrstcr_rsts_date, rec.sfrstcr_rsts_code, rec.sfrstcr_crn);
        end loop;
/*
        dbms_output.put_line('');
        dbms_output.put_line('Registration activity history recs');
        print_heading;
        for rec in c_history_recs loop
            print(rec.sfrstca_term_code, rec.sfrstca_pidm, rec.sfrstca_rsts_date, rec.sfrstca_rsts_code, rec.sfrstca_crn);
        end loop;
*/        
    end;
    
    procedure print_last_5_days_mobile_reg
    is
    begin
        for i in 0..4 loop
            print_mobile_regs_for_day(trunc(sysdate) - i);
            dbms_output.put_line('');
            dbms_output.put_line('');            
        end loop;
    end;
    
    ---------------------------------------------------------------------------
    ---------------------------------------------------------------------------
    procedure main_proc is
        l_date      date := sysdate - 5;
        l_count     number;
    begin

        --print_all_counts_for_term('201405');
        print_sums_for_term('201405');
        --print_all_counts_for_term('201409');
        print_sums_for_term('201409');
        

        for i in 0..4 loop
            print_sums_for_term('201405', l_date + i);
            print_sums_for_term('201409', l_date + i);
        end loop;

        dbms_output.put_line(LINE);
        select count(distinct sfrstcr_pidm)
          into l_count
          from sfrstcr
         where sfrstcr_term_code in ('201405', '201409')
           and sfrstcr_user = 'MOBILE_USER';        
        print_count('Unique Mobile Users ', l_count);        
        
        dbms_output.put_line(LINE);
        print_waitlist_warning('201405');
        print_waitlist_warning('201409');
        print_mobile_only_people('201405');        
        print_mobile_only_people('201409');        
    end;

begin
--    main_proc;
    print_last_5_days_mobile_reg;
end;
/

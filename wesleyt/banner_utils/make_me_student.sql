declare
    l_student       xu_test_data.t_student_props;
begin
    xu_test_data.test_user('TEST_BUTCH');
    xu_test_data.test_origin('ORGBUTCH');        

    l_student.pidm := btwh_utils.get_my_pidm;--559173
    l_student.term := '201401';
    l_student.stu_level := 'U';
    l_student.program := 'BA-AS';
    l_student.department := 'ACCT';
    l_student.degree_code := 'BA';
    l_student.majr := 'CSCI';

    begin
        xu_test_data.make_student(l_student);        
    --This thing blows up when run multiple times because it is not clear
    --when the data is cleared.  This might be a bug in xu_test_data.
    exception
        when others then
            dbms_output.put_line('make student:  '||sqlerrm);
    end;

    begin
        xu_test_data.make_student_eligible_for_term(l_student, '201309');
    exception
        when others then
            dbms_output.put_line('eligible for term:  '||sqlerrm);
    end;
    
    begin
        xu_test_data.make_student_eligible_for_term(l_student, '201401');
    exception
        when  others then
            dbms_output.put_line('eligible for term:  '||sqlerrm);
    end;
    
    --Set term to be open for registration
    xu_test_data_CLASSES.change_term_reg_window('201401', '1', 'RW', sysdate - 20, sysdate + 20);
    xu_test_data_classes.change_term_reg_window('201309', '1', 'RW', sysdate - 20, sysdate + 20);

    --create time tickets that have dates surround current date.  Although the term is open,
    --the time ticket from-to dates can prevent you from registering.
    xu_test_data_classes.create_time_ticket('t0', '201309', 201, sysdate - 20, sysdate + 20);
    xu_test_data_classes.assign_time_ticket_to_student(l_student.pidm, 't0', '201309');    
    xu_test_data_classes.create_time_ticket('t1', '201401', 200, sysdate - 20, sysdate + 20);    
    xu_test_data_classes.assign_time_ticket_to_student(l_student.pidm, 't1', '201401');
        
    commit;
end;


/*
begin    
    xu_test_data.test_user('TEST_BUTCH');
    xu_test_data.test_origin('ORGBUTCH');
    xu_test_data.clear_all_test_data;
    commit;
end;
*/



create or replace package unit_test_example is

end unit_test_example;
/
create or replace package body unit_test_example is
  g_num_hash     xu_datatype.t_number_hash;


  procedure set_the_10th_number(l_value in number)
  is
  begin
    g_num_hash(10) := l_value;
  end;

  function get_the_10th_number return number
  is
  begin
    return g_num_hash(10);
  end;

------------------------------------------------
--Testing Methods
------------------------------------------------
  
  procedure testsetup 
  is
  begin
    if(not xut.is_running)then
      return;
    end if;

    --Fill the number hash
    for i in 1..20 loop
      g_num_hash(i) := i;
    end loop;
  end;

  --resets all state that may have been introduced by previous 
  --test and the setup.
  procedure testteardown
  is
    l_empty   xu_datatype.t_number_hash;
  begin
    if(not xut.is_running)then
      return;
    end if;

    --clear out the number hash.
    g_num_hash := l_empty;
  end;

  procedure test_set_10th_num
  is
  begin
    set_the_10th_number(99);
    xut.assert_eq(99, to_number(get_the_10th_number), 'The 10th number should be set to 99');
  end;
  
  procedure test_fail_10th_eq_99
  is
  begin
    xut.assert_eq(99, to_number(get_the_10th_number), 'The 10th number should be set to 99');
  end;
  
  procedure test_do_another_test
  is
  begin
    xut.assert(true = true, 'True should always be true');
  end;
end unit_test_example;
/

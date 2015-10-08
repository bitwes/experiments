create or replace package test_xu_current_sprtele is

end test_xu_current_sprtele;
/
create or replace package body test_xu_current_sprtele is
    g_default_person            xu_test_data.t_person;
    g_tele                      sprtele%rowtype;
    g_empty_sprtele             sprtele%rowtype;
    
    type t_current_teles is table of xu_current_sprtele%rowtype index by binary_integer;
    
    --runs before ANY tests are run
    procedure testprerunsetup is
    begin
        g_default_person.pidm := null;
        g_default_person.first_name := 'Testerson';
        g_default_person.last_name := 'Hank';
        g_default_person.mi := 'T';
        g_default_person.dob := to_date('05/25/1977', 'mm/dd/yyyy');
        xu_test_data.create_test_user(g_default_person);
        commit;
    end;
    
    --runs ater ALL tests have run
    procedure testpostrunteardown is
    begin
        xu_test_data.clear_all_test_data;
        commit;        
    end;
    
    --runs after each test.
    procedure testteardown is
    begin
        --no changes saved during tests
        rollback;
    end;
    
    --runs before each test.
    procedure testsetup is
    begin
        --setup/reset the default person settings before each test.                
        g_tele := g_empty_sprtele;
        g_tele.sprtele_pidm := g_default_person.pidm;
        g_tele.sprtele_phone_area := '123';
        g_tele.sprtele_phone_number := '1';
    end;

    -----------------------------------------------------------------------------
    --Gets all tele entries found for the parameters.
    -----------------------------------------------------------------------------
    function get_current_teles(in_pidm in number, in_tele_code in varchar2, in_atyp_code in varchar2)
    return t_current_teles
    is
        l_return        t_current_teles;
    begin
        select *
          bulk collect into l_return
          from xu_current_sprtele
         where sprtele_pidm = in_pidm
           and sprtele_tele_code like(in_tele_code)
           and sprtele_atyp_code like(in_atyp_code);
           
        return l_return;
    end;

----------------
--Tests
----------------

    -----------------------------------------------------------------------------
    --If the person only has one telephone number make sure it exists.
    procedure test_gets_only_tele
    is
        l_teles         t_current_teles;
    begin
        g_tele.sprtele_tele_code := 'HM';
        g_tele.sprtele_atyp_code := 'HM';
        g_tele := xu_test_data.insert_sprtele(g_tele);
        
        l_teles := get_current_teles(g_default_person.pidm, g_tele.sprtele_tele_code, g_tele.sprtele_atyp_code);
        xut.assert(l_teles.count, 1, 'It should have found one address.');
    end;    

    -----------------------------------------------------------------------------
    --Make sure there isn't any overlap based on atyp code.
    procedure test_gets_one_tele_code
    is
        l_teles         t_current_teles;
    begin
        g_tele.sprtele_tele_code := 'HM';
        g_tele.sprtele_atyp_code := 'HM';
        g_tele := xu_test_data.insert_sprtele(g_tele);

        g_tele.sprtele_tele_code := 'CELL';
        g_tele.sprtele_atyp_code := 'HM';
        g_tele := xu_test_data.insert_sprtele(g_tele);
        
        l_teles := get_current_teles(g_default_person.pidm, 'CELL', 'HM');        
        xut.assert(l_teles.count, 1, 'It should only have found 1.');
    end;    
    
    -----------------------------------------------------------------------------
    --Make sure all phones of a given atyp are found
    procedure test_get_two_tele_code
    is
        l_teles         t_current_teles;
    begin
        g_tele.sprtele_tele_code := 'BU';
        g_tele.sprtele_atyp_code := 'BU';
        g_tele := xu_test_data.insert_sprtele(g_tele);

        g_tele.sprtele_tele_code := 'FAX';
        g_tele.sprtele_atyp_code := 'BU';
        g_tele := xu_test_data.insert_sprtele(g_tele);
        
        l_teles := get_current_teles(g_default_person.pidm, '%', 'BU');        
        xut.assert(l_teles.count, 2, 'It should have found 2.');
    end;    

    -----------------------------------------------------------------------------
    --Make sure the view honors the primary indicator as the first result when
    --gettying based on the atyp
    procedure test_gets_primary_first
    is
        l_teles         t_current_teles;
    begin
        g_tele.sprtele_tele_code := 'CELL';
        g_tele.sprtele_atyp_code := 'HM';
        g_tele.sprtele_primary_ind := 'Y';
        g_tele := xu_test_data.insert_sprtele(g_tele);

        g_tele.sprtele_tele_code := 'HM';
        g_tele.sprtele_atyp_code := 'HM';
        g_tele.sprtele_primary_ind := NULL;
        g_tele := xu_test_data.insert_sprtele(g_tele);
        
        l_teles := get_current_teles(g_default_person.pidm, '%', 'HM');        
        xut.assert(nvl(l_teles(1).sprtele_primary_ind, 'N'), 'Y', 'The primary phone should have been first');
        xut.assert(l_teles(2).sprtele_primary_ind is null, 'The 2nd one should have a null primary ind.');
    end;

    -----------------------------------------------------------------------------
    --Make sure it doesn't include multiples of the same type when the others are
    --inactive.
    procedure test_dont_get_inactives
    is
        l_teles         t_current_teles;
    begin
        g_tele.sprtele_tele_code := 'CELL';
        g_tele.sprtele_atyp_code := 'HM';
        g_tele.sprtele_primary_ind := 'Y';
        
        g_tele.sprtele_phone_area := '9';
        g_tele.sprtele_phone_number := '101';
        g_tele := xu_test_data.insert_sprtele(g_tele);

        g_tele.sprtele_phone_area := '8';
        g_tele.sprtele_phone_number := '102';
        g_tele := xu_test_data.insert_sprtele(g_tele);

        g_tele.sprtele_phone_area := '7';
        g_tele.sprtele_phone_number := '103';
        g_tele := xu_test_data.insert_sprtele(g_tele);

        l_teles := get_current_teles(g_default_person.pidm, 'CELL', 'HM');                
        xut.assert(l_teles.count, 1, 'There should only be one home cell number');
        xut.assert(l_teles(1).sprtele_phone_number, g_tele.sprtele_phone_number, 'The phone number should match the latest entry.');
    end;

    -----------------------------------------------------------------------------
    --Create 3 home cell phones, make sure that they are ordered correctly so
    --that the one with the primary indicator is first when it has a mid seqno
    --value and all are active.
    procedure test_get_older_actives
    is
        l_teles         t_current_teles;
    begin
        g_tele.sprtele_tele_code := 'CELL';
        g_tele.sprtele_atyp_code := 'HM';

        g_tele.sprtele_primary_ind := NULL;        
        g_tele.sprtele_phone_area := '9';
        g_tele.sprtele_phone_number := '101';
        g_tele := xu_test_data.insert_sprtele(g_tele, false);

        g_tele.sprtele_primary_ind := 'Y';        
        g_tele.sprtele_phone_area := '8';
        g_tele.sprtele_phone_number := '102';
        g_tele := xu_test_data.insert_sprtele(g_tele, false);

        g_tele.sprtele_primary_ind := NULL;        
        g_tele.sprtele_phone_area := '7';
        g_tele.sprtele_phone_number := '103';
        g_tele := xu_test_data.insert_sprtele(g_tele, false);

        l_teles := get_current_teles(g_default_person.pidm, 'CELL', 'HM');                
        xut.assert(l_teles.count, 3, 'There should only be 3 cell phones');
        xut.assert(l_teles(1).sprtele_phone_number, '102', 'The phone number should match the prefferred one.');
    end;

    -----------------------------------------------------------------------------
    --Create 3 home cell phones, make sure that the ranking of 1 goes to the one with
    --the primary indicator set when it is the lowest seqno and all are active
    procedure test_rank_primary_first
    is
        l_teles         t_current_teles;    
    begin
        g_tele.sprtele_tele_code := 'CELL';
        g_tele.sprtele_atyp_code := 'HM';
        
        g_tele.sprtele_primary_ind := 'Y';        
        g_tele.sprtele_phone_area := '9';
        g_tele.sprtele_phone_number := '101';
        g_tele := xu_test_data.insert_sprtele(g_tele, false);        
        
        g_tele.sprtele_primary_ind := null;       
        g_tele.sprtele_phone_area := '8';
        g_tele.sprtele_phone_number := '102';
        g_tele := xu_test_data.insert_sprtele(g_tele, false);        
        
        g_tele.sprtele_phone_area := '7';
        g_tele.sprtele_phone_number := '103';
        g_tele := xu_test_data.insert_sprtele(g_tele, false);        

        select * 
          bulk collect into l_teles
          from xu_current_sprtele
         where sprtele_pidm = g_default_person.pidm
           and ranking = 1
           and sprtele_tele_code = 'CELL';

        xut.assert(l_teles(1).sprtele_phone_number, '101', 'The first one should be the one with primary ind set');     
    end;
    
    -----------------------------------------------------------------------------
    --Make sure that there is only one record per pidm/atyp_code/tele_code combo.
    procedure test_one_exists_per_tele_atyp
    is
        l_count         number;
    begin
        select count(1)
          into l_count
          from (select sprtele_pidm, sprtele_atyp_code, sprtele_tele_code, count(1) cnt
                  from xu_current_sprtele                  
                  where ranking = 1
                 group by sprtele_pidm, sprtele_atyp_code, sprtele_tele_code)
         where cnt > 1;
        
        xut.assert(l_count, 0, 'There should be only one record per pidm/tele_code/atyp_code.');
    end;
    
    -----------------------------------------------------------------------------
    procedure test_honors_unlisted
    is
        l_teles         t_current_teles;    
    begin
        g_tele.sprtele_tele_code := 'CELL';
        g_tele.sprtele_atyp_code := 'HM';        
        g_tele.sprtele_primary_ind := 'Y';        
        g_tele.sprtele_phone_area := '9';
        g_tele.sprtele_phone_number := '101';
        g_tele.sprtele_unlist_ind := 'Y';
        g_tele := xu_test_data.insert_sprtele(g_tele, false);        
        
        l_teles := get_current_teles(g_default_person.pidm, 'CELL', 'HM');
        xut.assert(l_teles.count, 0, 'It should not have found the unlisted cell');
    end;
end test_xu_current_sprtele;
/

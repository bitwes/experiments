create or replace package TEST_ZGBPARM_API is

end test_zgbparm_api;
/
create or replace package body test_zgbparm_api is
    function get_parm_value_count(in_module in varchar2,
                                  in_process in varchar2, 
                                  in_parm in varchar2)return number
    is
        l_count     number;
    begin
        select count(1)
          into l_count
          from zgbparm
         where zgbparm_module = in_module
           and zgbparm_process = in_process
           and zgbparm_parm_name = in_parm;
        
        return l_count;
    end;
    
    --runs before ANY tests are run
    procedure testprerunsetup is
    begin
        null;
    end;
    
    --runs ater ALL tests have run
    procedure testpostrunteardown is
    begin
        null;
    end;
    
    --runs after each test.
    procedure testteardown is
    begin
        rollback;
    end;
    
    --runs before each test.
    procedure testsetup is
    begin
        null;
    end;

    --Test creating one
    procedure test_create_parm is
    begin
        xu_zgbparm_api.create_parm('test_module', 'test_process', 'test_parm', 'test_value');
        xut.assert(get_parm_value_count('test_module', 'test_process', 'test_parm'), 1, 'Should have made one');
    end;

    --Make sure you cannot recreate the same one twice
    procedure test_cannot_create_same_twice is
    begin
        xu_zgbparm_api.create_parm('test_module', 'test_process', 'test_blah', 'test_value');
        xu_zgbparm_api.create_parm('test_module', 'test_process', 'test_blah', 'test_value');            
        xut.assert(false, 'should have errored');
    exception
        when others then
            if(sqlcode = xu_zgbparm_api.E_PARM_EXISTS)then
                xut.assert(true, 'Errored like it should');
            else
                xut.assert(false, 'Failed with wrong error:  '||sqlerrm);
            end if;
    end;
    
    --Make sure the from date is always less than the to date on creation.
    procedure test_create_from_lt_to
    is
    begin
        xu_zgbparm_api.create_parm('test_module', 'test_process', 'test_blah', 'test_value', sysdate, sysdate -1);
        xut.assert(false, 'Should have errored');
    exception
        when others then
            if(sqlcode = xu_zgbparm_api.E_BAD_VALUE)then
                xut.assert(true, 'Correctly errored');
            else
                xut.assert(false, 'Wrong error:  '||sqlerrm);
            end if;                
    end;
    
    procedure test_cant_update_non_existant
    is
    begin
        xut.pending;
    end;
end test_zgbparm_api;
/

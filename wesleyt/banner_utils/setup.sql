SET DEFINE OFF
set serveroutput on

@@btwh_utils.pck
SHOW ERRORS

@@xu_ssb_test.pck
SHOW ERRORS

@@xut.pck
SHOW ERRORS

@@xu_test_data.pck
SHOW ERRORS

exec xu_ssb_test.create_ssb_objects
SHOW ERRORS

commit;

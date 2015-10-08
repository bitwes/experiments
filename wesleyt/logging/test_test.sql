declare
begin
  -----------------------------------------------------------------------------
  --basic demo of testing methods.  You first start a test, and for each of the
  --different unit tests you set the name then do some asserts.  This section
  --contains diliberate failures.
  -----------------------------------------------------------------------------    
  dbms_output.put_line('--- 3 of the next 8 tests should fail. ---');
  xut.init_test('test of test');
  xut.set_unit('TEST assert');
  xut.assert(true <> false, 'True should not equal false');
  xut.assert(false = false, 'False should equal false');
  xut.assert(true = true, 'True should equal true');
  xut.assert(true = false, 'Test for output, should fail.');
  
  xut.set_unit('TEST assert_eq numbers');
  xut.assert_eq(1, 1, 'These numbers are equal!');
  xut.assert_eq(1, 2, 'These numbers are not equal and should fail.');

  xut.set_unit('TEST assert_eq letters');
  xut.assert_eq('helloworld', 'helloworld', 'These letters are equal.');
  xut.assert_eq('asdf', 'qwert', 'These are not equal and should fail.');
  
  xut.end_test;

  dbms_output.put_line('');  dbms_output.put_line('');
  
  -----------------------------------------------------------------------------
  --Demo starting another set of tests in the same session
  -----------------------------------------------------------------------------
  dbms_output.put_line('--- All of the next tests should pass ---');  
  xut.init_test('another test that does not fail');
  xut.set_unit('these should all pass');
  xut.assert(true = true, 'true should equal true');  
  xut.assert('asdf' = 'asdf', 'asdf should equal asdf');
  xut.assert_eq('helloworld', 'helloworld', 'These letters are equal.');  
  xut.end_test;
end;

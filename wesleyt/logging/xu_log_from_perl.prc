create or replace procedure xu_log_from_perl is
  procedure xu_log_helloworld
  is
  begin
    xu_log.print('hello world');
    xu_log.error('hello world');  
  end;
  
  procedure xu_log_foobar
  is
  begin
    xu_log.debug('foobar');
    xu_log.warning('foobar');
  end;
begin
  xu_log_helloworld;
  xu_log_foobar;
end xu_log_from_perl;
/

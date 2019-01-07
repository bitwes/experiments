set serveroutput on;
WHENEVER SQLERROR EXIT FAILURE

select 'it ran' as words from dual;
select 'it sure did' as words from dual;

declare
begin
	dbms_output.put_line('Printing some numbers:');
	for i in 1..10 loop
		dbms_output.put_line('i = '||i);
	end loop;
end;
/

exit;
/
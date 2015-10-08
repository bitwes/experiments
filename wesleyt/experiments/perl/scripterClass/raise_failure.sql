--The error must be raised for perl to catch it
--Perl will return a 0 to $? if this is not set.
--If it is set, it will return 256 in the case
--of an error.
WHENEVER SQLERROR EXIT FAILURE

declare
begin
	raise_application_error(-20001, 'This is a custom error');
end;
/
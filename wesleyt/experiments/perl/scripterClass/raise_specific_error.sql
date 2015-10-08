--This script demonstrates passing a value from Perl into a script
--as well as using EXIT to dictate the value that will show up in $?
--when an error occurs.
WHENEVER SQLERROR EXIT &1
PROMPT ERROR NUMBER = &1

declare
	l_holder	number;
begin
	--this will cause no data found.
	select spriden_pidm into l_holder from spriden where spriden_pidm = -2978654;
end;
/
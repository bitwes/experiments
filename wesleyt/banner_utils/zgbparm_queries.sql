--Gets all the distinct parameters and their current value (if they have one)
select distinct vars.zgbparm_module     module,
                vars.zgbparm_process    process,
                vars.zgbparm_parm_name  parm_name,
                vals.zgbparm_parm_value value,
                vals.zgbparm_from_date  from_date,
                vals.zgbparm_to_date    to_date
  from zgbparm vars
  left outer join zgbparm vals
    on vals.zgbparm_module = vars.zgbparm_module
   and vals.zgbparm_process = vars.zgbparm_process
   and vals.zgbparm_parm_name = vars.zgbparm_parm_name
   and sysdate between vals.zgbparm_from_date and vals.zgbparm_to_date
 order  by lower(module), lower(process), lower(parm_name) ;

select *
  from (select distinct vars.zgbparm_process    process,
                        vars.zgbparm_module     module,
                        vars.zgbparm_parm_name  parm_name,
                        vals.zgbparm_parm_value value,
                        vals.zgbparm_from_date  from_date,
                        vals.zgbparm_to_date    to_date
          from zgbparm vars
          left outer join zgbparm vals
            on vals.zgbparm_module = vars.zgbparm_module
           and vals.zgbparm_process = vars.zgbparm_process
           and vals.zgbparm_parm_name = vars.zgbparm_parm_name
           and sysdate between vals.zgbparm_from_date and vals.zgbparm_to_date
         order by lower(process), lower(module), lower(parm_name))
 where module = 'housing';

select * from zgbparm where zgbparm_process = 'ZGVCDAC' order by lower(zgbparm_parm_name), zgbparm_from_date;

select sysdate from dual;

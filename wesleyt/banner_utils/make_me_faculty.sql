insert into sibinst(sibinst_pidm, sibinst_term_code_eff, sibinst_fcst_code,
                    sibinst_fcst_date, sibinst_activity_date, sibinst_override_process_ind)
values (<YOUR PIDM HERE>, '201401', 'A',
        to_date('01/19/2005', 'mm/dd/yyyy'), sysdate, 'N');

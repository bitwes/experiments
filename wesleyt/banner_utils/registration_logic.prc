--From bwckcoms.P_Regs.  Trying to tear out the registration logic
create or replace PROCEDURE dumb_p_regs(in_pidm in number,
                                        in_term IN varchar2, 
                                        in_rsts IN varchar2,
                                        in_assoc_term IN varchar2, 
                                        in_crn in varchar2,
                                        in_start_date IN varchar2, 
                                        in_end_date IN varchar2,
                                        in_subj IN varchar2, 
                                        in_crse IN varchar2,
                                        in_sec IN varchar2)
is                                        
    --------------------------
    --Variables I made
    --------------------------    
    --Some methods called by this require an array of terms.  This method is being
    --altered to only work for a single term, but until I can determine if the calls
    --to the methods requireing an array can be removed, this is used to pass the
    --single term off to them.
    l_single_term_array       OWA_UTIL.ident_arr;
    l_single_crn_array        OWA_UTIL.ident_arr;
    
    C_DUMMY                 constant varchar2(100) := 'dummy';
    
    --------------------------
    --GLOBALS that were declared in the package and used in this method
    --------------------------    
    curr_release CONSTANT VARCHAR2(10) := '8.5.3';
    sftregs_rec sftregs%ROWTYPE;
    sfrbtch_row sfrbtch%ROWTYPE;
    tbrcbrq_row tbrcbrq%ROWTYPE;
    lcur_tab    sokccur.curriculum_savedtab;

    --------------------------
    --Variables that WERE declared.
    --------------------------    
    err_term              OWA_UTIL.ident_arr;
    err_crn               OWA_UTIL.ident_arr;
    err_subj              OWA_UTIL.ident_arr;
    err_crse              OWA_UTIL.ident_arr;
    err_sec               OWA_UTIL.ident_arr;
    err_code              OWA_UTIL.ident_arr;
    err_levl              OWA_UTIL.ident_arr;
    err_cred              OWA_UTIL.ident_arr;
    err_gmod              OWA_UTIL.ident_arr;
    clas_code             SGRCLSR.SGRCLSR_CLAS_CODE%TYPE;
    stufac_ind            VARCHAR2(1);
    multi_term            BOOLEAN := false;
    olr_course_selected   BOOLEAN := FALSE;
    capp_tech_error       VARCHAR2(4);
    minh_admin_error      VARCHAR2(1);
    etrm_done             BOOLEAN := FALSE;
    drop_problems         sfkcurs.drop_problems_rec_tabtype;
    drop_failures         sfkcurs.drop_problems_rec_tabtype;
    local_capp_tech_error VARCHAR2(30);
    called_by_proc_name   VARCHAR2(100);


    ---------------------------------------------------------------------------------------
    --term_code     crse        message     dunt_code                               
    --pidm          sec         start_date  drop_code                         
    --crn           ptrm_code   comp_date   connected_crns                   
    --subj          rmsg_cde    rsts_date                     
    ---------------------------------------------------------------------------------------    
    function format_error_msg(in_problems_rec in sfkcurs.drop_problems_rec_tabtype)
    return varchar2
    is
        l_return    varchar2(2000);
    begin
        for i in 1..in_problems_rec.count loop
            l_return := l_return || in_problems_rec(i).message || 
                                    in_problems_rec(i).rmsg_cde || 
                                    in_problems_rec(i).connected_crns || 
                                    in_problems_rec(i).term_code || 
                                    in_problems_rec(i).pidm || 
                                    in_problems_rec(i).subj || 
                                    in_problems_rec(i).rsts_date || chr(13);
        end loop;
        
        return l_return;
    end;

    ---------------------------------------------------------------------------------------    
    ---------------------------------------------------------------------------------------        
    procedure log(in_text in varchar2)
    is
    begin
        dbms_output.put_line(in_text);
    end;
    
    function bool_to_varchar(in_boolean in boolean)return varchar2
    is
    begin
        if(in_boolean)then
            return 'Y';
        else
            return 'N';
        end if;
    end;
    
begin
    err_term(1) := C_DUMMY;
    err_crn(1) := C_DUMMY;
    err_code(1) := C_DUMMY;
    err_subj(1) := C_DUMMY;
    err_crse(1) := C_DUMMY;
    err_sec(1) := C_DUMMY;
    err_levl(1) := C_DUMMY;
    err_cred(1) := C_DUMMY;
    err_gmod(1) := C_DUMMY;


    l_single_term_array(1) := in_term;
    l_single_crn_array(1) := in_crn;
/*    
    IF NVL(twbkwbis.f_getparam(in_pidm, 'STUFAC_IND'), 'STU') = 'FAC' THEN
        stufac_ind          := 'F';
        called_by_proc_name := 'bwlkfrad.P_FacAddDropCrse';    
    ELSE
        stufac_ind          := 'S';
        called_by_proc_name := 'bwskfreg.P_AddDropCrse';
    END IF;

    IF NOT bwckcoms.f_reg_access_still_good(in_pidm, in_term, stufac_ind || in_pidm, called_by_proc_name) THEN
        raise_application_error(-20001, 'access is not good still .');
    END IF;    
*/
    -- Setup globals.
    -- ===================================================
    bwcklibs.p_initvalue(in_pidm, in_term, '', SYSDATE, '', '');

    --
    -- Check if student is allowed to register - single term
    -- only, as multi term is handled in the search results
    -- page.
    -- ===================================================
    IF NOT multi_term THEN
        IF NOT bwcksams.f_regsstu(in_pidm, in_term, called_by_proc_name) THEN
            raise_application_error(-20001, 'regsstu for a single term did not pass the check.');
        END IF;
    END IF;

    --
    -- Check whether OLR courses have been chosen, and if so,
    -- confirm their start/end dates
    -- ======================================================


    IF olr_course_selected THEN
        /* TODO, make sure this DISP method doesn't do other shit.
        bwckcoms.p_disp_start_date_confirm(single_term_array,
                                           rsts_in,
                                           assoc_term_in,
                                           single_crn_array,
                                           start_date_in,
                                           end_date_in,
                                           subj,
                                           crse,
                                           sec,
                                           levl,
                                           cred,
                                           gmod,
                                           title,
                                           mesg,
                                           reg_btn,
                                           regs_row,
                                           add_row,
                                           wait_row,
                                           NULL,
                                           NULL);
        */                                           
        raise_application_error(-20001, 'olr course was selected, so we quit or something.');
    END IF;

    --
    -- Check for admin errors that may have been introduced
    -- during this add/drop session.
    -- ====================================================

    
    /* Reset any linked courses that should be dropped. */
    /* This is so that they will be re-flagged as requiring drop confirmation. */
    /* This handles the scenario where a user presses the back button from */
    /* the drop confirmation page. */
    UPDATE sftregs a
       SET a.sftregs_error_flag     = a.sftregs_hold_error_flag,
           a.sftregs_rmsg_cde       = a.sftregs_hold_rmsg_cde,
           a.sftregs_message        = a.sftregs_hold_message,
           a.sftregs_rsts_code      = a.sftregs_hold_rsts_code,
           a.sftregs_rsts_date      = a.sftregs_hold_rsts_date,
           a.sftregs_vr_status_type = a.sftregs_hold_rsts_type,
           a.sftregs_grde_code      = a.sftregs_hold_grde_code,
           a.sftregs_user           = goksels.f_get_ssb_id_context,
           a.sftregs_activity_date  = SYSDATE
     WHERE a.sftregs_term_code = in_term
       AND a.sftregs_pidm = in_pidm
       AND a.sftregs_error_link IS NOT NULL
       AND a.sftregs_error_link = (SELECT b.sftregs_error_link
                                     FROM sftregs b
                                    WHERE b.sftregs_term_code = a.sftregs_term_code
                                      AND b.sftregs_pidm = a.sftregs_pidm
                                      AND b.sftregs_crn <> a.sftregs_crn
                                      AND b.sftregs_error_flag = 'F'
                                      AND ROWNUM = 1);
    
    UPDATE sftregs
       SET sftregs_error_flag     = sftregs_hold_error_flag,
           sftregs_rmsg_cde       = sftregs_hold_rmsg_cde,
           sftregs_message        = sftregs_hold_message,
           sftregs_rsts_code      = sftregs_hold_rsts_code,
           sftregs_rsts_date      = sftregs_hold_rsts_date,
           sftregs_vr_status_type = sftregs_hold_rsts_type,
           sftregs_grde_code      = sftregs_hold_grde_code,
           sftregs_user           = goksels.f_get_ssb_id_context,
           sftregs_activity_date  = SYSDATE
     WHERE sftregs_term_code = in_term
       AND sftregs_pidm = in_pidm
       AND sftregs_error_flag = 'F';
    
    sfkmods.p_admin_msgs(in_pidm, in_term, stufac_ind || in_pidm);
    
    minh_admin_error := sfkfunc.f_get_minh_admin_error(in_pidm, in_term);
    IF minh_admin_error = 'Y' THEN
--            bwckfrmt.p_open_doc(called_by_proc_name, term, NULL, multi_term, term_in(1));
--            twbkwbis.p_dispinfo(called_by_proc_name, 'SEE_ADMIN');
--            twbkwbis.p_closedoc(curr_release);
        raise_application_error(-20001, 'minh_admin_error.');
    END IF;
    
    local_capp_tech_error := sfkfunc.f_get_capp_tech_error(in_pidm, in_term);
    IF local_capp_tech_error IS NOT NULL THEN
        bwckcoms.p_adddrop2(l_single_term_array,
                            err_term,
                            err_crn,
                            err_subj,
                            err_crse,
                            err_sec,
                            err_code,
                            err_levl,
                            err_cred,
                            err_gmod,
                            local_capp_tech_error,
                            NULL,
                            drop_problems,
                            drop_failures);
        raise_application_error(-20001, 'local capp_tech error was not null');
    END IF;
    
    IF NOT bwckregs.f_finalize_admindrops(in_pidm, in_term, stufac_ind || in_pidm) THEN
        bwckfrmt.p_open_doc(called_by_proc_name, in_term, NULL, multi_term, in_term);
        twbkwbis.p_dispinfo(called_by_proc_name, 'SESSIONBLOCKED');
        twbkwbis.p_closedoc(curr_release);
        raise_application_error(-20001, 'bwckregs.finalize_admindrops did not pass check');
    END IF;
    
    --
    -- Loop through the registration records on the page.
    -- ===================================================
    BEGIN
        IF LTRIM(RTRIM(in_rsts)) IS NOT NULL THEN
            sftregs_rec.sftregs_crn       := in_crn;
            sftregs_rec.sftregs_pidm      := in_pidm;
            sftregs_rec.sftregs_term_code := in_assoc_term;
            sftregs_rec.sftregs_rsts_code := in_rsts;
            
            BEGIN
                IF multi_term THEN
                    --
                    -- Get the latest student and registration records.
                    -- ===================================================
                    bwckcoms.p_regs_etrm_chk(in_pidm, in_assoc_term, clas_code, multi_term);
                ELSIF NOT etrm_done THEN
                    bwckcoms.p_regs_etrm_chk(in_pidm, in_term, clas_code);
                    etrm_done := TRUE;
                END IF;
                
                --
                -- Get the section information.
                -- ===================================================
                bwckregs.p_getsection(sftregs_rec.sftregs_term_code,
                                      sftregs_rec.sftregs_crn,
                                      sftregs_rec.sftregs_sect_subj_code,
                                      sftregs_rec.sftregs_sect_crse_numb,
                                      sftregs_rec.sftregs_sect_seq_numb);
                
                --
                -- If the action corresponds to gtvsdax web drop code,
                -- then call the procedure to drop a course.
                -- ===================================================
                IF in_rsts = SUBSTR(f_stu_getwebregsrsts('D'), 1, 2) THEN
                    bwckregs.p_dropcrse(sftregs_rec.sftregs_term_code,
                                        sftregs_rec.sftregs_crn,
                                        sftregs_rec.sftregs_rsts_code,
                                        sftregs_rec.sftregs_reserved_key,
                                        rec_stat                         => 'D',
                                        del_ind                          => 'Y');
                    --
                    -- If the second character of the action is not D, then
                    -- call the procedure to update a course.
                    -- ===================================================
                ELSE
                    bwckregs.p_updcrse(sftregs_rec);
                END IF;
                
                --
                -- Create a batch fee assessment record.
                -- ===================================================
                sfrbtch_row.sfrbtch_term_code     := in_assoc_term;
                sfrbtch_row.sfrbtch_pidm          := in_pidm;
                sfrbtch_row.sfrbtch_clas_code     := clas_code;
                sfrbtch_row.sfrbtch_activity_date := SYSDATE;
                bwcklibs.p_add_sfrbtch(sfrbtch_row);
                tbrcbrq_row.tbrcbrq_term_code     := in_assoc_term;
                tbrcbrq_row.tbrcbrq_pidm          := in_pidm;
                tbrcbrq_row.tbrcbrq_activity_date := SYSDATE;
                bwcklibs.p_add_tbrcbrq(tbrcbrq_row);
            EXCEPTION
                WHEN OTHERS THEN
                    err_term(1) := in_assoc_term;
                    err_crn(1) := in_crn;
                    err_subj(1) := sftregs_rec.sftregs_sect_subj_code;
                    err_crse(1) := sftregs_rec.sftregs_sect_crse_numb;
                    err_sec(1) := sftregs_rec.sftregs_sect_seq_numb;
                    err_code(1) := SQLCODE;
                    err_levl(1) := lcur_tab(1).r_levl_code;
                    err_cred(1) := TO_CHAR(sftregs_rec.sftregs_credit_hr);
                    err_gmod(1) := sftregs_rec.sftregs_gmod_code;

                    IF SQLCODE = gb_event.APP_ERROR THEN
                        twbkfrmt.p_storeapimessages(SQLERRM);
                        RAISE;
                    END IF;
            END;
        END IF;        
    EXCEPTION
        WHEN OTHERS THEN
            IF SQLCODE = gb_event.APP_ERROR THEN
                twbkfrmt.p_storeapimessages(SQLERRM);
                RAISE;
            END IF;
    END;


    BEGIN
        IF in_crn IS NOT NULL AND LTRIM(RTRIM(in_rsts)) IS NOT NULL THEN
            sftregs_rec.sftregs_crn       := in_crn;
            sftregs_rec.sftregs_rsts_code := in_rsts;
            sftregs_rec.sftregs_rsts_date := SYSDATE;
            sftregs_rec.sftregs_pidm      := in_pidm;
            sftregs_rec.sftregs_term_code := in_assoc_term;
            
            BEGIN
                IF multi_term THEN
                    --
                    -- Get the latest student and registration records.
                    -- ===================================================
                    bwckcoms.p_regs_etrm_chk(in_pidm, in_assoc_term, clas_code, multi_term);
                ELSIF NOT etrm_done THEN
                    bwckcoms.p_regs_etrm_chk(in_pidm, in_term, clas_code);
                    etrm_done := TRUE;
                END IF;
                -- Do check for study path status also. Create sfrensp if it doesnt exist for the studypath
                IF bwckcoms.F_StudyPathEnabled = 'Y' THEN
                    IF NOT multi_term THEN
                        
                        bwckcoms.p_regs_ensp_chk(in_pidm,
                                                 SUBSTR(twbkwbis.f_getparam(in_pidm, 'G_SPATH'),
                                                        1,
                                                        INSTR(twbkwbis.f_getparam(in_pidm, 'G_SPATH'), '|') - 1),
                                                 twbkwbis.f_getparam(in_pidm, 'TERM'));
                    ELSE
                        IF twbkwbis.f_getparam(in_pidm, 'G_SP' || in_assoc_term) <> 'NULL' THEN
                            bwckcoms.p_regs_ensp_chk(in_pidm,
                                                     twbkwbis.f_getparam(in_pidm, 'G_SP' || in_assoc_term),
                                                     in_assoc_term);
                        END IF;
                    END IF;
                    
                END IF;
                
                --
                --
                -- Get the section information.
                -- ===================================================
                bwckregs.p_getsection(sftregs_rec.sftregs_term_code,
                                      sftregs_rec.sftregs_crn,
                                      sftregs_rec.sftregs_sect_subj_code,
                                      sftregs_rec.sftregs_sect_crse_numb,
                                      sftregs_rec.sftregs_sect_seq_numb);
                --
                -- Get the studyPath information
                --====================================================
                IF bwckcoms.F_StudyPathEnabled = 'Y' THEN
                    IF NOT multi_term THEN
                        sftregs_rec.sftregs_stsp_key_sequence := SUBSTR(twbkwbis.f_getparam(in_pidm, 'G_SPATH'),
                                                                        1,
                                                                        INSTR(twbkwbis.f_getparam(in_pidm,
                                                                                                  'G_SPATH'),
                                                                              '|') - 1);
                    ELSE
                        IF twbkwbis.f_getparam(in_pidm, 'G_SP' || in_assoc_term) <> 'NULL' THEN
                            sftregs_rec.sftregs_stsp_key_sequence := twbkwbis.f_getparam(in_pidm,
                                                                                         'G_SP' || in_assoc_term);
                        ELSE
                            sftregs_rec.sftregs_stsp_key_sequence := NULL;
                        END IF;
                    END IF;
                END IF;
                
                -- Call the procedure to add a course.
                -- ===================================================
                bwckregs.p_addcrse(sftregs_rec,
                                   sftregs_rec.sftregs_sect_subj_code,
                                   sftregs_rec.sftregs_sect_crse_numb,
                                   sftregs_rec.sftregs_sect_seq_numb,
                                   in_start_date,
                                   in_end_date);
                --
                -- Create a batch fee assessment record.
                -- ===================================================
                sfrbtch_row.sfrbtch_term_code     := in_assoc_term;
                sfrbtch_row.sfrbtch_pidm          := in_pidm;
                sfrbtch_row.sfrbtch_clas_code     := clas_code;
                sfrbtch_row.sfrbtch_activity_date := SYSDATE;
                bwcklibs.p_add_sfrbtch(sfrbtch_row);
                tbrcbrq_row.tbrcbrq_term_code     := in_assoc_term;
                tbrcbrq_row.tbrcbrq_pidm          := in_pidm;
                tbrcbrq_row.tbrcbrq_activity_date := SYSDATE;
                bwcklibs.p_add_tbrcbrq(tbrcbrq_row);
            EXCEPTION
                WHEN OTHERS THEN

                    err_term(1) := in_assoc_term;
                    err_crn(1) := in_crn;
                    err_subj(1) := sftregs_rec.sftregs_sect_subj_code;
                    err_crse(1) := sftregs_rec.sftregs_sect_crse_numb;
                    err_sec(1) := sftregs_rec.sftregs_sect_seq_numb;
                    err_code(1) := SQLCODE;
                    err_levl(1) := lcur_tab(1).r_levl_code;
                    err_cred(1) := TO_CHAR(sftregs_rec.sftregs_credit_hr);
                    err_gmod(1) := sftregs_rec.sftregs_gmod_code;

                    IF SQLCODE = gb_event.APP_ERROR THEN
                        twbkfrmt.p_storeapimessages(SQLERRM);
                        RAISE;
                    END IF;                    
            END;
        ELSE
            BEGIN
                --
                -- ?????
                -- ===================================================
                IF in_subj IS NOT NULL AND in_crse IS NOT NULL AND in_sec IS NOT NULL AND
                   LTRIM(RTRIM(in_rsts)) IS NOT NULL THEN
                    BEGIN
                        sftregs_rec.sftregs_rsts_code := in_rsts;
                        sftregs_rec.sftregs_rsts_date := SYSDATE;
                        sftregs_rec.sftregs_pidm      := in_pidm;
                        sftregs_rec.sftregs_term_code := in_assoc_term;
                        
                        IF multi_term THEN
                            --
                            -- Get the latest student and registration records.
                            -- ===================================================
                            bwckcoms.p_regs_etrm_chk(in_pidm, in_assoc_term, clas_code, multi_term);
                        ELSIF NOT etrm_done THEN
                            bwckcoms.p_regs_etrm_chk(in_pidm, in_term, clas_code);
                            etrm_done := TRUE;
                        END IF;
                        
                        bwckregs.p_addcrse(sftregs_rec, in_subj, in_crse, in_sec, in_start_date, in_end_date);
                    EXCEPTION
                        WHEN OTHERS THEN
                            err_term(1) := in_assoc_term;
                            err_crn(1) := in_crn;
                            err_subj(1) := in_subj;
                            err_crse(1) := in_crse;
                            err_sec(1) := in_sec;
                            err_code(1) := SQLCODE;
                            err_levl(1) := lcur_tab(1).r_levl_code;
                            err_cred(1) := TO_CHAR(sftregs_rec.sftregs_credit_hr);
                            err_gmod(1) := sftregs_rec.sftregs_gmod_code;
                            
                            IF SQLCODE = gb_event.APP_ERROR THEN
                                twbkfrmt.p_storeapimessages(SQLERRM);
                                RAISE;
                            END IF;

                    END;
                END IF;
            EXCEPTION
                WHEN OTHERS THEN
                    IF SQLCODE = gb_event.APP_ERROR THEN
                        twbkfrmt.p_storeapimessages(SQLERRM);
                        RAISE;
                    END IF;
            END;
        END IF;
        
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            BEGIN
                IF in_subj IS NOT NULL AND in_crse IS NOT NULL AND in_sec IS NOT NULL THEN
                    BEGIN
                        sftregs_rec.sftregs_rsts_code := in_rsts;
                        sftregs_rec.sftregs_rsts_date := SYSDATE;
                        sftregs_rec.sftregs_pidm      := in_pidm;
                        sftregs_rec.sftregs_term_code := in_assoc_term;
                        
                        IF multi_term THEN
                            --
                            -- Get the latest student and registration records.
                            -- ===================================================
                            bwckcoms.p_regs_etrm_chk(in_pidm, in_assoc_term, clas_code, multi_term);
                        ELSIF NOT etrm_done THEN
                            bwckcoms.p_regs_etrm_chk(in_pidm, in_term, clas_code);
                            etrm_done := TRUE;
                        END IF;
                        
                        bwckregs.p_addcrse(sftregs_rec, in_subj, in_crse, in_sec, in_start_date, in_end_date);
                    EXCEPTION
                        WHEN OTHERS THEN
                            err_term(1) := in_assoc_term;
                            err_crn(1) := in_crn;
                            err_subj(1) := in_subj;
                            err_crse(1) := in_crse;
                            err_sec(1) := in_sec;
                            err_code(1) := SQLCODE;
                            err_levl(1) := lcur_tab(1).r_levl_code;
                            err_cred(1) := TO_CHAR(sftregs_rec.sftregs_credit_hr);
                            err_gmod(1) := sftregs_rec.sftregs_gmod_code;

                            IF SQLCODE = gb_event.APP_ERROR THEN
                                twbkfrmt.p_storeapimessages(SQLERRM);
                                RAISE;
                            END IF;
                    END;
                END IF;
            EXCEPTION
                WHEN OTHERS THEN
                    IF SQLCODE = gb_event.APP_ERROR THEN
                        twbkfrmt.p_storeapimessages(SQLERRM);
                        RAISE;
                    END IF;
                    NULL;
            END;
            
    END;


    --
    -- Do batch validation on all registration records.
    -- ===================================================
    bwckcoms.p_group_edits(l_single_term_array, in_pidm, etrm_done, capp_tech_error, drop_problems, drop_failures);    
    log(bool_to_varchar(etrm_done)||' = eterm_doen');

    If capp_tech_error is null then
        bwckcoms.p_problems(l_single_term_array,
                            err_term,
                            err_crn,
                            err_subj,
                            err_crse,
                            err_sec,
                            err_code,
                            err_levl,
                            err_cred,
                            err_gmod,
                            drop_problems,
                            drop_failures);
        
        raise_application_error(-20001, 'capp tech error 2:  '||format_error_msg(drop_problems)||' ** '||format_error_msg(drop_failures));
    end if;

    --
    -- Redisplay the add/drop page (after a capp error)
    -- ===================================================
    bwckcoms.p_adddrop2(l_single_term_array,
                        err_term,
                        err_crn,
                        err_subj,
                        err_crse,
                        err_sec,
                        err_code,
                        err_levl,
                        err_cred,
                        err_gmod,
                        capp_tech_error,
                        NULL,
                        drop_problems,
                        drop_failures);


    if(err_term(1) <> C_DUMMY or 
       err_crn(1) <> C_DUMMY or 
       err_subj(1) <> C_DUMMY or 
       err_crse(1) <> C_DUMMY or 
       err_sec(1) <> C_DUMMY or 
       err_code(1) <> C_DUMMY or 
       err_levl(1) <> C_DUMMY or 
       err_cred(1) <> C_DUMMY or 
       err_gmod(1) <> C_DUMMY)
    then
        dbms_output.put_line('Error:  ');
        dbms_output.put_line('err_term(1)='||err_term(1));
        dbms_output.put_line('err_crn(1)='|| err_crn(1) );
        dbms_output.put_line('err_subj(1)='||err_subj(1));
        dbms_output.put_line('err_crse(1)='||err_crse(1));
        dbms_output.put_line('err_sec(1)='||err_sec(1) );
        dbms_output.put_line('err_code(1)='||err_code(1));
        dbms_output.put_line('err_levl(1)='||err_levl(1));
        dbms_output.put_line('err_cred(1)='||err_cred(1));
        dbms_output.put_line('err_gmod(1)='||err_gmod(1));
        raise_application_error(-20001, 'Something got put in the err arrays');
    end if;
    

EXCEPTION

    WHEN OTHERS THEN
        dbms_output.put_line('Error:  ');
        dbms_output.put_line('err_term(1)='||err_term(1));
        dbms_output.put_line('err_crn(1)='|| err_crn(1) );
        dbms_output.put_line('err_subj(1)='||err_subj(1));
        dbms_output.put_line('err_crse(1)='||err_crse(1));
        dbms_output.put_line('err_sec(1)='||err_sec(1) );
        dbms_output.put_line('err_code(1)='||err_code(1));
        dbms_output.put_line('err_levl(1)='||err_levl(1));
        dbms_output.put_line('err_cred(1)='||err_cred(1));
        dbms_output.put_line('err_gmod(1)='||err_gmod(1));
        raise;
/*

        IF NVL(twbkwbis.f_getparam(in_pidm, 'STUFAC_IND'), 'STU') = 'FAC' THEN            
            --FACWEB-specific code            
            IF NOT bwlkilib.f_add_drp(term) THEN
                NULL;
            END IF;
        
            bwckfrmt.p_open_doc(called_by_proc_name, term, NULL, multi_term, term_in(1));
        ELSE            
            --STUWEB-specific code            
            IF NOT bwskflib.f_validterm(term, stvterm_rec, sorrtrm_rec) THEN
                NULL;
            END IF;
        
            bwckfrmt.p_open_doc(called_by_proc_name, term, NULL, multi_term, term_in(1));
        END IF; 
*/
END dumb_p_regs;
/

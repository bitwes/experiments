-------------------------------------------------------------------------------
--08/05/2011    wesleyt       CR1423
--  Removed :SS from to_date of zgbparm values.  The value in the table did not 
--  have seconds in them. This caused the sections of the query that had these 
--  to_dates to fail.  I guess, because it was a union all, the entire query didn't 
--  fail, just those sections resulting in a lot of missing records.  The code was 
--  changed instead of the zgbparm value since it is likely that people will forget 
--  to put the seconds into the value and they serve no real purpose.
--11/29/2011    wesleyt       TD345
--  Reorganized most of query so that each new piece is less complicated and 
--  easier to maintain.
--  Added sections for Honor Students
--12/15/2011    wesleyt       TD345
--  Added section for Modern Langauge Students, Music, and Art students.  All
--  3 access levels are covered in the same section.
--01/18/2012    wesleyt       TD Issue 1294-2
--  Added Bishop Fenwick Place to the "Returning Residents" and "RA/SRA"
--  sections of the query.
--03/09/2012    wesleyt       Res Complex Name Change
--  Altered query to pull back the building for the student in a cleaner way.
--  Added condition to query so that BFP students would get the RES building
--  to address issues with offline door locks.  If we want the building to 
--  be the same, we have to rename in Persona which requires the Persona system
--  to be taken down.  We also have to time it correctly so that students are 
--  in BFP and this view is updated at the same time that Persona is updated.
--  This will be easier to do at a later time when all the students have been
--  migrated already and RMS and Banner are synced up.
--04/03/2012    wesleyt       TD656
--  Altered the RA section to add the bed-space back on for BFP RA rooms.
--04/03/2012    wesleyt       TD1215
--  Added the Psych_Graduate_Students, CompSci_Majr_Minor, Math_Majr_Minor
--  access levels as well as some minor comment and formatting changes elsewhere.
--05/07/2013    wesleyt       TD4004
--  Added Montessori access level.  This access level contains any student that
--  is taking a Montessori class (EDME).
-------------------------------------------------------------------------------
--  Special note about CompSci_Majr_Minor and Psych_Graduate_Students.  Both of 
--  these access levels are given to Summer students who qualified for them in
--  the Spring.  It has been discussed with the requestors and the following 
--  cases will be handled manually.
--      * Students who graduate in the spring will retain access over the summer.
--      * Students who drop their major over the summer will retain access 
--        if they were eligible during the spring.
-------------------------------------------------------------------------------

select to_char(sysdate, 'mm/dd/yy hh:mi:ss') time from dual;
select view_name||'->'||table_name from all_synonyms where synonym_name like ('PERSONA_ACCESS_VIE*');
-----------------------------------
--get the new name for the table and the name
--of the existing table.
-----------------------------------
col old_view_name for a30 new_value var_old_view;
col new_view_name for a30 new_value var_old_view;

select decode(table_name,
              'ZGVCDAC', 'ZGVCDAC_A',
              'ZGVCDAC_A', 'ZGVCDAC_B',
              'ZGVCDAC_B', 'ZGVCDAC_A') as new_view_name,
              table_name as old_view_name
  from all_synonyms 
 where synonym_name = 'PERSONA_ACCESS_VIEW';

-------------------------------------
--Move the _old synonym to the current table and drop
--the old table if this isn't the first run.
-------------------------------------
drop public synonym persona_access_view_old;
begin
    --on the very first time this is run the existing will be zgvcdac and there
    --will not be an old version. All later runs will need to kill the old one.
    if('&var_old_view' = 'ZGVCDAC')then
        execute immediate 'create public synonym persona_access_view_old for xupersona.zgvcdac';
    else
        execute immediate 'drop materialized view xupersona.&var_old_name';
        execute immediate 'create public synonym persona_access_view_old for xupersona.&var_new_view';
    end if;
end;
/
-----------------------------------
--Create the new view
-----------------------------------
CREATE MATERIALIZED VIEW xupersona.&var_new_view
  TABLESPACE USERS
  PCTUSED    0
  PCTFREE    10
  INITRANS   2
  MAXTRANS   255
  STORAGE    (
              INITIAL          64K
              MINEXTENTS       1
              MAXEXTENTS       UNLIMITED
              PCTINCREASE      0
              BUFFER_POOL      DEFAULT
             )
  NOCACHE 
  LOGGING
  NOCOMPRESS
  NOPARALLEL
  BUILD IMMEDIATE
  REFRESH FORCE
  START WITH TO_DATE('25-Feb-2011 14:39:01','dd-mon-yyyy hh24:mi:ss')
  NEXT SYSDATE + .1/24 
  WITH PRIMARY KEY
AS/*
  SELECT spriden_id || zsbidcd_issue_level zgvcdac_card_id,
         spriden_first_name zgvcdac_first_name,
         spriden_mi zgvcdac_mi,
         spriden_last_name zgvcdac_last_name,spriden_id zgvcdac_id,
         ' ' zgvcdac_access_level,
         spraddr_street_line1 zgvcdac_street,
         spraddr_city zgvcdac_city,
         spraddr_stat_code zgvcdac_state,
         spraddr_zip zgvcdac_zip, 
         home_phone zgvcdac_home_phone,
         cell_phone zgvcdac_cell_phone,
         spbpers_birth_date zgvcdac_dob,
         SUBSTR(spbpers_ssn, 6, 4) zgvcdac_national_id,
         begin_date zgvcdac_begin_date,
         end_date zgvcdac_end_date,
         stvbldg_desc zgvcdac_building,
         SUBSTR(ck_bed_space, 5, 10) zgvcdac_room,
         NVL(zgrcdpn_pin, '3274') zgvcdac_pin,
         NVL(spbpers_sex, ' ') zgvcdac_sex
    FROM zsbidcd
    JOIN (SELECT spriden_pidm,
                 spriden_id,
                 spriden_first_name,
                 spriden_mi,
                 spriden_last_name,
                 x.spraddr_pidm,
                 x.spraddr_street_line1,
                 x.spraddr_city,
                 x.spraddr_stat_code,
                 x.spraddr_zip,
                 y.sprtele_phone_area || '-' ||
                 substr(y.sprtele_phone_number, 1, 3) || '-' ||
                 substr(y.sprtele_phone_number, 4, 4) || ' ' ||
                 y.sprtele_phone_ext as home_phone,
                 z.sprtele_phone_area || '-' ||
                 substr(z.sprtele_phone_number, 1, 3) || '-' ||
                 substr(z.sprtele_phone_number, 4, 4) || ' ' ||
                 z.sprtele_phone_ext as cell_phone
            FROM spriden, spraddr x, sprtele y, sprtele z
           WHERE spriden_change_ind IS NULL
             AND x.ROWID(+) = xuprommgr.xf_address_rowid(spriden_pidm, 'HM')
             AND y.ROWID(+) = xuprommgr.xf_get_home_rowid(spriden_pidm)
             AND z.ROWID(+) = xuprommgr.xf_get_cell_rowid(spriden_pidm)) a
      ON (zsbidcd_pidm = a.spriden_pidm)
    LEFT JOIN (SELECT spbpers_pidm,
                      spbpers_birth_date,
                      spbpers_ssn,
                      spbpers_sex
                 FROM spbpers)
      ON (zsbidcd_pidm = spbpers_pidm)
    LEFT JOIN (SELECT zgrcdpn_pidm, zgrcdpn_pin
                 FROM xuprommgr.zgrcdpn
                WHERE zgrcdpn_from_date <= SYSDATE
                  AND zgrcdpn_to_date >= SYSDATE)
      ON (spriden_pidm = zgrcdpn_pidm)
    LEFT JOIN (SELECT PPLE.pk_rms_id,
                      PPLE.ix_student_number,
                      ROOM.ck_bed_space,
                      ROOM.ck_move_in_date,
                      ROOM.room_person_move_out_date,
                      ROOM.application_type,
                      PROF.ra_flag,
                      ROOM.fk_billing_type,
                      begin_date,
                      end_date
                 FROM pple_t_student_profile@rmsl PPLE
                 JOIN (SELECT ck_rms_id,
                             ck_bed_space,
                             application_type,
                             fk_billing_type,
                             ck_move_in_date,
                             room_person_move_out_date
                        FROM rmgt_t_room_person@rmsl
                        JOIN (SELECT pk_term_id,
                                    term_dates_start_date,
                                    term_dates_end_date
                               FROM rmgt_t_term_dates@rmsl) TERM
                          ON (fk_billing_type = pk_term_id)
                       WHERE (select xuprommgr.xf_am_i_evicted(ck_rms_id)
                                from dual) = 'N'
                         AND (SYSDATE <= term_dates_start_date)
                          OR (TERM.term_dates_start_date <= SYSDATE AND
                             SYSDATE <= TERM.term_dates_end_date AND
                             ck_move_in_date <= SYSDATE AND
                             SYSDATE <= room_person_move_out_date)
                          OR (SYSDATE >= term_dates_end_date)) ROOM
                   ON (PPLE.pk_rms_id = ROOM.ck_rms_id)
                 LEFT JOIN (SELECT pk_rms_id, 'Y' AS ra_flag
                             FROM pple_t_student_profile@rmsl
                            WHERE text4 IN ('RA', 'SRA')) PROF
                   ON (PPLE.pk_rms_id = PROF.pk_rms_id)
                RIGHT JOIN (SELECT zgbparm_parm_value
                             FROM xuprommgr.zgbparm
                            WHERE zgbparm_process = 'ZGVCDAC'
                              AND zgbparm_parm_name = 'Offline-Residents'
                              AND zgbparm_from_date <= SYSDATE
                              AND zgbparm_to_date >= SYSDATE) OFF
                   ON (ROOM.fk_billing_type = OFF.zgbparm_parm_value)
                 JOIN (SELECT zgbparm_from_date AS begin_date,
                             zgbparm_to_date,
                             zgbparm_process,
                             zgbparm_parm_name,
                             zgbparm_parm_value
                        FROM xuprommgr.zgbparm) DATS
                   ON (DATS.zgbparm_process = 'ZGVCDAC' AND
                      ROOM.fk_billing_type = DATS.zgbparm_parm_value AND
                      dats.zgbparm_parm_name =
                      DECODE(ra_flag,
                              'Y',
                              'RAs',
                              SUBSTR(application_type, 6, 9) || '-Residents'))
                 JOIN (SELECT zgbparm_from_date,
                             zgbparm_to_date,
                             zgbparm_process,
                             zgbparm_parm_name,
                             TO_DATE(zgbparm_parm_value, 'MM/DD/YYYY HH:MI PM') AS end_date
                        FROM xuprommgr.zgbparm) ENDD
                   ON (ENDD.zgbparm_process = 'ZGVCDAC' AND
                      ENDD.zgbparm_from_date <= SYSDATE AND
                      ENDD.zgbparm_to_date >= SYSDATE AND
                      ENDD.zgbparm_parm_name =
                      'Offline' || DECODE(ra_flag, 'Y', '-RA', NULL) ||
                      '-end-date'))
      ON (ix_student_number = spriden_id)
    --To avoid issues with door locks the building name for BFP is 
    --pulled back as the building name for RES.
    left outer join stvbldg 
      on stvbldg_code = decode (substr(ck_bed_space, 1, 3), 
                                        'BFP', 'RES', 
                                        substr(ck_bed_space, 1, 3))            
   WHERE zsbidcd_card_status = 'ACTIVE'
UNION ALL
---------------------------------------------------------------
-- Returning residents.
---------------------------------------------------------------
  SELECT spriden_id || zsbidcd_issue_level zgvcdac_card_id,
         spriden_first_name zgvcdac_first_name,
         spriden_mi zgvcdac_mi,
         spriden_last_name zgvcdac_last_name,
         spriden_id zgvcdac_id,
         DECODE(SUBSTR(ck_bed_space, 1, 3),
                'BUE',   'Buenger.Resident',
                'BRK',   'Brockman.Resident',
                'COM',   'Commons.Resident',
                'HUS',   'Husman.Resident',
                'KUH',   'Kuhlman.Resident',
                'VIL',   'Village.Resident',
                'UNI',   'UnivApts.Resident',
                'MAN',   'ManorHouse.Resident',
                'DAN',   '1019Dana.Resident',
                'RES',   'ResComplex.Resident',
                'BFP',   'FenwickPlace.Resident',
                ' ') zgvcdac_access_level,
         spraddr_street_line1 zgvcdac_street,
         spraddr_city zgvcdac_city,
         spraddr_stat_code zgvcdac_state,
         spraddr_zip zgvcdac_zip,
         home_phone zgvcdac_home_phone,
         cell_phone zgvcdac_cell_phone,
         spbpers_birth_date zgvcdac_dob,
         SUBSTR(spbpers_ssn, 6, 4) zgvcdac_national_id,
         DECODE(SIGN(term_dates_start_date - ck_move_in_date),
                0,                NVL(begin_date, ck_move_in_date),
                ck_move_in_date - 2.667) zgvcdac_begin_date,
         DECODE(SIGN(term_dates_end_date - room_person_move_out_date),
                0,                end_date,
                room_person_move_out_date + 3.5) zgvcdac_end_date,
         stvbldg_desc zgvcdac_building,
         SUBSTR(ck_bed_space, 5, 10) zgvcdac_room,
         NVL(zgrcdpn_pin, '3274') zgvcdac_pin,
         NVL(spbpers_sex, ' ') zgvcdac_sex
    FROM rmgt_t_room_person@rmsl ROOM
    JOIN (SELECT pk_rms_id, ix_student_number
            FROM pple_t_student_profile@rmsl) PROF
      ON (ROOM.ck_rms_id = PROF.pk_rms_id)
    JOIN (SELECT pk_rms_id, ix_national_id FROM pple_t_person@rmsl) PERS
      ON (ROOM.ck_rms_id = PERS.pk_rms_id)
    JOIN (SELECT spriden_pidm,
                 spriden_id,
                 spriden_first_name,
                 spriden_mi,
                 spriden_last_name,
                 x.spraddr_pidm,
                 x.spraddr_street_line1,
                 x.spraddr_city,
                 x.spraddr_stat_code,
                 x.spraddr_zip,
                 y.sprtele_phone_area || '-' ||
                  substr(y.sprtele_phone_number, 1, 3) || '-' ||
                  substr(y.sprtele_phone_number, 4, 4) || ' ' ||
                  y.sprtele_phone_ext as home_phone,
                 z.sprtele_phone_area || '-' ||
                  substr(z.sprtele_phone_number, 1, 3) || '-' ||
                  substr(z.sprtele_phone_number, 4, 4) || ' ' ||
                  z.sprtele_phone_ext as cell_phone
            FROM spriden, spraddr x, sprtele y, sprtele z
           WHERE spriden_change_ind IS NULL
             AND spriden_entity_ind = 'P'
             AND x.ROWID(+) = xuprommgr.xf_address_rowid(spriden_pidm, 'HM')
             AND y.ROWID(+) = xuprommgr.xf_get_home_rowid(spriden_pidm)
             AND z.ROWID(+) = xuprommgr.xf_get_cell_rowid(spriden_pidm)) IDEN
      ON (PROF.ix_student_number = IDEN.spriden_id)
    JOIN (SELECT zsbidcd_pidm, zsbidcd_card_status, zsbidcd_issue_level
            FROM zsbidcd
           WHERE zsbidcd_card_status = 'ACTIVE') IDCD
      ON (IDEN.spriden_pidm = IDCD.zsbidcd_pidm)
    JOIN (SELECT pk_term_id,
                 term_dates_start_date,
                 term_dates_end_date,
                 DECODE(SIGN(TRUNC((SYSDATE)) - TRUNC(term_dates_start_date)),
                        -1,      'Y',
                        0,       'Y',
                        'N') AS before_term_flag,
                 DECODE(DECODE(SIGN((TRUNC(SYSDATE)) - TRUNC(term_dates_start_date)),
                               1,       'Y',
                               0,       'Y',
                               'N') || 
                        DECODE(SIGN(TRUNC(term_dates_end_date) - (TRUNC(SYSDATE))),
                                1,      'Y',
                                0,      'Y',
                                'N'),
                        'YY', 'Y',
                        'N') within_term_flag,
                 DECODE(SIGN(TRUNC(term_dates_end_date) - TRUNC(SYSDATE)),
                        -1,      'Y',
                        0,       'Y',
                        'N') AS after_term_flag,
                 DECODE(SIGN((TRUNC(SYSDATE)) - TRUNC(term_dates_start_date)),
                        1,       'Y',
                        0,       'Y',
                        'N') AS after_begin_term_flag,
                 DECODE(SIGN(TRUNC(term_dates_end_date) - (TRUNC(SYSDATE))),
                        1,       'Y',
                        0,       'Y',
                        'N') AS before_end_term_flag
            FROM rmgt_t_term_dates@rmsl) TERM
      ON (ROOM.fk_term_id = TERM.pk_term_id)
    LEFT JOIN (SELECT spbpers_pidm,
                      spbpers_birth_date,
                      spbpers_ssn,
                      spbpers_sex
                 FROM spbpers) SPERS
      ON (IDEN.spriden_pidm = SPERS.spbpers_pidm)
    LEFT JOIN (SELECT zgrcdpn_pidm, zgrcdpn_pin
                 FROM xuprommgr.zgrcdpn
                WHERE zgrcdpn_from_date <= SYSDATE
                  AND zgrcdpn_to_date >= SYSDATE) CDPN
      ON (IDEN.spriden_pidm = CDPN.zgrcdpn_pidm)
    JOIN (SELECT zgbparm_parm_name,
                 TO_DATE(zgbparm_parm_value, 'MM/DD/YYYY HH:MI PM') AS end_date
            FROM xuprommgr.zgbparm
           WHERE zgbparm_process = 'ZGVCDAC'
             AND zgbparm_from_date <= SYSDATE
             AND zgbparm_to_date >= SYSDATE) ENDD
      ON (ENDD.zgbparm_parm_name = 'Offline-end-date')
    LEFT JOIN (SELECT 'Y' AS special_flag,
                      zgbparm_process,
                      zgbparm_parm_name,
                      zgbparm_parm_value,
                      zgbparm_from_date,
                      zgbparm_to_date
                 FROM xuprommgr.zgbparm
                WHERE zgbparm_process = 'ZGVCDAC'
                  AND zgbparm_from_date <= SYSDATE
                  AND zgbparm_to_date >= SYSDATE) SPEC
      ON (SPEC.zgbparm_parm_name LIKE
         SUBSTR(ck_bed_space, 1, 3) || '-SPECIAL' AND
         SPEC.zgbparm_parm_value = ROOM.fk_term_id AND
         ROOM.room_person_move_out_date = TERM.term_dates_end_date)
    LEFT JOIN (SELECT zgbparm_process,
                      zgbparm_parm_name,
                      zgbparm_parm_value,
                      zgbparm_from_date AS begin_date,
                      zgbparm_to_date
                 FROM xuprommgr.zgbparm) DATS
      ON (DATS.zgbparm_process = 'ZGVCDAC' AND
         DATS.zgbparm_parm_name =
         TRIM(SUBSTR(application_type, 6, 9)) || '-Residents' AND
         DATS.zgbparm_parm_value = ROOM.fk_billing_type AND
         DATS.begin_date <= SYSDATE AND DATS.zgbparm_to_date >= SYSDATE)
    --To avoid issues with door locks the building name for BFP is 
    --pulled back as the building name for RES.
    left outer join stvbldg 
      on stvbldg_code = decode (substr(ck_bed_space, 1, 3), 
                                        'BFP', 'RES', 
                                        substr(ck_bed_space, 1, 3))               
   WHERE (ROOM.ck_rms_id IN
         (SELECT pk_rms_id
             FROM pple_t_user_defined@rmsl
            WHERE (select xuprommgr.xf_am_i_evicted(ck_rms_id) from dual) = 'N'))
     AND (ck_bed_space LIKE 'BUE%' OR ck_bed_space LIKE 'BRK%' OR
          ck_bed_space LIKE 'COM%' OR ck_bed_space LIKE 'HUS%' OR
          ck_bed_space LIKE 'KUH%' OR ck_bed_space LIKE 'VIL%' OR
          ck_bed_space LIKE 'UNI%' OR ck_bed_space LIKE 'MAN%' OR
          ck_bed_space LIKE 'DAN%' OR ck_bed_space LIKE 'RES%' OR
          ck_bed_space LIKE 'BFP%')
     AND (
            (    before_term_flag = 'Y' AND DATS.begin_date <= SYSDATE 
             AND SYSDATE <= DATS.zgbparm_to_date) 
          OR(
                within_term_flag = 'Y' 
            AND(ROOM.ck_move_in_date - 2.667) <= SYSDATE
            AND SYSDATE <= (ROOM.room_person_move_out_date + 3.5)
          ) 
          OR(
            after_term_flag = 'Y' 
            AND(
                 (SPEC.special_flag = 'Y') 
              OR (    DATS.begin_date <= SYSDATE 
                  AND SYSDATE <= DATS.zgbparm_to_date)
            )
         )
    )
UNION ALL
---------------------------------------------------------------
--RA's/SRA's
---------------------------------------------------------------
  SELECT spriden_id || zsbidcd_issue_level zgvcdac_card_id,
         spriden_first_name zgvcdac_first_name,
         spriden_mi zgvcdac_mi,
         spriden_last_name zgvcdac_last_name,
         spriden_id zgvcdac_id,
         DECODE(SUBSTR(ck_bed_space, 1, 3),
                'BUE',              'Buenger.RA',
                'BRK',              'Brockman.RA',
                'COM',              'Commons.RA',
                'HUS',              'Husman.RA',
                'KUH',              'Kuhlman.RA',
                'VIL',              'Village.RA',
                'UNI',              'UnivApts.RA',
                'MAN',              'ManorHouse.RA',
                'DAN',              '1019Dana.RA',
                'RES',              'ResComplex.RA',
                'BFP',              'FenwickPlace.RA',
                ' ') zgvcdac_access_level,
         spraddr_street_line1 zgvcdac_street,
         spraddr_city zgvcdac_city,
         spraddr_stat_code zgvcdac_state,
         spraddr_zip zgvcdac_zip,
         home_phone zgvcdac_home_phone,
         cell_phone zgvcdac_cell_phone,
         spbpers_birth_date zgvcdac_dob,
         SUBSTR(spbpers_ssn, 6, 4) zgvcdac_national_id,
         DECODE(SIGN(term_dates_start_date - ck_move_in_date),
                0,              NVL(begin_date, ck_move_in_date),
                ck_move_in_date - 2.667) zgvcdac_begin_date,
         DECODE(SIGN(term_dates_end_date - room_person_move_out_date),
                0,              end_date,
                room_person_move_out_date + 3.5) zgvcdac_end_date,
         stvbldg_desc zgvcdac_building,         
         --The bedspace was stripped from the BFP rooms in RMS but were not removed
         --in Persona.  Changing the locks to not have the 'a' at the end is a much 
         --bigger deal than adding it back in here, so we just put it back.
         decode (substr(ck_bed_space, 1, 3), 
                  'BFP', SUBSTR(ck_bed_space, 5, 10) || 'a', 
                  SUBSTR(ck_bed_space, 5, 10)) zgvcdac_room,
         NVL(zgrcdpn_pin, '3274') zgvcdac_pin,
         NVL(spbpers_sex, ' ') zgvcdac_sex
    FROM rmgt_t_room_person@rmsl ROOM
   RIGHT JOIN (SELECT pk_rms_id, ix_student_number, 'Y' AS ra_flag
                 FROM pple_t_student_profile@rmsl
                WHERE text4 IN ('RA', 'SRA')) RA
      ON (ROOM.ck_rms_id = RA.pk_rms_id)
    JOIN (SELECT pk_rms_id, ix_national_id FROM pple_t_person@rmsl) PERS
      ON (ROOM.ck_rms_id = PERS.pk_rms_id)
    JOIN (SELECT spriden_pidm,
                 spriden_id,
                 spriden_first_name,
                 spriden_mi,
                 spriden_last_name,
                 x.spraddr_pidm,
                 x.spraddr_street_line1,
                 x.spraddr_city,
                 x.spraddr_stat_code,
                 x.spraddr_zip,
                 y.sprtele_phone_area || '-' ||
                 substr(y.sprtele_phone_number, 1, 3) || '-' ||
                 substr(y.sprtele_phone_number, 4, 4) || ' ' ||
                 y.sprtele_phone_ext as home_phone,
                 z.sprtele_phone_area || '-' ||
                 substr(z.sprtele_phone_number, 1, 3) || '-' ||
                 substr(z.sprtele_phone_number, 4, 4) || ' ' ||
                 z.sprtele_phone_ext as cell_phone
            FROM spriden, spraddr x, sprtele y, sprtele z
           WHERE spriden_change_ind IS NULL
             AND x.ROWID(+) = xuprommgr.xf_address_rowid(spriden_pidm, 'HM')
             AND y.ROWID(+) = xuprommgr.xf_get_home_rowid(spriden_pidm)
             AND z.ROWID(+) = xuprommgr.xf_get_cell_rowid(spriden_pidm)) IDEN
      ON (RA.ix_student_number = spriden_id)
    JOIN (SELECT zsbidcd_pidm, zsbidcd_card_status, zsbidcd_issue_level
            FROM zsbidcd
           WHERE zsbidcd_card_status = 'ACTIVE') IDCD
      ON (IDEN.spriden_pidm = IDCD.zsbidcd_pidm)
    JOIN (SELECT pk_term_id,
                 term_dates_start_date,
                 term_dates_end_date,
                 DECODE(SIGN(TRUNC((SYSDATE)) - TRUNC(term_dates_start_date)),
                        -1,      'Y',
                        0,       'Y',
                        'N') AS before_term_flag,
                 DECODE(DECODE(SIGN((TRUNC(SYSDATE)) -
                                    TRUNC(term_dates_start_date)),
                               1,          'Y',
                               0,          'Y',
                               'N') || 
                        DECODE(SIGN(TRUNC(term_dates_end_date) -
                                                   (TRUNC(SYSDATE))),
                              1,           'Y',
                              0,           'Y',
                              'N'),
                        'YY',     'Y',
                        'N') within_term_flag,
                 DECODE(SIGN(TRUNC(term_dates_end_date) - TRUNC(SYSDATE)),
                        -1,                'Y',
                        0,                 'Y',
                        'N') AS after_term_flag,
                 DECODE(SIGN((TRUNC(SYSDATE)) - TRUNC(term_dates_start_date)),
                        1,                 'Y',
                        0,                 'Y',
                        'N') AS after_begin_term_flag,
                 DECODE(SIGN(TRUNC(term_dates_end_date) - (TRUNC(SYSDATE))),
                        1,                 'Y',
                        0,    
               'Y',
                        'N') AS before_end_term_flag
            FROM rmgt_t_term_dates@rmsl) TERM
      ON (ROOM.fk_term_id = TERM.pk_term_id)
    LEFT JOIN (SELECT spbpers_pidm,
                      spbpers_birth_date,
                      spbpers_ssn,
                      spbpers_sex
                 FROM spbpers) SPERS
      ON (IDEN.spriden_pidm = SPERS.spbpers_pidm)
    LEFT JOIN (SELECT zgrcdpn_pidm, zgrcdpn_pin
                 FROM xuprommgr.zgrcdpn
                WHERE zgrcdpn_from_date <= SYSDATE
                  AND zgrcdpn_to_date >= SYSDATE) CDPN
      ON (IDEN.spriden_pidm = CDPN.zgrcdpn_pidm)
    JOIN (SELECT zgbparm_from_date,
                 zgbparm_to_date,
                 zgbparm_process,
                 zgbparm_parm_name,
                 TO_DATE(zgbparm_parm_value, 'MM/DD/YYYY HH:MI PM') AS end_date
            FROM xuprommgr.zgbparm) ENDD
      ON (ENDD.zgbparm_process = 'ZGVCDAC' AND
         ENDD.zgbparm_from_date <= SYSDATE AND
         ENDD.zgbparm_to_date >= SYSDATE AND
         ENDD.zgbparm_parm_name = 'Offline-RA-end-date')
    LEFT JOIN (SELECT zgbparm_process,
                      zgbparm_parm_name,
                      zgbparm_parm_value,
                      zgbparm_from_date AS begin_date,
                      zgbparm_to_date
                 FROM xuprommgr.zgbparm) DATS
      ON (DATS.zgbparm_process = 'ZGVCDAC' AND DATS.zgbparm_parm_name = 'RAs' AND
         DATS.zgbparm_parm_value = fk_billing_type AND
         DATS.begin_date <= SYSDATE AND DATS.zgbparm_to_date >= SYSDATE)
    --To avoid issues with door locks the building name for BFP is 
    --pulled back as the building name for RES.
    left outer join stvbldg 
      on stvbldg_code = decode (substr(ck_bed_space, 1, 3), 
                                        'BFP', 'RES', 
                                        substr(ck_bed_space, 1, 3))               
   WHERE (select xuprommgr.xf_am_i_evicted(ROOM.ck_rms_id) from dual) = 'N'
     AND (ck_bed_space LIKE 'BUE%' OR ck_bed_space LIKE 'BRK%' OR
          ck_bed_space LIKE 'COM%' OR ck_bed_space LIKE 'HUS%' OR
          ck_bed_space LIKE 'KUH%' OR ck_bed_space LIKE 'VIL%' OR
          ck_bed_space LIKE 'UNI%' OR ck_bed_space LIKE 'MAN%' OR
          ck_bed_space LIKE 'DAN%' OR ck_bed_space LIKE 'RES%' OR
          ck_bed_space LIKE 'BFP%')
     AND (  (    before_term_flag = 'Y' 
             AND DATS.begin_date <= SYSDATE 
             AND SYSDATE <= DATS.zgbparm_to_date
            ) 
         OR(     within_term_flag = 'Y' 
             AND (ROOM.ck_move_in_date - 2.667) <= SYSDATE 
             AND SYSDATE <= (ROOM.room_person_move_out_date + 3.5)) 
         OR (    after_term_flag = 'Y' 
             AND DATS.begin_date <= SYSDATE 
             AND SYSDATE <= DATS.zgbparm_to_date 
             AND ROOM.room_person_move_out_date = TERM.term_dates_end_date)
         )         
union all
-------------------------------------------------------------------------------
--  Select the pidms and other information that changes from access level to
--  access level in subqueries.  The results of these queries are joined with 
--  the other tables that contain the information that is common to all 
--  access levels.  
--
--  The "cast"s seen in the subqueries is how you select a NULL on a column 
--  that is unioned with other non null values.  You must cast the NULL to be
--  the same datatype as the other values.
------------------------------------------------------------------------------- 
*/
  SELECT spriden_id || nvl(zsbidcd_issue_level, '0')            zgvcdac_card_id,
         spriden_first_name                                     zgvcdac_first_name,
         spriden_mi                                             zgvcdac_mi,
         spriden_last_name                                      zgvcdac_last_name,
         spriden_id                                             zgvcdac_id,
         decode(access_level, 'NO_ALLCARD', ' ', access_level)  zgvcdac_access_level,
         spraddr_street_line1                                   zgvcdac_street,
         spraddr_city                                           zgvcdac_city,
         spraddr_stat_code                                      zgvcdac_state,
         spraddr_zip                                            zgvcdac_zip,         
         home_tele.sprtele_phone_area || '-' ||
           substr(home_tele.sprtele_phone_number, 1, 3) || '-' ||
           substr(home_tele.sprtele_phone_number, 4, 4) || ' ' ||
           home_tele.sprtele_phone_ext as                       zgvcdac_home_phone,         
         cell_tele.sprtele_phone_area || '-' ||
           substr(cell_tele.sprtele_phone_number, 1, 3) || '-' ||
           substr(cell_tele.sprtele_phone_number, 4, 4) || ' ' ||
           cell_tele.sprtele_phone_ext as                       zgvcdac_cell_phone,
         spbpers_birth_date                                     zgvcdac_dob,
         substr(spbpers_ssn, 6, 4)                              zgvcdac_national_id,
         begin_date                                             zgvcdac_begin_date,
         end_date                                               zgvcdac_end_date,
         building                                               zgvcdac_building,
         nvl(room, ' ')                                         zgvcdac_room,
         nvl(zgrcdpn_pin, '3274')                               zgvcdac_pin,
         nvl(spbpers_sex, ' ')                                  zgvcdac_sex
    from (
          ---------------------------------------------------------------
          -- These are all the deposited students who don't yet have an AllCard.  
          -- They are pre-loaded into Persona so that the Housing office
          -- can manually assign them dorm access before they get an AllCard.
          ---------------------------------------------------------------                
          select sarappd_pidm pidm,
                  'NO_ALLCARD' access_level,
                  cast (null as date) begin_date,
                  cast (null as date) end_date,
                  cast (null as varchar2(100)) building,
                  cast (null as varchar2(100)) room
            from sarappd
            LEFT JOIN(xuprommgr.zgrcdpn)
              ON (sarappd_pidm = zgrcdpn_pidm and
                 zgrcdpn_from_date <= SYSDATE AND zgrcdpn_to_date >= SYSDATE)
           WHERE sarappd_apdc_code IN
                 ('DA', 'DB', 'DC', 'DD', 'DE', 'DF', 'DH', 'DR', 'DT', 'DV')
             AND sarappd_pidm NOT IN (SELECT zsbidcd_pidm FROM zsbidcd)
             AND sarappd_term_code_entry IN
                 (SELECT zgbparm_parm_value
                    FROM xuprommgr.zgbparm
                   WHERE zgbparm_process = 'ZGVCDAC'
                     AND zgbparm_from_date <= SYSDATE
                     AND zgbparm_to_date >= SYSDATE
                     AND zgbparm_parm_name = 'Deposited-Students')
/*
          union all
          ---------------------------------------------------------------
          -- Investment Students (anyone taking the specified finance
          -- courses, not finance majors)
          ---------------------------------------------------------------          
          select sfrstcr_pidm pidm,
                 'Investment_Students' access_level,
                 stvterm_start_date - 7 as begin_date,
                 stvterm_end_date as end_date,
                 cast (null as varchar2(100)) building,
                 cast (null as varchar2(100)) room
            from sfrstcr
            join(stvterm)
              on (sfrstcr_term_code = stvterm_code and
                 stvterm_start_date <= sysdate + 7 and
                 stvterm_end_date >= sysdate)
            join(ssbsect)
              on (sfrstcr_crn = ssbsect_crn and
                 stvterm_code = ssbsect_term_code and
                 ssbsect_subj_code = 'FINC' and
                 ssbsect_crse_numb in ('490', '492', '664'))
            join(stvrsts)
              on (sfrstcr_rsts_code = stvrsts_code and
                 stvrsts_incl_sect_enrl = 'Y' and
                 stvrsts_withdraw_ind <> 'Y')
            join(zsbidcd)
              on (zsbidcd_pidm = sfrstcr_pidm and
                 zsbidcd_card_status = 'ACTIVE')
          UNION ALL
          ---------------------------------------------------------------
          -- All Registered Students
          ---------------------------------------------------------------          
          select distinct (sfrstcr.sfrstcr_pidm) pidm,
                          'Registered_Students' access_level,
                          stvterm_start_date - 7 as begin_date,
                          stvterm_end_date as end_date,
                          cast (null as varchar2(100)) building,
                          cast (null as varchar2(100)) room
            from sfrstcr
            join stvterm
              on sfrstcr_term_code = stvterm_code 
             and stvterm_start_date <= sysdate + 7 
             and stvterm_end_date >= sysdate
            join stvrsts
              on sfrstcr_rsts_code = stvrsts_code 
             and stvrsts_incl_sect_enrl = 'Y' 
             and stvrsts_withdraw_ind <> 'Y'
            join zsbidcd
              on zsbidcd_pidm = sfrstcr_pidm 
             and zsbidcd_card_status = 'ACTIVE'
          UNION ALL
          ---------------------------------------------------------------
          -- Current Faculty 
          ---------------------------------------------------------------          
          select distinct sirasgn_pidm pidm,
                          'Current_Faculty' access_level,
                          pebempl_first_hire_date begin_date,
                          cast (null as date) end_date,
                          cast (null as varchar2(100)) building,
                          cast (null as varchar2(100)) room
            from sirasgn
            join zsbidcd
              on zsbidcd_pidm = sirasgn_pidm 
             and zsbidcd_card_status = 'ACTIVE'
            join pebempl
              on pebempl_pidm = sirasgn_pidm 
             and pebempl_last_work_date is null 
             and pebempl_term_date is null
            join ssbsect
              on ssbsect_term_code = sirasgn_term_code 
             and ssbsect_crn = sirasgn_crn 
             and ssbsect_ssts_code <> 'C'
          union all
          ---------------------------------------------------------------
          -- Current Staff 1
          ---------------------------------------------------------------          
          select pebempl.pebempl_pidm pidm,
                 'Current_Staff' access_level,
                 pebempl_first_hire_date as begin_date,
                 cast (null as date) end_date,
                 cast (null as varchar2(100)) building,
                 cast (null as varchar2(100)) room
            from pebempl
            join zsbidcd
              on zsbidcd_pidm = pebempl_pidm 
             and zsbidcd_card_status = 'ACTIVE'
           where pebempl_last_work_date is null
             and pebempl_term_date is null
             and pebempl_ecls_code in
                 (20, 22, 23, 24, 25, 28, 30, 31, 32, 33, 36)
          union all
          ---------------------------------------------------------------
          -- Current Staff 2
          ---------------------------------------------------------------          
          select pebempl_pidm pidm,
                 'Management_Faculty' access_level,
                 pebempl_first_hire_date as begin_date,
                 cast (null as date) end_date,
                 cast (null as varchar2(100)) building,
                 cast (null as varchar2(100)) room
            from pebempl
            join zsbidcd
              on zsbidcd_pidm = pebempl_pidm 
             and zsbidcd_card_status = 'ACTIVE'
           where pebempl_orgn_code_dist in ('34502')
             and pebempl_last_work_date is null
             and pebempl_term_date is null
             and pebempl_ecls_code in ('01', '03', '04', '05', '07')
          union all
          ---------------------------------------------------------------
          -- Current Staff access level zInfo_Resources_Staff 
          ---------------------------------------------------------------          
          select pebempl_pidm,
                 'Info_Resources_Staff' access_level,
                 pebempl_first_hire_date begin_date,
                 cast (null as date) end_date,
                 cast (null as varchar2(100)) building,
                 cast (null as varchar2(100)) room
            from pebempl
            join zsbidcd
              on (zsbidcd_pidm = pebempl_pidm and
                 zsbidcd_card_status = 'ACTIVE')
           where pebempl_last_work_date is null
             and pebempl_term_date is null
             and pebempl_empl_status = 'A'
             and pebempl_dicd_code = '500'
             and pebempl_ecls_code not in
                 ('50', '51', '52', '53', '60', '61')
          union all 
          ---------------------------------------------------------------
          -- Honors Students
          -- Honor students will either have a specific student_attribute
          -- and/or a specific degree code.  Must select distinct
          -- students since they can show up in both lists.
          ---------------------------------------------------------------
          select distinct honor_info.pidm,
                          'Honors_Students' access_level,
                          honor_info.begin_date,
                          honor_info.end_date,
                          cast (null as varchar2(100)) building,
                          cast (null as varchar2(100)) room
            from (
                  --University Scholar students
                  select person_uid pidm,
                          stvterm_start_date - 7 as begin_date,
                          stvterm_end_date as end_date
                    from as_student_attribute
                    join(stvterm)
                      on (stvterm_start_date <= sysdate + 7 and
                         stvterm_end_date >= sysdate)
                    join(as_student_data)
                      on (pidm_key = person_uid and 
                          enrolled_ind = 'Y' and
                          graduated_ind = 'N' and
                         term_code_key = stvterm_code)
                   where student_attribute = 'USCH'
                     and academic_period_end >= stvterm.stvterm_code
                  --HAB students which includes PPPU and CLPL students
                  union all
                  select pidm_key pidm,
                         stvterm_start_date - 7 as begin_date,
                         stvterm_end_date as end_date
                    from as_student_data
                    join(stvterm)
                      on (stvterm_start_date <= sysdate + 7 and
                         stvterm_end_date >= sysdate)
                   where degc_code = 'HAB'
                     and enrolled_ind = 'Y'
                     and graduated_ind = 'N'
                     and term_code_key = stvterm.stvterm_code) honor_info
          union all
          ---------------------------------------------------------------
          --Modern Language, Art, Montessori, and Music Students
          --  This is anyone taking a course in any of these subjects.
          --  Because this section is pulling from all the courses in 
          --  progress we must do a distinct to prevent duplicates 
          --  within a given access level.
          ---------------------------------------------------------------          
          select distinct ascip.PERSON_UID pidm,
                 decode(ascip.subject,
                        'ARTS', 'Art_Students',
                        'MUSC', 'Music_Students',
                        'EDME', 'Montessori_Students',
                        'Modern_Language_Students') access_level,
                 stvterm_start_date - 7 as begin_date,
                 stvterm_end_date as end_date,
                 cast (null as varchar2(100)) building,
                 cast (null as varchar2(100)) room
            from as_student_course_in_progress ascip
            join stvterm
              on stvterm_start_date <= sysdate + 7 
             and stvterm_end_date >= sysdate
           where ascip.subject in 
                 ('ARTS', --art gallery disciplines
                  'MUSC', --music disciplines
                  'EDME', --Montissori  disciplines
                  'ARAB','ASLN','FREN','GERM','ITAL','JAPN','SPAN','ESLG') --Mod Lang disciplines
             --These are the registration statuses for someone that is registered
             --the other statuses are for non registered students.  RW = Web Registered,
             --AU = Audit, RE = Registered.
             and ascip.registration_status in ('RW', 'AU', 'RE')
             and ascip.academic_period = stvterm.stvterm_code
          union all
          ---------------------------------------------------------------
          --Math (and math related) majors and minors.
          ---------------------------------------------------------------
          select pidm, 
                 'Math_Majr_Minor' access_level,
                 stvterm_start_date - 7 as begin_date,
                 stvterm_end_date as end_date,
                 cast(null as varchar2(100)) building,
                 cast(null as varchar2(100)) room
            from xuprommgr.zs_enrollment_expanded
            join stvterm
              on stvterm_start_date <= sysdate + 7
             and stvterm_end_date >= sysdate
           where term = stvterm_code
             and LEVL_CODE_1 = 'U'
             and (--majors
                  MAJOR_CODE_1_1 in ('MATH', 'MACS') or MAJOR_CODE_1_2 in ('MATH', 'MACS') or MAJOR_CODE_1_3 in ('MATH', 'MACS') or
                  MAJOR_CODE_1_4 in ('MATH', 'MACS') or MAJOR_CODE_2_1 in ('MATH', 'MACS') or MAJOR_CODE_2_2 in ('MATH', 'MACS') or
                  MAJOR_CODE_2_3 in ('MATH', 'MACS') or MAJOR_CODE_2_4 in ('MATH', 'MACS') or  
                  --minors
                  MINOR_CODE_1_1 in ('MATH', 'STAT') or MINOR_CODE_1_2 in ('MATH', 'STAT') or MINOR_CODE_1_3 in ('MATH', 'STAT') or 
                  MINOR_CODE_1_4 in ('MATH', 'STAT') or MINOR_CODE_1_5 in ('MATH', 'STAT') or MINOR_CODE_2_1 in ('MATH', 'STAT') or 
                  MINOR_CODE_2_2 in ('MATH', 'STAT') or MINOR_CODE_2_3 in ('MATH', 'STAT') or MINOR_CODE_2_4 in ('MATH', 'STAT') or 
                  MINOR_CODE_2_5 in ('MATH', 'STAT'))
          union all
          ---------------------------------------------------------------
          --Computer Science Majors/Minors
          --Students are permitted to have this access level during the
          --Summer term if they were registered for the Spring term per
          --the requirements.
          --See the special notes at the top of this file.          
          ---------------------------------------------------------------
          select pidm,
                 'CompSci_Majr_Minor' access_level,
                 stvterm_start_date - 7 as begin_date,
                 stvterm_end_date as end_date,
                 cast(null as varchar2(100)) building,
                 cast(null as varchar2(100)) room
            from xuprommgr.zs_enrollment_expanded zee
            join stvterm
              on stvterm_start_date <= sysdate + 7
             and stvterm_end_date >= sysdate
            join xuprommgr.xu_current_terms cur_term
              on cur_term.term = 'CURRENT_SS'
            join xuprommgr.xu_current_terms prev_term
              on prev_term.term = 'PREVIOUS'
                 --Include anyone currently registered and anyone that was registered 
                 --in the previous term if the current term is Summer.
           where (zee.term = cur_term.term_code or 
                  zee.term = decode(cur_term.season, 
                                    'SUMMER', prev_term.term_code, 
                                    '__')--any arbitrary value that will never match a term but is not null.
                 )
             and levl_code_1 = 'U'
             and (--majors
                  MAJOR_CODE_1_1 in ('CSCI', 'APCP') or MAJOR_CODE_1_2 in ('CSCI', 'APCP') or MAJOR_CODE_1_3 in ('CSCI', 'APCP') or
                  MAJOR_CODE_1_4 in ('CSCI', 'APCP') or MAJOR_CODE_2_1 in ('CSCI', 'APCP') or MAJOR_CODE_2_2 in ('CSCI', 'APCP') or
                  MAJOR_CODE_2_3 in ('CSCI', 'APCP') or MAJOR_CODE_2_4 in ('CSCI', 'APCP') or 
                  --minors
                  MINOR_CODE_1_1 = 'CSCI' or MINOR_CODE_1_2 = 'CSCI' or MINOR_CODE_1_3 = 'CSCI' or 
                  MINOR_CODE_1_4 = 'CSCI' or MINOR_CODE_1_5 = 'CSCI' or MINOR_CODE_2_1 = 'CSCI' or 
                  MINOR_CODE_2_2 = 'CSCI' or MINOR_CODE_2_3 = 'CSCI' or MINOR_CODE_2_4 = 'CSCI' or 
                  MINOR_CODE_2_5 = 'CSCI')
          union all
          ---------------------------------------------------------------
          --Psych graduate students
          --Students are permitted to have this access level during the
          --Summer term if they were registered for the Spring term per
          --the requirements.
          --Students retain this access level during the gap between
          --terms.
          --See the special notes at the top of this file. 
          ---------------------------------------------------------------
          select distinct pidm,
                          'Psych_Graduate_Students' access_level,
                          stvterm_start_date - 7 as begin_date,
                          cur_term.end_date as end_date, --go to start of next term
                          cast(null as varchar2(100)) building,
                          cast(null as varchar2(100)) room
            from xuprommgr.zs_enrollment_expanded zee
            join stvterm
              on stvterm_start_date <= sysdate + 7
             and stvterm_end_date >= sysdate
            join xuprommgr.xu_current_terms cur_term
              on cur_term.term = 'CURRENT_SS'
            join xuprommgr.xu_current_terms prev_term
              on prev_term.term = 'PREVIOUS'
                 --Include anyone currently registered and anyone that was registered 
                 --in the previous term if the current term is Summer.
           where (zee.term = cur_term.term_code or 
                  zee.term = decode(cur_term.season, 
                                    'SUMMER', prev_term.term_code, 
                                    '__')--any arbitrary value that will never match a term but is not null.
                 )
             and levl_code_1 = 'G'
             and (--majors
                  MAJOR_CODE_1_1 = 'PSYC' or MAJOR_CODE_1_2 = 'PSYC' or MAJOR_CODE_1_3 = 'PSYC' or
                  MAJOR_CODE_1_4 = 'PSYC' or MAJOR_CODE_2_1 = 'PSYC' or MAJOR_CODE_2_2 = 'PSYC' or
                  MAJOR_CODE_2_3 = 'PSYC' or MAJOR_CODE_2_4 = 'PSYC')
*/
    ) people
  ---------------------------------------
  --Attach all the info to the pidms and
  --access levels.
  ---------------------------------------
    --warning:  xf_get_cell_rowid ignores extra cell phones, doesn't have an order by
    left outer join (sprtele) cell_tele
      on (cell_tele.rowid = xuprommgr.xf_get_cell_rowid(pidm)) 
    --warning:  xf_get_home_rowid ignores extra home phones, doesn't have an order by
    left outer join (sprtele) home_tele
      on (home_tele.rowid = xuprommgr.xf_get_home_rowid(pidm))
    left join(zsbidcd)
      on (zsbidcd_pidm = pidm and zsbidcd_card_status = 'ACTIVE' and
         access_level <> 'NO_ALLCARD')
    left join spriden out_s
      on (spriden_pidm = pidm and spriden_change_ind is null)
    left join(xuprommgr.zgrcdpn)
      on (zgrcdpn_pidm = pidm and zgrcdpn_from_date <= sysdate and
         zgrcdpn_to_date >= sysdate)
    left outer join spraddr home_addr
      on (spraddr_pidm = pidm and spraddr_atyp_code = 'HM' and
         spraddr_from_date <= sysdate and
         (spraddr_to_date is null or spraddr_to_date > sysdate) and
         spraddr_status_ind is null)      
    left outer join spbpers
      on (spbpers_pidm = pidm);

-----------------------------------
--Swap out public synonym and 
--kill old view.
-----------------------------------
select to_char(sysdate, 'mm/dd/yy hh:mi:ss') time from dual;
drop public synonym persona_access_view;
create public synonym persona_access_view for xupersona.&var_new_view;

select to_char(sysdate, 'mm/dd/yy hh:mi:ss') time from dual;
drop materialized view xupersona.&var_old_view;

select to_char(sysdate, 'mm/dd/yy hh:mi:ss') time from dual;
select count(1) from persona_access_view;
select view_name||'->'||table_name from all_synonyms where synonym_name like ('PERSONA_ACCESS_VIE*');

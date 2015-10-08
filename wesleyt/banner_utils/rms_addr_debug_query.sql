
--select count(1) from (

select * from (

select distinct zee.pidm,
       pk_rms_id,
       zstrmsx_id      xfer_id,
       zsthosx_stu_num,
       null            sepa,
       
       zee.HOME_STREET1  ban_street1,
       address_1         rms_street1,
       zstrmsx_addr1     xfer_street1,
       zsthosx_address_1,
       null              sepb,
       
       zee.home_phone ban_hm_phone,
       location_phone rms_phone,
       zee.HOME_EMAIL ban_hm_email,
       zee.XU_EMAIL ban_xu_email,
       e_mail rms_email,
       '################' sep,
       
       zee.HOME_STREET1,
       zee.HOME_STREET2,
       zee.HOME_STREET3,
       zee.HOME_STREET4,
       zee.HOME_CITY,
       zee.HOME_STATE,
       zee.HOME_ZIP,
       zee.HOME_PHONE,
       zee.HOME_COUNTRY,
       '################' sep2,
       
       address_1,
       address_1b,
       address_2,
       postcode,
       address_3,
       fk_state,
       ck_address_type,
       location_phone,
       '################' sep3,
       
       ix_last_name,
       ix_first_name,
       e_mail,
       '################' sep5,
       
       zee.LAST_NAME,
       zee.FIRST_NAME,
       zee.MIDDLE_NAME,
       zee.PREFIX,
       zee.SUFFIX,
       zee.HOME_EMAIL,
       zee.BUS_EMAIL,
       zee.XU_EMAIL

  from xuprommgr.zs_enrollment_expanded zee
  join spbpers
    on spbpers_pidm = pidm
  join pple_t_person@rmsl
    on ix_national_id = spbpers_ssn
  join pple_t_address@rmsl
    on ck_rms_id = pk_rms_id
   and ck_address_type = 'Permanent'
  join xuprommgr.zsthosx
    on zsthosx_stu_num = id
  join xuprommgr.zstrmsx
    on pk_rms_id = zstrmsx_id
 where
-- zsthosx_stu_num in ('000590785', '000589523')
 zee.home_street1 <> address_1
 --zee.home_street1 <> zsthosx_address_1
 --zee.home_street1 = address_1
 order by pidm
-- ) 

) it 
where ban_street1 in (select spraddr_street_line1 from spraddr where spraddr_pidm = it.pidm);

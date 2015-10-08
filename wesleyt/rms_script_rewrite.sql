declare
    g_call_count number := 0;
    procedure do_insert(in_CK_PLAN_TYPE varchar2, in_rms_id in varchar2, in_CK_MOVE_IN_DATE varchar2,
                        in_FK_RATE_CODE varchar2, in_FK_RATE_CONFIG_NO varchar2, in_APPLICATION_TYPE varchar2,
                         in_PLAN_PERSON_MOVE_OUT_DATE varchar2,
                        in_PLAN_PERSON_BOOKING_TYPE varchar2, in_PLAN_PERSON_RATE varchar2,
                        in_PLAN_PERSON_BILLED_UP_TO varchar2, in_PLAN_PERSON_NOTES varchar2,
                        in_PLAN_PERSON_BILLING_TYPE varchar2, 
                        in_FK_TERM_ID varchar2) is
        intOrderID   number;
        strSKOrderID varchar2(80);
    begin
        g_call_count := g_call_count + 1;
        SELECT MAX(pk_Order_ID + 1) INTO intOrderID FROM RMSREAL.acct_t_Orders;
        strSKOrderID := 'Plan' || TO_CHAR(intOrderID);
        INSERT INTO RMSREAL.acct_t_orders (PK_ORDER_ID, FK_RMS_ID) VALUES (intOrderID, in_rms_id);
        INSERT INTO RMSREAL.rmgt_t_plan_person
            (CK_PLAN_TYPE,
             CK_RMS_ID,
             CK_MOVE_IN_DATE,
             FK_RATE_CODE,
             FK_RATE_CONFIG_NO,
             APPLICATION_TYPE,
             PLAN_PERSON_BOOKED_BY,
             PLAN_PERSON_MOVE_OUT_DATE,
             PLAN_PERSON_BOOKING_TYPE,
             PLAN_PERSON_RATE,
             PLAN_PERSON_BILLED_UP_TO,
             PLAN_PERSON_NOTES,
             PLAN_PERSON_BILLING_TYPE,
             FK_ORDER_ID,
             SK_PLAN_ORDER_ID,
             FK_TERM_ID)
        VALUES
            (in_CK_PLAN_TYPE,
             in_RMS_ID,
             in_CK_MOVE_IN_DATE,
             in_FK_RATE_CODE,
             in_FK_RATE_CONFIG_NO,
             in_APPLICATION_TYPE,
             'Owner50RMS',
             in_PLAN_PERSON_MOVE_OUT_DATE,
             in_PLAN_PERSON_BOOKING_TYPE,
             in_PLAN_PERSON_RATE,
             in_PLAN_PERSON_BILLED_UP_TO,
             in_PLAN_PERSON_NOTES,
             in_PLAN_PERSON_BILLING_TYPE,
             intorderid,
             strSKOrderID,
             in_FK_TERM_ID);
        commit;
    exception
        when others then
            dbms_output.put_line('CallCount = '||g_call_count||'.  Error inserting plan '||in_CK_PLAN_TYPE||' for '||in_rms_id||':  '||sqlerrm);
    end; 
begin
    do_insert('MUSKIE','16279',to_date('08/26/2013', 'mm/dd/yyyy'), 'MUSKIE','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2400',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MUSKIE','15566',to_date('08/26/2013', 'mm/dd/yyyy'), 'MUSKIE','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2400',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MUSKIE','15389',to_date('08/26/2013', 'mm/dd/yyyy'), 'MUSKIE','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2400',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MEAL14','15105',to_date('08/26/2013', 'mm/dd/yyyy'), 'MEAL14','20','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2180',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MUSKIE','27253',to_date('08/26/2013', 'mm/dd/yyyy'), 'MUSKIE','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2400',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('BLOCK225','15063',to_date('08/26/2013', 'mm/dd/yyyy'), 'BLOCK225','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2290',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MEAL14','14301',to_date('08/26/2013', 'mm/dd/yyyy'), 'MEAL14','20','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2180',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('80BLOCK','12680',to_date('08/26/2013', 'mm/dd/yyyy'), '80BLOCK','12','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','930',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MEAL14','16164',to_date('08/26/2013', 'mm/dd/yyyy'), 'MEAL14','20','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2180',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MUSKIE','15801',to_date('08/26/2013', 'mm/dd/yyyy'), 'MUSKIE','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2400',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MEAL14','15511',to_date('08/26/2013', 'mm/dd/yyyy'), 'MEAL14','20','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2180',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('80BLOCK','13178',to_date('08/26/2013', 'mm/dd/yyyy'), '80BLOCK','12','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','930',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MUSKIE','15432',to_date('08/26/2013', 'mm/dd/yyyy'), 'MUSKIE','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2400',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MEAL14','13124',to_date('08/26/2013', 'mm/dd/yyyy'), 'MEAL14','20','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2180',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('BLOCK225','12792',to_date('08/26/2013', 'mm/dd/yyyy'), 'BLOCK225','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2290',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MUSKIE','15504',to_date('08/26/2013', 'mm/dd/yyyy'), 'MUSKIE','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2400',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('BLOCK225','15062',to_date('08/26/2013', 'mm/dd/yyyy'), 'BLOCK225','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2290',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MUSKIE','15567',to_date('08/26/2013', 'mm/dd/yyyy'), 'MUSKIE','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2400',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MEAL14','15656',to_date('08/26/2013', 'mm/dd/yyyy'), 'MEAL14','20','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2180',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('80BLOCK','14407',to_date('08/26/2013', 'mm/dd/yyyy'), '80BLOCK','12','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','930',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('BLOCK225','15906',to_date('08/26/2013', 'mm/dd/yyyy'), 'BLOCK225','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2290',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MUSKIE','15629',to_date('08/26/2013', 'mm/dd/yyyy'), 'MUSKIE','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2400',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MEAL14','27693',to_date('08/26/2013', 'mm/dd/yyyy'), 'MEAL14','20','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2180',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MEAL14','15433',to_date('08/26/2013', 'mm/dd/yyyy'), 'MEAL14','20','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2180',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MEAL14','27272',to_date('08/26/2013', 'mm/dd/yyyy'), 'MEAL14','20','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2180',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MUSKIE','15705',to_date('08/26/2013', 'mm/dd/yyyy'), 'MUSKIE','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2400',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MEAL14','15412',to_date('08/26/2013', 'mm/dd/yyyy'), 'MEAL14','20','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2180',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MUSKIE','27358',to_date('08/26/2013', 'mm/dd/yyyy'), 'MUSKIE','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2400',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('BLOCK25','13627',to_date('08/26/2013', 'mm/dd/yyyy'), 'BLOCK25','9','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','410',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('80BLOCK','14639',to_date('08/26/2013', 'mm/dd/yyyy'), '80BLOCK','12','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','930',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MEAL14','12404',to_date('08/26/2013', 'mm/dd/yyyy'), 'MEAL14','20','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2180',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MEAL14','12521',to_date('08/26/2013', 'mm/dd/yyyy'), 'MEAL14','20','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2180',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('80BLOCK','15662',to_date('08/26/2013', 'mm/dd/yyyy'), '80BLOCK','12','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','930',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('BLOCK225','13497',to_date('08/26/2013', 'mm/dd/yyyy'), 'BLOCK225','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2290',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('BLOCK225','15124',to_date('08/26/2013', 'mm/dd/yyyy'), 'BLOCK225','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2290',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('80BLOCK','13884',to_date('08/26/2013', 'mm/dd/yyyy'), '80BLOCK','12','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','930',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MUSKIE','15598',to_date('08/26/2013', 'mm/dd/yyyy'), 'MUSKIE','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2400',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MUSKIE','14317',to_date('08/26/2013', 'mm/dd/yyyy'), 'MUSKIE','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2400',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('BLOCK225','15682',to_date('08/26/2013', 'mm/dd/yyyy'), 'BLOCK225','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2290',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('BLOCK225','15871',to_date('08/26/2013', 'mm/dd/yyyy'), 'BLOCK225','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2290',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('80BLOCK','13190',to_date('08/26/2013', 'mm/dd/yyyy'), '80BLOCK','12','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','930',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('BLOCK225','13307',to_date('08/26/2013', 'mm/dd/yyyy'), 'BLOCK225','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2290',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('BLOCK225','15102',to_date('08/26/2013', 'mm/dd/yyyy'), 'BLOCK225','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2290',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MUSKIE','15944',to_date('08/26/2013', 'mm/dd/yyyy'), 'MUSKIE','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2400',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MUSKIE','13652',to_date('08/26/2013', 'mm/dd/yyyy'), 'MUSKIE','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2400',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('BLOCK225','14555',to_date('08/26/2013', 'mm/dd/yyyy'), 'BLOCK225','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2290',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MEAL14','13335',to_date('08/26/2013', 'mm/dd/yyyy'), 'MEAL14','20','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2180',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MUSKIE','25372',to_date('08/26/2013', 'mm/dd/yyyy'), 'MUSKIE','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2400',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('BLOCK40','13288',to_date('08/26/2013', 'mm/dd/yyyy'), 'BLOCK40','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','560',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('80BLOCK','13053',to_date('08/26/2013', 'mm/dd/yyyy'), '80BLOCK','12','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','930',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('BLOCK40','13271',to_date('08/26/2013', 'mm/dd/yyyy'), 'BLOCK40','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','560',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MEAL14','20661',to_date('08/26/2013', 'mm/dd/yyyy'), 'MEAL14','20','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2180',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('BLOCK225','15256',to_date('08/26/2013', 'mm/dd/yyyy'), 'BLOCK225','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2290',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MUSKIE','15776',to_date('08/26/2013', 'mm/dd/yyyy'), 'MUSKIE','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2400',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MUSKIE','12498',to_date('08/26/2013', 'mm/dd/yyyy'), 'MUSKIE','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2400',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MUSKIE','15671',to_date('08/26/2013', 'mm/dd/yyyy'), 'MUSKIE','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2400',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MEAL14','15727',to_date('08/26/2013', 'mm/dd/yyyy'), 'MEAL14','20','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2180',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('BLOCK225','15453',to_date('08/26/2013', 'mm/dd/yyyy'), 'BLOCK225','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2290',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MUSKIE','25946',to_date('08/26/2013', 'mm/dd/yyyy'), 'MUSKIE','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2400',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MUSKIE','15417',to_date('08/26/2013', 'mm/dd/yyyy'), 'MUSKIE','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2400',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('BLOCK40','14123',to_date('08/26/2013', 'mm/dd/yyyy'), 'BLOCK40','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','560',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MUSKIE','14420',to_date('08/26/2013', 'mm/dd/yyyy'), 'MUSKIE','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2400',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('BLOCK25','12614',to_date('08/26/2013', 'mm/dd/yyyy'), 'BLOCK25','9','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','410',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MUSKIE','15393',to_date('08/26/2013', 'mm/dd/yyyy'), 'MUSKIE','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2400',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MUSKIE','12879',to_date('08/26/2013', 'mm/dd/yyyy'), 'MUSKIE','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2400',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MUSKIE','16168',to_date('08/26/2013', 'mm/dd/yyyy'), 'MUSKIE','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2400',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('BLOCK225','16282',to_date('08/26/2013', 'mm/dd/yyyy'), 'BLOCK225','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2290',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('BLOCK225','12598',to_date('08/26/2013', 'mm/dd/yyyy'), 'BLOCK225','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2290',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('BLOCK225','27350',to_date('08/26/2013', 'mm/dd/yyyy'), 'BLOCK225','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2290',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('BLOCK40','27655',to_date('08/26/2013', 'mm/dd/yyyy'), 'BLOCK40','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','560',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('BLOCK40','12707',to_date('08/26/2013', 'mm/dd/yyyy'), 'BLOCK40','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','560',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MUSKIE','13876',to_date('08/26/2013', 'mm/dd/yyyy'), 'MUSKIE','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2400',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('BLOCK225','15665',to_date('08/26/2013', 'mm/dd/yyyy'), 'BLOCK225','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2290',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MUSKIE','15731',to_date('08/26/2013', 'mm/dd/yyyy'), 'MUSKIE','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2400',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('80BLOCK','12857',to_date('08/26/2013', 'mm/dd/yyyy'), '80BLOCK','12','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','930',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MEAL14','21754',to_date('08/26/2013', 'mm/dd/yyyy'), 'MEAL14','20','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2180',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MUSKIE','15690',to_date('08/26/2013', 'mm/dd/yyyy'), 'MUSKIE','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2400',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MEAL14','15652',to_date('08/26/2013', 'mm/dd/yyyy'), 'MEAL14','20','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2180',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('80BLOCK','12778',to_date('08/26/2013', 'mm/dd/yyyy'), '80BLOCK','12','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','930',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MEAL14','15137',to_date('08/26/2013', 'mm/dd/yyyy'), 'MEAL14','20','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2180',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('BLOCK225','13408',to_date('08/26/2013', 'mm/dd/yyyy'), 'BLOCK225','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2290',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MUSKIE','15780',to_date('08/26/2013', 'mm/dd/yyyy'), 'MUSKIE','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2400',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MEAL14','14693',to_date('08/26/2013', 'mm/dd/yyyy'), 'MEAL14','20','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2180',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('BLOCK225','14530',to_date('08/26/2013', 'mm/dd/yyyy'), 'BLOCK225','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2290',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('BLOCK225','13736',to_date('08/26/2013', 'mm/dd/yyyy'), 'BLOCK225','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2290',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MEAL14','16126',to_date('08/26/2013', 'mm/dd/yyyy'), 'MEAL14','20','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2180',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MUSKIE','15742',to_date('08/26/2013', 'mm/dd/yyyy'), 'MUSKIE','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2400',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('BLOCK225','13822',to_date('08/26/2013', 'mm/dd/yyyy'), 'BLOCK225','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2290',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MUSKIE','16102',to_date('08/26/2013', 'mm/dd/yyyy'), 'MUSKIE','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2400',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('BLOCK225','15670',to_date('08/26/2013', 'mm/dd/yyyy'), 'BLOCK225','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2290',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MUSKIE','16038',to_date('08/26/2013', 'mm/dd/yyyy'), 'MUSKIE','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2400',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('BLOCK40','13388',to_date('08/26/2013', 'mm/dd/yyyy'), 'BLOCK40','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','560',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('BLOCK225','15545',to_date('08/26/2013', 'mm/dd/yyyy'), 'BLOCK225','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2290',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MEAL14','14359',to_date('08/26/2013', 'mm/dd/yyyy'), 'MEAL14','20','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2180',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('BLOCK225','16166',to_date('08/26/2013', 'mm/dd/yyyy'), 'BLOCK225','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2290',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MUSKIE','14188',to_date('08/26/2013', 'mm/dd/yyyy'), 'MUSKIE','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2400',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('80BLOCK','13065',to_date('08/26/2013', 'mm/dd/yyyy'), '80BLOCK','12','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','930',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('BLOCK225','15619',to_date('08/26/2013', 'mm/dd/yyyy'), 'BLOCK225','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2290',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MUSKIE','16041',to_date('08/26/2013', 'mm/dd/yyyy'), 'MUSKIE','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2400',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MEAL14','13355',to_date('08/26/2013', 'mm/dd/yyyy'), 'MEAL14','20','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2180',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MUSKIE','15954',to_date('08/26/2013', 'mm/dd/yyyy'), 'MUSKIE','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2400',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MEAL14','14909',to_date('08/26/2013', 'mm/dd/yyyy'), 'MEAL14','20','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2180',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MUSKIE','14691',to_date('08/26/2013', 'mm/dd/yyyy'), 'MUSKIE','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2400',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MEAL14','15981',to_date('08/26/2013', 'mm/dd/yyyy'), 'MEAL14','20','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2180',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('80BLOCK','14507',to_date('08/26/2013', 'mm/dd/yyyy'), '80BLOCK','12','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','930',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MEAL14','15793',to_date('08/26/2013', 'mm/dd/yyyy'), 'MEAL14','20','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2180',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('BLOCK40','13263',to_date('08/26/2013', 'mm/dd/yyyy'), 'BLOCK40','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','560',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('BLOCK225','14253',to_date('08/26/2013', 'mm/dd/yyyy'), 'BLOCK225','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2290',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MEAL14','15201',to_date('08/26/2013', 'mm/dd/yyyy'), 'MEAL14','20','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2180',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MEAL14','15819',to_date('08/26/2013', 'mm/dd/yyyy'), 'MEAL14','20','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2180',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MUSKIE','13488',to_date('08/26/2013', 'mm/dd/yyyy'), 'MUSKIE','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2400',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('80BLOCK','14140',to_date('08/26/2013', 'mm/dd/yyyy'), '80BLOCK','12','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','930',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MUSKIE','15461',to_date('08/26/2013', 'mm/dd/yyyy'), 'MUSKIE','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2400',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MUSKIE','14312',to_date('08/26/2013', 'mm/dd/yyyy'), 'MUSKIE','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2400',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MUSKIE','16183',to_date('08/26/2013', 'mm/dd/yyyy'), 'MUSKIE','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2400',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('BLOCK225','13754',to_date('08/26/2013', 'mm/dd/yyyy'), 'BLOCK225','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2290',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MEAL14','16267',to_date('08/26/2013', 'mm/dd/yyyy'), 'MEAL14','20','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2180',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MUSKIE','15132',to_date('08/26/2013', 'mm/dd/yyyy'), 'MUSKIE','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2400',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MUSKIE','25848',to_date('08/26/2013', 'mm/dd/yyyy'), 'MUSKIE','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2400',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MEAL14','15580',to_date('08/26/2013', 'mm/dd/yyyy'), 'MEAL14','20','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2180',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MEAL14','15444',to_date('08/26/2013', 'mm/dd/yyyy'), 'MEAL14','20','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2180',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MUSKIE','14576',to_date('08/26/2013', 'mm/dd/yyyy'), 'MUSKIE','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2400',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('BLOCK40','12670',to_date('08/26/2013', 'mm/dd/yyyy'), 'BLOCK40','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','560',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MUSKIE','15310',to_date('08/26/2013', 'mm/dd/yyyy'), 'MUSKIE','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2400',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MUSKIE','15914',to_date('08/26/2013', 'mm/dd/yyyy'), 'MUSKIE','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2400',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('80BLOCK','27250',to_date('08/26/2013', 'mm/dd/yyyy'), '80BLOCK','12','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','930',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MEAL14','14339',to_date('08/26/2013', 'mm/dd/yyyy'), 'MEAL14','20','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2180',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('BLOCK25','13151',to_date('08/26/2013', 'mm/dd/yyyy'), 'BLOCK25','9','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','410',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('BLOCK225','14411',to_date('08/26/2013', 'mm/dd/yyyy'), 'BLOCK225','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2290',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MUSKIE','15224',to_date('08/26/2013', 'mm/dd/yyyy'), 'MUSKIE','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2400',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MUSKIE','15213',to_date('08/26/2013', 'mm/dd/yyyy'), 'MUSKIE','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2400',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MUSKIE','15258',to_date('08/26/2013', 'mm/dd/yyyy'), 'MUSKIE','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2400',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MUSKIE','15852',to_date('08/26/2013', 'mm/dd/yyyy'), 'MUSKIE','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2400',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('BLOCK225','15190',to_date('08/26/2013', 'mm/dd/yyyy'), 'BLOCK225','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2290',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MUSKIE','15886',to_date('08/26/2013', 'mm/dd/yyyy'), 'MUSKIE','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2400',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MUSKIE','15184',to_date('08/26/2013', 'mm/dd/yyyy'), 'MUSKIE','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2400',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('80BLOCK','11954',to_date('08/26/2013', 'mm/dd/yyyy'), '80BLOCK','12','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','930',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('80BLOCK','13881',to_date('08/26/2013', 'mm/dd/yyyy'), '80BLOCK','12','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','930',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('80BLOCK','13005',to_date('08/26/2013', 'mm/dd/yyyy'), '80BLOCK','12','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','930',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('BLOCK225','15667',to_date('08/26/2013', 'mm/dd/yyyy'), 'BLOCK225','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2290',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('BLOCK225','13041',to_date('08/26/2013', 'mm/dd/yyyy'), 'BLOCK225','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2290',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('BLOCK225','15563',to_date('08/26/2013', 'mm/dd/yyyy'), 'BLOCK225','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2290',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('BLOCK225','15327',to_date('08/26/2013', 'mm/dd/yyyy'), 'BLOCK225','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2290',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MEAL14','16026',to_date('08/26/2013', 'mm/dd/yyyy'), 'MEAL14','20','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2180',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MEAL14','14245',to_date('08/26/2013', 'mm/dd/yyyy'), 'MEAL14','20','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2180',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MEAL14','14244',to_date('08/26/2013', 'mm/dd/yyyy'), 'MEAL14','20','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2180',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MEAL14','15591',to_date('08/26/2013', 'mm/dd/yyyy'), 'MEAL14','20','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2180',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MUSKIE','15755',to_date('08/26/2013', 'mm/dd/yyyy'), 'MUSKIE','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2400',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MEAL14','15658',to_date('08/26/2013', 'mm/dd/yyyy'), 'MEAL14','20','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2180',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MUSKIE','15232',to_date('08/26/2013', 'mm/dd/yyyy'), 'MUSKIE','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2400',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MUSKIE','12705',to_date('08/26/2013', 'mm/dd/yyyy'), 'MUSKIE','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2400',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MEAL14','15119',to_date('08/26/2013', 'mm/dd/yyyy'), 'MEAL14','20','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2180',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MEAL14','15805',to_date('08/26/2013', 'mm/dd/yyyy'), 'MEAL14','20','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2180',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MEAL14','12801',to_date('08/26/2013', 'mm/dd/yyyy'), 'MEAL14','20','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2180',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('80BLOCK','13309',to_date('08/26/2013', 'mm/dd/yyyy'), '80BLOCK','12','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','930',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MUSKIE','15477',to_date('08/26/2013', 'mm/dd/yyyy'), 'MUSKIE','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2400',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MUSKIE','15260',to_date('08/26/2013', 'mm/dd/yyyy'), 'MUSKIE','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2400',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('BLOCK225','12846',to_date('08/26/2013', 'mm/dd/yyyy'), 'BLOCK225','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2290',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MUSKIE','13310',to_date('08/26/2013', 'mm/dd/yyyy'), 'MUSKIE','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2400',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('BLOCK225','16014',to_date('08/26/2013', 'mm/dd/yyyy'), 'BLOCK225','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2290',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MEAL14','16288',to_date('08/26/2013', 'mm/dd/yyyy'), 'MEAL14','20','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2180',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('BLOCK225','13858',to_date('08/26/2013', 'mm/dd/yyyy'), 'BLOCK225','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2290',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MEAL14','15336',to_date('08/26/2013', 'mm/dd/yyyy'), 'MEAL14','20','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2180',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('80BLOCK','14242',to_date('08/26/2013', 'mm/dd/yyyy'), '80BLOCK','12','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','930',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MUSKIE','13851',to_date('08/26/2013', 'mm/dd/yyyy'), 'MUSKIE','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2400',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MUSKIE','15177',to_date('08/26/2013', 'mm/dd/yyyy'), 'MUSKIE','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2400',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MEAL14','15763',to_date('08/26/2013', 'mm/dd/yyyy'), 'MEAL14','20','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2180',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MEAL14','14423',to_date('08/26/2013', 'mm/dd/yyyy'), 'MEAL14','20','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2180',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MUSKIE','14378',to_date('08/26/2013', 'mm/dd/yyyy'), 'MUSKIE','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2400',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('BLOCK225','15599',to_date('08/26/2013', 'mm/dd/yyyy'), 'BLOCK225','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2290',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('BLOCK225','12886',to_date('08/26/2013', 'mm/dd/yyyy'), 'BLOCK225','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2290',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('BLOCK225','15617',to_date('08/26/2013', 'mm/dd/yyyy'), 'BLOCK225','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2290',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('80BLOCK','13324',to_date('08/26/2013', 'mm/dd/yyyy'), '80BLOCK','12','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','930',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('BLOCK225','12730',to_date('08/26/2013', 'mm/dd/yyyy'), 'BLOCK225','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2290',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('BLOCK225','12770',to_date('08/26/2013', 'mm/dd/yyyy'), 'BLOCK225','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2290',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MUSKIE','15087',to_date('08/26/2013', 'mm/dd/yyyy'), 'MUSKIE','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2400',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MUSKIE','15939',to_date('08/26/2013', 'mm/dd/yyyy'), 'MUSKIE','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2400',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MEAL14','13173',to_date('08/26/2013', 'mm/dd/yyyy'), 'MEAL14','20','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2180',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('BLOCK40','13863',to_date('08/26/2013', 'mm/dd/yyyy'), 'BLOCK40','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','560',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('BLOCK225','13477',to_date('08/26/2013', 'mm/dd/yyyy'), 'BLOCK225','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2290',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('80BLOCK','11182',to_date('08/26/2013', 'mm/dd/yyyy'), '80BLOCK','12','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','930',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MUSKIE','12428',to_date('08/26/2013', 'mm/dd/yyyy'), 'MUSKIE','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2400',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('BLOCK225','13891',to_date('08/26/2013', 'mm/dd/yyyy'), 'BLOCK225','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2290',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('BLOCK25','16117',to_date('08/26/2013', 'mm/dd/yyyy'), 'BLOCK25','9','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','410',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MEAL14','15267',to_date('08/26/2013', 'mm/dd/yyyy'), 'MEAL14','20','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2180',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MUSKIE','25294',to_date('08/26/2013', 'mm/dd/yyyy'), 'MUSKIE','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2400',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MUSKIE','27580',to_date('08/26/2013', 'mm/dd/yyyy'), 'MUSKIE','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2400',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('BLOCK225','15649',to_date('08/26/2013', 'mm/dd/yyyy'), 'BLOCK225','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2290',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MUSKIE','15719',to_date('08/26/2013', 'mm/dd/yyyy'), 'MUSKIE','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2400',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MEAL14','12775',to_date('08/26/2013', 'mm/dd/yyyy'), 'MEAL14','20','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2180',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MUSKIE','15811',to_date('08/26/2013', 'mm/dd/yyyy'), 'MUSKIE','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2400',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MEAL14','14895',to_date('08/26/2013', 'mm/dd/yyyy'), 'MEAL14','20','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2180',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MUSKIE','14270',to_date('08/26/2013', 'mm/dd/yyyy'), 'MUSKIE','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2400',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MEAL14','15611',to_date('08/26/2013', 'mm/dd/yyyy'), 'MEAL14','20','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2180',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('BLOCK225','15606',to_date('08/26/2013', 'mm/dd/yyyy'), 'BLOCK225','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2290',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MEAL14','14296',to_date('08/26/2013', 'mm/dd/yyyy'), 'MEAL14','20','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2180',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MUSKIE','27349',to_date('08/26/2013', 'mm/dd/yyyy'), 'MUSKIE','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2400',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MUSKIE','15396',to_date('08/26/2013', 'mm/dd/yyyy'), 'MUSKIE','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2400',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('BLOCK225','15613',to_date('08/26/2013', 'mm/dd/yyyy'), 'BLOCK225','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2290',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MUSKIE','15866',to_date('08/26/2013', 'mm/dd/yyyy'), 'MUSKIE','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2400',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('80BLOCK','14834',to_date('08/26/2013', 'mm/dd/yyyy'), '80BLOCK','12','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','930',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MUSKIE','15738',to_date('08/26/2013', 'mm/dd/yyyy'), 'MUSKIE','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2400',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MUSKIE','12972',to_date('08/26/2013', 'mm/dd/yyyy'), 'MUSKIE','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2400',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MUSKIE','15270',to_date('08/26/2013', 'mm/dd/yyyy'), 'MUSKIE','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2400',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MEAL14','12956',to_date('08/26/2013', 'mm/dd/yyyy'), 'MEAL14','20','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2180',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MEAL14','14207',to_date('08/26/2013', 'mm/dd/yyyy'), 'MEAL14','20','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2180',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('BLOCK40','12926',to_date('08/26/2013', 'mm/dd/yyyy'), 'BLOCK40','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','560',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MUSKIE','25940',to_date('08/26/2013', 'mm/dd/yyyy'), 'MUSKIE','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2400',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MEAL14','15822',to_date('08/26/2013', 'mm/dd/yyyy'), 'MEAL14','20','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2180',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MEAL14','15816',to_date('08/26/2013', 'mm/dd/yyyy'), 'MEAL14','20','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2180',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MUSKIE','15677',to_date('08/26/2013', 'mm/dd/yyyy'), 'MUSKIE','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2400',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('BLOCK40','15565',to_date('08/26/2013', 'mm/dd/yyyy'), 'BLOCK40','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','560',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MUSKIE','27153',to_date('08/26/2013', 'mm/dd/yyyy'), 'MUSKIE','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2400',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MUSKIE','14005',to_date('08/26/2013', 'mm/dd/yyyy'), 'MUSKIE','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2400',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MEAL14','15501',to_date('08/26/2013', 'mm/dd/yyyy'), 'MEAL14','20','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2180',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MUSKIE','15209',to_date('08/26/2013', 'mm/dd/yyyy'), 'MUSKIE','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2400',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('BLOCK225','15845',to_date('08/26/2013', 'mm/dd/yyyy'), 'BLOCK225','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2290',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('BLOCK225','15339',to_date('08/26/2013', 'mm/dd/yyyy'), 'BLOCK225','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2290',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MUSKIE','15663',to_date('08/26/2013', 'mm/dd/yyyy'), 'MUSKIE','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2400',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MUSKIE','12374',to_date('08/26/2013', 'mm/dd/yyyy'), 'MUSKIE','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2400',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('BLOCK225','14212',to_date('08/26/2013', 'mm/dd/yyyy'), 'BLOCK225','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2290',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MEAL14','15356',to_date('08/26/2013', 'mm/dd/yyyy'), 'MEAL14','20','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2180',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MEAL14','15718',to_date('08/26/2013', 'mm/dd/yyyy'), 'MEAL14','20','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2180',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('BLOCK225','14791',to_date('08/26/2013', 'mm/dd/yyyy'), 'BLOCK225','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2290',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('BLOCK225','15225',to_date('08/26/2013', 'mm/dd/yyyy'), 'BLOCK225','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2290',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MEAL14','15034',to_date('08/26/2013', 'mm/dd/yyyy'), 'MEAL14','20','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2180',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MUSKIE','15449',to_date('08/26/2013', 'mm/dd/yyyy'), 'MUSKIE','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2400',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MEAL14','26475',to_date('08/26/2013', 'mm/dd/yyyy'), 'MEAL14','20','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2180',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('BLOCK40','15730',to_date('08/26/2013', 'mm/dd/yyyy'), 'BLOCK40','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','560',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('80BLOCK','13113',to_date('08/26/2013', 'mm/dd/yyyy'), '80BLOCK','12','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','930',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('BLOCK225','15326',to_date('08/26/2013', 'mm/dd/yyyy'), 'BLOCK225','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2290',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MUSKIE','15899',to_date('08/26/2013', 'mm/dd/yyyy'), 'MUSKIE','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2400',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('80BLOCK','14583',to_date('08/26/2013', 'mm/dd/yyyy'), '80BLOCK','12','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','930',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MEAL14','15496',to_date('08/26/2013', 'mm/dd/yyyy'), 'MEAL14','20','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2180',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('BLOCK225','15717',to_date('08/26/2013', 'mm/dd/yyyy'), 'BLOCK225','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2290',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MEAL14','16021',to_date('08/26/2013', 'mm/dd/yyyy'), 'MEAL14','20','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2180',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MEAL14','15536',to_date('08/26/2013', 'mm/dd/yyyy'), 'MEAL14','20','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2180',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MUSKIE','14696',to_date('08/26/2013', 'mm/dd/yyyy'), 'MUSKIE','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2400',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MUSKIE','12916',to_date('08/26/2013', 'mm/dd/yyyy'), 'MUSKIE','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2400',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MUSKIE','13730',to_date('08/26/2013', 'mm/dd/yyyy'), 'MUSKIE','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2400',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('BLOCK225','15631',to_date('08/26/2013', 'mm/dd/yyyy'), 'BLOCK225','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2290',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MEAL14','16023',to_date('08/26/2013', 'mm/dd/yyyy'), 'MEAL14','20','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2180',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('BLOCK40','15553',to_date('08/26/2013', 'mm/dd/yyyy'), 'BLOCK40','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','560',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('BLOCK225','20660',to_date('08/26/2013', 'mm/dd/yyyy'), 'BLOCK225','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2290',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('BLOCK225','15388',to_date('08/26/2013', 'mm/dd/yyyy'), 'BLOCK225','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2290',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MEAL14','15329',to_date('08/26/2013', 'mm/dd/yyyy'), 'MEAL14','20','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2180',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('BLOCK40','13787',to_date('08/26/2013', 'mm/dd/yyyy'), 'BLOCK40','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','560',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('80BLOCK','13721',to_date('08/26/2013', 'mm/dd/yyyy'), '80BLOCK','12','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','930',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('BLOCK225','12355',to_date('08/26/2013', 'mm/dd/yyyy'), 'BLOCK225','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2290',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('BLOCK25','12086',to_date('08/26/2013', 'mm/dd/yyyy'), 'BLOCK25','9','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','410',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MEAL14','15931',to_date('08/26/2013', 'mm/dd/yyyy'), 'MEAL14','20','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2180',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MUSKIE','12403',to_date('08/26/2013', 'mm/dd/yyyy'), 'MUSKIE','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2400',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MUSKIE','14136',to_date('08/26/2013', 'mm/dd/yyyy'), 'MUSKIE','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2400',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MUSKIE','16190',to_date('08/26/2013', 'mm/dd/yyyy'), 'MUSKIE','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2400',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MEAL14','15558',to_date('08/26/2013', 'mm/dd/yyyy'), 'MEAL14','20','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2180',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MUSKIE','15100',to_date('08/26/2013', 'mm/dd/yyyy'), 'MUSKIE','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2400',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('BLOCK40','15748',to_date('08/26/2013', 'mm/dd/yyyy'), 'BLOCK40','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','560',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MEAL14','15579',to_date('08/26/2013', 'mm/dd/yyyy'), 'MEAL14','20','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2180',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MUSKIE','16024',to_date('08/26/2013', 'mm/dd/yyyy'), 'MUSKIE','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2400',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MUSKIE','14279',to_date('08/26/2013', 'mm/dd/yyyy'), 'MUSKIE','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2400',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('BLOCK225','12580',to_date('08/26/2013', 'mm/dd/yyyy'), 'BLOCK225','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2290',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('BLOCK225','16066',to_date('08/26/2013', 'mm/dd/yyyy'), 'BLOCK225','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2290',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MUSKIE','25938',to_date('08/26/2013', 'mm/dd/yyyy'), 'MUSKIE','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2400',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('BLOCK40','12533',to_date('08/26/2013', 'mm/dd/yyyy'), 'BLOCK40','7','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','560',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MEAL14','27270',to_date('08/26/2013', 'mm/dd/yyyy'), 'MEAL14','20','13-14Returning',to_date('12/19/2013', 'mm/dd/yyyy'), 'Mall','2180',to_date('08/26/2013', 'mm/dd/yyyy'), '','13F','13F');
    do_insert('MUSKIE','16279',to_date('01/13/2014', 'mm/dd/yyyy'), 'MUSKIE','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2400',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MUSKIE','15566',to_date('01/13/2014', 'mm/dd/yyyy'), 'MUSKIE','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2400',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MUSKIE','15389',to_date('01/13/2014', 'mm/dd/yyyy'), 'MUSKIE','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2400',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MEAL14','15105',to_date('01/13/2014', 'mm/dd/yyyy'), 'MEAL14','21','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2180',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MUSKIE','27253',to_date('01/13/2014', 'mm/dd/yyyy'), 'MUSKIE','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2400',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('BLOCK225','15063',to_date('01/13/2014', 'mm/dd/yyyy'), 'BLOCK225','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2290',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MEAL14','14301',to_date('01/13/2014', 'mm/dd/yyyy'), 'MEAL14','21','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2180',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('80BLOCK','12680',to_date('01/13/2014', 'mm/dd/yyyy'), '80BLOCK','13','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','930',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MEAL14','16164',to_date('01/13/2014', 'mm/dd/yyyy'), 'MEAL14','21','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2180',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MUSKIE','15801',to_date('01/13/2014', 'mm/dd/yyyy'), 'MUSKIE','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2400',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MEAL14','15511',to_date('01/13/2014', 'mm/dd/yyyy'), 'MEAL14','21','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2180',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('80BLOCK','13178',to_date('01/13/2014', 'mm/dd/yyyy'), '80BLOCK','13','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','930',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MUSKIE','15432',to_date('01/13/2014', 'mm/dd/yyyy'), 'MUSKIE','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2400',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MEAL14','13124',to_date('01/13/2014', 'mm/dd/yyyy'), 'MEAL14','21','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2180',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('BLOCK225','12792',to_date('01/13/2014', 'mm/dd/yyyy'), 'BLOCK225','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2290',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MUSKIE','15504',to_date('01/13/2014', 'mm/dd/yyyy'), 'MUSKIE','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2400',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('BLOCK225','15062',to_date('01/13/2014', 'mm/dd/yyyy'), 'BLOCK225','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2290',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MUSKIE','15567',to_date('01/13/2014', 'mm/dd/yyyy'), 'MUSKIE','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2400',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MEAL14','15656',to_date('01/13/2014', 'mm/dd/yyyy'), 'MEAL14','21','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2180',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('80BLOCK','14407',to_date('01/13/2014', 'mm/dd/yyyy'), '80BLOCK','13','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','930',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('BLOCK225','15906',to_date('01/13/2014', 'mm/dd/yyyy'), 'BLOCK225','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2290',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MUSKIE','15629',to_date('01/13/2014', 'mm/dd/yyyy'), 'MUSKIE','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2400',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MEAL14','27693',to_date('01/13/2014', 'mm/dd/yyyy'), 'MEAL14','21','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2180',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MEAL14','15433',to_date('01/13/2014', 'mm/dd/yyyy'), 'MEAL14','21','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2180',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MEAL14','27272',to_date('01/13/2014', 'mm/dd/yyyy'), 'MEAL14','21','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2180',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MUSKIE','15705',to_date('01/13/2014', 'mm/dd/yyyy'), 'MUSKIE','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2400',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MEAL14','15412',to_date('01/13/2014', 'mm/dd/yyyy'), 'MEAL14','21','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2180',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    commit;
    dbms_output.put_line('Inserted '||g_call_count||' records.');    
end;
/







declare
    g_call_count number := 0;
    procedure do_insert(in_CK_PLAN_TYPE varchar2, in_rms_id in varchar2, in_CK_MOVE_IN_DATE varchar2,
                        in_FK_RATE_CODE varchar2, in_FK_RATE_CONFIG_NO varchar2, in_APPLICATION_TYPE varchar2,
                         in_PLAN_PERSON_MOVE_OUT_DATE varchar2,
                        in_PLAN_PERSON_BOOKING_TYPE varchar2, in_PLAN_PERSON_RATE varchar2,
                        in_PLAN_PERSON_BILLED_UP_TO varchar2, in_PLAN_PERSON_NOTES varchar2,
                        in_PLAN_PERSON_BILLING_TYPE varchar2, 
                        in_FK_TERM_ID varchar2) is
        intOrderID   number;
        strSKOrderID varchar2(80);
    begin
        g_call_count := g_call_count + 1;
        SELECT MAX(pk_Order_ID + 1) INTO intOrderID FROM RMSREAL.acct_t_Orders;
        strSKOrderID := 'Plan' || TO_CHAR(intOrderID);
        INSERT INTO RMSREAL.acct_t_orders (PK_ORDER_ID, FK_RMS_ID) VALUES (intOrderID, in_rms_id);
        INSERT INTO RMSREAL.rmgt_t_plan_person
            (CK_PLAN_TYPE,
             CK_RMS_ID,
             CK_MOVE_IN_DATE,
             FK_RATE_CODE,
             FK_RATE_CONFIG_NO,
             APPLICATION_TYPE,
             PLAN_PERSON_BOOKED_BY,
             PLAN_PERSON_MOVE_OUT_DATE,
             PLAN_PERSON_BOOKING_TYPE,
             PLAN_PERSON_RATE,
             PLAN_PERSON_BILLED_UP_TO,
             PLAN_PERSON_NOTES,
             PLAN_PERSON_BILLING_TYPE,
             FK_ORDER_ID,
             SK_PLAN_ORDER_ID,
             FK_TERM_ID)
        VALUES
            (in_CK_PLAN_TYPE,
             in_RMS_ID,
             in_CK_MOVE_IN_DATE,
             in_FK_RATE_CODE,
             in_FK_RATE_CONFIG_NO,
             in_APPLICATION_TYPE,
             'Owner50RMS',
             in_PLAN_PERSON_MOVE_OUT_DATE,
             in_PLAN_PERSON_BOOKING_TYPE,
             in_PLAN_PERSON_RATE,
             in_PLAN_PERSON_BILLED_UP_TO,
             in_PLAN_PERSON_NOTES,
             in_PLAN_PERSON_BILLING_TYPE,
             intorderid,
             strSKOrderID,
             in_FK_TERM_ID);
        commit;
    exception
        when others then
            dbms_output.put_line('CallCount = '||g_call_count||'.  Error inserting plan '||in_CK_PLAN_TYPE||' for '||in_rms_id||':  '||sqlerrm);
    end; 
begin
    do_insert('MUSKIE','27358',to_date('01/13/2014', 'mm/dd/yyyy'), 'MUSKIE','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2400',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('BLOCK25','13627',to_date('01/13/2014', 'mm/dd/yyyy'), 'BLOCK25','10','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','410',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('80BLOCK','14639',to_date('01/13/2014', 'mm/dd/yyyy'), '80BLOCK','13','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','930',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MEAL14','12404',to_date('01/13/2014', 'mm/dd/yyyy'), 'MEAL14','21','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2180',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MEAL14','12521',to_date('01/13/2014', 'mm/dd/yyyy'), 'MEAL14','21','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2180',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('80BLOCK','15662',to_date('01/13/2014', 'mm/dd/yyyy'), '80BLOCK','13','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','930',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('BLOCK225','13497',to_date('01/13/2014', 'mm/dd/yyyy'), 'BLOCK225','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2290',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('BLOCK225','15124',to_date('01/13/2014', 'mm/dd/yyyy'), 'BLOCK225','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2290',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('80BLOCK','13884',to_date('01/13/2014', 'mm/dd/yyyy'), '80BLOCK','13','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','930',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MUSKIE','15598',to_date('01/13/2014', 'mm/dd/yyyy'), 'MUSKIE','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2400',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MUSKIE','14317',to_date('01/13/2014', 'mm/dd/yyyy'), 'MUSKIE','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2400',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('BLOCK225','15682',to_date('01/13/2014', 'mm/dd/yyyy'), 'BLOCK225','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2290',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('BLOCK225','15871',to_date('01/13/2014', 'mm/dd/yyyy'), 'BLOCK225','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2290',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('80BLOCK','13190',to_date('01/13/2014', 'mm/dd/yyyy'), '80BLOCK','13','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','930',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('BLOCK225','13307',to_date('01/13/2014', 'mm/dd/yyyy'), 'BLOCK225','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2290',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('BLOCK225','15102',to_date('01/13/2014', 'mm/dd/yyyy'), 'BLOCK225','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2290',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MUSKIE','15944',to_date('01/13/2014', 'mm/dd/yyyy'), 'MUSKIE','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2400',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MUSKIE','13652',to_date('01/13/2014', 'mm/dd/yyyy'), 'MUSKIE','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2400',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('BLOCK225','14555',to_date('01/13/2014', 'mm/dd/yyyy'), 'BLOCK225','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2290',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MEAL14','13335',to_date('01/13/2014', 'mm/dd/yyyy'), 'MEAL14','21','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2180',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MUSKIE','25372',to_date('01/13/2014', 'mm/dd/yyyy'), 'MUSKIE','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2400',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('BLOCK40','13288',to_date('01/13/2014', 'mm/dd/yyyy'), 'BLOCK40','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','560',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('80BLOCK','13053',to_date('01/13/2014', 'mm/dd/yyyy'), '80BLOCK','13','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','930',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('BLOCK40','13271',to_date('01/13/2014', 'mm/dd/yyyy'), 'BLOCK40','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','560',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MEAL14','20661',to_date('01/13/2014', 'mm/dd/yyyy'), 'MEAL14','21','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2180',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('BLOCK225','15256',to_date('01/13/2014', 'mm/dd/yyyy'), 'BLOCK225','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2290',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MUSKIE','15776',to_date('01/13/2014', 'mm/dd/yyyy'), 'MUSKIE','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2400',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MUSKIE','12498',to_date('01/13/2014', 'mm/dd/yyyy'), 'MUSKIE','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2400',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MUSKIE','15671',to_date('01/13/2014', 'mm/dd/yyyy'), 'MUSKIE','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2400',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MEAL14','15727',to_date('01/13/2014', 'mm/dd/yyyy'), 'MEAL14','21','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2180',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('BLOCK225','15453',to_date('01/13/2014', 'mm/dd/yyyy'), 'BLOCK225','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2290',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MUSKIE','25946',to_date('01/13/2014', 'mm/dd/yyyy'), 'MUSKIE','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2400',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MUSKIE','15417',to_date('01/13/2014', 'mm/dd/yyyy'), 'MUSKIE','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2400',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('BLOCK40','14123',to_date('01/13/2014', 'mm/dd/yyyy'), 'BLOCK40','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','560',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MUSKIE','14420',to_date('01/13/2014', 'mm/dd/yyyy'), 'MUSKIE','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2400',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('BLOCK25','12614',to_date('01/13/2014', 'mm/dd/yyyy'), 'BLOCK25','10','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','410',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MUSKIE','15393',to_date('01/13/2014', 'mm/dd/yyyy'), 'MUSKIE','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2400',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MUSKIE','12879',to_date('01/13/2014', 'mm/dd/yyyy'), 'MUSKIE','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2400',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MUSKIE','16168',to_date('01/13/2014', 'mm/dd/yyyy'), 'MUSKIE','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2400',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('BLOCK225','16282',to_date('01/13/2014', 'mm/dd/yyyy'), 'BLOCK225','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2290',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('BLOCK225','12598',to_date('01/13/2014', 'mm/dd/yyyy'), 'BLOCK225','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2290',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('BLOCK225','27350',to_date('01/13/2014', 'mm/dd/yyyy'), 'BLOCK225','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2290',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('BLOCK40','27655',to_date('01/13/2014', 'mm/dd/yyyy'), 'BLOCK40','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','560',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('BLOCK40','12707',to_date('01/13/2014', 'mm/dd/yyyy'), 'BLOCK40','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','560',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MUSKIE','13876',to_date('01/13/2014', 'mm/dd/yyyy'), 'MUSKIE','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2400',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('BLOCK225','15665',to_date('01/13/2014', 'mm/dd/yyyy'), 'BLOCK225','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2290',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MUSKIE','15731',to_date('01/13/2014', 'mm/dd/yyyy'), 'MUSKIE','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2400',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('80BLOCK','12857',to_date('01/13/2014', 'mm/dd/yyyy'), '80BLOCK','13','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','930',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MEAL14','21754',to_date('01/13/2014', 'mm/dd/yyyy'), 'MEAL14','21','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2180',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MUSKIE','15690',to_date('01/13/2014', 'mm/dd/yyyy'), 'MUSKIE','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2400',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MEAL14','15652',to_date('01/13/2014', 'mm/dd/yyyy'), 'MEAL14','21','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2180',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('80BLOCK','12778',to_date('01/13/2014', 'mm/dd/yyyy'), '80BLOCK','13','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','930',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MEAL14','15137',to_date('01/13/2014', 'mm/dd/yyyy'), 'MEAL14','21','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2180',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('BLOCK225','13408',to_date('01/13/2014', 'mm/dd/yyyy'), 'BLOCK225','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2290',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MUSKIE','15780',to_date('01/13/2014', 'mm/dd/yyyy'), 'MUSKIE','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2400',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MEAL14','14693',to_date('01/13/2014', 'mm/dd/yyyy'), 'MEAL14','21','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2180',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('BLOCK225','14530',to_date('01/13/2014', 'mm/dd/yyyy'), 'BLOCK225','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2290',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('BLOCK225','13736',to_date('01/13/2014', 'mm/dd/yyyy'), 'BLOCK225','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2290',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MEAL14','16126',to_date('01/13/2014', 'mm/dd/yyyy'), 'MEAL14','21','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2180',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MUSKIE','15742',to_date('01/13/2014', 'mm/dd/yyyy'), 'MUSKIE','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2400',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('BLOCK225','13822',to_date('01/13/2014', 'mm/dd/yyyy'), 'BLOCK225','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2290',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MUSKIE','16102',to_date('01/13/2014', 'mm/dd/yyyy'), 'MUSKIE','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2400',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('BLOCK225','15670',to_date('01/13/2014', 'mm/dd/yyyy'), 'BLOCK225','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2290',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MUSKIE','16038',to_date('01/13/2014', 'mm/dd/yyyy'), 'MUSKIE','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2400',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('BLOCK40','13388',to_date('01/13/2014', 'mm/dd/yyyy'), 'BLOCK40','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','560',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('BLOCK225','15545',to_date('01/13/2014', 'mm/dd/yyyy'), 'BLOCK225','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2290',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MEAL14','14359',to_date('01/13/2014', 'mm/dd/yyyy'), 'MEAL14','21','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2180',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('BLOCK225','16166',to_date('01/13/2014', 'mm/dd/yyyy'), 'BLOCK225','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2290',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MUSKIE','14188',to_date('01/13/2014', 'mm/dd/yyyy'), 'MUSKIE','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2400',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('80BLOCK','13065',to_date('01/13/2014', 'mm/dd/yyyy'), '80BLOCK','13','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','930',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('BLOCK225','15619',to_date('01/13/2014', 'mm/dd/yyyy'), 'BLOCK225','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2290',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MUSKIE','16041',to_date('01/13/2014', 'mm/dd/yyyy'), 'MUSKIE','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2400',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MEAL14','13355',to_date('01/13/2014', 'mm/dd/yyyy'), 'MEAL14','21','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2180',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MUSKIE','15954',to_date('01/13/2014', 'mm/dd/yyyy'), 'MUSKIE','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2400',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MEAL14','14909',to_date('01/13/2014', 'mm/dd/yyyy'), 'MEAL14','21','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2180',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MUSKIE','14691',to_date('01/13/2014', 'mm/dd/yyyy'), 'MUSKIE','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2400',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MEAL14','15981',to_date('01/13/2014', 'mm/dd/yyyy'), 'MEAL14','21','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2180',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('80BLOCK','14507',to_date('01/13/2014', 'mm/dd/yyyy'), '80BLOCK','13','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','930',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MEAL14','15793',to_date('01/13/2014', 'mm/dd/yyyy'), 'MEAL14','21','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2180',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('BLOCK40','13263',to_date('01/13/2014', 'mm/dd/yyyy'), 'BLOCK40','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','560',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('BLOCK225','14253',to_date('01/13/2014', 'mm/dd/yyyy'), 'BLOCK225','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2290',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MEAL14','15201',to_date('01/13/2014', 'mm/dd/yyyy'), 'MEAL14','21','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2180',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MEAL14','15819',to_date('01/13/2014', 'mm/dd/yyyy'), 'MEAL14','21','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2180',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MUSKIE','13488',to_date('01/13/2014', 'mm/dd/yyyy'), 'MUSKIE','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2400',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('80BLOCK','14140',to_date('01/13/2014', 'mm/dd/yyyy'), '80BLOCK','13','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','930',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MUSKIE','15461',to_date('01/13/2014', 'mm/dd/yyyy'), 'MUSKIE','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2400',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MUSKIE','14312',to_date('01/13/2014', 'mm/dd/yyyy'), 'MUSKIE','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2400',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MUSKIE','16183',to_date('01/13/2014', 'mm/dd/yyyy'), 'MUSKIE','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2400',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('BLOCK225','13754',to_date('01/13/2014', 'mm/dd/yyyy'), 'BLOCK225','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2290',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MEAL14','16267',to_date('01/13/2014', 'mm/dd/yyyy'), 'MEAL14','21','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2180',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MUSKIE','15132',to_date('01/13/2014', 'mm/dd/yyyy'), 'MUSKIE','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2400',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MUSKIE','25848',to_date('01/13/2014', 'mm/dd/yyyy'), 'MUSKIE','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2400',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MEAL14','15580',to_date('01/13/2014', 'mm/dd/yyyy'), 'MEAL14','21','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2180',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MEAL14','15444',to_date('01/13/2014', 'mm/dd/yyyy'), 'MEAL14','21','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2180',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MUSKIE','14576',to_date('01/13/2014', 'mm/dd/yyyy'), 'MUSKIE','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2400',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('BLOCK40','12670',to_date('01/13/2014', 'mm/dd/yyyy'), 'BLOCK40','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','560',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MUSKIE','15310',to_date('01/13/2014', 'mm/dd/yyyy'), 'MUSKIE','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2400',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MUSKIE','15914',to_date('01/13/2014', 'mm/dd/yyyy'), 'MUSKIE','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2400',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('80BLOCK','27250',to_date('01/13/2014', 'mm/dd/yyyy'), '80BLOCK','13','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','930',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MEAL14','14339',to_date('01/13/2014', 'mm/dd/yyyy'), 'MEAL14','21','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2180',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('BLOCK25','13151',to_date('01/13/2014', 'mm/dd/yyyy'), 'BLOCK25','10','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','410',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('BLOCK225','14411',to_date('01/13/2014', 'mm/dd/yyyy'), 'BLOCK225','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2290',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MUSKIE','15224',to_date('01/13/2014', 'mm/dd/yyyy'), 'MUSKIE','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2400',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MUSKIE','15213',to_date('01/13/2014', 'mm/dd/yyyy'), 'MUSKIE','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2400',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MUSKIE','15258',to_date('01/13/2014', 'mm/dd/yyyy'), 'MUSKIE','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2400',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MUSKIE','15852',to_date('01/13/2014', 'mm/dd/yyyy'), 'MUSKIE','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2400',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('BLOCK225','15190',to_date('01/13/2014', 'mm/dd/yyyy'), 'BLOCK225','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2290',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MUSKIE','15886',to_date('01/13/2014', 'mm/dd/yyyy'), 'MUSKIE','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2400',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MUSKIE','15184',to_date('01/13/2014', 'mm/dd/yyyy'), 'MUSKIE','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2400',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('80BLOCK','11954',to_date('01/13/2014', 'mm/dd/yyyy'), '80BLOCK','13','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','930',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('80BLOCK','13881',to_date('01/13/2014', 'mm/dd/yyyy'), '80BLOCK','13','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','930',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('80BLOCK','13005',to_date('01/13/2014', 'mm/dd/yyyy'), '80BLOCK','13','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','930',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('BLOCK225','15667',to_date('01/13/2014', 'mm/dd/yyyy'), 'BLOCK225','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2290',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('BLOCK225','13041',to_date('01/13/2014', 'mm/dd/yyyy'), 'BLOCK225','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2290',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('BLOCK225','15563',to_date('01/13/2014', 'mm/dd/yyyy'), 'BLOCK225','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2290',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('BLOCK225','15327',to_date('01/13/2014', 'mm/dd/yyyy'), 'BLOCK225','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2290',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MEAL14','16026',to_date('01/13/2014', 'mm/dd/yyyy'), 'MEAL14','21','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2180',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MEAL14','14245',to_date('01/13/2014', 'mm/dd/yyyy'), 'MEAL14','21','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2180',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MEAL14','14244',to_date('01/13/2014', 'mm/dd/yyyy'), 'MEAL14','21','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2180',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MEAL14','15591',to_date('01/13/2014', 'mm/dd/yyyy'), 'MEAL14','21','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2180',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MUSKIE','15755',to_date('01/13/2014', 'mm/dd/yyyy'), 'MUSKIE','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2400',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MEAL14','15658',to_date('01/13/2014', 'mm/dd/yyyy'), 'MEAL14','21','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2180',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MUSKIE','15232',to_date('01/13/2014', 'mm/dd/yyyy'), 'MUSKIE','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2400',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MUSKIE','12705',to_date('01/13/2014', 'mm/dd/yyyy'), 'MUSKIE','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2400',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MEAL14','15119',to_date('01/13/2014', 'mm/dd/yyyy'), 'MEAL14','21','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2180',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MEAL14','15805',to_date('01/13/2014', 'mm/dd/yyyy'), 'MEAL14','21','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2180',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MEAL14','12801',to_date('01/13/2014', 'mm/dd/yyyy'), 'MEAL14','21','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2180',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('80BLOCK','13309',to_date('01/13/2014', 'mm/dd/yyyy'), '80BLOCK','13','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','930',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MUSKIE','15477',to_date('01/13/2014', 'mm/dd/yyyy'), 'MUSKIE','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2400',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MUSKIE','15260',to_date('01/13/2014', 'mm/dd/yyyy'), 'MUSKIE','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2400',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('BLOCK225','12846',to_date('01/13/2014', 'mm/dd/yyyy'), 'BLOCK225','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2290',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MUSKIE','13310',to_date('01/13/2014', 'mm/dd/yyyy'), 'MUSKIE','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2400',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('BLOCK225','16014',to_date('01/13/2014', 'mm/dd/yyyy'), 'BLOCK225','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2290',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MEAL14','16288',to_date('01/13/2014', 'mm/dd/yyyy'), 'MEAL14','21','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2180',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('BLOCK225','13858',to_date('01/13/2014', 'mm/dd/yyyy'), 'BLOCK225','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2290',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MEAL14','15336',to_date('01/13/2014', 'mm/dd/yyyy'), 'MEAL14','21','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2180',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('80BLOCK','14242',to_date('01/13/2014', 'mm/dd/yyyy'), '80BLOCK','13','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','930',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MUSKIE','13851',to_date('01/13/2014', 'mm/dd/yyyy'), 'MUSKIE','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2400',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MUSKIE','15177',to_date('01/13/2014', 'mm/dd/yyyy'), 'MUSKIE','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2400',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MEAL14','15763',to_date('01/13/2014', 'mm/dd/yyyy'), 'MEAL14','21','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2180',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MEAL14','14423',to_date('01/13/2014', 'mm/dd/yyyy'), 'MEAL14','21','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2180',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MUSKIE','14378',to_date('01/13/2014', 'mm/dd/yyyy'), 'MUSKIE','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2400',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('BLOCK225','15599',to_date('01/13/2014', 'mm/dd/yyyy'), 'BLOCK225','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2290',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('BLOCK225','12886',to_date('01/13/2014', 'mm/dd/yyyy'), 'BLOCK225','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2290',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('BLOCK225','15617',to_date('01/13/2014', 'mm/dd/yyyy'), 'BLOCK225','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2290',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('80BLOCK','13324',to_date('01/13/2014', 'mm/dd/yyyy'), '80BLOCK','13','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','930',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('BLOCK225','12730',to_date('01/13/2014', 'mm/dd/yyyy'), 'BLOCK225','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2290',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('BLOCK225','12770',to_date('01/13/2014', 'mm/dd/yyyy'), 'BLOCK225','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2290',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MUSKIE','15087',to_date('01/13/2014', 'mm/dd/yyyy'), 'MUSKIE','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2400',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MUSKIE','15939',to_date('01/13/2014', 'mm/dd/yyyy'), 'MUSKIE','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2400',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MEAL14','13173',to_date('01/13/2014', 'mm/dd/yyyy'), 'MEAL14','21','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2180',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('BLOCK40','13863',to_date('01/13/2014', 'mm/dd/yyyy'), 'BLOCK40','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','560',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('BLOCK225','13477',to_date('01/13/2014', 'mm/dd/yyyy'), 'BLOCK225','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2290',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('80BLOCK','11182',to_date('01/13/2014', 'mm/dd/yyyy'), '80BLOCK','13','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','930',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MUSKIE','12428',to_date('01/13/2014', 'mm/dd/yyyy'), 'MUSKIE','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2400',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('BLOCK225','13891',to_date('01/13/2014', 'mm/dd/yyyy'), 'BLOCK225','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2290',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('BLOCK25','16117',to_date('01/13/2014', 'mm/dd/yyyy'), 'BLOCK25','10','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','410',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MEAL14','15267',to_date('01/13/2014', 'mm/dd/yyyy'), 'MEAL14','21','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2180',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MUSKIE','25294',to_date('01/13/2014', 'mm/dd/yyyy'), 'MUSKIE','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2400',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MUSKIE','27580',to_date('01/13/2014', 'mm/dd/yyyy'), 'MUSKIE','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2400',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('BLOCK225','15649',to_date('01/13/2014', 'mm/dd/yyyy'), 'BLOCK225','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2290',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MUSKIE','15719',to_date('01/13/2014', 'mm/dd/yyyy'), 'MUSKIE','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2400',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MEAL14','12775',to_date('01/13/2014', 'mm/dd/yyyy'), 'MEAL14','21','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2180',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MUSKIE','15811',to_date('01/13/2014', 'mm/dd/yyyy'), 'MUSKIE','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2400',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MEAL14','14895',to_date('01/13/2014', 'mm/dd/yyyy'), 'MEAL14','21','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2180',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MUSKIE','14270',to_date('01/13/2014', 'mm/dd/yyyy'), 'MUSKIE','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2400',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MEAL14','15611',to_date('01/13/2014', 'mm/dd/yyyy'), 'MEAL14','21','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2180',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('BLOCK225','15606',to_date('01/13/2014', 'mm/dd/yyyy'), 'BLOCK225','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2290',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MEAL14','14296',to_date('01/13/2014', 'mm/dd/yyyy'), 'MEAL14','21','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2180',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MUSKIE','27349',to_date('01/13/2014', 'mm/dd/yyyy'), 'MUSKIE','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2400',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MUSKIE','15396',to_date('01/13/2014', 'mm/dd/yyyy'), 'MUSKIE','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2400',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('BLOCK225','15613',to_date('01/13/2014', 'mm/dd/yyyy'), 'BLOCK225','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2290',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MUSKIE','15866',to_date('01/13/2014', 'mm/dd/yyyy'), 'MUSKIE','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2400',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('80BLOCK','14834',to_date('01/13/2014', 'mm/dd/yyyy'), '80BLOCK','13','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','930',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MUSKIE','15738',to_date('01/13/2014', 'mm/dd/yyyy'), 'MUSKIE','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2400',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MUSKIE','12972',to_date('01/13/2014', 'mm/dd/yyyy'), 'MUSKIE','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2400',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MUSKIE','15270',to_date('01/13/2014', 'mm/dd/yyyy'), 'MUSKIE','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2400',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MEAL14','12956',to_date('01/13/2014', 'mm/dd/yyyy'), 'MEAL14','21','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2180',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MEAL14','14207',to_date('01/13/2014', 'mm/dd/yyyy'), 'MEAL14','21','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2180',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('BLOCK40','12926',to_date('01/13/2014', 'mm/dd/yyyy'), 'BLOCK40','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','560',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MUSKIE','25940',to_date('01/13/2014', 'mm/dd/yyyy'), 'MUSKIE','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2400',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MEAL14','15822',to_date('01/13/2014', 'mm/dd/yyyy'), 'MEAL14','21','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2180',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MEAL14','15816',to_date('01/13/2014', 'mm/dd/yyyy'), 'MEAL14','21','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2180',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MUSKIE','15677',to_date('01/13/2014', 'mm/dd/yyyy'), 'MUSKIE','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2400',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('BLOCK40','15565',to_date('01/13/2014', 'mm/dd/yyyy'), 'BLOCK40','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','560',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MUSKIE','27153',to_date('01/13/2014', 'mm/dd/yyyy'), 'MUSKIE','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2400',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MUSKIE','14005',to_date('01/13/2014', 'mm/dd/yyyy'), 'MUSKIE','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2400',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MEAL14','15501',to_date('01/13/2014', 'mm/dd/yyyy'), 'MEAL14','21','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2180',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MUSKIE','15209',to_date('01/13/2014', 'mm/dd/yyyy'), 'MUSKIE','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2400',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('BLOCK225','15845',to_date('01/13/2014', 'mm/dd/yyyy'), 'BLOCK225','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2290',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('BLOCK225','15339',to_date('01/13/2014', 'mm/dd/yyyy'), 'BLOCK225','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2290',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MUSKIE','15663',to_date('01/13/2014', 'mm/dd/yyyy'), 'MUSKIE','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2400',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MUSKIE','12374',to_date('01/13/2014', 'mm/dd/yyyy'), 'MUSKIE','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2400',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('BLOCK225','14212',to_date('01/13/2014', 'mm/dd/yyyy'), 'BLOCK225','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2290',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MEAL14','15356',to_date('01/13/2014', 'mm/dd/yyyy'), 'MEAL14','21','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2180',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MEAL14','15718',to_date('01/13/2014', 'mm/dd/yyyy'), 'MEAL14','21','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2180',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('BLOCK225','14791',to_date('01/13/2014', 'mm/dd/yyyy'), 'BLOCK225','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2290',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('BLOCK225','15225',to_date('01/13/2014', 'mm/dd/yyyy'), 'BLOCK225','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2290',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MEAL14','15034',to_date('01/13/2014', 'mm/dd/yyyy'), 'MEAL14','21','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2180',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MUSKIE','15449',to_date('01/13/2014', 'mm/dd/yyyy'), 'MUSKIE','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2400',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MEAL14','26475',to_date('01/13/2014', 'mm/dd/yyyy'), 'MEAL14','21','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2180',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('BLOCK40','15730',to_date('01/13/2014', 'mm/dd/yyyy'), 'BLOCK40','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','560',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('80BLOCK','13113',to_date('01/13/2014', 'mm/dd/yyyy'), '80BLOCK','13','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','930',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('BLOCK225','15326',to_date('01/13/2014', 'mm/dd/yyyy'), 'BLOCK225','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2290',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MUSKIE','15899',to_date('01/13/2014', 'mm/dd/yyyy'), 'MUSKIE','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2400',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('80BLOCK','14583',to_date('01/13/2014', 'mm/dd/yyyy'), '80BLOCK','13','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','930',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MEAL14','15496',to_date('01/13/2014', 'mm/dd/yyyy'), 'MEAL14','21','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2180',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('BLOCK225','15717',to_date('01/13/2014', 'mm/dd/yyyy'), 'BLOCK225','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2290',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MEAL14','16021',to_date('01/13/2014', 'mm/dd/yyyy'), 'MEAL14','21','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2180',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MEAL14','15536',to_date('01/13/2014', 'mm/dd/yyyy'), 'MEAL14','21','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2180',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MUSKIE','14696',to_date('01/13/2014', 'mm/dd/yyyy'), 'MUSKIE','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2400',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MUSKIE','12916',to_date('01/13/2014', 'mm/dd/yyyy'), 'MUSKIE','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2400',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MUSKIE','13730',to_date('01/13/2014', 'mm/dd/yyyy'), 'MUSKIE','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2400',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('BLOCK225','15631',to_date('01/13/2014', 'mm/dd/yyyy'), 'BLOCK225','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2290',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MEAL14','16023',to_date('01/13/2014', 'mm/dd/yyyy'), 'MEAL14','21','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2180',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('BLOCK40','15553',to_date('01/13/2014', 'mm/dd/yyyy'), 'BLOCK40','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','560',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('BLOCK225','20660',to_date('01/13/2014', 'mm/dd/yyyy'), 'BLOCK225','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2290',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('BLOCK225','15388',to_date('01/13/2014', 'mm/dd/yyyy'), 'BLOCK225','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2290',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MEAL14','15329',to_date('01/13/2014', 'mm/dd/yyyy'), 'MEAL14','21','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2180',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('BLOCK40','13787',to_date('01/13/2014', 'mm/dd/yyyy'), 'BLOCK40','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','560',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('80BLOCK','13721',to_date('01/13/2014', 'mm/dd/yyyy'), '80BLOCK','13','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','930',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('BLOCK225','12355',to_date('01/13/2014', 'mm/dd/yyyy'), 'BLOCK225','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2290',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('BLOCK25','12086',to_date('01/13/2014', 'mm/dd/yyyy'), 'BLOCK25','10','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','410',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MEAL14','15931',to_date('01/13/2014', 'mm/dd/yyyy'), 'MEAL14','21','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2180',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MUSKIE','12403',to_date('01/13/2014', 'mm/dd/yyyy'), 'MUSKIE','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2400',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MUSKIE','14136',to_date('01/13/2014', 'mm/dd/yyyy'), 'MUSKIE','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2400',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MUSKIE','16190',to_date('01/13/2014', 'mm/dd/yyyy'), 'MUSKIE','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2400',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MEAL14','15558',to_date('01/13/2014', 'mm/dd/yyyy'), 'MEAL14','21','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2180',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MUSKIE','15100',to_date('01/13/2014', 'mm/dd/yyyy'), 'MUSKIE','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2400',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('BLOCK40','15748',to_date('01/13/2014', 'mm/dd/yyyy'), 'BLOCK40','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','560',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MEAL14','15579',to_date('01/13/2014', 'mm/dd/yyyy'), 'MEAL14','21','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2180',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MUSKIE','16024',to_date('01/13/2014', 'mm/dd/yyyy'), 'MUSKIE','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2400',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MUSKIE','14279',to_date('01/13/2014', 'mm/dd/yyyy'), 'MUSKIE','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2400',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('BLOCK225','12580',to_date('01/13/2014', 'mm/dd/yyyy'), 'BLOCK225','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2290',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('BLOCK225','16066',to_date('01/13/2014', 'mm/dd/yyyy'), 'BLOCK225','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2290',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MUSKIE','25938',to_date('01/13/2014', 'mm/dd/yyyy'), 'MUSKIE','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2400',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('BLOCK40','12533',to_date('01/13/2014', 'mm/dd/yyyy'), 'BLOCK40','8','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','560',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');
    do_insert('MEAL14','27270',to_date('01/13/2014', 'mm/dd/yyyy'), 'MEAL14','21','13-14Returning',to_date('05/09/2014', 'mm/dd/yyyy'), 'Mall','2180',to_date('01/13/2014', 'mm/dd/yyyy'), '','14S','14S');    
    commit;
    dbms_output.put_line('Inserted '||g_call_count||' records.');
end;

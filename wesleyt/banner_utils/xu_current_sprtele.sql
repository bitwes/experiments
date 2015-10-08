create or replace view xu_current_sprtele as
-------------------------------------------------------------------------------
--This view contains the same information as sprtele but only the rows that are
--currently active.  This allows you to get the correct telephone record using 
--only the pidm, tele_code, and atyp_code.

--Telephone Number Storage Overview:
--  You can have as many telephone numbers as you want.  They can all have the 
--  same type and all be active and all be your primary.  The sprtele table
--  and the form have very few restrictions on the data that is entered.
--
--  For this reason, if you want to get one phone number of a given type the best
--  you can do is guess which one is correct.  This view does that.  It will return
--  you the 
--  You can have only one phone number with a given tele_code.  You can have 
--  many with a given atyp code.  This gives the awkward scenario where you 
--  can only have one cell phone regardless of whether it is for business
--  or home use.  This also makes querying somewhat odd.  If you want the 
--  home landline you could pull back just using a tele code of 'HM' (since it wouldn't
--  make sense to have a HM tele_code and a BU atyp_code for example).  If you want
--  home cell phone you have to pull back a tele_code of 'CELL' and a atyp_code
--  of 'HM' since a person could have other types of cell phones.  When you can,
--  you should supply both, if for no other reason than to make it clear what you
--  expect to get back.
--
--This view uses xu_settable_date to allow you to change the current date for 
--testing purposes.
--
--The rows are ordered by pidm and  primary_ind, ensuring that any rows with that value
--set will be first per pidm.  This allows you to do a rownum = 1 if you are 
--trying to get just a single phone for a specific atype_code.  
--
--<b>History</b><hr>
--<pre>
--07/17/13 wesleyt      Maxient Project
--  Created
--</pre><hr>
-------------------------------------------------------------------------------
    select --decode (row_number() over(partition by sprtele_pidm, sprtele_tele_code order by sprtele_pidm, sprtele_seqno desc, sprtele_tele_code), 1, 'Y', 'N') best_match, 
           row_number() over(partition by 
                                    sprtele_pidm, 
                                    sprtele_tele_code 
                                 order by 
                                    sprtele_pidm, sprtele_tele_code, nvl(sprtele_primary_ind, 'Z'),  sprtele_seqno desc) tele_ranking, 
           row_number() over(partition by 
                                    sprtele_pidm, 
                                    sprtele_atyp_code 
                                 order by 
                                    sprtele_pidm, sprtele_atyp_code, nvl(sprtele_primary_ind, 'Z'),  sprtele_seqno desc) atyp_ranking, 
           sprtele.*
      from sprtele
/*
            --Must distinct so that you only get one row back when there
            --are multiples per pidm/atyp_code/tele_code because of the 
            --status_ind.  Otherwise, if there are 4, you get 4 records 
            --all with the highest seqno.

      join (select distinct sprtele_pidm pidm,
                   sprtele_tele_code tele_code,
                   sprtele_atyp_code atyp_code,
                   max(sprtele_seqno) over(partition by sprtele_pidm, sprtele_tele_code, sprtele_atyp_code) seqno
              from sprtele
             where sprtele_status_ind is null) tele_max_seqno
        on sprtele_pidm = tele_max_seqno.pidm

       and sprtele_tele_code = tele_max_seqno.tele_code
       and sprtele_atyp_code = tele_max_seqno.atyp_code
       and sprtele_seqno = tele_max_seqno.seqno
*/       
       where sprtele_status_ind is null
             --This view is meant to contain phone numbers for export and display.
             --if the number is unlisted we don't want to show it.
         and sprtele_unlist_ind is null
--ADD THIS AFTER YOU MAKE A TEST         and sprtele_unlist_ind is null
           --primary_ind is either NULL or 'Y', this puts the 
           --primary ones first since there can be multiples.
     order by sprtele_pidm, nvl(sprtele_primary_ind, 'Z'), sprtele_seqno desc;

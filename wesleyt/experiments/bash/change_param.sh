#!/bin/bash

#below line commented out since it was done in ticket 378, included
#so that all the values are in one place for future reference
#echo 'housing|zsthosx_add_new_apps|app_term|201209' | $XU_HOME/general/ZGBPARM_new_parm_value.pl

echo 'housing|zsthosx_add_new_apps|rms_app_year|12-13New' | $XU_HOME/general/ZGBPARM_new_parm_value.pl
echo 'housing|zsthosx_add_new_apps|rms_app_yr_desc|2012-2013 New Students' | $XU_HOME/general/ZGBPARM_new_parm_value.pl
echo 'housing|rms_database_export|earliest_moveout_date|20-AUG-12' | $XU_HOME/general/ZGBPARM_new_parm_value.pl
/*
select 'SELECT * from '||table_name||';' from all_tables where table_name like ('SHP%');

SELECT * from SHP_FILTER_MST;
SELECT * from SHP_KEY_MST;
SELECT * from SHP_LOG_DTL;
SELECT * from SHP_NEXT_CD_DTL;
SELECT * from SHP_NEXT_ID_DTL;
SELECT * from SHP_NEXT_ID_MST;
SELECT * from SHP_PASSPORT_MST;
SELECT * from SHP_PREF_DTL;
SELECT * from SHP_PROXY_DTL;
SELECT * from SHP_SCRIPT_DTL;
SELECT * from SHP_SCRIPT_MST;
SELECT * from SHP_SERVER_MST;
SELECT * from SHP_FILTER_DTL;
*/

SELECT * from SHP_GROUP_MST;
SELECT * from SHP_SERVICE_MST;
SELECT * from SHP_SETTINGS_MST;
SELECT * from SHP_USER_MST where trim(shp_key_list) is not null;


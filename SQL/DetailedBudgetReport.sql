-- SQL used to generate report of budget information that can be droped to
--excel.  Currently (02/20/2017) There is no way to do this within the system.
--keep in mind this will report on EVERY BUDGET TYPE.  If you want to limit
--which budget types are reported you will need to add that to the sql below.

--Created by Arshay "Shay" Sloan @ GCISD
GO
SELECT * FROM OPENQUERY ( SKYWARD_FINANCE,
'
SELECT  DISTINCT Account_Info."FFAMAM-EDITED-ACCT",
		COALESCE (Detail_Info."FFAMDB-LINE-NBR",''''),
		COALESCE (Cast(Detail_Info."ffamdb-desc" AS CHAR(2000)),''''),
		COALESCE (Detail_Info."FFAMDB-AMOUNT",Bud_Info."FFAMBL-AMOUNT"),
		Bud_Info."ffambl-fis-year",
		Account_Info."FFAMAm-DIM-1",
		Account_Info."FFAMAm-DIM-3",
		Account_Info."FFAMAm-DIM-4",
		Account_Info."FFAMAm-DIM-5",
		Account_Info."FFAMAm-DIM-6",
		Account_Info."FFAMAm-DIM-7",
		Account_Info."FFAMAm-DIM-8",
		Account_Info."FFAMAm-DIM-9",
		Account_Info."FFAMAm-DIM-10"
FROM   "SKYWARD"."PUB"."ffambl-budget-level" as Bud_Info
INNER JOIN
		"SKYWARD"."PUB"."FFAMAM-ACCT-MST" AS Account_Info
ON		Account_Info."FFAMAM-ACCT-ID" = Bud_Info."FFAMAM-ACCT-ID"
LEFT JOIN "SKYWARD"."PUB"."FFAMDB-DTL-BUDGET" AS Detail_Info
ON		Account_Info."FFAMAM-ACCT-ID" = Detail_Info."FFAMAM-ACCT-ID"
AND		Detail_Info."FFAMDB-FIS-YEAR" = Bud_Info."ffambl-fis-year"
WHERE Bud_Info."ffambl-fis-year" = ''2017''
-- This is used to exclude payroll acounts from this report.
AND Account_Info."FFAMAM-DIM-4" NOT IN (''6116'', ''6117'', ''6119'', ''6127'', ''6129'',''6130'',''6131'',''6132'',''6133'',''6134'',''6135'',''6136'',''6137'',''6138'',''6139'',''6140'',''6141'',''6142'',''6143'',''6144'',''6145'',''6146'',''6147'',''6148'',''6149'' )
and (Account_Info."FFAMAM-DIM-4" <> ''6128'' and Account_Info."FFAMAM-DIM-9" <> ''039'')
and ((Account_Info."FFAMAM-DIM-5" = ''FC'' and Account_Info."FFAMAM-DIM-9" = ''738'') OR(Account_Info."FFAMAM-DIM-5" <> ''FC''))
AND Account_Info."FFAMAM-DIM-9" = ''738''
ORDER BY 1, 2, 4
'
)

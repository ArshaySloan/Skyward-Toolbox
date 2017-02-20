-- SQL used to generate report of budget information that can be droped to
--excel.  Currently (02/20/2017) There is no way to do this within the system.

--2/20/2017 Added Nested SQL to get current Database
--          Added statment to only report on selected budget types PR#1 PR#2

--Created by Arshay "Shay" Sloan @ GCISD
GO
SELECT * FROM OPENQUERY ( SKYWARD_FINANCE,
'
SELECT  DISTINCT Account_Info."FFAMAM-EDITED-ACCT" as ''Account Code'',
		COALESCE (CAST(Detail_Info."FFAMDB-LINE-NBR" as INT),'''') as ''Line Item'',
--CASE needed on skyward fields that have a varying length.
		COALESCE (
				REPLACE(
				  REPLACE(Cast(Detail_Info."ffamdb-desc" AS CHAR(2000)),CHAR(12),CHAR(32)
						)
				,CHAR(10),CHAR(32))
		,'''') as ''Detailed Description'',
		Bud_Info."FFAMBL-AMOUNT" as ''Account Total'',
		COALESCE (Detail_Info."FFAMDB-AMOUNT", 0.00) as ''Detail Amount'',
		CASE Bud_Info."FFAMBC-BUDGET-TYPE"
			WHEN ''PR#1'' THEN ''PRIORITY 1''
			WHEN ''PR#2'' THEN ''PRIORITY 2''
		END as ''Budget Type''	,
		Bud_Info."ffambl-fis-year" as ''Year'',
		Account_Info."FFAMAm-DIM-1" as ''Fund'',
		SUBSTRING(Account_Info."FFAMAM-EDITED-ACCT",5,1) as ''Type'',
		Account_Info."FFAMAm-DIM-3" as ''Function'',
		Account_Info."FFAMAm-DIM-4" as ''Object'',
		Account_Info."FFAMAm-DIM-5" as ''Sub Object'',
		Account_Info."FFAMAm-DIM-6" as ''Organization'',
		Account_Info."FFAMAm-DIM-7" as ''Fiscal Year'',
		Account_Info."FFAMAm-DIM-8" as ''Program Intent'',
		Account_Info."FFAMAm-DIM-9" as ''Owner'',
		Account_Info."FFAMAm-DIM-10" as ''Activity''
FROM   "SKYWARD"."PUB"."ffambl-budget-level" as Bud_Info
INNER JOIN
		"SKYWARD"."PUB"."FFAMAM-ACCT-MST" AS Account_Info
ON		Account_Info."FFAMAM-ACCT-ID" = Bud_Info."FFAMAM-ACCT-ID"
LEFT JOIN "SKYWARD"."PUB"."FFAMDB-DTL-BUDGET" AS Detail_Info
ON		Account_Info."FFAMAM-ACCT-ID" = Detail_Info."FFAMAM-ACCT-ID"
AND		Detail_Info."FFAMDB-FIS-YEAR" = Bud_Info."ffambl-fis-year"
WHERE Bud_Info."ffambl-fis-year" = (SELECT MAX(b."ffambl-fis-year") from "SKYWARD"."PUB"."ffambl-budget-level" as b)
-- Unique exclusion per district (Excluding payroll accounts)
AND Account_Info."FFAMAM-DIM-4" NOT IN (''6116'', ''6117'', ''6119'', ''6127'', ''6129'',''6130'',''6131'',''6132'',''6133'',''6134'',''6135'',''6136'',''6137'',''6138'',''6139'',''6140'',''6141'',''6142'',''6143'',''6144'',''6145'',''6146'',''6147'',''6148'',''6149'' )
-- Unique exclusion per district (This ownercode dosn't budget this object code)
and (Account_Info."FFAMAM-DIM-4" <> ''6128'' and Account_Info."FFAMAM-DIM-9" <> ''039'')
--  Unique exclusion per district (Only this owner code budgets for Sub-Object FC)
and ((Account_Info."FFAMAM-DIM-5" = ''FC'' and Account_Info."FFAMAM-DIM-9" = ''738'') OR(Account_Info."FFAMAM-DIM-5" <> ''FC''))
--When exporting this to crystal the 101 with a paramater for users owner code.
AND Account_Info."FFAMAM-DIM-9" = ''101''
AND Bud_Info."FFAMBC-BUDGET-TYPE" IN (''PR#1'', ''PR#2'')
ORDER BY 6, 1, 2, 4
'
)

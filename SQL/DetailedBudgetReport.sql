-- SQL used to generate report of budget information that can be droped to
--excel.  Currently (02/20/2017) There is no way to do this within the system.

--2/20/2017 Added Nested SQL to get current Database
--          Added statment to only report on selected budget types PR#1 PR#2

--Created by Arshay "Shay" Sloan @ GCISD

--Open query used for easy transplanting into crystal reports.
--When exporting make sure to remove the hard coded Owner Code to
--replace with a parammeter.  And remove all double single quotes with single
--quotes

-- For example you will need to change ''Account Code'' to 'Acount Code'

GO
SELECT * FROM OPENQUERY ( [SKYWARD FINANCE],
'
SELECT  DISTINCT Account_Info."FFAMAM-EDITED-ACCT" as ''Account Code'',
		COALESCE (CAST(Detail_Info."FFAMDB-LINE-NBR" as INT),'''') as ''Line Item'',
--Since Progress used fuzzy definitions for data we have to cast this into a
--char2000 field.
		COALESCE (
				REPLACE(
				  REPLACE(Cast(Detail_Info."ffamdb-desc" AS CHAR(2000)),CHAR(12),CHAR(32)
						)
				,CHAR(10),CHAR(32))
		,'''') as ''Detailed Description'',
--At our district we use two budget types, replace / change this info for your
--district.
		CASE Bud_Info."FFAMBC-BUDGET-TYPE"
		when ''PR#1'' THEN ''Priority 1''
		when ''PR#2'' THEN ''Priority 2''
		END AS ''Budget Type'',
		MAX(CASE COALESCE (CAST(Detail_Info."FFAMDB-LINE-NBR" as INT),'''')
			WHEN ''1''
				THEN COALESCE (Bud_Info."FFAMBL-AMOUNT", 0)
			WHEN ''''
				THEN COALESCE (Bud_Info."FFAMBL-AMOUNT", 0)
			ELSE 0
		END)	as ''Account Total'',
--Next two lines are used to always display totals, weather its in the summary
--record or the detailed record.
		MAX(CASE Bud_Info."FFAMBC-BUDGET-TYPE"
				when ''PR#1''
					THEN CASE (COALESCE (Detail_Info."FFAMDB-AMOUNT", 0) )
								WHEN 0
									THEN COALESCE (Bud_Info."FFAMBL-AMOUNT", 0)
								ELSE COALESCE (Detail_Info."FFAMDB-AMOUNT", 0)
								END
			    else 0
			end) as ''Priority 1'',
		MAX(CASE Bud_Info."FFAMBC-BUDGET-TYPE"
				when ''PR#2''
					THEN CASE (COALESCE (Detail_Info."FFAMDB-AMOUNT", 0) )
								WHEN 0
									THEN COALESCE (Bud_Info."FFAMBL-AMOUNT", 0)
								ELSE COALESCE (Detail_Info."FFAMDB-AMOUNT", 0)
								END
			    else 0
			end) as ''Priority 2'',
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
AND		Bud_Info."FFAMBC-BUDGET-TYPE" = Detail_Info."FFAMDB-BUDGET-TYPE"


WHERE  Bud_Info."ffambl-fis-year" = (SELECT MAX(b."ffambl-fis-year") from "SKYWARD"."PUB"."ffambl-budget-level" as b)
--<User Requested parammeter to exclude from report
AND Account_Info."FFAMAM-DIM-4" NOT IN (''6116'', ''6117'', ''6119'', ''6127'', ''6129'',''6130'',''6131'',''6132'',''6133'',''6134'',''6135'',''6136'',''6137'',''6138'',''6139'',''6140'',''6141'',''6142'',''6143'',''6144'',''6145'',''6146'',''6147'',''6148'',''6149'' )
and ((Account_Info."FFAMAM-DIM-4" <> ''6128'' and Account_Info."FFAMAM-DIM-9" <> ''039'') OR (Account_Info."FFAMAM-DIM-4" <> ''6128''))
and ((Account_Info."FFAMAM-DIM-5" = ''FC'' and Account_Info."FFAMAM-DIM-9" = ''738'') OR(Account_Info."FFAMAM-DIM-5" <> ''FC''))
-->
--Used to display own ownercode showen below.  When exporting to crystal
--make sure to change this field to a parammeter
AND Account_Info."FFAMAM-DIM-9" = ''930''
--At our district we use two budget types, replace / change this info for your
--district.
AND Bud_Info."FFAMBC-BUDGET-TYPE" IN (''PR#1'',''PR#2'')
GROUP BY  Account_Info."FFAMAM-EDITED-ACCT", Detail_Info."FFAMDB-LINE-NBR", Detail_Info."ffamdb-desc", Bud_Info."FFAMBC-BUDGET-TYPE", Bud_Info."ffambl-fis-year" , 		Account_Info."FFAMAm-DIM-1", 		Account_Info."FFAMAM-EDITED-ACCT", 		Account_Info."FFAMAm-DIM-3", 		Account_Info."FFAMAm-DIM-4", Account_Info."FFAMAm-DIM-5", Account_Info."FFAMAm-DIM-6", Account_Info."FFAMAm-DIM-7", Account_Info."FFAMAm-DIM-8", Account_Info."FFAMAm-DIM-9", Account_Info."FFAMAm-DIM-10"

ORDER BY 4, 1, 2
'
)

-- SQL used to report on demographic informaiton in skyward


--Created by Arshay "Shay" Sloan @ GCISD
--Distinct is a must to exclude duplicate entries for split assignments
SELECT DISTINCT Assignment_SW.[LAST-NAME] + ', ' + Assignment_SW.[FIRST-NAME] AS 'Name',
Name_SW.[NALPHAKEY] AS 'Namekey',
Plan_SW.[HPMPLN-DESC] AS 'Plan',
Assignment_SW.[haadsc-desc-asn] AS 'Assignment',
Assignment_SW.[haadsc-desc-pos] AS 'Position',
Assignment_SW.[HAABLD-BLD-DESC] AS 'Location',
CASE Name_SW.[ETHNICITY-HISP-X]
WHEN '1' THEN 'Y'
ELSE 'N'
END AS 'Hispanic/Latino?',
CASE Name_SW.[RACE-CODE]
WHEN '1' THEN 'AMERICAN INDIAN'
WHEN '2' THEN 'ASIAN/PACIFIC'
WHEN '3' THEN 'BLACK/NOT HISP'
WHEN '4' THEN 'HISPANIC'
WHEN '5' THEN 'WHITE,NOT HISP'
ELSE 'NO CODE FOUND'
END AS 'Local Race Code',
--Race Flags are kept in one field in 5 bites
CASE SUBSTRING (Name_SW.[FED-RACE-FLAGS], 1,1)
WHEN '0' THEN 'N'
WHEN '1' THEN 'Y'
END AS 'American Indian or Alaskan Native',

CASE SUBSTRING (Name_SW.[FED-RACE-FLAGS], 2,1)
WHEN '0' THEN 'N'
WHEN '1' THEN 'Y'
END AS 'Asian',

CASE SUBSTRING (Name_SW.[FED-RACE-FLAGS], 3,1)
WHEN '0' THEN 'N'
WHEN '1' THEN 'Y'
END AS 'Black or African American',

CASE SUBSTRING (Name_SW.[FED-RACE-FLAGS], 4,1)
WHEN '0' THEN 'N'
WHEN '1' THEN 'Y'
END AS 'Native Hawaiian or Other Pacific Islander',

CASE SUBSTRING (Name_SW.[FED-RACE-FLAGS], 5,1)
WHEN '0' THEN 'N'
WHEN '1' THEN 'Y'
END AS 'White'

FROM [SKYWARD_FINANCE].[SKYWARD].[PUB].[HPMASN-ASSIGNMENTS] Assignment_SW
INNER JOIN [SKYWARD_FINANCE].[SKYWARD].[PUB].[HPMPLN-PLAN] Plan_SW
ON Assignment_SW.[HPMPLN-ID] = Plan_SW.[HPMPLN-ID]
--Nested query used to always pull the most current active plan)
AND Plan_SW.[HPMPLN-ID] = (SELECT MAX([PLANS].[HPMPLN-ID]) from [SKYWARD_FINANCE].[SKYWARD].[PUB].[hpmpln-plan] PLANS WHERE [PLANS].[HPMPLN-SN-PLAN-X] = 0)
--GETDATE() used to pull current date and convert to skyward format
AND Assignment_SW.[HPMASN-END-DATE] >= CONVERT(VARCHAR(10), GETDATE(), 101)
INNER JOIN [SKYWARD_FINANCE].[SKYWARD].[PUB].[NAME] Name_SW
ON Name_SW.[NAME-ID] = Assignment_SW.[NAME-ID]
INNER JOIN [SKYWARD_FINANCE].[SKYWARD].[PUB].[HAAPRO-PROFILE] Profile_SW
	on Profile_SW.[Name-ID] = Assignment_SW.[Name-ID]
--Active employees only
	AND Profile_SW.[HAAPRO-ACTIVE] = 1
--Used to exclude stipends which are not consider employees.
WHERE Assignment_SW.[haadsc-desc-pos] NOT LIKE '%STIPEND%'
ORDER BY 6,5,4,1

-- SQL used to search for PO's based on description for the whole po or line item.
-- This example is looking for PO with the word "Java" or "Jcreator" anywhere in the line
-- if you want a hard search term remove the %'s

--Created by Arshay "Shay" Sloan @ GCISD


--OPENQUERY used for testing to see if it performance better. No definitive answer yet.
GO
SELECT * FROM OPENQUERY ( SKYWARD_FINANCE,
'
SELECT     po_master."FFPOPM-PO-NBR",
           po_master."FFPOPM-DESC",
           Cast("SKYWARD"."PUB"."FFPOPD-PO-DTL"."FFPOPD-DESC" AS CHAR(256)),
           po_dtl."FFPOPD-AMOUNT",
           po_master."FFPOPM-PO-GRP",
           name_sw."LAST-NAME",
           emp_name."NALPHAKEY"
FROM       "SKYWARD"."PUB"."FFPOPM-PO-MASTER" AS po_master
INNER JOIN "SKYWARD"."PUB"."NAME"             AS name_sw
ON         name_sw."NALPHAKEY" = po_master."NALPHAKEY"
INNER JOIN "SKYWARD"."PUB"."NAME" AS emp_name
ON         emp_name."Name-ID" = po_master."FFPOPM-ENT-BY-NAME-ID"
INNER JOIN "SKYWARD"."PUB"."FFPOPD-PO-DTL" AS po_dtl
ON         po_master."FFPOPM-ID" = po_dtl."FFPOPM-ID"
WHERE      po_master."FFPOPM-STATUS" = ''h''
AND        (
                      po_master."FFPOPM-DESC" LIKE ''%Java%''
           OR         cast(po_dtl."FFPOPD-DESC" AS char(256)) LIKE ''%Java%''
           OR         po_master."FFPOPM-DESC" LIKE ''%Jcreator%''
           OR         cast(po_dtl."FFPOPD-DESC" AS char(256)) LIKE ''%Jcreator%'')
ORDER BY   1
'
)

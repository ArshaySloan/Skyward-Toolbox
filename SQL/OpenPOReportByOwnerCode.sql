GO
SELECT * FROM OPENQUERY ( [SKYWARD FINANCE],
'
SELECT   DISTINCT "FFPORC_RECEIVING_FILE"."FFPOPD-LINE-NBR" as ''Recieving Line Number'',
         "FFPORC_RECEIVING_FILE"."FFPORC-QTY",
         "FFPOPM_PO_MASTER"."FFPOPM-PO-NBR",
         "FFPOPM_PO_MASTER"."FFPOPM-AMOUNT",
         "FFPOPM_PO_MASTER"."FFPOPM-ENT-DATE",
         "FFPOPD_PO_DTL"."FFPOPD-LINE-NBR",
         "FFPOPD_PO_DTL"."FFPOPD-QTY",
         "FFPOPD_PO_DTL"."FFPOPD-AMOUNT",
         "FFAPID_INVOICE_DTL"."FFAPID-LINE-NBR" AS ''Invoice Line Number'',
         "FFAPID_INVOICE_DTL"."FFAPID-AMOUNT" as ''Invoice Amount'',
         "FFPOPM_PO_MASTER"."NALPHAKEY" as ''PO Master Name Alpha'',
         "FFPORC_RECEIVING_FILE"."FFPORC-RECEIVED-DATE",
         "FFPORC_RECEIVING_FILE"."FFPORC-BP-RCV-AMT",
         "NAME1"."NALPHAKEY",
		COALESCE (
				REPLACE(
				  REPLACE(Cast("FFPOPD_PO_DTL"."FFPOPD-DESC" AS CHAR(2000)),CHAR(12),CHAR(32)
						)
				,CHAR(10),CHAR(32))
		,'''') as ''Detailed Description'',
         --"FFPOPD_PO_DTL"."FFPOPD-DESC",
         "FFPOPD_PO_DTL"."FFPOPD-MERCH-NARR",
         "FFPOPM_PO_MASTER"."FFPOPM-STATUS",
         "NAME_SHIP_TO"."NALPHAKEY" as ''Ship To Name Alpha'',
         "FFAMAM_ACCT_MST"."FFAMAM-EDITED-ACCT"
FROM     "SKYWARD"."PUB"."FFPORC-RECEIVING-FILE" "FFPORC_RECEIVING_FILE",
         "SKYWARD"."PUB"."FFPOPM-PO-MASTER" "FFPOPM_PO_MASTER",
         "SKYWARD"."PUB"."FFPOPD-PO-DTL" "FFPOPD_PO_DTL",
         "SKYWARD"."PUB"."FFAPID-INVOICE-DTL" "FFAPID_INVOICE_DTL",
         "SKYWARD"."PUB"."NAME" "NAME1",
         "SKYWARD"."PUB"."FFAPIA-INVOICE-ACCTS" "FFAPIA_INVOICE_ACCTS",
         "SKYWARD"."PUB"."FFAMAM-ACCT-MST" "FFAMAM_ACCT_MST",
         "SKYWARD"."PUB"."NAME" "NAME_SHIP_TO",
		 "SKYWARD"."PUB"."FFAMET-ENC-DTL" "DTL_LINE_INFO"
WHERE    (
                  "FFPORC_RECEIVING_FILE"."FFPOPM-ID"="FFPOPM_PO_MASTER"."FFPOPM-ID")
AND      ((
                           "FFPORC_RECEIVING_FILE"."FFPOPM-ID"="FFPOPD_PO_DTL"."FFPOPM-ID")
         AND      (
                           "FFPORC_RECEIVING_FILE"."FFPOPD-LINE-NBR"="FFPOPD_PO_DTL"."FFPOPD-LINE-NBR"))
AND      ((
                           "FFPORC_RECEIVING_FILE"."FFAPIM-ID"="FFAPID_INVOICE_DTL"."FFAPIM-ID" (+))
         AND      (
                           "FFPORC_RECEIVING_FILE"."FFPOPD-LINE-NBR"="FFAPID_INVOICE_DTL"."FFAPID-LINE-NBR" (+)))
AND      (
                  "FFPORC_RECEIVING_FILE"."FFPORC-RECEIVED-BY"="NAME1"."NAME-ID")
AND      (
                  "FFPORC_RECEIVING_FILE"."FFAPIM-ID"="FFAPIA_INVOICE_ACCTS"."FFAPIM-ID" (+))
AND      ( 
                  "DTL_LINE_INFO"."FFAMAM-ACCT-ID"="FFAMAM_ACCT_MST"."FFAMAM-ACCT-ID" (+))
AND      (
                  "FFPOPM_PO_MASTER"."FFPOPM-SHIP-TO-NAME-ID"="NAME_SHIP_TO"."NAME-ID")
AND      "DTL_LINE_INFO"."FFPOPM-PO-NBR" = "FFPOPM_PO_MASTER"."FFPOPM-PO-NBR"
AND		 "FFPOPD_PO_DTL"."FFPOPD-MERCH-NARR"=''M''
AND      (
                  "FFPORC_RECEIVING_FILE"."FFPORC-RECEIVED-DATE">= ''2017-01-01''
         AND      "FFPORC_RECEIVING_FILE"."FFPORC-RECEIVED-DATE"<= ''2018-01-01'')
AND      "FFPOPM_PO_MASTER"."FFPOPM-STATUS"=''O''
AND		 "FFAMAM_ACCT_MST"."FFAMAM-DIM-9" IN (''001'')
ORDER BY "FFPOPM_PO_MASTER"."FFPOPM-PO-NBR"
'
)

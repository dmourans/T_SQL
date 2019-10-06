SELECT
    A.CLASS_DESC AS DS_TIPO_PERMISSAO,
    A.STATE_DESC AS DS_TIPO_OPERACAO,
    A.[PERMISSION_NAME] AS DS_PERMISSAO,
    B.[NAME] AS DS_LOGIN,
    B.[TYPE_DESC] AS DS_TIPO_LOGIN
FROM 
    SYS.SERVER_PERMISSIONS A
    JOIN SYS.SERVER_PRINCIPALS B ON A.GRANTEE_PRINCIPAL_ID = B.PRINCIPAL_ID
WHERE
    B.[NAME] NOT LIKE '##%'
ORDER BY
    B.[NAME],
    A.[PERMISSION_NAME]
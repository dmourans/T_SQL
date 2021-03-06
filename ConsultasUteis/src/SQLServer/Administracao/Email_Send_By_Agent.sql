SELECT
    A.SEND_REQUEST_DATE AS DATAENVIO,
    A.SENT_DATE AS DATAENTREGA,
    (CASE    
        WHEN A.SENT_STATUS = 0 THEN '0 - AGUARDANDO ENVIO'
        WHEN A.SENT_STATUS = 1 THEN '1 - ENVIADO'
        WHEN A.SENT_STATUS = 2 THEN '2 - FALHOU'
        WHEN A.SENT_STATUS = 3 THEN '3 - TENTANDO NOVAMENTE'
    END) AS SITUACAO,
    A.FROM_ADDRESS AS REMETENTE,
    A.RECIPIENTS AS DESTINATARIO,
    A.SUBJECT AS ASSUNTO,
    A.REPLY_TO AS RESPONDERPARA,
    A.BODY AS MENSAGEM,
    A.BODY_FORMAT AS FORMATO,
    A.IMPORTANCE AS IMPORTANCIA,
    A.FILE_ATTACHMENTS AS ANEXOS,
    A.SEND_REQUEST_USER AS USUARIO,
    B.DESCRIPTION AS ERRO,
    B.LOG_DATE AS DATAFALHA
FROM 
    MSDB.DBO.SYSMAIL_MAILITEMS                  A    WITH(NOLOCK)
    LEFT JOIN MSDB.DBO.SYSMAIL_EVENT_LOG        B    WITH(NOLOCK)    ON A.MAILITEM_ID = B.MAILITEM_ID

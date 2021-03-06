SELECT
    CONVERT(VARCHAR(25), DB.NAME) AS DBNAME,
    STATE_DESC,
    (
        SELECT
            COUNT(1)
        FROM
            SYS.MASTER_FILES
        WHERE
            DB_NAME(DATABASE_ID) = DB.NAME
            AND TYPE_DESC = 'ROWS'
    ) AS DATAFILES,
    (
        SELECT
            SUM(( SIZE * 8 ) / 1024)
        FROM
            SYS.MASTER_FILES
        WHERE
            DB_NAME(DATABASE_ID) = DB.NAME
            AND TYPE_DESC = 'ROWS'
    ) AS [DATA MB],
    (
        SELECT
            COUNT(1)
        FROM
            SYS.MASTER_FILES
        WHERE
            DB_NAME(DATABASE_ID) = DB.NAME
            AND TYPE_DESC = 'LOG'
    ) AS LOGFILES,
    (
        SELECT
            SUM(( SIZE * 8 ) / 1024)
        FROM
            SYS.MASTER_FILES
        WHERE
            DB_NAME(DATABASE_ID) = DB.NAME
            AND TYPE_DESC = 'LOG'
    ) AS [LOG MB],
    RECOVERY_MODEL_DESC AS [RECOVERY MODEL],
    CASE [COMPATIBILITY_LEVEL]
        WHEN 60 THEN '60 (SQL SERVER 6.0)'
        WHEN 65 THEN '65 (SQL SERVER 6.5)'
        WHEN 70 THEN '70 (SQL SERVER 7.0)'
        WHEN 80 THEN '80 (SQL SERVER 2000)'
        WHEN 90 THEN '90 (SQL SERVER 2005)'
        WHEN 100 THEN '100 (SQL SERVER 2008)'
        WHEN 110 THEN '110 (SQL SERVER 2012)'
        WHEN 120 THEN '120 (SQL SERVER 2014)'
        WHEN 130 THEN '130 (SQL SERVER 2016)'
        WHEN 140 THEN '140 (SQL SERVER 2017)'
        WHEN 150 THEN '150 (SQL SERVER 2019)'
    END AS [COMPATIBILITY LEVEL],
    CONVERT(VARCHAR(20), CREATE_DATE, 103) + ' ' + CONVERT(VARCHAR(20), CREATE_DATE, 108) AS [CREATION DATE],
    -- LAST BACKUP
    ISNULL(
    (
        SELECT TOP 1
            CASE TYPE WHEN 'D' THEN 'FULL' WHEN 'I' THEN 'DIFFERENTIAL' WHEN 'L' THEN 'TRANSACTION LOG' END + ' � ' + LTRIM(ISNULL(STR(ABS(DATEDIFF(DAY, GETDATE(), BACKUP_FINISH_DATE))) + ' DAYS AGO', 'NEVER')) + ' � ' + CONVERT(VARCHAR(20), BACKUP_START_DATE, 103) + ' ' + CONVERT(VARCHAR(20), BACKUP_START_DATE, 108) + ' � ' + CONVERT(VARCHAR(20), BACKUP_FINISH_DATE, 103) + ' ' + CONVERT(VARCHAR(20), BACKUP_FINISH_DATE, 108) + ' (' + CAST(DATEDIFF(SECOND, BK.BACKUP_START_DATE, BK.BACKUP_FINISH_DATE) AS VARCHAR(4)) + ' ' + 'SECONDS)'
        FROM
            MSDB..BACKUPSET BK
        WHERE
            BK.DATABASE_NAME = DB.NAME
        ORDER BY
            BACKUP_SET_ID DESC
    ),    '-'
          ) AS [LAST BACKUP],
    CASE WHEN IS_AUTO_CLOSE_ON = 1 THEN 'AUTOCLOSE' ELSE '' END AS [AUTOCLOSE],
    PAGE_VERIFY_OPTION_DESC AS [PAGE VERIFY OPTION],
    CASE WHEN IS_AUTO_SHRINK_ON = 1 THEN 'AUTOSHRINK' ELSE '' END AS [AUTOSHRINK],
    CASE WHEN IS_AUTO_CREATE_STATS_ON = 1 THEN 'AUTO CREATE STATISTICS' ELSE '' END AS [AUTO CREATE STATISTICS],
    CASE WHEN IS_AUTO_UPDATE_STATS_ON = 1 THEN 'AUTO UPDATE STATISTICS' ELSE '' END AS [AUTO UPDATE STATISTICS],
    DB.DELAYED_DURABILITY_DESC,
    DB.IS_PARAMETERIZATION_FORCED,
    DB.USER_ACCESS_DESC,
    DB.SNAPSHOT_ISOLATION_STATE_DESC,
    DB.IS_READ_ONLY,
    DB.IS_TRUSTWORTHY_ON,
    DB.IS_ENCRYPTED,
    DB.IS_QUERY_STORE_ON,
    DB.IS_CDC_ENABLED,
    DB.IS_REMOTE_DATA_ARCHIVE_ENABLED,
    DB.IS_SUBSCRIBED,
    DB.IS_MERGE_PUBLISHED
FROM
    SYS.DATABASES DB
ORDER BY
    6 DESC;

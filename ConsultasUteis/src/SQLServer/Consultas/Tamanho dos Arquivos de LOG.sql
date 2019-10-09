IF (OBJECT_ID('TEMPDB..#DATAFILE_SIZE ') IS NOT NULL) DROP TABLE #DATAFILE_SIZE
SELECT
    B.DATABASE_ID AS DATABASE_ID,
    B.[NAME] AS [DATABASE_NAME],
    A.STATE_DESC,
    A.[TYPE_DESC],
    A.[FILE_ID],
    A.[NAME],
    A.PHYSICAL_NAME,
    CAST(C.TOTAL_BYTES / 1073741824.0 AS NUMERIC(18, 2)) AS DISK_TOTAL_SIZE_GB,
    CAST(C.AVAILABLE_BYTES / 1073741824.0 AS NUMERIC(18, 2)) AS DISK_FREE_SIZE_GB,
    CAST(A.SIZE / 128 / 1024.0 AS NUMERIC(18, 2)) AS SIZE_GB,
    CAST(A.MAX_SIZE / 128 / 1024.0 AS NUMERIC(18, 2)) AS MAX_SIZE_GB,
    CAST(
        (CASE
        WHEN A.GROWTH <= 0 THEN A.SIZE / 128 / 1024.0
            WHEN A.MAX_SIZE <= 0 THEN C.TOTAL_BYTES / 1073741824.0
            WHEN A.MAX_SIZE / 128 / 1024.0 > C.TOTAL_BYTES / 1073741824.0 THEN C.TOTAL_BYTES / 1073741824.0
            ELSE A.MAX_SIZE / 128 / 1024.0 
        END) AS NUMERIC(18, 2)) AS MAX_REAL_SIZE_GB,
    CAST(NULL AS NUMERIC(18, 2)) AS FREE_SPACE_GB,
    (CASE WHEN A.IS_PERCENT_GROWTH = 1 THEN A.GROWTH ELSE CAST(A.GROWTH / 128 AS NUMERIC(18, 2)) END) AS GROWTH_MB,
    A.IS_PERCENT_GROWTH,
    (CASE WHEN A.GROWTH <= 0 THEN 0 ELSE 1 END) AS IS_AUTOGROWTH_ENABLED,
    CAST(NULL AS NUMERIC(18, 2)) AS PERCENT_USED,
    CAST(NULL AS INT) AS GROWTH_TIMES
INTO
    #DATAFILE_SIZE 
FROM
    SYS.MASTER_FILES        A   WITH(NOLOCK)
    JOIN SYS.DATABASES      B   WITH(NOLOCK)    ON  A.DATABASE_ID = B.DATABASE_ID
    CROSS APPLY SYS.DM_OS_VOLUME_STATS(A.DATABASE_ID, A.[FILE_ID]) C
 
    
UPDATE A
SET
    A.FREE_SPACE_GB = (
    (CASE 
        WHEN MAX_SIZE_GB <= 0 THEN A.DISK_FREE_SIZE_GB
        WHEN MAX_REAL_SIZE_GB > DISK_FREE_SIZE_GB THEN A.DISK_FREE_SIZE_GB 
        ELSE MAX_REAL_SIZE_GB - SIZE_GB
    END)),
    A.PERCENT_USED = (SIZE_GB / (CASE WHEN MAX_REAL_SIZE_GB > DISK_TOTAL_SIZE_GB THEN A.DISK_TOTAL_SIZE_GB ELSE MAX_REAL_SIZE_GB END)) * 100
FROM 
    #DATAFILE_SIZE A
    
 
UPDATE A
SET
    A.GROWTH_TIMES = 
    (CASE 
        WHEN A.GROWTH_MB <= 0 THEN 0 
        WHEN A.IS_PERCENT_GROWTH = 0 THEN (A.MAX_REAL_SIZE_GB - A.SIZE_GB) / (A.GROWTH_MB / 1024.0) 
        ELSE NULL 
    END)
FROM 
    #DATAFILE_SIZE A
 
 
SELECT * 
FROM #DATAFILE_SIZE


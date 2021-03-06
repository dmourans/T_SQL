SELECT TOP(100)
    B.[NAME] AS ROTINA,
    A.CACHED_TIME,
    A.LAST_EXECUTION_TIME,
    A.EXECUTION_COUNT,
 
    A.TOTAL_ELAPSED_TIME / 1000 AS TOTAL_ELAPSED_TIME_MS,
    A.LAST_ELAPSED_TIME / 1000 AS LAST_ELAPSED_TIME_MS,
    A.MIN_ELAPSED_TIME / 1000 AS MIN_ELAPSED_TIME_MS,
    A.MAX_ELAPSED_TIME / 1000 AS MAX_ELAPSED_TIME_MS,
    ((A.TOTAL_ELAPSED_TIME / A.EXECUTION_COUNT) / 1000) AS AVG_ELAPSED_TIME_MS,
 
    A.TOTAL_WORKER_TIME / 1000 AS TOTAL_WORKER_TIME_MS,
    A.LAST_WORKER_TIME / 1000 AS LAST_WORKER_TIME_MS,
    A.MIN_WORKER_TIME / 1000 AS MIN_WORKER_TIME_MS,
    A.MAX_WORKER_TIME / 1000 AS MAX_WORKER_TIME_MS,
    ((A.TOTAL_WORKER_TIME / A.EXECUTION_COUNT) / 1000) AS AVG_WORKER_TIME_MS,
    
    A.TOTAL_PHYSICAL_READS,
    A.LAST_PHYSICAL_READS,
    A.MIN_PHYSICAL_READS,
    A.MAX_PHYSICAL_READS,
    
    A.TOTAL_LOGICAL_READS,
    A.LAST_LOGICAL_READS,
    A.MIN_LOGICAL_READS,
    A.MAX_LOGICAL_READS,
    
    A.TOTAL_LOGICAL_WRITES,
    A.LAST_LOGICAL_WRITES,
    A.MIN_LOGICAL_WRITES,
    A.MAX_LOGICAL_WRITES
FROM
    SYS.DM_EXEC_PROCEDURE_STATS                 A
    JOIN SYS.OBJECTS                            B    ON  A.[OBJECT_ID] = B.[OBJECT_ID]
ORDER BY
    A.EXECUTION_COUNT DESC

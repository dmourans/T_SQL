SELECT
    CASE DATABASE_ID WHEN 32767 THEN 'RESOURCEDB' ELSE DB_NAME(DATABASE_ID)END AS DATABASE_NAME,
    COUNT(*) AS CACHED_PAGES_COUNT,
    COUNT(*) * .0078125 AS CACHED_MEGABYTES /* EACH PAGE IS 8KB, WHICH IS .0078125 OF AN MB */
FROM
    SYS.DM_OS_BUFFER_DESCRIPTORS
GROUP BY
    DB_NAME(DATABASE_ID),
    DATABASE_ID
ORDER BY
    CACHED_PAGES_COUNT DESC;
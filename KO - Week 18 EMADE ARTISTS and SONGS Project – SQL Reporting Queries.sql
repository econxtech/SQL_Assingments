-- Top 5 Artist
USE EMADEDEV;

SELECT *
FROM [dbo].[EMADE_ARTISTS]
SELECT *
FROM [dbo].[EMADE_GLOBAL_SONG_RANK]
SELECT *
FROM [dbo].[EMADE_SONGS]

/* Assume there are three Spotify tables: EMADE_ARTISTS, EMADE_SONGS, and EMADE_GLOBAL_SONG_RANK, 
which contain information about the EMADE_ARTISTS, EMADE_SONGS, and music charts, respectively.

Write a query to find the top 5 EMADE_ARTISTS whose EMADE_SONGS appear most frequently in the 
Top 10 of the EMADE_GLOBAL_SONG_RANK table. Use CTEs and window functions where possible.
Display the top 5 artist names in ascending order, along with their song appearance ranking.*/

WITH Top10_Per_Song AS (
    SELECT
        s.artist_id,
        COUNT(*) AS top10_appearances
    FROM EMADE_GLOBAL_SONG_RANK r
    INNER JOIN EMADE_SONGS s ON r.song_id = s.song_id
    WHERE r.rank <= 10                          -- Only Top-10 chart events
    GROUP BY s.artist_id
),
Artist_Ranked AS (
    SELECT
        a.artist_name,
        a.artist_id,
        t.top10_appearances        
    FROM EMADE_ARTISTS a
    INNER JOIN Top10_Per_Song t ON t.artist_id = a.artist_id
)
SELECT
    artist_name,
    artist_id,
    top10_appearances    
FROM Artist_Ranked
WHERE top10_appearances >= 5
ORDER BY artist_name ASC;
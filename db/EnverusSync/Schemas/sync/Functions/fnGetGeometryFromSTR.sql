CREATE FUNCTION [sync].[fnGetGeometryFromStr](@GeoString VARCHAR(max))
RETURNS TABLE 
AS
RETURN (
    SELECT 
         GeoData    = CASE 
                        WHEN try_convert(GEOMETRY, @GeoString) IS NOT NULL
                            THEN geometry::STGeomFromText(@GeoString, 4326).MakeValid() 
                        ELSE NULL 
                      END
)
GO

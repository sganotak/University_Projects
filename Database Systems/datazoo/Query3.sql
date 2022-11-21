/*Project SubSpecies,Order and Class of animals that inhabit all continents of the world*/

SELECT t1.SubSpecies, t1.Order, t1.Class
FROM taxonomy t1
JOIN inhabits ON t1.SubSpecies=inhabits.Subspecies
JOIN habitat ON habitat.HabitatID=inhabits.HabitatID
GROUP BY t1.SubSpecies
HAVING COUNT(DISTINCT habitat.Continent) = (SELECT COUNT(DISTINCT habitat.Continent) FROM habitat);
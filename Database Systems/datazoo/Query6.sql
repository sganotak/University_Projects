/*Project the oldest Mammal that currentl inhabits the Zoo */

SELECT animal.AnimalID, animal.Gender, Birth_Date, taxonomy.Species
FROM animal
JOIN taxonomy ON animal.AnSpecies = taxonomy.SubSpecies
WHERE  Birth_Date IN
(SELECT MIN(Birth_Date) FROM animal
JOIN taxonomy ON animal.AnSpecies = taxonomy.SubSpecies
WHERE taxonomy.Class= 'Mammalia') 

/*Project the Gender of all Tigers located in the Zoo whose natural Habitat is not in India */

SELECT Animal.AnimalID, Animal.Gender
FROM Habitat
JOIN Inhabits ON Habitat.HabitatID=Inhabits.HabitatID
JOIN Taxonomy ON Inhabits.Subspecies=Taxonomy.Subspecies
JOIN Animal ON Taxonomy.Subspecies= Animal.AnSpecies
WHERE taxonomy.Species ='Panthera Tigris' AND Habitat.Country <> 'India';

/*Project all critically endangered subspecies that inhabit the zoo's aquarium */

SELECT inhabits.SubSpecies
FROM inhabits 
JOIN taxonomy ON inhabits.Subspecies=taxonomy.SubSpecies
JOIN animal ON taxonomy.SubSpecies=animal.AnSpecies
JOIN place  ON animal.AnPlace=place.PlaceId
WHERE inhabits.status='Critically Endangered' AND place.PlaceName='Aquarium'

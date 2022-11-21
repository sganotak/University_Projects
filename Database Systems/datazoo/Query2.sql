/*Project critically endangered subspecies whose natural habitat is located in Ecuador or in the African continent */

SELECT taxonomy.SubSpecies, inhabits.Range
FROM taxonomy
JOIN inhabits ON taxonomy.SubSpecies=inhabits.Subspecies
JOIN habitat ON inhabits.HabitatID=habitat.HabitatID
WHERE inhabits.status ='Critically Endangered' AND ( habitat.Country='Ecuador' OR habitat.Continent ='Africa')
/* Project the id, gender, Species, Checkup Date and recorded weight history of all animals born after 2018-10-26 who are cared by the Vet John Dolittle */

SELECT animal.AnimalID, animal.Gender, taxonomy.Species, animal_checkups.RecWeight, animal_checkups.CheckupDate
FROM animal
JOIN taxonomy ON animal.AnSpecies=taxonomy.SubSpecies
JOIN animal_checkups ON animal.AnimalID= animal_checkups.Ex_AnimalID
JOIN cares_for ON animal.AnimalID=cares_for.AnimalID
JOIN employee ON cares_for.EmployeeID=employee.EmployeeID
WHERE animal.Birth_Date>'2018-10-26' AND employee.FirstName='John' AND employee.LastName='Dolittle' AND employee.Occupation='Veterinarian'
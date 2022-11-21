/*Project the diets followed on 2018-11-24 by the mothers of all lion cubs who were born after 2018-11-17*/

SELECT DISTINCT  diet.*
FROM animal mother
INNER JOIN
animal cubs ON cubs.MotherID=mother.AnimalID
JOIN diet ON diet.AnID=mother.AnimalID
WHERE cubs.Birth_Date>'2018-11-17' AND diet.DietDay='2018-11-24'
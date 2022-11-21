CREATE ROLE 'selectpublic','selectprivate','basicemployee','checkupswrite','dietwrite','admin';

# Role selectpublic can only perform select queries on the animal,taxonomy,place,inhabits,habitat and climate tables
GRANT SELECT ON datazoo.animal TO 'selectpublic';
GRANT SELECT ON datazoo.taxonomy TO 'selectpublic';
GRANT SELECT ON datazoo.place TO 'selectpublic';
GRANT SELECT ON datazoo.inhabits TO 'selectpublic';
GRANT SELECT ON datazoo.habitat TO 'selectpublic';
GRANT SELECT ON datazoo.climate TO 'selectpublic';

#Role basicemployee can select,insert,update and delete animals in the DB and can also perform select queries on the animal_checkups,diet,employee and cares_for tables
GRANT SELECT, INSERT,UPDATE,DELETE ON datazoo.animal TO 'basicemployee';
GRANT SELECT ON datazoo.animal_checkups TO 'basicemployee';
GRANT SELECT ON datazoo.cares_for TO 'basicemployee';
GRANT SELECT ON datazoo.employee TO 'basicemployee';
GRANT SELECT ON datazoo.diet TO 'basicemployee';

#Role dietwrite can select,insert,update and delete entries from the diet table
GRANT SELECT,INSERT,UPDATE,DELETE ON datazoo.diet TO 'dietwrite';

#Role checkupswrite can select,insert,update and delete entries from the animal_checkups table
GRANT SELECT,INSERT,UPDATE,DELETE ON datazoo.diet TO 'checkupswrite';

#Role admin has all privileges
GRANT ALL PRIVILEGES ON datazoo.* TO 'admin';

# Create user dbadmin that can has all privileges but only from the server of the DB (localhost)
CREATE USER 'dbadmin'@'localhost' IDENTIFIED BY 'superpass';
GRANT 'admin' TO 'dbadmin'@'localhost';

# Crete user visitor that can perform select queries on the public tables of the DB
CREATE USER 'visistor'@'localhost' IDENTIFIED BY 'visitorpass';
CREATE USER 'visitor'@'%' IDENTIFIED BY 'visitorpass';
GRANT 'selectpublic' TO 'visitor';

# Create user employee that can perform select queries on public and private tables and also insert,update and delete animals in the DB
CREATE USER 'employee'@'localhost' IDENTIFIED BY 'employeepass';
CREATE USER 'employee'@'%' IDENTIFIED BY 'employeepass';
GRANT 'selectpublic','selectprivate','basicemployee' TO 'employee';

# Create user healthstaff that has the same privileges as basic employee in addition to being able to select,insert,update and delete entries from the animal_checkups table
CREATE USER 'healthstaff'@'localhost' IDENTIFIED BY 'hemployeepass';
CREATE USER 'healthstaff'@'%' IDENTIFIED BY 'hemployeepass';
GRANT 'selectpublic','selectprivate','basicemployee','checkupswrite' TO 'healthstaff';

# Create user dietstaff that has the same privileges as basic employee in addition to being able to select,insert,update and delete entries from the diet table
CREATE USER 'dietstaff'@'localhost' IDENTIFIED BY 'demployeepass';
CREATE USER 'dietstaff'@'%' IDENTIFIED BY 'demployeepass';
GRANT 'selectpublic','selectprivate','basicemployee','dietswrite' TO 'dietstaff';
-- This is a new user created on 
-- MySQL server: dsp-01.cnk9sarev6lg.us-east-2.rds.amazonaws.com
--       instance: dsp-01
CREATE USER 'tutorial_user'@'%';
ALTER USER 'tutorial_user'@'%'
IDENTIFIED BY '********' ;
GRANT Create role ON *.* TO 'tutorial_user'@'%';
GRANT Create user ON *.* TO 'tutorial_user'@'%';
GRANT Drop role ON *.* TO 'tutorial_user'@'%';
GRANT Event ON *.* TO 'tutorial_user'@'%';
GRANT File ON *.* TO 'tutorial_user'@'%';
GRANT Process ON *.* TO 'tutorial_user'@'%';
GRANT Reload ON *.* TO 'tutorial_user'@'%';
GRANT Replication client ON *.* TO 'tutorial_user'@'%';
GRANT Replication slave ON *.* TO 'tutorial_user'@'%';
GRANT Show databases ON *.* TO 'tutorial_user'@'%';
GRANT Super ON *.* TO 'tutorial_user'@'%';
GRANT Create tablespace ON *.* TO 'tutorial_user'@'%';
GRANT Usage ON *.* TO 'tutorial_user'@'%';
;
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, RELOAD, PROCESS, REFERENCES, INDEX, ALTER, SHOW DATABASES, CREATE TEMPORARY TABLES, LOCK TABLES, EXECUTE, REPLICATION SLAVE, REPLICATION CLIENT, CREATE VIEW, SHOW VIEW, CREATE ROUTINE, ALTER ROUTINE, CREATE USER, EVENT, TRIGGER ON *.* TO `tutorial_user`@`%` WITH GRANT OPTION
;

show grants for 'tutorial_user'
;
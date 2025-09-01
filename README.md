# crm-database
SWE6008 ADVANCED DATABASE


This is a project for the class Advanced Database, it's a functional CRM Database.

The tools needed are the following:
-PostgreSQL 12+ (recommended) OR MySQL 8.0+ OR SQL Server 2019+
- DB administration access


To run the database, here is what you need to do:

1.
- PostgreSQL:
CREATE DATABASE crm_system;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

- MySQL:
CREATE DATABASE crm_system CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;


2.
- PostgreSQL:
psql -d crm_system -f schema/crm_schema.sql

- MySQL:
mysql -u root -p crm_system < schema/crm_schema.sql

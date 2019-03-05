/* Create Contained Databases */
--------------------------------

-- This script performs the below operation:
	-- Drop & Create a Contained database cdb1
	-- Drop & create a database cdb2
	-- Enable database containment for database cdb2
	-- Enable database containment for database NonContainedDB
-----------------------------------------------
use [master];
go
if exists (select 1 from sys.databases where [name] = 'CDB1')
	begin
		drop database [cdb1];
	end
go

-- create a contained database
create database [cdb1]
	containment = partial;
go

-- turn off auto close setting
use [master];
go
alter database [cdb1]
	set auto_close off;
go

-- create another partial contained database with different collation
use [master];
go

if exists (select 1 from sys.databases where [name] = 'cdb2')
	begin
		drop database [cdb2];
	end
go
create database [cdb2]
	collate SQL_Latin1_General_Cp850_CI_AS;
go

-- turn off the auto_close property
use [master];
go
alter database [cdb2]
	set auto_close off;
go

-- turn on partial database containment
use [master];
go
alter database [cdb2]
	set containment = partial;
go

-- Change the Containment setting of an existing database
use [master];
go
alter database [NonContainedDB]
	set containment = Partial;
go
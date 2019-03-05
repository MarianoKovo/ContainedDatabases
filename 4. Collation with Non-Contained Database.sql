/* Collation Setting with Non Contained Databases */
----------------------------------------------------

-- This script performs the below operation:
	-- Drop & create the database NonContainedDB in Turkish_CI_AS collation
---------------------------------------------------------------------------
use [master];
go
if exists (Select 1 from sys.databases where [name] = 'NonContainedDB')
	begin
		alter database [NonContainedDB]
			set single_user with rollback immediate;
		drop database [NonContainedDB];
	end
go
create database [NonContainedDB]
	collate SQL_Latin1_General_CP850_CI_AS;
go

-- create a table in the NonContainedDB
use [NonContainedDB];
go
create table tbltest (
testname	char(10)
);
go

-- create a temp table
use [NonContainedDB];
go
create table #tbltest (
testname	char(10)
);
go

-- join the above two tables
use [NonContainedDB];
go
select *
from tbltest inner join #tbltest
on tbltest.testname = #tbltest.testname;
go

-- should get error because of collation mismatch


-- drop the temp table
use [NonContainedDB];
go
drop table #tbltest;
go

-- to fix the above issue, follow the step mentioned below

-- create the temp table again with database_default setting
use [NonContainedDB];
go
create table #tbltest (
testname char(10) collate SQL_Latin1_General_CP850_CI_AS);
go

-- execute the join query once again
use [NonContainedDB];
go
select *
from tbltest 
	inner join #tbltest
		on tbltest.testname = #tbltest.testname;
go

-- clean up
use [NonContainedDB];
go
drop table [#tbltest];
go
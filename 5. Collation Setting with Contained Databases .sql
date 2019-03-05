/* Collation Setting with Contained Databases */
------------------------------------------------

-- This script performs the below operation:
	-- Change containment of the databse NonContainedDB to Partial
---------------------------------------------------------
-- Change the Containment option to Partial
use [master];
go
alter database [NonContainedDB]
	set containment = Partial;
go

-- create a temp table, without "collate as database_default"
use [NonContainedDB];
go
create table #tbltest (
testchar	char(10)
);
go

-- Perform the same join which failed earlier
use [NonContainedDB];
go
select *
from tbltest inner join #tbltest
on tbltest.testname = #tbltest.testchar;
go


use [master];
go


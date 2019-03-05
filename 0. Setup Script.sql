/* Initial Setup script */
--------------------------
	-- Drop database cdb1, cdb2, NonContainedDB
	-- Remove logins noncdb_dbo, noncdb_reader
	-- Reset the Contained database server level setting
	-- create a database NonContainedDB
	-- Create logins noncdb_dbo, noncdb_reader
	-- Assign noncdb_dbo as 'db_owner' and noncdn_reader as 'db_datareader' 
	-- permissions on the NonContainedDB
		
--------------------------
use [master];
go
if exists (select 1 from sys.databases where [name] = 'cdb1')
begin
	alter database [cdb1]
		set single_user with rollback immediate;
	drop database [cdb1];
end
go

use [master];
go
if exists (select 1 from sys.databases where [name] = 'cdb2')
begin
	alter database [cdb2]
		set single_user with rollback immediate;
	drop database [cdb2];
end
go

use [master];
go
if exists (select 1 from sys.databases where [name] = 'NonContainedDB')
	begin
		alter database [NonContainedDB]
			set single_user with rollback immediate;
		drop database [NonContainedDB];
	end
go

use [master];
go
drop login [Noncdb_dbo];
go
drop login [Noncdb_reader];
go

-- reset the server level configuration
use [master];
go
exec sp_configure 'contained database authentication', 0;
go
reconfigure with override;
go


-- create a NonContainedDB
use [master];
go
create database [NonContainedDB];
go
create login [noncdb_dbo] with password = 'Pass@word1!!', default_database = [NonContainedDB];
go
create login [noncdb_reader] with password = 'Pass@word1!!', default_database = [NonContainedDB];
go
use [NonContainedDB];
go
create user [noncdb_dbo] for login [noncdb_dbo] with default_schema = [dbo];
go
Alter role db_owner add member [noncdb_dbo];
go
create user [noncdb_reader] for login [noncdb_reader] with default_schema = [dbo];
go
alter role db_datareader add member [noncdb_reader];
go
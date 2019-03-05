/* clean up script */
---------------------


-- This script performs the below operation:
	-- Drop database cdb1, cdb2, NonContainedDB
	-- Remove logins Noncdb_dbo, noncdb_reader
	-- Reset the Contained database server level setting
-------------------------------------------------------------------------
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



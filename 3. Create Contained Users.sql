/* Create Contained Database User */
------------------------------------

-- This script performs the below operation:
	-- create SQL User with Password
		-- cdb1_user on the contained database cdb1
		-- cdb2_user on the contained database cdb2
	-- create a windows user on the database cdb1
	-- migrate existing user to contained users on NonContainedDB
-----------------------------------------------------------------
use [master];
go

-- create a contained database user with password
use [cdb1];
go
create user [cdb1_user] with password ='Passw@rd1!!'
	, default_language = [English]
	, default_schema = [dbo];
go

use [cdb2];
go
create user [cdb2_user] with password = 'Passw@rd1!!'
	, default_language = [English]
	, default_schema = [dbo];
go 


-- create a contained database user from an existing domain login
use [cdb1];
go
create user [PITLAB001SRV01\sqldba] with default_schema = [dbo];
go

-- detach the database cdb1 from this instance and attach it to other 
-- sql server 2012 instance. Make sure, on the other instance, database containment
-- is enabled. You can also execute EnableContained Database script. 
-- Connect to the database cdb1 on the other instance using the user "cdb1_user"

-- Once you are able to connect it on the second instance, detach the database,
-- and attach it back to the first instance to continue with the rest of the script.

-- connect back to the first instance

-- Convert existing users (mapped to a login) to a Contained User
-- sp_migrate_user_to_contained 'username', 'copy_login_name\keep_name', 'disable_login\do_not_disable_login'
use [NonContainedDB];
go
exec sp_migrate_user_to_contained N'Noncdb_reader', N'keep_name', N'do_not_disable_login';
go
exec sp_migrate_user_to_contained N'Noncdb_dbo', N'copy_login_name', N'disable_login';
go

--verify the login Noncdb_dbo is disabled

use [master];
go


-- change the connection 
use [master];
go
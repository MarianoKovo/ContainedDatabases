/* Enable Contained Database Authentication for the SQL Server Instance */
--------------------------------------------------------------------------

-- This script performs the below operation:
	-- Enable the Contained database feature on the instance
	-- You can also enable it from the Advance tab of the SQL Server 
	-- instance properties, using SSMS
---------------------------------------------------------------------------
use [master];
go
exec sp_configure 'contained database authentication', 1;
go
reconfigure with override;
go
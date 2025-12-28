USE [SqlInv]
GO

/****** Object:  UserDefinedFunction [dbo].[uf_db_compatibility]    Script Date: 12/27/2025 6:52:26 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Paul Bezanson
-- Create date: 02/01/19
-- Description:	Returns a textual description of the compatibility level.
-- =============================================
CREATE function [dbo].[uf_db_compatibility] (
	@cmplevel tinyint
    )
returns varchar(20)
as begin
	-- Declare the return variable
	declare @Result varchar(20)

	-- Compute the return value
	select
		@Result = max(sql_server_edition)		-- Handles SQL2008 and SQL2008R2 having the same compatibility level.
	from dbo.patch_levels_available pla
	where pla.cmplevel = @cmplevel

  	-- Return the result of the function
	return @Result
	end

GO

ALTER AUTHORIZATION ON [dbo].[uf_db_compatibility] TO  SCHEMA OWNER 
GO

/****** Object:  UserDefinedFunction [dbo].[uf_exec_log_next_batch]    Script Date: 12/27/2025 6:52:26 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE function [dbo].[uf_exec_log_next_batch]()
returns bigint
as begin
	declare @rslt bigint

	select @rslt = isnull(max(exec_log.batch_no), 0) + 1 from dbo.exec_log

	return @rslt
	end

GO

ALTER AUTHORIZATION ON [dbo].[uf_exec_log_next_batch] TO  SCHEMA OWNER 
GO

/****** Object:  UserDefinedFunction [dbo].[uf_fmtgigs]    Script Date: 12/27/2025 6:52:26 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- ====================================================
-- Author:		pbezanson
-- Create date: 7/9/2015
-- Description:	
--		Takes a bigint and formats it in terms of KB,
--		MB, GB or TB depending on the scale requested
--		in the @scale parameter.-- 
-- ====================================================
CREATE function [dbo].[uf_fmtgigs](@byte_cnt bigint, @scale char(1))
returns varchar(50)
as
begin
	-- Declare the return variable here
	declare @rslt		varchar(50)
	declare @tmp		varchar(50)
	declare @fracpart	varchar(10)

	-- Add the T-SQL statements to compute the return value here
	--set @rslt = case
	--	when upper(@scale) = '' then str(cast(@byte_cnt as float), 25, 1)
	--	when upper(@scale) = 'K' then str(round(cast(@byte_cnt as float)/1024, 1), 25, 1) + 'KB'
	--	when upper(@scale) = 'M' then str(round(cast(@byte_cnt as float)/1048576, 1), 25, 1) + 'MB'
	--	when upper(@scale) = 'G' then str(round(cast(@byte_cnt as float)/1073741824, 1), 25, 1) + 'GB'
	--	when upper(@scale) = 'T' then str(round(cast(@byte_cnt as float)/1099511627776, 1), 25, 1) + 'TB'
	--	else
	--		'Unrecognized Scale.  Valid Scale values are: K, M, G, or T.'
	--	end

	set @rslt = case
		when len(@byte_cnt) <= 3 then ltrim(str(cast(@byte_cnt as float), 25, 1))
		when len(@byte_cnt) > 3 and len(@byte_cnt) <= 6 then ltrim(str(round(cast(@byte_cnt as float)/1024, 1), 25, 1)) + 'KB'
		when len(@byte_cnt) > 6 and len(@byte_cnt) <= 9 then ltrim(str(round(cast(@byte_cnt as float)/1048576, 1), 25, 1)) + 'MB'
		when len(@byte_cnt) > 9 and len(@byte_cnt) <= 12 then ltrim(str(round(cast(@byte_cnt as float)/1073741824, 1), 25, 1)) + 'GB'
		when len(@byte_cnt) > 12 then ltrim(str(round(cast(@byte_cnt as float)/1099511627776, 1), 25, 1)) + 'TB'
		else
			'Unrecognized Scale.  Valid Scale values are: K, M, G, or T.'
		end

	-- Format the string with commas
	set @rslt = ltrim(@rslt)  -- strip leading spaces
	set @fracpart = right(@rslt, len(@rslt) - charindex('.', @rslt) + 1)  -- save the fractional part of the string
	set @tmp = left(@rslt, charindex('.', @rslt) - 1)  -- get just the part left of the decimal

	-- Easier to add commas from right to left so we will reverse the string.
	set @tmp = reverse(@tmp)

	set @rslt = ''
	while len(@tmp) > 3 begin
		set @rslt = @rslt + left(stuff(@tmp, 4, 0, ','), 4)
		set @tmp = right(@tmp, len(@tmp) - 3)
		end

	if len(@tmp) > 0 
		set @rslt = @rslt + @tmp

	-- Reverse it back to its proper state.
	set @rslt = reverse(@rslt) + @fracpart

	if left(@rslt, 1) = ','
		set @rslt = right(@rslt, len(@rslt) - 1)

	-- Return the result of the function
	return @rslt
end


--print dbo.uf_fmtgigs(123, '')
--print dbo.uf_fmtgigs(12345, 'k')
--print dbo.uf_fmtgigs(1234567, 'm')
--print dbo.uf_fmtgigs(1234567890, 'g')
--print dbo.uf_fmtgigs(123456789012, 't')



GO

ALTER AUTHORIZATION ON [dbo].[uf_fmtgigs] TO  SCHEMA OWNER 
GO

/****** Object:  UserDefinedFunction [dbo].[uf_fmtndate]    Script Date: 12/27/2025 6:52:26 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


create function [dbo].[uf_fmtndate](@dt int) returns varchar(10)
as begin
	declare @stm varchar(10)

	set @stm = isnull(convert(varchar(10),convert(datetime,convert(varchar(20),@dt)),101), '')
		
	return @stm
	end

GO

ALTER AUTHORIZATION ON [dbo].[uf_fmtndate] TO  SCHEMA OWNER 
GO

/****** Object:  UserDefinedFunction [dbo].[uf_fmtntime]    Script Date: 12/27/2025 6:52:26 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-------------------------------------------------------------------------------
-- Takes a time value as an integer and formats it as a time string.
-------------------------------------------------------------------------------
CREATE function [dbo].[uf_fmtntime](@tm int) returns varchar(10)
as begin
	declare @stm varchar(10)

	set @stm = isnull(replicate('0', 6 - len(cast(@tm as varchar(10)))), '') + cast(@tm as varchar(10))
	set @stm = left(@stm, 2) + ':' + substring(@stm, 3, 2) + ':' + right(@stm, 2)
	
	return @stm
	end

GO

ALTER AUTHORIZATION ON [dbo].[uf_fmtntime] TO  SCHEMA OWNER 
GO

/****** Object:  UserDefinedFunction [dbo].[uf_fmtnum]    Script Date: 12/27/2025 6:52:27 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE function [dbo].[uf_fmtnum] (@int_value bigint)
returns varchar(30)
as 
begin
	declare	@is_negative bit
	declare	@return_value varchar(30)
	declare	@before varchar(30)
	declare	@after varchar(30)
	declare	@i bigint
	
	-- Determine sign
	select
		@is_negative = case	when @int_value < 0 then 1
							else 0
					   end

	-- Absolute value
	if @is_negative = 1 
		set @int_value = -1 * @int_value

	-- Default return value
	set @return_value = convert(varchar(30), isnull(@int_value, 0))

	set @before = @return_value
	set @after = ''

	-- After every third character:
	if len(@before) > 3 begin
		set @i = 3
		while @i > 1 and @i < len(@before) begin
			set @before = substring(@before, 1, len(@before) - @i) + ',' + right(@before, @i)
			set @i = @i + 4
			end
		end
	set @return_value = @before + @after

	if @is_negative = 1 
		set @return_value = '-' + @return_value

	---- Right justify if there's enough room.
	--if len(@return_value <= 25
	--	set @return_value = space(25 - len(@return_value)) + @return_value

	return @return_value
end

GO

ALTER AUTHORIZATION ON [dbo].[uf_fmtnum] TO  SCHEMA OWNER 
GO

/****** Object:  UserDefinedFunction [dbo].[uf_fqdn]    Script Date: 12/27/2025 6:52:27 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Paul Bezanson
-- Create date: 10/03/2014
-- Description:	Accepts a server name and domain name and returns a properly 
--				formatted FQDN (Fully Qualified Domain Name)
--				Defaults to "domain".
-- =============================================
create function [dbo].[uf_fqdn] (
	@server_nm nvarchar(28),
	@domain_nm nvarchar(384) = null
	)
returns varchar(256)
as
begin
	declare @RetVal varchar(256)

	--set @server_nm = 'pdxsap100'
	--set @domain_nm = 'tqs.com'

	set @server_nm = rtrim(ltrim(@server_nm))
	set @domain_nm = rtrim(ltrim(@domain_nm))

	set @RetVal = @server_nm + '.' + @domain_nm

	return @RetVal
end


















GO

ALTER AUTHORIZATION ON [dbo].[uf_fqdn] TO  SCHEMA OWNER 
GO

/****** Object:  UserDefinedFunction [dbo].[uf_fqdn_part]    Script Date: 12/27/2025 6:52:27 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Paul Bezanson
-- Create date: 10/03/2014
-- Description:	Accepts a FQDN and returns the server name or domain name
--				Defaults to "domain".
-- =============================================
CREATE function [dbo].[uf_fqdn_part] (
	@fqdn varchar(256),
	@part varchar(25) = 'domain'		-- <'server' | 'domain'>
	)
returns varchar(256)
as
begin
	declare @RetVal varchar(256)

	if @fqdn <> '' and @fqdn is not null
		select @RetVal = case @part
			when 'server' then
				left(@fqdn, charindex('.', @fqdn) - 1)
			else
				right(@fqdn, len(@fqdn) - len(left(@fqdn, charindex('.', @fqdn))))
			end      
	else
		set @RetVal = 'Error: Parameter @fqdn cannot be empty or null.'

	return @RetVal
end

GO

ALTER AUTHORIZATION ON [dbo].[uf_fqdn_part] TO  SCHEMA OWNER 
GO

/****** Object:  UserDefinedFunction [dbo].[uf_get_db_id]    Script Date: 12/27/2025 6:52:27 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Paul Bezanson
-- Create date: 6/8/2018
-- Description:	Takes an instance ID and database name and returns the db_list_id of the database.
--				if the @domain_nm paramenter is empty or null, the instance_id can still be obtained
--				if there are no other instances with the same name as @instance.
--
--				This function searches the entire database library whether active or not and returns 
--              the db_list_id.
--
-- Results:
--		> 0 = The db_list_id of the specified instance and database.
--		 -1 = No match was found.

-- =============================================
create function [dbo].[uf_get_db_id](@instance_id bigint, @database_nm sysname)
returns bigint
as
begin
	declare @cnt	bigint
	declare @rslt	bigint

	set @rslt = -1

	-- Handle the case when we're passed an instance name and a domain name.
				select
					@rslt = dl.db_list_id
				from
					db_list dl
				where
					dl.dbname = @database_nm and
                    dl.instance_id = @instance_id	
					
	-- Return the result of the function
	return isnull(@rslt, -1)
end

--print dbo.uf_get_db_id(81, 'dba_tools')



GO

ALTER AUTHORIZATION ON [dbo].[uf_get_db_id] TO  SCHEMA OWNER 
GO

/****** Object:  UserDefinedFunction [dbo].[uf_get_dbname]    Script Date: 12/27/2025 6:52:28 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		Paul Bezanson
-- Create date: 12/11/2017
-- Description:	Accepts a datbase ID (db_list_id) and returns the corresponding database name
-- =============================================
create function [dbo].[uf_get_dbname] (@db_list_id bigint)
returns sysname
begin
    declare @dbname   sysname

    select
        @dbname = dbname
    from 
        db_list
    where
        db_list_id = @db_list_id

    return @dbname
    end





GO

ALTER AUTHORIZATION ON [dbo].[uf_get_dbname] TO  SCHEMA OWNER 
GO

/****** Object:  UserDefinedFunction [dbo].[uf_get_default_login]    Script Date: 12/27/2025 6:52:28 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		Paul Bezanson
-- Create date: 12/11/2017
-- Description:	Returns the value of default_login
-- =============================================
create function [dbo].[uf_get_default_login] ()
returns sysname
begin
    declare @login   sysname

    select
        @login = convert(nvarchar(128), value)
    from 
        sysinfo
    where
        parameter = 'default_login'

    return @login
    end





GO

ALTER AUTHORIZATION ON [dbo].[uf_get_default_login] TO  SCHEMA OWNER 
GO

/****** Object:  UserDefinedFunction [dbo].[uf_get_domain_cd]    Script Date: 12/27/2025 6:52:28 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Paul Bezanson
-- Create date: 11/30/2018
-- Description:	Takes a domain name and returns the the associated domain code from the 
--				lu_domain_code table.  If the @domain_nm paramenter is empty or null, 
--				the result returned is "?".
--
-- Results:
--		Either:
--			The code of the associated domain,
--		or
--			"?"
-- =============================================
CREATE function [dbo].[uf_get_domain_cd](@domain_nm nvarchar(255))
returns varchar(4)
as
begin
	declare @rslt		sysname
	set @rslt = null

	-- Handle the case where we're passed an instance name and a domain name.
	if @domain_nm is not null and @domain_nm <> '' begin
		select @rslt = domain_cd from dbo.lu_domain_code where domain_nm = @domain_nm
		set @rslt = isnull(@rslt, '?')
		end
	else
		set @rslt = '?'

	-- Return the result of the function
	return @rslt
end		-- uf_get_domain_cd

--print dbo.uf_get_domain_cd 'PACIFICSOURCE.COM'



GO

ALTER AUTHORIZATION ON [dbo].[uf_get_domain_cd] TO  SCHEMA OWNER 
GO

/****** Object:  UserDefinedFunction [dbo].[uf_get_domain_name]    Script Date: 12/27/2025 6:52:28 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Paul Bezanson
-- Create date: 7/20/2015
-- Description:	Takes an instance ID and returns the the associated domain name.
--				if the @domain_nm paramenter is empty or null, the result "Null" is returned.
--
--				This function searches the entirety of the instance table whether enabled, disabled,
--				decommissioned or not and returns the instance_id.  It makes no assumptions about 
--				instance state.
--
-- Results:
--		Either:
--			The name of the associated domain,
--		or
--			The word "Null".
-- =============================================
create function [dbo].[uf_get_domain_name](@instance_id bigint)
returns sysname
as
begin
	declare @domain_nm	nvarchar(255)
	declare @rslt		sysname

	set @domain_nm = null
	set @rslt = null

	-- Handle the case when we're passed an instance name and a domain name.
	if @instance_id is not null and @instance_id > 0 begin
		select @rslt = s.domain_nm from instances i inner join dbo.servers s on s.server_id = i.server_id where i.instance_id = @instance_id
		set @domain_nm = isnull(@rslt, 'Null')
		end

	-- Return the result of the function
	return @rslt
end		-- uf_get_domain_name

--print dbo.uf_get_domain_name(123)



GO

ALTER AUTHORIZATION ON [dbo].[uf_get_domain_name] TO  SCHEMA OWNER 
GO

/****** Object:  UserDefinedFunction [dbo].[uf_get_email]    Script Date: 12/27/2025 6:52:28 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Paul Bezanson
-- Create date: 11/13/2012
-- Description:	Returns the proper email based on the passed parameter.  
--				Used to determine who notifications and alerts should be sent to.
-- =============================================
CREATE function [dbo].[uf_get_email] 
(
	-- add the parameters for the function here
	@recipient varchar(max) 	-- possible values: "lead_dba", "default"
)
returns varchar(max)
as
begin
	-- Declare the return variable here
	declare @result         varchar(max)

	-- Add the t-sql statements to compute the return value here
	set @recipient = ltrim(rtrim(lower(@recipient)))

    if @recipient is null or @recipient = '' 
		select @result = convert(varchar(max), value) from dbo.sysinfo si where parameter = 'default_email'
	else if charindex(':', @recipient) > 0    -- Parse colon separated arguments.  This is a special class of supported notation for recipients.
    	if rtrim(ltrim(lower(left(@recipient, charindex(':', @recipient) - 1)))) = 'operator' begin
            select @result = email_address from msdb..sysoperators s where name = rtrim(ltrim(right(@recipient, len(@recipient) - charindex(':', @recipient))))
            if @result = '' or @result is null      -- The colon separated argument did not match a valid SQL Operator.
		        select @result = convert(varchar(max), value) from dbo.sysinfo si where parameter = 'default_email'
            end
        else        -- The colon separated class specifier (left side of the colon) is not supported.
		    select @result = convert(varchar(max), value) from dbo.sysinfo si where parameter = 'default_email'
    else if @recipient = 'lead_dba' or @recipient = 'lead_dba_email' or @recipient = 'admin_dba_email' or @recipient = 'admin_dba' 
		select @result = convert(varchar(max), value) from dbo.sysinfo si where parameter = 'admin_dba_email'
	else if @recipient = 'lead_dba_pager' or @recipient = 'admin_dba_pager'
		select @result = convert(varchar(max), value) from dbo.sysinfo si where parameter = 'admin_dba_pager'
	else if @recipient = 'all_dbas'
		select @result = convert(varchar(max), value) from dbo.sysinfo si where parameter = 'dba_distribution'
	else if @recipient = 'license_dba'
		select @result = convert(varchar(max), value) from dbo.sysinfo si where parameter = 'license_dba'
	else if @recipient = 'alert_email_list' or @recipient = 'alert_email' 
		select @result = convert(varchar(max), value) from dbo.sysinfo si where parameter = 'alert_email_list'
	else if @recipient = 'alert_pager_list' or @recipient = 'alert_pager' 
		select @result = convert(varchar(max), value) from dbo.sysinfo si where parameter = 'alert_pager_list'
	else if @recipient = 'default' or @recipient = 'default_email'
		select @result = convert(varchar(max), value) from dbo.sysinfo si where parameter = 'default_email'
	else -- return the value passed in case it's a real email address
		select @result = @recipient 
	
	-- Make sure any @mail_to string uses ";" instead of "," and remove any spaces.
	set @result = replace(@result, ',', ';')
	set @result = replace(@result, ' ', '')

	-- In case something goes wrong above, make sure we return something!
	if @result = '' or @result is null
        select @result = convert(varchar(max), value) from dbo.sysinfo si where parameter = 'default_email'

	-- Return the result of the function
	return @result

end

--print dbo.uf_get_email('paul.bezanson@pacificsource.com, karl.kurien@pacificsource.com')



GO

ALTER AUTHORIZATION ON [dbo].[uf_get_email] TO  SCHEMA OWNER 
GO

/****** Object:  UserDefinedFunction [dbo].[uf_get_env_cd]    Script Date: 12/27/2025 6:52:28 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Paul Bezanson
-- Create date: 6/18/2015
-- Description:	Takes an environment ID (@env_id) and returns the the associated environment code.
--				if the @env_id paramenter is <= 0 or null, the result "Null" is returned.
--
--				This function searches the entirety of the lu_env table.
--
-- Results:
--		Either:
--			The name of the associated environment,
--		or
--			The word "Null".
-- =============================================
create function [dbo].[uf_get_env_cd](@env_id bigint)
returns sysname
as
begin
	declare @env_cd nvarchar(5)
	declare @rslt	sysname

	set @env_cd = null
	set @rslt = null

	-- Handle the case when we're passed an instance name and a domain name.
	if @env_id is not null and @env_id > 0 begin
		select @rslt = env_cd from dbo.lu_env le where env_id = @env_id
		set @env_cd = isnull(@rslt, 'Null')
		end

	-- Return the result of the function
	return @rslt
end

--print dbo.uf_get_env_cd(1)



GO

ALTER AUTHORIZATION ON [dbo].[uf_get_env_cd] TO  SCHEMA OWNER 
GO

/****** Object:  UserDefinedFunction [dbo].[uf_get_environment_from_instance_nm]    Script Date: 12/27/2025 6:52:29 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Paul Bezanson
-- Create date: 2016-12-06
-- Description:	Tries to determine the correct environment based on the name of the server.
-- =============================================
CREATE FUNCTION [dbo].[uf_get_environment_from_instance_nm] (@instance sysname)
RETURNS nvarchar(50)
AS
begin
	declare @charpos		int
	declare @environment	nvarchar(50)

	if @instance is null or @instance = ''
		set @environment = 'Unknown'
	else begin
		set @charpos = patindex('%[0-9]%', @instance)  -- Find the first numeric character.
		set @environment = case
								when substring(@instance, @charpos, 1) = '0' then 'Production'
								when substring(@instance, @charpos, 1) = '2' then 'Development'
								when substring(@instance, @charpos, 1) = '3' then 'Quality Assurance'
								when substring(@instance, @charpos, 1) = '5' then 'Sandbox'
							else 
								'Other'
							end
		end

	RETURN @environment
END

GO

ALTER AUTHORIZATION ON [dbo].[uf_get_environment_from_instance_nm] TO  SCHEMA OWNER 
GO

/****** Object:  UserDefinedFunction [dbo].[uf_get_instance_id]    Script Date: 12/27/2025 6:52:29 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Paul Bezanson
-- Create date: 6/18/2015
-- Description:	Takes an instance name and domain name and returns the instance_id of the instance.
--				if the @domain_nm paramenter is empty or null, the instance_id can still be obtained
--				if there are no other instances with the same name as @instance.
--
--				This function searches the entire instance library whether enabled, disabled,
--				decommissioned or not and returns the instance_id.  It makes no assumptions about 
--				instance state.
--
-- Results:
--		> 0 = The Instance ID of the specified instance and domain.
--		 -1 = No instance name supplied.
--		 -2 = Unable to find the specified instance name.
--		 -3 = Multiple instances with this name exist. No domain name supplied.
--		 -4 = Unable to find the specified instance within the specified domain.
--		 -5 = Not a registered instance.
-- =============================================
CREATE function [dbo].[uf_get_instance_id](@instance sysname, @domain_nm nvarchar(255))
returns bigint
as 
begin
	declare 
		@cnt			bigint,
		@rslt			bigint,
		@instance_nm	nvarchar(128)

	set @rslt = -1

	-- Handle the case when we're passed an instance name and a domain name.
	if @instance is not null and @instance <> '' begin
		-- Verify that we have the instance in the instances table.
		if not exists (select 1 from v_instances where instance = @instance) begin
			-- Check if the @instance is an alias.
			select @instance_nm = instance from dbo.v_inst_alias via where via.alias = @instance and via.inst_enabled = 1
			if @instance_nm is null
				set @rslt = -5		-- Not a registered instance.
			else
				set @instance = @instance_nm
			end
		end
	else
		set @rslt = -1		-- No instance name supplied.

	-- If we get here, we have a viable instance name
	-- Now check whether a domain name was passed.
	if @domain_nm is not null and @domain_nm <> '' begin
		-- If we have both an instance and domain name, we can determine the instance_id easily.
		select
			@rslt = i.instance_id
		from
			instances i
			inner join dbo.servers s on s.server_id = i.server_id
		where
			--i.enabled <> 255					-- enabled = 255 when instance decommissioned. <> 255 means instance is active.
			i.instance = @instance
			and s.domain_nm = @domain_nm	
					
		if @rslt < 0
			set @rslt = -4		-- Unable to find the specified instance in the specified domain.
		end

	-- No domain name.  The @domain_nm is empty but we can still match IF and ONLY IF there is only one active server with the specified instance name.
	else begin
		-- Determine how many active instances share the @instance name
		select @cnt = count(*) from instances where instance = @instance --and enabled <> 255
		if @cnt = 1 begin
			-- If there is only one instance by this name we can determine it's instance_id easily
			select @rslt = i.instance_id from dbo.instances i where instance = @instance --and enabled <> 255		-- enabled = 255 when instance decommissioned

			if @rslt < 0
				set @rslt = -2		-- Unable to find the specified instance name.
			end
		else begin
			set @rslt = -3		-- Multiple instances with this name exist. No domain name supplied.
			end
		end
	    
	-- Return the result of the function
	return @rslt
end

--print dbo.uf_get_instance_id('dj', '')



GO

ALTER AUTHORIZATION ON [dbo].[uf_get_instance_id] TO  SCHEMA OWNER 
GO

/****** Object:  UserDefinedFunction [dbo].[uf_get_instance_id_enum]    Script Date: 12/27/2025 6:52:29 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Paul Bezanson
-- Create date: 6/18/2015
-- Description:	Enumerates the result of the [uf_get_instance_id] into a readable error message.
--
-- Results:
--		> 0 = The instance name of the specified instance and domain.
--		 -1 = No instance name supplied.
--		 -2 = Unable to find the specified instance name.
--		 -3 = No domain name supplied.
--		 -4 = Unable to find the specified instance within the specified domain.
-- =============================================
CREATE function [dbo].[uf_get_instance_id_enum] (@err_code bigint)
returns sysname
as
begin
	declare @rslt	sysname

	set @rslt = null

	set @rslt = 
		case 
			when @err_code = -1 then 'No instance name supplied.'
			when @err_code = -2 then 'Unable to find the specified instance name.'
			when @err_code = -3 then 'Multiple instances registered with this name.  Domain name required.'
			when @err_code = -4 then 'Unable to find the instance within the specified domain.'
			when @err_code = -5 then 'Not a registered instance.'
		else
			isnull((select instance from dbo.v_instances_all via where via.instance_id = @err_code), 'Unrecognized error code.')
			end
	    
	-- return the result of the function
	return @rslt
end		-- uf_get_instance_id_enum

--print dbo.uf_get_instance_id_enum(-1)


GO

ALTER AUTHORIZATION ON [dbo].[uf_get_instance_id_enum] TO  SCHEMA OWNER 
GO

/****** Object:  UserDefinedFunction [dbo].[uf_get_instance_id_from_dbid]    Script Date: 12/27/2025 6:52:29 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		Paul Bezanson
-- Create date: 12/11/2017
-- Description:	Accepts a datbase ID (db_list_id) and returns an instance name
-- =============================================
create function [dbo].[uf_get_instance_id_from_dbid] (@db_list_id bigint)
returns sysname
begin
    declare @instance_id    bigint

    select
        @instance_id = instance_id
    from 
        db_list dl
    where
        dl.db_list_id = @db_list_id

    return @instance_id
    end
GO

ALTER AUTHORIZATION ON [dbo].[uf_get_instance_id_from_dbid] TO  SCHEMA OWNER 
GO

/****** Object:  UserDefinedFunction [dbo].[uf_get_instance_name]    Script Date: 12/27/2025 6:52:29 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Paul Bezanson
-- Create date: 6/18/2015
-- Description:	Takes an instance ID and returns the the associated instance name.
--				if the @instance_id paramenter is <= 0 or null, the result "Null" is returned.
--
--				This function searches the entirety of the instance table whether enabled, disabled,
--				decommissioned or not and returns the instance name.  It makes no assumptions about 
--				instance state.
--
-- Results:
--		Either:
--			The name of the associated instance,
--		or
--			The word "Null".
-- =============================================
CREATE function [dbo].[uf_get_instance_name](@instance_id bigint)
returns sysname
as
begin
	declare @instance	sysname
	declare @rslt	sysname

	set @instance = null
	set @rslt = null

	-- Handle the case when we're passed an instance name and a domain name.
	if @instance_id is not null and @instance_id > 0 begin
		select @rslt = instance from instances where instance_id = @instance_id
		set @instance = isnull(@rslt, 'Null')
		end
	else
		set @rslt = '<Instance name not found!>'

	-- Return the result of the function
	return @rslt
end

--print dbo.uf_get_instance_name(123)



GO

ALTER AUTHORIZATION ON [dbo].[uf_get_instance_name] TO  SCHEMA OWNER 
GO

/****** Object:  UserDefinedFunction [dbo].[uf_get_instance_name_from_dbid]    Script Date: 12/27/2025 6:52:30 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		Paul Bezanson
-- Create date: 12/11/2017
-- Description:	Accepts a datbase ID (db_list_id) and returns an instance name
-- =============================================
create function [dbo].[uf_get_instance_name_from_dbid] (@db_list_id bigint)
returns sysname
begin
    declare @instance   sysname

    select
        @instance = i.instance
    from 
        db_list dl
        inner join instances i on i.instance_id = dl.instance_id
    where
        dl.db_list_id = @db_list_id

    return @instance
    end
GO

ALTER AUTHORIZATION ON [dbo].[uf_get_instance_name_from_dbid] TO  SCHEMA OWNER 
GO

/****** Object:  UserDefinedFunction [dbo].[uf_get_link_from_server_id]    Script Date: 12/27/2025 6:52:30 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Paul Bezanson
-- Create date: 6/18/2015
-- Description:	Returns a linked server name that will work for the server specified by
--              the param (which contains a server_id argument).  For any given server_id
--              there could be more than one instance running on the server.  Any of the
--              instance's linked server will work to reach the server, we just need one.
--              This function is used by procedures that work with servers rather than
--              instances.
--
-- Results:
--      The name of a linked server that will connect with the server represented by
--      the specified server_id.
-- =============================================
CREATE function [dbo].[uf_get_link_from_server_id](@param bigint)
returns nvarchar(max)
as
begin
	declare @rslt	nvarchar(max)

	select @rslt = min(linked_server) from instances where server_id = @param and enabled in (0,1)

	-- Return the result of the function
	return @rslt
end

--print dbo.uf_get_link_from_server_id(81)

GO

ALTER AUTHORIZATION ON [dbo].[uf_get_link_from_server_id] TO  SCHEMA OWNER 
GO

/****** Object:  UserDefinedFunction [dbo].[uf_get_link_server_cnt]    Script Date: 12/27/2025 6:52:30 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Paul Bezanson
-- Create date: 6/18/2015
-- Description:	Takes a linked server name and returns the instance count from the link_server_state table.
--				
--
-- Results:
--		Either:
--			The instance count,
--		or
--			-1 if not found
-- =============================================
CREATE function [dbo].[uf_get_link_server_cnt](@link_name nvarchar(128))
returns int
as
begin
	declare @rslt		int

	select @rslt = instance_cnt from dbo.link_server_state where link_server_nm = @link_name

	set @rslt = isnull(@rslt, 0)

	-- Return the result of the function
	return @rslt
end

--print dbo.uf_get_link_server_cnt('test')



GO

ALTER AUTHORIZATION ON [dbo].[uf_get_link_server_cnt] TO  SCHEMA OWNER 
GO

/****** Object:  UserDefinedFunction [dbo].[uf_get_server_id]    Script Date: 12/27/2025 6:52:30 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Paul Bezanson
-- Create date: 1/15/2021
-- Description:	Takes an server name and domain name and returns the server_id of the server.
--				if the @domain_nm paramenter is empty or null, the server_id can still be obtained
--				if there are no other instances with the same name as @@server_nm.
--
--				This function searches the entire server library returns the server_id if it exists.  
--
-- Results:
--		> 0 = The Server ID of the specified server and domain.
--		 -1 = No server name supplied.
--		 -2 = Unable to find the specified server name.
--		 -3 = Multiple servers with this name exist. No domain name supplied.
--		 -4 = Unable to find the specified server within the specified domain.
--		 -5 = Not a registered instance.
-- =============================================
create   function [dbo].[uf_get_server_id](@server_nm nvarchar(128), @domain_nm nvarchar(255))
returns bigint
as
begin
	declare @cnt	bigint
	declare @rslt	bigint

	set @rslt = -1

	-- Handle the case when we're passed an instance name and a domain name.
	if @server_nm is not null and @server_nm <> '' begin
		if not exists (select s.server_id from servers s where s.server_name = @server_nm)
			set @rslt = -5		-- Not a registered server.
		else begin
			if @domain_nm is not null and @domain_nm <> '' begin
				-- If we have both an instance and domain name, we can determine the instance_id easily.
				select
					@rslt = s.server_id
				from
					servers s
					inner join dbo.instances i on s.server_id = i.server_id
				where
					--i.enabled <> 255					-- enabled = 255 when instance decommissioned. <> 255 means instance is active.
					s.server_name = @server_nm
					and s.domain_nm = @domain_nm	
					
				if @rslt < 0
					set @rslt = -4		-- Unable to find the specified instance in the specified domain.
				end

			-- No domain name.  The @domain_nm is empty but we can still match IF and ONLY IF there is only one active server with the specified instance name.
			else begin
				-- Determine how many active servers share the @server_nm 
				select @cnt = count(*) from servers s where s.server_name = @server_nm
				if @cnt = 1 begin
					-- If there is only one server by this name we can determine it's server_id easily
					select @rslt = s.server_id from servers s where server_name = @server_nm

					if @rslt < 0
						set @rslt = -2		-- Unable to find the specified server name.
					end
				else begin
					set @rslt = -3		-- Multiple servers with this name exist. No domain name supplied.
					end
				end
			end
		end
	else
		set @rslt = -1		-- No server name supplied.
	    
	-- Return the result of the function
	return @rslt
end

--print dbo.uf_get_server_id('dj', '')



GO

ALTER AUTHORIZATION ON [dbo].[uf_get_server_id] TO  SCHEMA OWNER 
GO

/****** Object:  UserDefinedFunction [dbo].[uf_get_server_name]    Script Date: 12/27/2025 6:52:30 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Paul Bezanson
-- Create date: 1/14/2021
-- Description:	Takes an server ID and returns the the associated server name.
--				if the @server_id paramenter is <= 0 or null, the result "Null" is returned.
--
--				This function searches the entirety of the server table.
--
-- Results:
--		Either:
--			The name of the associated server,
--		or
--			The word "Null".
-- =============================================
create   function [dbo].[uf_get_server_name](@server_id bigint)
returns sysname
as
begin
	declare @server_nm	sysname
	declare @rslt	sysname

	set @server_nm = null
	set @rslt = null

	-- Handle the case when we're passed an instance name and a domain name.
	if @server_id is not null and @server_id > 0 begin
		select @rslt = server_name from servers where server_id = @server_id
		set @server_nm = isnull(@rslt, 'Null')
		end
	else
		set @rslt = '<Server name not found!>'

	-- Return the result of the function
	return @rslt
end

--print dbo.uf_get_server_name(9)



GO

ALTER AUTHORIZATION ON [dbo].[uf_get_server_name] TO  SCHEMA OWNER 
GO

/****** Object:  UserDefinedFunction [dbo].[uf_get_sh_test_id]    Script Date: 12/27/2025 6:52:31 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		paul bezanson
-- Create date: 11/20/2020
-- Description:	returns the sec hardening test id from the sec_hardening_tests table.
-- =============================================
CREATE function [dbo].[uf_get_sh_test_id] (
	@test_desc				varchar(50)
	)
returns bigint as
begin
	declare 
		@test_id			bigint

	select @test_id = sec_hardening_tests_id from dbo.sec_hardening_tests sht where lower(sht.test_nm) = lower(@test_desc)

	return @test_id
	end

GO

ALTER AUTHORIZATION ON [dbo].[uf_get_sh_test_id] TO  SCHEMA OWNER 
GO

/****** Object:  UserDefinedFunction [dbo].[uf_get_sysinfo]    Script Date: 12/27/2025 6:52:31 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Paul Bezanson
-- Create date: 6/18/2015
-- Description:	Takes a dbo.sysinfo parameter value and returns the the associated value.
--
-- Results:
--		Either:
--			The name of the associated instance,
--		or
--			The word "Null".
-- =============================================
CREATE function [dbo].[uf_get_sysinfo](@param varchar(50))
returns nvarchar(max)
as
begin
	declare @rslt	nvarchar(max)

	select @rslt = value from dbo.sysinfo where parameter = @param

	-- Return the result of the function
	return @rslt
end

--print dbo.uf_get_sysinfo('licensee')

GO

ALTER AUTHORIZATION ON [dbo].[uf_get_sysinfo] TO  SCHEMA OWNER 
GO

/****** Object:  UserDefinedFunction [dbo].[uf_get_systems_id]    Script Date: 12/27/2025 6:52:31 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Paul Bezanson
-- Create date: 4/16/2020
-- Description:	Retrieves the systems_id for the "<None>" entry inthe systems table.
-- =============================================
create function [dbo].[uf_get_systems_id] (
	@system_nm varchar(100)
	)
returns bigint
as begin
	declare @systems_id		bigint

	select @systems_id = systems_id from systems where system_nm = @system_nm
	
	if @systems_id is null
		set @systems_id = -1

	return @systems_id
	end
GO

ALTER AUTHORIZATION ON [dbo].[uf_get_systems_id] TO  SCHEMA OWNER 
GO

/****** Object:  UserDefinedFunction [dbo].[uf_host_version_build]    Script Date: 12/27/2025 6:52:31 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================  
-- Author:  Paul Bezanson  
-- Create date: 05/04/18  
-- Description: Returns the type of os running on the remote server.  
-- =============================================  
CREATE function [dbo].[uf_host_version_build] (  
    @host_version nvarchar(2000)  
    )  
returns nvarchar(100)  
as  
begin  
    declare @result varchar(100)  
  
    select @result = 
        case  
            when charindex('build', lower(@host_version)) > 0 then   
                left(right(@host_version, len(@host_version) - charindex('build', @host_version) - len('build')),   
                charindex(':', right(@host_version, len(@host_version) - charindex('build', @host_version) - len('build'))) - 1)  
            else 'No Build Number'  
            end  
  
    return @result  
end  
GO

ALTER AUTHORIZATION ON [dbo].[uf_host_version_build] TO  SCHEMA OWNER 
GO

/****** Object:  UserDefinedFunction [dbo].[uf_host_version_common_nm]    Script Date: 12/27/2025 6:52:31 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Paul Bezanson
-- Create date: 05/04/18
-- Description:	Calculates and returns the common name of os running on the remote server.
-- =============================================
CREATE function [dbo].[uf_host_version_common_nm] (
	@os_nm nvarchar(100),
    @release_no varchar(50)
    )
returns nvarchar(100)
as
begin
	declare @result varchar(2000)

    select @result = case
    when @os_nm like 'Windows NT%' then 
        case
            when @release_no = '5.0' then 'Windows 2000'
            when @release_no = '5.2' then 'Windows Server 2003'
            when @release_no = '6.0' then 'Windows Server 2008'
            when @release_no = '6.1' then 'Windows Server 2008 R2'
            when @release_no = '6.2' then 'Windows Server 2012'
            when @release_no = '6.3' then 'Windows Server 2012 R2'
            when @release_no = '10.0' then 'Windows Server 2016'
            else 'Unknown'
            end
    when @os_nm like 'Windows Server%' then 
        @os_nm
    else 
        case
            when @release_no = '5.1' then 'Windows XP'
            when @release_no = '5.2' then 'Windows XP 64-Bit Edition'
            when @release_no = '6.0' then 'Windows Vista'
            when @release_no = '6.1' then 'Windows 7'
            when @release_no = '6.2' then 'Windows 8'
            when @release_no = '6.3' then 'Windows 8.1'
            when @release_no = '10.0' then 'Windows 10'
            else 'Unknown'
            end
        end
	return @result
end
GO

ALTER AUTHORIZATION ON [dbo].[uf_host_version_common_nm] TO  SCHEMA OWNER 
GO

/****** Object:  UserDefinedFunction [dbo].[uf_host_version_is_vm]    Script Date: 12/27/2025 6:52:32 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Paul Bezanson
-- Create date: 05/04/18
-- Description:	Returns 1 if the os is a VM (hypervisor); 0 if it is a physical machine.
-- =============================================
CREATE function [dbo].[uf_host_version_is_vm] (
	@host_version nvarchar(100)
    )
returns bit
as
begin
	declare @result bit

    if (charindex('hypervisor', lower(@host_version)) = 0 and charindex('(VM)', lower(@host_version)) = 0) or charindex('hypervisor', lower(@host_version)) is null
        set @result = 0
    else
        set @result = 1

	return @result
end
GO

ALTER AUTHORIZATION ON [dbo].[uf_host_version_is_vm] TO  SCHEMA OWNER 
GO

/****** Object:  UserDefinedFunction [dbo].[uf_host_version_os]    Script Date: 12/27/2025 6:52:32 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Paul Bezanson
-- Create date: 05/04/18
-- Description:	Returns the type of os running on the remote server.
-- =============================================
CREATE function [dbo].[uf_host_version_os] (
	@host_version nvarchar(2000)
    )
returns nvarchar(2000)
as
begin
	declare @result varchar(2000)

    select @result = reverse(right(reverse(left(@host_version, charindex('.', @host_version))), len(reverse(left(@host_version, charindex('.', @host_version)))) - charindex(' ', reverse(left(@host_version, charindex('.', @host_version))))))

	return @result
end
GO

ALTER AUTHORIZATION ON [dbo].[uf_host_version_os] TO  SCHEMA OWNER 
GO

/****** Object:  UserDefinedFunction [dbo].[uf_host_version_release_no]    Script Date: 12/27/2025 6:52:32 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Paul Bezanson
-- Create date: 05/04/18
-- Description:	Returns the release number of the os running on the remote server.
-- =============================================
create function [dbo].[uf_host_version_release_no] (
	@host_version nvarchar(100)
    )
returns nvarchar(100)
as
begin
	declare @result nvarchar(100)

    select @result = 
        reverse(
            left(reverse(left(@host_version, charindex('.', @host_version))), charindex(
                                                                              ' ',
                                                                              reverse(
                                                                                  left(@host_version, charindex(
                                                                                                        '.', @host_version)))) - 1))
        + substring(
              @host_version,
              charindex('.', @host_version) + 1,
              len(charindex(' ', @host_version, charindex('.', @host_version))) - 1)

	return @result
end
GO

ALTER AUTHORIZATION ON [dbo].[uf_host_version_release_no] TO  SCHEMA OWNER 
GO

/****** Object:  UserDefinedFunction [dbo].[uf_is_compliant]    Script Date: 12/27/2025 6:52:32 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Paul Bezanson
-- Create date: 11/25/2020
-- Description:	Returns the number of SQL Servers in compliance with
--				the PacificSource Security Policy within the specified
--				batch.
-- =============================================
CREATE function [dbo].[uf_is_compliant] (
	@batch_no		bigint,
	@env_cd			nvarchar(5),
	@test_id		bigint
	)
returns int
as
begin
	-- Declare the return variable here
	declare 
		@cnt		int

	-- No Test ID; No Environment
	if (@env_cd is null or @env_cd = '') and (@test_id is null or @test_id <= 0)
		select @cnt = count(*)
		from 
			(select
				vshr.instance
			from dbo.v_sec_hardening_results vshr
			where
				batch_no = @batch_no
			group by vshr.instance) t

	-- No Test ID; Environment
	else if @env_cd is not null and @env_cd <> '' and (@test_id is null or @test_id <= 0)
		select @cnt = count(*)
		from 
			(select
				vshr.instance
			from 
				dbo.v_sec_hardening_results vshr
				inner join instances i on i.instance_id = vshr.instance_id
				inner join lu_env le on le.env_id = i.env_id
			where
				batch_no = @batch_no
				and le.env_cd = @env_cd
			group by vshr.instance) t

	-- Test ID; No Environment
	else if (@env_cd is null or @env_cd = '') and @test_id is not null and @test_id > 0
		select @cnt = count(*)
		from 
			(select
				vshr.instance
			from 
				dbo.v_sec_hardening_results vshr
				inner join dbo.sec_hardening_tests sht on sht.sec_hardening_tests_id = vshr.sec_hardening_tests_id
			where
				batch_no = @batch_no
				and sht.sec_hardening_tests_id = @test_id
			group by vshr.instance) t

	-- Test ID; Environment
	else if @env_cd is not null and @env_cd <> '' and @test_id is not null and @test_id > 0
		select @cnt = count(*)
		from 
			(select
				vshr.instance
			from				
				dbo.v_sec_hardening_results vshr
				inner join instances i on i.instance_id = vshr.instance_id
				inner join lu_env le on le.env_id = i.env_id
				inner join dbo.sec_hardening_tests sht on sht.sec_hardening_tests_id = vshr.sec_hardening_tests_id
			where
				batch_no = @batch_no
				and le.env_cd = @env_cd
				and sht.sec_hardening_tests_id = @test_id
			group by vshr.instance) t


	-- Return the result of the function
	return @cnt

end
GO

ALTER AUTHORIZATION ON [dbo].[uf_is_compliant] TO  SCHEMA OWNER 
GO

/****** Object:  UserDefinedFunction [dbo].[uf_is_exempt]    Script Date: 12/27/2025 6:52:32 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--=========================================
-- Create scalar-valued function template
--=========================================

CREATE function [dbo].[uf_is_exempt] (
	@test_id		bigint,
	@instance_id	bigint, 
	@db_list_id		bigint = null 
	)
returns smallint
as
begin
	declare @rslt		smallint

	-- If we make it this far, then we have a valid test.  Now if it's not already present in the table, add it.
	if @db_list_id is null begin		-- instance
		-- Checking for match on instance must not include a test of dbname which will be null.
		if exists(select 1 from dbo.sec_hardening_exempt she where she.instance_id = @instance_id and she.sec_hardening_tests_id = @test_id)
			set @rslt = 1
		else
			set @rslt = 0
		end
	else begin			-- database
		-- Checking for match on database must include a test of dbname which will not be null.
		if exists(select 1 from dbo.sec_hardening_exempt she where she.instance_id = @instance_id and she.db_list_id = @db_list_id and she.sec_hardening_tests_id = @test_id)
			set @rslt = 1
		else
			set @rslt = 0
		end	
		
	return @rslt	
	end

GO

ALTER AUTHORIZATION ON [dbo].[uf_is_exempt] TO  SCHEMA OWNER 
GO

/****** Object:  UserDefinedFunction [dbo].[uf_is_exempt_related]    Script Date: 12/27/2025 6:52:32 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--=========================================
-- Create scalar-valued function template
--=========================================

CREATE function [dbo].[uf_is_exempt_related] (
	@test_id		bigint,			-- test id of the dependent test
	@instance_id	bigint, 
	@db_list_id		bigint = null 
	)
returns bigint		-- Returns the sec_hardening_test_id of the primary test.
as
begin
	declare @rslt		bigint

	-- If we make it this far, then we have a valid test.  Now if it's not already present in the table, add it.
	if @db_list_id is null begin		-- instance
		-- Checking for match on instance must not include a test of dbname which will be null.
		select 
			@rslt = vshtr.exempt_id
		from
			dbo.v_sec_hardening_exempt vshe
			inner join dbo.v_sec_hardening_tests_related vshtr on vshe.sec_hardening_tests_id = vshtr.exempt_id
		where
			instance_id = @instance_id
			and dbo.uf_is_exempt(vshtr.exempt_id, @instance_id, null) = 1
			and vshtr.dependent_id = @test_id

		if @rslt is not null and @rslt > 0	
			set @rslt = 1
		else
			set @rslt = 0
		end
	else begin			-- database
		-- Checking for match on database must include a test of dbname which will not be null.
		select 
			@rslt = vshtr.exempt_id
		from
			dbo.v_sec_hardening_exempt vshe
			inner join dbo.v_sec_hardening_tests_related vshtr on vshe.sec_hardening_tests_id = vshtr.exempt_id
		where
			instance_id = @instance_id
			and db_list_id = @db_list_id
			and dbo.uf_is_exempt(vshtr.exempt_id, @instance_id, null) = 1
			and vshtr.dependent_id = @test_id

		if @rslt is not null and @rslt > 0		
			set @rslt = 1
		else
			set @rslt = 0
		end	
		
	return @rslt	
	end

GO

ALTER AUTHORIZATION ON [dbo].[uf_is_exempt_related] TO  SCHEMA OWNER 
GO

/****** Object:  UserDefinedFunction [dbo].[uf_is_not_compliant]    Script Date: 12/27/2025 6:52:33 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Paul Bezanson
-- Create date: 11/25/2020
-- Description:	Returns the number of SQL Servers not in compliance with
--				the PacificSource Security Policy within the specified
--				batch.
-- =============================================
CREATE function [dbo].[uf_is_not_compliant] (
	@batch_no		bigint,
	@env_cd			nvarchar(5),
	@test_id		bigint
	)
returns int
as
begin
	-- Declare the return variable here
	declare 
		@cnt		int

	select @cnt = count(*)
		from 
			(select
				vshr.instance
			from dbo.v_sec_hardening_results vshr
			where
				batch_no = @batch_no
				and (charindex(results, vshr.accepted_values) = case left(vshr.accepted_values, 1) when '>' then '9999' else '0' end
						or results <= case left(vshr.accepted_values, 1) when '>' then right(vshr.accepted_values, len(vshr.accepted_values) - 1) else null end)
			group by vshr.instance) t

	-- No Test ID; No Environment
	if (@env_cd is null or @env_cd = '') and (@test_id is null or @test_id <= 0)
		select @cnt = count(*)
		from 
			(select
				vshr.instance
			from dbo.v_sec_hardening_results vshr
			where
				batch_no = @batch_no
				and (charindex(results, vshr.accepted_values) = case left(vshr.accepted_values, 1) when '>' then '9999' else '0' end
						or results <= case left(vshr.accepted_values, 1) when '>' then right(vshr.accepted_values, len(vshr.accepted_values) - 1) else null end)
			group by vshr.instance) t

	-- No Test ID; Environment
	else if @env_cd is not null and @env_cd <> '' and (@test_id is null or @test_id <= 0)
		select @cnt = count(*)
		from 
			(select
				vshr.instance
			from 
				dbo.v_sec_hardening_results vshr
				inner join instances i on i.instance_id = vshr.instance_id
				inner join lu_env le on le.env_id = i.env_id
			where
				batch_no = @batch_no
				and le.env_cd = @env_cd
				and (charindex(results, vshr.accepted_values) = case left(vshr.accepted_values, 1) when '>' then '9999' else '0' end
						or results <= case left(vshr.accepted_values, 1) when '>' then right(vshr.accepted_values, len(vshr.accepted_values) - 1) else null end)
			group by vshr.instance) t

	-- Test ID; No Environment
	else if (@env_cd is null or @env_cd = '') and @test_id is not null and @test_id > 0
		select @cnt = count(*)
		from 
			(select
				vshr.instance
			from 
				dbo.v_sec_hardening_results vshr
				inner join dbo.sec_hardening_tests sht on sht.sec_hardening_tests_id = vshr.sec_hardening_tests_id
			where
				batch_no = @batch_no
				and sht.sec_hardening_tests_id = @test_id
				and (charindex(results, vshr.accepted_values) = case left(vshr.accepted_values, 1) when '>' then '9999' else '0' end
						or results <= case left(vshr.accepted_values, 1) when '>' then right(vshr.accepted_values, len(vshr.accepted_values) - 1) else null end)
			group by vshr.instance) t

	-- Test ID; Environment
	else if @env_cd is not null and @env_cd <> '' and @test_id is not null and @test_id > 0
		select @cnt = count(*)
		from 
			(select
				vshr.instance
			from				
				dbo.v_sec_hardening_results vshr
				inner join instances i on i.instance_id = vshr.instance_id
				inner join lu_env le on le.env_id = i.env_id
				inner join dbo.sec_hardening_tests sht on sht.sec_hardening_tests_id = vshr.sec_hardening_tests_id
			where
				batch_no = @batch_no
				and le.env_cd = @env_cd
				and sht.sec_hardening_tests_id = @test_id
				and (charindex(results, vshr.accepted_values) = case left(vshr.accepted_values, 1) when '>' then '9999' else '0' end
						or results <= case left(vshr.accepted_values, 1) when '>' then right(vshr.accepted_values, len(vshr.accepted_values) - 1) else null end)
			group by vshr.instance) t
	-- Return the result of the function
	return @cnt

end
GO

ALTER AUTHORIZATION ON [dbo].[uf_is_not_compliant] TO  SCHEMA OWNER 
GO

/****** Object:  UserDefinedFunction [dbo].[uf_max_db_revision]    Script Date: 12/27/2025 6:52:33 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Paul Bezanson
-- Create date: 10/06/11
-- Description:	Returns the maximum revision date for the specified instance/database.
--				This is similar to the "uf_max_revision" function but returns the 
--				maximum revision for a given database.  (Not all current databases
--				have the same maximum revision.)
--
-- History
-------------------------------------------------
--	07/02/15	pbezanson	Updated to use instance_id for selection of proper database
--							rather than instance.  This supports new functionality
--							allowing there to be more than one instance with the same
--							name but different domain.
-- =============================================
CREATE function [dbo].[uf_max_db_revision] (
	@instance		nvarchar(128),
	@domain_nm		nvarchar(255),
	@dbname			nvarchar(128)
	)
returns datetime
as begin
	-- Declare the return variable here
	declare @max_rev		datetime
	declare @instance_id	bigint

	set @instance_id = 0

	-- Get the instance_id so we can grab the correct database data.
    select
        @instance_id = instance_id
    from
        dbo.v_instance_all via
    where
        via.instance = @instance
        and via.domain_nm = @domain_nm;

	-- Return with -1 if we can't find the instance.
	if @instance_id <= 0
		return -1

	-- Add the T-SQL statements to compute the return value here
	select
		@max_rev = max(di.revision)
	from
		dbo.db_list dl inner join 
		dbo.db_history di on dl.db_list_id = di.db_list_id
	where
		dl.instance_id = @instance_id
		and dl.dbname = @dbname
		and di.is_current = 1

	-- Return the result of the function
	return @max_rev

	end



GO

ALTER AUTHORIZATION ON [dbo].[uf_max_db_revision] TO  SCHEMA OWNER 
GO

/****** Object:  UserDefinedFunction [dbo].[uf_max_revision]    Script Date: 12/27/2025 6:52:33 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[uf_max_revision] ()
RETURNS datetime
AS BEGIN
	-- Declare the return variable here
	DECLARE @max_rev as datetime

	-- Add the T-SQL statements to compute the return value here
	SELECT @max_rev = max(db_history.revision) from dbo.db_history

	-- Return the result of the function
	RETURN @max_rev

	END



GO

ALTER AUTHORIZATION ON [dbo].[uf_max_revision] TO  SCHEMA OWNER 
GO

/****** Object:  UserDefinedFunction [dbo].[uf_max_revision_ex]    Script Date: 12/27/2025 6:52:33 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Paul Bezanson
-- Create date: 3/15/10
-- Description:	Returns the maximum revision date for the specified table.
--				This is similar to the "uf_max_revision" function but extended to allow
--				the caller to specify the table hosting the revision column.
-- Returns:		The most recent revision for the specified table.  If no table was found
--				matching the argument, it returns NULL.
-- =============================================
CREATE function [dbo].[uf_max_revision_ex] (@tbl_name varchar(50))
returns datetime
as begin
	-- Declare the return variable here
	declare @max_rev as datetime

	-- Add the T-SQL statements to compute the return value here
	if @tbl_name = 'db_history'
		select @max_rev = max(db_history.revision) from dbo.db_history
	else if @tbl_name = 'instance_history'
		select @max_rev = max(instance_history.revision) from dbo.instance_history

	-- Return the result of the function
	return @max_rev

	end



GO

ALTER AUTHORIZATION ON [dbo].[uf_max_revision_ex] TO  SCHEMA OWNER 
GO

/****** Object:  UserDefinedFunction [dbo].[uf_nTimepart]    Script Date: 12/27/2025 6:52:33 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


create function [dbo].[uf_nTimepart] (
	@nTime bigint, 
	@datepart char(1) 
	) returns int
as
begin
	declare @part_value	int
	declare @nTm varchar(8)
	
	-- Parameter validation.
	if @nTime is null or @datepart is null or @datepart = ''
		return -1
	
	-- Create the character version of the numeric time.  Pad left to 8 characters with 0's.
	set @nTm = replicate('0', 8 - len(cast(@nTime as varchar(8)))) + cast(@nTime as varchar(8))
	
	select @part_value = case lower(@datepart)
		when 'd' then cast(substring(@nTm, 1, 2) as int)
		when 'h' then cast(substring(@nTm, 3, 2) as int)
		when 'm' then cast(substring(@nTm, 5, 2) as int)
		when 's' then cast(substring(@nTm, 7, 2) as int)
		else
			0
		end

	return @part_value 
end


GO

ALTER AUTHORIZATION ON [dbo].[uf_nTimepart] TO  SCHEMA OWNER 
GO

/****** Object:  UserDefinedFunction [dbo].[uf_prior_revision]    Script Date: 12/27/2025 6:52:34 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[uf_prior_revision]()
RETURNS datetime
AS
BEGIN
	-- Declare the return variable here
	DECLARE @max_rev as datetime

	-- Add the T-SQL statements to compute the return value here
	select @max_rev = max(db_info.revision)
	from dbo.db_info
	where db_info.revision <> dbo.uf_max_revision()

	-- Return the result of the function
	RETURN @max_rev

END

GO

ALTER AUTHORIZATION ON [dbo].[uf_prior_revision] TO  SCHEMA OWNER 
GO

/****** Object:  UserDefinedFunction [dbo].[uf_qualify_instance_nm]    Script Date: 12/27/2025 6:52:34 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		pbezanson
-- Create date: 01/31/17
-- Description:	Returns a fully qualified instance name.  (server.domain_nm\instance_nm)
-- =============================================
CREATE function [dbo].[uf_qualify_instance_nm] 
(
	-- Add the parameters for the function here
	@instance sysname,
	@domain_nm	nvarchar(255)
)
returns 
	nvarchar(255)
as
begin				
	declare	@server_nm		sysname
	declare @instance_nm	sysname
	declare @qualified_nm	nvarchar(255)
	declare @slash_pos		int

	if @instance is not null and @domain_nm is not null begin
		set @instance = ltrim(rtrim(@instance))
		set @domain_nm = ltrim(rtrim(@domain_nm))

		set @slash_pos = charindex('\', @instance)
		if @slash_pos > 0 begin
			set @server_nm = left(@instance, @slash_pos - 1)
			set @instance_nm = right(@instance, len(@instance) - charindex('\', @instance))
			set @qualified_nm = @server_nm + '.' + @domain_nm + '\' + @instance_nm
			end
		else begin
			set @qualified_nm = @instance + '.' + @domain_nm
			end
		end
	else
		set @qualified_nm = ''

	return @qualified_nm
	end		-- uf_qualify_instance_nm 

GO

ALTER AUTHORIZATION ON [dbo].[uf_qualify_instance_nm] TO  SCHEMA OWNER 
GO

/****** Object:  UserDefinedFunction [dbo].[uf_revision_by_ord]    Script Date: 12/27/2025 6:52:34 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Paul Bezanson
-- Create date: 08/24/2012
-- Description:	Returns the revision associated with the @prior_rev_num ordinal value.  1, 2, or 3 revisions prior to current, for example.
-- =============================================
create function [dbo].[uf_revision_by_ord] (@prior_rev_num int)
returns datetime
as begin
	-- Declare the return variable here
	declare @rev as datetime

	-- Make sure we have a valid @prior_rev_num value.
	if @prior_rev_num <= 0 
		set @prior_rev_num = 1

	-- Add the T-SQL statements to compute the return value here
	select @rev = t1.revision
	from (select distinct
			revision,
			dense_rank() over (order by revision desc) denserank
		from
			dbo.v_dbs_all vda
		) t1
	where
		denserank = @prior_rev_num


	-- Return the result of the function
	return @rev

	end



GO

ALTER AUTHORIZATION ON [dbo].[uf_revision_by_ord] TO  SCHEMA OWNER 
GO

/****** Object:  UserDefinedFunction [dbo].[uf_version_major]    Script Date: 12/27/2025 6:52:34 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Paul Bezanson
-- Create date: 12/12/11
-- Description:	Returns the major part of an instance version number.  
--				This number will probably come from the "instance_history" table.
-- =============================================
CREATE function [dbo].[uf_version_major] 
(
	-- Add the parameters for the function here
	@version nvarchar(50)
)
returns int
as
begin
	-- Declare the return variable here
	declare @Result int

	-- Add the T-SQL statements to compute the return value here
	select
		@Result = cast(left(@version, cast(case	when (charindex('.', @version) - 1) < 1 then len(@version)
												else charindex('.', @version) - 1
										   end as int)) as int)

	-- Return the result of the function
	return @Result

end



GO

ALTER AUTHORIZATION ON [dbo].[uf_version_major] TO  SCHEMA OWNER 
GO

/****** Object:  UserDefinedFunction [dbo].[uf_version_major_build]    Script Date: 12/27/2025 6:52:34 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Paul Bezanson
-- Create date: 07/08/19
-- Description:	Returns the major build part of an instance version number.  
--				This number will probably come from the "instance_history" table.
-- =============================================
CREATE function [dbo].[uf_version_major_build] 
(
	-- Add the parameters for the function here
	@version nvarchar(50)
)
returns int
as
begin
	-- Declare the return variable here
	declare 
		@Result int,
		@i		int,
		@pos	int,
		@tail	nvarchar(50)

	set @tail = @version

	set @pos = 0
	set @i = 0

	while @i < 2 begin
		set @pos = charindex('.', @tail)
		set @tail = right(@tail, len(@tail) - @pos)
		set @i = @i + 1
		end

	-- Add the T-SQL statements to compute the return value here
	select @Result = convert(int,
								case
								when charindex('.', @tail) = 0 then @tail
								when charindex('.', @tail) > 0 then left(@tail, charindex('.', @tail) - 1)
								else
									'-1'
								end)

	-- Return the result of the function
	return @Result

end



GO

ALTER AUTHORIZATION ON [dbo].[uf_version_major_build] TO  SCHEMA OWNER 
GO

/****** Object:  UserDefinedFunction [dbo].[uf_version_minor]    Script Date: 12/27/2025 6:52:35 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Paul Bezanson
-- Create date: 12/12/11
-- Description:	Returns the minor part of an instance version number.  
--				This number will probably come from the "instance_history" table.
-- =============================================
CREATE function [dbo].[uf_version_minor] 
(
	-- Add the parameters for the function here
	@version nvarchar(50)
)
returns int
as
begin
	-- Declare the return variable here
	declare @result int

	-- Add the T-SQL statements to compute the return value here
	select @result = cast(substring(
							@version, 
							charindex('.', @version) + 1, 
							case when (charindex('.', @version, charindex('.', @version) + 1) - charindex('.', @version) - 1) < 0 then 0
								 else (charindex('.', @version, charindex('.', @version) + 1) - charindex('.', @version) - 1)
								end
							)
						as int)

	-- Return the result of the function
	return @result

end



GO

ALTER AUTHORIZATION ON [dbo].[uf_version_minor] TO  SCHEMA OWNER 
GO

/****** Object:  UserDefinedFunction [dbo].[uf_version_text]    Script Date: 12/27/2025 6:52:35 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Paul Bezanson
-- Create date: 04/34/19
-- Description:	Returns the version in text form.
-- =============================================
CREATE function [dbo].[uf_version_text] (
	@version nvarchar(50)
    )
returns varchar(20)
as
begin
	-- Declare the return variable
	declare @Result varchar(20)

	-- Compute the return value
	select
		@Result = case cast(left(@version, cast(case when (charindex('.', @version) - 1) < 1 then 1
												else charindex('.', @version) - 1
										   end as int)) as int)
            when 8 then 'SQL2000'
            when 9 then 'SQL2005'
            when 10 then case left(
                                cast(substring(
							        @version, 
							        charindex('.', @version) + 1, 
							        case when (charindex('.', @version, charindex('.', @version) + 1) - charindex('.', @version) - 1) < 0 then 0
								         else (charindex('.', @version, charindex('.', @version) + 1) - charindex('.', @version) - 1)
								        end
							        ) as int),
                                 1)
                             when 0 then 'SQL2008'
                             when 5 then 'SQL2008R2'
                             else 'SQL2008?'
                             end
            when 11 then 'SQL2012'
            when 12 then 'SQL2014'
            when 13 then 'SQL2016'
			when 14 then 'SQL2017'
			when 15 then 'SQL2019'
			when 16 then 'SQL2022'
            else 'See uf_version_text'
            end 

  	-- Return the result of the function
	return @Result
end
GO

ALTER AUTHORIZATION ON [dbo].[uf_version_text] TO  SCHEMA OWNER 
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'This function returns the number that should be assigned as the next batch number.  This represents the "next batch".' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'FUNCTION',@level1name=N'uf_exec_log_next_batch'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The date in integer format.  20091024, for example.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'FUNCTION',@level1name=N'uf_fmtndate', @level2type=N'PARAMETER',@level2name=N'@dt'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Takes a date in numeric form (20091201 for example) and converts it to an appropriately formatted character string.  Numeric dates are difficult to manage and manipulate programatically but are used by SQL Server rather than Datetime in some system views.  Most notably are those system views associated with job managment.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'FUNCTION',@level1name=N'uf_fmtndate'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The time in integer format.  235959, for example.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'FUNCTION',@level1name=N'uf_fmtntime', @level2type=N'PARAMETER',@level2name=N'@tm'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Takes a time in numeric form (235959 for example) and converts it to an appropriately formatted character string.  Numeric times are difficult to manage and manipulate programatically but are used by SQL Server rather than Datetime in some system views.  Most notably are those system views associated with job managment.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'FUNCTION',@level1name=N'uf_fmtntime'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Any integer that requires formating.  [Required]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'FUNCTION',@level1name=N'uf_fmtnum', @level2type=N'PARAMETER',@level2name=N'@int_value'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'This function formats a T-SQL integer by inserting commas every three digits.  It currently does no more than this but may be expanded in the future.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'FUNCTION',@level1name=N'uf_fmtnum'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The name of the instance that contains the database whose maximum revision is to be returned.  [Required]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'FUNCTION',@level1name=N'uf_max_db_revision', @level2type=N'PARAMETER',@level2name=N'@instance'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The name of the database whose maximum revision is to be returned.  [Required]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'FUNCTION',@level1name=N'uf_max_db_revision', @level2type=N'PARAMETER',@level2name=N'@dbname'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Returns the maximum revision date for the specified instance/database.  This is similar to the max_revision" function but returns the maximum revision for a given database.  (Not all current databases have the same maximum revision.)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'FUNCTION',@level1name=N'uf_max_db_revision'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Returns the maximum revision value from the "db_info" table.  This corresponds to the latest import date and is used when use of the "is_current" flag is inappropriate for whatever reason.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'FUNCTION',@level1name=N'uf_max_revision'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'A table containing the maximum revision dates used by each instance.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'FUNCTION',@level1name=N'uf_max_revision_ex', @level2type=N'PARAMETER',@level2name=N'@tbl_name'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Returns the maximum revision date for the specified table.  This is similar to the "uf_max_revision" function but extended to allow the caller to specify the table.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'FUNCTION',@level1name=N'uf_max_revision_ex'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The time value we wish to examine, formated as a numeric.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'FUNCTION',@level1name=N'uf_nTimepart', @level2type=N'PARAMETER',@level2name=N'@nTime'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The component of the time value we wish to extract.  It may be any of the following:
d : days
h : hours
m : minutes
s : seconds' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'FUNCTION',@level1name=N'uf_nTimepart', @level2type=N'PARAMETER',@level2name=N'@datepart'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Returns an integer representing either the days, hours, minutes or seconds of a numeric time value.  Numeric time values are difficult to manage and manipulate.  This function assists in returning a specific component of the numeric time value.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'FUNCTION',@level1name=N'uf_nTimepart'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'This function returns the next to latest revision value from the "db_info" table.  This represents the set of data that was current prior to the most recent import.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'FUNCTION',@level1name=N'uf_prior_revision'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The number of revision prior to the current one.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'FUNCTION',@level1name=N'uf_revision_by_ord', @level2type=N'PARAMETER',@level2name=N'@prior_rev_num'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Returns the revision associated with the @prior_rev_num ordinal value.  1, 2, or 3 revisions prior to current, for example.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'FUNCTION',@level1name=N'uf_revision_by_ord'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The version number to be parsed.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'FUNCTION',@level1name=N'uf_version_major', @level2type=N'PARAMETER',@level2name=N'@version'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Returns the major part of the instance version number passed in the @version parameter.  This number will probably come from the "instance_history" table.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'FUNCTION',@level1name=N'uf_version_major'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The version number to be parsed.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'FUNCTION',@level1name=N'uf_version_minor', @level2type=N'PARAMETER',@level2name=N'@version'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Returns the minor part of the instance version number passed in the @version parameter.  This number will probably come from the "instance_history" table.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'FUNCTION',@level1name=N'uf_version_minor'
GO


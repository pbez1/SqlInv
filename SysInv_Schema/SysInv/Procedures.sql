USE [SqlInv]
GO

/****** Object:  StoredProcedure [dbo].[up_exec_log_cleanup]    Script Date: 12/27/2025 6:51:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-----------------------------------------------------------------------------------------
-- Procedure: up_exec_log_cleanup
--
-- Purpose:
--		This procedure deletes old inventory data sets according to the values passed
--		in the two input parameters.  It will keep an sliding window of the most recent
--		daily revisions (@days_to_keep), then will keep the first of every month and
--		the first day (Sunday) of every week for as many months as defined in 
--		@mns_to_keep.
--
--		The @days_to_keep parameter will prevent data sets collected within the time
--		window from being deleted.  A value of @days_to_keep = 14, for example, would
--		retain all of the data sets collected in the past 14 days and remove any other
--		data sets.  The only exception would be if the @mns_to_keep parameter has a 
--		value other than -1.
--
--		The @mns_to_keep parameter is intended to protect at least one data set a month
--		from deletion so that a long history can be maintained without retaining an 
--		inordinate amount of data.  The data set that is protected corresponds to the 
--		earliest data set collected that month.  A default of -1 protects all month 
--		beginning data sets.
--
-- Paramters:
--		@days_to_keep	:	int		(Optional)
--			Determines how many days of data to keep.  This will protect all data within 
--			the past @days_to_keep days from being deleted.  The most recent two datasets 
--			may not be deleted.  So a value of 1, for example will be converted 
--			internally to the value 2 to preserve the last 2 data sets.  Default is null.
--			If this parameter is specified the @mns_to_keep parameter is ignored.
--
--		@mns_to_keep	:	int		(Default: 1  Optional)
--			Determines how many months of data to keep.  Default is 1, which will 
--			protect all data created within the last month from the date this procedure
--			is executed.  If the @days_to_keep parameter is specified, this parameter is 
--			ignored.
--
-- Usage:
--		exec dbo.up_exec_log_cleanup
--			@days_to_keep		= <the number of days to keep as a possitive number>,
--			@mns_to_keep		= <the number of months to keep as a possitive number>
--
-- History:
-- --------
--	Date:		Who:		Description:
--	-----------	-----------	-------------------------------------------------------------
--	11/12/09	pbezanson	Created.
-----------------------------------------------------------------------------------------
create proc [dbo].[up_exec_log_cleanup]
	@days_to_keep		int		= null,
	@mns_to_keep		int		= 1,
	@batch_no			bigint	= null,
	@print				bigint	= null
as begin
	set nocount on

	declare	
		@targ_dt		datetime,
		@targ_dt_str	varchar(50),
		@mn_targ_dt		datetime,
		@mn_targ_dt_str	varchar(50),
		@batch_desc		varchar(128),
		@log_batch		bigint,
		@rev_dt			datetime,
		@msg			varchar(200)

	-- Record start of procedure.
	set @batch_desc = 'Exec Log Cleanup'
	set @rev_dt = getdate()
	exec dbo.up_exec_log_write
		@batch = -1,						
		@reporting_proc = null,				
		@msg = 'Starting exec_log cleanup.',							
		@print = @print,						
		@batch_description = @batch_desc,			
		@revision_dt = @rev_dt,
		@new_batch = @log_batch output	
			
	-- Handle the @days_to_keep parameter if it's not null
	if @days_to_keep is not null begin
		-- Reset the value of the @days_to_keep parameter if it is less than 2.
		if @days_to_keep < 2 
			set @days_to_keep = 2
		
		-- Calculate the @days_to_keep cutoff date
		-- Manipulate the date as a string then convert back to datetime.
		set @targ_dt_str = left(convert(varchar(50), dateadd(day, -@days_to_keep + 1, getdate()), 121), 10)
		set @targ_dt = cast(@targ_dt_str as datetime)
		end
	else begin
		set @days_to_keep = null  -- Just to be safe.

		-- Handle the @mns_to_keep cutoff date.
		if @mns_to_keep < 1 
			set @mns_to_keep = 1
		else begin
			-- Calculate the @months_to_keep cutoff date
			-- Manipulate the date as a string then convert back to datetime.
			set @mn_targ_dt_str = left(convert(varchar(50), dateadd(month, -@mns_to_keep, getdate()), 121), 10)
			set @mn_targ_dt = cast(@mn_targ_dt_str as datetime)
			end
		end

	if @days_to_keep is not null begin
		-- Use the day cutoff date.
		delete dbo.batch_revision
			where revision < @targ_dt

		set @msg = 'Finished exec_log cleanup.  ' + convert(varchar(10), @days_to_keep) + ' days have been retained.'
		end
	else begin
		-- Use the day cutoff date.
		delete dbo.batch_revision
			where revision < @mn_targ_dt

		set @msg = 'Finished exec_log cleanup.  ' + convert(varchar(10), @mns_to_keep) + ' month' + case when @mns_to_keep > 1 then 's have' else ' has' end + ' been retained.'
		end

	exec dbo.up_exec_log_write @log_batch, @batch_desc, @msg, @print

	set nocount off
	end		-- up_exec_log_cleanup

--exec dbo.up_exec_log_cleanup @mns_to_keep = 1

GO

ALTER AUTHORIZATION ON [dbo].[up_exec_log_cleanup] TO  SCHEMA OWNER 
GO

/****** Object:  StoredProcedure [dbo].[up_exec_log_set_new_batch]    Script Date: 12/27/2025 6:51:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-----------------------------------------------------------------------------------------
-- Procedure: dbo.up_exec_log_set_new_batch
--
-- Purpose:
--		This procedure opens a new batch for logging.  This happens at the start of any 
--		procedure that requires logging to a new batch.
--
-- Paramters:
--		@revision_dt		:	datetime	(Optional)
--			Allows the caller to specify a specific revision date.  If, for example, the
--			The up_inventory_load_from_staging procedure may wish to use the revision
--			date contained in the db_staging table as the revision date recorded in the
--			batch_revision table.  This parameter allows that.
--			
--			If not value is passed, this procedure sets the revision date to getdate().
--			[Optional]	Default = Null
--		@batch_description	:	varchar(128) = null
--			Provides a machanism to attach a description to a particular batch.  This
--			description should be brief and represent a category of work rather than a
--			free text description.
--
-- Usage:
--		exec dbo.up_exec_log_set_new_batch
--
-- History:
-- --------
--	Date:		Who:		Description:
--	-----------	-----------	-------------------------------------------------------------
--	09/11/12	pbezanson	Modifed the way the next batch is determined.  Prior to this
--							modification, two or more processes running at the same time
--							often received the same batch number resulting in duplicates
--							in the table.  This is because the code to retrieve the 
--							next batch number was separate from the code to set it.  The
--							modification encapsulates the determination of the next 
--							batch number within the insert statement thus making the 
--							operation atomic.  The batch number is still unknown to this
--							procedure however, since it has only been inserted into a 
--							table.  So the identity of the newly created row is returned
--							by the SCOPE_IDENTITY() function and the batch number is 
--							retreived from the table by selecting the row with the 
--							matching identity (batch_revision_id).  This guarentees the
--							uniqueness of the new batch number.
--	07/20/12	pbezanson	Added parameters @batch_description and @revision_dt to 
--							centralize the setting of these two parameters in the 
--							batch_revision table, rather than have that logic spread
--							around throughout the rest of the code.
--	11/12/09	pbezanson	Created.
-----------------------------------------------------------------------------------------
CREATE proc [dbo].[up_exec_log_set_new_batch]
	@revision_dt		datetime		= null,
	@batch_description	varchar(128)	= null
as begin
	declare @new_batch		bigint
	declare @err_no			varchar(10)
	declare @err_severity	varchar(10)
	declare @err_state		varchar(10)
	declare @err_line		varchar(10)
	declare @msg			varchar(max)

	-- If no revision time was provided default to now.
	if @revision_dt is null
		set @revision_dt = current_timestamp
	
	begin transaction
	begin try
		-- Get the next available batch number from the seq_batch_number sequence.
		set @new_batch = next value for dbo.seq_batch_number
        if @new_batch < 0 
            raiserror('Unable to get next exec_log batch number.  Procedure "up_exec_log_set_new_batch" failed.', 0, 0)

		-- Update the batch_revision table with the batch number, revision date and description if appropriate.
		insert into dbo.exec_log_batch (batch_no, revision, batch_desc)
		values (@new_batch, @revision_dt, @batch_description)

		-- Record the start of a new batch in the log.
		insert into exec_log (batch_no, reporting_proc, [message])
			values(@new_batch, 'dbo.up_exec_log_set_new_batch', '>>> START OF NEW BATCH <<<')

		commit transaction
		end try

	begin catch
		if @err_no is not null begin
			set @err_no = cast(isnull(Error_Number(), 0) as varchar(10))
			set @err_severity = cast(isnull(Error_SEVERITY(), 0) as varchar(10))
			set @err_state = cast(isnull(Error_State(), 0) as varchar(10))
			set @err_line = cast(isnull(Error_Line(), 0) as varchar(10))
			set @msg = isnull(ERROR_MESSAGE(), 'up_exec_log_set_new_batch: Creation of new batch failed. (Error_Message() unavailable.') + 
				' Err_no: ' + @err_no + ', Severity: ' + @err_severity + ', State: ' + @err_state + ', Line: ' + @err_line
			end

		-- Rollback the transaction
		rollback tran
		
		-- These messages must go after the rollback tran statement otherwise they are 
		-- rolled back and removed from the log with the other changes and disappear!
		if @msg is null or @msg = '' 
			set @msg = 'up_exec_log_set_new_batch: Creation of new batch failed for revision ' + convert(varchar(20), @revision_dt, 120) + ', and batch description: ' + @batch_description + '.'

		insert into exec_log (batch_no, reporting_proc, [message])
			values(-1, 'up_exec_log_set_new_batch', @msg)
			-- -1 is the exception batch.  If there is no batch number logs go here.

		return -1
		end catch

	set transaction isolation level read committed
	
	-- Return the new batch number in case anyone is intersted.
	return @new_batch
	end		-- up_exec_log_set_new_batch

GO

ALTER AUTHORIZATION ON [dbo].[up_exec_log_set_new_batch] TO  SCHEMA OWNER 
GO

/****** Object:  StoredProcedure [dbo].[up_exec_log_write]    Script Date: 12/27/2025 6:51:24 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-----------------------------------------------------------------------------------------
-- Procedure: dbo.up_exec_log_write
--
-- Purpose:
--		This procedure writes a message to the execution log ("exec_log" table).  It is 
--		called from within a procedure to log specific events. 
--
-- Paramters:
--		@batch				:	bigint
--			< 0 causes a new batch to be created; <> 1 uses existing batch.
--			Default = 0 (prevents logging of any message);  [Optional]
--		@reporting_proc		:	sysname			(Required)
--			The name of the procedure writing the message to the log.
--		@msg				:	varchar(max)	(Required)
--			The message text being logged by the calling procedure. 
--		@print				:	bit				(Optional)
--			This parameter enables the procedure to write the message to the display as 
--			well as writing it to the log table.
--			0 = Do not print to display (default); <> 0 = Print to the display.
--			[Optional]  Default = 0
--		@batch_description	:	varchar(128)	(Optional)
--			Provide a batch description to be passed to the "exec_log_set_new_batch"
--			procedure.  This should represent a "category" of job rather than a free
--			form description.  For example: "Retrieve Jobs Load".
--			[Optional]	Default = null
--		@revision_dt		:	datetime		(Optional)
--			Allows the caller to specify a specific revision date.  (The value is passed
--			through to the up_exec_log_set_new_batch procedure.)  If, for example, the
--			The up_inventory_load_from_staging procedure may wish to use the revision
--			date contained in the db_staging table as the revision date recorded in the
--			batch_revision table.  This parameter allows that.
--			
--			If not value is passed, this procedure sets the revision date to getdate().
--			[Optional]	Default = Null
--		@new_batch			:	bigint	Output	(Optional)
--			Contains the value of the new batch number if one was created.  This was
--			added to handle values that are too large to fit into an integer.  Originally,
--			new batch numbers were returned as the return value of the procedure.  
--			However, that value is limited to a value that can be represented by an 
--			integer.  It is conceivable that one day the batch numbers may exceed that
--			value and will need to be passed as an output parameter.  The procedure
--			continues to support the original method for backward compatility.
--			Defaults to 0 (0 = Do not log)
--
-- Usage:
--		exec dbo.up_exec_log_write
--			@reporting_proc		= '<name of the procedure calling this proc>',
--			@msg				= '<the message to be logged>',
--			@print_to_display	= '<print>',
--
-- History:
-- --------
--	Date:		Who:		Description:
--	-----------	-----------	-------------------------------------------------------------
--	12/22/20	pbezanson	Explicitly set @revision_dt to getdate() if it is null.
--	01/06/11	pbezanson	Added parameter @print.  Removed paramenter print_to_display.
--	11/12/09	pbezanson	Created.
-----------------------------------------------------------------------------------------
create proc [dbo].[up_exec_log_write]
	@batch				bigint = 0,				-- < 0 - Starts a new batch; 0 = prevents logging of any message; > 0 = the current batch number to use; Default 0
	@reporting_proc		sysname,                -- The name of the procedure creating this log entry.
	@msg				varchar(max),           -- The message to log.
	@print				bit = 0,				-- 0 = Do not print to display (default); <> 0 = Print to the display.
	@batch_description	varchar(128) = null,	-- Include an optional batch description if @batch parm is set to < 0.
	@revision_dt		datetime = null,		-- Include an optional revision date to be passed to the up_exec_log_set_new_batch procedure if the @batch parm is set to 1.
	@new_batch			bigint = 0 output		-- Contains the value of the new batch number if one was created.
as begin
	-- Initialize
	set @new_batch = @batch	-- Assures that the calling batch number (if > 0) isn't reassigned to a null value when this procedure returns.
	if @revision_dt is null
		set @revision_dt = getdate()

	-- Start a new logging batch
	if @batch < 0 begin
		print 'Starting a new batch from up_exec_log_write.'
		exec @new_batch = dbo.up_exec_log_set_new_batch @revision_dt, @batch_description
		
		if @new_batch < 0 begin
			print 'An error was reported while retrieving a new exec log batch number from "up_exec_log_set_new_batch".'
			return -1
			end

		set @batch = @new_batch
		end
	
	if @batch > 0
		begin try
			insert into exec_log (batch_no, reporting_proc, [message])
				values(@batch, @reporting_proc, @msg)
			end try
		begin catch
			-- Log the error message.
			set @msg = 'Msg ' + 
				isnull(cast(Error_Number() as varchar(10)), 'null') + ', Level ' + 
				isnull(cast(Error_Severity() as varchar(10)), 'null') + ', ' + 'State ' + 
				isnull(cast(Error_State() as varchar(10)), 'null') + ', Line ' + 
				isnull(cast(Error_line() as varchar(10)), 'null') + ': ' + 
				Error_Message()
				
			print @msg
			raiserror(101001, 16, 1, @msg)
			end Catch
	
	-- prints if @print is <> 0 even if the batch number is zero (prevent printing).
	if @print <> 0
		print @msg

	-- Return the current batch number.
	return @batch
	end



GO

ALTER AUTHORIZATION ON [dbo].[up_exec_log_write] TO  SCHEMA OWNER 
GO

/****** Object:  StoredProcedure [dbo].[up_identify_instance_aliases]    Script Date: 12/27/2025 6:51:24 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-------------------------------------------------------------------------------
-- Procedure: up_identify_instance_aliases
--
-- Purpose:
--		This procedure attempts to identify and label instances that alias other instances.  An alias is a server name
--		that references a server by another name.  This can happen if an alias name is added to DSI.  For example, if
--		a CNAME is registered with DSI such as "COSMOS" that references the "svr_cosmos" server, there will be two DSI
--		entries pointing to the same server.  This stored procedure will identify the "COSMOS" server and the 
--		"svr_cosmos" server as the same server, albeit with different names.
--
-- Algorithm:
--	 Check for instance aliases.  
--		Problem:
--			Aliased instances will load the data for the aliased instance more than once and cause
--			duplicate key violations.  Duplicate data must be deleted and the alias reported in the log.
--
--		Methodology: 
--			This procedure gathers a list of instance names to search from the "instances" table.  The name of the
--			the instance to be searched is place in the "instance" column of the "db_staging" table.  When the actual 
--			server is searched, it's real instance name is retrieved and placed in the "searched_instance" column 
--			of the "db_staging" table.  Now we have a record of the instance that was supposed to be searched (instance)
--			and a record of the instance that actually was searched (searched_instance).  If the target instance has been 
--			aliased, these two names will be different, otherwise they'll be the same.
--
-- Consideration 05/18/12 (peb):
-- 	 What happens when an identifier is redirected to alias a new server but then is later repointed to a new server for 
-- 	 which it is no longer an alias.  Currently, I believe, the system will still list the identifier as an alias to it's 
-- 	 last server.
--				
--
-- Parameters:
--		@batch			:	bigint
--			Determines whether a new logging batch is created or contains the
--			logging batch number to use for logging.
--			0 = no new batch; < 0 = new batch; > 0 Current Batch Number  Default = -1;  [Optional]
--		@print			:	bit
--			1 = sends log message to console; <> 1 does not send log message to 
--			console.  Default = 1;  [Optional]
--
-- History:
-- Date		By			Description
-- -------- ----------- -------------------------------------------------------
-- 10/31/24	pbezanson	Added clarifying documentation.
-- 12/30/20 pbezanson	Created.
-------------------------------------------------------------------------------
CREATE procedure [dbo].[up_identify_instance_aliases] 
	@log_batch			bigint	= 0,
	@print				bit		= 0
as begin
	declare
		@aliased_instance_id		bigint,
		@aliased_instance			nvarchar(128),
		@msg						varchar(max),
		@domain_nm					nvarchar(255)

	-- Lets check the db_staging table...
	-- Get the searched_instance_id from the instances table and insert it into the db_staging table.  We will need this
	-- for alias recognition later.
	update dbo.db_staging
	set searched_instance_id = isnull(dbo.v_instance_all.instance_id, -1)
	from
		dbo.db_staging ds
		left outer join dbo.v_instance_all on ds.searched_instance = dbo.v_instance_all.instance and ds.searched_domain = dbo.v_instance_all.domain_nm

	-- Prepare the #tmp_db_dups table.  This will hold any duplicate instances.
	if object_id('tempdb..#tmp_db_dups') is not null 
		drop table #tmp_db_dups
	
	-- If there are multiple instances with the same file_path, there are aliases.
	-- Searched_instance and file_path comprise a primary key for this comparison.
	select distinct searched_instance_id, searched_instance, searched_domain, file_path
	into
		#tmp_db_dups
	from
		(select searched_instance_id, searched_instance, searched_domain, file_path
		from db_staging
		where file_type = 'ROWS' or file_type = 'LOG'
		group by searched_instance_id, searched_instance, searched_domain, file_path
		having count(*) > 1) t1

	-- Make sure there are no -1's in the searched_instance_id column.  (If so, we need to do something!?  Not sure.)
	if exists(select * from #tmp_db_dups tdd where tdd.searched_instance_id < 0) begin
		print 'There is at least one aliased instance that we couldn''t find an instance_id for!!!'
		select * from #tmp_db_dups tdd where tdd.searched_instance_id < 0
		end

	if exists (select * from #tmp_db_dups where searched_instance_id > 0) begin
		-- There are duplicate rows indicating an aliased instance condition.
		
		-- Write a notification in the log for each aliased instance.  Aliased conditions should be rare 
		-- and two or more aliased instances should be even rarer, but the WHILE loop should report all 
		-- of them if that condition should ever arise.
		select @aliased_instance_id = min(searched_instance_id) from #tmp_db_dups where searched_instance_id > 0
		while @aliased_instance_id is not null begin
			select @aliased_instance = searched_instance from #tmp_db_dups where searched_instance_id = @aliased_instance_id

			-- Create a comma separated string of the alias instances then add descriptive text to the message.
			set @msg = null
			select @domain_nm = isnull(domain_nm, 'Null') from dbo.v_instance_all via where via.instance_id = @aliased_instance_id
			select @msg = coalesce(@msg + ', ', '') + instance from (select distinct instance from db_staging where searched_instance_id = @aliased_instance_id and @aliased_instance_id <> instance_id) t1
			set @msg = 'The following instances are aliases of "' + @aliased_instance + '" in the ' + 
				@domain_nm + ' domain: ' + @msg + '.  All rows belonging to aliased instances have been marked in db_staging.'

			exec dbo.up_exec_log_write @log_batch, 'up_inventory_retrieve_data', @msg, @print
			
			-- Record the name of the instance the server is aliasing.  This column will only contain a value if the instance is an alias of another instance.
			update dbo.db_staging
				set is_alias_of = @aliased_instance
				where instance_id in (select distinct instance_id from db_staging where searched_instance_id = @aliased_instance_id and @aliased_instance_id <> instance_id)
			
			-- Get the next aliased instance if there is one.
			select @aliased_instance_id = min(searched_instance_id) from #tmp_db_dups where searched_instance_id > @aliased_instance_id and searched_instance_id > 0
			end
		end
	end
GO

ALTER AUTHORIZATION ON [dbo].[up_identify_instance_aliases] TO  SCHEMA OWNER 
GO


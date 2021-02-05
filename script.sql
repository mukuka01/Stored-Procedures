
/****** Object:  StoredProcedure [dbo].[spAssignment_Create&Edit]    Script Date: 2/5/2021 13:40:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spAssignment_Create&Edit]
	@SubjectId int,
	@GradeId int ,
	@TeacherId int,
	@Title nvarchar(500),
	@Deadline datetime2,
	@FilePath nvarchar(500),
	@Src nvarchar(50),
	@AssignmentId int=-1
AS
BEGIN
	SET NOCOUNT ON; 

	IF (@Src = 'Create')
	BEGIN
		Insert into dbo.Assignment
		(SubjectId,TeacherId,GradeID,Title,Deadline,FilePath)
		values (@subjectId,@TeacherId,@gradeId,@Title,@Deadline,@FilePath)
	END 

	ELSE IF (@Src = 'Edit')
	BEGIN 
	    Update dbo.Assignment 
		set Title = @Title,Deadline = @Deadline,FilePath = @FilePath,SubjectId=@SubjectId,GradeID=@GradeId
		where Id=@AssignmentId;
	END  

	ELSE IF (@Src = 'Delete')
	BEGIN  
		Delete from dbo.Assignment
		where Id=@AssignmentId;
	END  

END
GO
/****** Object:  StoredProcedure [dbo].[spAssignment_Get]    Script Date: 2/5/2021 13:40:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spAssignment_Get]
	@subjectId int= -1,
	@gradeId int= -1 ,
	@AssignmentId int= -1
AS 
begin
	set nocount on;

	IF (@AssignmentId > 0)
	BEGIN
		select a.Id,a.Title , s.Title,t.LastName,g.Title,a.Deadline,a.FilePath
		from dbo.Assignment a
		INNER JOIN dbo.Subject s
		on s.Id = a.SubjectId
		INNER JOIN dbo.Users t
		on t.Id = a.TeacherId
		INNER JOIN dbo.Grade g
		on g.Id = a.GradeID
		where a.Id = @AssignmentId
	END

	ELSE  
	BEGIN
		select a.Id,a.Title , s.Title as Subject,t.LastName as Teacher,g.Title as Grade,a.Deadline,a.FilePath
		from dbo.Assignment a
		INNER JOIN dbo.Subject s
		on s.Id = a.SubjectId
		INNER JOIN dbo.Users t
		on t.Id = a.TeacherId
		INNER JOIN dbo.Grade g
		on g.Id = a.GradeID
	END   

end
GO
/****** Object:  StoredProcedure [dbo].[spAssignment_GetSubmission]    Script Date: 2/5/2021 13:40:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spAssignment_GetSubmission]
	@StudentId int=-1,
	@AssignmentId int=-1  
AS 
begin
	set nocount on;

	IF (@AssignmentId > 0 and @StudentId< 0)
	BEGIN
		select * from dbo.AssignmentSubmission
		where AssignmentId=@AssignmentId
	END

	ELSE  IF (@AssignmentId >= 0 and @StudentId >= 0)
	BEGIN
		select * from dbo.AssignmentSubmission
		where StudentId=@StudentId and AssignmentId=@AssignmentId
	END   

end
GO
/****** Object:  StoredProcedure [dbo].[spAssignment_GetUploads]    Script Date: 2/5/2021 13:40:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spAssignment_GetUploads]
	@assignmentID int 
AS 
begin
	set nocount on;

	select * from dbo.Assignment
	where id=@assignmentID  

end
GO
/****** Object:  StoredProcedure [dbo].[spAssignmentSubmission_Create&Edit]    Script Date: 2/5/2021 13:40:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spAssignmentSubmission_Create&Edit]
	@AssignmentId int=-1,
	@StudentId int=-1,
	@Comment nvarchar(500)='' ,
	@UploadDate nvarchar(500) = '' ,
	@Score decimal=0,
	@FilePath nvarchar(500)='',
	@Src nvarchar(50)
	
AS
BEGIN
	SET NOCOUNT ON; 

	IF (@Src = 'Create')
	BEGIN
		Insert into dbo.AssignmentSubmission
		(AssignmentId,StudentId,UploadDate,Score,Comment,FilePath)
		values (@AssignmentId,@StudentId,@UploadDate,@Score,@Comment,@FilePath)
	END 

	ELSE IF (@Src = 'Edit')
	BEGIN 
	    Update dbo.AssignmentSubmission 
		set Score = @Score,Comment = @Comment
		where Id=@AssignmentId;
	END  

	ELSE IF (@Src = 'Delete')
	BEGIN  
		Delete from dbo.AssignmentSubmission
		where Id=@AssignmentId;
	END  

END
GO
/****** Object:  StoredProcedure [dbo].[spAttendance_Create&Edit]    Script Date: 2/5/2021 13:40:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spAttendance_Create&Edit]
	@Id int=-1,
	@SubjectId int=-1,
	@StudentId int=-1,
	@Date DateTime ='',
	@State nvarchar(500)='', 
	@Src nvarchar(50)=''

AS
BEGIN
	SET NOCOUNT ON; 

	IF (@Src = 'Create')
	BEGIN
		Insert into dbo.Attendance
		(SubjectId,StudentId,Date,State)
		values (@SubjectId,@StudentId,@Date,@State)
	END 

	ELSE IF (@Src = 'Edit')
	BEGIN 
	    Update dbo.Attendance 
		set State = @State 
		where Id=@Id;
	END  

	ELSE IF (@Src = 'Delete')
	BEGIN  
		Delete from dbo.Attendance
		where Id=@Id;
	END  

END
GO
/****** Object:  StoredProcedure [dbo].[spAttendance_Get]    Script Date: 2/5/2021 13:40:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spAttendance_Get]  
	@StudentId int  = -1,
	@SubjectId int= -1,
	@gradeId int= -1

AS 
begin
	set nocount on;

		--Getting Student Attendance
		IF (@StudentId >= 0 AND @gradeId <= -1)
		BEGIN
			select * from dbo.Attendance
			where StudentId = @StudentId; 
		END

		--getting list of student based on their grade
		else IF (@gradeId >= 0 AND @StudentId <= -1 )
		BEGIN
			select u.* from dbo.Users u
			Inner Join dbo.Student s
			On s.StudentId = u.Id
			where s.GradeId=@gradeId
		END

		--get attendance list of all students
		--ELSE  
		--BEGIN
		--	select * from dbo.Attendance
		--	where SubjectId=@subjectId and GradeId=@gradeId
		--END   
end
GO
/****** Object:  StoredProcedure [dbo].[spGrade_Create]    Script Date: 2/5/2021 13:40:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGrade_Create]
  @Title nvarchar(100)

AS
begin
	set nocount on;

	Insert into dbo.Grade(Title)
	Values (@Title); 

end
GO
/****** Object:  StoredProcedure [dbo].[spGrade_Get]    Script Date: 2/5/2021 13:40:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGrade_Get] 
	@GradeId int = -1

AS 
begin
	set nocount on;

	IF (@GradeId > 0)
	BEGIN
	   select * from dbo.Grade where Id = @GradeId;
	END

	ELSE
	BEGIN
	   select * from dbo.Grade
	END

end
GO
/****** Object:  StoredProcedure [dbo].[spGrade_Teacher]    Script Date: 2/5/2021 13:40:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGrade_Teacher]
	@TeacherId int  
AS 
begin
	set nocount on;

	  select g.* 
	  from dbo.Grade  g
	  INNER JOIN dbo.TeacherSubjects ts
	  on g.Id = ts.GradeId
	  where ts.TeacherId = @TeacherId;  

end
GO
/****** Object:  StoredProcedure [dbo].[spStudent_Create&Edit]    Script Date: 2/5/2021 13:40:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spStudent_Create&Edit]
	@UserId int,
	@ExpectedAmount int,
	@ActualAmount int,
	@GradeId int,
	@Src nvarchar(50)

AS
begin
	set nocount on;

	IF (@Src = 'Create')
	BEGIN
		Insert into dbo.Student(StudentId,ExpectedAmount,ActualAmount,GradeId)
		Values (@UserId,@ExpectedAmount,@ActualAmount,@GradeId);
	END  

	ELSE IF (@Src = 'Edit')
	BEGIN 
	    update dbo.Student
		set ExpectedAmount=@ExpectedAmount,ActualAmount=@ActualAmount,GradeId=@GradeId 
		where StudentId=@UserId; 
	END  

	ELSE IF (@Src = 'Delete')
	BEGIN 
	     Delete from dbo.Users
		Where Id=@UserId 
	END  
end
GO
/****** Object:  StoredProcedure [dbo].[spStudent_Get]    Script Date: 2/5/2021 13:40:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spStudent_Get]
	@StudentId int = -1

AS 
begin
	set nocount on;

	IF (@StudentId > 0)
	BEGIN
	   select s.StudentId,s.GradeId,s.ExpectedAmount,s.ActualAmount,g.Title as GradeTitle
	   from dbo.Student s  
	   Inner Join dbo.Grade g
	   on g.Id = s.GradeId
	   where StudentId = @StudentId;
	END

	ELSE
	BEGIN
	   select s.StudentId,s.GradeId,s.ExpectedAmount,s.ActualAmount,g.Title as GradeTitle
	   from dbo.Student s  
	   Inner Join dbo.Grade g
	   on g.Id = s.GradeId
	END

end
GO
/****** Object:  StoredProcedure [dbo].[spStudent_GetAttendance]    Script Date: 2/5/2021 13:40:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spStudent_GetAttendance]
	@StudentId int 
AS 
begin
	set nocount on;

	select * from dbo.Attendance
	where Studentid =@StudentId 

end
GO
/****** Object:  StoredProcedure [dbo].[spSubject_Create&Edit]    Script Date: 2/5/2021 13:40:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spSubject_Create&Edit]
	@SubjectId int =-1,
	@Title nvarchar(500)='',
	@Src nvarchar(50)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF (@Src = 'Create')
	BEGIN
		Insert into dbo.Subject(Title)
		Values (@Title); 
	END 

	ELSE IF (@Src = 'Edit')
	BEGIN 
	    Update dbo.Subject 
		set Title = @Title
		where Id=@SubjectId;
	END  

	ELSE IF (@Src = 'Delete')
	BEGIN  
		Delete from dbo.Subject
		Where Id=@SubjectId 
	END  

END
GO
/****** Object:  StoredProcedure [dbo].[spSubject_Get]    Script Date: 2/5/2021 13:40:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSubject_Get]
	@SubjectId int = -1

AS 
begin
	set nocount on;

	IF (@SubjectId > 0)
	BEGIN
	   select * from dbo.Subject where Id = @SubjectId;
	END

	ELSE
	BEGIN
	   select * from dbo.Subject
	END

end
GO
/****** Object:  StoredProcedure [dbo].[spSubject_Teacher]    Script Date: 2/5/2021 13:40:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSubject_Teacher]
	@TeacherId int  = -1,
	@SubjectId int = -1
AS 
begin
	set nocount on;

		IF (@TeacherId > 0)
		BEGIN
			select s.* 
			from dbo.Subject  s
			INNER JOIN dbo.TeacherSubjects ts
			on s.Id = ts.SubjectId
			where ts.TeacherId = @TeacherId; 
		END

		ELSE IF (@SubjectId > 0)
		BEGIN
			select u.* 
			from dbo.Users  u
			INNER JOIN dbo.TeacherSubjects ts
			on u.Id = ts.TeacherId
			where ts.SubjectId = @SubjectId; 
		END  

end
GO
/****** Object:  StoredProcedure [dbo].[spTeacher_Create&Edit]    Script Date: 2/5/2021 13:40:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTeacher_Create&Edit]
	@UserId int,
	@Salary int,
	@Qualification  nvarchar(300),
	@Src nvarchar(50)

AS
begin
	set nocount on;

	IF (@Src = 'Create')
	BEGIN
		Insert into dbo.Teacher(TeacherId,Salary,Qualification)
		Values (@UserId,@Salary,@Qualification);
	END 

	ELSE IF (@Src = 'Edit')
	BEGIN 
	    update dbo.Teacher
		set Salary=@Salary,Qualification=@Qualification 
		where TeacherId=@UserId; 
	END    

	ELSE IF (@Src = 'Delete')
	BEGIN  
		 Delete from dbo.Users
		Where Id=@UserId 
	END  

end
GO
/****** Object:  StoredProcedure [dbo].[spTeacher_Get]    Script Date: 2/5/2021 13:40:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTeacher_Get]
	@TeacherId int = -1

AS 
begin
	set nocount on;

	IF (@TeacherId > 0)
	BEGIN
	   select * from dbo.Teacher where TeacherId = @TeacherId;
	END

	ELSE
	BEGIN
	   select * from dbo.Teacher 
	END

end
GO
/****** Object:  StoredProcedure [dbo].[spTeacherSubject_Create&Edit]    Script Date: 2/5/2021 13:40:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTeacherSubject_Create&Edit]
	@TeacherId int,
	@GradeId int,
	@SubjectId int,
	@Src nvarchar(50)

AS
begin
	set nocount on;

	IF (@Src = 'Create')
	BEGIN
		Insert into dbo.TeacherSubjects(TeacherId,GradeId,SubjectId)
		Values (@TeacherId,@GradeId,@SubjectId);
	END 

	ELSE IF (@Src = 'Edit')
	BEGIN 
	    update dbo.TeacherSubjects
		set TeacherId=@TeacherId,GradeId=@GradeId 
		where TeacherId=@TeacherId; 
	END 
	
	ELSE IF (@Src = 'Delete')
	BEGIN 
	    Delete from dbo.TeacherSubjects
		Where TeacherId=@TeacherId AND GradeId=@GradeId AND SubjectId=@SubjectId
	END  

end
GO
/****** Object:  StoredProcedure [dbo].[spUser_Create&Edit]    Script Date: 2/5/2021 13:40:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spUser_Create&Edit]
	@FirstName nvarchar(100),
	@LastName nvarchar(100),
	@EmailAddress nvarchar(100),
	@Gender nvarchar(100),
	@NRC nvarchar(100),
	@phoneNumber nvarchar(100),
	@HomeAddress nvarchar(100),
	@Id int = -1

AS
begin
	set nocount on;

	--Edit User
	IF (@Id > 0)
	BEGIN
	    update dbo.Users
		set FirstName=@FirstName,LastName=@LastName,Email=@EmailAddress,
		Gender=@Gender,NRC=@NRC,PhoneNumber=@phoneNumber,HomeAddress=@HomeAddress
		where Id=@Id; 
	END

	--create user
	ELSE
	BEGIN
		Insert into dbo.Users(FirstName,LastName,Email,Gender,NRC,PhoneNumber,
		HomeAddress)
		OUTPUT INSERTED.ID
		values (@FirstName,@LastName,@EmailAddress,
		@Gender,@NRC,@phoneNumber,@HomeAddress);
	END 

end
GO
/****** Object:  StoredProcedure [dbo].[spUser_Get]    Script Date: 2/5/2021 13:40:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spUser_Get]
	@UserId int = -1

AS 
begin
	set nocount on;

	IF (@UserId > 0)
	BEGIN
	   select * from dbo.Users where Id = @UserId;
	END

	ELSE
	BEGIN
	   select * from dbo.Users  
	END

end
GO
USE [master]
GO
ALTER DATABASE [OctodutyDatabase] SET  READ_WRITE 
GO

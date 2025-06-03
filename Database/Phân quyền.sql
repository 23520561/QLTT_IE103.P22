

-- Tạo logins (tài khoản đăng nhập vào SQL Server)
CREATE LOGIN admin_user WITH PASSWORD = 'AdminPass123!';
CREATE LOGIN dev_user WITH PASSWORD = 'DevPass123!';
CREATE LOGIN analyst_user WITH PASSWORD = 'AnalystPass123!';
GO

-- Tạo users trong cơ sở dữ liệu, ánh xạ với logins
CREATE USER nguyendongochieu FOR LOGIN admin_user;
CREATE USER voducanhhuy FOR LOGIN dev_user;
CREATE USER lenamhung FOR LOGIN analyst_user;
GO

-- Tạo vai trò
CREATE ROLE admin_role;
CREATE ROLE dev_role;
CREATE ROLE analyst_role;
GO

-- Gán quyền CONTROL (toàn quyền) trên toàn bộ cơ sở dữ liệu cho admin_role
GRANT CONTROL ON DATABASE::QLKH TO admin_role;

-- Gán vai trò admin_role cho người dùng Nguyen Do Ngoc Hieu
ALTER ROLE admin_role ADD MEMBER nguyendongochieu;
GO

-- Gán quyền cho dev_role
GRANT SELECT, INSERT, UPDATE ON Users TO dev_role;
GRANT SELECT, INSERT, UPDATE ON Courses TO dev_role;
GRANT SELECT, INSERT, UPDATE ON Chapters TO dev_role;
GRANT SELECT, INSERT, UPDATE ON Videos TO dev_role;
GRANT SELECT, INSERT, UPDATE ON Lessons TO dev_role;
GRANT SELECT, INSERT, UPDATE ON Documents TO dev_role;
GRANT SELECT, INSERT, UPDATE ON Exams TO dev_role;
GRANT SELECT, INSERT, UPDATE ON Assignments TO dev_role;
GRANT SELECT, INSERT, UPDATE ON Questions TO dev_role;
GRANT SELECT, INSERT, UPDATE ON Answers TO dev_role;
GRANT SELECT, INSERT, UPDATE ON Feedback TO dev_role;
GRANT SELECT, INSERT, UPDATE ON UserProgress TO dev_role;
-- Hạn chế quyền trên bảng nhạy cảm
GRANT SELECT ON Payments TO dev_role;
GRANT SELECT ON UserCourseStatus TO dev_role;
-- Rõ ràng từ chối quyền DELETE và ALTER để bảo vệ dữ liệu và cấu trúc
DENY DELETE, ALTER ON DATABASE::QLKH TO dev_role;

-- Gán vai trò dev_role cho người dùng Vo Duc Anh Huy
ALTER ROLE dev_role ADD MEMBER voducanhhuy;
GO

-- Gán quyền cho analyst_role
CREATE VIEW UsersView
AS
SELECT UserId, UserName
FROM Users;
GO

CREATE VIEW CoursesView
AS
SELECT CourseId, CourseTitle, CourseDesc, CoursePrice, CreatedAt
FROM Courses;
GO

CREATE VIEW ChaptersView
AS
SELECT ChapterId, CourseId, ChapterTitle, ChapterDesc, ChapterPosition, CreatedAt
FROM Chapters;
GO

CREATE VIEW LessonsView
AS
SELECT LessonId, ChapterId, VideoId, LessonTitle, LessonDesc, CreatedAt
FROM Lessons;
GO

CREATE VIEW VideosView
AS
SELECT VideoId, VideoUrl, VideoDesc, VideoDuration, CreatedAt
FROM Videos;
GO

CREATE VIEW ExamsView
AS
SELECT ExamId, CourseId, ChapterId, ExamName, ExamDuration, ExamDesc, CreatedAt
FROM Exams;
GO

CREATE VIEW AssignmentsView
AS
SELECT AssignmentId, LessonId, AssignmentDuration, AssignmentDesc, CreatedAt
FROM Assignments;
GO

CREATE VIEW QuestionsView
AS
SELECT QuestionId, QuestionText, QuestionType, QuestionScore, ExamId, AssignmentId
FROM Questions;
GO

CREATE VIEW FeedbackView
AS
SELECT FeedbackId, UserId, CourseId, ChapterId, LessonId, Rating, FeedbackComment, CreatedAt
FROM Feedback;
GO

CREATE VIEW UserProgressView
AS
SELECT UserId, VideoId, IsComplete, CompletedAt
FROM UserProgress;
GO

CREATE VIEW UserCourseStatusView
AS
SELECT UserId, CourseId, CourseStatus, GraduatedAt
FROM UserCourseStatus;
GO

CREATE VIEW PaymentsView
AS
SELECT PaymentId, UserId, CourseId, PaymentDesc, PaymentAmount, PaymentMethod, CreatedAt
FROM Payments;
GO


GRANT SELECT ON UsersView TO analyst_role;
GRANT SELECT ON CoursesView TO analyst_role;
GRANT SELECT ON ChaptersView TO analyst_role;
GRANT SELECT ON LessonsView TO analyst_role;
GRANT SELECT ON VideosView TO analyst_role;
GRANT SELECT ON ExamsView TO analyst_role;
GRANT SELECT ON AssignmentsView TO analyst_role;
GRANT SELECT ON QuestionsView TO analyst_role;
GRANT SELECT ON FeedbackView TO analyst_role;
GRANT SELECT ON UserProgressView TO analyst_role;
GRANT SELECT ON UserCourseStatusView TO analyst_role;
GRANT SELECT ON PaymentsView TO analyst_role;
GO

DENY SELECT, INSERT, UPDATE, DELETE, ALTER ON Users TO analyst_role;
DENY SELECT, INSERT, UPDATE, DELETE, ALTER ON Courses TO analyst_role;
DENY SELECT, INSERT, UPDATE, DELETE, ALTER ON Chapters TO analyst_role;
DENY SELECT, INSERT, UPDATE, DELETE, ALTER ON Lessons TO analyst_role;
DENY SELECT, INSERT, UPDATE, DELETE, ALTER ON Videos TO analyst_role;
DENY SELECT, INSERT, UPDATE, DELETE, ALTER ON Exams TO analyst_role;
DENY SELECT, INSERT, UPDATE, DELETE, ALTER ON Assignments TO analyst_role;
DENY SELECT, INSERT, UPDATE, DELETE, ALTER ON Questions TO analyst_role;
DENY SELECT, INSERT, UPDATE, DELETE, ALTER ON Answers TO analyst_role;
DENY SELECT, INSERT, UPDATE, DELETE, ALTER ON Feedback TO analyst_role;
DENY SELECT, INSERT, UPDATE, DELETE, ALTER ON UserProgress TO analyst_role;
DENY SELECT, INSERT, UPDATE, DELETE, ALTER ON UserCourseStatus TO analyst_role;
DENY SELECT, INSERT, UPDATE, DELETE, ALTER ON Payments TO analyst_role;
GO

-- Gán vai trò analyst_role cho người dùng Le Nam Hung
ALTER ROLE analyst_role ADD MEMBER lenamhung;
GO

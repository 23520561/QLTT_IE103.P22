-- Phân quyền
CREATE ROLE Admin;
CREATE ROLE Teacher;
CREATE ROLE Student;
GO

DECLARE @tables TABLE (name NVARCHAR(50))
INSERT INTO @tables VALUES 
('USERS'), ('COURSES'), ('CHAPTERS'), ('VIDEOS'),
('LESSONS'), ('DOCUMENTS'), ('EXAMS'), ('ASSIGNMENTS'),
('ANSWERS'), ('QUESTIONS'), ('PAYMENTS'), ('USER_PROGRESS'),
('USER_COURSE_STATUS'), ('FEEDBACK'), ('TEACHER_COURSES');

DECLARE @sql NVARCHAR(MAX);
DECLARE @table NVARCHAR(50);

DECLARE table_cursor CURSOR FOR SELECT name FROM @tables;
OPEN table_cursor;
FETCH NEXT FROM table_cursor INTO @table;

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @sql = '
        GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.' + QUOTENAME(@table) + ' TO Admin;';
    EXEC sp_executesql @sql;
    FETCH NEXT FROM table_cursor INTO @table;
END

CLOSE table_cursor;
DEALLOCATE table_cursor;
GO

DENY SELECT ON dbo.COURSES TO Teacher;
DENY SELECT ON dbo.VIDEOS TO Teacher;
DENY SELECT ON dbo.LESSONS TO Teacher;
DENY SELECT ON dbo.ASSIGNMENTS TO Teacher;
DENY SELECT ON dbo.EXAMS TO Teacher;
DENY SELECT ON dbo.QUESTIONS TO Teacher;
DENY SELECT ON dbo.CHAPTERS TO Teacher;
DENY SELECT ON dbo.DOCUMENTS TO Teacher;
GO

CREATE VIEW vw_teacher_courses AS
SELECT c.*
FROM COURSES c
JOIN TEACHER_COURSES tc ON c.course_id = tc.course_id
JOIN USERS u ON tc.teacher_id = u.user_id
WHERE u.user_name = SYSTEM_USER;
GO
GRANT SELECT, INSERT, UPDATE, DELETE ON vw_teacher_courses TO Teacher;
GO

CREATE VIEW vw_teacher_chapters AS
SELECT ch.*
FROM CHAPTERS ch
JOIN COURSES c ON ch.course_id = c.course_id
JOIN TEACHER_COURSES tc ON c.course_id = tc.course_id
JOIN USERS u ON tc.teacher_id = u.user_id
WHERE u.user_name = SYSTEM_USER;
GO
GRANT SELECT, INSERT, UPDATE, DELETE ON vw_teacher_chapters TO Teacher;
GO

CREATE VIEW vw_teacher_lessons AS
SELECT l.*
FROM LESSONS l
JOIN CHAPTERS ch ON l.chapter_id = ch.chapter_id
JOIN COURSES c ON ch.course_id = c.course_id
JOIN TEACHER_COURSES tc ON c.course_id = tc.course_id
JOIN USERS u ON tc.teacher_id = u.user_id
WHERE u.user_name = SYSTEM_USER;
GO
GRANT SELECT, INSERT, UPDATE, DELETE ON vw_teacher_lessons TO Teacher;
GO

CREATE VIEW vw_teacher_videos AS
SELECT v.*
FROM VIDEOS v
JOIN LESSONS l ON v.video_id = l.video_id
JOIN CHAPTERS ch ON l.chapter_id = ch.chapter_id
JOIN COURSES c ON ch.course_id = c.course_id
JOIN TEACHER_COURSES tc ON c.course_id = tc.course_id
JOIN USERS u ON tc.teacher_id = u.user_id
WHERE u.user_name = SYSTEM_USER;
GO
GRANT SELECT, INSERT, UPDATE, DELETE ON vw_teacher_videos TO Teacher;
GO

CREATE VIEW vw_teacher_assignments AS
SELECT a.*
FROM ASSIGNMENTS a
JOIN LESSONS l ON a.lesson_id = l.lesson_id
JOIN CHAPTERS ch ON l.chapter_id = ch.chapter_id
JOIN COURSES c ON ch.course_id = c.course_id
JOIN TEACHER_COURSES tc ON c.course_id = tc.course_id
JOIN USERS u ON tc.teacher_id = u.user_id
WHERE u.user_name = SYSTEM_USER;
GO
GRANT SELECT, INSERT, UPDATE, DELETE ON vw_teacher_assignments TO Teacher;
GO

CREATE VIEW vw_teacher_exams AS
SELECT e.*
FROM EXAMS e
JOIN COURSES c ON e.course_id = c.course_id
JOIN TEACHER_COURSES tc ON c.course_id = tc.course_id
JOIN USERS u ON tc.teacher_id = u.user_id
WHERE u.user_name = SYSTEM_USER;
GO
GRANT SELECT, INSERT, UPDATE, DELETE ON vw_teacher_exams TO Teacher;
GO

CREATE VIEW vw_teacher_questions AS
SELECT q.*
FROM QUESTIONS q
JOIN EXAMS e ON q.exam_id = e.exam_id
JOIN COURSES c ON e.course_id = c.course_id
JOIN TEACHER_COURSES tc ON c.course_id = tc.course_id
JOIN USERS u ON tc.teacher_id = u.user_id
WHERE u.user_name = SYSTEM_USER;
GO
GRANT SELECT, INSERT, UPDATE, DELETE ON vw_teacher_questions TO Teacher;
GO

CREATE VIEW vw_teacher_documents AS
SELECT d.*
FROM DOCUMENTS d
JOIN LESSONS l ON d.lesson_id = l.lesson_id
JOIN CHAPTERS ch ON l.chapter_id = ch.chapter_id
JOIN COURSES c ON ch.course_id = c.course_id
JOIN TEACHER_COURSES tc ON c.course_id = tc.course_id
JOIN USERS u ON tc.teacher_id = u.user_id
WHERE u.user_name = SYSTEM_USER;
GO
GRANT SELECT, INSERT, UPDATE, DELETE ON vw_teacher_documents TO Teacher;
GO

DENY SELECT ON dbo.COURSES TO Student;
DENY SELECT ON dbo.CHAPTERS TO Student;
DENY SELECT ON dbo.VIDEOS TO Student;
DENY SELECT ON dbo.LESSONS TO Student;
DENY SELECT ON dbo.ASSIGNMENTS TO Student;
DENY SELECT ON dbo.DOCUMENTS TO Student;
DENY SELECT ON dbo.EXAMS TO Student;
DENY SELECT ON dbo.QUESTIONS TO Student;
DENY SELECT ON dbo.USER_PROGRESS TO Student;
DENY SELECT ON dbo.FEEDBACK TO Student;
GO

CREATE VIEW vw_student_courses AS
SELECT c.*
FROM COURSES c
JOIN PAYMENTS p ON p.course_id = c.course_id
JOIN USERS u ON p.user_id = u.user_id
WHERE u.user_name = SYSTEM_USER;
GO
GRANT SELECT ON vw_student_courses TO Student;
GO

CREATE VIEW vw_student_chapters AS
SELECT ch.*
FROM CHAPTERS ch
JOIN COURSES c ON ch.course_id = c.course_id
JOIN PAYMENTS p ON p.course_id = c.course_id
JOIN USERS u ON p.user_id = u.user_id
WHERE u.user_name = SYSTEM_USER;
GO
GRANT SELECT ON vw_student_chapters TO Student;
GO

CREATE VIEW vw_student_lessons AS
SELECT l.*
FROM LESSONS l
JOIN CHAPTERS ch ON l.chapter_id = ch.chapter_id
JOIN COURSES c ON ch.course_id = c.course_id
JOIN PAYMENTS p ON p.course_id = c.course_id
JOIN USERS u ON p.user_id = u.user_id
WHERE u.user_name = SYSTEM_USER;
GO
GRANT SELECT ON vw_student_lessons TO Student;
GO

CREATE VIEW vw_student_videos AS
SELECT v.*
FROM VIDEOS v
JOIN LESSONS l ON v.video_id = l.video_id
JOIN CHAPTERS ch ON l.chapter_id = ch.chapter_id
JOIN COURSES c ON ch.course_id = c.course_id
JOIN PAYMENTS p ON p.course_id = c.course_id
JOIN USERS u ON p.user_id = u.user_id
WHERE u.user_name = SYSTEM_USER;
GO
GRANT SELECT ON vw_student_videos TO Student;
GO

CREATE VIEW vw_student_assignments AS
SELECT a.*
FROM ASSIGNMENTS a
JOIN LESSONS l ON a.lesson_id = l.lesson_id
JOIN CHAPTERS ch ON l.chapter_id = ch.chapter_id
JOIN COURSES c ON ch.course_id = c.course_id
JOIN PAYMENTS p ON p.course_id = c.course_id
JOIN USERS u ON p.user_id = u.user_id
WHERE u.user_name = SYSTEM_USER;
GO
GRANT SELECT ON vw_student_assignments TO Student;
GO

CREATE VIEW vw_student_exams AS
SELECT e.*
FROM EXAMS e
JOIN COURSES c ON e.course_id = c.course_id
JOIN PAYMENTS p ON p.course_id = c.course_id
JOIN USERS u ON p.user_id = u.user_id
WHERE u.user_name = SYSTEM_USER;
GO
GRANT SELECT ON vw_student_exams TO Student;
GO

CREATE VIEW vw_student_questions AS
SELECT q.*
FROM QUESTIONS q
JOIN EXAMS e ON q.exam_id = e.exam_id
JOIN COURSES c ON e.course_id = c.course_id
JOIN PAYMENTS p ON p.course_id = c.course_id
JOIN USERS u ON p.user_id = u.user_id
WHERE u.user_name = SYSTEM_USER;
GO
GRANT SELECT ON vw_student_questions TO Student;
GO

CREATE VIEW vw_student_documents AS
SELECT d.*
FROM DOCUMENTS d
JOIN LESSONS l ON d.lesson_id = l.lesson_id
JOIN CHAPTERS ch ON l.chapter_id = ch.chapter_id
JOIN COURSES c ON ch.course_id = c.course_id
JOIN PAYMENTS p ON p.course_id = c.course_id
JOIN USERS u ON p.user_id = u.user_id
WHERE u.user_name = SYSTEM_USER;
GO
GRANT SELECT ON vw_student_documents TO Student;
GO

CREATE VIEW vw_student_user_progress AS
SELECT up.*
FROM USER_PROGRESS up
JOIN USERS u ON up.user_id = u.user_id
WHERE u.user_name = SYSTEM_USER;
GO
GRANT SELECT, INSERT, UPDATE ON vw_student_user_progress TO Student;
GO

CREATE VIEW vw_student_feedback AS
SELECT f.*
FROM FEEDBACK f
JOIN USERS u ON f.user_id = u.user_id
WHERE u.user_name = SYSTEM_USER;
GO
GRANT SELECT, INSERT ON vw_student_feedback TO Student;
GO
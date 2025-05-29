-- Xóa dữ liệu cũ để tránh xung đột
DELETE FROM TEACHER_COURSES;
DELETE FROM FEEDBACK;
DELETE FROM USER_COURSE_STATUS;
DELETE FROM USER_PROGRESS;
DELETE FROM PAYMENTS;
DELETE FROM QUESTIONS;
DELETE FROM ANSWERS;
DELETE FROM ASSIGNMENTS;
DELETE FROM EXAMS;
DELETE FROM DOCUMENTS;
DELETE FROM LESSONS;
DELETE FROM VIDEOS;
DELETE FROM CHAPTERS;
DELETE FROM COURSES;
DELETE FROM USERS;
DELETE FROM ROLES;
GO

-- Chèn dữ liệu vào bảng ROLES
INSERT INTO ROLES (role_id, role_name) VALUES
(1, N'Admin'),
(2, N'Teacher'),
(3, N'Student');
GO

-- Chèn dữ liệu vào bảng USERS
INSERT INTO USERS (user_id, user_name, user_email, user_password_hash, phone_number, user_address, role_id) VALUES
(1, N'Quản Trị Viên 1', 'admin1@example.com', 'admin1_hash', '0123456789', N'Số 123, Đường Admin, Quận Hoàn Kiếm, Hà Nội', 1),
(2, N'Quản Trị Viên 2', 'admin2@example.com', 'admin2_hash', '0987654321', N'Số 456, Đường Admin, Quận 1, TP. Hồ Chí Minh', 1),
(3, N'Quản Trị Viên 3', 'admin3@example.com', 'admin3_hash', '0112233445', N'Số 789, Đường Admin, Quận Hải Châu, Đà Nẵng', 1),
(4, N'Quản Trị Viên 4', 'admin4@example.com', 'admin4_hash', '0223344556', N'Số 101, Đường Admin, TP. Huế, Thừa Thiên Huế', 1),
(5, N'Quản Trị Viên 5', 'admin5@example.com', 'admin5_hash', '0334455667', N'Số 202, Đường Admin, Quận Ninh Kiều, Cần Thơ', 1),
(6, N'Nguyễn Văn An', 'teacherA@example.com', 'passA_hash', '0445566778', N'Số 303, Đường Giảng Viên, Quận Đống Đa, Hà Nội', 2),
(7, N'Trần Thị Bình', 'teacherB@example.com', 'passB_hash', '0556677889', N'Số 404, Đường Giảng Viên, Quận 7, TP. Hồ Chí Minh', 2),
(8, N'Lê Văn Cường', 'teacherC@example.com', 'passC_hash', '0667788990', N'Số 505, Đường Giảng Viên, Quận Thanh Khê, Đà Nẵng', 2),
(9, N'Phạm Thị Dung', 'teacherD@example.com', 'passD_hash', '0778899001', N'Số 606, Đường Giảng Viên, TP. Huế, Thừa Thiên Huế', 2),
(10, N'Hoàng Văn Em', 'teacherE@example.com', 'passE_hash', '0889900112', N'Số 707, Đường Giảng Viên, Quận Cái Răng, Cần Thơ', 2),
(11, N'Học Sinh 1 - Nguyễn Thị Hoa', 'student1@example.com', 'pass1_hash', '0990011223', N'Số 808, Đường Học Sinh, Quận Ba Đình, Hà Nội', 3),
(12, N'Học Sinh 2 - Trần Văn Hùng', 'student2@example.com', 'pass2_hash', '0101122334', N'Số 909, Đường Học Sinh, Quận 3, TP. Hồ Chí Minh', 3),
(13, N'Học Sinh 3 - Lê Thị Lan', 'student3@example.com', 'pass3_hash', '0212233445', N'Số 1010, Đường Học Sinh, Quận Sơn Trà, Đà Nẵng', 3),
(14, N'Học Sinh 4 - Phạm Văn Minh', 'student4@example.com', 'pass4_hash', '0323344556', N'Số 1111, Đường Học Sinh, TP. Huế, Thừa Thiên Huế', 3),
(15, N'Học Sinh 5 - Hoàng Thị Ngọc', 'student5@example.com', 'pass5_hash', '0434455667', N'Số 1212, Đường Học Sinh, Quận Bình Thủy, Cần Thơ', 3),
(16, N'Học Sinh 6 - Nguyễn Văn Phong', 'student6@example.com', 'pass6_hash', '0545566778', N'Số 1313, Đường Học Sinh, Quận Cầu Giấy, Hà Nội', 3),
(17, N'Học Sinh 7 - Trần Thị Quyên', 'student7@example.com', 'pass7_hash', '0656677889', N'Số 1414, Đường Học Sinh, Quận Tân Bình, TP. Hồ Chí Minh', 3),
(18, N'Học Sinh 8 - Lê Văn Sơn', 'student8@example.com', 'pass8_hash', '0767788990', N'Số 1515, Đường Học Sinh, Quận Ngũ Hành Sơn, Đà Nẵng', 3),
(19, N'Học Sinh 9 - Phạm Thị Thảo', 'student9@example.com', 'pass9_hash', '0878899001', N'Số 1616, Đường Học Sinh, TP. Huế, Thừa Thiên Huế', 3),
(20, N'Học Sinh 10 - Hoàng Văn Tiến', 'student10@example.com', 'pass10_hash', '0989900112', N'Số 1717, Đường Học Sinh, Quận Ô Môn, Cần Thơ', 3),
(21, N'Học Sinh 11 - Nguyễn Thị Uyên', 'student11@example.com', 'pass11_hash', '0990011223', N'Số 1818, Đường Học Sinh, Quận Thanh Xuân, Hà Nội', 3),
(22, N'Học Sinh 12 - Trần Văn Vinh', 'student12@example.com', 'pass12_hash', '0101122334', N'Số 1919, Đường Học Sinh, Quận Thủ Đức, TP. Hồ Chí Minh', 3),
(23, N'Học Sinh 13 - Lê Thị Xuân', 'student13@example.com', 'pass13_hash', '0212233445', N'Số 2020, Đường Học Sinh, Quận Liên Chiểu, Đà Nẵng', 3),
(24, N'Học Sinh 14 - Phạm Văn Yên', 'student14@example.com', 'pass14_hash', '0323344556', N'Số 2121, Đường Học Sinh, TP. Huế, Thừa Thiên Huế', 3),
(25, N'Học Sinh 15 - Hoàng Thị Ánh', 'student15@example.com', 'pass15_hash', '0434455667', N'Số 2222, Đường Học Sinh, Quận Thốt Nốt, Cần Thơ', 3),
(26, N'Học Sinh 16 - Nguyễn Văn Bắc', 'student16@example.com', 'pass16_hash', '0545566778', N'Số 2323, Đường Học Sinh, Quận Hai Bà Trưng, Hà Nội', 3),
(27, N'Học Sinh 17 - Trần Thị Cẩm', 'student17@example.com', 'pass17_hash', '0656677889', N'Số 2424, Đường Học Sinh, Quận Bình Tân, TP. Hồ Chí Minh', 3),
(28, N'Học Sinh 18 - Lê Văn Dương', 'student18@example.com', 'pass18_hash', '0767788990', N'Số 2525, Đường Học Sinh, Quận Cẩm Lệ, Đà Nẵng', 3),
(29, N'Học Sinh 19 - Phạm Thị Ý', 'student19@example.com', 'pass19_hash', '0878899001', N'Số 2626, Đường Học Sinh, TP. Huế, Thừa Thiên Huế', 3),
(30, N'Học Sinh 20 - Hoàng Văn Đông', 'student20@example.com', 'pass20_hash', '0989900112', N'Số 2727, Đường Học Sinh, Quận Phong Điền, Cần Thơ', 3);
GO

-- Chèn dữ liệu vào bảng COURSES
INSERT INTO COURSES (course_id, course_title, course_description, course_price, created_at) VALUES
(1, N'Nhập Môn SQL', N'Khóa học cung cấp kiến thức cơ bản về SQL, từ cú pháp cơ bản đến cách truy vấn dữ liệu hiệu quả.', 1500000, '2024-01-01 10:00:00'),
(2, N'Kỹ Thuật SQL Nâng Cao', N'Tìm hiểu sâu về các kỹ thuật SQL nâng cao như stored procedures, triggers và tối ưu hóa truy vấn.', 2500000, '2024-02-01 10:00:00'),
(3, N'Kỹ Năng Giao Tiếp', N'Phát triển kỹ năng giao tiếp hiệu quả trong công việc và cuộc sống.', 1300000, '2024-06-01 10:00:00');
GO

-- Chèn dữ liệu vào bảng CHAPTERS
-- Đảm bảo created_at của CHAPTERS sau created_at của COURSES (do trigger trg_create_at_course_chapter)
INSERT INTO CHAPTERS (chapter_id, course_id, chapter_title, chapter_description, chapter_position, created_at) VALUES
(1, 1, N'Giới Thiệu SQL', N'Tổng quan về SQL, lịch sử phát triển và ứng dụng trong quản lý cơ sở dữ liệu.', 1, '2024-01-02 10:00:00'),
(2, 1, N'Câu Lệnh SELECT Cơ Bản', N'Học cách sử dụng câu lệnh SELECT để truy vấn dữ liệu từ cơ sở dữ liệu.', 2, '2024-01-03 10:00:00'),
(3, 1, N'Các Loại Join Trong SQL', N'Tìm hiểu về các loại join như INNER JOIN, LEFT JOIN và cách sử dụng chúng.', 3, '2024-01-04 10:00:00'),
(4, 1, N'Subqueries và Ứng Dụng', N'Hiểu về subquery, cách viết và ứng dụng trong các truy vấn phức tạp.', 4, '2024-01-05 10:00:00'),
(5, 1, N'Tối Ưu Hóa Truy Vấn SQL', N'Các kỹ thuật tối ưu hóa câu lệnh SQL để tăng hiệu suất truy vấn.', 5, '2024-01-06 10:00:00'),
(6, 2, N'SQL Nâng Cao - Tổng Quan', N'Giới thiệu các kỹ thuật SQL nâng cao và ứng dụng thực tế.', 1, '2024-02-02 10:00:00'),
(7, 2, N'Stored Procedures', N'Học cách tạo và sử dụng stored procedures để quản lý logic nghiệp vụ.', 2, '2024-02-03 10:00:00'),
(8, 2, N'Triggers Trong SQL', N'Tìm hiểu về triggers, cách chúng hoạt động và ứng dụng trong cơ sở dữ liệu.', 3, '2024-02-04 10:00:00'),
(9, 2, N'Indexes và Hiệu Suất', N'Cách sử dụng indexes để tăng tốc độ truy vấn dữ liệu.', 4, '2024-02-05 10:00:00'),
(10, 2, N'Quản Lý Transactions', N'Hiểu về transactions, cách đảm bảo tính toàn vẹn dữ liệu.', 5, '2024-02-06 10:00:00'),
(11, 3, N'Giao Tiếp Hiệu Quả', N'Tìm hiểu các nguyên tắc cơ bản để giao tiếp hiệu quả.', 1, '2024-06-02 10:00:00'),
(12, 3, N'Kỹ Năng Lắng Nghe', N'Phát triển kỹ năng lắng nghe chủ động để cải thiện giao tiếp.', 2, '2024-06-03 10:00:00'),
(13, 3, N'Kỹ Năng Thuyết Trình', N'Học cách trình bày ý tưởng một cách rõ ràng và thuyết phục.', 3, '2024-06-04 10:00:00'),
(14, 3, N'Giao Tiếp Phi Ngôn Ngữ', N'Hiểu về ngôn ngữ cơ thể và cách sử dụng nó trong giao tiếp.', 4, '2024-06-05 10:00:00'),
(15, 3, N'Giao Tiếp Trong Công Việc', N'Phát triển kỹ năng giao tiếp chuyên nghiệp trong môi trường làm việc.', 5, '2024-06-06 10:00:00');
GO

-- Chèn dữ liệu vào bảng VIDEOS
INSERT INTO VIDEOS (video_id, video_url, video_description, video_duration, created_at) VALUES
(1, 'http://example.com/video/sql_intro', N'Video giới thiệu tổng quan về SQL, lịch sử và ứng dụng.', 30, '2024-01-03 10:00:00'),
(2, 'http://example.com/video/sql_select', N'Video hướng dẫn cách viết câu lệnh SELECT cơ bản.', 45, '2024-01-04 10:00:00'),
(3, 'http://example.com/video/sql_joins', N'Video giải thích các loại join trong SQL với ví dụ thực tế.', 50, '2024-01-05 10:00:00'),
(4, 'http://example.com/video/sql_subqueries', N'Video hướng dẫn cách sử dụng subquery trong truy vấn SQL.', 40, '2024-01-06 10:00:00'),
(5, 'http://example.com/video/sql_optimization', N'Video giới thiệu các kỹ thuật tối ưu hóa truy vấn SQL.', 55, '2024-01-07 10:00:00'),
(6, 'http://example.com/video/sql_advanced', N'Video tổng quan về các kỹ thuật SQL nâng cao.', 60, '2024-02-03 10:00:00'),
(7, 'http://example.com/video/stored_procedures', N'Video hướng dẫn cách tạo stored procedures trong SQL.', 35, '2024-02-04 10:00:00'),
(8, 'http://example.com/video/triggers', N'Video giải thích triggers và ứng dụng thực tế.', 45, '2024-02-05 10:00:00'),
(9, 'http://example.com/video/indexes', N'Video hướng dẫn cách tạo và sử dụng indexes.', 50, '2024-02-06 10:00:00'),
(10, 'http://example.com/video/transactions', N'Video giải thích cách quản lý transactions trong SQL.', 55, '2024-02-07 10:00:00'),
(11, 'http://example.com/video/communication_effective', N'Video hướng dẫn cách giao tiếp hiệu quả.', 40, '2024-06-03 10:00:00'),
(12, 'http://example.com/video/listening_skills', N'Video giải thích kỹ năng lắng nghe chủ động.', 35, '2024-06-04 10:00:00'),
(13, 'http://example.com/video/presentation_skills', N'Video hướng dẫn kỹ năng thuyết trình chuyên nghiệp.', 50, '2024-06-05 10:00:00'),
(14, 'http://example.com/video/non_verbal_communication', N'Video giải thích giao tiếp phi ngôn ngữ.', 45, '2024-06-06 10:00:00'),
(15, 'http://example.com/video/workplace_communication', N'Video hướng dẫn giao tiếp trong môi trường làm việc.', 55, '2024-06-07 10:00:00');
GO

-- Chèn dữ liệu vào bảng LESSONS
-- Đảm bảo created_at của LESSONS sau created_at của CHAPTERS (do trigger trg_created_at_chapter_lesson)
INSERT INTO LESSONS (lesson_id, chapter_id, video_id, lesson_title, lesson_description, created_at) VALUES
(1, 1, 1, N'Bài 1: Tổng Quan SQL', N'Giới thiệu về SQL, vai trò và ứng dụng trong quản lý dữ liệu.', '2024-01-04 10:00:00'),
(2, 2, 2, N'Bài 1: Câu Lệnh SELECT Cơ Bản', N'Học cách sử dụng SELECT để truy vấn dữ liệu từ bảng.', '2024-01-05 10:00:00'),
(3, 3, 3, N'Bài 1: Hiểu Biết Joins', N'Tìm hiểu cách sử dụng các loại join trong SQL.', '2024-01-06 10:00:00'),
(4, 4, 4, N'Bài 1: Subqueries Cơ Bản', N'Học cách viết subquery để giải quyết các truy vấn phức tạp.', '2024-01-07 10:00:00'),
(5, 5, 5, N'Bài 1: Tối Ưu Hóa Truy Vấn', N'Các kỹ thuật tối ưu hóa truy vấn SQL để tăng hiệu suất.', '2024-01-08 10:00:00'),
(6, 6, 6, N'Bài 1: SQL Nâng Cao', N'Giới thiệu các kỹ thuật SQL nâng cao như stored procedures.', '2024-02-04 10:00:00'),
(7, 7, 7, N'Bài 1: Stored Procedures', N'Học cách tạo và sử dụng stored procedures trong SQL.', '2024-02-05 10:00:00'),
(8, 8, 8, N'Bài 1: Triggers Cơ Bản', N'Tìm hiểu về triggers và cách chúng hoạt động.', '2024-02-06 10:00:00'),
(9, 9, 9, N'Bài 1: Indexes và Hiệu Suất', N'Học cách sử dụng indexes để tối ưu hóa truy vấn.', '2024-02-07 10:00:00'),
(10, 10, 10, N'Bài 1: Transactions Cơ Bản', N'Hiểu về transactions và cách quản lý chúng.', '2024-02-08 10:00:00'),
(11, 11, 11, N'Bài 1: Giao Tiếp Hiệu Quả', N'Học các nguyên tắc cơ bản để giao tiếp hiệu quả.', '2024-06-04 10:00:00'),
(12, 12, 12, N'Bài 1: Kỹ Năng Lắng Nghe', N'Phát triển kỹ năng lắng nghe chủ động.', '2024-06-05 10:00:00'),
(13, 13, 13, N'Bài 1: Kỹ Năng Thuyết Trình', N'Học cách trình bày ý tưởng một cách rõ ràng.', '2024-06-06 10:00:00'),
(14, 14, 14, N'Bài 1: Giao Tiếp Phi Ngôn Ngữ', N'Tìm hiểu về ngôn ngữ cơ thể trong giao tiếp.', '2024-06-07 10:00:00'),
(15, 15, 15, N'Bài 1: Giao Tiếp Công Việc', N'Phát triển kỹ năng giao tiếp trong môi trường làm việc.', '2024-06-08 10:00:00');
GO

-- Chèn dữ liệu vào bảng DOCUMENTS
-- Đảm bảo created_at của DOCUMENTS sau created_at của LESSONS (do trigger trg_created_at_lesson_document)
INSERT INTO DOCUMENTS (document_id, lesson_id, document_url, document_description, created_at) VALUES
(1, 1, 'http://example.com/doc/sql_intro', N'Tài liệu giới thiệu về SQL, lịch sử và ứng dụng.', '2024-01-05 10:00:00'),
(2, 2, 'http://example.com/doc/select_statement', N'Tài liệu hướng dẫn cách viết câu lệnh SELECT.', '2024-01-06 10:00:00'),
(3, 3, 'http://example.com/doc/joins', N'Tài liệu giải thích các loại join trong SQL.', '2024-01-07 10:00:00'),
(4, 4, 'http://example.com/doc/subqueries', N'Tài liệu hướng dẫn sử dụng subquery trong SQL.', '2024-01-08 10:00:00'),
(5, 5, 'http://example.com/doc/optimization', N'Tài liệu về kỹ thuật tối ưu hóa truy vấn SQL.', '2024-01-09 10:00:00'),
(6, 6, 'http://example.com/doc/advanced_sql', N'Tài liệu tổng quan về SQL nâng cao.', '2024-02-05 10:00:00'),
(7, 7, 'http://example.com/doc/stored_procedures', N'Tài liệu hướng dẫn tạo stored procedures.', '2024-02-06 10:00:00'),
(8, 8, 'http://example.com/doc/triggers', N'Tài liệu giải thích triggers trong SQL.', '2024-02-07 10:00:00'),
(9, 9, 'http://example.com/doc/indexes', N'Tài liệu về cách sử dụng indexes trong SQL.', '2024-02-08 10:00:00'),
(10, 10, 'http://example.com/doc/transactions', N'Tài liệu về quản lý transactions trong SQL.', '2024-02-09 10:00:00'),
(11, 11, 'http://example.com/doc/communication', N'Tài liệu về các nguyên tắc giao tiếp hiệu quả.', '2024-06-05 10:00:00'),
(12, 12, 'http://example.com/doc/listening', N'Tài liệu về kỹ năng lắng nghe chủ động.', '2024-06-06 10:00:00'),
(13, 13, 'http://example.com/doc/presentation', N'Tài liệu về kỹ năng thuyết trình chuyên nghiệp.', '2024-06-07 10:00:00'),
(14, 14, 'http://example.com/doc/non_verbal', N'Tài liệu về giao tiếp phi ngôn ngữ.', '2024-06-08 10:00:00'),
(15, 15, 'http://example.com/doc/workplace_communication', N'Tài liệu về giao tiếp trong công việc.', '2024-06-09 10:00:00');
GO

-- Chèn dữ liệu vào bảng EXAMS
-- Đảm bảo created_at của EXAMS sau created_at của CHAPTERS (do trigger trg_created_at_chapter_exam)
INSERT INTO EXAMS (exam_id, course_id, chapter_id, exam_name, exam_duration, exam_description, created_at) VALUES
(1, 1, 1, N'Kiểm Tra Kiến Thức SQL Cơ Bản', 60, N'Bài kiểm tra đánh giá kiến thức cơ bản về SQL.', '2024-01-06 10:00:00'),
(2, 2, 6, N'Kiểm Tra SQL Nâng Cao', 90, N'Bài kiểm tra về các kỹ thuật SQL nâng cao.', '2024-02-06 10:00:00'),
(3, 3, 11, N'Kiểm Tra Kỹ Năng Giao Tiếp', 60, N'Bài kiểm tra đánh giá kỹ năng giao tiếp trong công việc và cuộc sống.', '2024-06-06 10:00:00');
GO

-- Chèn dữ liệu vào bảng ASSIGNMENTS
-- Đảm bảo created_at của ASSIGNMENTS sau created_at của LESSONS (do trigger trg_created_at_lesson_assignment)
INSERT INTO ASSIGNMENTS (assignment_id, lesson_id, assignment_duration, assignment_description, created_at) VALUES
(1, 1, 30, N'Thực hành viết câu lệnh SQL cơ bản để truy vấn dữ liệu.', '2024-01-07 10:00:00'),
(2, 2, 45, N'Luyện tập sử dụng câu lệnh SELECT với các điều kiện lọc.', '2024-01-08 10:00:00'),
(3, 3, 60, N'Thực hành kết hợp các loại join trong SQL.', '2024-01-09 10:00:00'),
(4, 4, 75, N'Viết subquery để giải quyết một bài toán thực tế.', '2024-01-10 10:00:00'),
(5, 5, 30, N'Tối ưu hóa một truy vấn SQL đã cho.', '2024-01-11 10:00:00'),
(6, 6, 45, N'Thực hành viết stored procedure đơn giản.', '2024-02-07 10:00:00'),
(7, 7, 60, N'Tạo một stored procedure với tham số đầu vào.', '2024-02-08 10:00:00'),
(8, 8, 75, N'Thiết kế một trigger để tự động cập nhật dữ liệu.', '2024-02-09 10:00:00'),
(9, 9, 30, N'Tạo index cho một bảng và kiểm tra hiệu suất.', '2024-02-10 10:00:00'),
(10, 10, 45, N'Thực hành quản lý transaction trong một kịch bản thực tế.', '2024-02-11 10:00:00'),
(11, 11, 30, N'Thực hành giao tiếp hiệu quả trong một tình huống giả định.', '2024-06-07 10:00:00'),
(12, 12, 45, N'Luyện tập lắng nghe chủ động với một đoạn hội thoại.', '2024-06-08 10:00:00'),
(13, 13, 60, N'Chuẩn bị một bài thuyết trình ngắn về một chủ đề tự chọn.', '2024-06-09 10:00:00'),
(14, 14, 75, N'Phân tích ngôn ngữ cơ thể trong một đoạn video.', '2024-06-10 10:00:00'),
(15, 15, 30, N'Thực hành giao tiếp trong một tình huống công việc giả định.', '2024-06-11 10:00:00');
GO

-- Chèn dữ liệu vào bảng ANSWERS
INSERT INTO ANSWERS (answer_id, answer_text) VALUES
(1, N'SELECT * FROM table WHERE condition;'),
(2, N'INNER JOIN table2 ON table1.id = table2.id'),
(3, N'LEFT JOIN table2 ON table1.id = table2.id'),
(4, N'SELECT column FROM table WHERE column IN (SELECT column FROM table2);'),
(5, N'CREATE INDEX idx_name ON table(column);'),
(6, N'BEGIN TRANSACTION; UPDATE table SET column = value; COMMIT;'),
(7, N'CREATE PROCEDURE proc_name AS BEGIN SELECT * FROM table; END;'),
(8, N'CREATE TRIGGER trg_name ON table AFTER INSERT AS BEGIN UPDATE table SET column = value; END;'),
(9, N'Tối ưu hóa bằng cách sử dụng index và giảm số lượng bản ghi truy vấn.'),
(10, N'SELECT column1, column2 FROM table WHERE EXISTS (SELECT 1 FROM table2 WHERE table2.id = table.id);'),
(11, N'Giao tiếp hiệu quả cần sự rõ ràng, lắng nghe và phản hồi phù hợp.'),
(12, N'Lắng nghe chủ động bằng cách tập trung và không ngắt lời.'),
(13, N'Thuyết trình cần chuẩn bị nội dung, giọng nói và hình ảnh minh họa.'),
(14, N'Ngôn ngữ cơ thể bao gồm ánh mắt, cử chỉ và tư thế.'),
(15, N'Giao tiếp trong công việc cần lịch sự, chuyên nghiệp và ngắn gọn.');
GO

-- Chèn dữ liệu vào bảng QUESTIONS
-- Đảm bảo chỉ có một trong exam_id hoặc assignment_id là NOT NULL (do CHECK constraint)
INSERT INTO QUESTIONS (question_id, question_text, question_type, question_score, answer_id, exam_id, assignment_id) VALUES
(1, N'Câu lệnh SQL nào dùng để chọn tất cả dữ liệu từ một bảng?', N'MCQ', 5, 1, 1, NULL),
(2, N'Loại join nào trả về tất cả các dòng từ bảng bên trái?', N'MCQ', 5, 3, 1, NULL),
(3, N'Viết một subquery để tìm giá trị lớn nhất trong một cột.', N'Essay', 10, 4, 1, NULL),
(4, N'Làm thế nào để tạo một index trong SQL?', N'Essay', 10, 5, 1, NULL),
(5, N'Giải thích cách quản lý transactions trong SQL.', N'Essay', 10, 6, 1, NULL),
(6, N'Viết một stored procedure để đếm số bản ghi trong bảng.', N'Essay', 10, 7, 2, NULL),
(7, N'Trigger trong SQL có tác dụng gì? Viết một ví dụ.', N'Essay', 10, 8, 2, NULL),
(8, N'Làm thế nào để tối ưu hóa một truy vấn SQL?', N'Essay', 10, 9, 2, NULL),
(9, N'Viết một câu lệnh SQL sử dụng EXISTS.', N'Essay', 10, 10, 2, NULL),
(10, N'Index trong SQL có vai trò gì? Ví dụ?', N'Essay', 10, 5, 2, NULL),
(11, N'Nguyên tắc quan trọng nhất của giao tiếp hiệu quả là gì?', N'MCQ', 5, 11, 3, NULL),
(12, N'Làm thế nào để lắng nghe chủ động một cách hiệu quả?', N'Essay', 10, 12, 3, NULL),
(13, N'Các yếu tố cần thiết để thuyết trình thành công là gì?', N'Essay', 10, 13, 3, NULL),
(14, N'Ngôn ngữ cơ thể ảnh hưởng đến giao tiếp như thế nào?', N'MCQ', 5, 14, 3, NULL),
(15, N'Viết một đoạn giao tiếp ngắn trong tình huống công việc.', N'Essay', 10, 15, 3, NULL),
(16, N'Viết câu lệnh SQL để truy vấn dữ liệu từ 2 bảng.', N'Essay', 10, 2, NULL, 1),
(17, N'Làm thế nào để sử dụng LEFT JOIN trong SQL?', N'Essay', 10, 3, NULL, 2),
(18, N'Viết một subquery để lọc dữ liệu từ một bảng.', N'Essay', 10, 4, NULL, 3),
(19, N'Tạo một index cho bảng và giải thích lợi ích.', N'Essay', 10, 5, NULL, 4),
(20, N'Giải thích cách sử dụng transaction trong SQL.', N'Essay', 10, 6, NULL, 5);
GO

-- Chèn dữ liệu vào bảng PAYMENTS
INSERT INTO PAYMENTS (payment_id, user_id, course_id, payment_description, payment_amount, payment_method, created_at) VALUES
(1, 11, 1, N'Thanh toán khóa Nhập Môn SQL', 1500000, N'Thẻ Tín Dụng', '2024-01-10 10:00:00'),
(2, 12, 2, N'Thanh toán khóa Kỹ Thuật SQL Nâng Cao', 2500000, N'MoMo', '2024-02-10 10:00:00'),
(3, 30, 3, N'Thanh toán khóa Kỹ Năng Giao Tiếp', 1300000, N'Chuyển Khoản', '2024-06-10 10:00:00'),
(4, 13, 1, N'Thanh toán khóa Nhập Môn SQL', 1500000, N'Thẻ Tín Dụng', '2024-01-12 10:00:00'),
(5, 14, 2, N'Thanh toán khóa Kỹ Thuật SQL Nâng Cao', 2500000, N'MoMo', '2024-02-12 10:00:00');
GO

-- Chèn dữ liệu vào bảng USER_PROGRESS
-- Đảm bảo is_complete và completed_at hợp lệ (do trigger trg_is_complete_user_progress)
INSERT INTO USER_PROGRESS (user_progress_id, user_id, video_id, is_complete, completed_at) VALUES
(1, 11, 1, 1, '2024-01-11 10:00:00'),
(2, 11, 2, 1, '2024-01-12 10:00:00'),
(3, 11, 3, 0, NULL),
(4, 11, 4, 0, NULL),
(5, 11, 5, 0, NULL),
(6, 12, 6, 1, '2024-02-11 10:00:00'),
(7, 12, 7, 1, '2024-02-12 10:00:00'),
(8, 12, 8, 0, NULL),
(9, 12, 9, 0, NULL),
(10, 12, 10, 0, NULL),
(11, 30, 11, 1, '2024-06-11 10:00:00'),
(12, 30, 12, 1, '2024-06-12 10:00:00'),
(13, 30, 13, 0, NULL),
(14, 30, 14, 0, NULL),
(15, 30, 15, 0, NULL),
(16, 13, 1, 1, '2024-01-13 10:00:00'),
(17, 14, 6, 1, '2024-02-13 10:00:00');
GO

-- Chèn dữ liệu vào bảng USER_COURSE_STATUS
-- Đảm bảo user_course_status_id khớp với PAYMENTS (do stored procedure update_create_payment_course_status)
INSERT INTO USER_COURSE_STATUS (user_course_status_id, user_id, course_id, course_status, graduated_at) VALUES
(1, 11, 1, N'Đang Học', NULL),
(2, 12, 2, N'Chưa Bắt Đầu', NULL),
(3, 30, 3, N'Đang Học', NULL),
(4, 13, 1, N'Đang Học', NULL),
(5, 14, 2, N'Chưa Bắt Đầu', NULL);
GO

-- Chèn dữ liệu vào bảng FEEDBACK
-- Đảm bảo created_at của FEEDBACK sau created_at của COURSES (do trigger trg_created_at_course_feedback)
INSERT INTO FEEDBACK (feedback_id, user_id, course_id, chapter_id, lesson_id, rating, feedback_comment, created_at) VALUES
(1, 11, 1, NULL, NULL, 5, N'Khóa học rất chi tiết, dễ hiểu, phù hợp cho người mới bắt đầu.', '2024-01-12 10:00:00'),
(2, 12, 2, 6, NULL, 4, N'Nội dung SQL nâng cao rất hữu ích, cần thêm ví dụ thực tế.', '2024-02-12 10:00:00'),
(3, 30, 3, 11, NULL, 4, N'Khóa học giao tiếp rất thực tế, cần thêm bài tập nhóm.', '2024-06-12 10:00:00'),
(4, 13, 1, NULL, NULL, 4, N'Khóa học SQL cơ bản rất tốt, nhưng cần thêm bài tập thực hành.', '2024-01-14 10:00:00'),
(5, 14, 2, 7, NULL, 5, N'Khóa học SQL nâng cao rất chất lượng, đặc biệt phần stored procedures.', '2024-02-14 10:00:00');
GO

-- Chèn dữ liệu vào bảng TEACHER_COURSES
INSERT INTO TEACHER_COURSES (teacher_id, course_id) VALUES
(6, 1),
(6, 2),
(10, 3),
(7, 1),
(8, 2);
GO
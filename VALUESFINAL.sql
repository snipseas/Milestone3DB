USE DBProject

INSERT INTO Admin (Email, password_hash, first_name,last_name)
VALUES 
('admin1@example.com', '123456', 'Admin', 'One'),
('admin2@example.com', 'helloworld', 'Admin', 'Two');

-- 1. Insert Learner
INSERT INTO Learner (LearnerID, first_name, last_name, gender, birth_date, country, cultural_background)
VALUES
(1, 'John', 'Doe', 'Male', '1995-05-10', 'USA', 'Western'),
(2, 'Jane', 'Smith', 'Female', '1993-07-25', 'UK', 'European'),
(3, 'Alice', 'Johnson', 'Female', '1997-09-15', 'Canada', 'North American');

-- 2. Insert Skills --
INSERT INTO Skills (LearnerID, skill)
VALUES
(1, 'Programming'),
(2, 'Data Analysis'),
(3, 'Machine Learning');

-- 3. Insert LearningPreference
INSERT INTO LearningPreference (LearnerID, preference)
VALUES
(1, 'Visual'),
(2, 'Auditory'),
(3, 'Kinesthetic');

-- 4. Insert PersonalizationProfiles
INSERT INTO PersonalizationProfiles (LearnerID, ProfileID, Prefered_content_type, emotional_state, personality_type)
VALUES
(1, 1, 'Video', 'Happy', 'Extrovert'),
(2, 2, 'Article', 'Sad', 'Introvert'),
(3, 3, 'Podcast', 'Neutral', 'Balanced');

-- 5. Insert HealthCondition
INSERT INTO HealthCondition (LearnerID, ProfileID, condition)
VALUES
(1, 1, 'None'),
(2, 2, 'Asthma'),
(3, 3, 'Migraine');

-- 6. Insert Course
INSERT INTO Course (CourseID, Title, learning_objective, credit_points, difficulty_level, description)
VALUES
(1, 'Intro to Programming', 'Learn basic programming concepts', 5, 'Easy', 'An introductory course to programming.'),
(2, 'Data Science 101', 'Learn data manipulation and analysis', 6, 'Medium', 'A beginner course in data science.'),
(3, 'Machine Learning', 'Understand machine learning algorithms', 7, 'Hard', 'A comprehensive course on machine learning.');

-- 7. Insert CoursePrerequisite
INSERT INTO CoursePrerequisite (CourseID, Prereq)
VALUES
(2, 1),  -- Data Science 101 requires Intro to Programming
(3, 2);  -- Machine Learning requires Data Science 101

-- 8. Insert Modules
INSERT INTO Modules (ModuleID, CourseID, Title, difficulty, contentURL)
VALUES
(1, 1, 'Variables and Data Types', 'Easy', 'https://example.com/module1'),
(2, 2, 'Data Cleaning', 'Medium', 'https://example.com/module2'),
(3, 3, 'Supervised Learning', 'Hard', 'https://example.com/module3');

-- 9. Insert Target_traits
INSERT INTO Target_traits (ModuleID, CourseID, Trait)
VALUES
(1, 1, 'Beginner'),
(2, 2, 'Intermediate'),
(3, 3, 'Advanced');

-- 10. Insert ModuleContent
INSERT INTO ModuleContent (ModuleID, CourseID, content_type)
VALUES
(1, 1, 'Video'),
(2, 2, 'Article'),
(3, 3, 'Exercise');

-- 11. Insert ContentLibrary
INSERT INTO ContentLibrary (ID, ModuleID, CourseID, Title, description, metadata, type, content_URL)
VALUES
(1, 1, 1, 'Introduction to Variables', 'Learn about variables in programming', 'Beginner level', 'Video', 'https://example.com/intro-to-vars'),
(2, 2, 2, 'Data Cleaning Guide', 'A comprehensive guide to data cleaning', 'Intermediate level', 'Article', 'https://example.com/data-cleaning'),
(3, 3, 3, 'Machine Learning Algorithms', 'An overview of machine learning algorithms', 'Advanced level', 'Exercise', 'https://example.com/ml-algorithms');

-- 12. Insert Assessments
INSERT INTO Assessments (ID, ModuleID, CourseID, type, total_marks, passing_marks, criteria, weightage, description, title)
VALUES
(1, 1, 1, 'Quiz', 10, 6, 'Basic questions on programming', 0.2, 'Basic programming knowledge assessment', 'Programming Basics Quiz'),
(2, 2, 2, 'Assignment', 20, 12, 'Data cleaning tasks', 0.3, 'Assessment on data cleaning techniques', 'Data Cleaning Assignment'),
(3, 3, 3, 'Exam', 30, 18, 'Machine learning algorithms', 0.5, 'Final exam on machine learning algorithms', 'Machine Learning Exam');

-- 13. Insert Takenassessment
INSERT INTO Takenassessment (AssessmentID, LearnerID, scoredPoint)
VALUES
(1, 1, 8),
(2, 2, 18),
(3, 3, 27);

-- 14. Insert Learning_activities 
INSERT INTO Learning_activities (ActivityID, ModuleID, CourseID, activity_type, instruction_details, Max_points)
VALUES
(1, 1, 1, 'Quiz', 'Answer the following questions about programming.', 10),
(2, 2, 2, 'Assignment', 'Complete the data cleaning tasks and submit.', 20),
(3, 3, 3, 'Exam', 'Answer questions on machine learning algorithms.', 30);

-- 15. Insert Interaction_log 
INSERT INTO Interaction_log (LogID, activity_ID, LearnerID, Duration, Timestamp, action_type)
VALUES
(1, 1, 1, 120, '2024-11-30 09:00:00', 'View'),
(2, 2, 2, 90, '2024-11-30 10:00:00', 'Complete'),
(3, 3, 3, 150, '2024-11-30 11:00:00', 'View');

-- 16. Insert Emotional_feedback
INSERT INTO Emotional_feedback (LearnerID, activityID, timestamp, emotional_state)
VALUES
(1, 1, '2024-11-30 09:00:00', 'Happy'),
(2, 2, '2024-11-30 10:00:00', 'Neutral'),
(3, 3, '2024-11-30 11:00:00', 'Stressed');

-- 17. Insert Learning_path
INSERT INTO Learning_path (pathID, LearnerID, ProfileID, completion_status, custom_content, adaptive_rules)
VALUES
(1, 1, 1, 'In Progress', 'Extra videos', 'Content based on quiz scores'),
(2, 2, 2, 'Completed', 'No extra content', 'No rules'),
(3, 3, 3, 'In Progress', 'Extra reading materials', 'Adaptive based on performance');

-- 18. Insert Instructor
INSERT INTO Instructor (InstructorID, name, latest_qualification, expertise_area, email)
VALUES
(1, 'Dr. Smith', 'PhD in Computer Science', 'Programming', 'drsmith@example.com'),
(2, 'Prof. Johnson', 'Master in Data Science', 'Data Analysis', 'profjohnson@example.com'),
(3, 'Dr. Lee', 'PhD in AI', 'Machine Learning', 'drlee@example.com');

-- 19. Insert Pathreview
INSERT INTO Pathreview (InstructorID, PathID, review)
VALUES
(1, 1, 'Great learning path, very insightful.'),
(2, 2, 'The content was useful but needs more practical examples.'),
(3, 3, 'Excellent content and well-structured.');

-- 20. Insert Emotionalfeedback_review
INSERT INTO Emotionalfeedback_review (InstructorID, review)
VALUES
(1, 'Learner seemed engaged with the material.'),
(2, 'Learner seemed neutral, but did complete the task.'),
(3, 'Learner struggled with the content but showed effort.');

-- 21. Insert Course_enrollment
INSERT INTO Course_enrollment (EnrollmentID, CourseID, LearnerID, completion_date, enrollment_date, status)
VALUES
(1, 1, 1, '2024-12-01', '2024-11-01', 'In Progress'),
(2, 2, 2, '2024-12-10', '2024-11-05', 'Completed'),
(3, 3, 3, '2024-12-15', '2024-11-10', 'Enrolled');

-- 22. Insert Teaches
INSERT INTO Teaches (InstructorID, CourseID)
VALUES
(1, 1),
(2, 2),
(3, 3);

-- 23. Insert Leaderboard
INSERT INTO Leaderboard (BoardID, season)
VALUES
(1, 'Fall 2024'),
(2, 'Spring 2025');

-- 24. Insert Ranking
INSERT INTO Ranking (BoardID, LearnerID, CourseID, rank, total_points)
VALUES
(1, 1, 1, 1, 90),
(1, 2, 2, 2, 80),
(2, 3, 3, 1, 95);

-- 25. Insert Learning_goal
INSERT INTO Learning_goal (ID, status, deadline, description)
VALUES
(1, 'In Progress', '2024-12-01', 'Complete Data Science course'),
(2, 'Completed', '2024-11-30', 'Finish Machine Learning project'),
(3, 'In Progress', '2024-12-15', 'Complete Programming basics');

-- 26. Insert LearnersGoals
INSERT INTO LearnersGoals (GoalID, LearnerID)
VALUES
(1, 1),
(2, 2),
(3, 3);

-- 27. Insert Survey
INSERT INTO Survey (ID, Title)
VALUES
(1, 'Course Feedback'),
(2, 'Instructor Rating'),
(3, 'THE MUFFIN MAN');
SELECT * FROM Survey

-- 28. Insert SurveyQuestions
INSERT INTO SurveyQuestions (SurveyID, Question)
VALUES
(1, 'How would you rate the course content?'),
(2, 'Was the course material useful?'),
(3, 'How would you rate the instructor teaching skills?'); 

-- 29. Insert FilledSurvey --
INSERT INTO FilledSurvey (SurveyID, Question, LearnerID, Answer)
VALUES
(1, 'How would you rate the course content?', 1, 'Very Good'),
(2, 'Was the course material useful?', 2, 'Yes'),
(3, 'How would you rate the instructor teaching skills?', 3, 'Good');

-- 30. Insert Notification
INSERT INTO Notification (ID, timestamp, message, urgency_level, ReadStatus)
VALUES
(1, '2024-11-30 08:00:00', 'New module available!', 'High', 0),
(2, '2024-11-30 09:00:00', 'Reminder: Complete your quiz!', 'Medium', 0);

-- 31. Insert ReceivedNotification
INSERT INTO ReceivedNotification (NotificationID, LearnerID)
VALUES
(1, 1),
(2, 2);

-- 32. Insert Badge
INSERT INTO Badge (BadgeID, title, description, criteria, points)
VALUES
(1, 'Top Learner', 'Earned by scoring 90 or more in a course', 'Scoring 90% or higher in a course', 10),
(2, 'Quiz Master', 'Complete all quizzes with 80% or higher', 'Complete all quizzes with 80% or higher', 5);

-- 33. Insert SkillProgression 
INSERT INTO SkillProgression (ID, proficiency_level, LearnerID, skill_name, timestamp)
VALUES
(1, 'Intermediate', 1, 'Programming', '2024-11-15'),
(2, 'Beginner', 2, 'Data Analysis', '2024-11-15');
SELECT * FROM Skills

-- 34. Insert Achievement
INSERT INTO Achievement (AchievementID, LearnerID, BadgeID, description, date_earned, type)
VALUES
(1, 1, 1, 'Earned Top Learner Badge', '2024-11-30', 'Badge'),
(2, 2, 2, 'Earned Quiz Master Badge', '2024-11-29', 'Badge');

-- 35. Insert Reward
INSERT INTO Reward (RewardID, value, description, type)
VALUES
(1, 50, 'Gift card for course completion', 'Gift'),
(2, 100, 'Extra credit points for achievements', 'Points');

-- 36. Insert Quest
INSERT INTO Quest (QuestID, difficulty_level, criteria, description, title)
VALUES
(1, 'Medium', 'Complete the programming challenges', 'A set of programming challenges', 'Programming Quest'),
(2, 'Hard', 'Complete the machine learning project', 'A project in machine learning', 'ML Quest');

-- 37. Insert Skill_Mastery
INSERT INTO Skill_Mastery (QuestID, skill)
VALUES
(1, 'Programming'),
(2, 'Machine Learning');

-- 38. Insert Collaborative
INSERT INTO Collaborative (QuestID, deadline, max_num_participants)
VALUES
(1, '2024-12-15', 5),
(2, '2024-12-20', 3);

-- 39. Insert LearnersCollaboration
INSERT INTO LearnersCollaboration (LearnerID, QuestID, completion_status)
VALUES
(1, 1, 'Completed'),
(2, 2, 'In Progress');

-- 40. Insert LearnersMastery --
INSERT INTO LearnersMastery (LearnerID, QuestID, completion_status, skill)
VALUES
(1, 1, 'Mastered', 'Programming'),
(2, 2, 'In Progress', 'Machine Learning');
SELECT * FROM Skill_Mastery

-- 41. Insert Discussion_forum
INSERT INTO Discussion_forum (forumID, ModuleID, CourseID, title, last_active, timestamp, description)
VALUES
(1, 1, 1, 'Programming Discussion', '2024-11-30', '2024-11-30 10:00:00', 'Discuss programming topics here'),
(2, 2, 2, 'Data Science Forum', '2024-11-29', '2024-11-29 09:00:00', 'Talk about data science projects');

-- 42. Insert LearnerDiscussion
INSERT INTO LearnerDiscussion (ForumID, LearnerID, Post, time)
VALUES
(1, 1, 'What is a variable?', '2024-11-30 10:30:00'),
(2, 2, 'How do I clean my data?', '2024-11-29 09:30:00');

-- 43. Insert QuestReward
INSERT INTO QuestReward (RewardID, QuestID, LearnerID, Time_earned)
VALUES
(1, 1, 1, '2024-12-01'),
(2, 2, 2, '2024-12-05');

--DELETE FROM Learner --1
--DELETE FROM HealthCondition --2
--DELETE FROM Interaction_log --3
--DELETE FROM Leaderboard --4
--DELETE FROM LearnerDiscussion --5
--DELETE FROM LearnersCollaboration --6
--DELETE FROM LearnersGoals --7
--DELETE FROM LearnersMastery --8
--DELETE FROM Learning_activities --9
--DELETE FROM Learning_goal --10
--DELETE FROM Learning_path --11
--DELETE FROM LearningPreference --12
--DELETE FROM Achievement --13
--DELETE FROM Assessments --14
--DELETE FROM Badge --15
--DELETE FROM Collaborative --16
--DELETE FROM ContentLibrary --17
--DELETE FROM Course --18
--DELETE FROM Course_enrollment --19
--DELETE FROM CoursePrerequisite --20
--DELETE FROM Discussion_forum --21
--DELETE FROM Pathreview --22
--DELETE FROM PersonalizationProfiles --23
--DELETE FROM QuestReward --24
--DELETE FROM Ranking --25
--DELETE FROM ReceivedNotification --26
--DELETE FROM Reward --27
--DELETE FROM Skill_Mastery --28
--DELETE FROM SkillProgression --29
--DELETE FROM Emotional_feedback --30
--DELETE FROM Emotionalfeedback_review --31
--DELETE FROM FilledSurvey --32
--DELETE FROM Quest --33
--DELETE FROM SurveyQuestions --34
--DELETE FROM Survey --35
--DELETE FROM Takenassessment --36
--DELETE FROM Target_traits --37
--DELETE FROM Teaches --38
--DELETE FROM Modules --39
--DELETE FROM ModuleContent --40
--DELETE FROM Instructor --41
--DELETE FROM Notification --42
--DELETE FROM Skills --43

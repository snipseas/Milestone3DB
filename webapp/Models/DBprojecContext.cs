using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;

namespace webapp.Models;

public partial class DBprojecContext : DbContext
{
    public DBprojecContext()
    {
    }

    public DBprojecContext(DbContextOptions<DBprojecContext> options)
        : base(options)
    {
    }

    public virtual DbSet<Achievement> Achievements { get; set; }

    public virtual DbSet<Admin> Admins { get; set; }

    public virtual DbSet<Assessment> Assessments { get; set; }

    public virtual DbSet<Badge> Badges { get; set; }

    public virtual DbSet<Collaborative> Collaboratives { get; set; }

    public virtual DbSet<ContentLibrary> ContentLibraries { get; set; }

    public virtual DbSet<Course> Courses { get; set; }

    public virtual DbSet<CourseEnrollment> CourseEnrollments { get; set; }

    public virtual DbSet<DiscussionForum> DiscussionForums { get; set; }

    public virtual DbSet<EmotionalFeedback> EmotionalFeedbacks { get; set; }

    public virtual DbSet<EmotionalfeedbackReview> EmotionalfeedbackReviews { get; set; }

    public virtual DbSet<FilledSurvey> FilledSurveys { get; set; }

    public virtual DbSet<HealthCondition> HealthConditions { get; set; }

    public virtual DbSet<Instructor> Instructors { get; set; }

    public virtual DbSet<InteractionLog> InteractionLogs { get; set; }

    public virtual DbSet<Leaderboard> Leaderboards { get; set; }

    public virtual DbSet<Learner> Learners { get; set; }

    public virtual DbSet<LearnerDiscussion> LearnerDiscussions { get; set; }

    public virtual DbSet<LearnersCollaboration> LearnersCollaborations { get; set; }

    public virtual DbSet<LearnersMastery> LearnersMasteries { get; set; }

    public virtual DbSet<LearningActivity> LearningActivities { get; set; }

    public virtual DbSet<LearningGoal> LearningGoals { get; set; }

    public virtual DbSet<LearningPath> LearningPaths { get; set; }

    public virtual DbSet<LearningPreference> LearningPreferences { get; set; }

    public virtual DbSet<Module> Modules { get; set; }

    public virtual DbSet<ModuleContent> ModuleContents { get; set; }

    public virtual DbSet<Notification> Notifications { get; set; }

    public virtual DbSet<Pathreview> Pathreviews { get; set; }

    public virtual DbSet<PersonalizationProfile> PersonalizationProfiles { get; set; }

    public virtual DbSet<Quest> Quests { get; set; }

    public virtual DbSet<QuestReward> QuestRewards { get; set; }

    public virtual DbSet<Ranking> Rankings { get; set; }

    public virtual DbSet<Reward> Rewards { get; set; }

    public virtual DbSet<Skill> Skills { get; set; }

    public virtual DbSet<SkillMastery> SkillMasteries { get; set; }

    public virtual DbSet<SkillProgression> SkillProgressions { get; set; }

    public virtual DbSet<Survey> Surveys { get; set; }

    public virtual DbSet<SurveyQuestion> SurveyQuestions { get; set; }

    public virtual DbSet<Takenassessment> Takenassessments { get; set; }

    public virtual DbSet<TargetTrait> TargetTraits { get; set; }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
 //To protect potentially sensitive information in your connection string, you should move it out of source code. You can avoid scaffolding the connection string by using the Name= syntax to read it from configuration - see https://go.microsoft.com/fwlink/?linkid=2131148. For more guidance on storing connection strings, see https://go.microsoft.com/fwlink/?LinkId=723263.
        => optionsBuilder.UseSqlServer("Server=(localdb)\\MSSQLLocalDB;Database=DBProject;Trusted_Connection=True;");

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Achievement>(entity =>
        {
            entity.HasKey(e => e.AchievementId).HasName("PK__Achievem__276330E0E3F9D010");

            entity.ToTable("Achievement");

            entity.Property(e => e.AchievementId)
                .ValueGeneratedNever()
                .HasColumnName("AchievementID");
            entity.Property(e => e.BadgeId).HasColumnName("BadgeID");
            entity.Property(e => e.DateEarned).HasColumnName("date_earned");
            entity.Property(e => e.Description)
                .HasMaxLength(100)
                .IsUnicode(false)
                .HasColumnName("description");
            entity.Property(e => e.LearnerId).HasColumnName("LearnerID");
            entity.Property(e => e.Type)
                .HasMaxLength(50)
                .IsUnicode(false)
                .HasColumnName("type");

            entity.HasOne(d => d.Badge).WithMany(p => p.Achievements)
                .HasForeignKey(d => d.BadgeId)
                .HasConstraintName("FK__Achieveme__Badge__1BC821DD");

            entity.HasOne(d => d.Learner).WithMany(p => p.Achievements)
                .HasForeignKey(d => d.LearnerId)
                .HasConstraintName("FK__Achieveme__Learn__1AD3FDA4");
        });

        modelBuilder.Entity<Admin>(entity =>
        {
            entity.HasKey(e => e.AdminId).HasName("PK__Admin__719FE4E866807AD3");

            entity.ToTable("Admin");

            entity.HasIndex(e => e.Email, "UQ__Admin__AB6E6164AD05C4A7").IsUnique();

            entity.Property(e => e.AdminId).HasColumnName("AdminID");
            entity.Property(e => e.BirthDate).HasColumnName("birth_date");
            entity.Property(e => e.Country)
                .HasMaxLength(100)
                .HasColumnName("country");
            entity.Property(e => e.Email)
                .HasMaxLength(255)
                .HasColumnName("email");
            entity.Property(e => e.FirstName)
                .HasMaxLength(100)
                .HasColumnName("first_name");
            entity.Property(e => e.FullName)
                .HasMaxLength(201)
                .HasComputedColumnSql("(([first_name]+' ')+[last_name])", false)
                .HasColumnName("full_name");
            entity.Property(e => e.Gender)
                .HasMaxLength(10)
                .HasColumnName("gender");
            entity.Property(e => e.LastName)
                .HasMaxLength(100)
                .HasColumnName("last_name");
            entity.Property(e => e.PasswordHash)
                .HasMaxLength(255)
                .HasColumnName("password_hash");
            entity.Property(e => e.Role)
                .HasMaxLength(50)
                .HasDefaultValue("Admin")
                .HasColumnName("role");
        });

        modelBuilder.Entity<Assessment>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Assessme__3214EC27D4F813C6");

            entity.Property(e => e.Id)
                .ValueGeneratedNever()
                .HasColumnName("ID");
            entity.Property(e => e.CourseId).HasColumnName("CourseID");
            entity.Property(e => e.Criteria)
                .HasMaxLength(100)
                .IsUnicode(false)
                .HasColumnName("criteria");
            entity.Property(e => e.Description)
                .HasMaxLength(100)
                .IsUnicode(false)
                .HasColumnName("description");
            entity.Property(e => e.ModuleId).HasColumnName("ModuleID");
            entity.Property(e => e.PassingMarks).HasColumnName("passing_marks");
            entity.Property(e => e.Title)
                .HasMaxLength(100)
                .IsUnicode(false)
                .HasColumnName("title");
            entity.Property(e => e.TotalMarks).HasColumnName("total_marks");
            entity.Property(e => e.Type)
                .HasMaxLength(100)
                .IsUnicode(false)
                .HasColumnName("type");
            entity.Property(e => e.Weightage)
                .HasColumnType("decimal(5, 2)")
                .HasColumnName("weightage");

            entity.HasOne(d => d.Module).WithMany(p => p.Assessments)
                .HasForeignKey(d => new { d.ModuleId, d.CourseId })
                .HasConstraintName("FK__Assessments__5535A963");
        });

        modelBuilder.Entity<Badge>(entity =>
        {
            entity.HasKey(e => e.BadgeId).HasName("PK__Badge__1918237C38572539");

            entity.ToTable("Badge");

            entity.Property(e => e.BadgeId)
                .ValueGeneratedNever()
                .HasColumnName("BadgeID");
            entity.Property(e => e.Criteria)
                .HasMaxLength(100)
                .IsUnicode(false)
                .HasColumnName("criteria");
            entity.Property(e => e.Description)
                .HasMaxLength(100)
                .IsUnicode(false)
                .HasColumnName("description");
            entity.Property(e => e.Points).HasColumnName("points");
            entity.Property(e => e.Title)
                .HasMaxLength(100)
                .IsUnicode(false)
                .HasColumnName("title");
        });

        modelBuilder.Entity<Collaborative>(entity =>
        {
            entity.HasKey(e => e.QuestId).HasName("PK__Collabor__B6619ACB695180A5");

            entity.ToTable("Collaborative");

            entity.Property(e => e.QuestId)
                .ValueGeneratedNever()
                .HasColumnName("QuestID");
            entity.Property(e => e.Deadline).HasColumnName("deadline");
            entity.Property(e => e.MaxNumParticipants).HasColumnName("max_num_participants");

            entity.HasOne(d => d.Quest).WithOne(p => p.Collaborative)
                .HasForeignKey<Collaborative>(d => d.QuestId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Collabora__Quest__25518C17");
        });

        modelBuilder.Entity<ContentLibrary>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__ContentL__3214EC271B49AB84");

            entity.ToTable("ContentLibrary");

            entity.Property(e => e.Id)
                .ValueGeneratedNever()
                .HasColumnName("ID");
            entity.Property(e => e.ContentUrl)
                .HasMaxLength(255)
                .IsUnicode(false)
                .HasColumnName("content_URL");
            entity.Property(e => e.CourseId).HasColumnName("CourseID");
            entity.Property(e => e.Description)
                .HasMaxLength(100)
                .IsUnicode(false)
                .HasColumnName("description");
            entity.Property(e => e.Metadata)
                .HasMaxLength(100)
                .IsUnicode(false)
                .HasColumnName("metadata");
            entity.Property(e => e.ModuleId).HasColumnName("ModuleID");
            entity.Property(e => e.Title)
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.Type)
                .HasMaxLength(100)
                .IsUnicode(false)
                .HasColumnName("type");

            entity.HasOne(d => d.Module).WithMany(p => p.ContentLibraries)
                .HasForeignKey(d => new { d.ModuleId, d.CourseId })
                .HasConstraintName("FK__ContentLibrary__52593CB8");
        });

        modelBuilder.Entity<Course>(entity =>
        {
            entity.HasKey(e => e.CourseId).HasName("PK__Course__C92D7187307EE7F9");

            entity.ToTable("Course");

            entity.Property(e => e.CourseId)
                .ValueGeneratedNever()
                .HasColumnName("CourseID");
            entity.Property(e => e.CreditPoints).HasColumnName("credit_points");
            entity.Property(e => e.Description)
                .HasMaxLength(100)
                .IsUnicode(false)
                .HasColumnName("description");
            entity.Property(e => e.DifficultyLevel)
                .HasMaxLength(50)
                .IsUnicode(false)
                .HasColumnName("difficulty_level");
            entity.Property(e => e.LearningObjective)
                .HasMaxLength(100)
                .IsUnicode(false)
                .HasColumnName("learning_objective");
            entity.Property(e => e.Title)
                .HasMaxLength(100)
                .IsUnicode(false);

            entity.HasMany(d => d.Courses).WithMany(p => p.Prereqs)
                .UsingEntity<Dictionary<string, object>>(
                    "CoursePrerequisite",
                    r => r.HasOne<Course>().WithMany()
                        .HasForeignKey("CourseId")
                        .OnDelete(DeleteBehavior.ClientSetNull)
                        .HasConstraintName("FK__CoursePre__Cours__45F365D3"),
                    l => l.HasOne<Course>().WithMany()
                        .HasForeignKey("Prereq")
                        .OnDelete(DeleteBehavior.ClientSetNull)
                        .HasConstraintName("FK__CoursePre__Prere__46E78A0C"),
                    j =>
                    {
                        j.HasKey("CourseId", "Prereq").HasName("PK__CoursePr__F8693C2C9D86F3A1");
                        j.ToTable("CoursePrerequisite");
                        j.IndexerProperty<int>("CourseId").HasColumnName("CourseID");
                    });

            entity.HasMany(d => d.Prereqs).WithMany(p => p.Courses)
                .UsingEntity<Dictionary<string, object>>(
                    "CoursePrerequisite",
                    r => r.HasOne<Course>().WithMany()
                        .HasForeignKey("Prereq")
                        .OnDelete(DeleteBehavior.ClientSetNull)
                        .HasConstraintName("FK__CoursePre__Prere__46E78A0C"),
                    l => l.HasOne<Course>().WithMany()
                        .HasForeignKey("CourseId")
                        .OnDelete(DeleteBehavior.ClientSetNull)
                        .HasConstraintName("FK__CoursePre__Cours__45F365D3"),
                    j =>
                    {
                        j.HasKey("CourseId", "Prereq").HasName("PK__CoursePr__F8693C2C9D86F3A1");
                        j.ToTable("CoursePrerequisite");
                        j.IndexerProperty<int>("CourseId").HasColumnName("CourseID");
                    });
        });

        modelBuilder.Entity<CourseEnrollment>(entity =>
        {
            entity.HasKey(e => e.EnrollmentId).HasName("PK__Course_e__7F6877FB36FDA216");

            entity.ToTable("Course_enrollment");

            entity.Property(e => e.EnrollmentId)
                .ValueGeneratedNever()
                .HasColumnName("EnrollmentID");
            entity.Property(e => e.CompletionDate).HasColumnName("completion_date");
            entity.Property(e => e.CourseId).HasColumnName("CourseID");
            entity.Property(e => e.EnrollmentDate).HasColumnName("enrollment_date");
            entity.Property(e => e.LearnerId).HasColumnName("LearnerID");
            entity.Property(e => e.Status)
                .HasMaxLength(50)
                .IsUnicode(false)
                .HasColumnName("status");

            entity.HasOne(d => d.Course).WithMany(p => p.CourseEnrollments)
                .HasForeignKey(d => d.CourseId)
                .HasConstraintName("FK__Course_en__Cours__73BA3083");

            entity.HasOne(d => d.Learner).WithMany(p => p.CourseEnrollments)
                .HasForeignKey(d => d.LearnerId)
                .HasConstraintName("FK__Course_en__Learn__74AE54BC");
        });

        modelBuilder.Entity<DiscussionForum>(entity =>
        {
            entity.HasKey(e => e.ForumId).HasName("PK__Discussi__BBA7A44014D32AAB");

            entity.ToTable("Discussion_forum");

            entity.Property(e => e.ForumId)
                .ValueGeneratedNever()
                .HasColumnName("forumID");
            entity.Property(e => e.CourseId).HasColumnName("CourseID");
            entity.Property(e => e.Description)
                .HasMaxLength(100)
                .IsUnicode(false)
                .HasColumnName("description");
            entity.Property(e => e.LastActive)
                .HasColumnType("datetime")
                .HasColumnName("last_active");
            entity.Property(e => e.ModuleId).HasColumnName("ModuleID");
            entity.Property(e => e.Timestamp)
                .HasColumnType("datetime")
                .HasColumnName("timestamp");
            entity.Property(e => e.Title)
                .HasMaxLength(100)
                .IsUnicode(false)
                .HasColumnName("title");

            entity.HasOne(d => d.Module).WithMany(p => p.DiscussionForums)
                .HasForeignKey(d => new { d.ModuleId, d.CourseId })
                .HasConstraintName("FK__Discussion_forum__2FCF1A8A");
        });

        modelBuilder.Entity<EmotionalFeedback>(entity =>
        {
            entity.HasKey(e => e.FeedbackId).HasName("PK__Emotiona__6A4BEDF6F04D6D17");

            entity.ToTable("Emotional_feedback");

            entity.Property(e => e.FeedbackId).HasColumnName("FeedbackID");
            entity.Property(e => e.ActivityId).HasColumnName("activityID");
            entity.Property(e => e.EmotionalState)
                .HasMaxLength(100)
                .IsUnicode(false)
                .HasColumnName("emotional_state");
            entity.Property(e => e.LearnerId).HasColumnName("LearnerID");
            entity.Property(e => e.Timestamp)
                .HasColumnType("datetime")
                .HasColumnName("timestamp");

            entity.HasOne(d => d.Activity).WithMany(p => p.EmotionalFeedbacks)
                .HasForeignKey(d => d.ActivityId)
                .HasConstraintName("FK__Emotional__activ__6477ECF3");

            entity.HasOne(d => d.Learner).WithMany(p => p.EmotionalFeedbacks)
                .HasForeignKey(d => d.LearnerId)
                .HasConstraintName("FK__Emotional__Learn__6383C8BA");
        });

        modelBuilder.Entity<EmotionalfeedbackReview>(entity =>
        {
            entity.HasKey(e => new { e.FeedbackId, e.InstructorId }).HasName("PK__Emotiona__C39BFD41C7EB9DED");

            entity.ToTable("Emotionalfeedback_review");

            entity.Property(e => e.FeedbackId)
                .ValueGeneratedOnAdd()
                .HasColumnName("FeedbackID");
            entity.Property(e => e.InstructorId).HasColumnName("InstructorID");
            entity.Property(e => e.Review)
                .HasMaxLength(100)
                .IsUnicode(false)
                .HasColumnName("review");

            entity.HasOne(d => d.Feedback).WithMany(p => p.EmotionalfeedbackReviews)
                .HasForeignKey(d => d.FeedbackId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Emotional__Feedb__6FE99F9F");

            entity.HasOne(d => d.Instructor).WithMany(p => p.EmotionalfeedbackReviews)
                .HasForeignKey(d => d.InstructorId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Emotional__Instr__70DDC3D8");
        });

        modelBuilder.Entity<FilledSurvey>(entity =>
        {
            entity.HasKey(e => new { e.SurveyId, e.Question, e.LearnerId }).HasName("PK__FilledSu__D89C33C776A95598");

            entity.ToTable("FilledSurvey");

            entity.Property(e => e.SurveyId).HasColumnName("SurveyID");
            entity.Property(e => e.Question)
                .HasMaxLength(255)
                .IsUnicode(false);
            entity.Property(e => e.LearnerId).HasColumnName("LearnerID");
            entity.Property(e => e.Answer)
                .HasMaxLength(100)
                .IsUnicode(false);

            entity.HasOne(d => d.Learner).WithMany(p => p.FilledSurveys)
                .HasForeignKey(d => d.LearnerId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__FilledSur__Learn__0D7A0286");

            entity.HasOne(d => d.SurveyQuestion).WithMany(p => p.FilledSurveys)
                .HasForeignKey(d => new { d.SurveyId, d.Question })
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__FilledSurvey__0C85DE4D");
        });

        modelBuilder.Entity<HealthCondition>(entity =>
        {
            entity.HasKey(e => new { e.LearnerId, e.ProfileId, e.Condition }).HasName("PK__HealthCo__930320B0516FE6FC");

            entity.ToTable("HealthCondition");

            entity.Property(e => e.LearnerId).HasColumnName("LearnerID");
            entity.Property(e => e.ProfileId).HasColumnName("ProfileID");
            entity.Property(e => e.Condition)
                .HasMaxLength(100)
                .IsUnicode(false)
                .HasColumnName("condition");

            entity.HasOne(d => d.PersonalizationProfile).WithMany(p => p.HealthConditions)
                .HasForeignKey(d => new { d.LearnerId, d.ProfileId })
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__HealthCondition__412EB0B6");
        });

        modelBuilder.Entity<Instructor>(entity =>
        {
            entity.HasKey(e => e.InstructorId).HasName("PK__Instruct__9D010B7B2E03FD7C");

            entity.ToTable("Instructor");

            entity.Property(e => e.InstructorId)
                .ValueGeneratedNever()
                .HasColumnName("InstructorID");
            entity.Property(e => e.Email)
                .HasMaxLength(100)
                .IsUnicode(false)
                .HasColumnName("email");
            entity.Property(e => e.ExpertiseArea)
                .HasMaxLength(100)
                .IsUnicode(false)
                .HasColumnName("expertise_area");
            entity.Property(e => e.FirstName)
                .HasMaxLength(100)
                .IsUnicode(false)
                .HasColumnName("first_name");
            entity.Property(e => e.LastName)
                .HasMaxLength(100)
                .IsUnicode(false)
                .HasColumnName("last_name");
            entity.Property(e => e.LatestQualification)
                .HasMaxLength(100)
                .IsUnicode(false)
                .HasColumnName("latest_qualification");

            entity.HasMany(d => d.Courses).WithMany(p => p.Instructors)
                .UsingEntity<Dictionary<string, object>>(
                    "Teach",
                    r => r.HasOne<Course>().WithMany()
                        .HasForeignKey("CourseId")
                        .OnDelete(DeleteBehavior.ClientSetNull)
                        .HasConstraintName("FK__Teaches__CourseI__787EE5A0"),
                    l => l.HasOne<Instructor>().WithMany()
                        .HasForeignKey("InstructorId")
                        .OnDelete(DeleteBehavior.ClientSetNull)
                        .HasConstraintName("FK__Teaches__Instruc__778AC167"),
                    j =>
                    {
                        j.HasKey("InstructorId", "CourseId").HasName("PK__Teaches__F193DC638A76C2CB");
                        j.ToTable("Teaches");
                        j.IndexerProperty<int>("InstructorId").HasColumnName("InstructorID");
                        j.IndexerProperty<int>("CourseId").HasColumnName("CourseID");
                    });
        });

        modelBuilder.Entity<InteractionLog>(entity =>
        {
            entity.HasKey(e => e.LogId).HasName("PK__Interact__5E5499A883EF2C07");

            entity.ToTable("Interaction_log");

            entity.Property(e => e.LogId)
                .ValueGeneratedNever()
                .HasColumnName("LogID");
            entity.Property(e => e.ActionType)
                .HasMaxLength(100)
                .IsUnicode(false)
                .HasColumnName("action_type");
            entity.Property(e => e.ActivityId).HasColumnName("activity_ID");
            entity.Property(e => e.LearnerId).HasColumnName("LearnerID");
            entity.Property(e => e.Timestamp).HasColumnType("datetime");

            entity.HasOne(d => d.Activity).WithMany(p => p.InteractionLogs)
                .HasForeignKey(d => d.ActivityId)
                .HasConstraintName("FK__Interacti__activ__5FB337D6");

            entity.HasOne(d => d.Learner).WithMany(p => p.InteractionLogs)
                .HasForeignKey(d => d.LearnerId)
                .HasConstraintName("FK__Interacti__Learn__60A75C0F");
        });

        modelBuilder.Entity<Leaderboard>(entity =>
        {
            entity.HasKey(e => e.BoardId).HasName("PK__Leaderbo__F9646BD2CC8EED54");

            entity.ToTable("Leaderboard");

            entity.Property(e => e.BoardId)
                .ValueGeneratedNever()
                .HasColumnName("BoardID");
            entity.Property(e => e.Season)
                .HasMaxLength(50)
                .IsUnicode(false)
                .HasColumnName("season");
        });

        modelBuilder.Entity<Learner>(entity =>
        {
            entity.HasKey(e => e.LearnerId).HasName("PK__Learner__67ABFCFA28E67203");

            entity.ToTable("Learner");

            entity.Property(e => e.LearnerId)
                .ValueGeneratedNever()
                .HasColumnName("LearnerID");
            entity.Property(e => e.BirthDate).HasColumnName("birth_date");
            entity.Property(e => e.Country)
                .HasMaxLength(100)
                .IsUnicode(false)
                .HasColumnName("country");
            entity.Property(e => e.CulturalBackground)
                .HasMaxLength(100)
                .IsUnicode(false)
                .HasColumnName("cultural_background");
            entity.Property(e => e.Email)
                .HasMaxLength(255)
                .HasColumnName("email");
            entity.Property(e => e.FirstName)
                .HasMaxLength(100)
                .IsUnicode(false)
                .HasColumnName("first_name");
            entity.Property(e => e.Gender)
                .HasMaxLength(10)
                .IsUnicode(false)
                .HasColumnName("gender");
            entity.Property(e => e.LastName)
                .HasMaxLength(100)
                .IsUnicode(false)
                .HasColumnName("last_name");
        });

        modelBuilder.Entity<LearnerDiscussion>(entity =>
        {
            entity.HasKey(e => new { e.ForumId, e.LearnerId }).HasName("PK__LearnerD__546A1380114EE66C");

            entity.ToTable("LearnerDiscussion");

            entity.Property(e => e.ForumId).HasColumnName("ForumID");
            entity.Property(e => e.LearnerId).HasColumnName("LearnerID");
            entity.Property(e => e.Post)
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.Time)
                .HasColumnType("datetime")
                .HasColumnName("time");

            entity.HasOne(d => d.Forum).WithMany(p => p.LearnerDiscussions)
                .HasForeignKey(d => d.ForumId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__LearnerDi__Forum__32AB8735");

            entity.HasOne(d => d.Learner).WithMany(p => p.LearnerDiscussions)
                .HasForeignKey(d => d.LearnerId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__LearnerDi__Learn__339FAB6E");
        });

        modelBuilder.Entity<LearnersCollaboration>(entity =>
        {
            entity.HasKey(e => new { e.LearnerId, e.QuestId }).HasName("PK__Learners__CCCDE55615A4992A");

            entity.ToTable("LearnersCollaboration");

            entity.Property(e => e.LearnerId).HasColumnName("LearnerID");
            entity.Property(e => e.QuestId).HasColumnName("QuestID");
            entity.Property(e => e.CompletionStatus)
                .HasMaxLength(50)
                .IsUnicode(false)
                .HasColumnName("completion_status");

            entity.HasOne(d => d.Learner).WithMany(p => p.LearnersCollaborations)
                .HasForeignKey(d => d.LearnerId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__LearnersC__Learn__282DF8C2");

            entity.HasOne(d => d.Quest).WithMany(p => p.LearnersCollaborations)
                .HasForeignKey(d => d.QuestId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__LearnersC__Quest__29221CFB");
        });

        modelBuilder.Entity<LearnersMastery>(entity =>
        {
            entity.HasKey(e => new { e.LearnerId, e.QuestId, e.Skill }).HasName("PK__Learners__0B5D1DA34373A76C");

            entity.ToTable("LearnersMastery");

            entity.Property(e => e.LearnerId).HasColumnName("LearnerID");
            entity.Property(e => e.QuestId).HasColumnName("QuestID");
            entity.Property(e => e.Skill)
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.CompletionStatus)
                .HasMaxLength(50)
                .IsUnicode(false)
                .HasColumnName("completion_status");

            entity.HasOne(d => d.Learner).WithMany(p => p.LearnersMasteries)
                .HasForeignKey(d => d.LearnerId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__LearnersM__Learn__2BFE89A6");

            entity.HasOne(d => d.SkillMastery).WithMany(p => p.LearnersMasteries)
                .HasForeignKey(d => new { d.QuestId, d.Skill })
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__LearnersMastery__2CF2ADDF");
        });

        modelBuilder.Entity<LearningActivity>(entity =>
        {
            entity.HasKey(e => e.ActivityId).HasName("PK__Learning__45F4A7F16C0A58D6");

            entity.ToTable("Learning_activities");

            entity.Property(e => e.ActivityId)
                .ValueGeneratedNever()
                .HasColumnName("ActivityID");
            entity.Property(e => e.ActivityType)
                .HasMaxLength(100)
                .IsUnicode(false)
                .HasColumnName("activity_type");
            entity.Property(e => e.CourseId).HasColumnName("CourseID");
            entity.Property(e => e.InstructionDetails)
                .HasMaxLength(100)
                .IsUnicode(false)
                .HasColumnName("instruction_details");
            entity.Property(e => e.MaxPoints).HasColumnName("Max_points");
            entity.Property(e => e.ModuleId).HasColumnName("ModuleID");

            entity.HasOne(d => d.Course).WithMany(p => p.LearningActivities)
                .HasForeignKey(d => d.CourseId)
                .HasConstraintName("FK__Learning___Cours__5CD6CB2B");

            entity.HasOne(d => d.Module).WithMany(p => p.LearningActivities)
                .HasForeignKey(d => new { d.ModuleId, d.CourseId })
                .HasConstraintName("FK__Learning_activit__5BE2A6F2");
        });

        modelBuilder.Entity<LearningGoal>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Learning__3214EC2785F68A9B");

            entity.ToTable("Learning_goal");

            entity.Property(e => e.Id)
                .ValueGeneratedNever()
                .HasColumnName("ID");
            entity.Property(e => e.Deadline).HasColumnName("deadline");
            entity.Property(e => e.Description)
                .HasMaxLength(100)
                .IsUnicode(false)
                .HasColumnName("description");
            entity.Property(e => e.Status)
                .HasMaxLength(50)
                .IsUnicode(false)
                .HasColumnName("status");

            entity.HasMany(d => d.Learners).WithMany(p => p.Goals)
                .UsingEntity<Dictionary<string, object>>(
                    "LearnersGoal",
                    r => r.HasOne<Learner>().WithMany()
                        .HasForeignKey("LearnerId")
                        .OnDelete(DeleteBehavior.ClientSetNull)
                        .HasConstraintName("FK__LearnersG__Learn__04E4BC85"),
                    l => l.HasOne<LearningGoal>().WithMany()
                        .HasForeignKey("GoalId")
                        .OnDelete(DeleteBehavior.ClientSetNull)
                        .HasConstraintName("FK__LearnersG__GoalI__03F0984C"),
                    j =>
                    {
                        j.HasKey("GoalId", "LearnerId").HasName("PK__Learners__3C3540FEA3EDB645");
                        j.ToTable("LearnersGoals");
                        j.IndexerProperty<int>("GoalId").HasColumnName("GoalID");
                        j.IndexerProperty<int>("LearnerId").HasColumnName("LearnerID");
                    });
        });

        modelBuilder.Entity<LearningPath>(entity =>
        {
            entity.HasKey(e => e.PathId).HasName("PK__Learning__BFB8200A071EFDC1");

            entity.ToTable("Learning_path");

            entity.Property(e => e.PathId)
                .ValueGeneratedNever()
                .HasColumnName("pathID");
            entity.Property(e => e.AdaptiveRules)
                .HasMaxLength(100)
                .IsUnicode(false)
                .HasColumnName("adaptive_rules");
            entity.Property(e => e.CompletionStatus)
                .HasMaxLength(50)
                .IsUnicode(false)
                .HasColumnName("completion_status");
            entity.Property(e => e.CustomContent)
                .HasMaxLength(100)
                .IsUnicode(false)
                .HasColumnName("custom_content");
            entity.Property(e => e.LearnerId).HasColumnName("LearnerID");
            entity.Property(e => e.ProfileId).HasColumnName("ProfileID");

            entity.HasOne(d => d.PersonalizationProfile).WithMany(p => p.LearningPaths)
                .HasForeignKey(d => new { d.LearnerId, d.ProfileId })
                .HasConstraintName("FK__Learning_path__6754599E");
        });

        modelBuilder.Entity<LearningPreference>(entity =>
        {
            entity.HasKey(e => new { e.LearnerId, e.Preference }).HasName("PK__Learning__6032E15872F46925");

            entity.ToTable("LearningPreference");

            entity.Property(e => e.LearnerId).HasColumnName("LearnerID");
            entity.Property(e => e.Preference)
                .HasMaxLength(100)
                .IsUnicode(false)
                .HasColumnName("preference");

            entity.HasOne(d => d.Learner).WithMany(p => p.LearningPreferences)
                .HasForeignKey(d => d.LearnerId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__LearningP__Learn__3B75D760");
        });

        modelBuilder.Entity<Module>(entity =>
        {
            entity.HasKey(e => new { e.ModuleId, e.CourseId }).HasName("PK__Modules__47E6A09FFD561A9C");

            entity.Property(e => e.ModuleId).HasColumnName("ModuleID");
            entity.Property(e => e.CourseId).HasColumnName("CourseID");
            entity.Property(e => e.ContentUrl)
                .HasMaxLength(255)
                .IsUnicode(false)
                .HasColumnName("contentURL");
            entity.Property(e => e.Difficulty)
                .HasMaxLength(50)
                .IsUnicode(false)
                .HasColumnName("difficulty");
            entity.Property(e => e.Title)
                .HasMaxLength(100)
                .IsUnicode(false);

            entity.HasOne(d => d.Course).WithMany(p => p.Modules)
                .HasForeignKey(d => d.CourseId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Modules__CourseI__49C3F6B7");
        });

        modelBuilder.Entity<ModuleContent>(entity =>
        {
            entity.HasKey(e => new { e.ModuleId, e.CourseId, e.ContentType }).HasName("PK__ModuleCo__402E75DA84B97668");

            entity.ToTable("ModuleContent");

            entity.Property(e => e.ModuleId).HasColumnName("ModuleID");
            entity.Property(e => e.CourseId).HasColumnName("CourseID");
            entity.Property(e => e.ContentType)
                .HasMaxLength(100)
                .IsUnicode(false)
                .HasColumnName("content_type");

            entity.HasOne(d => d.Module).WithMany(p => p.ModuleContents)
                .HasForeignKey(d => new { d.ModuleId, d.CourseId })
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__ModuleContent__4F7CD00D");
        });

        modelBuilder.Entity<Notification>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Notifica__3214EC27264D4232");

            entity.ToTable("Notification");

            entity.Property(e => e.Id)
                .ValueGeneratedNever()
                .HasColumnName("ID");
            entity.Property(e => e.Message)
                .HasMaxLength(100)
                .IsUnicode(false)
                .HasColumnName("message");
            entity.Property(e => e.Timestamp)
                .HasColumnType("datetime")
                .HasColumnName("timestamp");
            entity.Property(e => e.UrgencyLevel)
                .HasMaxLength(50)
                .IsUnicode(false)
                .HasColumnName("urgency_level");

            entity.HasMany(d => d.Learners).WithMany(p => p.Notifications)
                .UsingEntity<Dictionary<string, object>>(
                    "ReceivedNotification",
                    r => r.HasOne<Learner>().WithMany()
                        .HasForeignKey("LearnerId")
                        .OnDelete(DeleteBehavior.ClientSetNull)
                        .HasConstraintName("FK__ReceivedN__Learn__1332DBDC"),
                    l => l.HasOne<Notification>().WithMany()
                        .HasForeignKey("NotificationId")
                        .OnDelete(DeleteBehavior.ClientSetNull)
                        .HasConstraintName("FK__ReceivedN__Notif__123EB7A3"),
                    j =>
                    {
                        j.HasKey("NotificationId", "LearnerId").HasName("PK__Received__96B591FDE2C35FB0");
                        j.ToTable("ReceivedNotification");
                        j.IndexerProperty<int>("NotificationId").HasColumnName("NotificationID");
                        j.IndexerProperty<int>("LearnerId").HasColumnName("LearnerID");
                    });
        });

        modelBuilder.Entity<Pathreview>(entity =>
        {
            entity.HasKey(e => new { e.InstructorId, e.PathId }).HasName("PK__Pathrevi__11D776B8AE80069A");

            entity.ToTable("Pathreview");

            entity.Property(e => e.InstructorId).HasColumnName("InstructorID");
            entity.Property(e => e.PathId).HasColumnName("PathID");
            entity.Property(e => e.Review)
                .HasMaxLength(100)
                .IsUnicode(false)
                .HasColumnName("review");

            entity.HasOne(d => d.Instructor).WithMany(p => p.Pathreviews)
                .HasForeignKey(d => d.InstructorId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Pathrevie__Instr__6C190EBB");

            entity.HasOne(d => d.Path).WithMany(p => p.Pathreviews)
                .HasForeignKey(d => d.PathId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Pathrevie__PathI__6D0D32F4");
        });

        modelBuilder.Entity<PersonalizationProfile>(entity =>
        {
            entity.HasKey(e => new { e.LearnerId, e.ProfileId }).HasName("PK__Personal__353B3472138905FB");

            entity.Property(e => e.LearnerId).HasColumnName("LearnerID");
            entity.Property(e => e.ProfileId).HasColumnName("ProfileID");
            entity.Property(e => e.EmotionalState)
                .HasMaxLength(100)
                .IsUnicode(false)
                .HasColumnName("emotional_state");
            entity.Property(e => e.PersonalityType)
                .HasMaxLength(100)
                .IsUnicode(false)
                .HasColumnName("personality_type");
            entity.Property(e => e.PreferedContentType)
                .HasMaxLength(100)
                .IsUnicode(false)
                .HasColumnName("Prefered_content_type");

            entity.HasOne(d => d.Learner).WithMany(p => p.PersonalizationProfiles)
                .HasForeignKey(d => d.LearnerId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Personali__Learn__3E52440B");
        });

        modelBuilder.Entity<Quest>(entity =>
        {
            entity.HasKey(e => e.QuestId).HasName("PK__Quest__B6619ACB577D0D6E");

            entity.ToTable("Quest");

            entity.Property(e => e.QuestId)
                .ValueGeneratedNever()
                .HasColumnName("QuestID");
            entity.Property(e => e.Criteria)
                .HasMaxLength(50)
                .IsUnicode(false)
                .HasColumnName("criteria");
            entity.Property(e => e.Description)
                .HasMaxLength(100)
                .IsUnicode(false)
                .HasColumnName("description");
            entity.Property(e => e.DifficultyLevel)
                .HasMaxLength(50)
                .IsUnicode(false)
                .HasColumnName("difficulty_level");
            entity.Property(e => e.Title)
                .HasMaxLength(100)
                .IsUnicode(false)
                .HasColumnName("title");
        });

        modelBuilder.Entity<QuestReward>(entity =>
        {
            entity.HasKey(e => new { e.RewardId, e.QuestId, e.LearnerId }).HasName("PK__QuestRew__D251A7C9FFB4F92C");

            entity.ToTable("QuestReward");

            entity.Property(e => e.RewardId).HasColumnName("RewardID");
            entity.Property(e => e.QuestId).HasColumnName("QuestID");
            entity.Property(e => e.LearnerId).HasColumnName("LearnerID");
            entity.Property(e => e.TimeEarned)
                .HasColumnType("datetime")
                .HasColumnName("Time_earned");

            entity.HasOne(d => d.Learner).WithMany(p => p.QuestRewards)
                .HasForeignKey(d => d.LearnerId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__QuestRewa__Learn__3864608B");

            entity.HasOne(d => d.Quest).WithMany(p => p.QuestRewards)
                .HasForeignKey(d => d.QuestId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__QuestRewa__Quest__37703C52");

            entity.HasOne(d => d.Reward).WithMany(p => p.QuestRewards)
                .HasForeignKey(d => d.RewardId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__QuestRewa__Rewar__367C1819");
        });

        modelBuilder.Entity<Ranking>(entity =>
        {
            entity.HasKey(e => new { e.BoardId, e.LearnerId, e.CourseId }).HasName("PK__Ranking__C9D7F96C18ABFC36");

            entity.ToTable("Ranking");

            entity.Property(e => e.BoardId).HasColumnName("BoardID");
            entity.Property(e => e.LearnerId).HasColumnName("LearnerID");
            entity.Property(e => e.CourseId).HasColumnName("CourseID");
            entity.Property(e => e.Rank).HasColumnName("rank");
            entity.Property(e => e.TotalPoints).HasColumnName("total_points");

            entity.HasOne(d => d.Board).WithMany(p => p.Rankings)
                .HasForeignKey(d => d.BoardId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Ranking__BoardID__7D439ABD");

            entity.HasOne(d => d.Course).WithMany(p => p.Rankings)
                .HasForeignKey(d => d.CourseId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Ranking__CourseI__7F2BE32F");

            entity.HasOne(d => d.Learner).WithMany(p => p.Rankings)
                .HasForeignKey(d => d.LearnerId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Ranking__Learner__7E37BEF6");
        });

        modelBuilder.Entity<Reward>(entity =>
        {
            entity.HasKey(e => e.RewardId).HasName("PK__Reward__8250159980721E69");

            entity.ToTable("Reward");

            entity.Property(e => e.RewardId)
                .ValueGeneratedNever()
                .HasColumnName("RewardID");
            entity.Property(e => e.Description)
                .HasMaxLength(100)
                .IsUnicode(false)
                .HasColumnName("description");
            entity.Property(e => e.Type)
                .HasMaxLength(50)
                .IsUnicode(false)
                .HasColumnName("type");
            entity.Property(e => e.Value).HasColumnName("value");
        });

        modelBuilder.Entity<Skill>(entity =>
        {
            entity.HasKey(e => new { e.LearnerId, e.Skill1 }).HasName("PK__Skills__C45BDEA5F1CA2318");

            entity.Property(e => e.LearnerId).HasColumnName("LearnerID");
            entity.Property(e => e.Skill1)
                .HasMaxLength(100)
                .IsUnicode(false)
                .HasColumnName("skill");

            entity.HasOne(d => d.Learner).WithMany(p => p.Skills)
                .HasForeignKey(d => d.LearnerId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Skills__LearnerI__38996AB5");
        });

        modelBuilder.Entity<SkillMastery>(entity =>
        {
            entity.HasKey(e => new { e.QuestId, e.Skill }).HasName("PK__Skill_Ma__1591B894FF8273EE");

            entity.ToTable("Skill_Mastery");

            entity.Property(e => e.QuestId).HasColumnName("QuestID");
            entity.Property(e => e.Skill)
                .HasMaxLength(100)
                .IsUnicode(false)
                .HasColumnName("skill");

            entity.HasOne(d => d.Quest).WithMany(p => p.SkillMasteries)
                .HasForeignKey(d => d.QuestId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Skill_Mas__Quest__22751F6C");
        });

        modelBuilder.Entity<SkillProgression>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__SkillPro__3214EC27BACD3D7E");

            entity.ToTable("SkillProgression");

            entity.Property(e => e.Id)
                .ValueGeneratedNever()
                .HasColumnName("ID");
            entity.Property(e => e.LearnerId).HasColumnName("LearnerID");
            entity.Property(e => e.ProficiencyLevel)
                .HasMaxLength(50)
                .IsUnicode(false)
                .HasColumnName("proficiency_level");
            entity.Property(e => e.SkillName)
                .HasMaxLength(100)
                .IsUnicode(false)
                .HasColumnName("skill_name");
            entity.Property(e => e.Timestamp)
                .HasColumnType("datetime")
                .HasColumnName("timestamp");

            entity.HasOne(d => d.Skill).WithMany(p => p.SkillProgressions)
                .HasForeignKey(d => new { d.LearnerId, d.SkillName })
                .HasConstraintName("FK__SkillProgression__17F790F9");
        });

        modelBuilder.Entity<Survey>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Survey__3214EC277F817BD5");

            entity.ToTable("Survey");

            entity.Property(e => e.Id)
                .ValueGeneratedNever()
                .HasColumnName("ID");
            entity.Property(e => e.Title)
                .HasMaxLength(100)
                .IsUnicode(false);
        });

        modelBuilder.Entity<SurveyQuestion>(entity =>
        {
            entity.HasKey(e => new { e.SurveyId, e.Question }).HasName("PK__SurveyQu__23FB983B95E48A4F");

            entity.Property(e => e.SurveyId).HasColumnName("SurveyID");
            entity.Property(e => e.Question)
                .HasMaxLength(255)
                .IsUnicode(false);

            entity.HasOne(d => d.Survey).WithMany(p => p.SurveyQuestions)
                .HasForeignKey(d => d.SurveyId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__SurveyQue__Surve__09A971A2");
        });

        modelBuilder.Entity<Takenassessment>(entity =>
        {
            entity.HasKey(e => new { e.AssessmentId, e.LearnerId }).HasName("PK__Takenass__8B5147F15C31F2A2");

            entity.ToTable("Takenassessment");

            entity.Property(e => e.AssessmentId).HasColumnName("AssessmentID");
            entity.Property(e => e.LearnerId).HasColumnName("LearnerID");
            entity.Property(e => e.ScoredPoint).HasColumnName("scoredPoint");

            entity.HasOne(d => d.Assessment).WithMany(p => p.Takenassessments)
                .HasForeignKey(d => d.AssessmentId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Takenasse__Asses__59063A47");

            entity.HasOne(d => d.Learner).WithMany(p => p.Takenassessments)
                .HasForeignKey(d => d.LearnerId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Takenasse__Learn__5812160E");
        });

        modelBuilder.Entity<TargetTrait>(entity =>
        {
            entity.HasKey(e => new { e.ModuleId, e.CourseId, e.Trait }).HasName("PK__Target_t__4E005E4C2FEE4EBC");

            entity.ToTable("Target_traits");

            entity.Property(e => e.ModuleId).HasColumnName("ModuleID");
            entity.Property(e => e.CourseId).HasColumnName("CourseID");
            entity.Property(e => e.Trait)
                .HasMaxLength(100)
                .IsUnicode(false);

            entity.HasOne(d => d.Module).WithMany(p => p.TargetTraits)
                .HasForeignKey(d => new { d.ModuleId, d.CourseId })
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Target_traits__4CA06362");
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}

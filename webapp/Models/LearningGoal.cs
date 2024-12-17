using System;
using System.Collections.Generic;

namespace webapp.Models;

public partial class LearningGoal
{
    public int Id { get; set; }

    public string? Status { get; set; }

    public DateOnly? Deadline { get; set; }

    public string? Description { get; set; }

    public virtual ICollection<Learner> Learners { get; set; } = new List<Learner>();
}

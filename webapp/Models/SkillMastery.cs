using System;
using System.Collections.Generic;

namespace webapp.Models;

public partial class SkillMastery
{
    public int QuestId { get; set; }

    public string Skill { get; set; } = null!;

    public virtual ICollection<LearnersMastery> LearnersMasteries { get; set; } = new List<LearnersMastery>();

    public virtual Quest Quest { get; set; } = null!;
}

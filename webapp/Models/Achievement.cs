﻿using System;
using System.Collections.Generic;

namespace webapp.Models;

public partial class Achievement
{
    public int AchievementId { get; set; }

    public int? LearnerId { get; set; }

    public int? BadgeId { get; set; }

    public string? Description { get; set; }

    public DateOnly? DateEarned { get; set; }

    public string? Type { get; set; }

    public virtual Badge? Badge { get; set; }

    public virtual Learner? Learner { get; set; }
}

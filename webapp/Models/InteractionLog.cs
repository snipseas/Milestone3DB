﻿using System;
using System.Collections.Generic;

namespace webapp.Models;

public partial class InteractionLog
{
    public int LogId { get; set; }

    public int? ActivityId { get; set; }

    public int? LearnerId { get; set; }

    public int? Duration { get; set; }

    public DateTime? Timestamp { get; set; }

    public string? ActionType { get; set; }

    public virtual LearningActivity? Activity { get; set; }

    public virtual Learner? Learner { get; set; }
}

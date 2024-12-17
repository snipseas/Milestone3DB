using System;
using System.Collections.Generic;

namespace webapp.Models;

public partial class Admin
{
    public int AdminId { get; set; }

    public string FirstName { get; set; } = null!;

    public string LastName { get; set; } = null!;

    public string? Gender { get; set; }

    public DateOnly? BirthDate { get; set; }

    public string? Country { get; set; }

    public string Email { get; set; } = null!;

    public string PasswordHash { get; set; } = null!;

    public string? Role { get; set; }

    public string FullName { get; set; } = null!;
}

using BCrypt.Net;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

using System.Threading.Tasks;
using webapp.Models;

public class AccountController : Controller
{
    private readonly DBprojecContext _context;

    public AccountController(DBprojecContext context)
    {
        _context = context;
    }
    [HttpGet]
    public IActionResult Register()
    {
        return View();
    }

    [HttpPost]

    [HttpPost]
    public async Task<IActionResult> Register(string email, string firstName, string lastName, string password, string role)
    {
        // Validate inputs (make sure they are not empty)
        if (string.IsNullOrEmpty(email) || string.IsNullOrEmpty(firstName) || string.IsNullOrEmpty(lastName) || string.IsNullOrEmpty(password) || string.IsNullOrEmpty(role))
        {
            ViewData["Error"] = "All fields are required.";
            return View();
        }

        // Check if email is already taken in the appropriate table for that role
        bool emailExists = false;
        if (role == "Admin")
        {
            emailExists = await _context.Admins.AnyAsync(a => a.Email == email);
        }
        else if (role == "Learner")
        {
            emailExists = await _context.Learners.AnyAsync(l => l.Email == email);
        }
        else if (role == "Instructor")
        {
            emailExists = await _context.Instructors.AnyAsync(i => i.Email == email);
        }

        if (emailExists)
        {
            ViewData["Error"] = "Email is already taken.";
            return View();
        }

        // Hash the password (using BCrypt)
        string passwordHash = BCrypt.Net.BCrypt.HashPassword(password);

        // Based on the role, create the appropriate entity (Admin, Learner, or Instructor)
        if (role == "Admin")
        {
            var admin = new Admin
            {
                Email = email,
                FirstName = firstName,
                LastName = lastName,
                PasswordHash = passwordHash
            };

            _context.Admins.Add(admin);
            await _context.SaveChangesAsync();

            // After creation, redirect to a profile page for Admin
            return RedirectToAction("Profile", "Admin", new { email = email });
        }
        else if (role == "Learner")
        {
            var learner = new Learner
            {
                Email = email,
                FirstName = firstName,
                LastName = lastName,
                PasswordHash = passwordHash
            };

            _context.Learners.Add(learner);
            await _context.SaveChangesAsync();

            // Redirect to learner's profile
            return RedirectToAction("Profile", "Learner", new { email = email });
        }
        else if (role == "Instructor")
        {
            var instructor = new Instructor
            {
                Email = email,
                FirstName = firstName,
                LastName = lastName,
                PasswordHash = passwordHash
            };

            _context.Instructors.Add(instructor);
            await _context.SaveChangesAsync();

            // Redirect to instructor's profile
            return RedirectToAction("Profile", "Instructor", new { email = email });
        }

        // If something goes wrong or role not recognized:
        ViewData["Error"] = "Invalid role selected.";
        return View();
    }

    [HttpGet]
    public async Task<IActionResult> Profile(string email, string role)
    {
        if (role == "Admin")
        {
            var admin = await _context.Admins.FirstOrDefaultAsync(a => a.Email == email);
            return View(admin);
        }
        else if (role == "Learner")
        {
            var learner = await _context.Learners.FirstOrDefaultAsync(l => l.Email == email);
            return View(learner);
        }
        else if (role == "Instructor")
        {
            var instructor = await _context.Instructors.FirstOrDefaultAsync(i => i.Email == email);
            return View(instructor);
        }

        return NotFound();
    }

    [HttpPost]
    public async Task<IActionResult> UpdateProfile(string email, string firstName, string lastName, IFormFile profilePicture, string role)
    {
        if (role == "Admin")
        {
            var admin = await _context.Admins.FirstOrDefaultAsync(a => a.Email == email);
            if (admin != null)
            {
                admin.FirstName = firstName;
                admin.LastName = lastName;

                // Handle profile picture upload
                if (profilePicture != null)
                {
                    // Save the profile picture and update the path in the database
                    // Example: admin.ProfilePicture = SaveProfilePicture(profilePicture);
                }

                await _context.SaveChangesAsync();
                return RedirectToAction("Profile", new { email = email, role = role });
            }
        }
        else if (role == "Learner")
        {
            var learner = await _context.Learners.FirstOrDefaultAsync(l => l.Email == email);
            if (learner != null)
            {
                learner.FirstName = firstName;
                learner.LastName = lastName;

                // Handle profile picture upload
                if (profilePicture != null)
                {
                    // Save the profile picture and update the path in the database
                    // Example: learner.ProfilePicture = SaveProfilePicture(profilePicture);
                }

                await _context.SaveChangesAsync();
                return RedirectToAction("Profile", new { email = email, role = role });
            }
        }
        else if (role == "Instructor")
        {
            var instructor = await _context.Instructors.FirstOrDefaultAsync(i => i.Email == email);
            if (instructor != null)
            {
                instructor.FirstName = firstName;
                instructor.LastName = lastName;

                // Handle profile picture upload
                if (profilePicture != null)
                {
                    // Save the profile picture and update the path in the database
                    // Example: instructor.ProfilePicture = SaveProfilePicture(profilePicture);
                }

                await _context.SaveChangesAsync();
                return RedirectToAction("Profile", new { email = email, role = role });
            }
        }

        return NotFound();
    }

    [HttpGet]
    public IActionResult Login()
    {
        return View();
    }

    [HttpPost]

    [HttpPost]
    public async Task<IActionResult> Login(string email, string password, string role)
    {
        if (string.IsNullOrEmpty(email) || string.IsNullOrEmpty(password) || string.IsNullOrEmpty(role))
        {
            ViewData["Error"] = "All fields are required.";
            return View();
        }

        try
        {
            switch (role)
            {
                case "Admin":
                    var admin = await _context.Admins.FirstOrDefaultAsync(a => a.Email == email);
                    if (admin != null && BCrypt.Net.BCrypt.Verify(password, admin.PasswordHash))
                    {
                        HttpContext.Session.SetString("User  Role", "Admin");
                        HttpContext.Session.SetString("User  Email", email);
                        return RedirectToAction("Profile", "Admin", new { email = email, role = role });
                    }
                    break;

                case "Learner":
                    var learner = await _context.Learners.FirstOrDefaultAsync(l => l.Email == email);
                    if (learner != null && BCrypt.Net.BCrypt.Verify(password, learner.PasswordHash))
                    {
                        HttpContext.Session.SetString("User  Role", "Learner");
                        HttpContext.Session.SetString("User  Email", email);
                        return RedirectToAction("Profile", "Learner", new { email = email, role = role });
                    }
                    break;

                case "Instructor":
                    var instructor = await _context.Instructors.FirstOrDefaultAsync(i => i.Email == email);
                    if (instructor != null && BCrypt.Net.BCrypt.Verify(password, instructor.PasswordHash))
                    {
                        HttpContext.Session.SetString("User  Role", "Instructor");
                        HttpContext.Session.SetString("User  Email", email);
                        return RedirectToAction("Profile", "Instructor", new { email = email, role = role });
                    }
                    break;

                default:
                    ViewData["Error"] = "Invalid role selected.";
                    return View();
            }
        }
        catch (SaltParseException ex)
        {
            // Log the exception (optional)
            ViewData["Error"] = "An error occurred while verifying the password. Please try again.";
            return View();
        }

        // If authentication fails
        ViewData["Error"] = "Invalid email or password.";
        return View();
    }
}

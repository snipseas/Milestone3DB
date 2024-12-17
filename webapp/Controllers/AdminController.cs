using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using webapp.Models;

namespace webapp.Controllers
{
    public class AdminController : Controller
    {
        private readonly DBprojecContext _context;

        [HttpPost]
        public async Task<IActionResult> RemoveInstructor(int instructorId)
        {
            var instructor = await _context.Instructors.FindAsync(instructorId);
            if (instructor != null)
            {
                _context.Instructors.Remove(instructor);
                await _context.SaveChangesAsync();
                ViewData["Message"] = "Instructor account removed successfully.";
            }
            else
            {
                ViewData["Error"] = "Instructor not found.";
            }

            // Redirect to the instructor management page
            return RedirectToAction("ManageInstructors");
        }

        [HttpPost]
        public async Task<IActionResult> RemoveLearner(int learnerId)
        {
            var learner = await _context.Learners.FindAsync(learnerId);
            if (learner != null)
            {
                _context.Learners.Remove(learner);
                await _context.SaveChangesAsync();
                ViewData["Message"] = "Learner account removed successfully.";
            }
            else
            {
                ViewData["Error"] = "Learner not found.";
            }

            // Redirect to the learner management page
            return RedirectToAction("ManageLearners");
        }

        public AdminController(DBprojecContext context)
        {
            _context = context;
        }
        [HttpGet]
        public async Task<IActionResult> RemovePersonalizationProfile(int learnerId, int profileId)
        {
            var profile = await _context.PersonalizationProfiles
                                       .FindAsync(learnerId, profileId);
            if (profile != null)
            {
                _context.PersonalizationProfiles.Remove(profile);
                await _context.SaveChangesAsync();
                ViewData["Message"] = "Personalization profile removed successfully.";
            }
            else
            {
                ViewData["Error"] = "Profile not found.";
            }

            // Return to the learner's profile page or admin page
            return RedirectToAction("Profile", "Learner", new { id = learnerId });
        }

        [HttpGet]
        public async Task<IActionResult> ManageInstructors()
        {
            var instructors = await _context.Instructors.ToListAsync();
            return View(instructors); // Create a corresponding view to display the list
        }
        [HttpGet]
        public async Task<IActionResult> ManageLearners()
        {
            var learners = await _context.Learners.ToListAsync();
            return View(learners); // Create a corresponding view to display the list
        }
    }
}

package com.StudentEnrollSystem.servlets;

import com.StudentEnrollSystem.model.Course;
import com.StudentEnrollSystem.services.CourseService;
import com.google.gson.Gson;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * Servlet to handle course-related operations
 */
@WebServlet("/CourseServlet")
public class CourseServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private CourseService courseService;
    private Gson gson;
    
    @Override
    public void init() throws ServletException {
        super.init();
        // Initialize the course service with the path to courses.txt
        String coursesFilePath = ("C:\\Users\\user\\Downloads\\uthtara\\StudentEnrollSystem\\src\\main\\webapp\\WEB-INF\\lib\\data\\courses.txt");
        courseService = new CourseService(coursesFilePath);
        gson = new Gson();
    }
    
    /**
     * Handle GET requests for course data
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "list"; // Default action
        }
        
        switch (action) {
            case "list":
                listCourses(request, response);
                break;
            case "get":
                getCourseByCode(request, response);
                break;
            case "json":
                exportCoursesAsJson(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Unknown action: " + action);
        }
    }
    
    /**
     * Handle POST requests for course operations
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if (action == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Action is required");
            return;
        }
        
        switch (action) {
            case "add":
                addCourse(request, response);
                break;
            case "update":
                updateCourse(request, response);
                break;
            case "delete":
                deleteCourse(request, response);
                break;
            case "import":
                importCoursesFromJson(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Unknown action: " + action);
        }
    }
    
    /**
     * Lists all courses and forwards to the courses page
     */
    private void listCourses(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        List<Course> courses = courseService.getAllCourses();
        request.setAttribute("courses", courses);
        request.setAttribute("courseCount", courses.size());
        
        // Forward to the courses JSP page
        request.getRequestDispatcher("/teacherDashboard.jsp?tab=courses").forward(request, response);
    }
    
    /**
     * Gets a specific course by its code
     */
    private void getCourseByCode(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String courseCode = request.getParameter("courseCode");
        if (courseCode == null || courseCode.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Course code is required");
            return;
        }
        
        courseService.getCourseByCode(courseCode)
            .ifPresentOrElse(
                course -> {
                    try {
                        request.setAttribute("course", course);
                        request.getRequestDispatcher("/courseDetails.jsp").forward(request, response);
                    } catch (ServletException | IOException e) {
                        e.printStackTrace();
                    }
                },
                () -> {
                    try {
                        response.sendError(HttpServletResponse.SC_NOT_FOUND, "Course not found: " + courseCode);
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }
            );
    }
    
    /**
     * Adds a new course from form data
     */
    private void addCourse(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Get parameters from the form
        String courseCode = request.getParameter("courseCode");
        String title = request.getParameter("courseTitle");
        String description = request.getParameter("courseDescription");
        String day = request.getParameter("courseDay");
        String time = request.getParameter("courseTime");
        
        // Validate required parameters
        if (courseCode == null || courseCode.trim().isEmpty() || 
            title == null || title.trim().isEmpty() ||
            day == null || day.trim().isEmpty() ||
            time == null || time.trim().isEmpty()) {
            
            request.setAttribute("errorMessage", "All required fields must be completed");
            request.getRequestDispatcher("/teacherDashboard.jsp?tab=courses").forward(request, response);
            return;
        }
        
        // Create a new Course object
        Course newCourse = new Course();
        newCourse.setCourseCode(courseCode.trim());
        newCourse.setTitle(title.trim());
        newCourse.setDescription(description != null ? description.trim() : "");
        newCourse.setDay(day.trim());
        newCourse.setTime(time.trim());
        newCourse.setEnrolledStudents(0);
        newCourse.setSessionsCount(0);
        
        // Try to add the course
        boolean success = courseService.addCourse(newCourse);
        
        if (success) {
            request.setAttribute("successMessage", "Course " + courseCode + " added successfully");
            response.sendRedirect(request.getContextPath() + "/teacherDashboard.jsp?tab=courses");
        } else {
            request.setAttribute("errorMessage", 
                "Failed to add course. A course with code " + courseCode + " may already exist.");
            request.getRequestDispatcher("/teacherDashboard.jsp?tab=courses").forward(request, response);
        }
    }
    
    /**
     * Updates an existing course
     */
    private void updateCourse(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Get parameters from the form
        String courseCode = request.getParameter("courseCode");
        String title = request.getParameter("courseTitle");
        String description = request.getParameter("courseDescription");
        String day = request.getParameter("courseDay");
        String time = request.getParameter("courseTime");
        String enrolledStudentsStr = request.getParameter("enrolledStudents");
        String sessionsCountStr = request.getParameter("sessionsCount");
        
        // Validate required parameters
        if (courseCode == null || courseCode.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Course code is required");
            return;
        }
        
        // Check if the course exists
        var existingCourseOpt = courseService.getCourseByCode(courseCode);
        if (existingCourseOpt.isEmpty()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Course not found: " + courseCode);
            return;
        }
        
        Course existingCourse = existingCourseOpt.get();
        
        // Update only provided fields
        if (title != null && !title.trim().isEmpty()) {
            existingCourse.setTitle(title.trim());
        }
        
        if (description != null) {
            existingCourse.setDescription(description.trim());
        }
        
        if (day != null && !day.trim().isEmpty()) {
            existingCourse.setDay(day.trim());
        }
        
        if (time != null && !time.trim().isEmpty()) {
            existingCourse.setTime(time.trim());
        }
        
        if (enrolledStudentsStr != null && !enrolledStudentsStr.trim().isEmpty()) {
            try {
                existingCourse.setEnrolledStudents(Integer.parseInt(enrolledStudentsStr.trim()));
            } catch (NumberFormatException e) {
                // Keep the existing value
            }
        }
        
        if (sessionsCountStr != null && !sessionsCountStr.trim().isEmpty()) {
            try {
                existingCourse.setSessionsCount(Integer.parseInt(sessionsCountStr.trim()));
            } catch (NumberFormatException e) {
                // Keep the existing value
            }
        }
        
        // Save the updated course
        boolean success = courseService.updateCourse(existingCourse);
        
        if (success) {
            request.setAttribute("successMessage", "Course " + courseCode + " updated successfully");
            response.sendRedirect(request.getContextPath() + "/teacherDashboard.jsp?tab=courses");
        } else {
            request.setAttribute("errorMessage", "Failed to update course: " + courseCode);
            request.getRequestDispatcher("/teacherDashboard.jsp?tab=courses").forward(request, response);
        }
    }
    
    /**
     * Deletes a course
     */
    private void deleteCourse(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String courseCode = request.getParameter("courseCode");
        
        if (courseCode == null || courseCode.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Course code is required");
            return;
        }
        
        boolean success = courseService.deleteCourse(courseCode);
        
        if (success) {
            request.setAttribute("successMessage", "Course " + courseCode + " deleted successfully");
            response.sendRedirect(request.getContextPath() + "/teacherDashboard.jsp?tab=courses");
        } else {
            request.setAttribute("errorMessage", "Failed to delete course: " + courseCode);
            request.getRequestDispatcher("/teacherDashboard.jsp?tab=courses").forward(request, response);
        }
    }
    
    /**
     * Exports all courses as JSON
     */
    private void exportCoursesAsJson(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        String jsonCourses = courseService.exportCoursesToJson();
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(jsonCourses);
    }
    
    /**
     * Imports courses from JSON
     */
    private void importCoursesFromJson(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String jsonData = request.getParameter("jsonData");
        
        if (jsonData == null || jsonData.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "JSON data is required");
            return;
        }
        
        boolean success = courseService.importCoursesFromJson(jsonData);
        
        if (success) {
            request.setAttribute("successMessage", "Courses imported successfully");
            response.sendRedirect(request.getContextPath() + "/teacherDashboard.jsp?tab=courses");
        } else {
            request.setAttribute("errorMessage", "Failed to import courses from JSON");
            request.getRequestDispatcher("/teacherDashboard.jsp?tab=courses").forward(request, response);
        }
    }
}
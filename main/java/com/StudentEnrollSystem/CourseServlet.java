package com.StudentEnrollSystem.servlets;

import com.StudentEnrollSystem.model.Course;
import com.StudentEnrollSystem.services.CourseService;
import com.google.gson.Gson;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/CourseServlet")
public class CourseServlet extends HttpServlet {
    private CourseService courseService;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        courseService = new CourseService();
        gson = new Gson();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String studentId = (String) session.getAttribute("studentId");
        
        String action = request.getParameter("action");
        
        if ("getEnrolledCourses".equals(action)) {
            List<Course> courses = courseService.getEnrolledCourses(studentId);
            request.setAttribute("courses", courses);
            request.getRequestDispatcher("mycourses.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String studentId = (String) session.getAttribute("studentId");
        
        String action = request.getParameter("action");
        
        if ("enroll".equals(action)) {
            String courseId = request.getParameter("courseId");
            boolean success = courseService.enrollStudent(studentId, courseId);
            
            response.setContentType("application/json");
            response.getWriter().write(gson.toJson(success));
        }
    }
}

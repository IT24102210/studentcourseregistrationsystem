package com.StudentEnrollSystem.servlets;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.StudentEnrollSystem.model.Teacher;
import com.StudentEnrollSystem.services.TeacherService;

public class TeacherLoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get teacher ID and password from form
        String teacherId = request.getParameter("teacherId");
        String password = request.getParameter("password");
        
        // Validate input
        if (teacherId == null || teacherId.trim().isEmpty() || 
            password == null || password.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Teacher ID and password are required");
            request.getRequestDispatcher("index.jsp").forward(request, response);
            return;
        }
        
        // Authenticate teacher
        TeacherService teacherService = new TeacherService();
        Teacher teacher = teacherService.authenticateTeacher(teacherId, password);
        
        if (teacher != null) {
            // Successful login
            HttpSession session = request.getSession();
            session.setAttribute("teacher", teacher);
            session.setAttribute("loginTime", new java.util.Date());
            
            // Redirect to dashboard
            response.sendRedirect("teacherDashboard.jsp");
        } else {
            // Failed login
            request.setAttribute("errorMessage", "Invalid Teacher ID or password");
            request.getRequestDispatcher("index.jsp").forward(request, response);
        }
    }
}
package com.StudentEnrollSystem.servlets;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.StudentEnrollSystem.model.Student;
import com.StudentEnrollSystem.services.StudentService;

public class StudentLoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get student ID and password from form
        String studentName = request.getParameter("studentName");
        String password = request.getParameter("password");
        
        // Validate input
        if (studentName == null || studentName.trim().isEmpty() || 
            password == null || password.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Student ID and password are required");
            request.getRequestDispatcher("index.jsp").forward(request, response);
            return;
        }
        
        // Authenticate user
        StudentService studentService = new StudentService();
        Student student = studentService.authenticateUser(studentName, password);
        
        if (student != null) {
            // Successful login
            HttpSession session = request.getSession();
            session.setAttribute("student", student);
            session.setAttribute("loginTime", new java.util.Date());
            
            // Redirect to dashboard
            response.sendRedirect("studentDashboard.jsp");
        } else {
            // Failed login
            request.setAttribute("errorMessage", "Invalid Student ID or password");
            request.getRequestDispatcher("index.jsp").forward(request, response);
        }
    }
}

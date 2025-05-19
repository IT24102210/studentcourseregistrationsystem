package com.StudentEnrollSystem.servlets;

import com.StudentEnrollSystem.model.Teacher;
import com.StudentEnrollSystem.services.EnrollmentService;

import java.io.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/ProcessEnrollmentServlet")
public class ProcessEnrollmentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Teacher teacher = (Teacher) session.getAttribute("teacher");
        
        if (teacher == null) {
            response.sendRedirect("index.jsp");
            return;
        }
        
        String requestId = request.getParameter("requestId");
        String action = request.getParameter("action");
        
        if (requestId == null || action == null || !(action.equals("approve") || action.equals("reject"))) {
            response.sendRedirect("TeacherDashboard.jsp?tab=enrollment-requests&error=Invalid+request+parameters");
            return;
        }
        
        EnrollmentService enrollmentService = new EnrollmentService(getServletContext());
        String status = action.equals("approve") ? "APPROVED" : "REJECTED";
        
        if (enrollmentService.updateRequestStatus(requestId, status)) {
            String successMsg = action.equals("approve") ? 
                "Enrollment request approved successfully" : 
                "Enrollment request rejected successfully";
                
            response.sendRedirect("TeacherDashboard.jsp?tab=enrollment-requests&success=" + successMsg);
        } else {
            response.sendRedirect("TeacherDashboard.jsp?tab=enrollment-requests&error=Failed+to+process+request");
        }
    }
}
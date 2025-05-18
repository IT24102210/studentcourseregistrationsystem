package com.StudentEnrollSystem.servlets;

import com.StudentEnrollSystem.model.EnrollmentRequest;
import com.StudentEnrollSystem.model.Student;
import com.StudentEnrollSystem.services.EnrollmentService;
import com.google.gson.Gson;
import com.google.gson.JsonObject;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/studentEnrollment")
public class StudentEnrollmentServlet extends HttpServlet {
    private EnrollmentService enrollmentService = new EnrollmentService();
    private Gson gson = new Gson();
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        JsonObject jsonResponse = new JsonObject();
        
        try {
            HttpSession session = request.getSession();
            Student student = (Student) session.getAttribute("student");
            
            if (student == null) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Not logged in");
                out.print(jsonResponse.toString());
                return;
            }
            
            String action = request.getParameter("action");
            
            if ("enroll".equals(action)) {
                String courseCode = request.getParameter("courseCode");
                String currentDateTime = request.getParameter("currentDateTime");
                
                if (courseCode == null || courseCode.isEmpty()) {
                    jsonResponse.addProperty("success", false);
                    jsonResponse.addProperty("message", "Course code is required");
                } else if (enrollmentService.isEnrolled(student.getStudentName(), courseCode)) {
                    jsonResponse.addProperty("success", false);
                    jsonResponse.addProperty("message", "You are already enrolled in this course");
                } else if (enrollmentService.hasPendingRequest(student.getStudentName(), courseCode)) {
                    jsonResponse.addProperty("success", false);
                    jsonResponse.addProperty("message", "You already have a pending request for this course");
                } else {
                    EnrollmentRequest enrollRequest = new EnrollmentRequest(
                        student.getStudentName(), courseCode, currentDateTime);
                    
                    boolean success = enrollmentService.addRequest(enrollRequest);
                    
                    if (success) {
                        jsonResponse.addProperty("success", true);
                        jsonResponse.addProperty("message", "Enrollment request submitted successfully");
                        session.setAttribute("enrollmentSuccess", 
                            "Your enrollment request for course " + courseCode + " has been submitted and is waiting for approval");
                    } else {
                        jsonResponse.addProperty("success", false);
                        jsonResponse.addProperty("message", "Failed to submit enrollment request");
                        session.setAttribute("enrollmentError", 
                            "Failed to submit enrollment request for course: " + courseCode);
                    }
                }
            } else if ("getMyRequests".equals(action)) {
                List<EnrollmentRequest> requests = enrollmentService.getStudentRequests(student.getStudentName());
                jsonResponse.addProperty("success", true);
                jsonResponse.add("requests", gson.toJsonTree(requests));
            } else {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Invalid action");
            }
            
        } catch (Exception e) {
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Error: " + e.getMessage());
            e.printStackTrace();
        }
        
        out.print(jsonResponse.toString());
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        JsonObject jsonResponse = new JsonObject();
        
        try {
            HttpSession session = request.getSession();
            Student student = (Student) session.getAttribute("student");
            
            if (student == null) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Not logged in");
                out.print(jsonResponse.toString());
                return;
            }
            
            List<EnrollmentRequest> requests = enrollmentService.getStudentRequests(student.getStudentName());
            jsonResponse.addProperty("success", true);
            jsonResponse.add("requests", gson.toJsonTree(requests));
            
        } catch (Exception e) {
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Error: " + e.getMessage());
            e.printStackTrace();
        }
        
        out.print(jsonResponse.toString());
    }
}
package com.StudentEnrollSystem.servlets;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.util.Date;
import java.text.SimpleDateFormat;

public class AddStudentServlet extends HttpServlet {
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        
        try {
            // Get parameters from the form
            String fname = request.getParameter("fname");
            String lname = request.getParameter("lname");
            String id = request.getParameter("id");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            
            // Get current date and time for registration timestamp
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            String registrationTimestamp = sdf.format(new Date());
            
            // Default department and enrollment year (these can be added as fields in your form later)
            String department = "General";
            String enrollmentYear = "2025";
            
            // Format the data according to your existing structure
            // name, studentName, password, email, department, enrollmentYear, registrationTimestamp
            String fullName = fname + " " + lname;
            String studentData = fullName + ", " + id + ", " + password + ", " + email + ", " + 
                                department + ", " + enrollmentYear + ", " + registrationTimestamp;
            
            // Path to the students.txt file
            String filePath = ("C:\\Users\\user\\Downloads\\uthtara\\StudentEnrollSystem\\src\\main\\webapp\\WEB-INF\\lib\\data\\students.txt");
            
            // Ensure directories exist
            File file = new File(filePath);
            if (!file.exists()) {
                file.getParentFile().mkdirs();
            }
            
            // Write data to file (append mode)
            FileWriter fw = new FileWriter(filePath, true);
            BufferedWriter bw = new BufferedWriter(fw);
            PrintWriter pw = new PrintWriter(bw);
            
            // Add a newline if file is not empty
            if (file.length() > 0) {
                pw.println();
            }
            
            // Write the student data
            pw.print(studentData);
            
            // Close resources
            pw.close();
            bw.close();
            fw.close();
            
            // Redirect back to the teacher dashboard with success message
            response.sendRedirect("teacherDashboard.jsp?message=Student added successfully&tab=students");
            
        } catch (Exception e) {
            out.println("<div class='error-message'>Error adding student: " + e.getMessage() + "</div>");
            e.printStackTrace(out);
        }
    }
}
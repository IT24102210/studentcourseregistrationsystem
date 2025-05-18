package com.example.servlet;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;

public class AttendanceServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String course = request.getParameter("course");
        String date = request.getParameter("attendanceDate");

        // Write to attendance.txt
        String path = getServletContext().getRealPath("/WEB-INF/attendance.txt");
        try (PrintWriter writer = new PrintWriter(new FileWriter(path, true))) {
            request.getParameterMap().forEach((key, values) -> {
                if (key.startsWith("status_")) {
                    String studentId = key.substring(7);
                    String status = values[0];
                    writer.println(studentId + "|" + course + "|" + date + "|" + status);
                }
            });
        } catch (IOException e) {
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/dashboard.jsp?tab=attendance&selectedCourse=" + java.net.URLEncoder.encode(course, "UTF-8"));
    }
}
package com.StudentEnrollSystem.servlets;

import java.io.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {
    private static final String FILE_PATH = "C:/student_profile_data.txt"; // Change path as needed

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get form data
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String dob = request.getParameter("dob");

        // Save to file
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(FILE_PATH))) {
            writer.write(name + "," + email + "," + phone + "," + dob);
        }

        response.sendRedirect("MyProfile.jsp");
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Load existing profile data from file
        File file = new File(FILE_PATH);
        if (file.exists()) {
            try (BufferedReader reader = new BufferedReader(new FileReader(FILE_PATH))) {
                String line = reader.readLine();
                if (line != null) {
                    String[] parts = line.split(",");
                    request.setAttribute("name", parts.length > 0 ? parts[0] : "");
                    request.setAttribute("email", parts.length > 1 ? parts[1] : "");
                    request.setAttribute("phone", parts.length > 2 ? parts[2] : "");
                    request.setAttribute("dob", parts.length > 3 ? parts[3] : "");
                }
            }
        }

        request.getRequestDispatcher("MyProfile.jsp").forward(request, response);
    }
}

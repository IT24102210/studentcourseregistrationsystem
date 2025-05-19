package com.StudentEnrollSystem.servlets;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/AccountSettings")
@MultipartConfig(fileSizeThreshold = 1024 * 1024, // 1MB
                 maxFileSize = 1024 * 1024 * 5,    // 5MB
                 maxRequestSize = 1024 * 1024 * 10) // 10MB
public class AccountSettingsServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String phone = request.getParameter("phone");
        String bio = request.getParameter("bio");
        Part photoPart = request.getPart("photo");

        // Example of handling file upload
        String photoFileName = null;
        if (photoPart != null && photoPart.getSize() > 0) {
            photoFileName = getFileName(photoPart);
            String uploadPath = getServletContext().getRealPath("") + "uploads";
            photoPart.write(uploadPath + "/" + photoFileName);
        }

        // TODO: Save or update this data in your database

        request.setAttribute("message", "Settings updated successfully.");
        request.getRequestDispatcher("/AccountSettings.jsp").forward(request, response);
    }

    private String getFileName(Part part) {
        for (String content : part.getHeader("content-disposition").split(";")) {
            if (content.trim().startsWith("filename")) {
                return content.substring(content.indexOf("=") + 2, content.length() - 1);
            }
        }
        return null;
    }
}

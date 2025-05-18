package com.StudentEnrollSystem.servlets;

import com.StudentEnrollSystem.model.Assignment;
import com.StudentEnrollSystem.services.AssignmentService;

import java.io.IOException;
import java.io.File;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.ArrayList;
import java.util.UUID;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

/**
 * Servlet for handling assignment CRUD operations
 * Last Updated: 2025-05-16 22:07:18
 */
@WebServlet("/AssignmentServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024, // 1 MB
    maxFileSize = 1024 * 1024 * 10,  // 10 MB
    maxRequestSize = 1024 * 1024 * 50 // 50 MB
)
public class AssignmentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private AssignmentService assignmentService;
    
    @Override
    public void init() throws ServletException {
        super.init();
        try {
            // Create service with proper error handling
            assignmentService = new AssignmentService(getServletContext());
            System.out.println("AssignmentServlet initialized successfully with context: " + getServletContext());
        } catch (Exception e) {
            System.err.println("Error initializing AssignmentServlet: " + e.getMessage());
            e.printStackTrace();
            throw new ServletException("Failed to initialize AssignmentServlet", e);
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }
        
        try {
            switch (action) {
                case "view":
                    viewAssignment(request, response);
                    break;
                case "edit":
                    showEditForm(request, response);
                    break;
                case "delete":
                    deleteAssignment(request, response);
                    break;
                default:
                    listAssignments(request, response);
                    break;
            }
        } catch (Exception e) {
            System.err.println("Error processing GET request: " + e.getMessage());
            e.printStackTrace();
            handleError(request, response, "Error processing request: " + e.getMessage());
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        
        try {
            switch (action) {
                case "create":
                    createAssignment(request, response);
                    break;
                case "update":
                    updateAssignment(request, response);
                    break;
                default:
                    response.sendRedirect("teacherDashboard.jsp?tab=assignments");
                    break;
            }
        } catch (Exception e) {
            System.err.println("Error processing POST request: " + e.getMessage());
            e.printStackTrace();
            handleError(request, response, "Error processing request: " + e.getMessage());
        }
    }
    
    private void listAssignments(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String courseCode = request.getParameter("courseCode"); // Optional filter by course
        String teacherId = request.getParameter("teacherId"); // Optional filter by teacher
        
        List<Assignment> assignments;
        if (courseCode != null && !courseCode.isEmpty()) {
            assignments = assignmentService.getAssignmentsByCourse(courseCode);
        } else if (teacherId != null && !teacherId.isEmpty()) {
            assignments = assignmentService.getAssignmentsByTeacher(teacherId);
        } else {
            assignments = assignmentService.getAllAssignments();
        }
        
        request.setAttribute("assignments", assignments);
        request.getRequestDispatcher("teacherDashboard.jsp?tab=assignments").forward(request, response);
    }
    
    private void viewAssignment(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String id = request.getParameter("id");
        if (id != null && !id.isEmpty()) {
            Assignment assignment = assignmentService.getAssignmentById(id);
            if (assignment != null) {
                request.setAttribute("assignment", assignment);
                request.getRequestDispatcher("viewAssignment.jsp").forward(request, response);
            } else {
                handleError(request, response, "Assignment not found");
            }
        } else {
            handleError(request, response, "Assignment ID is required");
        }
    }
    
    private void showEditForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String id = request.getParameter("id");
        if (id != null && !id.isEmpty()) {
            Assignment assignment = assignmentService.getAssignmentById(id);
            if (assignment != null) {
                request.setAttribute("assignment", assignment);
                request.getRequestDispatcher("editAssignment.jsp").forward(request, response);
            } else {
                handleError(request, response, "Assignment not found");
            }
        } else {
            handleError(request, response, "Assignment ID is required");
        }
    }
    
    private void createAssignment(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, ParseException {
        Assignment assignment = new Assignment();
        
        // Set basic assignment properties
        assignment.setCourseCode(request.getParameter("courseCode"));
        assignment.setTitle(request.getParameter("title"));
        assignment.setDescription(request.getParameter("description"));
        assignment.setMaxPoints(Integer.parseInt(request.getParameter("maxPoints")));
        assignment.setTeacherId(request.getParameter("teacherId"));
        assignment.setTeacherName(request.getParameter("teacherName"));
        
        // Parse dates
        String dueDateStr = request.getParameter("dueDate");
        String dueTimeStr = request.getParameter("dueTime");
        SimpleDateFormat dateTimeFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        Date dueDate = dateTimeFormat.parse(dueDateStr + " " + dueTimeStr + ":00");
        assignment.setDueDate(dueDate);
        
        String createdDateStr = request.getParameter("createdDate"); 
        Date createdDate = dateTimeFormat.parse(createdDateStr);
        assignment.setCreatedDate(createdDate);
        
        // Set boolean flags
        assignment.setAllowLateSubmissions(request.getParameter("allowLateSubmissions") != null);
        assignment.setVisibleToStudents(request.getParameter("visibleToStudents") != null);
        assignment.setGroupAssignment(request.getParameter("groupAssignment") != null);
        assignment.setRequireRubric(request.getParameter("requireRubric") != null);
        
        // Handle file uploads
        List<String> attachmentFiles = new ArrayList<>();
        
        // Create uploads directory if it doesn't exist
        String uploadPath = getServletContext().getRealPath("/uploads/assignments/" + assignment.getId());
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            boolean created = uploadDir.mkdirs();
            if (!created) {
                System.err.println("Warning: Failed to create directory: " + uploadPath);
            }
        }
        
        // Process uploaded files
        for (Part part : request.getParts()) {
            if (part.getName().equals("assignmentFiles") && part.getSize() > 0) {
                String fileName = getFileName(part);
                if (fileName != null && !fileName.isEmpty()) {
                    // Generate unique file name to prevent overwriting
                    String uniqueFileName = UUID.randomUUID().toString() + "_" + fileName;
                    part.write(uploadPath + File.separator + uniqueFileName);
                    attachmentFiles.add(uniqueFileName);
                }
            }
        }
        
        assignment.setAttachmentFiles(attachmentFiles);
        
        // Save the assignment
        boolean success = assignmentService.createAssignment(assignment);
        
        if (success) {
            response.sendRedirect("teacherDashboard.jsp?tab=assignments&successMessage=Assignment created successfully");
        } else {
            handleError(request, response, "Failed to create assignment. Please try again.");
        }
    }
    
    /**
     * Update an existing assignment
     * ADDED: This method was missing in the previous implementation
     */
    private void updateAssignment(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, ParseException {
        String id = request.getParameter("id");
        if (id == null || id.isEmpty()) {
            handleError(request, response, "Assignment ID is required");
            return;
        }
        
        Assignment existingAssignment = assignmentService.getAssignmentById(id);
        if (existingAssignment == null) {
            handleError(request, response, "Assignment not found");
            return;
        }
        
        // Update assignment properties
        existingAssignment.setCourseCode(request.getParameter("courseCode"));
        existingAssignment.setTitle(request.getParameter("title"));
        existingAssignment.setDescription(request.getParameter("description"));
        existingAssignment.setMaxPoints(Integer.parseInt(request.getParameter("maxPoints")));
        
        // Parse dates
        String dueDateStr = request.getParameter("dueDate");
        String dueTimeStr = request.getParameter("dueTime");
        SimpleDateFormat dateTimeFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        Date dueDate = dateTimeFormat.parse(dueDateStr + " " + dueTimeStr + ":00");
        existingAssignment.setDueDate(dueDate);
        
        // Set boolean flags
        existingAssignment.setAllowLateSubmissions(request.getParameter("allowLateSubmissions") != null);
        existingAssignment.setVisibleToStudents(request.getParameter("visibleToStudents") != null);
        existingAssignment.setGroupAssignment(request.getParameter("groupAssignment") != null);
        existingAssignment.setRequireRubric(request.getParameter("requireRubric") != null);
        
        // Handle file uploads (keep existing files and add new ones)
        String uploadPath = getServletContext().getRealPath("/uploads/assignments/" + existingAssignment.getId());
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            boolean created = uploadDir.mkdirs();
            if (!created) {
                System.err.println("Warning: Failed to create directory: " + uploadPath);
            }
        }
        
        // Process new uploaded files
        List<String> currentFiles = existingAssignment.getAttachmentFiles();
        if (currentFiles == null) {
            currentFiles = new ArrayList<>();
            existingAssignment.setAttachmentFiles(currentFiles);
        }
        
        // Check if files to remove
        String[] filesToRemove = request.getParameterValues("removeFile");
        if (filesToRemove != null) {
            for (String fileToRemove : filesToRemove) {
                // Remove from list
                currentFiles.remove(fileToRemove);
                
                // Delete file from disk
                File fileToDelete = new File(uploadPath + File.separator + fileToRemove);
                if (fileToDelete.exists()) {
                    boolean deleted = fileToDelete.delete();
                    if (!deleted) {
                        System.err.println("Warning: Failed to delete file: " + fileToDelete.getAbsolutePath());
                    }
                }
            }
        }
        
        // Add new files
        for (Part part : request.getParts()) {
            if (part.getName().equals("assignmentFiles") && part.getSize() > 0) {
                String fileName = getFileName(part);
                if (fileName != null && !fileName.isEmpty()) {
                    // Generate unique file name
                    String uniqueFileName = UUID.randomUUID().toString() + "_" + fileName;
                    part.write(uploadPath + File.separator + uniqueFileName);
                    currentFiles.add(uniqueFileName);
                }
            }
        }
        
        // Save the updated assignment
        boolean success = assignmentService.updateAssignment(existingAssignment);
        
        if (success) {
            response.sendRedirect("teacherDashboard.jsp?tab=assignments&successMessage=Assignment updated successfully");
        } else {
            handleError(request, response, "Failed to update assignment. Please try again.");
        }
    }
    
    private void deleteAssignment(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String id = request.getParameter("id");
        if (id != null && !id.isEmpty()) {
            boolean success = assignmentService.deleteAssignment(id);
            
            if (success) {
                response.sendRedirect("teacherDashboard.jsp?tab=assignments&successMessage=Assignment deleted successfully");
            } else {
                handleError(request, response, "Failed to delete assignment");
            }
        } else {
            handleError(request, response, "Assignment ID is required");
        }
    }
    
    private String getFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] tokens = contentDisp.split(";");
        
        for (String token : tokens) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf("=") + 2, token.length() - 1);
            }
        }
        
        return null;
    }
    
    private void handleError(HttpServletRequest request, HttpServletResponse response, String errorMessage) throws ServletException, IOException {
        System.err.println("Error in AssignmentServlet: " + errorMessage);
        response.sendRedirect("teacherDashboard.jsp?tab=assignments&errorMessage=" + errorMessage);
    }
}
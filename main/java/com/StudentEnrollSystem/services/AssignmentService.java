package com.StudentEnrollSystem.services;  // Updated package name to match error log

import com.StudentEnrollSystem.model.Assignment;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Comparator;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

import javax.servlet.ServletContext;

/**
 * Service class for assignment operations
 * Last Updated: 2025-05-16 21:57:57
 */
public class AssignmentService {
    private ServletContext context;
    // Updated file path to be more standard and avoid issues
    private static final String ASSIGNMENTS_FILE = "C:\\Users\\user\\Downloads\\uthtara\\StudentEnrollSystem\\src\\main\\webapp\\WEB-INF\\lib\\data\\assignments.txt";
    private String realFilePath;
    
    public AssignmentService(ServletContext context) {
        if (context == null) {
            throw new IllegalArgumentException("ServletContext cannot be null");
        }
        this.context = context;
        
        // Save the real path to avoid repeated calls
        this.realFilePath = (ASSIGNMENTS_FILE);
        if (this.realFilePath == null) {
            // If getRealPath returns null, try an alternative path
            this.realFilePath = "C:\\Users\\user\\Downloads\\uthtara\\StudentEnrollSystem\\src\\main\\webapp\\WEB-INF\\lib\\data\\assignments.txt";
        }
        
        ensureDataFileExists();
        System.out.println("AssignmentService initialized with file path: " + this.realFilePath);
    }
    
    /**
     * Make sure the assignments data file exists
     */
    private void ensureDataFileExists() {
        try {
            if (realFilePath == null) {
                System.err.println("Error: Unable to determine real path for assignments file");
                throw new IOException("Real path is null");
            }
            
            File file = new File(realFilePath);
            File parentDir = file.getParentFile();
            
            // Create parent directory if it doesn't exist
            if (!parentDir.exists()) {
                boolean dirCreated = parentDir.mkdirs();
                if (!dirCreated) {
                    System.err.println("Warning: Failed to create directory: " + parentDir.getAbsolutePath());
                }
            }
            
            // Create file if it doesn't exist
            if (!file.exists()) {
                boolean fileCreated = file.createNewFile();
                if (!fileCreated) {
                    System.err.println("Warning: Failed to create file: " + file.getAbsolutePath());
                }
            }
            
            System.out.println("Assignment data file exists at: " + file.getAbsolutePath());
        } catch (IOException | SecurityException e) {
            System.err.println("Error ensuring data file exists: " + e.getMessage());
            e.printStackTrace();
            // Create a fallback path in case of issues
            try {
                realFilePath = System.getProperty("java.io.tmpdir") + "/assignments.txt";
                File tmpFile = new File(realFilePath);
                if (!tmpFile.exists()) {
                    tmpFile.createNewFile();
                }
                System.out.println("Created fallback assignments file at: " + realFilePath);
            } catch (IOException ex) {
                System.err.println("Failed to create fallback file: " + ex.getMessage());
            }
        }
    }
    
    /**
     * Get all assignments
     */
    public List<Assignment> getAllAssignments() {
        List<Assignment> assignments = new ArrayList<>();
        
        try (BufferedReader reader = new BufferedReader(new FileReader(realFilePath))) {
            String line;
            while ((line = reader.readLine()) != null) {
                line = line.trim();
                if (!line.isEmpty()) {
                    Assignment assignment = parseAssignment(line);
                    if (assignment != null) {
                        assignments.add(assignment);
                    }
                }
            }
        } catch (IOException e) {
            System.err.println("Error reading assignments: " + e.getMessage());
            e.printStackTrace();
        }
        
        // Sort by due date (most recent first)
        assignments.sort(Comparator.comparing(Assignment::getDueDate).reversed());
        
        return assignments;
    }
    
    /**
     * Get assignments by course code
     */
    public List<Assignment> getAssignmentsByCourse(String courseCode) {
        return getAllAssignments().stream()
                .filter(a -> a.getCourseCode().equals(courseCode))
                .collect(Collectors.toList());
    }
    
    /**
     * Get assignments by teacher ID
     */
    public List<Assignment> getAssignmentsByTeacher(String teacherId) {
        return getAllAssignments().stream()
                .filter(a -> a.getTeacherId().equals(teacherId))
                .collect(Collectors.toList());
    }
    
    /**
     * Get assignment by ID
     */
    public Assignment getAssignmentById(String id) {
        return getAllAssignments().stream()
                .filter(a -> a.getId().equals(id))
                .findFirst()
                .orElse(null);
    }
    
    /**
     * Create a new assignment
     */
    public boolean createAssignment(Assignment assignment) {
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(realFilePath, true))) {
            writer.write(assignment.toString());
            writer.newLine();
            return true;
        } catch (IOException e) {
            System.err.println("Error creating assignment: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Update an existing assignment
     */
    public boolean updateAssignment(Assignment updatedAssignment) {
        List<Assignment> assignments = getAllAssignments();
        List<Assignment> updatedAssignments = assignments.stream()
                .map(a -> a.getId().equals(updatedAssignment.getId()) ? updatedAssignment : a)
                .collect(Collectors.toList());
        
        return writeAllAssignments(updatedAssignments);
    }
    
    /**
     * Delete an assignment by ID
     */
    public boolean deleteAssignment(String id) {
        List<Assignment> assignments = getAllAssignments();
        List<Assignment> updatedAssignments = assignments.stream()
                .filter(a -> !a.getId().equals(id))
                .collect(Collectors.toList());
        
        // Also delete the assignment files
        try {
            String uploadPath = context.getRealPath("/uploads/assignments/" + id);
            if (uploadPath != null) {
                deleteDirectory(new File(uploadPath));
            }
        } catch (Exception e) {
            System.err.println("Error deleting assignment files: " + e.getMessage());
        }
        
        return writeAllAssignments(updatedAssignments);
    }
    
    /**
     * Write all assignments to the data file
     */
    private boolean writeAllAssignments(List<Assignment> assignments) {
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(realFilePath, false))) {
            for (Assignment assignment : assignments) {
                writer.write(assignment.toString());
                writer.newLine();
            }
            return true;
        } catch (IOException e) {
            System.err.println("Error writing assignments: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Parse an assignment from a string
     * Format: id|courseCode|title|description|dueDate|maxPoints|teacherId|teacherName|createdDate|
     * allowLateSubmissions|visibleToStudents|groupAssignment|requireRubric|attachment1,attachment2,...
     */
    private Assignment parseAssignment(String line) {
        try {
            String[] parts = line.split("\\|");
            if (parts.length < 13) {
                return null;  // Invalid format
            }
            
            Assignment assignment = new Assignment();
            assignment.setId(parts[0]);
            assignment.setCourseCode(parts[1]);
            assignment.setTitle(parts[2]);
            assignment.setDescription(parts[3]);
            assignment.setDueDate(new Date(Long.parseLong(parts[4])));
            assignment.setMaxPoints(Integer.parseInt(parts[5]));
            assignment.setTeacherId(parts[6]);
            assignment.setTeacherName(parts[7]);
            assignment.setCreatedDate(new Date(Long.parseLong(parts[8])));
            assignment.setAllowLateSubmissions(Boolean.parseBoolean(parts[9]));
            assignment.setVisibleToStudents(Boolean.parseBoolean(parts[10]));
            assignment.setGroupAssignment(Boolean.parseBoolean(parts[11]));
            assignment.setRequireRubric(Boolean.parseBoolean(parts[12]));
            
            // Parse attachments if any
            if (parts.length > 13 && !parts[13].isEmpty()) {
                List<String> attachments = Arrays.asList(parts[13].split(","));
                assignment.setAttachmentFiles(attachments);
            }
            
            return assignment;
        } catch (Exception e) {
            System.err.println("Error parsing assignment: " + e.getMessage() + " for line: " + line);
            e.printStackTrace();
            return null;
        }
    }
    
    /**
     * Recursively delete a directory
     */
    private boolean deleteDirectory(File directory) {
        if (directory == null || !directory.exists()) {
            return true;
        }
        
        File[] files = directory.listFiles();
        if (files != null) {
            for (File file : files) {
                if (file.isDirectory()) {
                    deleteDirectory(file);
                } else {
                    file.delete();
                }
            }
        }
        return directory.delete();
    }
}
package com.StudentEnrollSystem.model;

import java.io.Serializable;

public class EnrollmentRequest implements Serializable {
    private String studentName;
    private String courseCode;
    private String requestTimestamp;
    private String status; // pending, approved, rejected
    private String processingTimestamp;
    private String processorId;
    
    public EnrollmentRequest() {
        // Default constructor for GSON
    }
    
    public EnrollmentRequest(String studentName, String courseCode, String requestTimestamp) {
        this.studentName = studentName;
        this.courseCode = courseCode;
        this.requestTimestamp = requestTimestamp;
        this.status = "pending";
        this.processingTimestamp = "";
        this.processorId = "";
    }
    
    // Getters and setters
    public String getStudentName() {
        return studentName;
    }
    
    public void setStudentName(String studentName) {
        this.studentName = studentName;
    }
    
    public String getCourseCode() {
        return courseCode;
    }
    
    public void setCourseCode(String courseCode) {
        this.courseCode = courseCode;
    }
    
    public String getRequestTimestamp() {
        return requestTimestamp;
    }
    
    public void setRequestTimestamp(String requestTimestamp) {
        this.requestTimestamp = requestTimestamp;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    public String getProcessingTimestamp() {
        return processingTimestamp;
    }
    
    public void setProcessingTimestamp(String processingTimestamp) {
        this.processingTimestamp = processingTimestamp;
    }
    
    public String getProcessorId() {
        return processorId;
    }
    
    public void setProcessorId(String processorId) {
        this.processorId = processorId;
    }
    
    // Format for file storage
    public String toFileString() {
        return studentName + "|" + courseCode + "|" + requestTimestamp + "|" + status + "|" + 
               processingTimestamp + "|" + processorId;
    }
    
    // Parse from file string
    public static EnrollmentRequest fromFileString(String fileString) {
        String[] parts = fileString.split("\\|");
        if (parts.length < 3) {
            return null;
        }
        
        EnrollmentRequest request = new EnrollmentRequest(parts[0], parts[1], parts[2]);
        if (parts.length > 3) {
            request.setStatus(parts[3]);
        }
        if (parts.length > 4) {
            request.setProcessingTimestamp(parts[4]);
        }
        if (parts.length > 5) {
            request.setProcessorId(parts[5]);
        }
        
        return request;
    }
}
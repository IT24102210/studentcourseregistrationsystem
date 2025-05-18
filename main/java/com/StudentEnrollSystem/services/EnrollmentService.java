package com.StudentEnrollSystem.services;

import com.StudentEnrollSystem.model.EnrollmentRequest;
import java.io.*;
import java.util.*;

public class EnrollmentService {
    private static final String ENROLLMENT_REQUESTS_FILE = 
        "C:\\Users\\rasin\\Downloads\\project3\\StudentEnrollSystem\\src (9)\\src\\main\\webapp\\WEB-INF\\lib\\data\\enrollment_requests.txt";
    private static final String ENROLLMENTS_FILE = 
        "C:\\Users\\rasin\\Downloads\\project3\\StudentEnrollSystem\\src (9)\\src\\main\\webapp\\WEB-INF\\lib\\data\\enrollments.txt";
    
    public List<EnrollmentRequest> getAllRequests() {
        List<EnrollmentRequest> requests = new ArrayList<>();
        File file = new File(ENROLLMENT_REQUESTS_FILE);
        
        if (!file.exists()) {
            try {
                file.getParentFile().mkdirs();
                file.createNewFile();
            } catch (IOException e) {
                e.printStackTrace();
                return requests;
            }
        }
        
        try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
            String line;
            while ((line = reader.readLine()) != null) {
                line = line.trim();
                if (!line.isEmpty() && !line.startsWith("#")) {
                    EnrollmentRequest request = EnrollmentRequest.fromFileString(line);
                    if (request != null) {
                        requests.add(request);
                    }
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        
        return requests;
    }
    
    public List<EnrollmentRequest> getPendingRequestsForCourse(String courseCode) {
        List<EnrollmentRequest> allRequests = getAllRequests();
        List<EnrollmentRequest> pendingRequests = new ArrayList<>();
        
        for (EnrollmentRequest request : allRequests) {
            if (request.getCourseCode().equals(courseCode) && request.getStatus().equals("pending")) {
                pendingRequests.add(request);
            }
        }
        
        // Sort by timestamp (oldest first) to implement FIFO queue behavior
        Collections.sort(pendingRequests, new Comparator<EnrollmentRequest>() {
            public int compare(EnrollmentRequest r1, EnrollmentRequest r2) {
                return r1.getRequestTimestamp().compareTo(r2.getRequestTimestamp());
            }
        });
        
        return pendingRequests;
    }
    
    public List<EnrollmentRequest> getStudentRequests(String studentName) {
        List<EnrollmentRequest> allRequests = getAllRequests();
        List<EnrollmentRequest> studentRequests = new ArrayList<>();
        
        for (EnrollmentRequest request : allRequests) {
            if (request.getStudentName().equals(studentName)) {
                studentRequests.add(request);
            }
        }
        
        return studentRequests;
    }
    
    public synchronized boolean addRequest(EnrollmentRequest request) {
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(ENROLLMENT_REQUESTS_FILE, true))) {
            writer.write(request.toFileString());
            writer.newLine();
            return true;
        } catch (IOException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public synchronized boolean updateRequestStatus(String studentName, String courseCode, String status, 
                                                  String processingTimestamp, String processorId) {
        List<EnrollmentRequest> requests = getAllRequests();
        boolean updated = false;
        
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(ENROLLMENT_REQUESTS_FILE))) {
            // Preserve any header comments
            try (BufferedReader reader = new BufferedReader(new FileReader(ENROLLMENT_REQUESTS_FILE))) {
                String line;
                while ((line = reader.readLine()) != null) {
                    if (line.trim().startsWith("#")) {
                        writer.write(line);
                        writer.newLine();
                    } else {
                        break;
                    }
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
            
            for (EnrollmentRequest request : requests) {
                if (request.getStudentName().equals(studentName) && 
                    request.getCourseCode().equals(courseCode) && 
                    request.getStatus().equals("pending")) {
                    
                    request.setStatus(status);
                    request.setProcessingTimestamp(processingTimestamp);
                    request.setProcessorId(processorId);
                    updated = true;
                    
                    // If approved, also add to enrollments file
                    if (status.equals("approved")) {
                        try (BufferedWriter enrollWriter = new BufferedWriter(new FileWriter(ENROLLMENTS_FILE, true))) {
                            enrollWriter.write(studentName + "|" + courseCode + "|" + processingTimestamp);
                            enrollWriter.newLine();
                        } catch (IOException e) {
                            e.printStackTrace();
                        }
                    }
                }
                
                writer.write(request.toFileString());
                writer.newLine();
            }
            return updated;
        } catch (IOException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean isEnrolled(String studentName, String courseCode) {
        try (BufferedReader reader = new BufferedReader(new FileReader(ENROLLMENTS_FILE))) {
            String line;
            while ((line = reader.readLine()) != null) {
                String[] parts = line.split("\\|");
                if (parts.length >= 2 && parts[0].equals(studentName) && parts[1].equals(courseCode)) {
                    return true;
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean hasPendingRequest(String studentName, String courseCode) {
        List<EnrollmentRequest> studentRequests = getStudentRequests(studentName);
        for (EnrollmentRequest req : studentRequests) {
            if (req.getCourseCode().equals(courseCode) && 
                (req.getStatus().equals("pending") || req.getStatus().equals("approved"))) {
                return true;
            }
        }
        return false;
    }
}
package com.StudentEnrollSystem.model;

import java.util.Date;
import java.util.List;
import java.util.ArrayList;
import java.io.Serializable;

/**
 * Assignment model class
 */
public class Assignment implements Serializable {
    private static final long serialVersionUID = 1L;
    
    private String id;
    private String courseCode;
    private String title;
    private String description;
    private Date dueDate;
    private int maxPoints;
    private String teacherId;
    private String teacherName;
    private Date createdDate;
    private List<String> attachmentFiles;
    private boolean allowLateSubmissions;
    private boolean visibleToStudents;
    private boolean groupAssignment;
    private boolean requireRubric;
    
    public Assignment() {
        this.attachmentFiles = new ArrayList<>();
        this.id = generateId();
    }
    
    /**
     * Generate a unique ID for the assignment
     * Format: ASG-{timestamp}-{random number}
     */
    private String generateId() {
        return "ASG-" + System.currentTimeMillis() + "-" + (int)(Math.random() * 1000);
    }
    
    /**
     * Convert assignment to string format for storage
     * Format: id|courseCode|title|description|dueDate|maxPoints|teacherId|teacherName|createdDate|
     * allowLateSubmissions|visibleToStudents|groupAssignment|requireRubric|attachment1,attachment2,...
     */
    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append(id).append("|");
        sb.append(courseCode).append("|");
        sb.append(title).append("|");
        sb.append(description).append("|");
        sb.append(dueDate.getTime()).append("|");
        sb.append(maxPoints).append("|");
        sb.append(teacherId).append("|");
        sb.append(teacherName).append("|");
        sb.append(createdDate.getTime()).append("|");
        sb.append(allowLateSubmissions).append("|");
        sb.append(visibleToStudents).append("|");
        sb.append(groupAssignment).append("|");
        sb.append(requireRubric);
        
        if (!attachmentFiles.isEmpty()) {
            sb.append("|");
            for (int i = 0; i < attachmentFiles.size(); i++) {
                sb.append(attachmentFiles.get(i));
                if (i < attachmentFiles.size() - 1) {
                    sb.append(",");
                }
            }
        }
        
        return sb.toString();
    }
    
    // Getters and setters
    public String getId() {
        return id;
    }
    
    public void setId(String id) {
        this.id = id;
    }
    
    public String getCourseCode() {
        return courseCode;
    }
    
    public void setCourseCode(String courseCode) {
        this.courseCode = courseCode;
    }
    
    public String getTitle() {
        return title;
    }
    
    public void setTitle(String title) {
        this.title = title;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public Date getDueDate() {
        return dueDate;
    }
    
    public void setDueDate(Date dueDate) {
        this.dueDate = dueDate;
    }
    
    public int getMaxPoints() {
        return maxPoints;
    }
    
    public void setMaxPoints(int maxPoints) {
        this.maxPoints = maxPoints;
    }
    
    public String getTeacherId() {
        return teacherId;
    }
    
    public void setTeacherId(String teacherId) {
        this.teacherId = teacherId;
    }
    
    public String getTeacherName() {
        return teacherName;
    }
    
    public void setTeacherName(String teacherName) {
        this.teacherName = teacherName;
    }
    
    public Date getCreatedDate() {
        return createdDate;
    }
    
    public void setCreatedDate(Date createdDate) {
        this.createdDate = createdDate;
    }
    
    public List<String> getAttachmentFiles() {
        return attachmentFiles;
    }
    
    public void setAttachmentFiles(List<String> attachmentFiles) {
        this.attachmentFiles = attachmentFiles;
    }
    
    public void addAttachment(String fileName) {
        this.attachmentFiles.add(fileName);
    }
    
    public boolean isAllowLateSubmissions() {
        return allowLateSubmissions;
    }
    
    public void setAllowLateSubmissions(boolean allowLateSubmissions) {
        this.allowLateSubmissions = allowLateSubmissions;
    }
    
    public boolean isVisibleToStudents() {
        return visibleToStudents;
    }
    
    public void setVisibleToStudents(boolean visibleToStudents) {
        this.visibleToStudents = visibleToStudents;
    }
    
    public boolean isGroupAssignment() {
        return groupAssignment;
    }
    
    public void setGroupAssignment(boolean groupAssignment) {
        this.groupAssignment = groupAssignment;
    }
    
    public boolean isRequireRubric() {
        return requireRubric;
    }
    
    public void setRequireRubric(boolean requireRubric) {
        this.requireRubric = requireRubric;
    }
}
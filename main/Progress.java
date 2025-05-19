package com.StudentEnrollSystem.model;


public class Progress {
    private String id;
    private String studentId;
    private String course;
    private String progressStatus;

    public Progress(String id, String studentId, String course, String progressStatus) {
        this.id = id;
        this.studentId = studentId;
        this.course = course;
        this.progressStatus = progressStatus;
    }

    public String getId() {
        return id;
    }

    public String getStudentId() {
        return studentId;
    }

    public String getCourse() {
        return course;
    }

    public String getProgressStatus() {
        return progressStatus;
    }

    public void setId(String id) {
        this.id = id;
    }

    public void setStudentId(String studentId) {
        this.studentId = studentId;
    }

    public void setCourse(String course) {
        this.course = course;
    }

    public void setProgressStatus(String progressStatus) {
        this.progressStatus = progressStatus;
    }

    // Fix for FileUtil error
    public static Progress fromString(String line) {
        String[] fields = line.split(",");
        if (fields.length == 4) {
            return new Progress(fields[0], fields[1], fields[2], fields[3]);
        }
        return null;
    }

    @Override
    public String toString() {
        return id + "," + studentId + "," + course + "," + progressStatus;
    }
}

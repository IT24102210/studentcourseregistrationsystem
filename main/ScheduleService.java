package com.StudentEnrollSystem.services;

import com.StudentEnrollSystem.model.Schedule;
import java.io.*;
import java.util.*;

public class ScheduleService {
    private static final String SCHEDULE_FILE = "WEB-INF/lib/schedules.txt";
    private static final String ENROLLMENTS_FILE = "WEB-INF/lib/enrollments.txt";

    public List<Schedule> getStudentSchedule(String studentId) {
        List<Schedule> schedules = new ArrayList<>();
        try {
            // First get enrolled courses
            Set<String> enrolledCourses = new HashSet<>();
            List<String> enrollments = readLines(ENROLLMENTS_FILE);
            for (String enrollment : enrollments) {
                String[] parts = enrollment.split(",");
                if (parts[0].equals(studentId)) {
                    enrolledCourses.add(parts[1]);
                }
            }

            // Then get schedules for enrolled courses
            List<String> scheduleLines = readLines(SCHEDULE_FILE);
            for (String line : scheduleLines) {
                String[] parts = line.split(",");
                if (enrolledCourses.contains(parts[0])) {
                    schedules.add(new Schedule(
                        parts[0], // courseId
                        parts[1], // courseName
                        parts[2], // dayOfWeek
                        parts[3], // startTime
                        parts[4], // endTime
                        parts[5], // room
                        parts[6]  // instructor
                    ));
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        return schedules;
    }

    private List<String> readLines(String filename) throws IOException {
        List<String> lines = new ArrayList<>();
        try (BufferedReader reader = new BufferedReader(new FileReader(filename))) {
            String line;
            while ((line = reader.readLine()) != null) {
                lines.add(line);
            }
        }
        return lines;
    }
}
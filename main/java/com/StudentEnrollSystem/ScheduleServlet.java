package com.StudentEnrollSystem.servlets;

import com.StudentEnrollSystem.model.Schedule;
import com.StudentEnrollSystem.services.ScheduleService;
import com.google.gson.Gson;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/ScheduleServlet")
public class ScheduleServlet extends HttpServlet {
    private ScheduleService scheduleService;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        scheduleService = new ScheduleService();
        gson = new Gson();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String studentId = (String) session.getAttribute("studentId");

        List<Schedule> schedules = scheduleService.getStudentSchedule(studentId);
        request.setAttribute("schedules", schedules);
        request.getRequestDispatcher("schedule.jsp").forward(request, response);
    }
}

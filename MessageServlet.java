package com.StudentEnrollSystem.servlets;

import com.StudentEnrollSystem.model.Message;
import com.StudentEnrollSystem.model.Teacher;
import com.StudentEnrollSystem.model.Student;
import com.StudentEnrollSystem.services.MessageService;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Enumeration;

@WebServlet("/MessageServlet")
public class MessageServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private MessageService messageService;
    private Gson gson;
    
    // Current values
    private static final String CURRENT_DATETIME = "2025-05-16 20:30:07";
    private static final String CURRENT_USER_LOGIN = "IT24103866";
    
    @Override
    public void init() throws ServletException {
        messageService = new MessageService(getServletContext());
        gson = new GsonBuilder()
                .setDateFormat("yyyy-MM-dd HH:mm:ss")
                .create();
        
        // Print initialization message
        System.out.println("MessageServlet initialized at " + CURRENT_DATETIME);
    }
    
    /**
     * Handle GET requests - retrieve messages
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Debug - Log the request details
        logRequestDetails(request, "GET");
        
        // Check if user is logged in
        Object user = request.getSession().getAttribute("teacher");
        if (user == null) {
            user = request.getSession().getAttribute("student");
        }
        
        if (user == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "User not logged in");
            return;
        }
        
        String username = CURRENT_USER_LOGIN;
        String action = request.getParameter("action");
        
        System.out.println("GET Request - Action: " + action + ", Username: " + username);
        
        // Default action is inbox
        if (action == null || action.trim().isEmpty()) {
            action = "inbox";
            System.out.println("No action specified, defaulting to: " + action);
        }
        
        try {
            switch (action) {
                case "inbox":
                    loadInbox(request, response, username);
                    break;
                case "sent":
                    loadSentMessages(request, response, username);
                    break;
                case "view":
                    viewMessage(request, response, username);
                    break;
                case "json":
                    getMessagesJson(request, response, username);
                    break;
                default:
                    System.out.println("Unknown action requested: " + action);
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Unknown action: " + action);
            }
        } catch (Exception e) {
            System.err.println("Error processing GET request: " + e.getMessage());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error processing request: " + e.getMessage());
        }
    }
    
    /**
     * Handle POST requests - create, update, delete messages
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Debug - Log the request details
        logRequestDetails(request, "POST");
        
        // Check if user is logged in
        Object user = request.getSession().getAttribute("teacher");
        if (user == null) {
            user = request.getSession().getAttribute("student");
        }
        
        if (user == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "User not logged in");
            return;
        }
        
        String username = CURRENT_USER_LOGIN;
        String action = request.getParameter("action");
        
        System.out.println("POST Request - Action: " + action + ", Username: " + username);
        
        // Default action is create
        if (action == null || action.trim().isEmpty()) {
            action = "create";
            System.out.println("No action specified, defaulting to: " + action);
        }
        
        try {
            switch (action) {
                case "create":
                    createMessage(request, response, username);
                    break;
                case "markAsRead":
                    markAsRead(request, response, username);
                    break;
                case "delete":
                    deleteMessage(request, response, username);
                    break;
                default:
                    System.out.println("Unknown action requested: " + action);
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Unknown action: " + action);
            }
        } catch (Exception e) {
            System.err.println("Error processing POST request: " + e.getMessage());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error processing request: " + e.getMessage());
        }
    }
    
    /**
     * Log request details for debugging
     */
    private void logRequestDetails(HttpServletRequest request, String method) {
        System.out.println("\n==== " + method + " Request to MessageServlet ====");
        System.out.println("Request URI: " + request.getRequestURI());
        System.out.println("Query String: " + request.getQueryString());
        System.out.println("Content Type: " + request.getContentType());
        System.out.println("Parameters:");
        
        Enumeration<String> paramNames = request.getParameterNames();
        while (paramNames.hasMoreElements()) {
            String paramName = paramNames.nextElement();
            String paramValue = request.getParameter(paramName);
            System.out.println("  " + paramName + ": " + paramValue);
        }
        
        System.out.println("Headers:");
        Enumeration<String> headerNames = request.getHeaderNames();
        while (headerNames.hasMoreElements()) {
            String headerName = headerNames.nextElement();
            String headerValue = request.getHeader(headerName);
            System.out.println("  " + headerName + ": " + headerValue);
        }
        
        System.out.println("Session Attributes:");
        Enumeration<String> attributeNames = request.getSession().getAttributeNames();
        while (attributeNames.hasMoreElements()) {
            String attributeName = attributeNames.nextElement();
            Object attributeValue = request.getSession().getAttribute(attributeName);
            System.out.println("  " + attributeName + ": " + 
                               (attributeValue != null ? attributeValue.getClass().getSimpleName() : "null"));
        }
        
        System.out.println("================================================\n");
    }
    
    /**
     * Load user's inbox
     */
    private void loadInbox(HttpServletRequest request, HttpServletResponse response, String username) 
            throws ServletException, IOException {
        
        List<Message> inbox = messageService.getUserInbox(username);
        request.setAttribute("messages", inbox);
        request.setAttribute("messageType", "inbox");
        
        // Get unread count for badge
        int unreadCount = messageService.getUnreadCount(username);
        request.setAttribute("unreadCount", unreadCount);
        
        // Set active tab
        request.setAttribute("activeTab", "messages");
        
        request.getRequestDispatcher("/teacherDashboard.jsp").forward(request, response);
    }
    
    /**
     * Load user's sent messages
     */
    private void loadSentMessages(HttpServletRequest request, HttpServletResponse response, String username) 
            throws ServletException, IOException {
        
        List<Message> sent = messageService.getUserSentMessages(username);
        request.setAttribute("messages", sent);
        request.setAttribute("messageType", "sent");
        
        // Get unread count for badge
        int unreadCount = messageService.getUnreadCount(username);
        request.setAttribute("unreadCount", unreadCount);
        
        // Set active tab
        request.setAttribute("activeTab", "messages");
        
        request.getRequestDispatcher("/teacherDashboard.jsp").forward(request, response);
    }
    
    /**
     * View a single message
     */
    private void viewMessage(HttpServletRequest request, HttpServletResponse response, String username) 
            throws ServletException, IOException {
        
        String messageId = request.getParameter("id");
        if (messageId == null || messageId.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Message ID is required");
            return;
        }
        
        Message message = messageService.getMessageById(messageId);
        if (message == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Message not found");
            return;
        }
        
        // Only mark as read if the current user is the recipient
        if (username.equals(message.getRecipient()) && !message.isRead()) {
            message.setRead(true);
            messageService.updateMessage(message);
        }
        
        request.setAttribute("message", message);
        
        // Determine if user can reply to this message
        boolean canReply = username.equals(message.getRecipient());
        request.setAttribute("canReply", canReply);
        
        // Get unread count for badge
        int unreadCount = messageService.getUnreadCount(username);
        request.setAttribute("unreadCount", unreadCount);
        
        // Set active tab
        request.setAttribute("activeTab", "messages");
        
        request.getRequestDispatcher("/teacherDashboard.jsp").forward(request, response);
    }
    
    /**
     * Return messages as JSON
     */
    private void getMessagesJson(HttpServletRequest request, HttpServletResponse response, String username) 
            throws IOException {
        
        String type = request.getParameter("type");
        List<Message> messages;
        
        if ("sent".equals(type)) {
            messages = messageService.getUserSentMessages(username);
        } else {
            // Default to inbox
            messages = messageService.getUserInbox(username);
        }
        
        // Add extra info
        Map<String, Object> result = new HashMap<>();
        result.put("messages", messages);
        result.put("unreadCount", messageService.getUnreadCount(username));
        result.put("timestamp", CURRENT_DATETIME);
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(gson.toJson(result));
    }
    
    /**
     * Create a new message
     */
    private void createMessage(HttpServletRequest request, HttpServletResponse response, String sender) 
            throws IOException {
        
        // Get form parameters
        String recipient = request.getParameter("recipient");
        String subject = request.getParameter("subject");
        String content = request.getParameter("content");
        String category = request.getParameter("category");
        String importantStr = request.getParameter("important");
        boolean important = "on".equals(importantStr) || "true".equals(importantStr);
        
        // Log the parameters for debugging
        System.out.println("Creating message with parameters:");
        System.out.println("  recipient: " + recipient);
        System.out.println("  subject: " + subject);
        System.out.println("  content length: " + (content != null ? content.length() : 0));
        System.out.println("  category: " + category);
        System.out.println("  important: " + important);
        
        // Validate required fields
        if (recipient == null || recipient.trim().isEmpty() || 
            subject == null || subject.trim().isEmpty() || 
            content == null || content.trim().isEmpty()) {
            
            sendJsonResponse(response, false, "All required fields must be filled");
            return;
        }
        
        // Create the message
        try {
            Message message = messageService.createMessage(
                sender, recipient, subject, content, category, important
            );
            
            sendJsonResponse(response, true, "Message sent successfully", message);
        } catch (Exception e) {
            System.err.println("Error creating message: " + e.getMessage());
            e.printStackTrace();
            sendJsonResponse(response, false, "Error creating message: " + e.getMessage());
        }
    }
    
    /**
     * Mark a message as read
     */
    private void markAsRead(HttpServletRequest request, HttpServletResponse response, String username) 
            throws IOException {
        
        String messageId = request.getParameter("id");
        if (messageId == null || messageId.trim().isEmpty()) {
            sendJsonResponse(response, false, "Message ID is required");
            return;
        }
        
        Message message = messageService.getMessageById(messageId);
        if (message == null) {
            sendJsonResponse(response, false, "Message not found");
            return;
        }
        
        // Make sure user is the recipient
        if (!username.equals(message.getRecipient())) {
            sendJsonResponse(response, false, "You are not authorized to mark this message as read");
            return;
        }
        
        boolean success = messageService.markAsRead(messageId);
        
        if (success) {
            sendJsonResponse(response, true, "Message marked as read");
        } else {
            sendJsonResponse(response, false, "Failed to mark message as read");
        }
    }
    
    /**
     * Delete a message
     */
    private void deleteMessage(HttpServletRequest request, HttpServletResponse response, String username) 
            throws IOException {
        
        String messageId = request.getParameter("id");
        if (messageId == null || messageId.trim().isEmpty()) {
            sendJsonResponse(response, false, "Message ID is required");
            return;
        }
        
        Message message = messageService.getMessageById(messageId);
        if (message == null) {
            sendJsonResponse(response, false, "Message not found");
            return;
        }
        
        // Make sure user is the recipient or sender
        if (!username.equals(message.getRecipient()) && !username.equals(message.getSender())) {
            sendJsonResponse(response, false, "You are not authorized to delete this message");
            return;
        }
        
        boolean success = messageService.deleteMessage(messageId);
        
        if (success) {
            sendJsonResponse(response, true, "Message deleted successfully");
        } else {
            sendJsonResponse(response, false, "Failed to delete message");
        }
    }
    
    /**
     * Send JSON response
     */
    private void sendJsonResponse(HttpServletResponse response, boolean success, String message) 
            throws IOException {
        sendJsonResponse(response, success, message, null);
    }
    
    /**
     * Send JSON response with data
     */
    private void sendJsonResponse(HttpServletResponse response, boolean success, String message, Object data) 
            throws IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        Map<String, Object> result = new HashMap<>();
        result.put("success", success);
        result.put("message", message);
        result.put("timestamp", CURRENT_DATETIME); 
        
        if (data != null) {
            result.put("data", data);
        }
        
        String jsonResponse = gson.toJson(result);
        System.out.println("Sending JSON response: " + jsonResponse);
        response.getWriter().write(jsonResponse);
    }
}
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%
    List<String> announcements = (List<String>) request.getAttribute("announcements");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Announcements</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    
    <!-- Bootstrap & Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">

    <style>
        :root {
            --primary-color: #2196F3;
            --secondary-color: #f1f1f1;
            --bg-color: #2b2f32;
            --form-bg: #3a3f44;
            --text-color: #f8f9fa;
            --field-bg: #4e545a;
            --danger-color: #f44336;
            --warning-color: #ffc107;
            --info-color: #0dcaf0;
        }

        body {
            background-color: white;
            color: var(--text-color);
            font-family: 'Segoe UI', sans-serif;
            margin: 0;
            padding: 0;
            min-height: 100vh;
            position: relative;
            overflow-x: hidden;
        }

        body::before {
            content: "";
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(135deg, rgba(33,150,243,0.1) 0%, rgba(0,0,0,0) 100%);
            z-index: -1;
        }

        .container {
            max-width: 900px;
            margin: 30px auto;
            background: var(--form-bg);
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 0 30px rgba(0,0,0,0.3);
            position: relative;
            z-index: 1;
        }

        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 1px solid #4e545a;
        }

        .announcement-card {
            background: var(--form-bg);
            border-radius: 8px;
            margin-bottom: 20px;
            border: 1px solid #4e545a;
            transition: all 0.3s;
            padding: 20px;
        }

        .announcement-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.2);
        }

        .announcement-title {
            font-size: 18px;
            font-weight: 600;
            margin-bottom: 10px;
            display: flex;
            align-items: center;
        }

        .announcement-title i {
            margin-right: 10px;
        }

        .announcement-body {
            font-size: 1rem;
            color: #d4d4d4;
        }

        .floating {
            position: absolute;
            animation: floating 9s infinite linear;
            opacity: 0.3;
            z-index: -4;
        }

        @keyframes floating {
            0% { transform: translate(0, 0) rotate(0deg); }
            25% { transform: translate(50px, 50px) rotate(90deg); }
            50% { transform: translate(0, 100px) rotate(180deg); }
            75% { transform: translate(-50px, 50px) rotate(270deg); }
            100% { transform: translate(0, 0) rotate(360deg); }
        }

        .filter-controls {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
        }

        .filter-btn {
            padding: 5px 15px;
            border-radius: 20px;
            border: 1px solid #5d646b;
            background: var(--field-bg);
            color: var(--text-color);
            cursor: pointer;
            transition: all 0.3s;
        }

        .filter-btn:hover, .filter-btn.active {
            background: var(--primary-color);
            color: white;
            border-color: var(--primary-color);
        }
    </style>
</head>
<body>

    <!-- Floating background elements -->
    <div class="floating" style="top: 10%; left: 5%; width: 100px; height: 100px; background: var(--primary-color); border-radius: 50%;"></div>
    <div class="floating" style="top: 70%; left: 80%; width: 150px; height: 150px; background: var(--danger-color); border-radius: 30%; animation-delay: -5s;"></div>
    <div class="floating" style="top: 30%; left: 70%; width: 80px; height: 80px; background: #4caf50; border-radius: 20%; animation-delay: -10s;"></div>

    <div class="container">
        <div class="page-header">
            <h1><i class="fas fa-bullhorn"></i> Student Announcements</h1>
            <div class="filter-controls">
                <button class="filter-btn active">All</button>
                <!-- Placeholder filters (not active for dynamic list, but can be extended) -->
            </div>
        </div>

        <%
            if (announcements != null && !announcements.isEmpty()) {
                for (String note : announcements) {
        %>
            <div class="announcement-card">
                <div class="announcement-title">
                    <i class="fas fa-circle-info"></i> Announcement
                </div>
                <div class="announcement-body">
                    <%= note %>
                </div>
            </div>
        <%
                }
            } else {
        %>
            <div class="announcement-card">
                <div class="announcement-title"><i class="fas fa-info-circle"></i> No Announcements</div>
                <div class="announcement-body">There are currently no announcements to display.</div>
            </div>
        <%
            }
        %>

    </div>

    <!-- Bootstrap Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>

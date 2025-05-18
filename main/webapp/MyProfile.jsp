<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="javax.servlet.http.*, javax.servlet.*" %>
<%
    String fullName = "Your name";
    String email = "senitha@my.sliit.lk";
    String regNo = "STU20231045";
    String course = "B.Sc Computer Science";
    String year = "3rd Year";
    String semester = "6";
    String dob = "2003-02-14";
    String gender = "Male";
    String contact = "+91 98765 43210";
    String address = "Colombo, Srilanka.";
    double gpa = 8.7;
    int enrolledCourses = 5;
    int completedCredits = 84;
    int totalCredits = 120;
%>
<!DOCTYPE html>
<html>
<head>
    <title>Student Profile</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    
    <!-- Bootstrap & Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    
    <!-- Custom Styles -->
    <style>
        :root {
            --primary-color: #2196F3;
            --secondary-color: #f1f1f1;
            --bg-color: #ffffff;
            --form-bg: #3a3f44;
            --text-color: #f8f9fa;
            --field-bg: #4e545a;
            --danger-color: #f44336;
        }

        body {
            background-color: white; /* changed */
            color: var(--text-color);
            font-family: 'Segoe UI', sans-serif;
            margin: 0;
            padding: 0;
            min-height: 100vh;
            position: relative;
            overflow-x: hidden;
        }

        /* Removed translucent background overlay */
        /* body::before {
            content: "";
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(135deg, rgba(33,150,243,0.1) 0%, rgba(0,0,0,0) 100%);
            z-index: -1;
        } */

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

        .profile-header {
            display: flex;
            align-items: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 1px solid #4e545a;
        }

        .profile-pic-container {
            position: relative;
            margin-right: 30px;
            width: 150px;
            height: 150px;
            background: #4e545a;
            border-radius: 8px;
            display: flex;
            justify-content: center;
            align-items: center;
            overflow: hidden;
            border: 2px solid #5d646b;
        }

        .profile-pic {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .change-photo-btn {
            position: absolute;
            bottom: 10px;
            right: 10px;
            background: var(--primary-color);
            color: white;
            border: none;
            border-radius: 4px;
            padding: 5px 10px;
            font-size: 12px;
            cursor: pointer;
        }

        .settings-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 30px;
        }

        .profile-section {
            margin-bottom: 30px;
            background: #3a3f44;
            padding: 20px;
            border-radius: 8px;
            border: 1px solid #4e545a;
        }

        .section-title {
            font-size: 18px;
            margin-bottom: 15px;
            color: var(--text-color);
            padding-bottom: 10px;
            border-bottom: 1px solid #4e545a;
            display: flex;
            align-items: center;
        }

        .section-title i {
            margin-right: 10px;
            color: var(--primary-color);
        }

        .info-item {
            margin-bottom: 20px;
        }

        .info-label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: #d1d5db;
        }

        .info-value {
            background: var(--field-bg);
            border: 1px solid #5d646b;
            border-radius: 4px;
            padding: 12px;
            color: var(--text-color);
            display: block;
        }

        .stats-card {
            background: var(--field-bg);
            border-radius: 8px;
            padding: 15px;
            text-align: center;
            margin-bottom: 15px;
        }

        .stat-value {
            font-size: 1.8rem;
            font-weight: 700;
            color: var(--primary-color);
            margin-bottom: 0.2rem;
        }

        .stat-label {
            font-size: 0.8rem;
            color: #d1d5db;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .edit-btn {
            padding: 12px 25px;
            background: var(--primary-color);
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
            transition: all 0.3s;
            margin-top: 10px;
        }

        .edit-btn:hover {
            background: #1976D2;
            transform: translateY(-2px);
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
    </style>
</head>
<body>
    <!-- Floating background elements -->
    <div class="floating" style="top: 10%; left: 5%; width: 100px; height: 100px; background: var(--primary-color); border-radius: 50%;"></div>
    <div class="floating" style="top: 70%; left: 80%; width: 150px; height: 150px; background: var(--danger-color); border-radius: 30%; animation-delay: -5s;"></div>
    <div class="floating" style="top: 30%; left: 70%; width: 80px; height: 80px; background: #4caf50; border-radius: 20%; animation-delay: -10s;"></div>

    <div class="container">
        <div class="profile-header">
            <div class="profile-pic-container">
                <img id="profileImage" class="profile-pic" 
                     src="https://via.placeholder.com/150" 
                     alt="Profile Picture">
                <button class="change-photo-btn" onclick="document.getElementById('profileImageUpload').click()">
                    Change
                </button>
                <input type="file" id="profileImageUpload" accept="image/*" style="display: none;">
                
                <input type="text" name="name" value="${name}">
				<input type="email" name="email" value="${email}">
				<input type="text" name="phone" value="${phone}">
				<input type="date" name="dob" value="${dob}">
                
            </div>
            <div>
                <h1 style="margin: 0; color: var(--text-color);"><%= fullName %></h1>
                <p style="margin: 5px 0 0; color: #a0a4a8;"><i class="fas fa-id-badge"></i> <%= regNo %></p>
                <p style="margin: 5px 0 0; color: #a0a4a8;"><i class="fas fa-graduation-cap"></i> <%= course %></p>
            </div>
        </div>

        <div class="settings-grid">
            <!-- Personal Information Section -->
            <div class="profile-section">
                <h2 class="section-title"><i class="fas fa-user"></i> Personal Information</h2>
                <div class="info-item"><div class="info-label">Email Address</div><div class="info-value"><%= email %></div></div>
                <div class="info-item"><div class="info-label">Date of Birth</div><div class="info-value"><%= dob %></div></div>
                <div class="info-item"><div class="info-label">Gender</div><div class="info-value"><%= gender %></div></div>
                <div class="info-item"><div class="info-label">Contact Number</div><div class="info-value"><%= contact %></div></div>
                <div class="info-item"><div class="info-label">Address</div><div class="info-value"><%= address %></div></div>
            </div>

            <!-- Academic Information Section -->
            <div class="profile-section">
                <h2 class="section-title"><i class="fas fa-graduation-cap"></i> Academic Information</h2>
                <div class="info-item"><div class="info-label">Year/Semester</div><div class="info-value"><%= year %> / Semester <%= semester %></div></div>
                <div class="row">
                    <div class="col-md-6"><div class="stats-card"><div class="stat-value"><%= gpa %></div><div class="stat-label">Current GPA</div></div></div>
                    <div class="col-md-6"><div class="stats-card"><div class="stat-value"><%= enrolledCourses %></div><div class="stat-label">Enrolled Courses</div></div></div>
                    <div class="col-md-6"><div class="stats-card"><div class="stat-value"><%= completedCredits %></div><div class="stat-label">Completed Credits</div></div></div>
                    <div class="col-md-6"><div class="stats-card"><div class="stat-value"><%= totalCredits %></div><div class="stat-label">Total Credits</div></div></div>
                </div>
            </div>
        </div>

        <!-- Edit Button -->
        <div class="text-end mt-4">
            <a href="AccountSettings.jsp" class="edit-btn"><i class="fas fa-edit me-1"></i> Edit Profile</a>
            
            
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.getElementById('profileImageUpload').addEventListener('change', function(e) {
            if (e.target.files.length > 0) {
                const reader = new FileReader();
                reader.onload = function(event) {
                    document.getElementById('profileImage').src = event.target.result;
                };
                reader.readAsDataURL(e.target.files[0]);
            }
        });
    </script>
</body>
</html>

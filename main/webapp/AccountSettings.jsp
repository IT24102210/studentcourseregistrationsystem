<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Complete Account Settings</title>
    <style>
        :root {
            --primary-color: #2196F3;
            --secondary-color: #f1f1f1;
            --bg-color: #2b2f32;
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

        
        /* Background effect */
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
        
        .settings-header {
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
        
        .settings-section {
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
        
        .form-group {
            margin-bottom: 20px;
        }
        
        label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: #d1d5db;
        }
        
        input, select, textarea {
            width: 100%;
            padding: 12px;
            background: var(--field-bg);
            border: 1px solid #5d646b;
            border-radius: 4px;
            box-sizing: border-box;
            font-size: 14px;
            transition: all 0.3s;
            color: var(--text-color);
        }
        
        input:focus, select:focus, textarea:focus {
            border-color: var(--primary-color);
            outline: none;
            box-shadow: 0 0 0 2px rgba(33,150,243,0.2);
        }
        
        .checkbox-group {
            margin: 15px 0;
        }
        
        .checkbox-label {
            display: flex;
            align-items: center;
            cursor: pointer;
            margin-bottom: 10px;
            color: #d1d5db;
        }
        
        .checkbox-label input {
            width: auto;
            margin-right: 10px;
        }
        
        button {
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
        
        button:hover {
            background: #1976D2;
            transform: translateY(-2px);
        }
        
        .btn-danger {
            background: var(--danger-color);
        }
        
        .btn-danger:hover {
            background: #d32f2f;
        }
        
        .success-message {
            color: #4caf50;
            margin-bottom: 20px;
            padding: 10px;
            background: rgba(76, 175, 80, 0.1);
            border-radius: 4px;
            display: none;
            border-left: 4px solid #4caf50;
        }
        
        .two-factor-box {
            border: 1px solid #5d646b;
            padding: 15px;
            border-radius: 5px;
            margin-top: 15px;
            background: var(--field-bg);
        }
        
        .language-options {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }
        
        .language-option {
            padding: 8px 15px;
            border: 1px solid #5d646b;
            border-radius: 20px;
            cursor: pointer;
            background: var(--field-bg);
            color: var(--text-color);
            transition: all 0.3s;
        }
        
        .language-option:hover {
            border-color: var(--primary-color);
        }
        
        .language-option.selected {
            background: var(--primary-color);
            color: white;
            border-color: var(--primary-color);
        }
        
        /* Floating background elements */
        .floating {
            position: absolute;
            animation: floating 9s infinite linear;
            opacity: 0.3;
            z-index: -1;
        }
        
        @keyframes floating {
            0% { transform: translate(0, 0) rotate(0deg); }
            25% { transform: translate(50px, 50px) rotate(90deg); }
            50% { transform: translate(0, 100px) rotate(180deg); }
            75% { transform: translate(-50px, 50px) rotate(270deg); }
            100% { transform: translate(0, 0) rotate(360deg); }
        }
        
        /* Modal styles */
        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.7);
            z-index: 1000;
            justify-content: center;
            align-items: center;
        }
        
        .modal-content {
            background: var(--form-bg);
            padding: 30px;
            border-radius: 8px;
            width: 400px;
            max-width: 90%;
            box-shadow: 0 0 30px rgba(0,0,0,0.5);
        }
        
        .modal h2 {
            margin-top: 0;
            color: var(--text-color);
        }
        
    </style>
</head>
<body>
    <!-- Floating background elements -->
    <div class="floating" style="top: 10%; left: 5%; width: 100px; height: 100px; background: var(--primary-color); border-radius: 50%;"></div>
    <div class="floating" style="top: 70%; left: 80%; width: 150px; height: 150px; background: var(--danger-color); border-radius: 30%; animation-delay: -5s;"></div>
    <div class="floating" style="top: 30%; left: 70%; width: 80px; height: 80px; background: #4caf50; border-radius: 20%; animation-delay: -10s;"></div>

    <div class="container">
        <%-- =============== BACKEND SIMULATION =============== --%>
        <%
            // Initialize default values
            if (session.getAttribute("username") == null) {
                session.setAttribute("username", "john_doe");
                session.setAttribute("fullName", "John Doe");
                session.setAttribute("email", "john@example.com");
                session.setAttribute("phone", "1234567890");
                session.setAttribute("department", "Computer Science");
                session.setAttribute("birthDate", "1995-05-15");
                session.setAttribute("profileImage", "default-avatar.jpg");
                session.setAttribute("emailNotifications", "true");
                session.setAttribute("showOnlineStatus", "true");
                session.setAttribute("twoFactorEnabled", "false");
                session.setAttribute("language", "en");
                session.setAttribute("theme", "dark");
            }

            // Handle form submission
            if ("POST".equals(request.getMethod())) {
                // Personal Info
                session.setAttribute("fullName", request.getParameter("fullName"));
                session.setAttribute("email", request.getParameter("email"));
                session.setAttribute("phone", request.getParameter("phone"));
                session.setAttribute("department", request.getParameter("department"));
                session.setAttribute("birthDate", request.getParameter("birthDate"));
                
                // Notification Settings
                session.setAttribute("emailNotifications", 
                    request.getParameter("emailNotifications") != null ? "true" : "false");
                session.setAttribute("showOnlineStatus", 
                    request.getParameter("showOnlineStatus") != null ? "true" : "false");
                session.setAttribute("promotionalEmails", 
                    request.getParameter("promotionalEmails") != null ? "true" : "false");
                
                // Security
                session.setAttribute("twoFactorEnabled", 
                    request.getParameter("twoFactorEnabled") != null ? "true" : "false");
                
                // Preferences
                session.setAttribute("language", request.getParameter("language"));
                session.setAttribute("theme", request.getParameter("theme"));
                
                out.println("<div class='success-message' id='successMessage'>Settings saved successfully!</div>");
            }
        %>

        <div class="settings-header">
            <div class="profile-pic-container">
                <img id="profileImage" class="profile-pic" 
                     src="<%= request.getContextPath() + "/uploads/" + 
                     (session.getAttribute("profileImage") != null ? 
                     session.getAttribute("profileImage") : "default-avatar.jpg") %>" 
                     alt="Profile Picture"
                     onerror="this.src='<%= request.getContextPath() %>/uploads/default-avatar.jpg'">
                <button class="change-photo-btn" onclick="document.getElementById('profileImageUpload').click()">
                    Change
                </button>
                <input type="file" id="profileImageUpload" accept="image/*" style="display: none;">
            </div>
            <div>
                <h1 style="margin: 0; color: var(--text-color);"><%= session.getAttribute("fullName") %></h1>
                <p style="margin: 5px 0 0; color: #a0a4a8;"><%= session.getAttribute("department") %></p>
                <p style="margin: 5px 0 0; color: #a0a4a8;"><%= session.getAttribute("email") %></p>
            </div>
        </div>

        <div id="successMessage" class="success-message"></div>

        <form method="post" enctype="multipart/form-data">
            <div class="settings-grid">
                <!-- Personal Information Section -->
                <div class="settings-section">
                    <h2 class="section-title"><i>📝</i> Personal Information</h2>
                    
                    <div class="form-group">
                        <label for="fullName">Full Name</label>
                        <input type="text" id="fullName" name="fullName" 
                               value="<%= session.getAttribute("fullName") %>" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="email">Email Address</label>
                        <input type="email" id="email" name="email" 
                               value="<%= session.getAttribute("email") %>" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="phone">Phone Number</label>
                        <input type="tel" id="phone" name="phone" 
                               value="<%= session.getAttribute("phone") %>">
                    </div>
                    
                    <div class="form-group">
                        <label for="birthDate">Date of Birth</label>
                        <input type="date" id="birthDate" name="birthDate" 
                               value="<%= session.getAttribute("birthDate") %>">
                    </div>
                    
                    <div class="form-group">
                        <label for="department">Department</label>
                        <select id="department" name="department">
                            <option value="Computer Science" <%= "Computer Science".equals(session.getAttribute("department")) ? "selected" : "" %>>Computer Science</option>
                            <option value="Electrical Engineering" <%= "Electrical Engineering".equals(session.getAttribute("department")) ? "selected" : "" %>>Electrical Engineering</option>
                            <option value="Mechanical Engineering" <%= "Mechanical Engineering".equals(session.getAttribute("department")) ? "selected" : "" %>>Mechanical Engineering</option>
                            <option value="Business Administration" <%= "Business Administration".equals(session.getAttribute("department")) ? "selected" : "" %>>Business Administration</option>
                        </select>
                    </div>
                </div>

                <!-- Security Section -->
                <div class="settings-section">
                    <h2 class="section-title"><i>🔒</i> Security</h2>
                    
                    <div class="form-group">
                        <label>Password</label>
                        <button type="button" style="width: auto;" onclick="showPasswordModal()">Change Password</button>
                    </div>
                    
                    <div class="form-group">
                        <label>Two-Factor Authentication</label>
                        <div class="checkbox-group">
                            <label class="checkbox-label">
                                <input type="checkbox" name="twoFactorEnabled" 
                                       <%= "true".equals(session.getAttribute("twoFactorEnabled")) ? "checked" : "" %>>
                                Enable Two-Factor Authentication
                            </label>
                        </div>
                        <div class="two-factor-box" style="display: <%= "true".equals(session.getAttribute("twoFactorEnabled")) ? "block" : "none" %>;">
                            <p>Scan this QR code with your authenticator app:</p>
                            <div style="background: var(--field-bg); padding: 10px; text-align: center; margin: 10px 0;">
                                <!-- Placeholder for QR code -->
                                <div style="width: 150px; height: 150px; margin: 0 auto; background: #5d646b; display: flex; align-items: center; justify-content: center; color: var(--text-color);">
                                    QR Code
                                </div>
                            </div>
                            <p>Or enter this code manually: <strong>JBSWY3DPEHPK3PXP</strong></p>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label>Active Sessions</label>
                        <div style="background: var(--field-bg); border: 1px solid #5d646b; padding: 10px; border-radius: 4px;">
                            <p><strong>Current Session</strong> - Chrome on Windows (10.0.0.1)</p>
                            <p><strong>Last Session</strong> - Firefox on Mac (10.0.0.2) - 2 days ago</p>
                            <button type="button" class="btn-danger" style="margin-top: 10px;">Log Out Other Devices</button>
                        </div>
                    </div>
                </div>

                <!-- Notification Settings -->
                <div class="settings-section">
                    <h2 class="section-title"><i>🔔</i> Notifications</h2>
                    
                    <div class="checkbox-group">
                        <label class="checkbox-label">
                            <input type="checkbox" name="emailNotifications" 
                                   <%= "true".equals(session.getAttribute("emailNotifications")) ? "checked" : "" %>>
                            Email Notifications
                        </label>
                    </div>
                    
                    <div class="checkbox-group">
                        <label class="checkbox-label">
                            <input type="checkbox" name="showOnlineStatus" 
                                   <%= "true".equals(session.getAttribute("showOnlineStatus")) ? "checked" : "" %>>
                            Show Online Status
                        </label>
                    </div>
                    
                    <div class="checkbox-group">
                        <label class="checkbox-label">
                            <input type="checkbox" name="promotionalEmails" 
                                   <%= "true".equals(session.getAttribute("promotionalEmails")) ? "checked" : "" %>>
                            Receive Promotional Emails
                        </label>
                    </div>
                    
                    <div class="form-group">
                        <label>Notification Sound</label>
                        <select>
                            <option>Default</option>
                            <option>Chime</option>
                            <option>Bell</option>
                            <option>None</option>
                        </select>
                    </div>
                </div>

                <!-- Preferences -->
                <div class="settings-section">
                    <h2 class="section-title"><i>⚙️</i> Preferences</h2>
                    
                    <div class="form-group">
                        <label>Language</label>
                        <div class="language-options">
                            <div class="language-option <%= "en".equals(session.getAttribute("language")) ? "selected" : "" %>" onclick="selectLanguage('en')">
                                English
                            </div>
                            <div class="language-option <%= "es".equals(session.getAttribute("language")) ? "selected" : "" %>" onclick="selectLanguage('es')">
                                Español
                            </div>
                            <div class="language-option <%= "fr".equals(session.getAttribute("language")) ? "selected" : "" %>" onclick="selectLanguage('fr')">
                                Français
                            </div>
                            <input type="hidden" id="language" name="language" value="<%= session.getAttribute("language") %>">
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label>Theme</label>
                        <select name="theme">
                            <option value="light" <%= "light".equals(session.getAttribute("theme")) ? "selected" : "" %>>Light</option>
                            <option value="dark" <%= "dark".equals(session.getAttribute("theme")) ? "selected" : "" %>>Dark</option>
                            <option value="system" <%= "system".equals(session.getAttribute("theme")) ? "selected" : "" %>>System Default</option>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label>Time Zone</label>
                        <select>
                            <option>(GMT-08:00) Pacific Time</option>
                            <option>(GMT-05:00) Eastern Time</option>
                            <option>(GMT+00:00) London</option>
                            <option>(GMT+01:00) Paris</option>
                        </select>
                    </div>
                </div>
            </div>

            <!-- Danger Zone -->
            <div class="settings-section" style="grid-column: span 2; border-color: #5d1f1f; background: #3a2a2a;">
                <h2 class="section-title" style="color: var(--danger-color);"><i>⚠️</i> Danger Zone</h2>
                
                <div class="form-group">
                    <label>Delete Account</label>
                    <p>Permanently delete your account and all associated data</p>
                    <button type="button" class="btn-danger" onclick="showDeleteAccountModal()">Delete Account</button>
                </div>
                
                <div class="form-group">
                    <label>Export Data</label>
                    <p>Download all your data in a ZIP file</p>
                    <button type="button">Export Data</button>
                </div>
            </div>

            <div style="grid-column: span 2; text-align: right;">
                <button type="submit" style="padding: 12px 30px;">Save All Changes</button>
            </div>
        </form>
    </div>

    <!-- Password Change Modal -->
    <div id="passwordModal" class="modal">
        <div class="modal-content">
            <h2>Change Password</h2>
            <div class="form-group">
                <label for="currentPasswordModal">Current Password</label>
                <input type="password" id="currentPasswordModal">
            </div>
            <div class="form-group">
                <label for="newPasswordModal">New Password</label>
                <input type="password" id="newPasswordModal">
            </div>
            <div class="form-group">
                <label for="confirmPasswordModal">Confirm New Password</label>
                <input type="password" id="confirmPasswordModal">
            </div>
            <div style="display: flex; justify-content: flex-end; gap: 10px;">
                <button type="button" onclick="document.getElementById('passwordModal').style.display = 'none'">Cancel</button>
                <button type="button" onclick="changePassword()">Change Password</button>
            </div>
        </div>
    </div>

    <script>
        // Profile image upload preview
        document.getElementById('profileImageUpload').addEventListener('change', function(e) {
            if (e.target.files.length > 0) {
                const reader = new FileReader();
                reader.onload = function(event) {
                    document.getElementById('profileImage').src = event.target.result;
                };
                reader.readAsDataURL(e.target.files[0]);
            }
        });

        // Show success message if present
        if (document.getElementById('successMessage') && 
            document.getElementById('successMessage').innerHTML.trim() !== '') {
            document.getElementById('successMessage').style.display = 'block';
            setTimeout(() => {
                document.getElementById('successMessage').style.display = 'none';
            }, 3000);
        }

        // Two-factor authentication toggle
        document.querySelector('input[name="twoFactorEnabled"]').addEventListener('change', function() {
            document.querySelector('.two-factor-box').style.display = this.checked ? 'block' : 'none';
        });

        // Language selection
        function selectLanguage(lang) {
            document.querySelectorAll('.language-option').forEach(el => {
                el.classList.remove('selected');
            });
            event.target.classList.add('selected');
            document.getElementById('language').value = lang;
        }

        // Password modal
        function showPasswordModal() {
            document.getElementById('passwordModal').style.display = 'flex';
        }

        function changePassword() {
            const current = document.getElementById('currentPasswordModal').value;
            const newPass = document.getElementById('newPasswordModal').value;
            const confirm = document.getElementById('confirmPasswordModal').value;
            
            if (newPass !== confirm) {
                alert('New passwords do not match!');
                return;
            }
            
            if (newPass.length < 8) {
                alert('Password must be at least 8 characters!');
                return;
            }
            
            // In a real app, you would send this to the server
            alert('Password changed successfully!');
            document.getElementById('passwordModal').style.display = 'none';
        }

        function showDeleteAccountModal() {
            if (confirm('Are you sure you want to delete your account? This cannot be undone!')) {
                alert('Account deletion requested. In a real app, this would trigger deletion.');
            }
        }
    </script>
</body>
</html>
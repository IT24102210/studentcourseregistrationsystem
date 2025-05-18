<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EduEnroll - Student Enrollment System</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Custom CSS -->
    <style>
        .hero-section {
            background: linear-gradient(rgba(0, 0, 0, 0.6), rgba(0, 0, 0, 0.6)), url('https://images.unsplash.com/photo-1523050854058-8df90110c9f1?ixlib=rb-4.0.3');
            background-size: cover;
            background-position: center;
            color: white;
            padding: 100px 0;
            margin-bottom: 30px;
        }
        .feature-box {
            padding: 20px;
            border-radius: 5px;
            margin-bottom: 20px;
            transition: transform 0.3s;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
        .feature-box:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.1);
        }
        .custom-navbar {
            padding: 15px 0;
        }
        footer {
            background-color: #343a40;
            color: white;
            padding: 30px 0;
            margin-top: 50px;
        }
        .login-buttons .btn {
            margin-left: 8px;
        }
        .role-tab-content {
            padding: 20px 0;
        }
        .currentDateTime {
            font-size: 0.8rem;
            color: #6c757d;
        }
        .student-id {
            font-weight: bold;
            color: #17a2b8;
        }
        /* Real-time display styles */
        .time-display {
            font-family: monospace;
            background-color: rgba(0, 123, 255, 0.15);
            padding: 6px 10px;
            border-radius: 4px;
            color: #0d6efd;
            border: 1px solid rgba(0, 123, 255, 0.2);
            font-weight: 500;
            display: inline-block;
        }
    </style>
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark custom-navbar">
        <div class="container">
            <a class="navbar-brand" href="#">
                <strong>EduEnroll</strong>
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarSupportedContent">
                <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                    <li class="nav-item">
                        <a class="nav-link active" href="#">Home</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#">Courses</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#">Programs</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#">About</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#">Contact</a>
                    </li>
                </ul>
                <div class="d-flex login-buttons">
                    <button class="btn btn-outline-info me-2" data-bs-toggle="modal" data-bs-target="#studentLoginModal">Student Login</button>
                    <button class="btn btn-outline-warning me-2" data-bs-toggle="modal" data-bs-target="#teacherLoginModal">Teacher Login</button>
                    <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#signupModal">Student Sign Up</button>
                </div>
            </div>
        </div>
    </nav>

    <!-- Hero Section -->
    <section class="hero-section text-center">
        <div class="container">
            <h1 class="display-4 fw-bold">Welcome to EduEnroll</h1>
            <p class="lead mb-4">The complete student enrollment system for academic excellence</p>
            <div class="mb-3">
                <strong>Current Date and Time (UTC - YYYY-MM-DD HH:MM:SS formatted):</strong> 
                <span class="time-display" id="headerDateTime">2025-05-11 21:33:20</span>
            </div>
            <div class="mb-4">
                <span class="badge bg-info">Current User's Login: IT24103866</span>
            </div>
            
            <div>
                <button class="btn btn-primary btn-lg px-4 me-2" data-bs-toggle="modal" data-bs-target="#signupModal">Register Now</button>
                <button class="btn btn-outline-light btn-lg px-4">Explore Courses</button>
            </div>
        </div>
    </section>

    <!-- Features Section -->
    <section class="py-5">
        <div class="container">
            <div class="text-center mb-5">
                <h2 class="fw-bold">Features & Benefits</h2>
                <p class="text-muted">Making education management seamless for students and teachers</p>
            </div>
            <div class="row">
                <div class="col-md-4">
                    <div class="feature-box bg-light">
                        <div class="text-primary mb-3">
                            <i class="fas fa-graduation-cap fa-3x"></i>
                        </div>
                        <h5 class="fw-bold">For Students</h5>
                        <ul class="text-muted">
                            <li>Easy course registration</li>
                            <li>Access to learning materials</li>
                            <li>Grade tracking and progress reports</li>
                            <li>Schedule management</li>
                        </ul>
                        <div class="d-grid gap-2 mt-3">
                            <button class="btn btn-outline-primary" data-bs-toggle="modal" data-bs-target="#studentLoginModal">Student Login</button>
                            <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#signupModal">Sign Up</button>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="feature-box bg-light">
                        <div class="text-warning mb-3">
                            <i class="fas fa-chalkboard-teacher fa-3x"></i>
                        </div>
                        <h5 class="fw-bold">For Teachers</h5>
                        <ul class="text-muted">
                            <li>Course management tools</li>
                            <li>Attendance tracking</li>
                            <li>Grade submission system</li>
                            <li>Communication with students</li>
                        </ul>
                        <div class="d-grid mt-3">
                            <button class="btn btn-outline-warning" data-bs-toggle="modal" data-bs-target="#teacherLoginModal">Teacher Login</button>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="feature-box bg-light">
                        <div class="text-success mb-3">
                            <i class="fas fa-chart-line fa-3x"></i>
                        </div>
                        <h5 class="fw-bold">Institutional Benefits</h5>
                        <ul class="text-muted">
                            <li>Centralized data management</li>
                            <li>Automated enrollment processes</li>
                            <li>Analytics and reporting</li>
                            <li>Integration with other systems</li>
                        </ul>
                        <button class="btn btn-outline-success mt-3">Learn More</button>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Call to Action -->
    <section class="bg-primary text-white text-center py-5">
        <div class="container">
            <h2 class="fw-bold">Join Our Academic Community</h2>
            <p class="lead mb-4">Register today to access all features of our enrollment system</p>
            <div class="d-flex justify-content-center">
                <button class="btn btn-light me-2" data-bs-toggle="modal" data-bs-target="#studentLoginModal">Student Login</button>
                <button class="btn btn-warning text-dark me-2" data-bs-toggle="modal" data-bs-target="#teacherLoginModal">Teacher Login</button>
                <button class="btn btn-success" data-bs-toggle="modal" data-bs-target="#signupModal">Student Sign Up</button>
            </div>
        </div>
    </section>

    <!-- Upcoming Courses Section -->
    <section class="py-5 bg-light">
        <div class="container">
            <div class="text-center mb-5">
                <h2 class="fw-bold">Featured Courses</h2>
                <p class="text-muted">Explore our popular academic offerings</p>
            </div>
            <div class="row">
                <div class="col-md-4 mb-4">
                    <div class="card h-100">
                        <img src="https://via.placeholder.com/350x200?text=Computer+Science" class="card-img-top" alt="Computer Science">
                        <div class="card-body">
                            <h5 class="card-title">Introduction to Programming</h5>
                            <p class="card-text">Learn the fundamentals of programming with Python and Java.</p>
                            <div class="d-flex justify-content-between align-items-center">
                                <span class="badge bg-info">CS101</span>
                                <span class="text-muted">Credits: 4</span>
                            </div>
                        </div>
                        <div class="card-footer bg-transparent">
                            <button class="btn btn-sm btn-outline-primary">View Details</button>
                        </div>
                    </div>
                </div>
                <div class="col-md-4 mb-4">
                    <div class="card h-100">
                        <img src="https://via.placeholder.com/350x200?text=Business" class="card-img-top" alt="Business">
                        <div class="card-body">
                            <h5 class="card-title">Business Ethics</h5>
                            <p class="card-text">Explore ethical principles and practices in modern business.</p>
                            <div class="d-flex justify-content-between align-items-center">
                                <span class="badge bg-warning text-dark">BUS205</span>
                                <span class="text-muted">Credits: 3</span>
                            </div>
                        </div>
                        <div class="card-footer bg-transparent">
                            <button class="btn btn-sm btn-outline-primary">View Details</button>
                        </div>
                    </div>
                </div>
                <div class="col-md-4 mb-4">
                    <div class="card h-100">
                        <img src="https://via.placeholder.com/350x200?text=Engineering" class="card-img-top" alt="Engineering">
                        <div class="card-body">
                            <h5 class="card-title">Circuit Design</h5>
                            <p class="card-text">Fundamentals of electronic circuit design and analysis.</p>
                            <div class="d-flex justify-content-between align-items-center">
                                <span class="badge bg-danger">ENG310</span>
                                <span class="text-muted">Credits: 4</span>
                            </div>
                        </div>
                        <div class="card-footer bg-transparent">
                            <button class="btn btn-sm btn-outline-primary">View Details</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <footer>
        <div class="container">
            <div class="row">
                <div class="col-md-4 mb-4 mb-md-0">
                    <h5 class="fw-bold">EduEnroll</h5>
                    <p class="text-muted">The comprehensive student enrollment and academic management system.</p>
                    <div>
                        <strong>Current Date and Time (UTC - YYYY-MM-DD HH:MM:SS formatted):</strong>
                        <span class="time-display" id="footerDateTime">2025-05-11 21:33:20</span>
                    </div>
                    <p class="student-id">Current User's Login: IT24103866</p>
                </div>
                <div class="col-md-2 mb-4 mb-md-0">
                    <h5 class="fw-bold">Quick Links</h5>
                    <ul class="list-unstyled">
                        <li><a href="#" class="text-decoration-none text-muted">Home</a></li>
                        <li><a href="#" class="text-decoration-none text-muted">Courses</a></li>
                        <li><a href="#" class="text-decoration-none text-muted">Programs</a></li>
                        <li><a href="#" class="text-decoration-none text-muted">About</a></li>
                    </ul>
                </div>
                <div class="col-md-2 mb-4 mb-md-0">
                    <h5 class="fw-bold">Resources</h5>
                    <ul class="list-unstyled">
                        <li><a href="#" class="text-decoration-none text-muted">Help Center</a></li>
                        <li><a href="#" class="text-decoration-none text-muted">Student Guide</a></li>
                        <li><a href="#" class="text-decoration-none text-muted">Teacher Portal</a></li>
                        <li><a href="#" class="text-decoration-none text-muted">FAQ</a></li>
                    </ul>
                </div>
                <div class="col-md-4">
                    <h5 class="fw-bold">Contact Us</h5>
                    <p class="text-muted">Have questions or need assistance?</p>
                    <div class="input-group mb-3">
                        <input type="email" class="form-control" placeholder="Your Email">
                        <button class="btn btn-outline-light" type="button">Contact</button>
                    </div>
                    <div class="d-flex mt-3">
                        <a href="#" class="text-light me-3"><i class="fab fa-facebook-f"></i></a>
                        <a href="#" class="text-light me-3"><i class="fab fa-twitter"></i></a>
                        <a href="#" class="text-light me-3"><i class="fab fa-linkedin-in"></i></a>
                        <a href="#" class="text-light"><i class="fab fa-instagram"></i></a>
                    </div>
                </div>
            </div>
            <hr class="my-4 bg-light">
            <div class="text-center text-muted">
                <p>&copy; 2025 EduEnroll. All rights reserved.</p>
            </div>
        </div>
    </footer>

    <!-- Student Login Modal -->
    <div class="modal fade" id="studentLoginModal" tabindex="-1" aria-labelledby="studentLoginModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header bg-info bg-opacity-10">
                    <h5 class="modal-title" id="studentLoginModalLabel">Student Login</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form action="studentLogin" method="post">
                        <div class="text-center mb-4">
                            <i class="fas fa-user-graduate fa-3x text-info mb-3"></i>
                            <h5>Welcome back, Student!</h5>
                            <p class="text-muted">Access your courses and academic information</p>
                            <div class="d-inline-block mb-2">
                                <span class="time-display modalDateTime">2025-05-11 21:33:20</span>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label for="studentId" class="form-label">Username</label>
                            <input type="text" class="form-control" id="studentId" name="studentName" placeholder="Enter your username" required>
                            <div class="form-text">Enter the username you registered with</div>
                        </div>
                        <div class="mb-3">
                            <label for="studentPassword" class="form-label">Password</label>
                            <input type="password" class="form-control" id="studentPassword" name="password" required>
                        </div>
                        <div class="mb-3 form-check">
                            <input type="checkbox" class="form-check-input" id="studentRememberMe" name="rememberMe">
                            <label class="form-check-label" for="studentRememberMe">Remember me</label>
                        </div>
                        <div class="d-grid">
                            <button type="submit" class="btn btn-info">Login as Student</button>
                        </div>
                        <div class="text-center mt-3">
                            <a href="#" class="text-decoration-none">Forgot password?</a>
                            <p class="mt-3 mb-0">Don't have an account? <a href="#" data-bs-toggle="modal" data-bs-target="#signupModal" data-bs-dismiss="modal">Sign up</a></p>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- Teacher Login Modal -->
    <div class="modal fade" id="teacherLoginModal" tabindex="-1" aria-labelledby="teacherLoginModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header bg-warning bg-opacity-10">
                    <h5 class="modal-title" id="teacherLoginModalLabel">Teacher Login</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form action="teacherLogin" method="post">
                        <div class="text-center mb-4">
                            <i class="fas fa-chalkboard-teacher fa-3x text-warning mb-3"></i>
                            <h5>Welcome back, Teacher!</h5>
                            <p class="text-muted">Access your course management dashboard</p>
                            <div class="d-inline-block mb-2">
                                <span class="time-display modalDateTime">2025-05-11 21:33:20</span>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label for="teacherId" class="form-label">Teacher ID</label>
                            <input type="text" class="form-control" id="teacherId" name="teacherId" placeholder="Enter your teacher ID" required>
                        </div>
                        <div class="mb-3">
                            <label for="teacherPassword" class="form-label">Password</label>
                            <input type="password" class="form-control" id="teacherPassword" name="password" required>
                        </div>
                        <div class="mb-3 form-check">
                            <input type="checkbox" class="form-check-input" id="teacherRememberMe" name="rememberMe">
                            <label class="form-check-label" for="teacherRememberMe">Remember me</label>
                        </div>
                        <div class="d-grid">
                            <button type="submit" class="btn btn-warning">Login as Teacher</button>
                        </div>
                        <div class="text-center mt-3">
                            <a href="#" class="text-decoration-none">Forgot password?</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- Student Signup Modal -->
    <div class="modal fade" id="signupModal" tabindex="-1" aria-labelledby="signupModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header bg-primary bg-opacity-10">
                    <h5 class="modal-title" id="signupModalLabel">Student Registration</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form action="studentSignup" method="post" id="studentRegistrationForm">
                        <input type="hidden" name="userType" value="student">
                        <!-- Hidden field to store registration timestamp -->
                        <input type="hidden" id="registrationTimestamp" name="registrationTimestamp" value="2025-05-11 21:33:20">
                        
                        <div class="text-center mb-4">
                            <i class="fas fa-user-plus fa-3x text-primary mb-3"></i>
                            <h5>Create Student Account</h5>
                            <p class="text-muted mb-2">Join our academic community</p>
                            <div class="mb-3">
                                <div>Current Registration Time:</div>
                                <div class="time-display" id="registrationTimeDisplay">2025-05-11 21:33:20</div>
                                <small class="text-muted d-block mt-1">This exact time will be recorded with your registration</small>
                            </div>
                        </div>
                        
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="studentFirstName" class="form-label">First Name</label>
                                <input type="text" class="form-control" id="studentFirstName" name="firstName" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="studentLastName" class="form-label">Last Name</label>
                                <input type="text" class="form-control" id="studentLastName" name="lastName" required>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label for="studentUsername" class="form-label">Username</label>
                            <input type="text" class="form-control" id="studentUsername" name="studentName" placeholder="Choose a username" required>
                            <div class="form-text">This will be used for login</div>
                        </div>
                        <div class="mb-3">
                            <label for="studentEmail" class="form-label">Email Address</label>
                            <input type="email" class="form-control" id="studentEmail" name="email" required>
                        </div>
                        <div class="mb-3">
                            <label for="studentNewPassword" class="form-label">Password</label>
                            <input type="password" class="form-control" id="studentNewPassword" name="password" required>
                        </div>
                        <div class="mb-3">
                            <label for="studentConfirmPassword" class="form-label">Confirm Password</label>
                            <input type="password" class="form-control" id="studentConfirmPassword" name="confirmPassword" required>
                        </div>
                        <div class="mb-3">
                            <label for="studentDepartment" class="form-label">Department/Major</label>
                            <select class="form-select" id="studentDepartment" name="department" required>
                                <option value="" selected disabled>Select your department</option>
                                <option value="computer_science">Computer Science</option>
                                <option value="engineering">Engineering</option>
                                <option value="business">Business</option>
                                <option value="arts">Arts & Humanities</option>
                                <option value="science">Science</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label for="studentEnrollmentYear" class="form-label">Enrollment Year</label>
                            <select class="form-select" id="studentEnrollmentYear" name="enrollmentYear" required>
                                <option value="" selected disabled>Select year</option>
                                <option value="2025">2025</option>
                                <option value="2024">2024</option>
                                <option value="2023">2023</option>
                                <option value="2022">2022</option>
                            </select>
                        </div>
                        <div class="mb-3 form-check">
                            <input type="checkbox" class="form-check-input" id="studentTermsCheck" required>
                            <label class="form-check-label" for="studentTermsCheck">I agree to the <a href="#">Terms & Conditions</a></label>
                        </div>
                        <div class="d-grid">
                            <button type="submit" class="btn btn-primary" id="registerButton">Register as Student</button>
                        </div>
                    </form>
                </div>
                <div class="modal-footer justify-content-center">
                    <p class="text-muted">Already have an account? 
                        <a href="#" data-bs-toggle="modal" data-bs-target="#studentLoginModal" data-bs-dismiss="modal">Login</a>
                    </p>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <!-- Font Awesome for icons -->
    <script src="https://kit.fontawesome.com/a076d05399.js" crossorigin="anonymous"></script>
    
    <!-- Updated Real-Time Clock Script -->
    <script>
    // Initial timestamp - Updated to match the current time provided
    var currentTime = "2025-05-11 21:33:20";
    
    // Function to update all time displays
    function updateClocks() {
        try {
            // Update all displayed times
            document.getElementById("headerDateTime").innerHTML = currentTime;
            document.getElementById("footerDateTime").innerHTML = currentTime;
            
            // Update registration displays if they exist
            var regTimeDisplay = document.getElementById("registrationTimeDisplay");
            if (regTimeDisplay) {
                regTimeDisplay.innerHTML = currentTime;
            }
            
            var regTimestamp = document.getElementById("registrationTimestamp");
            if (regTimestamp) {
                regTimestamp.value = currentTime;
            }
            
            // Update all modal times
            var modalTimes = document.getElementsByClassName("modalDateTime");
            for (var i = 0; i < modalTimes.length; i++) {
                modalTimes[i].innerHTML = currentTime;
            }
            
            // Advance time by 1 second
            currentTime = advanceTimeByOneSecond(currentTime);
        } catch (err) {
            console.error("Error updating clocks:", err);
        }
    }
    
    // Function to advance time by one second
    function advanceTimeByOneSecond(timeStr) {
        try {
            // Parse time components
            var year = parseInt(timeStr.substring(0, 4));
            var month = parseInt(timeStr.substring(5, 7)) - 1; // JS months are 0-based
            var day = parseInt(timeStr.substring(8, 10));
            var hour = parseInt(timeStr.substring(11, 13));
            var minute = parseInt(timeStr.substring(14, 16));
            var second = parseInt(timeStr.substring(17, 19));
            
            // Create date object
            var date = new Date(year, month, day, hour, minute, second);
            
            // Add one second
            date.setSeconds(date.getSeconds() + 1);
            
            // Format back to string (YYYY-MM-DD HH:MM:SS)
            var newYear = date.getFullYear();
            var newMonth = (date.getMonth() + 1).toString().padStart(2, "0");
            var newDay = date.getDate().toString().padStart(2, "0");
            var newHour = date.getHours().toString().padStart(2, "0");
            var newMinute = date.getMinutes().toString().padStart(2, "0");
            var newSecond = date.getSeconds().toString().padStart(2, "0");
            
            return newYear + "-" + newMonth + "-" + newDay + " " + newHour + ":" + newMinute + ":" + newSecond;
        } catch (err) {
            console.error("Error advancing time:", err);
            return timeStr; // Return original if error occurs
        }
    }
    
    // Wait for DOM to be fully loaded
    document.addEventListener("DOMContentLoaded", function() {
        console.log("DOM fully loaded - starting clock");
        
        // Update clock immediately when page loads
        updateClocks();
        
        // Set interval to update clock every second
        setInterval(updateClocks, 1000);
        
        // REMOVE THE FORM SUBMISSION PREVENTION CODE
        // We're not preventing form submission anymore to allow proper redirect
        // The form will naturally submit to the server when the button is clicked
    });
    </script>
</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Signup - ChatSphere</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700&display=swap" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Poppins', sans-serif;
        }
        body {
            background: #e5ddd5;
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }
        .signup-container {
            width: 100%;
            max-width: 450px;
            background: #ffffff;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.15);
            padding: 40px;
            animation: slideUp 0.5s ease-out;
        }
        .signup-header h2 {
            font-size: 32px;
            font-weight: 700;
            color: #075e54;
            text-align: center;
            margin-bottom: 30px;
        }
        .form-group {
            margin-bottom: 20px;
        }
        .form-group label {
            font-size: 14px;
            font-weight: 600;
            color: #128c7e;
            margin-bottom: 8px;
            display: block;
        }
        .form-group input {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e6e6e6;
            border-radius: 10px;
            font-size: 16px;
            outline: none;
            transition: border-color 0.3s ease, box-shadow 0.3s ease;
        }
        .form-group input:focus {
            border-color: #075e54;
            box-shadow: 0 0 8px rgba(7, 94, 84, 0.2);
        }
        .signup-btn {
            width: 100%;
            padding: 14px;
            background: linear-gradient(90deg, #128c7e 0%, #075e54 100%);
            color: #ffffff;
            border: none;
            border-radius: 10px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: transform 0.2s ease, box-shadow 0.3s ease;
        }
        .signup-btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(7, 94, 84, 0.4);
        }
        .login-link {
            text-align: center;
            margin-top: 20px;
            font-size: 14px;
            color: #6b7280;
        }
        .login-link a {
            color: #128c7e;
            font-weight: 600;
            text-decoration: none;
        }
        .login-link a:hover {
            text-decoration: underline;
        }
        @keyframes slideUp {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>
<body>
    <div class="signup-container">
        <div class="signup-header">
            <h2>Join ChatSphere</h2>
        </div>
        <form id="signupForm" onsubmit="return handleSignup(event)">
            <div class="form-group">
                <label for="name">Full Name</label>
                <input type="text" id="name" name="name" placeholder="Enter your full name" required>
            </div>
            <div class="form-group">
                <label for="username">Username</label>
                <input type="text" id="username" name="username" placeholder="Choose a username" required>
            </div>
            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" placeholder="Create a password" required>
            </div>
            <button type="submit" class="signup-btn">Sign Up</button>
        </form>
        <div class="login-link">
            Already have an account? <a href="login.jsp">Login</a>
        </div>
    </div>

    <script>
        async function handleSignup(event) {
            event.preventDefault();

            const name = document.getElementById('name').value.trim();
            const username = document.getElementById('username').value.trim();
            const password = document.getElementById('password').value.trim();
            const contextPath = '<%= request.getContextPath() %>';

            const formData = new URLSearchParams();
            formData.append('name', name);
            formData.append('username', username);
            formData.append('password', password);

            try {
                const response = await fetch(`${contextPath}/api/signup`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: formData.toString(),
                });

                const result = await response.json();

                if (response.ok && result.success) {
                    alert(result.message); // or show on page
                    window.location.href = `${contextPath}/login.jsp`;
                } else {
                    alert(result.message || 'Signup failed. Please try again.');
                }
            } catch (error) {
                alert('Server error. Please try again later.');
                console.error('Signup error:', error);
            }

            return false;
        }
    </script>

</body>
</html>
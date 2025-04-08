<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login - ChatSphere</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700&display=swap" rel="stylesheet">
    <style>
        /* CSS remains unchanged */
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Poppins', sans-serif; }
        body {
            background: #e5ddd5;
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }
        .login-container {
            width: 100%;
            max-width: 450px;
            background: #ffffff;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.15);
            padding: 40px;
            animation: slideUp 0.5s ease-out;
        }
        .login-header h2 {
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
        .login-btn {
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
        .login-btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(7, 94, 84, 0.4);
        }
        .signup-link {
            text-align: center;
            margin-top: 20px;
            font-size: 14px;
            color: #6b7280;
        }
        .signup-link a {
            color: #128c7e;
            font-weight: 600;
            text-decoration: none;
        }
        .signup-link a:hover {
            text-decoration: underline;
        }
        .error-message {
            color: #e63946;
            font-size: 14px;
            text-align: center;
            margin-bottom: 20px;
            display: none;
            background: #ffe6e6;
            padding: 10px;
            border-radius: 8px;
        }
        @keyframes slideUp {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>
<body>
    <div class="login-container">
        <div class="login-header">
            <h2>Login to ChatSphere</h2>
        </div>
        <div id="errorMessage" class="error-message"></div>
        <form id="loginForm" onsubmit="return handleLogin(event)">
            <div class="form-group">
                <label for="username">Username</label>
                <input type="text" id="username" name="username" placeholder="Enter your username" required>
            </div>
            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" placeholder="Enter your password" required>
            </div>
            <button type="submit" class="login-btn">Login</button>
        </form>
        <div class="signup-link">
            Don’t have an account? <a href="signup.jsp">Sign Up</a>
        </div>
    </div>

    <script>
        async function handleLogin(event) {
            event.preventDefault();
            const username = document.getElementById("username").value;
            const password = document.getElementById("password").value;
            const errorMessage = document.getElementById("errorMessage");

            try {
                const response = await fetch("<%=request.getContextPath()%>/api/login", {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/x-www-form-urlencoded"
                    },
                    body: new URLSearchParams({
                        username: username,
                        password: password
                    })
                });

                const data = await response.json();

                if (response.ok && data.success) {
                    // Store session data (optional)
                    localStorage.setItem("name", data.name);
                    localStorage.setItem("username", data.username);
                    // Redirect to home
                    window.location.href = "home.jsp";
                } else {
                    errorMessage.style.display = "block";
                    errorMessage.textContent = data.message || "Login failed.";
                    setTimeout(() => errorMessage.style.display = "none", 4000);
                }
            } catch (error) {
                errorMessage.style.display = "block";
                errorMessage.textContent = "An error occurred. Please try again.";
                console.error("Login error:", error);
                setTimeout(() => errorMessage.style.display = "none", 4000);
            }

            return false;
        }
    </script>
</body>
</html>

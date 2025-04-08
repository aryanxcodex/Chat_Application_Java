<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Chat Room - ChatSphere</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700&display=swap" rel="stylesheet">
    <style>
        * {
            box-sizing: border-box;
            font-family: 'Poppins', sans-serif;
        }
        body {
            background: #e5ddd5;
            margin: 0;
            padding: 20px;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }
        .chat-container {
            width: 100%;
            max-width: 1000px;
            height: 750px;
            background: #ffffff;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.15);
            overflow: hidden;
            display: flex;
            flex-direction: column;
        }
        .chat-header {
            background: linear-gradient(90deg, #128c7e 0%, #075e54 100%);
            color: white;
            padding: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .chat-header h2 {
            font-size: 20px;
            font-weight: 600;
        }
        .input-fields {
            display: flex;
            gap: 10px;
            padding: 15px;
            background: #f0f2f5;
        }
        .input-fields input {
            padding: 10px;
            flex: 1;
            border-radius: 8px;
            border: 1px solid #ccc;
            font-size: 14px;
        }
        .input-fields button {
            padding: 10px 20px;
            background: #128c7e;
            color: white;
            border: none;
            border-radius: 8px;
            cursor: pointer;
        }
        .chat-messages {
            flex: 1;
            padding: 20px;
            overflow-y: auto;
            background: url('https://whatsapp-clone-bg.netlify.app/chat-bg.png') repeat;
            background-size: contain;
        }
        .message {
            margin: 10px 0;
            padding: 12px 18px;
            border-radius: 10px;
            max-width: 70%;
            font-size: 15px;
            position: relative;
            animation: fadeIn 0.3s ease;
            line-height: 1.4;
        }
        .sent {
            background: #dcf8c6;
            color: #075e54;
            margin-left: auto;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        .received {
            background: #ffffff;
            color: #075e54;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        .system {
            color: gray;
            font-style: italic;
            text-align: center;
        }
        .message::after {
            content: '';
            position: absolute;
            width: 0;
            height: 0;
            border: 8px solid transparent;
        }
        .sent::after {
            border-left-color: #dcf8c6;
            right: -8px;
            top: 50%;
            transform: translateY(-50%);
        }
        .received::after {
            border-right-color: #ffffff;
            left: -8px;
            top: 50%;
            transform: translateY(-50%);
        }
        .chat-input-area {
            padding: 15px 20px;
            background: #f0f2f5;
            display: flex;
            align-items: center;
            gap: 15px;
        }
        .chat-input {
            flex: 1;
            padding: 12px 20px;
            border-radius: 25px;
            font-size: 15px;
            border: none;
            outline: none;
            background: white;
        }
        .send-button {
            background: #128c7e;
            color: white;
            border: none;
            border-radius: 50%;
            width: 50px;
            height: 50px;
            font-size: 20px;
            display: flex;
            justify-content: center;
            align-items: center;
            cursor: pointer;
        }
        #typingIndicator {
            font-style: italic;
            font-size: 13px;
            padding-left: 20px;
            color: #666;
            height: 20px;
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>
<body>
    <div class="chat-container">
        <div class="chat-header">
            <h2>💬 Join a Chat Room</h2>
        </div>
        <div class="input-fields" id="connectArea">
            <input type="text" id="username" placeholder="Your name e.g. Aryan">
            <input type="text" id="room" placeholder="Room name e.g. room1">
            <button onclick="connect()">Connect</button>
        </div>

        <div class="chat-messages" id="chatLog" style="display:none;"></div>
        <div id="typingIndicator"></div>
        <div class="chat-input-area" id="chatControls" style="display:none;">
            <input type="text" class="chat-input" id="message" placeholder="Type a message" oninput="sendTyping()" />
            <button class="send-button" onclick="send()">➤</button>
        </div>
    </div>

    <script>
    const username = localStorage.getItem('loggedInUsername') || localStorage.getItem('username');
    if(!username){
        window.location.href = 'login.jsp';
    }
        let socket;
        let username;
        let typingTimeout;

        function connect() {
            const room = document.getElementById("room").value.trim();
            username = document.getElementById("username").value.trim();

            if (!room || !username) return alert("Please enter both username and room name");

            socket = new WebSocket("ws://" + window.location.host + "<%= request.getContextPath() %>/chat/" + room + "?username=" + encodeURIComponent(username));

            socket.onopen = () => {
                document.getElementById("connectArea").style.display = "none";
                document.getElementById("chatLog").style.display = "block";
                document.getElementById("chatControls").style.display = "flex";
            };

            socket.onmessage = (event) => {
                const message = event.data;
                const chatLog = document.getElementById("chatLog");
                const typingIndicator = document.getElementById("typingIndicator");

                if (message.startsWith("[TYPING]")) {
                    const typer = message.substring(8);
                    if (typer !== username) {
                        typingIndicator.textContent = `${typer} is typing...`;
                        clearTimeout(typingTimeout);
                        typingTimeout = setTimeout(() => typingIndicator.textContent = "", 2000);
                    }
                    return;
                }

                typingIndicator.textContent = "";

                const div = document.createElement("div");
                const time = new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });

                if (message.includes(":")) {
                    const sender = message.split(":")[0];
                    const content = message.substring(message.indexOf(":") + 1).trim();

                    if (sender === username) {
                        div.className = "message sent";
                        div.innerHTML = `You: ${content}`;
                    } else {
                        div.className = "message received";
                        div.innerHTML = `${sender}: ${content}`;
                    }
                } else {
                    div.className = "system";
                    div.textContent = message;
                }

                chatLog.appendChild(div);
                chatLog.scrollTop = chatLog.scrollHeight;
            };
        }

        function send() {
            const input = document.getElementById("message");
            if (input.value.trim()) {
                socket.send(input.value.trim());
                input.value = "";
            }
        }

        function sendTyping() {
            if (socket && socket.readyState === WebSocket.OPEN) {
                socket.send("[TYPING]" + username);
            }
        }
    </script>
</body>
</html>

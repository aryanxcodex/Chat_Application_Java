<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Group Chat - ChatSphere</title>
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
        .group-container {
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
        .group-header {
            background: linear-gradient(90deg, #128c7e 0%, #075e54 100%);
            color: #ffffff;
            padding: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .group-header h2 {
            font-size: 20px;
            font-weight: 600;
        }
        .group-header .back-btn {
            background: rgba(255, 255, 255, 0.1);
            border: none;
            color: #ffffff;
            font-size: 14px;
            font-weight: 600;
            padding: 8px 15px;
            border-radius: 8px;
            cursor: pointer;
            transition: background 0.3s ease;
        }
        .group-header .back-btn:hover {
            background: rgba(255, 255, 255, 0.2);
        }
        #chatArea {
            flex: 1;
            display: flex;
            flex-direction: column;
            padding: 20px;
            background: url('https://whatsapp-clone-bg.netlify.app/chat-bg.png') repeat;
            background-size: contain;
        }
        #chatLog {
            flex: 1;
            overflow-y: auto;
            margin-bottom: 15px;
        }
        .message {
            margin: 10px 0;
            padding: 12px 18px;
            border-radius: 10px;
            max-width: 70%;
            font-size: 15px;
            line-height: 1.4;
            position: relative;
            animation: fadeIn 0.3s ease;
        }
        .me {
            background: #dcf8c6;
            color: #075e54;
            margin-left: auto;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }
        .other {
            background: #ffffff;
            color: #075e54;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }
        .message::after {
            content: '';
            position: absolute;
            width: 0;
            height: 0;
            border: 8px solid transparent;
        }
        .me::after {
            border-left-color: #dcf8c6;
            right: -8px;
            top: 50%;
            transform: translateY(-50%);
        }
        .other::after {
            border-right-color: #ffffff;
            left: -8px;
            top: 50%;
            transform: translateY(-50%);
        }
        .system {
            color: #6b7280;
            text-align: center;
            font-style: italic;
            margin: 10px 0;
        }
        .timestamp {
            display: block;
            font-size: 0.75em;
            color: #777;
            margin-top: 5px;
        }
        #typingIndicator {
            font-style: italic;
            color: #555;
            height: 20px;
            margin-bottom: 15px;
        }
        .input-area {
            display: flex;
            gap: 15px;
            background: #f0f2f5;
            padding: 20px;
        }
        #username, #room, #message {
            flex: 1;
            padding: 12px 20px;
            border: none;
            border-radius: 25px;
            font-size: 15px;
            outline: none;
            background: #ffffff;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            transition: box-shadow 0.3s ease;
        }
        #username:focus, #room:focus, #message:focus {
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.15);
        }
        button {
            background: #128c7e;
            color: #ffffff;
            border: none;
            border-radius: 25px;
            padding: 12px 20px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.3s ease, transform 0.2s ease;
        }
        button:hover {
            background: #075e54;
            transform: scale(1.05);
        }
        #chatLog::-webkit-scrollbar {
            width: 8px;
        }
        #chatLog::-webkit-scrollbar-thumb {
            background: #d1d5db;
            border-radius: 4px;
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>
<body>
    <div class="group-container">
        <div class="group-header">
            <button class="back-btn" onclick="window.location.href='home.jsp'">Back</button>
            <h2>Group Chat</h2>
        </div>
        <div style="padding: 20px;">
            <div class="form-group">
                <label for="username">Username:</label>
                <input type="text" id="username" placeholder="e.g. Aryan" />
            </div>
            <div class="form-group">
                <label for="room">Room Name:</label>
                <input type="text" id="room" placeholder="e.g. room1" />
                <button onclick="connect()">Connect</button>
            </div>
        </div>
        <div id="chatArea" style="display:none;">
            <h3 style="padding: 0 20px;">Room: <span id="roomDisplay"></span></h3>
            <div id="chatLog"></div>
            <div id="typingIndicator"></div>
            <div class="input-area">
                <input type="text" id="message" placeholder="Type a message" oninput="sendTyping()" />
                <button onclick="send()">Send</button>
            </div>
        </div>
    </div>

    <script>
        let socket;
        let username;
        let typingTimeout;

        function connect() {
            const room = document.getElementById("room").value.trim();
            username = document.getElementById("username").value.trim();

            if (!room || !username) return alert("Please enter both username and room name");

            document.getElementById("roomDisplay").textContent = room;

            socket = new WebSocket("ws://" + window.location.host + "<%= request.getContextPath() %>/chat/" + room + "?username=" + encodeURIComponent(username));

            socket.onopen = () => {
                document.getElementById("chatArea").style.display = "block";
            };

            socket.onmessage = (event) => {
                const message = event.data;
                const chatLog = document.getElementById("chatLog");
                const typingIndicator = document.getElementById("typingIndicator");

                if (message.startsWith("[TYPING]")) {
                    const typer = message.substring(8);
                    if (typer !== username) {
                        typingIndicator.textContent = ${typer} is typing...;
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
                        div.className = "message me";
                        div.innerHTML = You: ${content}<span class="timestamp">${time}</span>;
                    } else {
                        div.className = "message other";
                        div.innerHTML = ${sender}: ${content}<span class="timestamp">${time}</span>;
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


group.jsp
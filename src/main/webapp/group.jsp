<!DOCTYPE html>
<html>
<head>
    <title>Chat Room App</title>
    <style>
        #chatLog {
            border: 1px solid #ccc;
            padding: 10px;
            height: 300px;
            overflow-y: auto;
            margin-bottom: 10px;
        }
        .message {
            margin: 5px;
            padding: 8px 12px;
            border-radius: 12px;
            display: inline-block;
            max-width: 60%;
            clear: both;
        }
        .me {
            background-color: #dcf8c6;
            float: right;
            text-align: right;
        }
        .other {
            background-color: #f1f0f0;
            float: left;
            text-align: left;
        }
        .system {
            color: gray;
            text-align: center;
            clear: both;
            margin: 5px;
            font-style: italic;
        }
        .timestamp {
            display: block;
            font-size: 0.75em;
            color: #777;
            margin-top: 2px;
        }
        #typingIndicator {
            font-style: italic;
            color: #555;
            margin-top: 5px;
            height: 20px;
        }
    </style>
</head>
<body>
    <h2>💬 Join a Chat Room</h2>

    <label for="username">Username:</label>
    <input type="text" id="username" placeholder="e.g. Aryan" />

    <br><br>

    <label for="room">Room Name:</label>
    <input type="text" id="room" placeholder="e.g. room1" />
    <button onclick="connect()">Connect</button>

    <div id="chatArea" style="display:none;">
        <h3>Room: <span id="roomDisplay"></span></h3>
        <div id="chatLog"></div>
        <div id="typingIndicator"></div>
        <input type="text" id="message" placeholder="Type a message" oninput="sendTyping()" />
        <button onclick="send()">Send</button>
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

                // If it's a typing message
                if (message.startsWith("[TYPING]")) {
                    const typer = message.substring(8);
                    if (typer !== username) {
                        typingIndicator.textContent = `${typer} is typing...`;
                        clearTimeout(typingTimeout);
                        typingTimeout = setTimeout(() => typingIndicator.textContent = "", 2000);
                    }
                    return;
                }

                typingIndicator.textContent = ""; // reset on real message

                const div = document.createElement("div");
                const time = new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });

                if (message.includes(":")) {
                    const sender = message.split(":")[0];
                    const content = message.substring(message.indexOf(":") + 1).trim();

                    if (sender === username) {
                        div.className = "message me";
                        div.innerHTML = `You: ${content}<span class="timestamp">${time}</span>`;
                    } else {
                        div.className = "message other";
                        div.innerHTML = `${sender}: ${content}<span class="timestamp">${time}</span>`;
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

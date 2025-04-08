<!DOCTYPE html>
<html>
<head>
    <title>Chat Room App</title>
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
        <div id="chatLog" style="border:1px solid #ccc; padding:10px; height:200px; overflow-y:auto;"></div>
        <input type="text" id="message" placeholder="Type a message" />
        <button onclick="send()">Send</button>
    </div>

    <script>
        let socket;
        let username;

        function connect() {
            const room = document.getElementById("room").value.trim();
            username = document.getElementById("username").value.trim();

            if (!room || !username) return alert("Please enter both username and room name");

            document.getElementById("roomDisplay").textContent = room;

            // Connect with username as a query param
            socket = new WebSocket("ws://" + window.location.host + "<%= request.getContextPath() %>/chat/" + room + "?username=" + encodeURIComponent(username));

            socket.onopen = () => {
                document.getElementById("chatArea").style.display = "block";
            };

            socket.onmessage = (event) => {
                const div = document.createElement("div");
                div.textContent = event.data;
                document.getElementById("chatLog").appendChild(div);
                div.scrollIntoView();
            };
        }

        function send() {
            const input = document.getElementById("message");
            if (input.value.trim()) {
                socket.send(input.value.trim());
                input.value = "";
            }
        }
    </script>
</body>
</html>

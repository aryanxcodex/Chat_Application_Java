<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Chat - ChatSphere</title>
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
            color: #ffffff;
            padding: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .chat-header h2 {
            font-size: 20px;
            font-weight: 600;
        }
        .chat-header .back-btn {
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
        .chat-header .back-btn:hover {
            background: rgba(255, 255, 255, 0.2);
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
            line-height: 1.4;
            position: relative;
            animation: fadeIn 0.3s ease;
        }
        .sent {
            background: #dcf8c6;
            color: #075e54;
            margin-left: auto;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }
        .received {
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
            padding: 20px;
            background: #f0f2f5;
            display: flex;
            gap: 15px;
            align-items: center;
        }
        .chat-input {
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
        .chat-input:focus {
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.15);
        }
        .send-button {
            background: #128c7e;
            color: #ffffff;
            border: none;
            border-radius: 50%;
            width: 50px;
            height: 50px;
            display: flex;
            justify-content: center;
            align-items: center;
            cursor: pointer;
            font-size: 20px;
            transition: background 0.3s ease, transform 0.2s ease;
        }
        .send-button:hover {
            background: #075e54;
            transform: scale(1.1);
        }
        .chat-messages::-webkit-scrollbar {
            width: 8px;
        }
        .chat-messages::-webkit-scrollbar-thumb {
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
    <div class="chat-container">
        <div class="chat-header">
            <button class="back-btn" onclick="window.location.href='home.jsp'">Back</button>
            <h2 id="chatWithName">Chat</h2>
        </div>
        <div class="chat-messages" id="chatMessages"></div>
        <div class="chat-input-area">
            <textarea class="chat-input" id="messageInput" rows="1" placeholder="Type a message"></textarea>
            <button class="send-button" onclick="sendMessage()">➤</button>
        </div>
    </div>

    <script>
        const username = localStorage.getItem('loggedInUsername') || localStorage.getItem('username');
        const name = localStorage.getItem('name');
        if (!username) {
            window.location.href = 'login.jsp';
        }

        const urlParams = new URLSearchParams(window.location.search);
        const chatWithId = urlParams.get('chatWithId') || 'Unknown';
        const chatWithName = urlParams.get('chatWithName') || 'Unknown';
        document.getElementById('chatWithName').textContent = chatWithName;

        let messages = JSON.parse(localStorage.getItem(`chat_${username}_${chatWithId}`)) || [
            { sender: chatWithName, text: 'Hi there!' },
            { sender: name, text: 'Hey! How’s it going?' }
        ];

        const messagesContainer = document.getElementById('chatMessages');
        messages.forEach(msg => {
            const messageDiv = document.createElement('div');
            messageDiv.className = msg.sender === name ? 'message sent' : 'message received';
            messageDiv.textContent = msg.text;
            messagesContainer.appendChild(messageDiv);
        });
        messagesContainer.scrollTop = messagesContainer.scrollHeight;

        function sendMessage() {
            const input = document.getElementById('messageInput');
            const message = input.value.trim();
            if (message) {
                const newMessage = { sender: name, text: message };
                messages.push(newMessage);

                const messageDiv = document.createElement('div');
                messageDiv.className = 'message sent';
                messageDiv.textContent = message;
                messagesContainer.appendChild(messageDiv);
                messagesContainer.scrollTop = messagesContainer.scrollHeight;

                localStorage.setItem(`chat_${username}_${chatWithId}`, JSON.stringify(messages));
                input.value = '';
            }
        }

        document.getElementById('messageInput').addEventListener('keypress', function(e) {
            if (e.key === 'Enter' && !e.shiftKey) {
                e.preventDefault();
                sendMessage();
            }
        });
    </script>
</body>
</html>
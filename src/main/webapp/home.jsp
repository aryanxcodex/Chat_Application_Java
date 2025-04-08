<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Home - ChatSphere</title>
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
        .home-container {
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
        .home-header {
            background: linear-gradient(90deg, #128c7e 0%, #075e54 100%);
            color: #ffffff;
            padding: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .home-header h2 {
            font-size: 24px;
            font-weight: 600;
        }
        .home-header .button-group {
            display: flex;
            gap: 10px;
        }
        .home-header .group-btn, .home-header .logout-btn {
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
        .home-header .group-btn:hover, .home-header .logout-btn:hover {
            background: rgba(255, 255, 255, 0.2);
        }
        .chat-list {
            flex: 1;
            overflow-y: auto;
            background: #ffffff;
        }
        .chat-tile {
            padding: 15px 20px;
            border-bottom: 1px solid #e6e6e6;
            display: flex;
            align-items: center;
            cursor: pointer;
            transition: background 0.2s ease;
        }
        .chat-tile:hover {
            background: #f7f7f7;
        }
        .chat-tile .avatar {
            width: 50px;
            height: 50px;
            background: linear-gradient(135deg, #128c7e 0%, #075e54 100%);
            border-radius: 50%;
            margin-right: 15px;
            display: flex;
            justify-content: center;
            align-items: center;
            color: #ffffff;
            font-size: 20px;
            font-weight: 600;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }
        .chat-tile .info {
            flex: 1;
        }
        .chat-tile .info .name {
            font-size: 16px;
            font-weight: 600;
            color: #075e54;
        }
        .chat-tile .info .last-message {
            font-size: 14px;
            color: #6b7280;
            margin-top: 5px;
        }
        .chat-tile .time {
            font-size: 12px;
            color: #128c7e;
            font-weight: 600;
        }
        .chat-list::-webkit-scrollbar {
            width: 8px;
        }
        .chat-list::-webkit-scrollbar-thumb {
            background: #d1d5db;
            border-radius: 4px;
        }
    </style>
</head>
<body>
    <div class="home-container">
        <div class="home-header">
            <h2>ChatSphere</h2>
            <div class="button-group">
                <button class="group-btn" onclick="window.location.href='group1.jsp'">Group Chat</button>
                <button class="logout-btn" onclick="logout()">Logout</button>
            </div>
        </div>
        <div class="chat-list" id="chatList"></div>
    </div>

    <script>
        const username = localStorage.getItem('loggedInUsername') || localStorage.getItem('username');
        const name = localStorage.getItem('name') || 'Guest';
        if (!username) {
            window.location.href = 'login.jsp';
        }

        const users = [
            { id: 'user1', name: 'Ram', lastMessage: 'Hey, how’s it going?', time: '12:30 PM' },
            { id: 'user2', name: 'Sham', lastMessage: 'See you later!', time: '11:45 AM' },
            { id: 'user3', name: 'Ajay', lastMessage: 'What’s up?', time: 'Yesterday' }
        ];

        const chatList = document.getElementById('chatList');
        users.forEach(user => {
            if (user.name !== name) {
                const tile = document.createElement('div');
                tile.className = 'chat-tile';
                tile.innerHTML = `
                    <div class="avatar">${user.name.charAt(0)}</div>
                    <div class="info">
                        <div class="name">${user.name}</div>
                        <div class="last-message">${user.lastMessage}</div>
                    </div>
                    <div class="time">${user.time}</div>
                `;
                tile.onclick = () => { window.location.href = `chat.jsp?chatWithId=${encodeURIComponent(user.id)}&chatWithName=${encodeURIComponent(user.name)}`; };
                chatList.appendChild(tile);
            }
        });

        function logout() {
            localStorage.removeItem('username');
            window.location.href = 'login.jsp';
        }
    </script>
</body>
</html>
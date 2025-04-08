package com.chat.socket;

import javax.websocket.*;
import javax.websocket.server.PathParam;
import javax.websocket.server.ServerEndpoint;

import java.io.IOException;
import java.util.*;

@ServerEndpoint("/chat/{room}")
public class RoomWebSocket {

    // roomName -> Set of Sessions
    private static final Map<String, Set<Session>> roomSessions = new HashMap<>();

    // sessionId -> username
    private static final Map<Session, String> sessionUsernames = new HashMap<>();

    @OnOpen
    public void onOpen(Session session, @PathParam("room") String room) {
        String query = session.getQueryString();
        String username = "Guest";

        if (query != null && query.contains("username=")) {
            username = query.substring(query.indexOf("username=") + 9);
            username = decode(username);
        }

        synchronized (roomSessions) {
            roomSessions.computeIfAbsent(room, k -> new HashSet<>()).add(session);
            sessionUsernames.put(session, username);
        }

        System.out.println("🔌 " + username + " joined room [" + room + "]: " + session.getId());

        sendToRoom(room, "🔔 " + username + " joined the chat.");
    }

    @OnMessage
    public void onMessage(String message, Session session, @PathParam("room") String room) {
        String username = sessionUsernames.getOrDefault(session, "Guest");

        // handle typing
        if (message.startsWith("[TYPING]")) {
            sendToRoom(room, message); // Broadcast typing
            return;
        }

        sendToRoom(room, username + ": " + message);
    }

    @OnClose
    public void onClose(Session session, @PathParam("room") String room) {
        String username = sessionUsernames.getOrDefault(session, "Guest");

        synchronized (roomSessions) {
            Set<Session> sessions = roomSessions.get(room);
            if (sessions != null) {
                sessions.remove(session);
                if (sessions.isEmpty()) {
                    roomSessions.remove(room);
                }
            }
            sessionUsernames.remove(session);
        }

        sendToRoom(room, "❌ " + username + " left the chat.");
    }

    @OnError
    public void onError(Session session, Throwable throwable) {
        throwable.printStackTrace();
    }

    private void sendToRoom(String room, String message) {
        Set<Session> sessions = roomSessions.get(room);
        if (sessions != null) {
            for (Session s : sessions) {
                try {
                    s.getBasicRemote().sendText(message);
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    private String decode(String input) {
        try {
            return java.net.URLDecoder.decode(input, "UTF-8");
        } catch (Exception e) {
            return input;
        }
    }
}

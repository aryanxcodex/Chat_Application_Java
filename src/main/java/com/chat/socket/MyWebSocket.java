package com.chat.socket;

import jakarta.websocket.*;
import jakarta.websocket.server.ServerEndpoint;
import java.io.IOException;

@ServerEndpoint("/chat")
public class MyWebSocket {

    @OnOpen
    public void onOpen(Session session) {
        System.out.println("🔌 Client connected: " + session.getId());
        try {
            session.getBasicRemote().sendText("👋 Welcome! You're connected to the chat server.");
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    @OnMessage
    public void onMessage(String message, Session session) throws IOException {
        System.out.println("📩 Message received: " + message);
        session.getBasicRemote().sendText("You said: " + message);
    }

    @OnClose
    public void onClose(Session session) {
        System.out.println("❌ Connection closed: " + session.getId());
    }

    @OnError
    public void onError(Session session, Throwable throwable) {
        System.err.println("⚠️ Error on session " + session.getId());
        throwable.printStackTrace();
    }
}
package com.cscc43;

import java.sql.Connection;

public class Main {
    private static final String URL = "jdbc:postgresql://localhost:5432/postgres";
    private static final String USER = "postgres";
    private static final String PASSWORD = "a2";

    public static void main(String[] args) {
        Assignment2 controller = new Assignment2();
        System.out.println("CONNECTED: " + controller.connectDB(URL, USER, PASSWORD));
        System.out.println("DISCONNECTED: " + controller.disconnectDB());

    }
}

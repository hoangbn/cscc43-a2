package com.cscc43;

public class Main {
    private static final String URL = "jdbc:postgresql://localhost:5432/postgres";
    private static final String USER = "postgres";
    private static final String PASSWORD = "a2";

    public static void main(String[] args) {
        Assignment2 controller = new Assignment2();
        assert controller.connectDB(URL, USER, PASSWORD) : "Connect failed";
//        controller.insertPlayer(2, "Brian", 2, 12);
//        assert controller.insertPlayer(1, "Jeff", 1, 2) : "Insert failed";
//        assert controller.insertPlayer(1, "Jeff", 1, 2) : "Inserted duplicate";
        System.out.println(controller.getChampions(1));
        System.out.println(controller.getCourtInfo(15));
        System.out.println(controller.chgRecord(1, 2012, 34, 9));
//        System.out.println(controller.deleteMatchBetween(2, 3));
        System.out.println(controller.listPlayerRanking());
        System.out.println(controller.findTriCircle());
        System.out.println(controller.updateDB());
        assert controller.disconnectDB() : "Disconnect failed";

    }
}

package com.cscc43;

public class Main {
    private static final String URL = "jdbc:postgresql://localhost:5432/postgres";
    private static final String USER = "macbookpro";
    private static final String PASSWORD = "";

    public static void main(String[] args) throws ClassNotFoundException {
        Assignment2 controller = new Assignment2();
        System.out.print(controller.connectDB(URL, USER, PASSWORD));
        controller.insertPlayer(122, "Brian", 2, 12);
        controller.insertPlayer(1, "Jeff", 1, 2);
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

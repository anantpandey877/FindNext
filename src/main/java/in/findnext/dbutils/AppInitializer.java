package in.findnext.dbutils;

import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;

import in.findnext.utils.AffindaAPI;
import in.findnext.utils.MyAuthenticator;

public class AppInitializer implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        // --- DEBUG PRINT START ---
        System.out.println("=============================================");
        System.out.println("FINDNEXT DEBUG: AppInitializer Started");
        System.out.println("=============================================");

        try {
            ServletContext sc = sce.getServletContext();

            // --- 1. Database Configuration ---
            String url = System.getenv("DB_URL");
            if (url == null) url = "jdbc:mysql://localhost:3306/findnest";
            System.out.println("FINDNEXT DEBUG: DB_URL found: " + url);

            String username = System.getenv("DB_USER");
            if (username == null) username = "root";

            String password = System.getenv("DB_PASSWORD");
            if (password == null) password = "root";

            System.out.println("FINDNEXT DEBUG: Attempting DB Connection...");
            DBConnection.openConnection(url, username, password);
            System.out.println("FINDNEXT DEBUG: DB Connection Successful!");

            // --- 2. Email & API Configuration ---
            String affindaApiKey = System.getenv("AFFINDA_API_KEY");
            if (affindaApiKey == null) affindaApiKey = "ADD_KEY_TO_ENVIRONMENT_VARIABLES";

            String mailUsername = System.getenv("MAIL_USERNAME");
            if (mailUsername == null) mailUsername = "findnextteam@gmail.com";

            String mailPassword = System.getenv("MAIL_PASSWORD");
            if (mailPassword == null) mailPassword = "REQUIRED_ONLY_FOR_LOCAL_TESTING";

            String mailFrom = System.getenv("MAIL_FROM");
            if (mailFrom == null) mailFrom = "findnextteam@gmail.com";

            // Pass configs to utility classes
            System.out.println("FINDNEXT DEBUG: Configuring APIs and Mail...");
            AffindaAPI.setApiKey(affindaApiKey);
            MyAuthenticator.configure(mailUsername, mailPassword);
            sc.setAttribute("mail.from", mailFrom);

            // --- 3. General App Settings ---
            String appName = sc.getInitParameter("appName");
            if (appName == null) appName = "FindNext";
            sc.setAttribute("appName", appName);

            System.out.println("=============================================");
            System.out.println("FINDNEXT DEBUG: AppInitializer COMPLETED SUCCESS");
            System.out.println("=============================================");

        } catch (Exception e) {
            // This captures the crash and prints it to Render Logs
            System.err.println("=============================================");
            System.err.println("FINDNEXT CRITICAL ERROR: APP CRASHED ON STARTUP");
            System.err.println("=============================================");
            e.printStackTrace();
            throw new RuntimeException("App failed to start", e);
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        DBConnection.closeConnection();
    }
}
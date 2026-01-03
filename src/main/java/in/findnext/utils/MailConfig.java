package in.findnext.utils;

import java.util.Properties;
import jakarta.mail.Session;

public class MailConfig {

	// Creates and configures email session with Gmail SMTP settings
    public static Session getSession() {
    	Properties prop = new Properties();
    	prop.put("mail.smtp.host", "smtp.gmail.com");
    	prop.put("mail.smtp.port", "465");
    	prop.put("mail.smtp.auth", "true");
    	prop.put("mail.smtp.socketFactory.port", "465");
    	prop.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");

    	MyAuthenticator myAuth = new MyAuthenticator();
    	Session session = Session.getInstance(prop,myAuth);

        return session;
    }
}


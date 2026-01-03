package in.findnext.utils;

import jakarta.mail.Authenticator;
import jakarta.mail.PasswordAuthentication;

public class MyAuthenticator extends Authenticator {
	private static volatile String email;
	private static volatile String password;

	public static void configure(String configuredEmail, String configuredPassword) {
		email = (configuredEmail == null) ? null : configuredEmail.trim();
		password = (configuredPassword == null) ? null : configuredPassword;
	}

	private static void requireConfigured() {
		if (email == null || email.isEmpty() || "__SET_ME__".equals(email) || password == null
				|| password.isEmpty() || "__SET_ME__".equals(password)) {
			throw new IllegalStateException(
					"Mail credentials are not configured. Set context-params 'mail.username' and 'mail.password' in WEB-INF/web.xml");
		}
	}

	// Provides email credentials for authentication with mail server
	@Override
	protected PasswordAuthentication getPasswordAuthentication() {
		requireConfigured();
		return new PasswordAuthentication(email, password);
	}

}

package member.action;

import javax.mail.Authenticator;
import javax.mail.PasswordAuthentication;

public class Gmail extends Authenticator {

    @Override
    protected PasswordAuthentication getPasswordAuthentication() {

        return new PasswordAuthentication("jinsan654321@gmail.com","jinsan!123456789");

    }

    

}
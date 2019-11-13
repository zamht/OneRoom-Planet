package member.action;

import java.util.Properties;

import javax.mail.Address;
import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import member.model.MemberDAO;

public class EmailAction implements Action {

	@Override
	public ActionForward execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		request.setCharacterEncoding("UTF-8");
		MemberDAO dao = new MemberDAO();
		ActionForward forward = new ActionForward();

		int result = dao.emailCheck(request.getParameter("email"));
		if (result == 0) { // 이미 있는 이메일
			return null;
		}
		
		String randomNum = request.getParameter("randomNum"); 
		String from = "jinsan654321@gmail.com";
		String to = request.getParameter("email");
		String subject = "회원가입을 위한 이메일 확인 메일입니다.";
		String content = "인증번호 : " + randomNum;
		

		
		Properties p = new Properties();    // hashtable 상속하는 콜렉션 hashmap 구조 = // FileInputstream+hashmap = properties
		p.put("mail.smtp.user", from);
		//		키				밸류
		p.put("mail.smtp.host", "smtp.googlemail.com");
		p.put("mail.smtp.port", "465");
		p.put("mail.smtp.starttls.enable", "true");
		p.put("mail.smtp.auth", "true");
		p.put("mail.smtp.debug", "true");
		p.put("mail.smtp.socketFactory.port", "465");
		p.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
		p.put("mail.smtp.socketFactory.fallback", "false");
		
		try {
			Authenticator auth = new Gmail();
			Session ses = Session.getInstance(p, auth);
			ses.setDebug(true);
			MimeMessage msg = new MimeMessage(ses);
			msg.setSubject(subject);
			Address fromAddr = new InternetAddress(from);
			msg.setFrom(fromAddr);
			Address toAddr = new InternetAddress(to);
			msg.addRecipient(Message.RecipientType.TO, toAddr);
			msg.setContent(content, "text/html;charset=UTF-8");
			Transport.send(msg);
		} catch (Exception e) {
			e.printStackTrace();
		}
		request.setAttribute("randomNum", randomNum);
		forward.setRedirect(true);
		forward.setPath("./emailOk.to");
		return forward;
	}

}

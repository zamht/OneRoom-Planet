package member.action;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import member.model.MemberDAO;

public class MemberDeleteAction implements Action {

	@Override
	public ActionForward execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		ActionForward forward = new ActionForward();
		request.setCharacterEncoding("UTF-8");
		MemberDAO dao = new MemberDAO();
	   	
		String id = (String)request.getSession().getAttribute("sessionID");
	   	dao.delete(id);
	   	request.getSession().invalidate();
		
		forward.setRedirect(true);
   		forward.setPath("./index.to");
   		return forward;
	}


}

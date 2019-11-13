package member.action;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import member.model.MemberDAO;

public class MemberListAction implements Action {

	@Override
	public ActionForward execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		ActionForward forward = new ActionForward();
		
		MemberDAO memberdao=new MemberDAO();
		
		System.out.println("memberlistAction 시작");
		List memberlist=new ArrayList();
		memberlist = memberdao.getMemberList();
		
		request.setAttribute("memberlist", memberlist);
		
		System.out.println("getMemberList 끝");
		
		forward.setRedirect(false);
 		forward.setPath("/memberinfo.jsp");
		return forward;
	}
}
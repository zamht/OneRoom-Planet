package member.action;

import java.io.PrintWriter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import member.model.MemberDAO;

public class AdminDeleteAction implements Action{
	 public ActionForward execute(HttpServletRequest request,HttpServletResponse response) 
			 	throws Exception{
				 
				ActionForward forward = new ActionForward();
				request.setCharacterEncoding("UTF-8");
				
			   	boolean result=false;
			   	boolean usercheck=false;
			   	String id = request.getParameter("id");
			   	
			   	MemberDAO memberdao=new MemberDAO();
			   	System.out.println("2222");
			   	
			   	
			   	result=memberdao.memberDelete(id);
			   	if(result==false){
			   		return null;
			   	}
			   	
			   	forward.setRedirect(true);
		   		forward.setPath("./memberlist.to");
		   		return forward;
			 }
}

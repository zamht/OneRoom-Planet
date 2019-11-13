package member.controller;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import member.action.Action;
import member.action.ActionForward;
import member.action.AdminDeleteAction;
import member.action.DeleteEmailAction;
import member.action.EmailAction;
import member.action.JoinAction;
import member.action.MemberDeleteAction;
import member.model.MemberDAO;
import member.action.PwdEmailAction;
import member.action.MemberListAction;
import member.action.MemberLoginAction;
import member.action.MemberLogoutAction;


@WebServlet("*.to")
public class MemberController extends javax.servlet.http.HttpServlet implements javax.servlet.Servlet {

   private static final long serialVersionUID = 1L;

   protected void doProcess(HttpServletRequest request, HttpServletResponse response)
         throws ServletException, IOException {

      String RequestURI = request.getRequestURI();
      String contextPath = request.getContextPath();
      String command = RequestURI.substring(contextPath.length());
      ActionForward forward = null;
      Action action = null;
      	
		if (command.equals("/register2.to")) {
			forward = new ActionForward();
			forward.setRedirect(false);
			forward.setPath("register2.jsp");
		} else if (command.equals("/JoinAction.to")) {
			action = new JoinAction();
			try {
				forward = action.execute(request, response);
			} catch (Exception e) {
				e.printStackTrace();
			}

		} else if (command.equals("/search.to")) {
			forward = new ActionForward();
			forward.setRedirect(false);
			forward.setPath("search.jsp");
		} else if (command.equals("/search_id.to")) {
			forward = new ActionForward();
			forward.setRedirect(false);
			forward.setPath("search_id.jsp");
		} else if (command.equals("/search_password.to")) {
			forward = new ActionForward();
			forward.setRedirect(false);
			forward.setPath("search_password.jsp");
		} else if (command.equals("/register3.to")) {
			forward = new ActionForward();
			forward.setRedirect(false);
			forward.setPath("register3.jsp");
		} else if (command.equals("/email.to")) {
			forward = new ActionForward();
			forward.setRedirect(false);
			forward.setPath("email.jsp");

		} else if (command.equals("/EmailAction.to")) {
			action = new EmailAction();
			try {
				forward = action.execute(request, response);
			} catch (Exception e) {
				e.printStackTrace();
			}

		} else if (command.equals("/PwdEmailAction.to")) {
			action = new PwdEmailAction();
			try {
				forward = action.execute(request, response);
			} catch (Exception e) {
				e.printStackTrace();
			}

		} else if (command.equals("/DeleteEmailAction.to")) {
            action = new DeleteEmailAction();
            try {
               forward = action.execute(request, response);
            } catch (Exception e) {
               e.printStackTrace();
            }

            
		} else if (command.equals("/MemberDeleteAction.to")) {
            action = new MemberDeleteAction();
            try {
               forward = action.execute(request, response);
            } catch (Exception e) {
               e.printStackTrace();
            }
            
		} else if (command.equals("/emailOk.to")) {
			forward = new ActionForward();
			forward.setRedirect(false);
			forward.setPath("emailOk.jsp");

		} else if (command.equals("/login.to")) {
			forward = new ActionForward();
			forward.setRedirect(false);
			forward.setPath("login.jsp");

		} else if (command.equals("/register.to")) {
			forward = new ActionForward();
			forward.setRedirect(false);
			forward.setPath("register.jsp");

		} else if (command.equals("/index.to")) {
			forward = new ActionForward();
			forward.setRedirect(false);
			forward.setPath("index.jsp");

		} else if (command.equals("/registerDelete.to")) {
			forward = new ActionForward();
			forward.setRedirect(false);
			forward.setPath("registerDelete.jsp");

		} else if (command.equals("/logout.to")) {
			action = new MemberLogoutAction();
			try {
				forward = action.execute(request, response);
			} catch (Exception e) {
				e.printStackTrace();
			}

		} else if (command.equals("/MemberLoginAction.to")) {
			action = new MemberLoginAction();
			try {
				forward = action.execute(request, response);
			} catch (Exception e) {
				e.printStackTrace();
			}

		} else if (command.equals("/idCheck.to")) {
			String id = request.getParameter("id");
			response.getWriter().write(new MemberDAO().idCheck(id) + "");

		} else if (command.equals("/pwdCheck.to")) {
			response.getWriter()
					.write(new MemberDAO().pwdCheck(request.getParameter("id") + "", request.getParameter("pwd")) + "");
			

		} else if (command.equals("/idSearch.to")) {
			response.getWriter()
			.write(new MemberDAO().idSearch(request.getParameter("name") + "", request.getParameter("email") + "", request.getParameter("phone") + ""));
			return ;
		} else if (command.equals("/pwdSearch.to")) {
			response.getWriter()
			.write(new MemberDAO().pwdSearch(request.getParameter("name") + "", request.getParameter("id") + "", request.getParameter("email") + "", request.getParameter("phone") + ""));
			return ;
		} else if (command.equals("/admin.to")) {
			forward = new ActionForward();
			forward.setRedirect(false);
			forward.setPath("admin.jsp");


      } else if(command.equals("/memberlist.to")){
         action = new MemberListAction();
         try{
            forward=action.execute(request, response);
         }catch(Exception e){
            e.printStackTrace();
         } 
      } else if (command.equals("/Delete.to")) {
          action = new AdminDeleteAction();
          System.out.println("1111");
          try {
             forward = action.execute(request, response);
          } catch (Exception e) {
             e.printStackTrace();
          }
      }
      System.out.println(forward);
      if (forward != null) {
         if (forward.isRedirect()) {
            response.sendRedirect(forward.getPath());
         } else {
            RequestDispatcher dispatcher = request.getRequestDispatcher(forward.getPath());
            dispatcher.forward(request, response);
         }
      }

   }

   protected void doGet(HttpServletRequest request, HttpServletResponse response)
         throws ServletException, IOException {
      doProcess(request, response);
   }

   protected void doPost(HttpServletRequest request, HttpServletResponse response)
         throws ServletException, IOException {
      doProcess(request, response);
   }
}
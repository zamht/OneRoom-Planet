package test.filter;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/*
 * 로그인을 했는지 안했는지 검사하는 필터 객체만들기
 */
public class LoginFilter implements Filter{

@Override
public void destroy() {}

@Override
public void doFilter(ServletRequest request, ServletResponse response,
FilterChain chain) throws IOException, ServletException {
//자식객체로 형변환 한다음
HttpServletRequest httpRequest=(HttpServletRequest)request;
//세션 객체를 얻어온다.
HttpSession session=httpRequest.getSession();
//로그인 했는지 아닌지에 대한 여부
boolean isLogin=false;
if(session!=null){
//세션에서 id 라는 키값을 읽어와 본다.
System.out.println("sessionID");
String id=(String)session.getAttribute("sessionID");
//만일 id 값이 null 이 아니라면 로그인한 상태이다.
if(id!=null)isLogin=true;
}
if(isLogin){
//로그인 된 경우에는 요청된 작업을 계속한다.
chain.doFilter(request, response);
}else{
//로그인 하지 않은 경우
//ServletResponse 객체를 자식 객체로 형변환 한다음
HttpServletResponse httpResponse=(HttpServletResponse)response;
//안내페이지 혹은 login 페이지로 강제 이동시킨다.
httpResponse.sendRedirect("login.jsp");
}
}
@Override
public void init(FilterConfig arg0) throws ServletException {

}
}
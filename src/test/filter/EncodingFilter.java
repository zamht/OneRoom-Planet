package test.filter;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;

/*
 *  인코딩 필터 만들기
 *  1.Filter 인터페이스를 implements 한다.
 *  2.doFilter 메소드를 오버 라이딩한다.
 *  3.web.xml 에서 필터가 동작하도록 맵핑한다.
 */
public class EncodingFilter implements Filter{

@Override
public void destroy() {}

@Override
public void doFilter(ServletRequest request, ServletResponse response,
FilterChain chain) throws IOException, ServletException {
System.out.println("doFilter()메소드");
//인코딩이 안되어 있다면
if(request.getCharacterEncoding()==null){
//한글 인코딩 설정하기
request.setCharacterEncoding(encoding);
}
//다음 필터 체인으로 실행순서를 넘긴다, 더이상 필터가 없다면 요청페이지로 실행순서가
//넘어간다.
chain.doFilter(request, response);
}
String encoding;
@Override
public void init(FilterConfig config) throws ServletException {
System.out.println("init() 메소드");
//xml 문서에 정의된 init param에서 값 읽어오기
encoding=config.getInitParameter("encoding");
}

}
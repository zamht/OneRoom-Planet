package room.action;

import java.util.Date;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;

import map.bit.kakaomap.kakaoDAO;
import map.bit.kakaomap.kakaoVO;
import room.action.ActionForward;
import room.model.RoomDAO;
import room.model.RoomVO;

public class RoomOutAction implements Action{

	public ActionForward execute(HttpServletRequest request,
			 HttpServletResponse response) throws Exception{
		
		RoomDAO dao = new RoomDAO();
		RoomVO vo = new RoomVO();
		ActionForward forward=new ActionForward();
		HttpSession session = request.getSession();
		
		String realFolder="";
   		String saveFolder="/image";
		
		boolean result=false;
		
		int fileSize=5*1024*1024;
   		
   		realFolder=request.getRealPath(saveFolder);
   		
   		try{
			
			MultipartRequest multi=null;
   			
   			multi=new MultipartRequest(request,
   					realFolder,
   					fileSize,
   					"UTF-8",
   					new DefaultFileRenamePolicy());
			
			String MPAY3 ="";
			int count = 0;
			String[] value = multi.getParameterValues("MPAY2");
			for (String val : value) {
				count ++;
				if(value.length == 1) {
					MPAY3 = val;
					break;
				}
				if(count == value.length) {
					MPAY3 += val;
					break;
				}
					MPAY3 += val+",";
			}
			
			String MPAY4 = multi.getParameter("MPAY");
			if(MPAY4 == null) {
				MPAY4 = "없음";
			}
			
			String NADDRESS;
			String RADDRESS;
			if (multi.getParameter("NADDRESS").isEmpty()) {
				NADDRESS = "없음";
			} else {
				NADDRESS = multi.getParameter("NADDRESS") + " " + multi.getParameter("ADDRESS2") + multi.getParameter("ADDRESS3");
			}
			if (multi.getParameter("RADDRESS").isEmpty()) {
				RADDRESS = "없음";
			} else {
				RADDRESS = multi.getParameter("RADDRESS") + " " + multi.getParameter("ADDRESS2") + multi.getParameter("ADDRESS3");
			}
			vo.setROOMID((String)session.getAttribute("sessionID"));
			vo.setNADDRESS(NADDRESS);
			vo.setRADDRESS(RADDRESS);
			vo.setIMAGE1(multi.getFilesystemName("FILE1"));
			vo.setIMAGE2(multi.getFilesystemName("FILE2"));
			vo.setIMAGE3(multi.getFilesystemName("FILE3"));
			vo.setIMAGE4(multi.getFilesystemName("FILE4"));
			vo.setIMAGE5(multi.getFilesystemName("FILE5"));
			vo.setDEPOSIT(Integer.parseInt(multi.getParameter("DEPOSIT")));
			vo.setRENT(Integer.parseInt(multi.getParameter("RENT")));
			vo.setROOMTYPE(multi.getParameter("ROOMTYPE"));
			vo.setMPAY(MPAY4);
			vo.setMPAY2(MPAY3);
			vo.setRSIZE(Integer.parseInt(multi.getParameter("RSIZE")));
			vo.setPARKING(multi.getParameter("PARKING"));
			vo.setELVE(multi.getParameter("ELVE"));
			vo.setFLOOR(multi.getParameter("FLOOR"));
			vo.setRDATE(multi.getParameter("RDATE"));
			vo.setTITLE(multi.getParameter("TITLE"));
			vo.setCONTENT(multi.getParameter("CONTENT"));
		
			result = dao.roomadd(vo);
			
			
			//영학수정파트
			
			String addr1=multi.getParameter("NADDRESS");
			String addr2=multi.getParameter("RADDRESS");
			
			String addr="";
			if(!addr1.equals("")) {
				addr=addr1;
			}else {
				addr=addr2;
			}
			
			System.out.println("addr1 = "+addr1+"\naddr2 = "+addr2+"\naddr = "+addr);
					
			
			//System.out.println("multi.getParameter(\"lat\")="+String.valueOf(multi.getParameter("lat")));
			String lat=String.valueOf(multi.getParameter("lat"));
			String lng=String.valueOf(multi.getParameter("lng"));
			int result2=0;
			int count2 = kakaoDAO.getInstance().getRecordCount(addr); //클릭된 마커클러스터에 저장된 정보가있는지 반환한다.
			System.out.println("count is "+count2);
			
			
			if(count2>0) { //만약에 oneroomplanet 테이블에 저장된값이없다면 값을 추가한다.
				System.out.println("해당주소가 잇으므로 데이터 처리를 안합니다.");
			}else {
				System.out.println("insert go");
				System.out.println("lat ="+lat+"\nlng"+lng+"\nnaddress"+addr);
				kakaoVO vo2 = new kakaoVO(lat, lng, addr, "123");
				
					//만약에 oneroomplanet 테이블에 저장된 데이터가 있다면 oneroomplanetreply데이터에 추가한다. 
				//public kakaoVO(String lat, String lng, String addr, String content) {
				result2 = kakaoDAO.getInstance().insert(vo2);
			}
			
			
			if(result==false){
	   			System.out.println("등록 실패");
	   			return null;
	   		}else if(result2==0) {
	   			System.out.println("영학이 넣은 데이터 실패");
	   		}
	   		System.out.println("등록 완료");
	   		
	   		
			//영학수정파트
		forward.setRedirect(true);
   		forward.setPath("./RoomOut.do");
   		return forward;
   		
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
}
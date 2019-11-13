package com.Action;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.catalina.tribes.util.Arrays;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import map.bit.kakaomap.kakaoDAO;
import map.bit.kakaomap.kakaoVO;
import map.bit.kakaomap.replyVO;
import room.model.RoomVO;

@WebServlet("/ArrayServlet.do")
public class ArrayServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;

	public ArrayServlet() {
		super();
	}

	private void doProcess(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		if (request.getParameterValues("string[]") != null) {
			String[] arrayStr = request.getParameterValues("string[]");
			//System.out.println(Arrays.toString(arrayStr) + "here!");

			kakaoVO vo = new kakaoVO(arrayStr[1], arrayStr[0], arrayStr[2], "123");
			int result = kakaoDAO.getInstance().insert(vo);

			//System.out.println("data save success!" + result);

			PrintWriter out = response.getWriter();
			out.write("[\"" + arrayStr[2] + "\",\"" + result + "\"]");
			out.close();
		}

		if (request.getParameter("latlng") != null) {
			String latlng = request.getParameter("latlng");
			// System.out.println(latlng);
			ArrayList<kakaoVO> clusterarr = new ArrayList<kakaoVO>();
			clusterarr = kakaoDAO.getInstance().getdb_to_markercluster(latlng);

			//System.out.println("map에서 가져온 클러스터 데이터 =" + clusterarr.size());

			// person의 JSON정보를 담을 Array 선언
			JSONArray personArray = new JSONArray();
			// person의 한명 정보가 들어갈 JSONObject 선언

			JSONObject personInfoinner = null;
			for (int i = 0; i < clusterarr.size(); i++) {
				JSONObject personInfo = new JSONObject();
				personInfo.put("lat", clusterarr.get(i).getLat());
				personInfo.put("lng", clusterarr.get(i).getLng());
				personInfoinner = new JSONObject();
				personInfoinner.put("position", personInfo);

				String text = clusterarr.get(i).getAddr();
				text = URLEncoder.encode(text, "UTF-8"); // json이나 jsonarray 객체를 넘길때 인코딩을 해줘야 한글이 넘어간다.

				personInfoinner.put("text", text);
				personArray.add(personInfoinner);

			}
			/*
			 * System.out.println(); System.out.println(personArray.toJSONString());
			 System.out.println();*/

			PrintWriter out = response.getWriter();
			out.println(personArray);
			out.flush();
			out.close();

			// 맵에보이는 최대 좌측상단 좌측하단 우측상단 우측하단에 좌표값을 보내고 해당좌표값안에있는 마커클러스터데이터
			// 를 kakaoVO의 ArrayList로 보낸다.

		}
		if (request.getParameterValues("reply[]") != null) { // 리플데이터를 데이터베이스에 저장하는 함수
			String[] arraystr = request.getParameterValues("reply[]");
			//System.out.println(Arrays.toString(arraystr) + "here! 101");
			// 0 ,1 ,2 , 3 ,4
			// 리플데이터,주소,id,lng,lat

			String lat = arraystr[4];
			String lng = arraystr[3];
			String addr = arraystr[1];
			String id = arraystr[2];
			String reply = arraystr[0];

			// replyVO vo = new replyVO(reply, addr);

			// replyVO vo = new replyVO(reply, addr, id);
			int count = kakaoDAO.getInstance().getRecordCount(arraystr[1]); // 클릭된 마커클러스터에 저장된 정보가있는지 반환한다.
			//System.out.println("count is " + count);
			if (count > 0) { // 만약에 oneroomplanet 테이블에 저장된값이없다면 값을 추가한다.

			} else {
				kakaoVO vo = new kakaoVO(lat, lng, addr, id);
				// 만약에 oneroomplanet 테이블에 저장된 데이터가 있다면 oneroomplanetreply데이터에 추가한다.
				// public kakaoVO(String lat, String lng, String addr, String content) {
				int result = kakaoDAO.getInstance().insert(vo);
			}

			int maxnum = kakaoDAO.getInstance().getidaddrfrommaxnum(addr, id);

			replyVO vo = new replyVO(reply, addr, id, maxnum + 1);
			int result = kakaoDAO.getInstance().replysavedb(vo);

			//System.out.println("data save success!" + result);

		}

		if (request.getParameterValues("addr") != null) { // 주소값을 jsp에서 보내면 데이터베이스에서 리플데이터를 가져오는 함수
			String straddr = request.getParameter("addr");
			System.out.println(straddr + "here! 121");

			ArrayList<replyVO> replyArray = kakaoDAO.getInstance().getreplydata(straddr);

			// System.out.println("data save success!" + result);

			// reply의 JSON정보를 담을 Array 선언
			JSONArray replydataArray = new JSONArray();

			for (int i = 0; i < replyArray.size(); i++) {
				JSONObject replydata = new JSONObject();

				String addr = "", id = "", reply = "";
				addr = decodeutf8(replyArray.get(i).getAddr());
				id = decodeutf8(replyArray.get(i).getId());
				reply = decodeutf8(replyArray.get(i).getReply());

				replydata.put("addr", addr);
				replydata.put("id", id);
				replydata.put("reply", reply);
				replydata.put("sutja", replyArray.get(i).getSutja());

				replydataArray.add(replydata);

			}
			/*
			 * System.out.println(); System.out.println(replydataArray.toJSONString());
			 * System.out.println();
			 */

			PrintWriter out = response.getWriter();
			out.println(replydataArray);
			out.flush();
			out.close();
		}

		if (request.getParameterValues("addrtodetail") != null) { // 주소값을 jsp에서 보내면 데이터베이스에서 리플데이터를 가져오는 함수
			
			System.out.println("PRE straddr ");
			String straddr1 = request.getParameter("addrtodetail");
			
			System.out.println("straddr ="+straddr1);

			ArrayList<RoomVO> detailArray = kakaoDAO.getInstance().getdetaildata(straddr1);

			if (detailArray.size() > 0) {
				System.out.println("detailarray = " + detailArray.get(0).getRADDRESS());
			} else {
				System.out.println("addrtodetail 에이젝스에서 detailarray값이 없습니다.");
			}

			// System.out.println("data save success!" + result);

			// reply의 JSON정보를 담을 Array 선언
			JSONArray replydataArray = new JSONArray();

			JSONObject replydata = new JSONObject();

			for (int i = 0; i < detailArray.size(); i++) {

				// String addr="",id="",reply="";
				ArrayList<String> jsondetail = new ArrayList<String>();

				jsondetail.add(decodeutf8(detailArray.get(i).getNADDRESS())); // 1
				jsondetail.add(decodeutf8(detailArray.get(i).getRADDRESS())); // 2

				jsondetail.add(decodeutf8(detailArray.get(i).getIMAGE1())); // 3
				jsondetail.add(decodeutf8(detailArray.get(i).getIMAGE2())); // 4
				jsondetail.add(decodeutf8(detailArray.get(i).getIMAGE3())); // 5
				jsondetail.add(decodeutf8(detailArray.get(i).getIMAGE4())); // 6
				jsondetail.add(decodeutf8(detailArray.get(i).getIMAGE5())); // 7
				jsondetail.add(decodeutf8(detailArray.get(i).getROOMTYPE())); // 8
				jsondetail.add(decodeutf8(detailArray.get(i).getMPAY())); // 9
				jsondetail.add(decodeutf8(detailArray.get(i).getMPAY2())); // 10
				jsondetail.add(decodeutf8(detailArray.get(i).getPARKING())); // 11
				jsondetail.add(decodeutf8(detailArray.get(i).getELVE())); // 12
				jsondetail.add(decodeutf8(detailArray.get(i).getFLOOR())); // 13
				jsondetail.add(decodeutf8(detailArray.get(i).getRDATE())); // 14
				jsondetail.add(decodeutf8(detailArray.get(i).getTITLE())); // 15
				jsondetail.add(decodeutf8(detailArray.get(i).getCONTENT())); // 16
				jsondetail.add(decodeutf8(String.valueOf(detailArray.get(i).getDEPOSIT()))); // 17
				jsondetail.add(decodeutf8(String.valueOf(detailArray.get(i).getRENT()))); // 18
				jsondetail.add(decodeutf8(String.valueOf(detailArray.get(i).getRSIZE()))); // 19

				replydata.put("naddress", jsondetail.get(0));
				replydata.put("raddress", jsondetail.get(1));
				replydata.put("image1", jsondetail.get(2));
				replydata.put("image2", jsondetail.get(3));
				replydata.put("image3", jsondetail.get(4));
				replydata.put("image4", jsondetail.get(5));
				replydata.put("image5", jsondetail.get(6));
				replydata.put("roomtype", jsondetail.get(7));
				replydata.put("mpay", jsondetail.get(8));
				replydata.put("mpay2", jsondetail.get(9));
				replydata.put("parking", jsondetail.get(10));
				replydata.put("elve", jsondetail.get(11));
				replydata.put("floor", jsondetail.get(12));
				replydata.put("rdate", jsondetail.get(13));
				replydata.put("title", jsondetail.get(14));
				replydata.put("content", jsondetail.get(15));
				replydata.put("deposit", jsondetail.get(16));
				replydata.put("rent", jsondetail.get(17));
				replydata.put("rsize", jsondetail.get(18));

				/*
				 * addr =decodeutf8(replyArray.get(i).getAddr()); id=
				 * decodeutf8(replyArray.get(i).getId());
				 * reply=decodeutf8(replyArray.get(i).getReply());
				 */

				// replydata.put("sutja", replyArray.get(i).getSutja());

				replydataArray.add(replydata);

			}
			/*
			 * System.out.println(); System.out.println("replydata.toJSONString() = " +
			 * replydata.toJSONString()); System.out.println();
			 */
			PrintWriter out = response.getWriter();
			out.println(replydata);
			out.flush();
			out.close();
		}

	}

	public String decodeutf8(String str) {

		if (str == null) {
			str = "내용 없음";
		}

		try {
			str = URLEncoder.encode(str, "UTF-8");
		} catch (UnsupportedEncodingException e) {
			System.out.println("utf-8 인코딩중 에러발생");
			e.printStackTrace();
		}
		return str;
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

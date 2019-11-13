package map.bit.kakaomap;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

import dbclose.util.CloseUtil;
import room.model.RoomVO;

public class kakaoDAO {
	private static kakaoDAO instance = new kakaoDAO();

	public static kakaoDAO getInstance() {
		return instance;
	}

	private kakaoDAO() {
	} // useBean 태그로 객체 생성하면~

	public Connection getConnection() throws Exception {
		// 연결은 JNDI * Pool 형태로 연결 객체 생성해서 리턴할것
		Context initCtx = new InitialContext();

		DataSource ds = (DataSource) initCtx.lookup("java:comp/env/jdbc:OracleDB");

		return ds.getConnection();
	}// getConnection() end

	// insert(vo) method - 새로운 글을 게시판에 추가, 글 입력처리에 사용
	public int insert(kakaoVO vo) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		// 답변 글인지 일반(새글)인지 구분해서 입력 시키는 로직
		String lat = vo.getLat(); // 위도
		String lng = vo.getLng(); // 경도
		String addr = vo.getAddr(); // 지번주소
		String content = vo.getContent();

		StringBuffer sb = new StringBuffer();

		int result = 0;
		try {
			conn = getConnection();
			// 현재 board 테이블에 레코드 유무 판단과 글 번호 지정
			// pstmt = conn.prepareStatement("SELECT MAX(NUM) FROM BOARD");
			// rs = pstmt.executeQuery();

			// insert 처리 명령
			sb.append("insert into oneroomplanettwo(lat,lng,addr,content) ");
			sb.append(" values(?,?,?,?)");

			// System.out.println(sb.toString());

			pstmt = conn.prepareStatement(sb.toString());
			pstmt.setString(1, lat);
			pstmt.setString(2, lng);
			pstmt.setString(3, addr);
			pstmt.setString(4, content);

			result = pstmt.executeUpdate();

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			CloseUtil.close(rs);
			CloseUtil.close(pstmt);
			CloseUtil.close(conn);
		} // try end

		return result;
	}// insert() end

	public ArrayList<kakaoVO> getdb_to_markercluster(String latlng) {

		ArrayList<kakaoVO> arr2 = new ArrayList<kakaoVO>();

		latlng = latlng.replace("(", "");
		latlng = latlng.replace(")", "");
		latlng = latlng.replace(" ", "");

		String arr[] = latlng.split(",");
		System.out.println(arr.toString());
		System.out.println(latlng.toString());
		System.out.println("arr[0] = " + arr[0]); // lngmin
		System.out.println("arr[1] = " + arr[1]); // latmin
		System.out.println("arr[2] = " + arr[2]); // lngmax
		System.out.println("arr[3] = " + arr[3]); // lngmax
		String lngmin = "", lngmax = "", latmin = "", latmax = "";

		latmin = arr[0];
		latmax = arr[2];
		lngmin = arr[1];
		lngmax = arr[3];

		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		StringBuffer sb = new StringBuffer();
		try {
			conn = getConnection();

			sb.append("select*from oneroomplanettwo where" + " lat>=? and lat<=? and lng>=? and lng<=?");

			pstmt = conn.prepareStatement(sb.toString());
			pstmt.setString(1, latmin);
			pstmt.setString(2, latmax);
			pstmt.setString(3, lngmin);
			pstmt.setString(4, lngmax);

			rs = pstmt.executeQuery();

			if (rs.next()) {
				do {
					kakaoVO vo = new kakaoVO();

					vo.setLat(rs.getString("lat"));
					vo.setLng(rs.getString("lng"));
					vo.setAddr(rs.getString("addr"));
					vo.setContent("123");

					// list 객체에 데이터 저장빈인 BoardVO 객체에 저장
					arr2.add(vo);

				} while (rs.next());

			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			CloseUtil.close(rs);
			CloseUtil.close(pstmt);
			CloseUtil.close(conn);
		} // try end

		return arr2;

	}

	public int replysavedb(replyVO vo) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		// 답변 글인지 일반(새글)인지 구분해서 입력 시키는 로직
		String reply = vo.getReply(); // 위도
		String addr = vo.getAddr(); // 경도
		String id = vo.getId(); // 지번주소
		int sutja = vo.getSutja();

		StringBuffer sb = new StringBuffer();

		int result = 0;
		try {
			conn = getConnection();

			// insert 처리 명령
			sb.append("insert into oneroomplanetreply(reply,addr,id,sutja) ");
			sb.append(" values(?,?,?,?)");

			// System.out.println(sb.toString());

			pstmt = conn.prepareStatement(sb.toString());
			pstmt.setString(1, reply);
			pstmt.setString(2, addr);
			pstmt.setString(3, id);
			pstmt.setInt(4, sutja);
			// pstmt.setString(4, content);

			result = pstmt.executeUpdate();

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			CloseUtil.close(rs);
			CloseUtil.close(pstmt);
			CloseUtil.close(conn);
		} // try end

		return result;

	}

	public ArrayList getreplydata(String straddr) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList<replyVO> arr = new ArrayList<replyVO>();

		StringBuffer sb = new StringBuffer();
		int result = 0;
		try {
			conn = getConnection();
			// insert 처리 명령
			sb.append("select *from oneroomplanetreply where addr = ? order by sutja");

			// System.out.println(sb.toString());

			pstmt = conn.prepareStatement(sb.toString());
			pstmt.setString(1, straddr);

			rs = pstmt.executeQuery();

			if (rs.next()) {
				do {
					replyVO vo = new replyVO();

					vo.setAddr(rs.getString("addr"));
					vo.setId(rs.getString("id"));
					vo.setReply(rs.getString("reply"));

					System.out.println("line226");
					System.out.println(rs.getString("sutja"));
					if (rs.getString("sutja") != null) {
						vo.setSutja(Integer.parseInt(rs.getString("sutja")));
					} else {
						System.out.println("sutja data is null");

					}

					// list 객체에 데이터 저장빈인 BoardVO 객체에 저장
					arr.add(vo);
				} while (rs.next());

			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			CloseUtil.close(rs);
			CloseUtil.close(pstmt);
			CloseUtil.close(conn);
		} // try end

		return arr;

	}

	public int getidaddrfrommaxnum(String addr, String id) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		StringBuffer sb = new StringBuffer();

		int result = 0;
		try {
			conn = getConnection();
			// insert 처리 명령
			// sb.append("select count(*) from oneroomplanettwo where addr = ?");
			sb.append("select max(sutja) from oneroomplanetreply where addr=? and id=? ");

			// System.out.println(sb.toString());

			pstmt = conn.prepareStatement(sb.toString());
			pstmt.setString(1, addr);
			pstmt.setString(2, id);

			rs = pstmt.executeQuery();
			if (rs.next()) {
				if (rs.getString(1) == null) {
					result = 1;
				} else {
					result = Integer.parseInt(rs.getString(1));
				}
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			CloseUtil.close(rs);
			CloseUtil.close(pstmt);
			CloseUtil.close(conn);
		} // try end

		return result;

	}

	public int getRecordCount(String addr) { // oneroomplanettwo테이블에 저장된 레코드갯수를 반환함
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		StringBuffer sb = new StringBuffer();

		int result = 0;
		try {
			conn = getConnection();
			// insert 처리 명령
			sb.append("select count(*) from oneroomplanettwo where addr = ?");

			// System.out.println(sb.toString());

			pstmt = conn.prepareStatement(sb.toString());
			pstmt.setString(1, addr);

			rs = pstmt.executeQuery();
			if (rs.next()) {
				result = Integer.parseInt(rs.getString(1));
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			CloseUtil.close(rs);
			CloseUtil.close(pstmt);
			CloseUtil.close(conn);
		} // try end

		return result;

	}

	public ArrayList<RoomVO> getdetaildata(String straddr) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList<RoomVO> arr = new ArrayList<RoomVO>();

		StringBuffer sb = new StringBuffer();
		int result = 0;
		try {
			conn = getConnection();
			// insert 처리 명령

			String norraddr = "";
			
			int result1 = getdetailnaddressdatacount(straddr);
			
			int result2 = getdetailraddressdatacount(straddr);
			
			String str="";
			if(result1>0) {
				str="select * from roominfo where naddress like ?";
			}else {
				str="select * from roominfo where raddress like ?";
			}
			
			sb.append(str);
			// sb.append(" % ");

			// System.out.println(sb.toString());

			pstmt = conn.prepareStatement(sb.toString());
			//pstmt.setString(1, norraddr);
			pstmt.setString(1, straddr + " %");

			rs = pstmt.executeQuery();

			if (rs.next()) {
				do {
					RoomVO vo = new RoomVO();

					vo.setCONTENT(rs.getString("content"));
					vo.setDEPOSIT(rs.getInt("deposit"));
					vo.setELVE(rs.getString("elve"));
					vo.setFLOOR(rs.getString("floor"));
					vo.setIMAGE1(rs.getString("image1"));
					vo.setIMAGE2(rs.getString("image2"));
					vo.setIMAGE3(rs.getString("image3"));
					vo.setIMAGE4(rs.getString("image4"));
					vo.setIMAGE5(rs.getString("image5"));
					vo.setMPAY(rs.getString("mpay"));
					vo.setMPAY2(rs.getString("mpay2"));
					vo.setNADDRESS(rs.getString("naddress"));
					vo.setPARKING(rs.getString("parking"));
					vo.setRADDRESS(rs.getString("raddress"));
					vo.setRDATE(rs.getString("rdate"));
					vo.setRENT(rs.getInt("rent"));
					vo.setROOMTYPE(rs.getString("roomtype"));
					vo.setRSIZE(rs.getInt("rsize"));
					vo.setTITLE(rs.getString("title"));

					// list 객체에 데이터 저장빈인 BoardVO 객체에 저장
					arr.add(vo);

					System.out.println("arr.toString() = " + arr.toString());
				} while (rs.next());

			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			CloseUtil.close(rs);
			CloseUtil.close(pstmt);
			CloseUtil.close(conn);
		} // try end

		return arr;
	}

	public int getdetailnaddressdatacount( String addr) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		StringBuffer sb = new StringBuffer();

		int result = 0;
		try {
			conn = getConnection();
			// insert 처리 명령
			sb.append("select count(*) from roominfo where naddress like ?");

			// System.out.println(sb.toString());

			pstmt = conn.prepareStatement(sb.toString());

			pstmt.setString(1, addr+"%");

			rs = pstmt.executeQuery();
			if (rs.next()) {
				result = rs.getInt(1);
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			CloseUtil.close(rs);
			CloseUtil.close(pstmt);
			CloseUtil.close(conn);
		} // try end

		return result;

	}
	
	public int getdetailraddressdatacount(String addr) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		StringBuffer sb = new StringBuffer();

		int result = 0;
		try {
			conn = getConnection();
			// insert 처리 명령
			sb.append("select count(*) from roominfo where raddress like ?");

			// System.out.println(sb.toString());

			pstmt = conn.prepareStatement(sb.toString());

			pstmt.setString(1, addr+"%");

			rs = pstmt.executeQuery();
			if (rs.next()) {
				result = rs.getInt(1);
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			CloseUtil.close(rs);
			CloseUtil.close(pstmt);
			CloseUtil.close(conn);
		} // try end

		return result;

	}

}

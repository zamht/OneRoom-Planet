package map.bit.kakaomap;

public class kakaoVO {
	String lat="",lng="",addr="",content="";//����,�浵,�ּ�,����

	public String getLat() {
		return lat;
	}

	public void setLat(String lat) {
		this.lat = lat;
	}

	public String getLng() {
		return lng;
	}
	

	public void setLng(String lng) {
		this.lng = lng;
	}

	public String getAddr() {
		return addr;
	}

	public void setAddr(String addr) {
		this.addr = addr;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public kakaoVO(String lat, String lng, String addr, String content) {
		super();
		this.lat = lat;
		this.lng = lng;
		this.addr = addr;
		this.content = content;
	}

	public kakaoVO() {
		super();
	}
	
	
	

}

package map.bit.kakaomap;

public class replyVO {
	String reply="",addr="",id="";
	int sutja;
	
	public replyVO(String reply, String addr, String id, int sutja) {
		super();
		this.reply = reply;
		this.addr = addr;
		this.id = id;
		this.sutja = sutja;
	}

	public int getSutja() {
		return sutja;
	}

	public void setSutja(int sutja) {
		this.sutja = sutja;
	}

	public String getReply() {
		return reply;
	}

	public replyVO(String reply, String addr, String id) {
		super();
		this.reply = reply;
		this.addr = addr;
		this.id = id;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public void setReply(String reply) {
		this.reply = reply;
	}

	public String getAddr() {
		return addr;
	}

	public void setAddr(String addr) {
		this.addr = addr;
	}

	public replyVO(String reply, String addr) {
		super();
		this.reply = reply;
		this.addr = addr;
	}

	public replyVO() {
		super();
	}

}

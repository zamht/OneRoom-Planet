// zbee.js
// http://stackoverflow.com/questions/13478303/correct-way-to-use-modernizr-to-detect-ie
var BrowserDetect = {
	init: function () {
		this.browser = this.searchString(this.dataBrowser) || "Other";
		this.version = this.searchVersion(navigator.userAgent) || this.searchVersion(navigator.appVersion) || "Unknown";

		this.mobile = false;
		this.mobOS = this.osCheck(navigator.userAgent);
		if (/Android|webOS|iPhone|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent)) {
			this.mobile = true;
		}


		var is_vega2 = navigator.userAgent.indexOf("Chrome") == -1 && navigator.userAgent.indexOf("IM-A830S") != -1;
		var is_naver = navigator.userAgent.indexOf("NAVER") != -1;
		var is_chrome30 = navigator.userAgent.indexOf("Chrome/30.0.0.0") != -1;

		this.unsupported = is_chrome30 && this.mobile;
	},

	osCheck: function (data) {
		if (/Android/i.test(data)) {
			return 'android';
		} else if (/iPad|iPod|iPhone/i.test(data)) {
			return 'ios';
		} else {
			return ''
		}
	},

	searchString: function (data) {
		for (var i = 0; i < data.length; i++) {
			var dataString = data[i].string;
			this.versionSearchString = data[i].subString;

			if (dataString.indexOf(data[i].subString) !== -1) {
				return data[i].identity;
			}
		}
	},
	searchVersion: function (dataString) {
		var index = dataString.indexOf(this.versionSearchString);
		if (index === -1) {
			return;
		}

		var rv = dataString.indexOf("rv:");
		if (this.versionSearchString === "Trident" && rv !== -1) {
			return parseFloat(dataString.substring(rv + 3));
		} else {
			return parseFloat(dataString.substring(index + this.versionSearchString.length + 1));
		}
	},

	dataBrowser: [
		{ string: navigator.userAgent, subString: "Chrome", identity: "Chrome" },
		{ string: navigator.userAgent, subString: "MSIE", identity: "IE" },
		{ string: navigator.userAgent, subString: "Trident", identity: "IE" },
		{ string: navigator.userAgent, subString: "Firefox", identity: "Firefox" },
		{ string: navigator.userAgent, subString: "Safari", identity: "Safari" },
		{ string: navigator.userAgent, subString: "Opera", identity: "Opera" }
	]
};

BrowserDetect.init();

function guideToMobile() {
	if(!BrowserDetect.mobile) return;
	var strUrl = location.href;
	var matches = null;
	var urlApt = 'https://s.zigbang.com/mobile/gateway/20170510/apt1.html';
	var urlRoom = 'https://s.zigbang.com/mobile/gateway/20161107/room1.html';
	// oneroom map
	if(strUrl.match(/^https?\:\/\/[^\/]+\/search\//i)!=null) {
		location.href = urlRoom;
		return;
	}
	// oneroom item
	if(strUrl.match(/^https?\:\/\/[^\/]+\/items1\/(\d+)/i)!=null) {
		location.href = location.href.replace('items1', 'items2');
		return;
	}
	// apt map
	if(strUrl.match(/^https?\:\/\/[^\/]+\/apt\/map/i)!=null) {
		location.href = urlApt;
		return;
	}
	// my rooms
	if(strUrl.match(/^https?\:\/\/[^\/]+\/my\/rooms/i)!=null) {
		location.href = urlApt;
		return;
	}
	// danji to mobile share
	if(matches = strUrl.match(/^https?\:\/\/[^\/]+\/apt\/complex\/(\d+)/i)) {
		location.href = 'https://m.zigbang.com/share/detail.html?area_danji_id='+matches[1];
		return;
	}

	// regist ceo & etc
	if(strUrl.match(/^https?\:\/\/[^\/]+\/danji\/item/i)!=null || strUrl.match(/^https?\:\/\/[^\/]+\/home\/.+/i)!=null) {
		// location.href = urlRoom;
		return;
	}

	// any others
	location.href = urlApt;
}

//cookie
function zbGetCookie(cookie_name) {
	var cookie_value = document.cookie;
	var cookie_start = cookie_value.indexOf(" " + cookie_name + "=");
	if (cookie_start == -1) {
		cookie_start = cookie_value.indexOf(cookie_name + "=");
	}
	if (cookie_start == -1) {
		cookie_value = null;
	} else {
		cookie_start = cookie_value.indexOf("=", cookie_start) + 1;
		var cookie_end = cookie_value.indexOf(";", cookie_start);
		if (cookie_end == -1) {
			cookie_end = cookie_value.length;
		}
		cookie_value = unescape(cookie_value.substring(cookie_start, cookie_end));
	}
	return cookie_value;
}

function zbSetCookie(cookie_name, cookie_day) {
	var expire = new Date();
	expire.setDate(expire.getDate() + cookie_day);
	var cookies = cookie_name + '=' + escape('true') + '; path=/; expires=' + expire.toGMTString() + ';';
	document.cookie = cookies;

}

// deprecated - 로 판단되나 앱에서 사용할 가능성도 있음
var _zb_item_img_index = 1;
function zbGetItemImageUrl(item_id, position, w, h) {
	return "//ic.zigbang.com/items/" + item_id + "/" + position + ".jpg?w=" + w + "&h=" + h + "&q=100";
}

function zbGetItemImageUrlFromItemDetail(item, position, w, h) {
    //console.log("position", item)
    if (item.images_thumbnail != "" || item.images) {
        var url = item.images_thumbnail != "" ? item.images_thumbnail : item.images[position - 1].url; 
	    if (url.indexOf("http:") == -1)
		    url = "https://ic.zigbang.com/ic" + url;
	    return url + "?w=" + w + "&h=" + h;
    } else {
        return ""
    }
    
}

// deprecated - 로 판단되나 앱에서 사용할 가능성도 있음
function zbGetItemImageUrl2(item_id, position, w, h) {
	return "//ic.zigbang.com/items/" + item_id + "/" + position + ".jpg?w=" + w + "&h=" + h;
}

function zbLazy(str, container) {
	$(str).lazy({
		appendScroll: $(container),
		chainable: false,
		bind: "event",
		onError: function (element) {
			var alternative = $(element).data("alternative");
			var target = $(element).data("target");
			if (alternative && target != "alternative") {
				$(element).data("original", $(element).attr("src"));
				$(element).attr("src", alternative);
				$(element).data("target", "alternative");
			} else {
				$(element).attr("src", $(element).data("original"));
			}
		}
	});
}

var zbValidation = {
	isNum: function (n) {
		var re = /^[0-9]+$/;
		if (!re.test(n)) {
			return false
		}
		return true;
	},
	isNumAndPoint: function (n) {
		var re = /^\d*(\.\d+)?$/;
		if (!re.test(n)) {
			return false
		}
		return true;
	},

	isPhone: function (n) {
		var re = /^[0-9]+$/;
		if (n.length >= 12 || n.length < 10) {
			return false;
		}
		if (!re.test(n)) {
			return false
		}
		return true;
	}

}


var was_slept = false;

if (!BrowserDetect.mobile) {
	if (window.location.protocol == 'http:') {
		var ssl_url = 'https://' + window.location.hostname + window.location.pathname + window.location.search;
		//window.location = ssl_url;
	}
}

var number_validate = function (event) {
	var key = window.event ? event.keyCode : event.which;
	if (key == 32) {
		window.event.returnValue = false;
	}
};

function getParameterByName(name) {
	name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
	var regex = new RegExp("[\\?&|&amp;]" + name + "=([^&#]*)"),
	results = regex.exec(location.search);
	return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
}

function showPlaceholder() {
	if (BrowserDetect.browser == "IE" && BrowserDetect.version <= 9) {
		$('input[type=text], textarea').placeholder();
	}
}

function createBgLayerIfNecessary() {
	if (!$("#bg-layer").length > 0) {
		$(document.body).append($("<div />").addClass("bg-layer").attr("id", "bg-layer"));
	}

	$("#bg-layer").show();
}

function creatTempAlert(){
	var body = $("body"), setTime;
	var div = document.createElement('div');
	div.className="tmp_alert_layer";
	return function(str){
		$(div).remove();
		if(setTime) clearTimeout(setTime);
		div.innerHTML = str;
		body.append(div);
		setTime = setTimeout(function(){
			$(div).remove();
		},2000);
	}
}

function createLoginLayer(username) {
	createBgLayerIfNecessary();

	zbGetTpl('layer-login-template', function (strHtml) {
		var template = Handlebars.compile(strHtml);
		var layer = $(template({}));
		$(document.body).append(layer);
		layer.show();

		var e_close = $(layer).find(".layer-close");
		e_close.click(function () {
			layer.remove(); $("#bg-layer").hide();
		});

		var e_username = $(layer).find("input[name=username]");
		if (username) { e_username.val(username); }
		e_username.focus();

		var e_join = $(layer).find(".join");
		e_join.click(function () {
			layer.remove();
			createJoinLayer();
		});

		var e_find = $(layer).find(".find");
		e_find.click(function () {
			layer.remove();
			createFindEmailLayer();
		});

		var form = $(layer).find("form");
		form.submit(function () {
			var e_submit = $(layer).find("button[type=submit]");
			e_submit.attr("disabled", true);

			var username = e_username.val();
			if (!username) {
				alert("이메일을 입력해 주시기 바랍니다.");
				e_username.focus();
				e_submit.attr("disabled", false);
				return false;
			}

			$.ajax({
				type: "POST",
				url: "//" + api_host + "/v1/account/login1",
				data: { email: username },
				success: function (data) {
					was_slept = data.was_slept;
					if (!data) {
						alert("사용자의 이메일을 확인해 주시기 바랍니다.");
						e_submit.attr("disabled", false);
						return;
					}

					var autologin = $(layer).find("input[type=checkbox]").is(":checked");
					if (!data.secure_token) {
						layer.remove();
						createPasswordLayer(username, autologin);
					}

					if (data.secure_token) {
						$.ajax({
							type: "POST",
							url: "/account/legacy",
							data: { email: username, autologin: autologin },
							success: function (data) {
								layer.remove();
								if (was_slept) {
									sleepLayerShow();
								} else {
									location.reload();
								}
							}
						}).fail(function () {
							alert("사용자의 이메일을 확인해 주시기 바랍니다.");
							e_submit.attr("disabled", false);
						});
					}
				}
			}).fail(function () {
				alert("사용자의 이메일을 확인해 주시기 바랍니다.");
				e_submit.attr("disabled", false);
			});

			return false;
		});
	});
}

function createPasswordLayer(username, autologin) {
	createBgLayerIfNecessary();

	zbGetTpl('layer-pw-set-template', function (strHtml) {
		var template = Handlebars.compile(strHtml);
		var layer = $(template({}));
		$(document.body).append(layer);
		layer.show();

		var e_close = $(layer).find(".layer-close");
		e_close.click(function () { layer.remove(); $("#bg-layer").hide(); });

		var e_password = $(layer).find("input[type=password]");
		e_password.focus();

		var e_findPassword = $(layer).find(".layer-findpassword");
		$(e_findPassword).click(function () {
			layer.remove();
			createFindPasswordLayer(username);

		});

		var form = $(layer).find("form");
		form.submit(function () {
			var e_submit = $(layer).find("button[type=submit]");
			e_submit.attr("disabled", true);

			var password = e_password.val();
			if (!password) {
				alert("패스워드를 입력해 주시기 바랍니다.");
				e_password.focus();
				e_submit.attr("disabled", false);
				return false;
			}

			$.ajax({
				type: "POST",
				url: "https://" + api_host + "/v1/account/login2",
				data: { email: username, password: password },
				success: function (data) {
					was_slept = data.was_slept;
					if (!data) {
						alert("ID 또는 패스워드를 확인해 주시기 바랍니다.");
						return;
					}

					if (data.secure_token) {
						$.ajax({
							type: "POST",
							url: "//" + window.location.host + "/account/Legacy",
							data: { email: username, password: password, autologin: autologin },
							success: function (data) {
								layer.remove();
								if (was_slept) {
									sleepLayerShow();
								} else {
									location.reload();
								}
							}
						}).fail(function () {
							alert("ID 또는 패스워드를 확인해 주시기 바랍니다.");
							e_submit.attr("disabled", false);
						});
					}
				}
			}).fail(function () {
				alert("ID 또는 패스워드를 확인해 주시기 바랍니다.");
				e_submit.attr("disabled", false);
			});

			return false;
		});
	});
}

function createFindPasswordLayer(username) {
	createBgLayerIfNecessary();

	zbGetTpl('layer-pw-find-template', function (strHtml) {
		var template = Handlebars.compile(strHtml);
		var layer = $(template({}));
		$(document.body).append(layer);
		layer.show();

		var e_email = $(layer).find("input[name=username]");
		e_email.focus();
		if (username) {
			e_email.val(username);
		}

		var e_close = $(layer).find(".layer-close");
		e_close.click(function () { layer.remove(); $("#bg-layer").hide(); });

		$(layer).find(".layer-btn button[type=button]").click(function () {
			var url = "//" + api_host + "/v1/account/password";
			var data = { email: e_email.val() };
			$.ajax({
				type: "POST",
				url: url,
				data: data
			}).success(function (data) {
				if (data) {
					alert(data);
					layer.remove(); $("#bg-layer").hide();
				}
			}).fail(function (jqXHR, textStatus, errorThrown) {
				var response = jqXHR.responseText;
				if (response) alert(response);
				else alert("이메일을 확인해 주세요");
			});
		});
	});
}

function createFindEmailLayer() {
	createBgLayerIfNecessary();

	zbGetTpl('layer-email-find-template', function (strHtml) {
		var template = Handlebars.compile(strHtml);
		var layer = $(template({}));
		$(document.body).append(layer);
		layer.show();

		var e_close = $(layer).find(".layer-close");
		e_close.click(function () { layer.remove(); $("#bg-layer").hide(); });

		var e_phone1 = $(layer).find("select[name=phone1]");
		var e_phone2 = $(layer).find("input[name=phone2]");
		var e_phone3 = $(layer).find("input[name=phone3]");
		var e_authNum = $(layer).find("input[name=authNum]");
		var e_submit = $(layer).find(".btn-ok");

		var phones = [e_phone1, e_phone2, e_phone3];
		var e_authtoken;

		e_phone1.focus();

		//인증번호 발송 + 재발송 버튼
		var e_sendAuthNum = $(layer).find(".sendAuthNum");

		e_sendAuthNum.click(function () {
			var valid = true;
			var regex = /^[0-9]+$/;
			$.each(phones, function (i, e) {
				if (!e.val()) {
					alert("핸드폰 번호를 입력해 주세요.");
					e.focus();
					valid = false;
					return false;
				}
				if (!regex.test(e.val())) {
					alert("숫자만 입력해 주세요.");
					e.focus();
					valid = false;
					return false;
				}
			});
			if (!valid) { return false; }

			$.ajax({
				type: "POST",
				url: "//" + api_host + "/v1/account/sms",
				data: {
					phone: e_phone1.val() + e_phone2.val() + e_phone3.val()
				},
				success: function (data) {
					if (data) {
						e_authtoken = data;
						alert("인증번호가 전송되었습니다.");
						e_authNum.focus();
					}
				}
			}).fail(function (jqXHR, textStatus, errorThrown) {
				var message = jqXHR.responseText;
				if (message) alert(message);
				e_submit.attr("disabled", false);
			});
		});

		// 확인 버튼
		e_submit.click(function () {
			if (e_authtoken == null) {
				alert("인증번호 발송을 해주세요.");
				e_sendAuthNum.focus();
				return false;
			}
			if (!e_authNum.val()) {
				alert("인증번호를 입력해 주세요.");
				e_authNum.focus();
				return false;
			}

			e_submit.attr("disabled", true);

			var ajax_url = "//" + api_host + "/v1/account/auth/email";
			$.ajax({
				type: "POST",
				url: ajax_url,
				data: {
					code: e_authNum.val(),
					authtoken: e_authtoken
				},
				success: function (data) {
					if (data && data.length > 0) {
						layer.remove();
						createFindEmailResultLayer(data);
					} else {
						alert("가입되지 않은 번호 입니다. 핸드폰 번호를 확인해주세요.");
						e_submit.attr("disabled", false);
						return false;
					}
				}
			}).fail(function (jqXHR, textStatus, errorThrown) {
				var message = jqXHR.responseText;
				if (message) alert(message);
				e_submit.attr("disabled", false);
			});
		});
	});
}

function createFindEmailResultLayer(data) {
	createBgLayerIfNecessary();

	zbGetTpl('layer-email-result-template', function (strHtml) {
		var template = Handlebars.compile(strHtml);
		var layer = $(template({}));
		$(document.body).append(layer);
		layer.show();

		var e_close = $(layer).find(".layer-close");
		e_close.click(function () {
			layer.remove(); $("#bg-layer").hide();
		});

		var e_login = $(layer).find(".login");
		var e_pw = $(layer).find(".pw");
		var e_results = $(layer).find(".email-results");
		var template = "<div class='result'><span class='email bold'>##EMAIL##</span><br /><span class='date'>##DATE##</span></div>";

		var result = "";
		var username = "";
		if (data && data.length > 0) {
			for (var i = 0; i < data.length; i++) {
				var obj = data[i];
				var email = obj.email ? obj.email : "";
				var date = obj.register_date ? obj.register_date : "";
				if (i > 0) {
					result += "<br />";
				}
				result += template.replace("##EMAIL##", email).replace("##DATE##", date);
			}
			username = data[0].email;
		}
		e_results.append(result);

		e_login.click(function () {
			layer.remove();
			createLoginLayer(username);
		});

		e_pw.click(function () {
			layer.remove();
			createFindPasswordLayer(username);
		});
	});
}

function createJoinLayer() {
	createBgLayerIfNecessary();

	zbGetTpl('layer-join-template', function (strHtml){
		var template = Handlebars.compile(strHtml);
		var layer = $(template({}));
		$(document.body).append(layer);
		layer.show();

		var e_close = $(layer).find(".layer-close, .btn-cancel");
		e_close.click(function () { layer.remove(); $("#bg-layer").hide(); });

		var e_username = $(layer).find("input[name=username]");
		e_username.focus();

		$(layer).find(".layer-other-links .link1").click(function () {
			layer.remove();
			createLoginLayer();
		});

		var form = $(layer).find("form");
		form.submit(function () {
			var e_submit = $(layer).find("button[type=submit]");
			e_submit.attr("disabled", true);

			var username = e_username.val();
			if (!username) {
				alert("이메일을 입력해 주시기 바랍니다.");
				e_username.focus();
				e_submit.attr("disabled", false);
				return false;
			}

			if (!$(layer).find("input[name=agree]").is(":checked")) {
				alert("이용약관과 개인정보 취급 방침에 동의해 주세요.");
				e_submit.attr("disabled", false);
				return false;
			}

			if (!$(layer).find("input[name=agree2]").is(":checked")) {
				alert("이용약관과 개인정보 취급 방침에 동의해 주세요.");
				e_submit.attr("disabled", false);
				return false;
			}

			$.ajax({
				type: "POST",
				url: "//" + api_host + "/v1/account/register",
				data: { email: username },
				success: function (data) {
					if (data && data.secure_token) {
						alert("회원가입이 완료되었습니다.");
						layer.remove();
						createLoginLayer();
					}
				}
			}).fail(function (jqXHR, textStatus, errorThrown) {
				var message = jqXHR.responseText;
				if (message) alert(message);
				e_submit.attr("disabled", false);
			});

			return false;
		});
	});
}

var is_login = false;
function createJoinLayer2(email,userToken) {
	createBgLayerIfNecessary();

	zbGetTpl('layer-join2-template', function(strHtml) {
		var template = Handlebars.compile(strHtml);
		var layer = $(template({}));
		$(document.body).append(layer);
		layer.show();

		var e_close = $(layer).find(".layer-close, .btn-cancel");
		e_close.click(function () { layer.remove(); $("#bg-layer").hide(); });

		if (email && userToken) {
			$(layer).find("input[name=email]").val(email);
			$(layer).find("input[name=email]").attr("disabled", true);
			is_login = true;
		} else {
			is_login = false;
		}

		var e_username = $(layer).find("input[name=username]");
		var e_email = $(layer).find("input[name=email]");
		var e_password = $(layer).find("input[name=password]");
		var e_password1 = $(layer).find("input[name=password1]");
		var e_phone1 = $(layer).find("select[name=phone1]");
		var e_phone2 = $(layer).find("input[name=phone2]");
		var e_phone3 = $(layer).find("input[name=phone3]");
		var e_authNum = $(layer).find("input[name=authNum]");
		var e_submit = $(layer).find("button[type=submit]");
		var e_authtoken;

		e_username.focus();

		//기존회원 로그인 버튼
		$(layer).find(".show-login").click(function () {
			layer.remove();
			createLoginLayer();
		});

		//인증번호 발송 + 재발송 버튼
		var e_sendAuthNum = $(layer).find(".sendAuthNum");

		e_sendAuthNum.click(function () {
			$.ajax({
				type: "POST",
				url: "//" + api_host + "/v1/account/auth/sms",
				data: {
					phone: e_phone1.val() + e_phone2.val() + e_phone3.val()
				},
				success: function (data) {
					if (data) {
						e_authtoken = data;
						alert("인증번호가 전송되었습니다.");
					}
				}
			}).fail(function (jqXHR, textStatus, errorThrown) {
				var message = jqXHR.responseText;
				if (message) alert(message);
				e_submit.attr("disabled", false);
			});
		});

		//확인 버튼
		var form = $(layer).find("form");
		form.submit(function () {
			e_submit.attr("disabled", true);



			if ($(layer).find("input[name=username]").val() == "") {
				alert("이름을 입력해주세요.");
				e_submit.attr("disabled", false);
				return false;
			}
			var v_only_kor = /[^가-힣]/g;
			if (v_only_kor.test($(layer).find("input[name=username]").val())) {
				alert("한글만 입력가능합니다");
				e_submit.attr("disabled", false);
				return false;
			}

			if (e_authtoken == null) {
				alert("인증번호 발송을 해주세요");
				e_submit.attr("disabled", false);
				return false;
			}

			if (!$(layer).find("input[name=agree]").is(":checked")) {
				alert("이용약관과 개인정보 취급 방침에 동의해 주세요.");
				e_submit.attr("disabled", false);
				return false;
			}

			if (!$(layer).find("input[name=agree2]").is(":checked")) {
				alert("이용약관과 개인정보 취급 방침에 동의해 주세요.");
				e_submit.attr("disabled", false);
				return false;
			}

			var check_data = "1";
			var ajax_url = "//" + api_host + "/v1/account/register";
			if (is_login) {
				check_data = "2";
				ajax_url = "//" + api_host + "/v1/account/modify";
			}

			$.ajax({
				type: "POST",
				url: ajax_url,
				data: {
					userToken: userToken,
					email: e_email.val(),
					user_name: e_username.val(),
					password1: e_password.val(),
					password2: e_password1.val(),
					code: e_authNum.val(),
					authtoken: e_authtoken
				},
				success: function (data) {
					if (check_data == "2") {
						alert("회원가입이 완료되었습니다.");
						location.href = '/my/rooms/null/modify';
					} else {
						if (data && data.secure_token) {
							alert("회원가입이 완료되었습니다.");
							layer.remove();
							createLoginLayer();
						}
					}
				}
			}).fail(function (jqXHR, textStatus, errorThrown) {
				var message = jqXHR.responseText;
				if (message.length < 100) {
					if (message) alert(message);
					e_submit.attr("disabled", false);
				} else {
					alert("회원가입이 완료되었습니다.");
					layer.remove();
					createLoginLayer();
				}
			});

			return false;
		});
	});
}

function createAgentTypeLayer(type) {
	createBgLayerIfNecessary();

	zbGetTpl('layer-agent-info-template', function(strHtml) {
		var template = Handlebars.compile(strHtml);
		var layer = $(template({}));
		$(document.body).append(layer);
		layer.show();

		var e_close = $(layer).find(".layer-close");
		e_close.click(function () { layer.remove(); $("#bg-layer").hide(); });

		$("#agent_type1, #agent_type2").hide();
		$("#agent_type" + type).show();
	});
}

function createPhoneTypeLayer(type) {
	createBgLayerIfNecessary();
	
	function PopupCenter(url, title, w, h) {
		// Fixes dual-screen position                         Most browsers      Firefox
		var dualScreenLeft = window.screenLeft != undefined ? window.screenLeft : screen.left;
		var dualScreenTop = window.screenTop != undefined ? window.screenTop : screen.top;

		var width = window.innerWidth ? window.innerWidth : document.documentElement.clientWidth ? document.documentElement.clientWidth : screen.width;
		var height = window.innerHeight ? window.innerHeight : document.documentElement.clientHeight ? document.documentElement.clientHeight : screen.height;

		var left = ((width / 2) - (w / 2)) + dualScreenLeft;
		var top = ((height / 2) - (h / 2)) + dualScreenTop;
		var newWindow = window.open(url, title, 'scrollbars=yes, width=' + w + ', height=' + h + ', top=' + top + ', left=' + left);

		// Puts focus on the newWindow
		if (window.focus) {
			newWindow.focus();
		}
	}
	
	zbGetTpl('layer-phone-info-template', function(strHtml) {
		var template = Handlebars.compile(strHtml);
		var layer = $(template({}));
		var isPhone = false;
		var isAddr = false;
		var isCheck = false;
		
		$(document.body).append(layer);
		//layer.show();

		var e_close = $(layer).find(".layer-close");
		e_close.click(function () { layer.remove(); $("#bg-layer").hide(); });
		$(".phone-complete-layer .btn-confirm").on("click",function () {
			layer.remove(); $("#bg-layer").hide();
		});

		function enableButton() {
			//$(".phone-apply-layer .btn-apply").removeClass("disable").addClass("enable");
		}
		
		function disableButton() {
			//$(".phone-apply-layer .btn-apply").addClass("disable").removeClass("enable");
		}

		$(".phone-apply-layer .phone input").on("keyup",function () {
			var re = /^[0-9]+$/;
			if(!(9 <= $(this).val().length && $(this).val().length <= 11)) {

				isPhone=false;
			} else {

				if(!re.test($(this).val())) {
					isPhone=false;
				} else {

					isPhone=true;
				}
			}
			
			
			if (isPhone && isAddr && isCheck) enableButton();
			else disableButton();
			
		});

		$(".phone-apply-layer .address input").on("keyup",function () {
			if ($(this).val().length>1) isAddr=true;
			else isAddr=false;

			if (isPhone && isAddr && isCheck) enableButton();
			else disableButton();

		});
		
		$(".phone-apply-layer .img_checkbox a").on("click",function () {
			if ($(this).hasClass("active")) {
				isCheck = false;
				$(this).removeClass("active");
			} else {
				isCheck = true;
				$(this).addClass("active");
			}

			if (isPhone && isAddr && isCheck) enableButton();
			else disableButton();
		})
		
		$(".phone-apply-layer .agree a").on("click",function () {
			PopupCenter('http://s.zigbang.com/event/myroom/room_agree_popup.html','agree','600','600');
		});
		
		$(document).on("click",".phone-apply-layer .btn-apply.enable",function(e) {
			e.stopImmediatePropagation();
			
			if (!isPhone) {
				alert("번호를 정확하게 입력해주세요.");
				$(".phone-apply-layer .phone input").focus();
				return false;
			}

			if (!isAddr) {
				alert("주소를 정확하게 입력해주세요.");
				$(".phone-apply-layer .address input").focus();
				return false;
			}
			
			if (!isCheck) {
				alert("이용약관을 동의해주세요.");
				$(".phone-apply-layer .img_checkbox a").focus();
				return false;
			}
			
			$.ajax({
				type: "POST",
				dataType:'json',
				contentType: 'application/json',
				url: apis_host + "/oneroom/requestroom/simple",
				data: JSON.stringify({
					"phone" : $(".phone-apply-layer .phone input").val(),
					"inq_device" : "web",
					"address" : $(".phone-apply-layer .address input").val()
				}),
				success: function (data) {
					$(".phone-apply-layer").hide();
					$(".phone-complete-layer").show();
				}
			}).fail(function () {
				alert("오류가 발생했습니다. 다시 작성해 주세요.");
			});
		});
		
		
		$("#agent_type1, #agent_type2").hide();
		$("#agent_type" + type).show();
	});
}

// 공통 얼럿 레이어
function cearteAlertLayer(tit, txt, callback) {
	createBgLayerIfNecessary();

	zbGetTpl('layer-alert-template', function (strHtml) {
		var template = Handlebars.compile(strHtml);
		var tempData = {
			title: tit,
			text: txt
		}
		var layer = $(template(tempData));
		$(document.body).append(layer);
		layer.show();

		$(layer).find(".layer-close").click(function () {
			layer.remove();
			$("#bg-layer").hide();
		});

		$(layer).find(".layer-btn button").click(function () {
			layer.remove();
			$("#bg-layer").hide();
		});

		if (callback) {
		    callback();
		}
	});
}

// 공통 컨펌 레이어
function cearteConfirmtLayer(tit, txt, callback) {
	createBgLayerIfNecessary();

	zbGetTpl('layer-confirm-template', function (strHtml) {
		var template = Handlebars.compile(strHtml);
		var tempData = {
			title: tit,
			text: txt
		}
		var layer = $(template(tempData));
		$(document.body).append(layer);
		layer.show();

		$(layer).find(".layer-close").click(function () {
			layer.remove();
			$("#bg-layer").hide();
		});

		$(layer).find(".layer-btn button").click(function () {
			layer.remove();
			$("#bg-layer").hide();
		});
		if (callback) {
		    callback();
		}
	});
}

function createNoticeLayer(option) {
	var notice_data = [];
	var user_type = user_type_all;
	var today = new Date().yyyymmdd();
	var data_url = apis_host + "/banner?date=" + today + "&location=notice_web&platform=web&option=" + option + "&user_type=" + user_type;
	$.when(
		$.ajax({
			type: "GET",
			dataType: "json",
			url: data_url
		})
	).done(function (data) {
		if (data && data.length != 0) {
			notice_data.img_url = data[0].image_url;
			notice_data.link_url = data[0].link_url;
			notice_data.title = data[0].title;
			notice_data.id = "zbNoticeId_" + data[0].id;
			if (!Cookies.get(notice_data.id)) {
				noticeLayerShow(notice_data);
			}
		}
	});
}

function noticeLayerShow(notice_data) {
	createBgLayerIfNecessary();

	zbGetTpl('layer-main-notice-template', function (strHtml) {
		var template = Handlebars.compile(strHtml);
		var layer = $(template(notice_data));
		$(document.body).append(layer);
		$(layer).find(".item_body img").load(function () {

			$(layer).css({
				"marginLeft": -($(layer).width() / 2) + "px"
			});
			layer.show();
		})

		$(".main-notice-layer .i-hide").click(function () {
			if ($(".main-notice-layer .item_check input[type=checkbox]").is(":checked")) {
				Cookies.set(notice_data.id, true, 86400);
			}
			layer.remove();
			$("#bg-layer").remove();
		});
	});
}

function sleepLayerShow() {
	if (!BrowserDetect.mobile) {
		createBgLayerIfNecessary();

		zbGetTpl('layer-sleep-member-template', function (strHtml) {
			var template = Handlebars.compile(strHtml);
			var layer = $(template());
			$(document.body).append(layer);
			layer.show();

			$(layer).find(".layer-close").click(function () {
				layer.remove();
				$("#bg-layer").hide();
				location.reload();
			});

			$(layer).find(".layer-btn button").click(function () {
				layer.remove();
				$("#bg-layer").hide();
				location.reload();
			});
		});
	}
}

;
var zbDanjiCommon = {
	checkIE8: function (section, ver) {
		if (BrowserDetect.browser == "IE" && BrowserDetect.version < ver) {
			return {
				check: true,
				msg: section + "는 현재 웹 브라우저 버전에서 지원되지 않습니다. <br />모든 브라우저에서 제약 없이 이용하실 수 있도록 현재 준비 중이며,<br />최신 버전으로 업그레이드하거나 크롬에서 이용하시면 지금 바로 사용할 수 있습니다.",
			}
		} else {
			return {
				check: false,
			}
		}
	},
	getAjaxData: function (type, url, contentType, data) {
		return $.ajax({
			type: type,
			contentType: (!contentType) ? "application/x-www-form-urlencoded" : contentType,
			data: data,
			url: url
		});
	},
	templates: function (origin, data, target, callback) {
		var tTemplate = $(origin).html();
		var template = Handlebars.compile(tTemplate);
		tHtml = template(data);

		$(target).html(tHtml);

		if (typeof callback == 'function') {
			callback();
		}
	},
	getPoint: function (score) {

		var fixed = 0;
		var score = score.toString();

		if (score.indexOf('.') > -1) {
			fixed = score.split('.')[1].charAt(0);
		}

		if (fixed > 0 && fixed < 3) {
			fixed = Math.floor(score);
		} else if (fixed > 2 && fixed < 8) {
			fixed = Math.floor(score.split('.')[0]) + 0.5;
		} else if (fixed > 7) {
			fixed = Math.round(score);
		} else {
			fixed = Math.floor(score).toFixed(1);
		}
		return fixed;
	},
	//handlebar helpers get star expression
	getStar: function (score, type) {
		var html = '';
		var icoType = "icon-star";
		var rScore = zbDanjiCommon.getPoint(score);

		for (var i = 0; i < 5; i++) {
			if (i < Math.round(rScore)) {
				if ((rScore % 1) > 0 && Math.floor(rScore) == i) {
					html += '<span class="i_half"><span class="zbIcon ' + icoType + '_on"></span><span class="zbIcon icon-star_half on"></span></span>';
				} else {
					html += '<span class="zbIcon ' + icoType + '_on on"></span>';
				}
			} else {
				html += '<span class="zbIcon ' + icoType + '_on "></span>';
			}

		}
		return html;
	},
	//get query string
	getParameterByName: function (name, url) {
		if (!url) url = window.location.href;
		name = name.replace(/[\[\]]/g, "\\$&");
		var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
				results = regex.exec(url);
		if (!results) return null;
		if (!results[2]) return '';

		return decodeURIComponent(results[2].replace(/\+/g, " "));
	},
	getPriceFormat: function (price) {
		var price = price.toString();
		var result = 0;

		if (price.length == 4) {
			price = price.substring(0, 1) + '.' + price.substring(1, 2) + price.substring(2, 3);

			if (price.substring(2, 3) == '0' && price.substring(3, 4) == '0') {
				price = price.substring(0, 1);
			}

			if (price.substring(3, 4) == '0') {
				price = price.substring(0, 1) + '.' + price.substring(2, 3);

				if (price.substring(2, 3) == '0') {
					price = price.substring(1, 2);
				}
			}
		} else if (price.toString().length == 5) {
			price = price.substring(0, 1) + price.substring(1, 2) + '.' + price.substring(2, 3);

			if (price.substring(3, 4) == '0') {
				price = price.substring(0, 1) + price.substring(1, 2);
			}

		} else if (price.toString().length == 6) {
			price = price.substring(0, 1) + price.substring(1, 2) + price.substring(2, 3);
		} else {
			price = '0' + '.' + price.substring(0, 1) + price.substring(1, 2);

			if (price.substring(3, 4) == '0') {
				price = '0' + '.' + price.substring(2, 3);
			}
		}

		//result = ((Math.round(price * 10) / 100) === 0) ? '-' : (Math.round(price * 10) / 100);

		return (Math.round(price * 10) / 100).toFixed(1);
	},
	getPriceFormat2: function (price) {
	    var p = (priceToKmoney(price) == 0) ? "-" : priceToKmoney(price);
		return p;
	},
	getPriceFormat3: function (price, u) {
        var unit = u
	    if(price) {
	        return priceToKmoney(price);
	    } else {
	        return (unit) ? "-" + unit : " - ";
	    }
	},
	getNumComma: function (num) {
		if (!num) return 0;
		var n = num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
		return n;
	},
	getImageSize: function (url, size) {
		return url + size;
	},
	//handlebar helpers get introImg expression
	getLineFeed: function (contents) {
		if (contents) {
			return contents.replace(/\n/g, '<br />');
		} else {
			return '';
		}
	},
	getPrice: function (price) {
		return price.toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,");
	},
	getZeroOrMan: function (price) {
		//var price = (price === 0) ? price : price + '만';
		//var price = price + '만';
		return zbDanjiCommon.getPriceFormat2(price);
	},
	//handlebar helpers get Price expression
	getSalesStatus: function (salesPercentChange, salesPriceChange) {
		var direction = '';
		var status = '';

		if (!salesPercentChange) {
			direction = "fix";
		} else if (salesPercentChange < 0) {
			direction = "down";
			status = "";
		} else if (salesPercentChange > 0) {
			direction = "up";
			status = "+";
		}

		return {
			"direction": direction,
			"status": status,
		};
	},
	telFormat: function (num) {

		var formatNum = '';

		if (num) {
			if (num.length == 11) {
				formatNum = num.replace(/(\d{3})(\d{4})(\d{4})/, '$1-$2-$3');
			} else if (num.length == 8) {
				formatNum = num.replace(/(\d{4})(\d{4})/, '$1-$2');
			} else if (num.length == 9) {
				formatNum = num.replace(/(\d{2})(\d{3})(\d{4})/, '$1-$2-$3');
			} else {
				if (num.indexOf('02') == 0) {
					formatNum = num.replace(/(\d{2})(\d{4})(\d{4})/, '$1-$2-$3');
				} else {
					formatNum = num.replace(/(\d{3})(\d{3})(\d{4})/, '$1-$2-$3');
				}
			}
		}


		return formatNum;
	},
	getConvertUTime: function (utime) {
		var year = new Date(utime * 1000).getFullYear();
		var month = new Date(utime * 1000).getMonth() + 1;

		return {
			"year": year,
			"month": month,
		}
	},
	getDirection: function (direction) {
		var cls_name = 'fix';

		if (direction === 'up') {
			cls_name = 'icon-listUp';
		} else if (direction === 'down') {
			cls_name = 'icon-listDown';
		} else {
			return '<span class=' + cls_name + '></span>';
		}

		return '<span class=' + cls_name + '></span>';
	},
	isFlash: function () {
		var hasFlash = false;
		try {
			var fo = new ActiveXObject('ShockwaveFlash.ShockwaveFlash');
			if (fo) hasFlash = true;
		}
		catch (e) {
			if (navigator.mimeTypes["application/x-shockwave-flash"] != undefined) hasFlash = true;
		}
		return hasFlash;
	},
	trim: function (str) {
		return str.replace(/(^\s*)|(\s*$)/gi, "");
	},
	getDateKor: function (str) {
		return str.replace(/\d+[-.]0*(\d+)[-.]0*(\d+)/, '$1' + '월 ' + '$2' + '일');
	},
	removeLoading: function () {
		$('.danzi-loading-container').hide();
	},
	zzim: {
		set: function (id) {
			console.log("zzim.set", id)
			if (!zbDanjiCommon.zzim.get(id)) {
				zbDanjiCommon.localStorageCheck()
				var localZB = zbDanjiCommon.zzim.getList();
				localZB.push(id)
				zbDanjiCommon.zzim.setList(localZB);
			}
		},
		setList: function (arr) {
			var agent = navigator.userAgent.toLowerCase();
			if ((navigator.appName == 'Netscape' && navigator.userAgent.search('Trident') != -1) || (agent.indexOf("msie") != -1)) {
				Cookies.set('_zbZZIM', arr);
			}
			localStorage.setItem("_zbZZIM", arr)
		},
		remove: function (id) {
			console.log("remove")
			var localZB = zbDanjiCommon.zzim.getList();
			var arr = [];
			for (var i = 0; i < localZB.length; i++) {
				if (parseInt(localZB[i]) != parseInt(id)) {
					arr.push(parseInt(localZB[i]));
				}
			}
			zbDanjiCommon.zzim.setList(arr);
		},
		get: function (id) {
			if (!localStorage.getItem("_zbZZIM")) return false;
			var localZB = zbDanjiCommon.zzim.getList();
			if (localZB.length == 0) return false;

			for (var i = 0; i < localZB.length; i++) {
				if (parseInt(localZB[i]) == id) {
					return true;
				}
			}
			return false;
		},
		getList: function () {
			var result;
			zbDanjiCommon.localStorageCheck();
			var agent = navigator.userAgent.toLowerCase();
			localStorage.setItem("_zbZZIM", localStorage.getItem("_zbZZIM").split(",").filter(Number))

			var result = localStorage.getItem("_zbZZIM");

			if ((navigator.appName == 'Netscape' && navigator.userAgent.search('Trident') != -1) || (agent.indexOf("msie") != -1)) {
				Cookies.set('_zbZZIM', Cookies.get('_zbZZIM').split(",").filter(Number))
				if (Cookies.get('_zbZZIM') != result) {
					localStorage.setItem("_zbZZIM", result)
					result = Cookies.get('_zbZZIM')
				}
			}
			return result.split(",");
		}
	},
	localStorageCheck: function (id) {
		id = id || "_zbZZIM";
		if (!localStorage.getItem(id)) {
			localStorage.setItem(id, "");
		}
		var agent = navigator.userAgent.toLowerCase();
		if ((navigator.appName == 'Netscape' && navigator.userAgent.search('Trident') != -1) || (agent.indexOf("msie") != -1)) {
			if (!Cookies.get(id)) {
				Cookies.set(id, "");
			}
		}
	}
};


var popFn = {//레이어 팝업 띄우는 공통 함수
	show: function (t, params) {
		var defaults = {
			onStart: "",
			onClose: "",
			btnCloseCl: 'btn-close',
			bgEle: '.bg-layer',
			resize: true,
			htmlOverhide: true,
			setScroll: true,
			showAfterImgLoad: false,
			bgClickHide: true
		};
		params = params || {};
		for (var prop in defaults) { if (!(prop in params)) { params[prop] = defaults[prop]; } }
		var _this = this, html = $('html'), win = $(window);
		var posi = t.css('position');
		if (params.bgEle) {
			if ($("body > " + params.bgEle).length === 0) {
				var bg_class = params.bgEle.replace(".", " ");
				$("body").append($("<div></div>").addClass(bg_class));
			}
			var bg = $("body > " + params.bgEle).css('display', 'block');
			params.bgClickHide && bg.on('click', hide);
		}
		t.css('display', 'block');
		!params.onStart ? (params.showAfterImgLoad ? imgLoad(show) : show()) : params.onStart(t, show);
		function hideByKey(e) {
			if (e.keyCode === 27) hide();
		}
		function show() {
			if (params.resize) resize(), win.on('resize', resize);
			t.addClass('on').find('.' + params.btnCloseCl).on('click', hide);
			params.htmlOverhide && html.css('overflow', 'hidden');
			win.on('keyup', hideByKey);
		}
		function imgLoad(fn, fn2) {
			var $imgs = t.find('img[src!=""]'), imgArr = { cpl: [], err: [] };
			if (!$imgs.length) return fn && fn();
			var dfds = [], cnt = 0;
			$imgs.each(function () {
				var _this = this;
				var dfd = $.Deferred();
				dfds.push(dfd);
				var img = new Image();
				img.onload = function () { imgArr.cpl.push(_this); check(); }
				img.onerror = function () { imgArr.err.push(_this); check(); }
				img.src = this.src;
			});
			function check() {
				cnt++;
				if (cnt === $imgs.length) {
					fn && fn();
					imgArr.err && fn2 && fn2();
				}
			}
		}
		function hide() {
			params.onClose ? params.onClose(t) : "";
			params.bgEle && bg.off('click').remove();
			t.css('display', 'none');
			params.htmlOverhide && html.css('overflow', 'visible');
			win.off('resize', resize).off('keyup', hideByKey);
			return 0;
		}
		function resize() {
			var scl = posi === 'fixed' ? 0 : ((document.documentElement && document.documentElement.scrollTop) || document.body.scrollTop);
			var vH = window.innerHeight || document.documentElement.clientHeight || document.body.clientHeight;
			if (params.setScroll) t.css({ 'max-height': '' });
			var bxH = t.outerHeight();
			t.css({ "top": (bxH > vH ? scl : (vH - bxH) / 2 + scl) + "px" });
			if (params.setScroll) t.css({ 'max-height': vH });
		}
		return { closeFn: hide };
	}
};

var agentZzim = {
	add: function (data) {
		function setting(o) {
			if (!o.flag) {
				if (o.list.length >= 20) {
					popFn.show($("#agent-zzim-alert-layer"));
					return false;
				}
				o.list.unshift(data);
				localStorage.setItem("_agentZZIM", JSON.stringify(o.list));
				return true;
			}
			return false;
		}
		return setting(this.checkDuple(data.user_no));
	},
	remove: function (id) {
		localStorage.setItem("_agentZZIM", JSON.stringify(
			_.reject(JSON.parse(localStorage.getItem("_agentZZIM")), function (i) {
				return i.user_no == id
			})
		));
	},
	checkDuple: function (id) {
		var list = JSON.parse(localStorage.getItem("_agentZZIM")) || [];
		var flag = _.some(list, function (i) { return i.user_no == id });
		return { flag: flag, list: list };
	},
	fillBtn: function (btn) { btn.addClass('on').find('span')[0].className = "icon-bookmark_fill"; },
	emptyBtn: function (btn) { btn.removeClass('on').find('span')[0].className = "icon-bookmark_border"; }
};

function asideFixFn(o) {
	o.container = o.container;
	o.bx = o.bx;
	o.inBx = o.bx.find('>div');
	o.inBxH = o.inBx.outerHeight();
	o.moveTop = o.moveTop || 0;
	function layoutFn(first) {
		var s = (document.documentElement && document.documentElement.scrollTop) || document.body.scrollTop;
		var wH = window.innerHeight || document.documentElement.clientHeight || document.body.clientHeight;
		var cH = o.container.height();
		var bxOffT = o.bx.offset().top;
		if (o.inBxH >= cH) {
			o.inBx.hasClass('fix') && o.inBx.removeClass('fix');
			return;
		}
		if (wH >= bxOffT + o.inBxH) {
			if (s < o.moveTop) o.inBx.hasClass('fix') && o.inBx.css({ top: '' }).removeClass('fix');
			else if (o.container.offset().top + cH - s < bxOffT + o.inBxH - o.moveTop) o.inBx.hasClass('fix') && o.inBx.css({ top: cH - o.inBxH }).removeClass('fix');
			else o.inBx.hasClass('fix') || o.inBx.css({ top: '' }).addClass('fix');
		} else {
			if (s + wH < bxOffT + o.inBxH + o.moveTop) o.inBx.hasClass('fix') && o.inBx.css({ top: '' }).removeClass('fix');
			else if (o.container.offset().top + cH < s + wH) o.inBx.hasClass('fix') && o.inBx.css({ top: cH - o.inBxH }).removeClass('fix');
			else o.inBx.hasClass('fix') || o.inBx.css({ top: wH - o.inBxH }).addClass('fix');
		}
	}
	$(window).on('scroll resize', layoutFn);
	return layoutFn;
}

function zbGetTpl(tplId, callback) {
	$.ajax({
		url: tpl_host + tplId + '.html?vs='+tpl_version,
		type: 'GET',
		dataType: 'html',
		success: function (data) {
			callback(data);
		},
		error: function (xhr) {
			console.log(xhr);
		}
	});
};

function buttonOver(clz) {
	$("body")
		.on("mouseenter",clz,function () {
			$(this).addClass("over");
		})
		.on("mouseout",clz,function() {

			$(this).removeClass("over");
		})
}

function priceToKmoney(price, attachTag) {
	if (!price) {
		return 0;
	} else if (price < 10000) {
		return price.toString().replace(/(\d)(\d{3})$/, '$1,$2')
	} else {
	    var strUk = "억";
	    if (attachTag) {
	        strUk = "<span>" + strUk + "</span>";
	    }
		return Math.floor(price / 10000) + strUk + (priceToKmoney(price % 10000) || '');
	}
}

$(document).ready(function () {
	if (document.getElementById('gnb-container')) {
		// gnb select
		var arrMenuMatch = [
			[undefined, undefined, undefined, "\/danji\/zzim", undefined, "^\/danji", "^\/apt"],
			["^\/search\/villa", "^\/item\/villa\/zzim", "^\/my\/villa\/rooms"],
			["^\/search\/map", "^\/item\/zzim", "^\/my\/rooms", "^\/items1\/\\d+"],
			[undefined, "^\/item\/officetel\/zzim", "^\/my\/officetel\/rooms", "^\/items1\/officetel\/\\d+"]
		];
		for (var i = 0; i < arrMenuMatch.length; i++) {
			for (var j = 0; j < arrMenuMatch[i].length; j++) {
				if (arrMenuMatch[i][j] && (new RegExp(arrMenuMatch[i][j])).test(location.pathname.toLowerCase())) {
					$('#gnb-container li:nth-child(' + (i + 1) + ')').addClass('on');
					$('#header .depth2>a:nth-child(' + (j + 1) + ')').addClass('on');
					break;
				}
			}
		}
		// gnb bind
		$(".i_login").click(function () {
			createLoginLayer();
		});
		$(".i_join").click(function () {
			createJoinLayer();
		});
		// var ToastAlert = creatTempAlert();
		// $('#header .depth2 a.population, #gnb-container .depth2_bx a.population').on('click', function(e){
		// 	e.preventDefault();
		// 	e.stopPropagation();
		// 	ToastAlert('현재 서비스 준비중 입니다.');
		// })
	}

	document.oncontextmenu = function () { return false; }
	document.ondragstart = function () { return false; }


	buttonOver(".phone-complete-layer .btn-confirm");
	buttonOver(".room-list-container .btn_add1");
	buttonOver(".room-list-container .btn_add2");
	buttonOver(".phone-apply-layer .btn-apply.enable");
	
});
Date.prototype.yyyymmdd = function () {
	var yyyy = this.getFullYear().toString();
	var mm = (this.getMonth() + 1).toString();
	var dd = this.getDate().toString();
	return yyyy + (mm[1] ? mm : "0" + mm[0]) + (dd[1] ? dd : "0" + dd[0]);
} 
;
 
if (location.href.match('zigbang.com')!=null) {
	console = console || {};
	console.log = function (msg) { };
	console.info = function() {}; 
};
 
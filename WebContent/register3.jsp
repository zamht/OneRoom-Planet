<%@ page language="java" contentType="text/html; charset=UTF-8" 
	pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE HTML>
<html>
	<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<title>OneRoom Planet</title>
	<meta name="viewport" content="width
	=device-width, initial-scale=1">
	<meta name="description" content="Free HTML5 Website Template by gettemplates.co" />
	<meta name="keywords" content="free website templates, free html5, free template, free bootstrap, free website template, html5, css3, mobile first, responsive" />
	<meta name="author" content="gettemplates.co" />
	<script src="https://code.jquery.com/jquery-3.1.1.min.js" ></script>

	<!-- 
	//////////////////////////////////////////////////////
	FREE HTML5 TEMPLATE 
	DESIGNED & DEVELOPED by FreeHTML5.co
		
	Website: 		http://freehtml5.co/
	Email: 			info@freehtml5.co
	Twitter: 		http://twitter.com/fh5co
	Facebook: 		https://www.facebook.com/fh5co
	//////////////////////////////////////////////////////
	 -->

  	<!-- Facebook and Twitter integration -->
	<meta property="og:title" content=""/>
	<meta property="og:image" content=""/>
	<meta property="og:url" content=""/>
	<meta property="og:site_name" content=""/>
	<meta property="og:description" content=""/>
	<meta name="twitter:title" content="" />
	<meta name="twitter:image" content="" />
	<meta name="twitter:url" content="" />
	<meta name="twitter:card" content="" />

	<!-- <link href='https://fonts.googleapis.com/css?family=Work+Sans:400,300,600,400italic,700' rel='stylesheet' type='text/css'> -->
	
	<!-- Animate.css -->
	<link rel="stylesheet" href="css/animate.css">
	<!-- Icomoon Icon Fonts-->
	<link rel="stylesheet" href="css/icomoon.css">
	<!-- Bootstrap  -->
	<link rel="stylesheet" href="css/bootstrap.css">

	<!-- Theme style  -->
	<link rel="stylesheet" href="css/style.css">

	<!-- Modernizr JS -->
	<script src="js/modernizr-2.6.2.min.js"></script>
	<!-- FOR IE9 below -->
	<!--[if lt IE 9]>
	<script src="js/respond.min.js"></script>
	<![endif]-->
	
	<script type="text/javascript">
		var randomNum;
		var checkId = 0;
		var idOK;
		var numCheck = 0;
		var emailOK;
		var numOK;
		
		function nameCheck() {
			var name = $( '#name' ).val();
			if(name != ""){
				$("#name").css("background-color", "#B0F6AC");
			} else {
				$("#name").css("background-color", "#FFCECE");
			}
		}
		
		function cnameCheck() {
			var cname = $( '#cname' ).val();
			if(cname != ""){
				$("#cname").css("background-color", "#B0F6AC");
			} else {
				$("#cname").css("background-color", "#FFCECE");
			}
		}
		
		function idCheck() {
			var id = $( '#id' ).val();
			$.ajax({
				type: 'post',
				url: 'idCheck.to',
				data: {id : id},
				success: function(result) {
					if(result == 1 && id != "") {
						$('#idCheckMessage').html('사용가능한 아이디입니다.').css("color", "green");
						$("#id").css("background-color", "#B0F6AC");
						idOK = id;
						/* document.getElementById('id').readOnly = true; */
						checkId = 1;
					} else {
						$('#idCheckMessage').html('이미 있는 아이디입니다.').css("color", "red");
						$("#id").css("background-color", "#FFCECE");
						checkId = 0;
					}
				}
			})
		}
		
		function emailOK() {
			randomNum = Math.floor(Math.random() * 100000001) + 1000000;;
			var email = $('#email').val();
			$.ajax({
				type: 'post',
				url: 'EmailAction.to',
				data: {"email" : email, "randomNum" : randomNum},
				success: function(result) {
					if(result == 0) {	
						alert('이미 인증된 이메일 입니다.');
					} else {
						alert('이메일이 발송되었습니다.');
						emailOK = email;
						document.getElementById('incl').style.display = 'block';
					}
				}
			})
		}
		
		function randomCheck() {
			var inputNum = $('#inputNum').val();
			if(inputNum == randomNum) {
				alert('인증되었습니다.');
				numOK = inputNum;
				$("#email").css("background-color", "#B0F6AC");
				$("#inputNum").css("background-color", "#B0F6AC");
				numCheck = 1;
			} else {
				alert('인증번호가 다릅니다.');
				$("#email").css("background-color", "#FFCECE");
				$("#inputNum").css("background-color", "#FFCECE");
				numCheck = 0;
			}
		} 
		
		function pwdCheck() {
			var pwd1 = $( '#pwd1' ).val();
			var pwd2 = $( '#pwd2' ).val();
			if(pwd1 == pwd2) {
				$('#pwdCheckMessage').html('');
				$("#pwd1").css("background-color", "#B0F6AC");
				$("#pwd2").css("background-color", "#B0F6AC");
			} else {
				$('#pwdCheckMessage').html('비밀번호가 서로 일치하지 않습니다.');
				$("#pwd1").css("background-color", "#FFCECE");
				$("#pwd2").css("background-color", "#FFCECE");
			}
		}
		
		function phoneCheck() {
			var phone = $( '#phone' ).val();
			if(phone != ""){
				$("#phone").css("background-color", "#B0F6AC");
			} else {
				$("#phone").css("background-color", "#FFCECE");
			}
		}
		
		function check() {
			var getCheck = RegExp(/^[a-zA-Z0-9]{4,12}$/);
			var getMail = RegExp(/^[A-Za-z0-9_\.\-]+@[A-Za-z0-9\-]+\.[A-Za-z0-9\-]+/);
			var getPhone = RegExp(/^01([0|1|6|7|8|9]?)+-([0-9]{3,4})+-([0-9]{4})$/);
			
			if(!getCheck.test($("#id").val())) {
			      alert("형식에 맞춰서 입력해주세요.");
			      $("#id").val("");
			      $("#id").focus();
			      return false;
			}
			if(!getCheck.test($("#pwd1").val())) {
			      alert("형식에 맞춰서 입력해주세요.");
			      $("#pwd1").val("");
			      $("#pwd1").focus();
			      return false;
			}
			if ($("#id").val()==($("#pwd1").val())) {
			      alert("비밀번호가 아이디랑 같습니다.");
			      $("#pwd1").val("");
			      $("#pwd1").focus();
			      return false;
			}
			if ($("#pwd1").val()!=($("#pwd2").val())) {
			      alert("비밀번호가 다릅니다.");
			      $("#pwd2").val("");
			      $("#pwd2").focus();
			      return false;
			}
			if(!getMail.test($("#email").val())){
		        alert("올바른 이메일 주소를 입력해주세요.");
		        $("#email").val("");
		        $("#email").focus();	
		        return false;
		    }
			if(!getPhone.test($("#phone").val())){
		        alert("핸드폰 형식으로 해주세요.");
		        $("#phone").val("");
		        $("#phone").focus();
		        return false;
		    }
			if(checkId == 0) {
				alert("아이디 중복확인을 해주세요.");
				return false;
			}
			if(idOK != ($("#id").val())){
				alert("중복확인을 눌러주세요.");
				return false;
			}
			if(emailOK != ($("#email").val())){
				alert("이메일 인증을 눌러주세요.");
				return false;
			}
			if(numOK != ($("#inputNum").val())){
				alert("이메일 인증을 눌러주세요.");
				return false;
			}
			if(numCheck == 0) { // 인증이 되면 넘어감
				alert("이메일 인증확인을 해주세요.");
				return false;
			}
			
			return true;
		}
		
			
	</script>
	
	</head>
	<body>
	

	<nav class="fh5co-nav" role="navigation">
		<div class="container">
			<div class="row">
				<div class="col-xs-2">
					<div id="fh5co-logo">
						<a href="index.jsp">2조</a>
					</div>
				</div>
				<div class="col-xs-10 text-right menu-1">
					<ul>
						<li class="active"><a href="index.jsp">Home</a></li>
						<li class="has-dropdown"><a href="">원룸</a>
							<ul class="dropdown">
								<li><a href="jsp_yeonghak/map_finalV1.04.jsp">원룸 검색</a></li>
								<li><a href="#">상세 검색</a></li>
							</ul></li>
						<li class="has-dropdown"><a href="#">방 내놓기</a>
							<ul class="dropdown">
								<li><a href="#">매물 보기</a></li>
								<li><a href="out.do">내 방 내놓기</a></li>

							</ul></li>
						<li class="btn-cta"><a href="login.jsp"><span>로그인</span></a></li>
						<li class="btn-cta"><a href="register.jsp"><span>회원가입</span></a></li>
					</ul>


				</div>
			</div>

		</div>
	</nav>



	<header id="fh5co-header" class="fh5co-cover" role="banner" style="background-image:url(images/img_bg_2.jpg);">
      <div class="overlay"></div>
      <div class="container">
         <div class="row">
            <div class="col-md-8 col-md-offset-2 text-center">
               <div class="display-t">
                  <div class="display-tc animate-box" data-animate-effect="fadeIn">
                     <h1>OneRoom Planet</h1>
                     <div class="row">
                     </div>
                  </div>
               </div>
            </div>
         </div>
      </div>
   </header>
	
	<div id="fh5co-contact">
	 <div class="container">
    <div class="row">
       <div class="centered">
        <div class="card card-signin my-5">
          <div class="card-body">
            <h5 class="card-title text-center">업체 회원가입</h5>
            <form class="form-signin" action="JoinAction.to" method="post" onsubmit="return check();" autocomplete="off">
             
             <div class="form-label-group">
                <input type="text" name="name" id="name" oninput="nameCheck()" class="form-control" placeholder="이름" required autofocus>
              </div>
              
              <div class="form-label-group">
                <input type="text" name="cname" id="cname" oninput="cnameCheck()" class="form-control" placeholder="업체이름" required>
              </div>
             
              <div class="form-label-group">
                <input type="text" name="id" id="id" class="form-control" placeholder="아이디 ※4~12자의 영문 대소문자와 숫자" maxlength="12" required>
                <button type="button" onclick="idCheck()">중복확인</button><h5 id="idCheckMessage"></h5>
              </div>

              <div class="form-label-group">
                <input type="password" oninput="pwdCheck()" id="pwd1" name="pwd1" class="form-control" placeholder="비밀번호 ※4~12자의 영문 대소문자와 숫자" maxlength="12">
              </div>
              
              <div class="form-label-group">
                <input type="password" oninput="pwdCheck()" id="pwd2" name="pwd2" class="form-control" placeholder="비밀번호 확인" maxlength="12">
              </div>
              
              <div class="form-label-group">
                <input type="email" name="email" id="email" class="form-control" placeholder="이메일" required>
                <button type="button" onclick="emailOK()">이메일 인증</button>
              </div>
              
              <div class="form-label-group" id="incl" style="display:none">
                <input type="text" name="inputNum" id="inputNum" class="form-control">
                <button type="button" onclick="randomCheck()">인증확인</button>
             </div>
              
              <div class="form-label-group">
                <input type="text" name="phone" id="phone" oninput="phoneCheck()" class="form-control" placeholder="전화번호 ※010-1111-1111" required>
              </div>
              
              <div class="form-label-group">
              <h5 style="color: red;" id="pwdCheckMessage"></h5>
              </div>
              
              <button id="button" class="btn btn-lg btn-primary btn-block text-uppercase" type="submit" >회원가입</button>
             
            
            </form>
          </div>
           </div>
        </div>
      </div>
    </div>
  </div>
	



	<div class="gototop js-top">
		<a href="#" class="js-gotop"><i class="icon-arrow-up"></i></a>
	</div>
	
	<!-- jQuery -->
	<script src="js/jquery.min.js"></script>
	<!-- jQuery Easing -->
	<script src="js/jquery.easing.1.3.js"></script>
	<!-- Bootstrap -->
	<script src="js/bootstrap.min.js"></script>
	<!-- Waypoints -->
	<script src="js/jquery.waypoints.min.js"></script>
	<!-- Main -->
	<script src="js/main.js"></script>
	

	</body>
</html>
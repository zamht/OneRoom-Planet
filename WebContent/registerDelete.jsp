<%@ page language="java" contentType="text/html; charset=UTF-8" 
	pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE HTML>
<html>
	<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
<title>OneRoom Planet</title>	<meta name="viewport" content="width
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
		var randomNum;;
		var numCheck = 0;
		var emailOK;
		var numOK;
		pwdNumCheck = 0;
		pwdOK;
		
		function pwdCheck() {
			var pwd = $( '#pwd' ).val();
			var id = "${sessionScope.sessionID }";
			$.ajax({
				type: 'post',
				url: 'pwdCheck.to',
				data: {'pwd' : pwd, 'id' : id},
				success: function(result) {
					if(result == 1) {
						$("#pwd").css("background-color", "#B0F6AC");
						pwdOK = pwd;
						pwdNumCheck = 1;
					} else {
						$("#pwd").css("background-color", "#FFCECE");
						pwdNumCheck = 0;
					}
				}
			})
		}
		
		function emailOK() {
			randomNum = Math.floor(Math.random() * 100000001) + 1000000;;
			var email = $('#email').val();
			var id = "${sessionScope.sessionID }";
			$.ajax({
				type: 'post',
				url: 'DeleteEmailAction.to',
				data: {"email" : email, "randomNum" : randomNum, "id" : id},
				success: function(result) {
					if(result == 0) {	
						alert('아이디랑 다른 이메일 입니다.');
					} else {
						alert('이메일이 발송되었습니다.');
						emailOK = email;
						document.getElementById('incl').style.display = 'block';
					}
				}
			})
		}
		
		function memberDelete() {
			var id = "${sessionScope.sessionID }";
			$.ajax({
				type: 'post',
				url: 'MemberDeleteAction.to',
				data: {"id" : id},
				success: function(result) {
					if(result == 0) {	
						alert('탈퇴되었습니다.');
						location.href='index.to';
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
		
		function check() {
			
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
			if(pwdOK != ($("#pwd").val())) {
				alert('비밀번호 확인을 눌러주세요.');
				return false;
			}
			if(pwdNumCheck == 0) {
				alert('비밀번호가 틀렸습니다.');
				return false;
			}
			
			
			return true;
		}
		
			
	</script>
	
	</head>
	<body>
	
	<div class="fh5co-loader"></div>
	
	<nav class="fh5co-nav" role="navigation">
		<div class="container">
			<div class="row">
				<div class="col-xs-2">
					<div id="fh5co-logo"><a href="index.html">King.</a></div>
				</div>
				<div class="col-xs-10 text-right menu-1">
					<ul>
						<li><a href="index.html">Home</a></li>
						<li><a href="work.html">Work</a></li>
						<li><a href="about.html">About</a></li>
						<li class="has-dropdown">
							<a href="services.html">Services</a>
							<ul class="dropdown">
								<li><a href="#">Web Design</a></li>
								<li><a href="#">eCommerce</a></li>
								<li><a href="#">Branding</a></li>
								<li><a href="#">API</a></li>
							</ul>
						</li>
						<li class="has-dropdown">
							<a href="#">Tools</a>
							<ul class="dropdown">
								<li><a href="#">HTML5</a></li>
								<li><a href="#">CSS3</a></li>
								<li><a href="#">Sass</a></li>
								<li><a href="#">jQuery</a></li>
							</ul>
						</li>
						<c:if test="${sessionScope.sessionID!=null}">
                         
                  			<li class="btn-cta"><span style="font-size: 30px">${sessionScope.sessionID }님</span></li> 
                  			<li class="btn-cta"><a href="logout.to"><span>로그아웃</span></a></li>
                  			<li class="btn-cta"><a href="registerDelete.to"><span>회원 탈퇴</span></a></li>
               
                    	</c:if>
					</ul>
				</div>
			</div>
			
		</div>
	</nav>

	<header id="fh5co-header" class="fh5co-cover fh5co-cover-sm" role="banner" style="background-image:url(images/img_bg_2.jpg);">
		<div class="overlay"></div>
		<div class="container">
			<div class="row">
				<div class="col-md-8 col-md-offset-2 text-center">
					<div class="display-t">
						<div class="display-tc animate-box" data-animate-effect="fadeIn">
							<h1>Contact Us</h1>
							<h2>Free html5 templates Made by <a href="http://freehtml5.co" target="_blank">freehtml5.co</a></h2>
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
            <h5 class="card-title text-center">회원탈퇴</h5>
            <form class="form-signin" method="post" action="MemberDeleteAction.to" onsubmit="return check();" autocomplete="off">

              <div class="form-label-group">
                <input type="password" id="pwd" name="pwd" class="form-control" placeholder="비밀번호 입력" maxlength="12" required>
                <button type="button" onclick="pwdCheck()">비밀번호 확인</button>
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
              <h5 style="color: red;" id="pwdCheckMessage"></h5>
              </div>
              
              <button id="button" class="btn btn-lg btn-primary btn-block text-uppercase" type="submit" >탈퇴하기</button>
             
            
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
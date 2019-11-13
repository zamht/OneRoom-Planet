<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE HTML>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<title>OneRoom Planet</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="description"
	content="Free HTML5 Website Template by gettemplates.co" />
<meta name="keywords"
	content="free website templates, free html5, free template, free bootstrap, free website template, html5, css3, mobile first, responsive" />
<meta name="author" content="gettemplates.co" />

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
<meta property="og:title" content="" />
<meta property="og:image" content="" />
<meta property="og:url" content="" />
<meta property="og:site_name" content="" />
<meta property="og:description" content="" />
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

</head>
<body>

	<div class="fh5co-loader"></div>

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
						<li class="btn-cta"><a href="search.to"><span>아이디/비밀번호 찾기</span></a></li> 
						
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
							<h5 class="card-title text-center">로그인</h5>
							<form class="form-signin" method="post" action="MemberLoginAction.to" autocomplete="off">
								<div class="form-label-group">
									<input type="text" name="id" class="form-control"
										placeholder="아이디" required autofocus>
								</div>

								<div class="form-label-group">
									<input type="password" name="pwd" class="form-control"
										placeholder="비밀번호" required>
								</div>

								<button class="btn btn-lg btn-primary btn-block text-uppercase"
									type="submit">로그인</button>

								<button class="btn btn-lg btn-primary btn-block text-uppercase"
									type="button" onclick="location.href='search.to'">아이디/비밀번호 찾기</button>

								<button class="btn btn-lg btn-primary btn-block text-uppercase"
									type="button" onclick="location.href='register.jsp'">회원가입</button>


							</form>
						</div>
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

	<c:set var="failMessage" value="${requestScope.fail}" />
	<c:if test="${failMessage!=null}">
		<c:if test="${ failMessage == 0 }">
			<script type="text/javascript">
				alert("아이디나 비밀번호가 틀렸습니다.")
			</script>
		</c:if>
		<c:if test="${ failMessage == 1 }">
			<script type="text/javascript">
				alert("로그인 되었습니다.")
			</script>
		</c:if>
	</c:if>


</body>
</html>


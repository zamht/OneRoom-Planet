<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>   
<html style="overflow-y: hidden !important">
<head>
<meta charset="utf-8">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>방 내놓기</title>
<meta name="viewport" content="width=device-width, initial-scale=1">

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

<!-- 우편번호 및 주소 받아오기 -->
<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
<link rel="stylesheet" href="./jquery-ui-1.12.1/jquery-ui.min.css">
<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
<script src="./jquery-ui-1.12.1/jquery-ui.min.js"></script>
<script src="./jquery-ui-1.12.1/datepicker-ko.js"></script>

<script type="text/javascript">
// 로그인 여부

 //MPAY 없음 선택
function checkDisable(form)
{
    if( form.MPAY_none.checked == true ){
       form.MPAY.value ="없음";
       form.MPAY.disabled = true;
} else {
   form.MPAY.value ="";
   form.MPAY.disabled = false;
   }
}
//이미지
$(function () {
   $('#btn-upload').click(function(e) {
         e.preventDefault();
         $('#file').click();
      });
   });
$(function () {
   $('#btn-upload2').click(function(e) {
         e.preventDefault();
         $('#file2').click();
      });
   });
$(function () {
   $('#btn-upload3').click(function(e) {
         e.preventDefault();
         $('#file3').click();
      });
   });
$(function () {
   $('#btn-upload4').click(function(e) {
         e.preventDefault();
         $('#file4').click();
      });
   });
$(function () {
   $('#btn-upload5').click(function(e) {
         e.preventDefault();
         $('#file5').click();
      });
   });
//주소정보
function sample4_execDaumPostcode() {
    new daum.Postcode({
        oncomplete: function(data) {
            // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

            // 도로명 주소의 노출 규칙에 따라 주소를 표시한다.
            // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
            var roadAddr = data.roadAddress; // 도로명 주소 변수
            var extraRoadAddr = ''; // 참고 항목 변수

            // 법정동명이 있을 경우 추가한다. (법정리는 제외)
            // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
            if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
                extraRoadAddr += data.bname;
            }
            // 건물명이 있고, 공동주택일 경우 추가한다.
            if(data.buildingName !== '' && data.apartment === 'Y'){
               extraRoadAddr += (extraRoadAddr !== '' ? ', ' + data.buildingName : data.buildingName);
            }
            // 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
            if(extraRoadAddr !== ''){
                extraRoadAddr = ' (' + extraRoadAddr + ')';
            }

            // 우편번호와 주소 정보를 해당 필드에 넣는다.
            document.getElementById('sample4_postcode').value = data.zonecode;
            document.getElementById("sample4_roadAddress").value = roadAddr;
            document.getElementById("sample4_jibunAddress").value = data.jibunAddress;
            
            // 참고항목 문자열이 있을 경우 해당 필드에 넣는다.
            if(roadAddr !== ''){
                document.getElementById("sample4_extraAddress").value = extraRoadAddr;
            } else {
                document.getElementById("sample4_extraAddress").value = '';
            }

            var guideTextBox = document.getElementById("guide");
            // 사용자가 '선택 안함'을 클릭한 경우, 예상 주소라는 표시를 해준다.
             if(data.autoRoadAddress) {
                var expRoadAddr = data.autoRoadAddress + extraRoadAddr;
                document.getElementById("sample4_roadAddress").value = extraRoadAddr;
                guideTextBox.innerHTML = '(예상 도로명 주소 : ' + expRoadAddr + ')';
                guideTextBox.style.display = 'block';

            } else if(data.autoJibunAddress) {
                var expJibunAddr = data.autoJibunAddress;
               document.getElementById("sample4_jibunAddress").value = expJibunAddr;
                guideTextBox.innerHTML = '(예상 지번 주소 : ' + expJibunAddr + ')';
                guideTextBox.style.display = 'block';
            } else {
                guideTextBox.innerHTML = '';
                guideTextBox.style.display = 'none';
            }
             getlatlng(roadAddr,data.jibunAddress);
        }
    }).open();
}

//이미지

   function preview(id, input, target) {
      var idok = id;
      if (input.files && input.files[0]) {
         var fileName = input.files[0].name;
         var ext = fileName.substr(fileName.length - 3, fileName.length);
         var isCheck = false;
         if (ext.toLowerCase() == 'jpg' || ext.toLowerCase() == 'gif'
               || ext.toLowerCase() == 'png') {
            isCheck = true;
         }
         if (isCheck == false) {
            alert("이미지 파일 아님");
            jQuery(input).val("");
            return;
         }
         var reader = new FileReader();
         reader.readAsDataURL(input.files[0]);
         reader.onload = function(e) {
            jQuery(target).attr('src', e.target.result);
            if (idok == "file") {
               document.getElementById('btn-upload').style.visibility = 'hidden';
               document.getElementById('select-del').style.visibility = 'visible';
            } else if (idok == "file2") {
               document.getElementById('btn-upload2').style.visibility = 'hidden';
               document.getElementById('select-del2').style.visibility = 'visible';
            } else if (idok == "file3") {
               document.getElementById('btn-upload3').style.visibility = 'hidden';
               document.getElementById('select-del3').style.visibility = 'visible';
            } else if (idok == "file4") {
               document.getElementById('btn-upload4').style.visibility = 'hidden';
               document.getElementById('select-del4').style.visibility = 'visible';
            } else if (idok == "file5") {
               document.getElementById('btn-upload5').style.visibility = 'hidden';
               document.getElementById('select-del5').style.visibility = 'visible';
            }
         }
      }
   }
   
   function getlatlng(data1,data2){
      
      //alert("data1="+data1+"\ndata2"+data2);
      
      if(data1!=""){
         data=data1   
      }else if(data2!=""){
         data=data2;
      }
      
      
      var geocoder = new kakao.maps.services.Geocoder();

      // 주소로 좌표를 검색합니다
      geocoder.addressSearch(data, function(result, status) {
         
         //제주특별자치도 제주시 첨단로 242
          // 정상적으로 검색이 완료됐으면 
           if (status === kakao.maps.services.Status.OK) {
              
              document.getElementById('lat').value = result[0].y;
              document.getElementById('lng').value = result[0].x;
              
              //alert("위도"+result[0].y+"\n경도"+result[0].x)

              //var coords = new kakao.maps.LatLng(result[0].y, result[0].x);

              // 결과값으로 받은 위치를 마커로 표시합니다
          } 
      });  
   }

   function del() {
      document.getElementById('file').value = "";
      document.getElementById('image1').src = "";
      document.getElementById('btn-upload').style.visibility = 'visible';
      document.getElementById('select-del').style.visibility = 'hidden';
   }
   function del2() {
      document.getElementById('file2').value = "";
      document.getElementById('image2').src = "";
      document.getElementById('btn-upload2').style.visibility = 'visible';
      document.getElementById('select-del2').style.visibility = 'hidden';
   }
   function del3() {
      document.getElementById('file3').value = "";
      document.getElementById('image3').src = "";
      document.getElementById('btn-upload3').style.visibility = 'visible';
      document.getElementById('select-del3').style.visibility = 'hidden';
   }
   function del4() {
      document.getElementById('file4').value = "";
      document.getElementById('image4').src = "";
      document.getElementById('btn-upload4').style.visibility = 'visible';
      document.getElementById('select-del4').style.visibility = 'hidden';
   }
   function del5() {
      document.getElementById('file5').value = "";
      document.getElementById('image5').src = "";
      document.getElementById('btn-upload5').style.visibility = 'visible';
      document.getElementById('select-del5').style.visibility = 'hidden';
   }
   
   function check() {
       alert("등록 완료");
       return true;
   }
</script>

</head>
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=cf17b15a111ecb427c26da3a08661ee9&libraries=services,clusterer"></script>
<body>

    <div class="fh5co-loader"></div>
   
   <div id="page">
  <nav class="fh5co-nav" role="navigation">

      <div class="container">
         <div class="row">
            <div class="col-xs-2">
            <c:if test="${sessionScope.sessionID=='admin'}">
               <div id="fh5co-logo"><a href="admin.jsp">2조</a></div>
            </c:if>
            <c:if test="${sessionScope.sessionID!='admin'}">
               <div id="fh5co-logo"><a href="index.jsp">2조</a></div>
            </c:if>
            </div>
            <div class="col-xs-10 text-right menu-1">
               <ul>
               		
               	  <c:if test="${sessionScope.sessionID=='admin'}">
               		<li class="active"><a href="admin.jsp">Home</a></li>
            	  </c:if>
            	  <c:if test="${sessionScope.sessionID!='admin'}">
               		<li class="active"><a href="index.jsp">Home</a></li>
            	  </c:if>
              
            
                  <li class="has-dropdown">
                     <a href="">원룸</a>
                     <ul class="dropdown">
						<li><a href="jsp_yeonghak/map_finalV1.04.jsp" >원룸 검색</a></li>
                        <li><a href="#">상세 검색</a></li>
                     </ul>
                  </li>
                  <li class="has-dropdown">
                     <a href="">방 내놓기</a>
                     <ul class="dropdown">
                        <li><a href="#">매물 보기</a></li>
                        <li><a href="out.do">내 방 내놓기</a></li>
                     </ul>
                  </li>

               <c:if test="${sessionScope.sessionID==null}">
                  <li class="btn-cta"><a href="login.to"><span>로그인</span></a></li>
               
                        <li class="btn-cta"><a href="register.to"><span>회원가입</span></a></li> 
                    </c:if>
                    
                    <c:if test="${sessionScope.sessionID!=null}">
                         
                  <li class="btn-cta"><span style="font-size: 30px">${sessionScope.sessionID }님</span></li> 
                  <li class="btn-cta"><a href="logout.to"><span>로그아웃</span></a></li>
               
                    </c:if>
                     
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

      <form action="RoomOutAction.do" method="post" name="boardform" enctype="multipart/form-data" onsubmit="return check()">
         <div class="wrap-950 add-container">
            <div class="content left-content">

                  <input type="hidden" id="lat" name="lat" value="">
                  <input type="hidden" id="lng" name="lng" value="">
                  

               <h4>사진 등록</h4>
               <div class="add-photo">
                  <p class="item-txt ischrome">
                     · 사진 최대 5장 까지 등록할 수 있습니다.<br> · 아래에 등록 버튼을 클릭하여 등록할 수 있습니다.<br>
                     · 한꺼번에 여러 장 등록도 가능합니다.<br> <span class="fc-red1">· 직접
                        찍은 실제 방 사진의 원본을 등록해야 합니다.</span><br>
                  </p>
                  <div class="item-photo" id="add-photo-box">
                     <ul class="ui-sortable">
                        <li id="li1" class="ui-sortable-handle"><span class="i-count">1</span>
                           <div>
                           <input class="i-btn" type="file" id="file" name="FILE1" onchange="preview(this.id,this, $('#image1'));"/>
                           <button class="i-btn" type="button" id="btn-upload" name="btn1">Image</button>
                           </div>
                           <div class="selectable">
                              <div class="selectable-content">
                                 <img src="" style="width:108px; height:81px;" id="image1">
                              </div>
                              <div class="selectable-layer">
                                 <button id="select-del" class="selectable-del" type="button" onclick="del()" style="visibility:hidden">X</button>
                              </div>
                           </div>
                        </li>
                        <li id="li2" class="ui-sortable-handle"><span class="i-count">2</span>
                           <div>
                           <input class="i-btn" type="file" id="file2" name="FILE2" value = "2" onchange="preview(this.id,this, $('#image2'));"/>
                           <button class="i-btn" type="button" id="btn-upload2" name="btn2">Image</button>
                           </div>
                           <div class="selectable">
                              <div class="selectable-content">
                                 <img src="" style="width:108px; height:81px; " id="image2">
                              </div>
                              <div class="selectable-layer">
                                 <button id="select-del2" class="selectable-del" type="button" onclick="del2()" style="visibility:hidden">X</button>
                              </div>
                           </div>
                        </li>
                        <li id="li3" class="ui-sortable-handle"><span class="i-count">3</span>
                           <div>
                           <input class="i-btn" type="file" id="file3" name="FILE3" value = "3" onchange="preview(this.id,this, $('#image3'));"/>
                           <button class="i-btn" type="button" id="btn-upload3" name="btn3">Image</button>
                           </div>
                           <div class="selectable">
                              <div class="selectable-content">
                                 <img src="" style="width:108px; height:81px; " id="image3">
                              </div>
                              <div class="selectable-layer">
                                 <button id="select-del3" class="selectable-del" type="button" onclick="del3()" style="visibility:hidden">X</button>
                              </div>
                           </div>
                        </li>
                        <li id="li4" class="ui-sortable-handle"><span class="i-count">4</span>
                           <div>
                           <input class="i-btn" type="file" id="file4" name="FILE4" value = "4" onchange="preview(this.id,this, $('#image4'));"/>
                           <button class="i-btn" type="button" id="btn-upload4" name="btn4">Image</button>
                           </div>
                           <div class="selectable">
                              <div class="selectable-content">
                                 <img src="" style="width:108px; height:81px; " id="image4">
                              </div>
                              <div class="selectable-layer">
                                 <button id="select-del4" class="selectable-del" type="button" onclick="del4()" style="visibility:hidden">X</button>
                              </div>
                           </div>
                        </li>
                        <li id="li5" class="ui-sortable-handle"><span class="i-count">5</span>
                           <div>
                           <input class="i-btn" type="file" id="file5" name="FILE5" value = "5" onchange="preview(this.id,this, $('#image5'));"/>
                           <button class="i-btn" type="button" id="btn-upload5" name="btn5">Image</button>
                           </div>
                           <div class="selectable">
                              <div class="selectable-content">
                                 <img src="" style="width:108px; height:81px;" id="image5">
                              </div>
                              <div class="selectable-layer">
                                 <button id="select-del5" class="selectable-del" type="button" onclick="del5()" style="visibility:hidden">X</button>
                              </div>
                           </div>
                        </li>
                     </ul>
                  </div>
               </div>


               <h4>정보 입력</h4>
               <table class="add-table">
                  <tbody>
                     <tr>
                        <th>주소</th>
                        <td colspan="3">
                           <input type="text" id="sample4_postcode" placeholder="우편번호">
                           <input type="button" onclick="sample4_execDaumPostcode()" value="우편번호 찾기"><br>
                           <input type="text" id="sample4_roadAddress" name = "RADDRESS" placeholder="도로명주소"><br>
                           <input type="text" id="sample4_jibunAddress" name = "NADDRESS" placeholder="지번주소">
                           <span id="guide" style="color:#999;display:none"></span>
                           <input type="text" id="sample4_detailAddress" name = "ADDRESS2" placeholder="상세주소">
                           <input type="text" id="sample4_extraAddress" name = "ADDRESS3" placeholder="참고항목">
                        </td>
                     </tr>
                     <tr>
                        <th>보증금</th>
                        <td><input type="text" class="text" name="DEPOSIT" id="test" required> 만원 <span class="fc-red1">※무보증일 경우, 한 달 월세를 입력하세요</span></td>
                     </tr>
                     <tr>
                        <th>월세</th>
                        <td><input type="text" class="text" name="RENT" id="test2"> 만원 <span class="fc-red1">※전세일 경우, 0을 입력 하세요</span></td>
                     </tr>
                     <tr>
                        <th>방구조</th>
                        <td><select style="width: 180px" name="ROOMTYPE">
                              <option value="">선택하세요</option>
                              <option value="오픈형 원룸 (방1)">오픈형 원룸 (방1)</option>
                              <option value="분리형 원룸 (방1, 거실1)">분리형 원룸 (방1, 거실1)</option>
                              <option value="복층형 원룸">복층형 원룸</option>
                              <option value="투룸 (방2, 거실1)">투룸 (방2, 거실1)</option>
                        </select></td>
                     </tr>

                     <tr>
                        <th>관리비</th>
                        <td><input type="text" class="text" name="MPAY" id="MPAY" required> 만원
                           &nbsp;&nbsp;&nbsp;/&nbsp;&nbsp;&nbsp; 
                           <label><input type="checkbox" id="MPAY_none" name="MPAY_none" onClick="checkDisable(this.form)"> 없음</label>
                           <p class="i-gray">
                              <strong>관리비 포함 항목</strong> <label><input
                                 name="MPAY2" type="checkbox" value="전기세"> 전기세</label> <label><input
                                 name="MPAY2" type="checkbox" value="가스"> 가스</label> <label><input
                                 name="MPAY2" type="checkbox" value="수도"> 수도</label> <label><input
                                 name="MPAY2" type="checkbox" value="인터넷"> 인터넷</label> <label><input
                                 name="MPAY2" type="checkbox" value="TV"> TV</label>
                           </p></td>
                     </tr>
                     
                     <tr>
                        <th>크기</th>
                        <td>
                              전용면적 : <input type="text" style="width:50px; margin-right:5px;"name="RSIZE" />평
                        </td>
                     </tr>
                     <tr>
                        <th>층수</th>
                        <td>해당 층 : <select name="FLOOR">
                              <option value="">선택하세요</option>
                              <option value="반지하">반지하</option>
                              <option value="옥탑방">옥탑방</option>
                              <option value="1">1층</option>
                              <option value="2">2층</option>
                              <option value="3">3층</option>
                              <option value="4">4층</option>
                              <option value="5">5층</option>
                              <option value="6">6층</option>
                              <option value="7">7층</option>
                              <option value="8">8층</option>
                              <option value="9">9층</option>
                              <option value="10">10층</option>
                              <option value="11">11층</option>
                              <option value="12">12층</option>
                              <option value="13">13층</option>
                              <option value="14">14층</option>
                              <option value="15">15층</option>
                              <option value="16">16층</option>
                              <option value="17">17층</option>
                              <option value="18">18층</option>
                              <option value="19">19층</option>
                              <option value="20">20층</option>
                              <option value="21">21층</option>
                              <option value="22">22층</option>
                              <option value="23">23층</option>
                              <option value="24">24층</option>
                              <option value="25">25층</option>
                              <option value="26">26층</option>
                              <option value="27">27층</option>
                              <option value="28">28층</option>
                              <option value="29">29층</option>
                              <option value="30">30층</option>
                              <option value="31">31층</option>
                              <option value="32">32층</option>
                              <option value="33">33층</option>
                              <option value="34">34층</option>
                              <option value="35">35층</option>
                              <option value="36">36층</option>
                              <option value="37">37층</option>
                              <option value="38">38층</option>
                              <option value="39">39층</option>
                              <option value="40">40층</option>
                        </select>
                        </td>
                     </tr>
                     <tr>
                        <th>주차</th>
                        <td class="has-col">
                        <label><input type="radio"name="PARKING" value="가능"> 가능</label> 
                        <label><input type="radio" name="PARKING" value="없음"> 없음</label>
                        <div class="i-col">
                           <strong>엘리베이터</strong>
                           <label><input type="radio" name="ELVE" value="있음"> 있음</label>
                           <label><input type="radio" name="ELVE" value="없음"> 없음</label>
                        </div>
                        </td>
                     </tr>

                     <tr>
                        <th>입주가능일</th>
                        <td>
                        <input type="date" class="text max" name="RDATE">
                        </td>
                     </tr>
                     <tr>
                        <th>제목</th>
                        <td><input type="text" class="text max" name="TITLE">
                        </td>
                     </tr>
                     <tr>
                        <th>상세설명</th>
                        <td><textarea name="CONTENT" class="description"
                              placeholder="해당 방에 대한 특징과 소개를 최소 50자 이상 입력해야 합니다.
방의 위치와 교통, 주변 편의시설, 방의 특징과 장점, 보안시설, 옵션, 주차, 전체적인
방의 느낌 등을 작성해 주세요.      
다른 방에 대한 설명, 연락처, 홍보 메시지 등 해당 방과 관련없는 내용을 입력하거나 
해당 방에 대한 설명이 부적절할 경우 중개가 종료될 수 있습니다."></textarea>

                        </td>
                     </tr>
                  </tbody>
               </table>

               <div class="add-btn m-bottom-20">
                  <button type="submit" class="btn btn-orange" id="add_room">
                     <span id="btn_complete">방 내놓기</span>
                  </button>
               </div>
            </div>
         </div>
      </form>
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
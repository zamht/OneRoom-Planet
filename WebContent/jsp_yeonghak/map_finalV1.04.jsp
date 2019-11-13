<%@ page import="map.bit.kakaomap.kakaoVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page import="java.util.*  ,  java.text.SimpleDateFormat"%>
<%@ page import="map.bit.*"%>

<!DOCTYPE html>
<html>
<head>


<meta charset="utf-8">
<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
<title>마커 클러스터러 사용하기</title>

<p style="margin-top: 25px" height=150px>
<form action="javascript:searchaddr()" name="incruitpart">

	<input type="text" width=50px name="searchcontent" id="searchcontent">
	<input type="submit" height=250px value="검색">

</form>

</p>
<style>
.map_wrap {
	position: relative;
	width: 70%;
	height: 850px;
	float: left;
}

.title {
	font-weight: bold;
	display: block;
}

.hAddr {
	position: absolute;
	left: 10px;
	top: 10px;
	border-radius: 2px;
	background: #fff;
	background: rgba(255, 255, 255, 0.8);
	z-index: 1;
	padding: 5px;
}

#centerAddr {
	display: block;
	margin-top: 2px;
	font-weight: normal;
}

.bAddr {
	padding: 5px;
	text-overflow: ellipsis;
	overflow: hidden;
	white-space: nowrap;
}
</style>
<!-- Bootstrap  -->
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>
</head>

<body>
<header>

<nav class="navbar navbar-expand-md navbar-light bg-light">
	<c:if test="${sessionScope.sessionID=='admin'}">
 		<a href="../admin.jsp" class="navbar-brand">OneRoom Planet</a>    
 	</c:if>
    <c:if test="${sessionScope.sessionID!='admin'}">
        <a href="../index.jsp" class="navbar-brand">OneRoom Planet</a>
    </c:if>
    <button type="button" class="navbar-toggler" data-toggle="collapse" data-target="#navbarCollapse">
        <span class="navbar-toggler-icon"></span>
    </button>

    <div class="collapse navbar-collapse" id="navbarCollapse">
        <div class="navbar-nav">
        
        	<c:if test="${sessionScope.sessionID=='admin'}">
               	<a href="../admin.jsp" class="nav-item nav-link active">Home</a>
            </c:if>
            <c:if test="${sessionScope.sessionID!='admin'}">
               	<a href="../index.jsp" class="nav-item nav-link active">Home</a>
           	</c:if>
            
            <a href="../out.do" class="nav-item nav-link">내 방 내놓기</a>
            
        </div>
        <div class="navbar-nav ml-auto">
        	<c:if test="${sessionScope.sessionID==null}">
                    <li class="nav-item nav-link"><a href="../login.to"><span>로그인</span></a></li>
                         
               </c:if>
                    
                    <c:if test="${sessionScope.sessionID!=null}">
                         
                  <li class="btn-cta"><span style="font-size: 30px">${sessionScope.sessionID }님</span></li> 
                  <li class="btn-cta"><a href="../logout.to"><span>로그아웃</span></a></li>
               
                    </c:if>
        </div>
    </div>
</nav>
</header>
<div class="map_wrap">
	<div id="map"
		style="width: 100%; height: 100%; position: relative; overflow: hidden;"></div>
	<div class="hAddr">
		<span class="title">지도중심기준 행정동 주소정보</span> <span id="centerAddr"></span>
	</div>
</div>

	<p style="margin-top: -12px"></p>
	<div name="good"
      style="overflow: scroll; width: 30%; height: 850px; float: right; overflow: scroll; background-color: #f8f9fa!important;">

		<form name="replyform">
			<!-- <font type="hidden" id="latid" name="lntname"></font><br> 
			<font type="hidden" id="lngid">헬로우</font><br>
			<font type="hidden"  id="addrid">헬로우</font><br> 
			 -->
			<input type="hidden" id="latlngid" value="확인"
				onClick="javascript:check()"><br>

			<!-- <font type="hidden" id="markid">헬로우</font><br> -->
			<hr>
			<font size=6 id="detailhead"><B>상세정보</B></font><br>
			<hr>
			<font size=4 id="detailcontent"></font><br>
			<hr>

			<font size=6 id="replynotice"><B>세입자들의 한줄평</B></font><br>
			<hr>
</form>
			<!-- javascript:replydbsave() -->
			
		
			
			

		<form action="javascript:replydbsave()" name="replypart">

	<input type="text" width=50px name="replyname" id="replyid">
	<input type="submit" height=250px value="등록">

</form>

			<hr>
			<font size=5 id="addrfont"></font><br>
			<hr>
			<font size=5 id="replycontent"></font><br>

		
	</div>

	<script type="text/javascript"
		src="//dapi.kakao.com/v2/maps/sdk.js?appkey=cf17b15a111ecb427c26da3a08661ee9&libraries=services,clusterer">
</script>


	<script>
	    var map = new kakao.maps.Map(document.getElementById('map'), { // 지도를 표시할 div
	        center : new kakao.maps.LatLng(37.570508045762345, 126.98536939847243), // 지도의 중심좌표 lat이 위도 36  lng이 경도 127
	        level : 2 // 지도의 확대 레벨 
	    });
	    
	  mapchange();
	  
	  kakao.maps.event.addListener(map, 'zoom_changed', function(){ mapchange() }); ///줌을 바꾸거나
    
      kakao.maps.event.addListener(map, 'dragend', function(){ mapchange() }); ///드래그가 끝나거나
      
      //kakao.maps.event.addListener(map, 'bounds_changed', function () {mapchange()}); //맵의 영역이 바뀌었을때 
      
      function mapchange(){ ///바뀐 영역 안에있는  db데이터를 가져온다.
			var bounds = map.getBounds();
	        
	        //그냥 정보가져오기.
	        var latlng= bounds.toString();
	        //console.log(test);
	        var level = map.getLevel();
	        if(level<10){
	        gotoservletlatlng(latlng);
      		}
	    } 
      
      function gotoservletlatlng(latlng){
      	//var string = [lng,lat,addr]; //이건 사실의미없음
      	//var vparam = "test";
      	var latlng = latlng;      	
      		$.ajax(
      				{      					
      					url : "<%=request.getContextPath()%>/ArrayServlet.do",      					
      					type: "get",
      					dataType: "json",
      					data:{"latlng":latlng}, //여기서 데이터를 바로보내준다
      					header:{
      						"Content-Type":"application/json",	//Content-Type 설정
      						"X-HTTP-Method-Override":"POST"},
      					success:function(data){      						
      						var as = eval(data);//객체 변환
      						
      						gotogetmarker(data);
      					},
      					error:function(msg,error){
      						alert(error);
      					}
      				}
      			  );
      };	      
      
      
  	var decodeaddr=""; //JSP상에 저장할 주소
      
      function gotogetmarker(data){
    	  // 마커 클러스터러를 생성합니다 
    	    var clusterer = new kakao.maps.MarkerClusterer({
    	        map: map, // 마커들을 클러스터로 관리하고 표시할 지도 객체 
    	        averageCenter: true, // 클러스터에 포함된 마커들의 평균 위치를 클러스터 마커 위치로 설정 
    	        minLevel: 10 // 클러스터 할 최소 지도 레벨 
    	    });
    	  
    	    var markerjson=new Array();
    	    $.each(data, function(index, list){
    	    	//alert("here 168!");
					
	              var data2 = new Object();
	              data2.lat=parseFloat(list.position.lat);
	              data2.lng=parseFloat(list.position.lng);
	        
              	var data1 = new Object() ;            	
           		              
            	data1.position = data2;
            	
            	data1.text = list.text ;
            	
            	markerjson.push(data1);
				});
    	    //alert(JSON.stringify(markerjson)); //json객체를 한글로 출력해준다.
    	
    	    	var markers = markerjson.map(function(each) {
    	    	var position = each.position;
    	    	var marker = new kakao.maps.Marker({
    	    	    position : new kakao.maps.LatLng(position.lat, position.lng)
    	    	  });

    	    	kakao.maps.event.addListener(marker, 'click', function() {
    	    	    var info = new kakao.maps.InfoWindow({
    	    	      position: marker.getPosition(),
    	    	      disableAutoPan:true,
    	    	      content: each.text
    	    	    });
    	    	    
    	    	    var ca = /\+/g;
    	    	    decodeaddr = decodeURIComponent( each.text.replace(ca, " ") );
    	    	    //alert("인코딩주소 : "+decodeaddr);
    	    	    
    	    	    //document.getElementById('markid').innerHTML="마커클러스터 지번주소 "+decodeaddr;
    	    	    detailnull();//마커를 클릭할때 상세정보를 한번공백해준다.
    	    	    getdetailajax(decodeaddr);//상세정보
    	    	    getreplyajax(decodeaddr);//리플정보
    	    	    
    	    	  });
    	    	 
    	    	  return marker;
    	    	});
    	    	
    	    	// 클러스터러에 마커들을 추가합니다
    	    	clusterer.clear();
    	        clusterer.addMarkers(markers);
      };
      
      
      
      function replydbsave(){ //마커의 리플을 저장할때 결과처리하기
    	  //alert("오긴오냐");
    	  var addrtodb = decodeaddr; //주소
    	  var replycont = document.replypart.replyname.value; //리플
    	  var id = "${sessionScope.sessionID}"; //저장을 할 id
    	  //alert("lng = "+lng+"\nlat"+lat);
    	  if(replycont!=''&& addrtodb!=''&&addrtodb!=null&&replycont!=null){
    		$.ajax(
    				{
    					url : "<%=request.getContextPath()%>/ArrayServlet.do",
    					type: "get",
    					data:{"reply":[replycont,addrtodb,id,lng,lat]}, //여기서 데이터를 바로보내준다 
    					//리플데이터,주소,id,lng,lat
    					success:function(data){
    						var as = eval(data);//객체 변환
    						/* alert("데이터 저장성공 :\n"
    								+"지번주소 : "+ as[0] + "\n " + as[1]+" 개 데이터 저장"); */
    								alert("한줄평등록성공");
    								getreplyajax(addrtodb);
    								mapchange();
    					},
    					error:function(msg,error){
    						alert(error+"addrtodb : "+addrtodb+"\nreplycont = "+replycont);
    					}
    				}
    			  );
    	  }else{
    		  alert("리뷰나 주소를 입력해주세요\n"+"addrtodb = "+addrtodb+"\nreplycont = "+replycont);
    	  }    	  
      }
  
        /* 저장할객체생성 */
        var lng="";
        var lat="";
        var addr="";

        $(function(){        	
        	$('#latlngid').click(function(){
        		$.ajax(
        				{        					
        					url : "<%=request.getContextPath()%>/ArrayServlet.do",
        					type: "get",
        					data:{"string":[lng,lat,addr]}, //여기서 데이터를 바로보내준다
        					success:function(data){
        						var as = eval(data);//객체 변환
        						alert("데이터 저장성공 :\n"
        								+"지번주소 : "+ as[0] + "\n " + as[1]+" 개 데이터 저장");
        					},
        					error:function(msg,error){
        						alert(error);
        					}
        				}
        			  );
        	});
        		
        });	
        
     // 주소-좌표 변환 객체를 생성합니다
        var geocoder = new kakao.maps.services.Geocoder();

        var marker = new kakao.maps.Marker(), // 클릭한 위치를 표시할 마커입니다
            infowindow = new kakao.maps.InfoWindow({zindex:1}); // 클릭한 위치에 대한 주소를 표시할 인포윈도우입니다

        // 현재 지도 중심좌표로 주소를 검색해서 지도 좌측 상단에 표시합니다
        searchAddrFromCoords(map.getCenter(), displayCenterInfo);

     // 지도를 클릭했을 때 클릭 위치 좌표에 대한 주소정보를 표시하도록 이벤트를 등록합니다
     kakao.maps.event.addListener(map, 'click', function(mouseEvent) {
         searchDetailAddrFromCoords(mouseEvent.latLng, function(result, status) {
             if (status === kakao.maps.services.Status.OK) {
                 var detailAddr = !!result[0].road_address ? 
                 		'<div>도로명주소 : ' + result[0].road_address.address_name + '</div>' : '';
                 detailAddr += '<div>지번 주소 : ' + result[0].address.address_name + '</div>';
                 
                 var content = '<div class="bAddr">' +
                                 '<span class="title">주소정보</span>' + 
                                 detailAddr + 
                             '</div>';
                             //+'<input type="text">'
                             
                             addr=result[0].address.address_name;
                             setaddr(addr);
                      

                 // 마커를 클릭한 위치에 표시합니다 
                 marker.setPosition(mouseEvent.latLng);
                 
                 marker.setMap(map);
                 
                 /* document.getElementById('latid').innerHTML="위도는"+mouseEvent.latLng.getLat();
                 document.getElementById('lngid').innerHTML="경도는"+mouseEvent.latLng.getLng();
                 document.getElementById('addrid').innerHTML="지번주소 "+result[0].address.address_name;
                  */decodeaddr=result[0].address.address_name;
                 
                 lng=mouseEvent.latLng.getLng();
                 lat=mouseEvent.latLng.getLat();
                 addr=result[0].address.address_name;

                 // 인포윈도우에 클릭한 위치에 대한 법정동 상세 주소정보를 표시합니다
                 infowindow.setContent(content);
                 infowindow.open(map, marker);
             }
         });
     });
            
     // 중심 좌표나 확대 수준이 변경됐을 때 지도 중심 좌표에 대한 주소 정보를 표시하도록 이벤트를 등록합니다
        kakao.maps.event.addListener(map, 'idle', function() {
            searchAddrFromCoords(map.getCenter(), displayCenterInfo);
        });
     
        function searchAddrFromCoords(coords, callback) {
            // 좌표로 행정동 주소 정보를 요청합니다
            geocoder.coord2RegionCode(coords.getLng(), coords.getLat(), callback);
        }

        function searchDetailAddrFromCoords(coords, callback) {
            // 좌표로 법정동 상세 주소 정보를 요청합니다
            geocoder.coord2Address(coords.getLng(), coords.getLat(), callback);
        }
        
        function displayCenterInfo(result, status) {
            if (status === kakao.maps.services.Status.OK) {
                var infoDiv = document.getElementById('centerAddr');

                for(var i = 0; i < result.length; i++) {
                    // 행정동의 region_type 값은 'H' 이므로
                    if (result[i].region_type === 'H') {
                        infoDiv.innerHTML = result[i].address_name;
                        break;
                    }
                }
            }    
        }
        
        function searchaddr(){
        	
        	var cont = document.incruitpart.searchcontent.value;
        	
        	var status="";
        	status =searchaddrkeyword(cont);
        	/* if(status=="OK"){
        		//alert("searchaddrkeyword() is ok");
    			return;
    		}
        	//status =searchaddrtext(cont);
        	if(status=="OK"){
        		alert("searchaddrtext() is ok");
    			return;
    		}else{
    			alert("검색 결과가 없습니다.\nstatus is "+status)
    		} */
        	
        }
        function searchaddrkeyword(searchtext){
        	
        	// 장소 검색 객체를 생성합니다
        	var ps = new kakao.maps.services.Places(); 

        	// 키워드로 장소를 검색합니다
        	ps.keywordSearch(searchtext,  placesSearchCB); 
			
        	var returnstatus=" ";
        	// 키워드 검색 완료 시 호출되는 콜백함수 입니다
        	function placesSearchCB (data, status, pagination) {
        		
        		if (status === kakao.maps.services.Status.OK) {
        			
        	        // 검색된 장소 위치를 기준으로 지도 범위를 재설정하기위해
        	        // LatLngBounds 객체에 좌표를 추가합니다
        	        var bounds = new kakao.maps.LatLngBounds();
        	        
        	        for (var i=0; i<data.length; i++) {
        	            bounds.extend(new kakao.maps.LatLng(data[i].y, data[i].x));
        	        }       

        	        // 검색된 장소 위치를 기준으로 지도 범위를 재설정합니다
        	        map.setBounds(bounds);
        	        returnstatus="OK";
        	    }else{
        	    	searchaddrtext(searchtext);
        	    }
        	        		
        	}
        	
        }
        
        var addrsearchmarker;
        function searchaddrtext(cont){
        	// 주소로 좌표를 검색합니다
     
        	geocoder.addressSearch(cont, function(result, status) {
        		
        	    // 정상적으로 검색이 완료됐으면 
        	     if (status === kakao.maps.services.Status.OK) {
								
        	        var coords = new kakao.maps.LatLng(result[0].y, result[0].x);

        	        lng=result[0].y;
        	        lat=result[0].x;

        	        	var coord = new kakao.maps.LatLng(lng, lat);
        	        	var callback = function(result, status) {
        	        	    if (status === kakao.maps.services.Status.OK) {
        	        	        //console.log('그런 너를 마주칠까 ' + result[0].address.address_name + '을 못가');
        	        	        //alert('그런 너를 마주칠까 ' + result[0].address.address_name + '을 못가');
        	        	        decodeaddr=result[0].address.address_name;
        	        	        addr=result[0].address.address_name;
        	        	    }
        	        	};

        	        	geocoder.coord2Address(coord.getLng(), coord.getLat(), callback);
        	        
        	        //alert(coords+"\n"+result[0].y);
        	        
        	        // 결과값으로 받은 위치를 마커로 표시합니다
        	        
        	        /* if(addrsearchmarker==null){
        	        	alert("마커가 널임");
        	        }else{
        	        	alert("마커지우기");
        	        	addrsearchmarker.setMap(null);
        	        } */
        	        
        	        var addrsearchmarker = new kakao.maps.Marker({
        	            map: map,
        	            position: coords
        	        });

        	        // 인포윈도우로 장소에 대한 설명을 표시합니다
        	        var infowindow = new kakao.maps.InfoWindow({
        	            content: '<div style="width:150px;text-align:center;padding:6px 0;">검색한곳</div>'
        	        });
        	        infowindow.open(map, addrsearchmarker);

        	        // 지도의 중심을 결과값으로 받은 위치로 이동시킵니다
        	        map.setCenter(coords);
        	    } 
        	});  
        	
        }
        
        function getreplyajax(addr){
          
          		$.ajax(
          				{
          					url : "<%=request.getContextPath()%>/ArrayServlet.do",
				type : "get",
				dataType : "json",
				data : {
					"addr" : addr
				}, //여기서 데이터를 바로보내준다
				header : {//Content-Type 설정
					"Content-Type" : "application/json", 
					"X-HTTP-Method-Override" : "POST"
				},
				success : function(data) {
					//var as = eval(data);//객체 변환
					setreply(data);
					

				},
				error : function(msg, error) {
					alert(error);
				}
			});
		};
		
		 function getdetailajax(addrtoaddr){
			 
			 //alert("this addr to detail"+addr);
	          
       		$.ajax(
       				{
       					url : "<%=request.getContextPath()%>/ArrayServlet.do",
				type : "get",
				dataType : "json",
				data : {
					"addrtodetail" : addrtoaddr
				//상세정보를 가져오기위해 detail파라미터에 주소값을 넣어준다.
				}, //여기서 데이터를 바로보내준다
				header : {
					"Content-Type" : "application/json", //Content-Type 설정
					"X-HTTP-Method-Override" : "POST"
				},
				success : function(data) {
					//var as = eval(data);//객체 변환
					setdetail(data);

					//alert(data.toString());

				},
				error : function(msg, error) {
					alert("getdetailajax() " + error);

				}
			});
		};
//
		function OnloadImg(url){

  var img=new Image();

  img.src=url;

  var img_width=img.width;

  var win_width=img.width+25;

  var height=img.height+30;

  var OpenWindow=window.open('','_blank', 'width='+img_width+', height='+height+', menubars=no, scrollbars=auto');

  OpenWindow.document.write("<style>body{margin:0px;}</style><img src='"+url+"' width='"+win_width+"'>");

 }
		//
		
		function setdetail(data) {

			console.log(data);

			document.getElementById('detailcontent').innerHTML = "";

			var text = "";

			//var obj = JSON.parse(data);
			
			
			text += "제목 : " + encodeutf8(data.title) + "<br>";
			text += "상세 설명 : " + encodeutf8(data.content) + "<br>";
			text += "입주 가능일 : " + encodeutf8(data.rdate) + "<br>";
			text += "지번 주소 : <br>" + encodeutf8(data.naddress) + "<br>";
			text += "도로명 주소 : <br>" + encodeutf8(data.raddress) + "<br>";
			text += "방 구조 : " + encodeutf8(data.roomtype) + "<br>";
			text += "보증금 : " + encodeutf8(data.deposit) + "<br>";
			text += "월세 : " + encodeutf8(data.rent) + "<br>";
			text += "관리비 : " + encodeutf8(data.mpay) + "<br>";
			text += "관리비포함항목 : " + encodeutf8(data.mpay2) + "<br>";
			text += "주차 : " + encodeutf8(data.parking) + "<br>";
			text += "엘리베이터 : " + encodeutf8(data.elve) + "<br>";
			text += "층수 : " + encodeutf8(data.floor) + "<br>";
			text += "크기 : " + encodeutf8(data.rsize) + "<br>";
			if(encodeutf8(data.image1) != "내용 없음"){
				text += "<img src='../image/" + encodeutf8(data.image1) + "' width='70px' onclick='OnloadImg(this.src)'>"; 
			}
			if(encodeutf8(data.image2) != "내용 없음"){
				text += "<img src='../image/" + encodeutf8(data.image2) + "' width='70px' onclick='OnloadImg(this.src)'>";
			}
			if(encodeutf8(data.image3) != "내용 없음"){
				text += "<img src='../image/" + encodeutf8(data.image3) + "' width='70px' onclick='OnloadImg(this.src)'>";
			}
			if(encodeutf8(data.image4) != "내용 없음"){
				text += "<img src='../image/" + encodeutf8(data.image4) + "' width='70px' onclick='OnloadImg(this.src)'>";
			}
			if(encodeutf8(data.image5) != "내용 없음"){
				text += "<img src='../image/" + encodeutf8(data.image5) + "' width='70px' onclick='OnloadImg(this.src)'>";
			}

	
			document.getElementById('detailcontent').innerHTML = text;

			//document.getElementById('replycontent').innerHTML=text;
		}

		function setreply(data) {
			var text = "";
			var addr;
			$.each(data, function(index, list) {
				var text1 = "12 12";

				/* text += "<input type='button' value='삭제하기' onClick=aa('"+encodeutf8_2(list.addr)+"') >&nbsp;";
				text += "<input type='button' value='수정하기' onClick=aa('"+encodeutf8_2(list.addr)+"') ><br>";
				text += "주소는 = " + encodeutf8(list.addr); */
				addr = encodeutf8(list.addr);
				text += "<br>한줄평 : " + encodeutf8(list.reply);
				text += "<br>작성자 : " + encodeutf8(list.id) + "<br><br><hr>";

			});
			//document.getElementById('show').innerHTML = text;

			setaddr(addr);
			document.getElementById('replycontent').innerHTML = text;
		}

		function detailnull() {

			document.getElementById('detailcontent').innerHTML = "";
		}

		function setaddr(addr) { //화면의 폰트를 주소로 출력해준다.
			if(addr==""||addr==null||addr=="undefined"){
				addr=decodeaddr;
			}
			addr = "주소 : " + addr;
			document.getElementById('addrfont').innerHTML = addr;
			setreplynull();
			
		}

		function setreplynull() {
			document.getElementById('replycontent').innerHTML = "";
		}

		function aa(data) {
			//alert(+"\""+data+"\"");
			var ca = /\+/g;
			data.replace(ca, " ");
			alert(data);
			//document.getElementById('replycontent').innerHTML=" ";
		}
		function encodeutf8(str) {
			var ca = /\+/g;
			str = decodeURIComponent(str.replace(ca, " "));
			return str;
		}
		function encodeutf8_2(str) {
			//var ca = /\+/g;
			str = decodeURIComponent(str);
			return str;
		}
	</script>


</body>
</html>
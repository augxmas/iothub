<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.monorama.iot.ctl.IoTListener" %>
<%@ page import="org.json.simple.JSONArray" %>
<%@ page import="org.json.simple.JSONObject" %>
<%@ page import="java.util.List" %>

<!DOCTYPE html>
<%
String userName = (String)session.getAttribute(IoTListener.nameField);
if(userName == null){
	response.sendRedirect("pages-login.jsp");
}
String serialNum = (String)session.getAttribute(IoTListener.serialNumField);

%>
<html>
    <head>
		<%@ include file="./head.jsp" %>
    </head>
<script>

$(document).ready(function(){
	isFired();
	setInterval(isFired,3000);
});

function isFired(){
	var idx = 0;
	$.ajax({
		url:"/iothub/listener",
		type:"post",
		async : true,
	    headers : {              // Http header
	        "Content-Type" : "application/json",
	        "X-HTTP-Method-Override" : "POST"
	    },
	    dataType : 'text',		
	    data : JSON.stringify({  
	        'mode' :'<%=IoTListener.stateMode%>',
	        'serialNum':'<%=serialNum%>'	    	
	        
	    }),		
		success:function(result){
			var innerHtml = "";
			$("#state").empty();
			$("#date").empty();

			var flag = ""
			var arr = JSON.parse(result);
			var innerHtml = "<table id='apts' width='100%'>";
			var now = new Date();
			var mm = now.getMonth()+1;
			var yyyy = now.getFullYear();
			var dd = now.getDate();
			var hr = now.getHours();
			var min = now.getMinutes();
			
			if(mm < 10){	
				mm = "0" + mm;
			}
			
			if(hr == 0){
				hr = "00";
			}
			
			if(dd < 10){
				dd = "0" + dd;
			}
			
			if(min < 10){
				min = "0" + min;
			}
			
			var sec = now.getSeconds();
			if(sec < 10){
				sec = "0" + sec;
			}//*/
			
			var _now = parseInt(yyyy.toString()+mm.toString()+dd.toString()+hr.toString()+min.toString()+sec.toString());
			
			$("#date").append("확인시간 : " + mm + "월 " + dd + "일 " + hr + "시 " + min+ "분 " + sec+"초");

			for(i in arr){
				innerHtml += "<tr width='800px'>";
				innerHtml += "<td width='800px'>";
				innerHtml += "<div class='row'>";
				innerHtml += "<div class='col-md-4'>";
				innerHtml += "<div class='card-box'>";
				innerHtml += "<h4 class='text-dark header-title m-t-0'>";
				innerHtml += arr[i].aptName + "의 현재 상태";
				innerHtml += "</h4>";
				innerHtml += "<p class='text-muted m-b-25 font-13'>";
				gab = parseInt(_now) - parseInt(arr[i]._regdate.toString());

				/*
				console.log("idx : " + i );
				console.log("regdate " + arr[i]._regdate);
				console.log("now  " + _now);
				console.log("gab " +  gab);
				console.log(_now);
				console.log("00 " + arr[i].isFired00 + (arr[i].isFired00 == "1"));
				console.log("01 " + arr[i].isFired01 + (arr[i].isFired01 == "1"));
				//*/
				
				if(gab < 10){
					if(arr[i].isFired00 == "1"){
						innerHtml += "<a href='./pages-fire.jsp?idx=" + arr[i].idx+"&aptName="+ arr[i].aptName +"&serialNum="+arr[i].serialNum+"'><button class='btn btn-danger'>"+"화재발생"+"</button>";
						innerHtml += " ";
						innerHtml += "<button class='btn' id='flag0' >";
						innerHtml += "<a href='./pages-fire.jsp?serialNum="+arr[i].serialNum+"&aptName="+ arr[i].aptName+"'>제어하기</a></button>";
					}
					else { 
						innerHtml += "<a href='./pages-fire.jsp?idx=" + arr[i].idx+"&aptName="+ arr[i].aptName +"&serialNum="+arr[i].serialNum+"'><button class='btn btn-danger'>"+"해당없음"+"</button>";
						innerHtml += " ";
						innerHtml += "<button class='btn' id='flag1' >";
						innerHtml += "<a href='./pages-fire.jsp?serialNum="+arr[i].serialNum+"&aptName="+ arr[i].aptName+"'>제어하기</a></button>";
					}//*/
				}else{
					innerHtml += "<a href='./pages-fire.jsp?idx=" + arr[i].idx+"&aptName="+ arr[i].aptName +"&serialNum="+arr[i].serialNum+"'><button class='btn btn-primary'>"+"해당없음"+"</button>";
					innerHtml += " ";
					innerHtml += "<button class='btn' id='flag0' >";					
					innerHtml += "<a href='./pages-fire.jsp?serialNum="+arr[i].serialNum+"&aptName="+ arr[i].aptName+"'>제어하기</a></button>";
				}
				innerHtml += "</p>";
				innerHtml += "</div>";
				innerHtml += "</div>";
				innerHtml += "</div>";
				innerHtml += "</td>";
				innerHtml += "</tr>";
			}
			innerHtml += "</table>";
			$("#state").append(innerHtml);
		},
		error: function(data,status,xhr){
			alert("시스템 담당자에게 연락바랍니다");
		}
	})
	
}// end of isFire

</script>    
    <body>
        <!-- Navigation Bar-->
        <header id="topnav">
			<%@ include file="./navy.jsp" %>        
        </header>
        <!-- End Navigation Bar-->
        <div class="wrapper">
            <div class="container-fluid">
                <!-- Page-Title -->
                <div class="row">
                    <div class="col-sm-12">
                        <div class="page-title-box">
                        <%
                        String name = (String)session.getAttribute(IoTListener.nameField);
                        %>
						<h4 class="page-title"><%= name != null ? name : "" %>님께서 접속하셨습니다</h4>
                        </div>
                    </div>
                </div>
                <!-- end page title end breadcrumb -->
                <div id='date'></div>
				<div id="state"></div>
        <!-- Footer -->
<%@ include file="./footer.jsp" %>
        <!-- End Footer -->
        <!-- jQuery  -->
        <script src="assets/js/jquery.min.js"></script>
        <script src="assets/js/popper.min.js"></script><!-- Popper for Bootstrap --><!-- Tether for Bootstrap -->
        <script src="assets/js/bootstrap.min.js"></script>
        <script src="assets/js/waves.js"></script>
        <script src="assets/js/jquery.slimscroll.js"></script>
        <script src="assets/js/jquery.scrollTo.min.js"></script>
        <script src="../plugins/switchery/switchery.min.js"></script>
        <!-- Counter Up  -->
        <script src="../plugins/waypoints/lib/jquery.waypoints.min.js"></script>
        <script src="../plugins/counterup/jquery.counterup.min.js"></script>

        <!-- circliful Chart -->
        <script src="../plugins/jquery-circliful/js/jquery.circliful.min.js"></script>
        <script src="../plugins/jquery-sparkline/jquery.sparkline.min.js"></script>

        <!-- skycons -->
        <script src="../plugins/skyicons/skycons.min.js" type="text/javascript"></script>

        <!-- Page js  -->
        <script src="assets/pages/jquery.dashboard.js"></script>

        <!-- Custom main Js -->
        <script src="assets/js/jquery.core.js"></script>
        <script src="assets/js/jquery.app.js"></script>


        <script type="text/javascript">
            jQuery(document).ready(function($) {
            	/*
                $('.counter').counterUp({
                    delay: 100,
                    time: 1200
                });
                $('.circliful-chart').circliful();
                //*/
            });

            // BEGIN SVG WEATHER ICON
            if (typeof Skycons !== 'undefined'){
                var icons = new Skycons(
                        {"color": "#3bafda"},
                        {"resizeClear": true}
                        ),
                        list  = [
                            "clear-day", "clear-night", "partly-cloudy-day",
                            "partly-cloudy-night", "cloudy", "rain", "sleet", "snow", "wind",
                            "fog"
                        ],
                        i;

                for(i = list.length; i--; )
                    icons.set(list[i], list[i]);
                icons.play();
            };

        </script>



    </body>
</html>
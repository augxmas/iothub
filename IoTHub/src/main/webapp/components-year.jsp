<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.monorama.iot.ctl.IoTListener"%>

<%
String userName = (String) session.getAttribute(IoTListener.nameField);
if (userName == null) {
	response.sendRedirect("pages-login.jsp");
}
%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="./head.jsp"%>
<script>

$(document).ready(function(){
	//alert();
	showStatus();
	setInterval(showStatus,3000);
});

function showStatus(){
	
	$.ajax({
		url:"/IoTHub/listener",
		type:"post",
		async : true,
	    headers : {              // Http header
	        "Content-Type" : "application/json",
	        "X-HTTP-Method-Override" : "POST"
	    },
	    dataType : 'text',		
	    data : JSON.stringify({ 'mode' :'<%=IoTListener.statusMode%>'}),
		success : function(result) {
				var innerHtml = "";
				$("#status").empty();
				$("#date").empty();
				console.log(result);
				var flag = ""
				var arr = JSON.parse(result);
				var innerHtml = "";
				var now = new Date();
				var mm = now.getMonth() + 1;
				var dd = now.getDate();
				var hr = now.getHours();
				var min = now.getMinutes();
				if(min < 10){
					min = "0" + min;
				}
				var sec = now.getSeconds();
				if(sec < 10){
					sec = "0" + sec;
				}
				$("#date").append("확인시간:" + mm + "월" + dd + "일" + hr + "시" + min+ "분" + sec+"초 " );
				var i = 0;
				try{
					for (i = 0 ; i < arr.length/3 ; i++) {
						innerHtml+="<div class='card-box'>";
						innerHtml+="<h4 class='text-dark  header-title m-t-0 m-b-30'>"+arr[i*3].aptName+" 화재경보알람 보고서</h4>";
						innerHtml+="<div class='widget-chart text-center'>";
						innerHtml+="<div id='sparkline2'></div>";
						innerHtml+="<ul class='list-inline m-t-15 mb-0'>";
						innerHtml+="<li>";
						innerHtml+="<h5 class='text-muted m-t-20'>총경보</h5>";
						innerHtml+="<h4 class='m-b-0'>"+arr[i*3].cnt+"</h4>";
						innerHtml+="</li>";
						innerHtml+="<li>";
						innerHtml+="<h5 class='text-muted m-t-20'>월간경보</h5>";
						innerHtml+="<h4 class='m-b-0'>"+arr[i*3+1].cnt+"</h4>";
						innerHtml+="</li>";
						innerHtml+="<li>";
						innerHtml+="<h5 class='text-muted m-t-20'>제어건수</h5>";
						innerHtml+="<h4 class='m-b-0'>"+arr[i*3+2].cnt+"</h4>";
						innerHtml+="</li>";
						innerHtml+="</ul>";
						innerHtml+="</div>";
						innerHtml+="</div>	";	
						console.log(i);
					}//end of for loop
				}catch(exception){
					console.log(exception);
				}
				$("#status").append(innerHtml);
				
			},
			error : function(data, status, xhr) {

			}
		})

}// end of isFire
</script>
</head>
<script>
	
</script>
<body>

	<!-- Navigation Bar-->
	<%@ include file="./navy.jsp"%>
	<!-- End Navigation Bar-->
	<div class="wrapper">
		<div class="container-fluid">

			<!-- Page-Title -->
			<div class="row">
				<div class="col-sm-12">
					<div class="page-title-box">
						<h4 class="page-title"><%=userName%>님께서 접속하셨습니다
						</h4>
					</div>
				</div>
			</div>
			<!-- end page title end breadcrumb -->
			<div id='date'></div>
			<div id="status" class="col-lg-4"></div>
			<div class="row"></div>
			<!-- end row -->
		</div>
		<!-- end container -->
	</div>


	<!-- end wrapper -->


	<!-- Footer -->
	<%@ include file="./footer.jsp"%>
	<!-- End Footer -->


	<!-- jQuery  -->
	<script src="assets/js/jquery.min.js"></script>
	<script src="assets/js/popper.min.js"></script>
	<!-- Popper for Bootstrap -->
	<!-- Tether for Bootstrap -->
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
			$('.counter').counterUp({
				delay : 100,
				time : 1200
			});
			$('.circliful-chart').circliful();
		});

		// BEGIN SVG WEATHER ICON
		if (typeof Skycons !== 'undefined') {
			var icons = new Skycons({
				"color" : "#3bafda"
			}, {
				"resizeClear" : true
			}), list = [ "clear-day", "clear-night", "partly-cloudy-day",
					"partly-cloudy-night", "cloudy", "rain", "sleet", "snow",
					"wind", "fog" ], i;

			for (i = list.length; i--;)
				icons.set(list[i], list[i]);
			icons.play();
		};
	</script>



</body>
</html>
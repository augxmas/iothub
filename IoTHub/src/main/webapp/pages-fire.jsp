<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.monorama.iot.ctl.IoTListener"%>
<%@ page import="org.json.simple.JSONArray"%>
<%@ page import="org.json.simple.JSONObject"%>


<%
String userName = (String) session.getAttribute(IoTListener.nameField);
if (userName == null) {
	response.sendRedirect("pages-login.jsp");
}
String serialNum = (String) request.getParameter(IoTListener.serialNumField);
%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="./head.jsp"%>
<style>
/* The switch - the box around the slider */
.switch {
	position: relative;
	display: inline-block;
	width: 60px;
	height: 34px;
	vertical-align: middle;
}

/* Hide default HTML checkbox */
.switch input {
	display: none;
}

/* The slider */
.slider {
	position: absolute;
	cursor: pointer;
	top: 0;
	left: 0;
	right: 0;
	bottom: 0;
	background-color: #ccc;
	-webkit-transition: .4s;
	transition: .4s;
}

.slider:before {
	position: absolute;
	content: "";
	height: 26px;
	width: 26px;
	left: 4px;
	bottom: 4px;
	background-color: white;
	-webkit-transition: .4s;
	transition: .4s;
}

input:checked+.slider {
	background-color: #2196F3;
}

input:focus+.slider {
	box-shadow: 0 0 1px #2196F3;
}

input:checked+.slider:before {
	-webkit-transform: translateX(26px);
	-ms-transform: translateX(26px);
	transform: translateX(26px);
}

/* Rounded sliders */
.slider.round {
	border-radius: 34px;
}

.slider.round:before {
	border-radius: 50%;
}

p {
	margin: 0px;
	display: inline-block;
	font-size: 15px;
	font-weight: bold;
}
</style>
<script>

$(document).ready(function(){
	//var check = $("input[type='checkbox']");
	var check01 = $('input:checkbox[id="cmd01"]');
	check01.click(function(){
		$("#on01").toggle();
		$("#off01").toggle();
	});
	var check02 = $('input:checkbox[id="cmd02"]');
	check02.click(function(){
		$("#on02").toggle();
		$("#off02").toggle();
	});	
	var check03 = $('input:checkbox[id="cmd03"]');
	check03.click(function(){
		$("#on03").toggle();
		$("#off03").toggle();
	});
	var check04 = $('input:checkbox[id="cmd04"]');
	check04.click(function(){
		$("#on04").toggle();
		$("#off04").toggle();
	});
	var check05 = $('input:checkbox[id="cmd05"]');
	check05.click(function(){
		$("#on05").toggle();
		$("#off05").toggle();
	});
	var check06 = $('input:checkbox[id="cmd06"]');
	check06.click(function(){
		$("#on06").toggle();
		$("#off06").toggle();
	});
	var check07 = $('input:checkbox[id="cmd07"]');
	check07.click(function(){
		$("#on07").toggle();
		$("#off07").toggle();
	});	
	var check08 = $('input:checkbox[id="cmd08"]');
	check08.click(function(){
		$("#on08").toggle();
		$("#off08").toggle();
	});		
});
//*/

function go(){
	var cmd01 = 0,cmd02 = 0,cmd03 = 0,cmd04 = 0,cmd05 = 0,cmd06 = 0,cmd07 = 0,cmd08 = 0;
	if ( $('input:checkbox[id="cmd01"]').is(":checked") == true ){
		cmd01 = 1;
	}
	if ( $('input:checkbox[id="cmd02"]').is(":checked") == true ){
		cmd02 = 1;
	}
	if ( $('input:checkbox[id="cmd03"]').is(":checked") == true ){
		cmd03 = 1;
	}
	if ( $('input:checkbox[id="cmd04"]').is(":checked") == true ){
		cmd04 = 1;
	}
	if ( $('input:checkbox[id="cmd05"]').is(":checked") == true ){
		cmd05 = 1;
	}
	if ( $('input:checkbox[id="cmd06"]').is(":checked") == true ){
		cmd06 = 1;
	}
	if ( $('input:checkbox[id="cmd07"]').is(":checked") == true ){
		cmd07 = 1;
	}
	if ( $('input:checkbox[id="cmd08"]').is(":checked") == true ){
		cmd08 = 1;
	}
	
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
	        "mode" :"<%=IoTListener.cmdMode%>",
	        "cmd01":cmd01.toString(),
	        "cmd02":cmd02.toString(),
	        "cmd03":cmd03.toString(),
	        "cmd04":cmd04.toString(),
	        "cmd05":cmd05.toString(),
	        "cmd06":cmd06.toString(),
	        "cmd07":cmd07.toString(),
	        "cmd08":cmd08.toString(),
	        "serialNum":"<%=serialNum%>"
			}),
			success : function(result) {
				var obj = JSON.parse(result);
				alert(obj.message);
			},
			error : function(data, status, xhr) {

			}
		})
	}// end of go
	
	function reset(){
		var cmd01 = 0,cmd02 = 0,cmd03 = 0,cmd04 = 0,cmd05 = 0,cmd06 = 0,cmd07 = 0,cmd08 = 0;
		/*
		if ( $('input:checkbox[id="cmd01"]').is(":checked") == true ){
			cmd01 = 1;
		}
		if ( $('input:checkbox[id="cmd02"]').is(":checked") == true ){
			cmd02 = 1;
		}
		if ( $('input:checkbox[id="cmd03"]').is(":checked") == true ){
			cmd03 = 1;
		}
		if ( $('input:checkbox[id="cmd04"]').is(":checked") == true ){
			cmd04 = 1;
		}
		if ( $('input:checkbox[id="cmd05"]').is(":checked") == true ){
			cmd05 = 1;
		}
		if ( $('input:checkbox[id="cmd06"]').is(":checked") == true ){
			cmd06 = 1;
		}
		if ( $('input:checkbox[id="cmd07"]').is(":checked") == true ){
			cmd07 = 1;
		}
		if ( $('input:checkbox[id="cmd08"]').is(":checked") == true ){
			cmd08 = 1;
		}
		//*/
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
		        "mode" :"<%=IoTListener.cmdMode%>",
		        "cmd01":cmd01.toString(),
		        "cmd02":cmd02.toString(),
		        "cmd03":cmd03.toString(),
		        "cmd04":cmd04.toString(),
		        "cmd05":cmd05.toString(),
		        "cmd06":cmd06.toString(),
		        "cmd07":cmd07.toString(),
		        "cmd08":cmd08.toString(),
		        "serialNum":"<%=serialNum%>"
				}),
				success : function(result) {
					var obj = JSON.parse(result);
					alert(obj.message);
				},
				error : function(data, status, xhr) {

				}
			})
		}// end of reset
	
</script>

</head>

<body>

	<!-- Navigation Bar-->
	<header id="topnav">
		<%@ include file="./navy.jsp"%>
	</header>
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

			<div class="row">
				<div class="col-md-4">
					<div class="card-box">
						<h4 class="text-dark  header-title m-t-0"><%=request.getParameter(IoTListener.aptNameField)%> 수신기관리
						</h4>
						<span class="text-muted m-b-25 font-13">원격으로 수신기를 제어합니다.</span>
						<table class="table mb-0 table-responsive">
							<tbody>
								<tr>
									<td cols='2'><input type='button' onClick="javascript:go();" value="경보(소리)끄기" /></td>
									<td cols='2'><input type='button' onClick="javascript:reset();" value="감시재개(초기화)" /></td>
								</tr>
								<tr>
									<td>벨소리끄기</td>
									<td><label class="switch"><input id="cmd01" name="cmd01" type="checkbox" checked><span class="slider round"></span></label><p id='off01'>OFF</p><p id='on01' style="display: none;">ON</p></td>
								</tr>
								<tr>
									<td>시각경보끄기</td>
									<td><label class="switch"><input id="cmd02" name="cmd02" type="checkbox" checked><span class="slider round"></span></label><p id='off02'>OFF</p><p id='on02' style="display: none;">ON</p></td>
								</tr>
								<tr>
									<td>비상방송끄기</td>
									<td><label class="switch"><input id="cmd03" name="cmd03" type="checkbox" checked><span class="slider round"></span></label><p id='off03'>OFF</p><p id='on03' style="display: none;">ON</p></td>
								</tr>
								<tr>
									<td>펌프1끄기</td>
									<td><label class="switch"><input id="cmd04" name="cmd04" type="checkbox"><span class="slider round"></span></label><p id='off04'>OFF</p><p id='on04' style="display: none;">ON</p></td>
								</tr>
								<tr>
									<td>펌프2끄기</td>
									<td><label class="switch"><input id="cmd05" name="cmd05" type="checkbox"><span class="slider round"></span></label><p id='off05'>OFF</p><p id='on05' style="display:none;">ON</p></td>
								</tr>
								<tr>
									<td>펌프3끄기</td>
									<td><label class="switch"><input id="cmd06" name="cmd06" type="checkbox"><span class="slider round"></span></label><p id='off06'>OFF</p><p id='on06' style="display: none;">ON</p></td>
								</tr>
								<tr>
									<td>펌프4끄기</td>
									<td><label class="switch"><input id="cmd07" name="cmd07" type="checkbox"><span class="slider round"></span></label><p id='off07'>OFF</p><p id='on07' style="display: none;">ON</p></td>
								</tr>
								<tr>
									<td>펌프5끄기</td>
									<td><label class="switch"><input id="cmd08" name="cmd08" type="checkbox"><span class="slider round"></span></label><p  id='off08'>OFF</p><p id='on08' style="display: none;">ON</p></td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
				<!-- end col -8 -->
			</div>
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
			/*
			$('.counter').counterUp({
			    delay: 100,
			    time: 1200
			});
			$('.circliful-chart').circliful();
			//*/
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
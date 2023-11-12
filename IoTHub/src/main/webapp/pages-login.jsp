<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.monorama.iot.ctl.IoTListener"%>
<%
String code = request.getParameter("code");
if (code != null && code.equals(IoTListener.VALUE4NOTFOUND)) {
%>
<script>
	alert("사용자 정보를 확인해주세요");
</script>
<%
}
%>


<!DOCTYPE html>
<html>
<head>
<%@ include file="./head.jsp"%>
</head>
<script>

$(document).ready(function(){
	// 저장된 쿠키값을 가져와서 ID 칸에 넣어준다. 없으면 공백으로 들어감.
    var key = getCookie("key");
    $("#id").val(key); 
     
    // 그 전에 ID를 저장해서 처음 페이지 로딩 시, 입력 칸에 저장된 ID가 표시된 상태라면,
    if($("#id").val() != ""){ 
        $("#checkbox-signup").attr("checked", true); // ID 저장하기를 체크 상태로 두기.
    }
     
    $("#checkbox-signup").change(function(){ // 체크박스에 변화가 있다면,
        if($("#checkbox-signup").is(":checked")){ // ID 저장하기 체크했을 때,
            setCookie("key", $("#id").val(), 7); // 7일 동안 쿠키 보관
        }else{ // ID 저장하기 체크 해제 시,
            deleteCookie("key");
        }
    });
     
    // ID 저장하기를 체크한 상태에서 ID를 입력하는 경우, 이럴 때도 쿠키 저장.
    $("#id").keyup(function(){ // ID 입력 칸에 ID를 입력할 때,
        if($("#checkbox-signup").is(":checked")){ // ID 저장하기를 체크한 상태라면,
            setCookie("key", $("#id").val(), 7); // 7일 동안 쿠키 보관
        }
    });
})

// 쿠키 저장하기 
// setCookie => saveid함수에서 넘겨준 시간이 현재시간과 비교해서 쿠키를 생성하고 지워주는 역할
function setCookie(cookieName, value, exdays) {
	var exdate = new Date();
	exdate.setDate(exdate.getDate() + exdays);
	var cookieValue = escape(value) + ((exdays == null) ? "" : "; expires=" + exdate.toGMTString());
	document.cookie = cookieName + "=" + cookieValue;
}

// 쿠키 삭제
function deleteCookie(cookieName) {
	var expireDate = new Date();
	expireDate.setDate(expireDate.getDate() - 1);
	document.cookie = cookieName + "= " + "; expires="+ expireDate.toGMTString();
}
 
// 쿠키 가져오기
function getCookie(cookieName) {
	cookieName = cookieName + '=';
	var cookieData = document.cookie;
	var start = cookieData.indexOf(cookieName);
	var cookieValue = '';
	if (start != -1) { // 쿠키가 존재하면
		start += cookieName.length;
		var end = cookieData.indexOf(';', start);
		if (end == -1) { // 쿠키 값의 마지막 위치 인덱스 번호 설정 
			end = cookieData.length;
		}
        console.log("end위치  : " + end);
		cookieValue = cookieData.substring(start, end);
	}
	return unescape(cookieValue);
}


function go(){
	if($("#id").val()== ""){
		alert("ID를 입력해주세요");
		$("#id").focus();
		return;
	}
	if($("#password").val()== ""){
		alert("비밀번호를 입력해주세요");
		$("#password").focus();
		return;
	}	
	document.forms[0].submit();
}// end of go

</script>

<body>

	<div class="wrapper-page">

		<div class="text-center">
			<a href="pages-login.html" class="logo-lg"><i
				class="mdi mdi-google-chrome"></i> <span>SEYES</span> </a>
		</div>
		<div class="logo-lg">
			<center>
				<h4>스마트 안전관리 솔루션</h4>
			</center>
		</div>

		<form method='post' class="form-horizontal m-t-20"
			action="/iothub/listener">

			<div class="form-group row">
				<div class="col-12">
					<div class="input-group">
						<span class="input-group-addon"><i class="mdi mdi-account"></i></span>
						<input id='id' name='id' required class="form-control" type="text"
							placeholder="ID">
					</div>
				</div>
			</div>

			<div class="form-group row">
				<div class="col-12">
					<div class="input-group">
						<span class="input-group-addon"><i class="mdi mdi-radar"></i></span>
						<input id='password' name='password' class="form-control"
							type="password" required placeholder="Password">
					</div>
				</div>
			</div>

			<div class="form-group row">
				<div class="col-12">
					<div class="checkbox checkbox-primary">
						<input id="checkbox-signup" type="checkbox"> <label
							for="checkbox-signup"> 아이디기억하기 </label>
					</div>

				</div>
			</div>

			<div class="form-group text-center">
				<div class="col-xs-12">
					<input id='mode' name='mode' required class="form-control"
						type="hidden" value="1">
					<button class="btn btn-outline-primary" type="submit">
						<a href="javascript:go()" class="text-muted">로그인</a>
					</button>
				</div>
			</div>

			<div class="form-group row m-t-30">
				<div class="col-sm-7">
					<a href="#" class="text-muted"><i class="fa fa-lock m-r-5"></i>
						비번찾기</a>
				</div>
				<div class="col-sm-5 text-right">
					<a href="#" class="text-muted">회원가입</a>
				</div>
			</div>
		</form>
	</div>
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

	<!-- App js -->
	<script src="assets/js/jquery.core.js"></script>
	<script src="assets/js/jquery.app.js"></script>

</body>
</html>
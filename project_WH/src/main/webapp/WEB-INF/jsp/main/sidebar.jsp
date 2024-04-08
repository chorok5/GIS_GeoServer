<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>side bar</title>
<link rel="stylesheet" type="text/html" href="t-file.jsp">
<style>

</style>
</head>
<body>
<!-------------------------------------------------------->
<!----------------------- 사이드바 ----------------------->
<!-------------------------------------------------------->
<div class="sidebar">
  <ul>
    <li><a href="#" id="carbonMap" >탄소지도</a></li>
    <li><a href="#" id="dataOption" >데이터</a></li>
    <li><a href="./chart.do" id="statistic" >통계</a></li>
  </ul>
</div>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>

 <c:import url="map.jsp" />    
 <c:import url="t-file.jsp" />    
 <c:import url="chart.jsp" />    
<script>
<!-- 탄소지도 내용 -->

 document.getElementById("carbonMap").addEventListener("click", function() {
  var selectBoxContainer = document.getElementById("selectBoxContainer");
  if (selectBoxContainer.style.display === "block") {
    selectBoxContainer.style.display = "none";
  } else {
    selectBoxContainer.style.display = "block";
  }
});
 
//데이터 항목 클릭 이벤트 핸들러
 $("#dataOption").on("click", function(event) {
   event.preventDefault(); // 기본 동작 방지

   // 파일 업로드 폼 보이기
   $(".dropArea").toggle();
   $("#fileBtn").toggle(); // 파일 업로드 버튼도 함께 토글
   $(".fileform").toggle();
   $("#progressModal").hide();
   $("#failModal").hide();
 });
 </script>
 


</body>
</html>
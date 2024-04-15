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
.modal-backdrop {
    display: none !important;
}
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
    <li><a href="#" id="statistic" >통계</a></li>
  </ul>
</div>
 <c:import url="map.jsp" />    
 <c:import url="t-file.jsp" />    
 
<!-- 모달 -->
<div class="modal fade" id="chartModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-xl">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="exampleModalLabel">통계 차트</h5>
                <button type="button" class="btn-close" aria-label="Close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <c:import url="chart.jsp" /> 
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-success" data-bs-dismiss="modal">닫기</button>
            </div>
        </div>
    </div>
</div>
 
<script>
<!-- 탄소지도 내용 -->
$("#carbonMap").on("click", function(event) {
	   event.preventDefault();
	   var selectBoxContainer = $("#selectBoxContainer");
	   selectBoxContainer.toggle();
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
//통계 항목 클릭 이벤트 핸들러
 $("#statistic").on("click", function(event) {
    event.preventDefault(); // 기본 동작 방지

    // 통계 모달 열기
    $("#chartModal").modal("show");
 });
 
 </script>
</body>
</html>
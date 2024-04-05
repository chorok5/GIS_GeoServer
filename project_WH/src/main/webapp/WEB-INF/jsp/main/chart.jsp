<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>chart</title>
<!-- jquery -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<!-- Bootstrap JavaScript 파일 추가 -->
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.min.js"></script>
<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
<script type="text/javascript">

	$(function() {
	
     	// Load the Visualization API and the piechart package.
        google.charts.load('current', {'packages':['bar']});

        // Set a callback to run when the Google Visualization API is loaded.
        google.charts.setOnLoadCallback(drawChart);
		
    // Callback that creates and populates a data table, 
    // instantiates the pie chart, passes in the data and
    // draws it.
    function drawChart(response) {
		
    	  if (!response || response.length === 0) {
             alert("시도를 먼저 선택해주세요.");
             return;
         }

   	    // Create the data table.
   	    var data = new google.visualization.DataTable();
        data.addColumn('string', '지역 이름');
        data.addColumn('number', '전기 사용량(kWh)');
        response.forEach(function(item) {
        	data.addRow([item.sd_nm, item.total_used_kwh]);
        });

    // Set chart options
    var options = {
                'title':'전체 전기 사용량',
                'width':1000,
                'height':800,
                bars : 'horizontal'
        };

    // Instantiate and draw our chart, passing in some options.
    var chart = new google.charts.Bar(document.getElementById('chart_div'));
    chart.draw(data, google.charts.Bar.convertOptions(options));
  }
	$('#showStatus').click(function() {
		var sdCd1 = $('#loc').val();
		var allSelected = $('#loc option:selected').attr('id') === 'all';
		alert(sdCd1);
		alert(allSelected);
		console.log(sdCd1);
		console.log(allSelected);

		if (allSelected) { // 전체 선택 옵션
			$.ajax({
				type : 'POST',
				url : '/allSelect.do',
				dataType : 'json',
				success : function(response) {
					alert("ㅅㄱ");
					drawChart(response);
				},
				error : function(xhr, status, error) {
				}
			});
		} else if (!allSelected) { // 시 선택 차트
			$.ajax({
				type : 'POST',
				url : '/sdSelectChart.do',
				dataType : 'json',
				data : {
					'sdCd1' : sdCd1
				}, //선택된 값 전송
				success : function(response) {
					alert("시선택 alert");
					drawChart22(response);
				},
				error : function(xhr, status, error) {
					console.error(error);
				}
			});
			$.ajax({ // 시 선택 테이블
				type : 'POST',
				url : '/sdSelectTable.do',
				dataType : 'json',
				data : {
					'sdCd1' : sdCd1
				}, //선택된 값 전송
				success : function(response) {
					drawTable22(response);
				},
				error : function(xhr, status, error) {
					console.error(error);
				}
			});
		}
	});
});
	
</script>
<style>
#table thead th {
	border: 1px solid black; /* 제목에 테두리 추가 */
}

#table tbody td {
	border: 1px solid black; /* 내용에 테두리 추가 */
}
</style>
</head>
<body>
	<div>
		<div>
			<select id="loc" name="loc">
				<option>시/도 선택</option>
				<option id="all" value="${total_used_kwh}">전체 선택</option>
				<c:forEach items="${chartList}" var="row2">
					<option id="sd" value="${row2.sd_cd}">${row2.sd_nm}</option>
				</c:forEach>
			</select>
		</div>
		<br>
		<button type="button" class="btn btn-secondary" id="showStatus" data-bs-toggle="modal" data-bs-target="#myModal">통계 보기</button>

		<!-- 위 버튼 누르면 작동하는 모달 -->
		<div class="modal fade" id="myModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
			<div class="modal-dialog modal-xl">
				<div class="modal-content" style="width: 1300px; height: 1050px;">
					<div class="modal-header">
						<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
					</div>
					<div class="modal-body">
						<div>
							<div id="chart_div" style="width:800; height:800"></div>
						</div>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-danger" data-bs-dismiss="modal">닫기</button>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>
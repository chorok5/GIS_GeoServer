<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>chart</title>
<!-- Bootstrap CSS 파일 추가 -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
	<div>
		<div style="display: inline-block;">
			<select id="loc" name="loc">
				<option>시/도 선택</option>
				<option id="all" value="${total_used_kwh}">전체 선택</option>
				<c:forEach items="${chartList}" var="row2">
					<option id="sdOption" value="${row2.sd_cd}">${row2.sd_nm}</option>
				</c:forEach>
			</select>
		</div>

		<!-- 통계 보기 버튼 -->
		<button type="button" class="btn btn-success" id="showStatus">통계 보기</button>
	</div>
	    <div style="text-align: right;">
        <button type="button" class="btn btn-success" id="reset">리셋</button>
    </div>
	<!-- 모달 -->
	<div id="chartModal">
		<div>
			<div class="modal-body">
				<div id="chart_div"></div>
				<!-- 통계 차트를 표시할 공간 -->
			</div>
		</div>
	</div>
	<br>

	<!-- jquery -->
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
	<!-- Bootstrap JavaScript 파일 추가 -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
	<!-- Google Charts 라이브러리 로드 -->
	<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>

	<script type="text/javascript">

		$(function() {
			google.charts.load('current', {
				'packages' : [ 'bar' ]
			});

			google.charts.setOnLoadCallback(drawChart);

			function drawChart(response) {
				if (!response || response.length === 0) {
					// alert("시도를 먼저 선택해주세요.");
					return;
				}

				var data = new google.visualization.DataTable();
				data.addColumn('string', '지역 이름');
				data.addColumn('number', '전기 사용량(kWh)');
				response.forEach(function(item) {
					data.addRow([ item.sd_nm, item.total_used_kwh ]);
				});

				var options = {
					'title' : '전체 전기 사용량',
					'width' : 1000,
					'height' : 800,
					bars : 'horizontal'
				};

				var chart = new google.charts.Bar(document
						.getElementById('chart_div'));
				chart.draw(data, google.charts.Bar.convertOptions(options));
			}

			function drawTable(response) {
			    var tableHtml = '<table class="table"><thead style="position: sticky; top: 0; background-color: white; z-index: 1;"><tr><th>지역 이름</th><th>전기 사용량(kWh)</th></tr></thead><tbody>';

			    response.forEach(function(item) {
			        tableHtml += '<tr><td>' + item.sd_nm + '</td><td>'
			                + item.total_used_kwh + '</td></tr>';
			    });

			    tableHtml += '</tbody></table>';

			    $('#chartModal .modal-body').html(tableHtml).css({
			        'max-height' : '450px',
			        'overflow-y' : 'auto',
			        'background-color' : 'white'
			    });

			}
			$('#showStatus')
					.click(
							function() {
								console.log('버튼 클릭됨');
								jQuery('#chartModal').modal('show'); // 모달 열기
							    
							    var selectedOption = $('#loc').val();
							    if (selectedOption === '시/도 선택') {
							        return;
							    }
							    
								var sdCd1 = $('#loc').val();
								var allSelected = $('#loc option:selected')
										.attr('id') === 'all';
								
								if (allSelected) { // 전체 선택 옵션
									$.ajax({
										type : 'POST',
										url : '/allSelect.do',
										dataType : 'json',
										success : function(response) {
											
											drawChart(response);
										},
										error : function(xhr, status, error) {
											console.error(error);
										}
									});
								} else { // 시 선택 차트와 테이블
									$.ajax({
										type : 'POST',
										url : '/sdSelectChart.do',
										dataType : 'json',
										data : {
											'sdCd1' : sdCd1
										},
										success : function(response) {
											drawChart(response);
										},
										error : function(xhr, status, error) {
											console.error(error);
										}
									});
									$.ajax({
										type : 'POST',
										url : '/sdSelectTable.do',
										dataType : 'json',
										data : {
											'sdCd1' : sdCd1
										},
										success : function(response) {
											drawTable(response);
										},
										error : function(xhr, status, error) {
											console.error(error);
										}
									});
								}
							});
		});
		
		$(document).ready(function() {
		    $('#reset').click(function() {
		        $('#chart_div').hide();
		    });

		    $('#showStatus').click(function() {
		        $('#chart_div').show();
		    });
		});
	</script>

</body>
</html>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>지도</title>

<script src="https://cdn.jsdelivr.net/npm/ol@v9.0.0/dist/ol.js"></script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/ol@v9.0.0/ol.css">

<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js" integrity="sha512-v2CJ7UaYy4JwqLDIrZUI/4hqeoQieOmAZNXBeQyjo21dadnwR+8ZaIJVT8EE2iyI61OV8e6M8PP2/4hpQINQ/g=="
	crossorigin="anonymous" referrerpolicy="no-referrer"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
<script scr="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/4.4.1/chart.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script src="https://canvasjs.com/assets/script/canvasjs.min.js"></script>
<link rel="stylesheet" href="//cdn.jsdelivr.net/npm/xeicon@2.3.3/xeicon.min.css">
<link href="https://fonts.googleapis.com/css?family=Roboto:300,400,400i,500'">
<link rel="stylesheet" type="text/css" href="/css/navbar.css">

<style type="text/css">

.map {
	height: 800px;
	width: 60%;
	float: right; /* 맵을 우측에 배치합니다. */
}
.select-box {
	margin: 0 20px;
	margin-bottom: 20px;
}
.select-box select {
  width: 200px; /* 모든 셀렉트 박스 너비 200px 설정 */
}
.select-box-container {
	position: fixed;
	top: 100px;
	left: 250px;
	margin-right:0px;
	width: 150px;
	height: 300px;
	background-color: white;
	padding: 10px;
	display: none;
	/*z-index: 1000;  옵션 선택 부분을 다른 요소들보다 위로 올립니다. */
}

/*****************************************************************/
/*************************** 모달 CSS  ***************************/
/*****************************************************************/
.modal {
  display: none; /* 기본적으로 숨겨진 상태 */
  position: fixed; /* 스크롤 영역에 영향을 받지 않음 */
  z-index: 1000; /* 다른 요소 위에 표시 */
  left: 0;
  top: 0;
  width: 100%;
  height: 100%;
  overflow: auto; /* 모달 창 내용이 넘치면 스크롤바 표시 */
  background-color: rgba(0, 0, 0, 0.4); /* 배경 어둡게 */
}

.modal-content {
  position: relative;
  background-color: #fff;
  margin: 15% auto;
  padding: 30px;
  width: 50%;
  border: 1px solid #888;
}

.close {
  color: #aaa;
  float: right;
  font-size: 28px;
  font-weight: bold;
  cursor: pointer;
}

.close:hover, .close:focus {
  color: black;
  text-decoration: none;
}

.progress-bar {
  height: 20px;
  background-color: #ddd;
  border-radius: 10px;
}

.progress {
  height: 100%;
  background-color: #B686F3;
  border-radius: 10px;
  padding: 5px;
  text-align: center; /* 텍스트를 가운데 정렬 */
  line-height: 20px; /* 수직 가운데 정렬 */
}
.header {
  position: fixed; /* 헤더를 맨 위에 고정시킵니다. */
  top: 0; /* 화면의 맨 위에 헤더를 배치합니다. */
  width: 100%; /* 화면 전체 너비를 차지하도록 설정합니다. */
  background-color: #f0f0f0; /* 헤더의 배경색을 설정합니다. */
  z-index: 1000; /* 다른 요소보다 위에 표시되도록 설정합니다. */
  }
.content {
margin-top: 100px; /* 헤더의 아래에 배치하기 위해 헤더의 높이만큼 여백을 줍니다. */
padding: 20px; /* 컨텐츠 영역 주변에 여백을 줍니다. */
 }
  
.dropArea {
    display: none;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    margin-top: 200px;
    margin-left: 200px;
    width: 400px;
    height : 200px;
    border: 2px dashed #ccc;
    padding: 30px;
    text-align: center;
    cursor: pointer;
}
#file {
  position: absolute;
    margin-top: 60px;
    margin-left: 50px;
  transform: translate(-50%, -50%);
}
.fileBtn {
	display: none;
    margin-top: 10px;
    margin-left: 300px;
    /* width: 100px; */
    padding: 10px 20px; 
    background-color: #4CAF50; 
    color: white; 
    border: none; 
    border-radius: 5px; 
    cursor: pointer;
}
#chartContainer {
    position: absolute;
    width: 500px;
    height: 500px;
    top: 100px; /* 맵 상단에서의 거리 */
    left: 10px; /* 맵 좌측에서의 거리 */
}

</style>

</head>
<body>
<div class="header">
	<h1 style="height:50px">header</h1>
</div>

<div class="content">

<!------------------------------------------------------------------------------------------------->
<!----------------------------------------- 기본 맵 ----------------------------------------------->
<!------------------------------------------------------------------------------------------------->
	<div class="map-container">
		<div id="map" class="map"></div>
	</div>
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
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>

<!-- 탄소지도 내용 -->
<script>
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
    $("#progressModal").hide();
    $("#failModal").hide();
}); 
 </script>

</div>


<!-- 메뉴 3개가 겹치지 않고 하나씩 나타나게 하기 -->
<script>


</script>


<!------------------------------------------------------------------------------------------------->
<!--------------------------------------- 파일 업로드 --------------------------------------------->
<!------------------------------------------------------------------------------------------------->

<!-- 파일 업로드 폼 -->
<div class="dropArea" id="dropArea">
<form id="form">
	<label for="file" class="file-label"></label>
  <input type="file" id="file" name="file" accept=".txt">
</form>
</div>
<button type="button" id="fileBtn" class="fileBtn">업로드</button>

<!-- 업로드 진행 폼 -->
<div id="progressModal" class="modal">
  <div class="modal-content">
  업로드 진행중
    <span class="close">&times;</span>
    <div class="progress-bar">
      <div id="progressBar" class="progress">
      </div>
    </div>
  </div>
</div>

<!-- 업로드 실패 폼 -->
<div id="failModal" class="modal">
  <div class="modal-content">
    <span class="close">&times;</span>
    <p>파일 업로드에 실패했습니다.</p>
  </div>
</div>
     
<script>
// 파일 업로드 버튼 클릭 이벤트 핸들러
$("#fileBtn").on("click", function() {
    let fileName = $('#file').val();
    if (fileName == "") {
        return false;
    }
    let dotName = fileName.substring(fileName.lastIndexOf('.') + 1).toLowerCase();
    if (dotName == 'txt') {
        // 모달 열기
        $(".modal").css("display", "block");

        // AJAX 요청 전 모달 내용에 프로그래스 바 추가
        $(".modal-content").html('<div class="progress-bar"><div class="progress"></div></div>');

        $.ajax({
            url: './t-file2.do',
            type: 'POST',
            dataType: 'text',
            data: new FormData($('#form')[0]),
            cache: false,
            contentType: false,
            processData: false,
            enctype: 'multipart/form-data',
            xhr: function() {
                var xhr = new window.XMLHttpRequest();
                xhr.upload.addEventListener("progress", function(evt) {
                    if (evt.lengthComputable) {
                        var percentComplete = evt.loaded / evt.total;
                        $(".progress").css("width", percentComplete * 100 + "%");
                    }
                }, false);
                return xhr;
            },
            success: function(response) {
            	// 파일 업로드 성공 또는 실패 시 파일 업로드 폼 리셋
                $('#form')[0].reset();
            	
            	if (response.trim() === "success") {
                	// 파일 업로드 성공 시 Swal.fire로 성공 알림창 띄우기
                    Swal.fire({
                        icon: 'success',
                        title: '업로드 성공!',
                        text: '파일이 성공적으로 업로드되었습니다.'
                    });
                } else {
                    // 파일 업로드 실패 시 Swal.fire로 실패 알림창 띄우기
                    Swal.fire({
                        icon: 'error',
                        title: '업로드 실패',
                        text: '파일 업로드에 실패했습니다.'
                    });
                }
            },
            error: function(xhr, status, error) {
            	// 서버와의 통신에 실패한 경우 Swal.fire로 실패 알림창 띄우기
                Swal.fire({
                    icon: 'error',
                    title: '업로드 실패',
                    text: '서버와의 통신에 실패했습니다. 다시 시도해주세요.'
                });
             // 파일 업로드 실패 시 파일 업로드 폼 리셋
                $('#form')[0].reset();
            },
            complete: function() {
                // AJAX 요청이 완료되면 모달 닫기
                $(".modal").css("display", "none");
            }
        });
    } else {
        alert("확장자가 안 맞으면 멈추기");
    }
});
</script>

<!------------------------------------------------------------------------------------------------->
<!---------------------------- 시도, 시군구, 법정동 셀렉트박스 ------------------------------------>
<!------------------------------------------------------------------------------------------------->
   	<!-- ${row.geom } 추가해야지 지도 이동됨.... -->
<div id="selectBoxContainer" class="select-box-container">
  <div class="select-box">
  <h3>시도 선택</h3>
    <select id="sdSelect">
      <option value="">시도 선택</option>
      <c:forEach var="row" items="${sdList}">
        <option value="${row.sd_cd}, ${row.geom }">${row.sd_nm}</option>
      </c:forEach>
    </select>
  </div>
  <br>
  <div class="select-box">
  <h3>시군구 선택</h3>
    <select id="sggSelect">
      <option value="">시군구 선택</option>
    </select>
  </div>
  <br>
  <div class="select-box">
  <h3>범례 선택</h3>
     <select id="legendSelect">
         <option value="default">범례 선택</option>
         <option value="1">등간격</option>
         <option value="2">내추럴 브레이크</option>
     </select>
  </div>
  <br>
  <button id="insertbtn" class="insertbtn">입력하기</button>
</div>

<!------------------------------------------------------------------------------------------------->
<!------------------------------------- OpenLayers MAP -------------------------------------------->
<!------------------------------------------------------------------------------------------------->
<script type="text/javascript">
$(document).ready(function() {
	
let map = new ol.Map(
		{ // OpenLayer의 맵 객체를 생성한다.
			target : 'map', // 맵 객체를 연결하기 위한 target으로 <div>의 id값을 지정해준다.
			layers : [ // 지도에서 사용 할 레이어의 목록을 정희하는 공간이다.
			new ol.layer.Tile(
		{
		source : new ol.source.OSM(
		{url : 'https://api.vworld.kr/req/wmts/1.0.0/5FEEDEDB-3705-3E32-8DC7-583B0B613B26/Base/{z}/{y}/{x}.png' // vworld의 지도를 가져온다.
		})
		}) ],
	view : new ol.View({ // 지도가 보여 줄 중심좌표, 축소, 확대 등을 설정한다. 보통은 줌, 중심좌표를 설정하는 경우가 많다.
		center : ol.proj.fromLonLat([ 128.4,
				35.7 ]),
		zoom : 7
	})
});

//<!------------------------------------------------------------------------------------------------->
//<!---------------- 시도 선택 시 시군구 옵션 업데이트 및 새로운 시도 레이어 추가 ------------------->
//<!------------------------------------------------------------------------------------------------->
$('#carbonMap').on("click", function() {

      // 시도 메뉴를 클릭했을 때 시군구 레이어가 있을 경우 제거
    map.getLayers().forEach(function (layer) {
        if (layer.get('name') === 'sggLayer') {
            map.removeLayer(layer);
        }
    });

    // 시도 메뉴를 클릭했을 때 법정동 범례 레이어가 있을 경우 제거
    map.getLayers().forEach(function (layer) {
        if (layer.get('name') === 'newBjdLayer') {
            map.removeLayer(layer);
        }
    }); 
    // 이전에 추가된 범례 레이어를 찾아서 제거
    map.getLayers().forEach(function (layer) {
        if (layer.get('name') === 'bjdLayer') {
            map.removeLayer(layer);
        }
    });
});
    
    
//새로운 시도 레이어 생성
var newSdLayer = new ol.layer.Tile({
	name: 'sdLayer',
    source: new ol.source.TileWMS({
    	target: 'newSdLayer',
        url: 'http://localhost/geoserver/korea/wms?service=WMS',
        params: {
            'VERSION': '1.1.0',
            'LAYERS': 'korea:tl_sd',
            'SRS': 'EPSG:3857',
            'FORMAT': 'image/png'
        },
        serverType: 'geoserver',
    })
});

$('#sdSelect').on("change", function() {
    var sdValue = $(this).val().split(',')[0]; //sd_cd
    
    // 기존에 추가된 시도 레이어가 있을 경우 제거
/*     map.getLayers().forEach(function (layer) {
        if (layer.get('name') === 'sdLayer') {
            map.removeLayer(layer);
        }
    }); */
    
    // 기존에 추가된 시군구 레이어가 있을 경우 제거
    map.getLayers().forEach(function (layer) {
        if (layer.get('name') === 'sggLayer') {
            map.removeLayer(layer);
        }
    });
    
    // 이전에 추가된 범례 레이어를 찾아서 제거
    map.getLayers().forEach(function (layer) {
        if (layer.get('name') === 'bjdLayer') {
            map.removeLayer(layer);
        }
    });
    
    //--------------- 선택된 시/도의 geom값을 가져와서 지도에 표시 ---------------//
    var geom = $(this).val().split(',')[1]; // x 좌표
       
    // alert("도시코드:"+sdValue+", 좌표:"+geom);
    
    var regex = /POINT\(([-+]?\d+\.\d+) ([-+]?\d+\.\d+)\)/;
    var matches = regex.exec(geom);
    var xCoordinate, yCoordinate;
     
    if (matches) {
        xCoordinate = parseFloat(matches[1]); // x 좌표
        yCoordinate = parseFloat(matches[2]); // y 좌표
    } else {
        alert("GEOM값 가져오기 실패!");
    }

    var sidoCenter = ol.proj.fromLonLat([xCoordinate, yCoordinate]);
    map.getView().setCenter(sidoCenter); // 중심좌표 기준으로 보기
    map.getView().setZoom(10); // 중심좌표 기준으로 줌 설정
    
	// PARAM 추가해줘야 AJAX 로 PARAM 보내줄 수 있음
    newSdLayer.getSource().updateParams({'CQL_FILTER' : "sd_cd = " + sdValue});
       
    //map.addLayer(newSdLayer); // 맵 객체에 레이어를 추가함
    
    //--------------- 시도 선택 시 시군구 불러오기 옵션 & 레이어 추가 ---------------//
    let sggOpt = `<option value="0">선택</option>`; // 시군구 Option html String
    let sggDd = document.querySelector("#sggSelect"); // 시군구 드롭다운
    
    $.ajax({
        type: 'post',
        url: '/getSggList.do', 
        data: { 'sdValue': sdValue }, 
        dataType: "json",
        success: function(data) {
        	console.log(data); // 배열로 출력됨. 이거 가져다 쓰면 됨!! (오류 해결)
        	sggDd.innerHTML = "";
        	for(let i = 0; i < data.length;i++) {
                 sggOpt += "<option value='"+ data[i].sgg_cd+"'>"+ data[i].sgg_nm+"</option>";
          	  }
        		sggDd.innerHTML = sggOpt;
        	},
        	error : function(error){
                alert("문제발생"+error);
            }
    }); 
    map.addLayer(newSdLayer);
});

//<!------------------------------------------------------------------------------------------------->
//<!-------------- 범례, 범례 시군구 선택 시 법정동 옵션 업데이트 및 새로운 시군구 레이어 추가 ----------------->
//<!------------------------------------------------------------------------------------------------->
  $('#sggSelect').on("change", function() {
	 var sggValue = $("#sggSelect option:checked").val();
	 console.log(sggValue);
	 
	    // 기존에 추가된 시군구 레이어가 있을 경우 제거
	    map.getLayers().forEach(function (layer) {
	        if (layer.get('name') === 'sggLayer') {
	            map.removeLayer(layer);
	        }
	    });
	    
	    // 이전에 추가된 범례 레이어를 찾아서 제거
    map.getLayers().forEach(function (layer) {
        if (layer.get('name') === 'bjdLayer') {
            map.removeLayer(layer);
        }
    });
	    
	    // 새로운 시군구 레이어 생성
	    var newSggLayer = new ol.layer.Tile({
	        name: 'sggLayer', // 레이어의 이름을 설정하여 추후에 식별할 수 있도록 함
	        source: new ol.source.TileWMS({
	            url: 'http://localhost/geoserver/korea/wms?service=WMS',
	            params: {
	                'VERSION': '1.1.0',
	                'LAYERS': 'korea:tl_sgg',
	                'CQL_FILTER': "sgg_cd = " + sggValue,
	                'SRS': 'EPSG:3857',
	                'FORMAT': 'image/png'
	            },
	            serverType: 'geoserver',
	        })
	    });
	    map.addLayer(newSggLayer); // 맵 객체에 새로운 시군구 레이어를 추가함
	});
     
   //<!----------------------------------------------------------->
   //<!---------------------- 범례 ------------------------>
   //<!----------------------------------------------------------->
     $("#insertbtn").click(function() {
    	    // 기존에 추가된 시도 레이어가 있을 경우 제거
    	    var sdLayer = map.getLayers().getArray().find(function(layer) {
    	        return layer.get('name') === 'sdLayer';
    	    });
    	    if (sdLayer) {
    	        map.removeLayer(sdLayer);
    	    }
    	    
    	    // 기존에 추가된 시군구 레이어가 있을 경우 제거
    	    var sggLayer = map.getLayers().getArray().find(function(layer) {
    	        return layer.get('name') === 'sggLayer';
    	    });
    	    if (sggLayer) {
    	        map.removeLayer(sggLayer);
    	    }
    	    
    	    var sggValue = $("#sggSelect option:checked").val();
    	    if (!sggValue) {
    	        alert("시군구를 선택하세요.");
    	        return;
    	    }
    	    var sdValue = $("#sdSelect option:checked").val(); 
    	    if (!sdValue) { 
    	        alert("시도를 선택하세요."); 
    	        return;
    	    }
    	    
    	    
   	    var legend = $("#legendSelect").val();
   	    var sggValue = $("#sggSelect option:checked").val(); /* 아래에서 cql 필터로 걸러줄거 선언 */
           
   	    var style = (legend === "1") ? 'bjd_equal' : 'bjd_natural';
   	    alert((legend === "1") ? "등간격 스타일을 적용합니다." : "네추럴 브레이크 스타일을 적용합니다.");
   	    
   	    $.ajax({
   	        url: "/legend.do",
   	        type: 'POST',
   	        dataType: "json",
   	        data: { "legend": legend },
   	        success: function(result) {
   	        	// console.log(sggValue+"안녕");
   	            var newBjdLayer = new ol.layer.Tile({
   	                name: 'bjdLayer',
   	                source: new ol.source.TileWMS({
   	                	target: 'bjd_CQL',
   	                    url: 'http://localhost/geoserver/korea/wms?service=WMS',
   	                    params: {
   	                        'VERSION': '1.1.0',
   	                        'LAYERS': 'korea:b3_bjd_view',
   	                        'CQL_FILTER': "sgg_cd = " + sggValue,
   	                        'SRS': 'EPSG:3857',
   	                        'FORMAT': 'image/png',
   	                        'STYLES': style,
   	                    },
   	                    serverType : 'geoserver',
   	                })
   	            });
   	            map.addLayer(newBjdLayer);
   	        },
   	        error: function(){
   				alert("범례실패");
   	        }
   	    });
   	}); 
 });
  
</script>
<!----------------------------------------------------------->
<!----------------------- 차트 그리기 ----------------------->
<!----------------------------------------------------------->
<div id="chartContainer" style="width: 500px; height: 300px; margin-left:250px; margin-top:500px; background-color: white; display: none;">
    <canvas id="myChart"></canvas>
</div>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<script>
//메뉴 토글 기능 추가
$('#statistic').on('click', function() {
    // JSP 코드를 사용하여 chartData를 가져옵니다.
    $('#chartContainer').toggle();
    
    var chartData = [
        <c:forEach items="${chartData}" var="data">
            {
                sgg_cd: '<c:out value="${data.sgg_cd}"/>',
                total_used_kwh: '<c:out value="${data.total_used_kwh}"/>'
            },
        </c:forEach>
    ];

    var labels = chartData.map(function(item) { return item['sgg_cd']; }); // 'sgg_cd' 키로 변경
    var data = chartData.map(function(item) { return item['total_used_kwh']; }); // 'total_used_kwh' 키로 변경

    console.log(labels);
    console.log(data);
    
    var ctx = document.getElementById('myChart').getContext('2d');
    var myChart = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: labels,
            datasets: [{
                label: 'Total Used kWh',
                data: data, 
                backgroundColor: 'rgba(255, 99, 132, 0.2)',
                borderColor: 'rgba(255, 99, 132, 1)',
                borderWidth: 1
            }]
        },
        options: {
            scales: {
                yAxes: [{
                    ticks: {
                        beginAtZero:true
                    },
                    gridLines: {
                        display: false
                    }
                }],
                xAxes: [{
                    gridLines: {
                        display: false
                    }
                }]
            }
        }
    });
});
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
</body>
</html>

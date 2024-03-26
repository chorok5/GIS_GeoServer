<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>지도</title>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js" integrity="sha512-v2CJ7UaYy4JwqLDIrZUI/4hqeoQieOmAZNXBeQyjo21dadnwR+8ZaIJVT8EE2iyI61OV8e6M8PP2/4hpQINQ/g=="
	crossorigin="anonymous" referrerpolicy="no-referrer"></script>

<!-- <script type="text/javascript" src="resource/js/ol.js"></script> OpenLayer 라이브러리
<link href="resource/css/ol.css" rel="stylesheet" type="text/css" > OpenLayer css -->
<script src="https://cdn.jsdelivr.net/npm/ol@v9.0.0/dist/ol.js"></script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/ol@v9.0.0/ol.css">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<style type="text/css">
.map {
	height: 800px;
	width: 60%;
	float: right; /* 맵을 우측에 배치합니다. */
}

/* .select-box-container {
	display: flex;
	justify-content: left;
	align-items: left;
	height: 50vh;
} */
.select-box {
	margin: 0 20px;
}

.select-box-container {
	position: fixed;
	top: 0;
	left: 0;
	width: 100%;
	background-color: white;
	padding: 10px;
	display: flex;
	z-index: 1000; /* 옵션 선택 부분을 다른 요소들보다 위로 올립니다. */
}
</style>
</head>
<body>
	<div class="map-container">
		<div id="map" class="map"></div>
	</div>

	<div class="select-box-container">
		<div class="select-box">
			<h2>시도 선택</h2>
			<select id="sdSelect">
				<option value="">선택</option>
				<c:forEach var="row" items="${sdList}">
					<option value="${row.sd_nm}">${row.sd_nm}</option>
				</c:forEach>
			</select>
		</div>

		<div class="select-box">
			<h2>시군구 선택</h2>
			<select id="sggSelect">
				<option value="">선택</option>
				<c:forEach var="row" items="${sggList}">
					<option value="${row.sgg_nm}">${row.sgg_nm}</option>
				</c:forEach>
			</select>
		</div>

		<div class="select-box">
			<h2>법정동 선택</h2>
			<select id="bjdSelect">
				<option value="">선택</option>
				<c:forEach var="row" items="${bjdList}">
					<option value="${row.bjd_nm}">${row.bjd_nm}</option>
				</c:forEach>
			</select>
		</div>
	</div>
<hr>
<!-- 파일 업로드 폼 -->
	<form id="form" style="margin-top:300px;">
		<input type="file" id="file" name="file" accept="txt">
	</form>
            <button type="submit" id="fileBtn">업로드</button>
            
     
	<!------------------------------------------------------------------------------------------------>
	<!------------------------------------------------------------------------------------------------>
<script type="text/javascript">

// 파일 업로드 버튼 클릭 이벤트 핸들러
$("#fileBtn").on("click", function() {
    let fileName = $('#file').val();
    if (fileName == "") {
        alert("파일을 선택해주세요.");
        return false;
    }
    let dotName = fileName.substring(fileName.lastIndexOf('.') + 1).toLowerCase();
    if (dotName == 'txt') {
        $.ajax({
            url: './t-file2.do',
            type: 'POST',
            dataType: 'json',
            data: new FormData($('#form')[0]),
            cache: false,
            contentType: false,
            processData: false,
            enctype: 'multipart/form-data',
            success: function(result) {
                alert(result);
            },
            error: function(Data) {
            }
        });

    } else {
        alert("확장자가 안 맞으면 멈추기");
    }
});


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

    // 시도 선택 시 시군구 옵션 업데이트
    $('#sdSelect').on("change", function() {
        var sdValue = $(this).val(); 
        $.ajax({
            type: 'post',
            url: '/getSggList.do', 
            data: { 'sdValue': sdValue }, 
            dataType : "json",
            success: function(response) {

                // 시도에 해당하는 레이어 추가
                map.addLayer(new ol.layer.Tile({
                    source: new ol.source.TileWMS({
                        url: 'http://localhost/geoserver/korea/wms?service=WMS',
                        params: {
                            'VERSION': '1.1.0',
                            'LAYERS': 'korea:tl_sd',
                            'CQL_FILTER': "sd_nm LIKE '%" + sdValue + "%'",
                            'SRS': 'EPSG:3857',
                            'FORMAT': 'image/png'
                        },
                        serverType: 'geoserver'
                    }),
                    opacity: 0.5,
                }));
            }
        });
    });

    // 시군구 선택 시 법정동 옵션 업데이트
    $('#sggSelect').on("change", function() {
        var sggValue = $(this).val();
        $.ajax({
            type: 'post',
            url: '/getBjdList.do',
            data: { 'sggValue': sggValue },
            dataType: "json",
            success: function(response) {

                // 시군구에 해당하는 레이어 추가
                map.addLayer(new ol.layer.Tile({
                    source: new ol.source.TileWMS({
                        url: 'http://localhost/geoserver/korea/wms?service=WMS',
                        params: {
                            'VERSION': '1.1.0',
                            'LAYERS': 'korea:tl_sgg',
                            'CQL_FILTER': "sgg_nm LIKE '%" + sggValue + "%'",
                            'SRS': 'EPSG:3857',
                            'FORMAT': 'image/png'
                        },
                        serverType: 'geoserver'
                    }),
                    opacity: 0.5
                }));
            }
        });
     });
     });

</script>

</body>
</html>
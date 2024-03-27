<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>지도</title>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js" integrity="sha512-v2CJ7UaYy4JwqLDIrZUI/4hqeoQieOmAZNXBeQyjo21dadnwR+8ZaIJVT8EE2iyI61OV8e6M8PP2/4hpQINQ/g=="
	crossorigin="anonymous" referrerpolicy="no-referrer"></script>
<script src="https://cdn.jsdelivr.net/npm/ol@v9.0.0/dist/ol.js"></script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/ol@v9.0.0/ol.css">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
<link rel="stylesheet" type="text/css" href="/css/geo.css">

 
<style type="text/css">
.map {
	height: 800px;
	width: 60%;
	float: right; /* 맵을 우측에 배치합니다. */
}
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
/* 모달 CSS */
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
  padding: 20px;
  width: 80%;
  border: 1px solid #888;
}

.close {
  color: #aaa;
  float: right;
  font-size: 28px;
  font-weight: bold;
  cursor: pointer;
}

.close:hover,
.close:focus {
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
  background-color: #4caf50;
  border-radius: 10px;
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
<div id="dropArea" style="margin-top: 300px; width: 400px; border: 2px dashed #ccc; padding: 50px; text-align: center; cursor: pointer;">
<form id="form">
	<label for="file" class="file-label"></label>
  <input type="file" id="file" name="file" accept=".txt">
</form>
</div>
<button type="button" id="fileBtn" style="margin-top: 10px; padding: 10px 20px; background-color: #4CAF50; color: white; border: none; border-radius: 5px; cursor: pointer;">업로드</button>



<!-- 업로드 진행 폼 -->
<div id="progressModal" class="modal">
  <div class="modal-content">
    <span class="close">&times;</span>
    <p>업로드 진행률</p>
    <div class="progress-bar">
      <div id="progressBar" class="progress"></div>
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
            dataType: 'text', // 반환 타입 변경
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

	<!------------------------------------------------------------------------------------------------>
	<!------------------------------------------------------------------------------------------------>
	
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



// 시도 선택 시 시군구 옵션 업데이트
$('#sdSelect').on("change", function() {
    var sdValue = $(this).val(); 
    $.ajax({
        type: 'post',
        url: '/getSggList.do', 
        data: { 'sdValue': sdValue }, 
        dataType : "json",
        success: function(data) {
            var sggSelect = $('#sggSelect');
            sggSelect.empty(); // 기존 옵션 제거
            sggSelect.append('<option value="">선택</option>'); // 기본 선택 옵션 추가
            $.each(data, function(index, item) {
                sggSelect.append('<option value="' + item.sgg_nm + '">' + item.sgg_nm + '</option>'); // 응답으로 받은 데이터로 옵션 추가
            });


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
                opacity: 0.5
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
            var bjdSelect = $('#bjdSelect');
            bjdSelect.empty(); // 기존 옵션 제거
            bjdSelect.append('<option value="">선택</option>'); // 기본 선택 옵션 추가
            $.each(response, function(index, item) {
                bjdSelect.append('<option value="' + item.value + '">' + item.name + '</option>'); // 응답으로 받은 데이터로 옵션 추가
            });

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


<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>

</body>
</html>
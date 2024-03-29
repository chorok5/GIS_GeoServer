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
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
<!-- <link rel="stylesheet" type="text/css" href="/css/geo.css"> -->

 
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
}
</style>
</head>
<body>
<!------------------------------------------------------------------------------------------------->
<!----------------------------------------- 기본 맵 ----------------------------------------------->
<!------------------------------------------------------------------------------------------------->
	<div class="map-container">
		<div id="map" class="map"></div>
	</div>
	
<!------------------------------------------------------------------------------------------------->
<!---------------------------- 시도, 시군구, 법정동 셀렉트박스 ------------------------------------>
<!------------------------------------------------------------------------------------------------->	
	
	<!-- ${row.geom } 추가해야지 지도 이동됨.... -->
	
	<div class="select-box-container">
		<div class="select-box">
			<h2>시도 선택</h2>
			<select id="sdSelect">
				<option value="">선택</option>
				<c:forEach var="row" items="${sdList}">
					<option value="${row.sd_nm}, ${row.geom }">${row.sd_nm}</option>
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
					<option value="${row.bjd_nm}, ${row.geom }">${row.bjd_nm}</option>
				</c:forEach>
			</select>
		</div>
	</div>
<hr>
<!------------------------------------------------------------------------------------------------->
<!--------------------------------------- 파일 업로드 --------------------------------------------->
<!------------------------------------------------------------------------------------------------->

<!-- 파일 업로드 폼 -->
<div id="dropArea" style="margin-top: 300px; margin-left: 100px; width: 500px; border: 2px dashed #ccc; padding: 50px; text-align: center; cursor: pointer;">
<form id="form">
	<label for="file" class="file-label"></label>
  <input type="file" id="file" name="file" accept=".txt">
</form>
</div>
<button type="button" id="fileBtn" style="margin-top: 10px; margin-left: 100px; padding: 10px 20px; background-color: #4CAF50; color: white; border: none; border-radius: 5px; cursor: pointer;">업로드</button>

<!-- 업로드 진행 폼 -->
<div id="progressModal" class="modal">
  <div class="modal-content">
    <span class="close">&times;</span>
    <p>업로드 진행률</p>
    <div class="progress-bar">
      <div id="progressBar" class="progress">
      <h1>업로드 진행률</h1>
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

//레이어 변수 선언
var sdLayer; 
var sggLayer; 
var bjdLayer;

$('#sdSelect').on("change", function() {
    var selectSiValue = $(this).val().split(',')[0];
    // alert(selectSiValue);
    
    var sdValue = $(this).val(); 
    
    //--------------- 선택된 시/도의 geom값을 가져와서 지도에 표시 ---------------//
    var datas = $(this).val(); // value 값 가져오기
    var values = datas.split(",");
    var sdValue = values[0]; // sido 코드
       
    var geom = values[1]; // x 좌표
    // alert("sido 좌표값" + sdValue  + geom);
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
    
    //--------------- 시도 선택 시 시군구 불러오기 옵션 & 레이어 추가 ---------------//
    $.ajax({
        type: 'post',
        url: '/getSggList.do', 
        data: { 'sdValue': sdValue }, 
        dataType: "json",
        success: function(data) {
            var sggSelect = $('#sggSelect');
            sggSelect.empty();
            sggSelect.append('<option value="">선택</option>');
            $.each(data, function(index, item) {
                sggSelect.append('<option value="' + item.sgg_nm + '">' + item.sgg_nm + '</option>'); // 응답으로 받은 데이터로 옵션 추가
            });

            // 새로운 시도 레이어 생성
            var newSdLayer = new ol.layer.Tile({
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
            });

             // 기존에 추가된 시도 레이어가 있다면 삭제
            if (sdLayer) {
                map.removeLayer(sdLayer);         
            } 

            // 새로운 시도 레이어 변수에 할당
            sdLayer = newSdLayer;

            // 새로운 시도 레이어 추가
            map.addLayer(sdLayer);
            
            // 기존에 추가된 시군구 레이어가 있다면 삭제
            var sggLayerToRemove = map.getLayers().getArray().find(function(layer) {
                return layer.get('name') === 'sggLayer';
            });
            if (sggLayerToRemove) {
                map.removeLayer(sggLayerToRemove);
            }
        }
    });
});


//<!------------------------------------------------------------------------------------------------->
//<!-------------- 시군구 선택 시 법정동 옵션 업데이트 및 새로운 시군구 레이어 추가 ----------------->
//<!------------------------------------------------------------------------------------------------->
$('#sggSelect').on("change", function() {
    var sggValue = $(this).val();

    
    //--------------- 시군구 선택 시 법정동 불러오기 옵션 & 레이어 추가 ---------------//
    $.ajax({
        type: 'post',
        url: '/getBjdList.do',
        data: { 'sggValue': sggValue },
        dataType: "json",
        success: function(response) {
            var bjdSelect = $('#bjdSelect');
            bjdSelect.empty();
            bjdSelect.append('<option value="">선택</option>');
            $.each(response, function(index, item) {
                bjdSelect.append('<option value="' + item.value + '">' + item.name + '</option>'); // 응답으로 받은 데이터로 옵션 추가
            });
            
            
            // 기존에 추가된 시군구 레이어가 있다면 삭제
            var sggLayerToRemove = map.getLayers().getArray().find(function(layer) {
                return layer.get('name') === 'sggLayer';
            });
            if (sggLayerToRemove) {
                map.removeLayer(sggLayerToRemove);
            }

            // 새로운 시군구 레이어 생성
            var newSggLayer = new ol.layer.Tile({
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
            });

         // 새로운 시군구 레이어 변수에 할당
            newSggLayer.set('name', 'sggLayer'); // 레이어에 이름 설정
            map.addLayer(newSggLayer);
        }
    });
});


//<!------------------------------------------------------------------------------------------------->
//<!---------------------- 법정동 옵션 업데이트 및 새로운 시군구 레이어 추가 ------------------------>
//<!------------------------------------------------------------------------------------------------->
$('#bjdSelect').change(function() {
    var bjdSelectedValue = $(this).val().split(',')[0];
    var bjdSelectedText = $(this).find('option:selected').text();
    updateAddress(null, null, bjdSelectedText); //상단 법정동 노출

    //여기 좌표코드 설정
    var datas = $(this).val(); // value 값 가져오기
    var values = datas.split(",");
    var bjdValue = values[0]; // sido 코드

    var geom = values[1]; // x 좌표
    var regex = /POINT\(([-+]?\d+\.\d+) ([-+]?\d+\.\d+)\)/;
    var matches = regex.exec(geom);
    var xCoordinate, yCoordinate;

    if (matches) {
        xCoordinate = parseFloat(matches[1]); // x 좌표
        yCoordinate = parseFloat(matches[2]); // y 좌표
    } else {
        alert("GEOM값 가져오기 실패!");
    }

    var bjdCenter = ol.proj.fromLonLat([xCoordinate, yCoordinate]);
    map.getView().setCenter(bjdCenter); // 중심좌표 기준으로 보기
    map.getView().setZoom(13); // 중심좌표 기준으로 줌 설정


  //--------------- 법정동 불러오기 옵션 & 레이어 추가 ---------------//
            var newBjdLayer = new ol.layer.Tile({
                source: new ol.source.TileWMS({
                    url : 'http://localhost:8080/geoserver/korea/wms?service=WMS', // 1. 레이어 URL
                    params : {
                        'VERSION' : '1.1.0', // 2. 버전
                        'LAYERS' : 'korea:tl_bjd', // 3. 작업공간:레이어 명
                        'CQL_FILTER': "bjd_nm LIKE '%" + bjdValue + "%'",
                        'SRS': 'EPSG:3857',
                        'FORMAT': 'image/png'
                    },
                    serverType : 'geoserver',
                })
        });
         // 새로운 Bjd 레이어 변수에 할당
            newBjdLayer.set('name', 'bjdLayer'); // 레이어에 이름 설정
            map.addLayer(newBjdLayer);

});

});
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    	<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>

<style type="text/css">
#map-frame {
    height: 800px;
    width: 60%;  
    position: absolute;
    top: 90px;
    right : 10px;
    border: 1px solid #ccc; 
    box-sizing: border-box; 
    overflow: hidden;
}
.map {
position: relative;
    height: 100%; 
    width: 100%; 
}
.select-box {
	margin: 0 20px;
	margin-bottom: 20px;
	margin-left: 50px;
}
.select-box select {
  width: 200px; /* 모든 셀렉트 박스 너비 설정 */
}
.select-box-container {
	position: fixed;
	top: 100px;
	left: 180px;
	margin-right:0px;
    width: 500px;
    height: 900px;
	background-color: white;
	padding: 10px;
	display: none;
}
.insertbtn {
    position: absolute;
    top: 350px;
    left: 150px;
    transform: translate(-50%, -50%);
    border-radius: 5px;
    background-color: #B0CDFF;
    padding: 10px 20px;
    color: #2E2E2E;
    font-size: 16px;
    cursor: pointer;
    border: none;
}
.insertbtn:hover {
    background-color: #a9c7e3;
}
</style>
</head>
<body>
<!---------------------------------------------------------------------------->
<!---------------------------- 셀렉트박스 ------------------------------------>
<!---------------------------------------------------------------------------->

<div id="selectBoxContainer" class="select-box-container">
  <div class="select-box">
  <h5>시도 선택</h5>
    <select id="sdSelect">
      <option value="">시도 선택</option>
      <c:forEach var="row" items="${sdList}">
        <option value="${row.sd_cd}, ${row.geom }">${row.sd_nm}</option>  <!-- ${row.geom } 추가해야지 지도 이동됨.... -->
      </c:forEach>
    </select>
  </div>
  <br>
  <div class="select-box">
  <h5>시군구 선택</h5>
    <select id="sggSelect">
      <option value="">시군구 선택</option>
    </select>
  </div>
  <br>
  <div class="select-box">
  <h5>범례 선택</h5>
     <select id="legendSelect">
         <option value="default">범례 선택</option>
         <option value="1">등간격</option>
         <option value="2">내추럴 브레이크</option>
     </select>
  </div>
  <br>
  <button id="insertbtn" class="insertbtn">입력하기</button>
</div>

<!------------------------------------------------------------------------------------->
<!-------------------------------- OpenLayers MAP ------------------------------------->
<!------------------------------------------------------------------------------------->
<script type="text/javascript">
$(document).ready(function() {
	
let map = new ol.Map(
		{ 
			target : 'map', 
			layers : [ 
			new ol.layer.Tile(
		{
		source : new ol.source.OSM(
		{url : 'https://api.vworld.kr/req/wmts/1.0.0/5FEEDEDB-3705-3E32-8DC7-583B0B613B26/Base/{z}/{y}/{x}.png' // vworld의 지도를 가져온다.
		})
		}) ],
	view : new ol.View({ 
		center : ol.proj.fromLonLat([ 128.4,
				35.7 ]),
		zoom : 7
	})
});

$('#carbonMap').on("click", function() {
	
    document.getElementById("legendImageContainer1").style.display = "none";
    document.getElementById("legendImageContainer2").style.display = "none";
    
    // 시도 메뉴를 클릭했을 때 시군구 레이어가 있을 경우 제거
        map.getLayers().forEach(function (layer) {
        if (layer.get('name') === 'sdLayer') {
            map.removeLayer(layer);
        }
    });
    
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
    
//<!----------------------------------------------------------------------->
//<!---------------- #sdSelect 시도 선택 시 레이어 추가 ------------------->
//<!----------------------------------------------------------------------->    
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
    document.getElementById("legendImageContainer1").style.display = "none";
    document.getElementById("legendImageContainer2").style.display = "none";

    
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
    map.getView().setCenter(sidoCenter); 
    map.getView().setZoom(10); 
    
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
        		
        		// 시도 선택 시 범례 선택 상자를 초기화
                $('#legendSelect').val('default');
        	},
        	error : function(error){
                alert("문제발생"+error);
            }
    }); 
    map.addLayer(newSdLayer);
});

//<!------------------------------------------------------------------->
//<!-------------- #sggSelect 시군구 선택 레이어 추가 ----------------->
//<!------------------------------------------------------------------->
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
    document.getElementById("legendImageContainer1").style.display = "none";
    document.getElementById("legendImageContainer2").style.display = "none";

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
	    map.addLayer(newSggLayer); 
	});
     
//<!----------------------------------------------------------->
//<!---------------------- 범례 ------------------------>
//<!----------------------------------------------------------->
    $("#insertbtn").click(function() {
        var sdValue = $('#sdSelect').val().split(',')[0]; // 시도 코드
        var sggValue = $('#sggSelect').val(); // 시군구 코드
        var legendValue = $('#legendSelect').val(); // 범례 선택값
        
   	    // 기존에 추가된 시군구 레이어가 있을 경우 제거
   	    var sggLayer = map.getLayers().getArray().find(function(layer) {
   	        return layer.get('name') === 'sggLayer';
   	    });
   	    if (sggLayer) {
   	        map.removeLayer(sggLayer);
   	    }

  	    if (sdValue === '0' || sggValue === '0' || legendValue === '0') {
  	        alert("시도, 시군구, 범례를 모두 선택해주세요.");
  	        return;
  	    }

  	    var style = (legendValue === "1") ? 'bjd_equal' : 'bjd_natural';
  	    alert((legendValue === "1") ? "등간격 스타일을 적용합니다." : "네추럴 브레이크 스타일을 적용합니다.");
  	    var imageUrl = (legendValue === "1") ? 'img/bjd_equal.png' : 'img/bjd_natural.png';
  	    if (legendValue === "1") {
  	        $("#legendImageContainer1").show();
  	        $("#legendImageContainer2").hide();
  	    } else {
  	        $("#legendImageContainer1").hide();
  	        $("#legendImageContainer2").show();
  	    }
  	    
  	    $.ajax({
  	        url: "/legend.do",
  	        type: 'POST',
  	        dataType: "json",
  	        data: { "legend": legendValue },
  	        success: function(result) {
  	        	// console.log(sggValue+"안녕");
  	        	console.log(legendValue);
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
</body>
</html>
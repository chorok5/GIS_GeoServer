<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
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
<title>t-file.do</title>
<style>
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
 .fileform {
 	position: fixed;
	top: 100px;
	left: 180px;
	margin-right:0px;
    width: 500px;
    height: 900px;
	background-color: gray;
	padding: 10px;
	display: none;
 }
.dropArea {
    display: none;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    margin-top: 200px;
    margin-left: 50px;
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
</style>

<!------------------------------------------------------------------------------------------------->
<!--------------------------------------- 파일 업로드 --------------------------------------------->
<!------------------------------------------------------------------------------------------------->

<!-- 파일 업로드 폼 -->
<div class=fileform>
<div class="dropArea" id="dropArea">
<form id="form" style="width:400px; height:800px;">
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
</div>
</head>
<body>

<script type="text/javascript" charset="UTF-8">
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
</body>
</html>
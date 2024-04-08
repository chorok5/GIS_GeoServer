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
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<link href="https://fonts.googleapis.com/css?family=Roboto:300,400,400i,500'">
<link rel="stylesheet" type="text/css" href="/css/navbar.css">
<link rel="stylesheet" href="//cdn.jsdelivr.net/npm/xeicon@2.3.3/xeicon.min.css">
<link href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
<script src="https://cdn.rawgit.com/openlayers/openlayers.github.io/master/en/v6.15.1/build/ol.js"></script>
<script src="https://www.gstatic.com/charts/loader.js"></script>

<style type="text/css">
.header {
  position: fixed;
  top: 0;
  width: 100%;
  background-color: #f0f0f0;
  z-index: 1000; 
  }
.content {
margin-top: 100px;
padding: 20px; 
 }
#legendImageContainer1,
#legendImageContainer2 {
    position: fixed;
    right: 100px;
    bottom: 100px;
    z-index: 9999; 
}
</style>
</head>
<body>
<div class="header">
	<h1 style="height:50px">header</h1>
</div>

<div class="content">
<!------------------------------------------------------->
<!----------------------- 기본 맵 ----------------------->
<!------------------------------------------------------->
	<div class="map-container" id="map-frame">
		<div id="map" class="map"></div>
	</div>

<div id="sidebar">
    <c:import url="sidebar.jsp" />
</div>
</div>

<div id="legendImageContainer1" style="display: none;">
    <img id="legendImage" src="img/bjd_equal.png" alt="등간격">
</div>
<div id="legendImageContainer2" style="display: none;">>
    <img id="legendImage" src="img/bjd_natural.png" alt="내추럴">
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
</body>
</html>

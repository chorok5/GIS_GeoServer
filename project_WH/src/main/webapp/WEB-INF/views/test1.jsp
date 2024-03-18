var wmsSource = new ol.source.InageWMS({
	url : 'http://localhost/geoserver/topp/wms',
	params : {
		'service' : 'WMS',
		'request' : 'GetMap',
		'layers' : 'topp:3Astates',
		'SRS' : 'EPSG:4326',
		'format' : 'application/openlayers'

},
	serverType : 'geoserver'
});

var wmsLayer = new ol.layer.Image({
	name : "wmsLayer",
	source : wmsSource

});

map.addLayer(wmsLayer);



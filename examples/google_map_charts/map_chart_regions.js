google.load('visualization', '1', {'packages': ['geomap']});
   google.setOnLoadCallback(drawMap);

function drawMap() {
var data = google.visualization.arrayToDataTable([
	['Country', 'Users'],
		['US', 469],
		['GB', 71],
		['DE', 40],
		['CA', 40],
		['AU', 34],
		['SE', 14],
		['FR', 13],
		['ES', 11],
		['BR', 11],
		['PL', 9],
		['NO', 9],
		['NL', 9],
		['RU', 7],
		['PT', 7],
		['IN', 7],
		['AT', 7],
		['ZA', 5],
		['SG', 5],
		['RO', 4],
		['IT', 4],
		['IE', 4],
		['FI', 4],
		['DK', 4],
		['CN', 4],
		['UY', 3],
		['UA', 3],
		['NZ', 3],
		['CV', 3],
		['BE', 3],
		['AR', 3],
		['TH', 2],
		['SI', 2],
		['PK', 2],
		['MX', 2],
		['LK', 2],
		['JP', 2],
		['IS', 2],
		['HU', 2],
		['CH', 2],
		['YE', 1],
		['VN', 1],
		['TW', 1],
		['TR', 1],
		['SK', 1],
		['MY', 1],
		['MD', 1],
		['IL', 1],
		['HR', 1],
		['HK', 1],
		['GR', 1],
		['GD', 1],
		['EG', 1],
		['EE', 1],
		['BO', 1],
		['BM', 1],
	]);
	var options = {};
options['dataMode'] = 'regions';
options['width'] = '1000px';
options['height'] = '600px';
var container = document.getElementById('map_canvas_regions');
      var geomap = new google.visualization.GeoMap(container);
      geomap.draw(data, options);
};
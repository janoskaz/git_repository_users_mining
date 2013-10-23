google.load('visualization', '1', {'packages': ['geomap']});
   google.setOnLoadCallback(drawMap);

function drawMap() {
var data = google.visualization.arrayToDataTable([
	['X', 'Y', 'Users', 'Populated Area'],
		[37.77493, -122.41942, 1146, 'San Francisco Area'],
		[40.71427, -74.00597, 533, 'New York Area'],
		[47.60621, -122.33207, 306, 'Seattle'],
		[35.6895, 139.69171, 288, 'Tokyo'],
		[51.50853, -0.12574, 519, 'London Area'],
		[45.52345, -122.67621, 238, 'Portland'],
		[41.85003, -87.65005, 231, 'Chicago'],
		[52.52437, 13.41053, 227, 'Berlin'],
		[34.05223, -118.24368, 208, 'Los Angeles'],
		[43.70011, -79.4163, 191, 'Toronto'],
		[30.26715, -97.74306, 189, 'Austin'],
		[-33.86785, 151.20732, 160, 'Sydney'],
		[-23.5475, -46.63611, 159, 'São Paulo'],
		[-37.814, 144.96332, 152, 'Melbourne'],
		[48.85341, 2.3488, 144, 'Paris'],
		[42.35843, -71.05977, 244, 'Boston Area'],
		[49.24966, -123.11934, 127, 'Vancouver'],
		[39.73915, -104.9847, 184, 'Denver Area'],
		[33.749, -84.38798, 114, 'Atlanta'],
		[45.50884, -73.58781, 112, 'Montreal'],
		[59.33258, 18.0649, 107, 'Stockholm'],
		[38.89511, -77.03637, 102, 'Washington'],
		[59.91273, 10.74609, 95, 'Oslo'],
		[39.9075, 116.39723, 94, 'Beijing'],
		[55.75222, 37.61556, 89, 'Moscow'],
		[32.71533, -117.15726, 84, 'San Diego'],
		[39.95234, -75.16379, 78, 'Philadelphia'],
		[44.97997, -93.26384, 73, 'Minneapolis'],
		[-22.90278, -43.2075, 72, 'Rio de Janeiro'],
		[53.57532, 10.01534, 69, 'Hamburg'],
		[55.67594, 12.56553, 68, 'Copenhagen'],
		[29.76328, -95.36327, 62, 'Houston'],
		[32.78306, -96.80667, 59, 'Dallas'],
		[41.38879, 2.15899, 53, 'Barcelona'],
		[48.20849, 16.37208, 47, 'Vienna'],
		[40.76078, -111.89105, 44, 'Salt Lake City'],
		[40.4165, -3.70256, 44, 'Madrid'],
		[39.96118, -82.99879, 42, 'Columbus'],
		[53.33306, -6.24889, 40, 'Dublin'],
		[12.97194, 77.59369, 40, 'Bangalore'],
		[35.7721, -78.63861, 39, 'Raleigh'],
		[53.48095, -2.23743, 37, 'Manchester'],
		[36.17137, -86.78429, 33, 'Metropolitan Government of Nashville-Davidson (balance)'],
	]);
	var options = {};
options['dataMode'] = 'markers';
options['region'] = '021';
options['colors'] = [0xFF8747, 0xFFB581, 0xc06000];
options['width'] = '1000px';
options['height'] = '600px';
var container = document.getElementById('map_canvas_cities');
      var geomap = new google.visualization.GeoMap(container);
      geomap.draw(data, options);
};
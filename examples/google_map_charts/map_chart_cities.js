google.load('visualization', '1', {'packages': ['geomap']});
   google.setOnLoadCallback(drawMap);

function drawMap() {
var data = google.visualization.arrayToDataTable([
	['Country', 'Users'],
		['San Francisco', 382],
		['New York', 129],
		['Seattle', 112],
		['Chicago', 98],
		['Portland', 97],
		['London', 97],
		['City of London', 92],
		['Berlin', 81],
		['Los Angeles', 68],
		['Austin', 60],
		['Vancouver', 56],
		['Toronto', 56],
		['Denver', 52],
		['United Kingdom', 49],
		['Paris', 48],
		['Sydney', 47],
		['Melbourne', 46],
		['Montreal', 44],
		['Boston', 41],
		['Tokyo', 37],
		['Stockholm', 37],
		['Atlanta', 37],
		['Germany', 35],
		['Brooklyn', 32],
		['Washington', 31],
		['Oslo', 30],
		['Salt Lake City', 29],
		['Dallas', 29],
		['Boulder', 25],
		['Philadelphia', 24],
		['San Diego', 23],
		['Brazil', 23],
		['Vienna', 21],
		['Cambridge', 21],
		['Mountain View', 19],
		['Beijing', 19],
		['Palo Alto', 18],
		['Netherlands', 17],
		['Madrid', 17],
		['Houston', 17],
		['São Paulo', 16],
		['Barcelona', 16],
		['Singapore', 15],
		['San Jose', 15],
		['Moscow', 15],
		['Minneapolis', 14],
		['Bangalore', 13],
		['United States', 12],
		['Sweden', 12],
		['Hamburg', 12],
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
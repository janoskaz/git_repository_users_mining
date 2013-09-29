google.load('visualization', '1', {'packages': ['geomap']});
   google.setOnLoadCallback(drawMap);

function drawMap() {
var data = google.visualization.arrayToDataTable([
	['Country', 'Users'],
		['San Francisco', 89],
		['Portland', 25],
		['Seattle', 20],
		['New York', 19],
		['City of London', 18],
		['Chicago', 16],
		['Austin', 15],
		['London', 13],
		['Berlin', 13],
		['Melbourne', 11],
		['San Diego', 10],
		['United Kingdom', 9],
		['Los Angeles', 9],
		['Brooklyn', 9],
		['Sydney', 8],
		['Paris', 8],
		['Montreal', 8],
		['Washington', 7],
		['Vancouver', 7],
		['Stockholm', 7],
		['Oslo', 7],
		['Toronto', 6],
		['Orlando', 6],
		['Atlanta', 6],
		['Sweden', 5],
		['Singapore', 5],
		['Salt Lake City', 5],
		['Philadelphia', 5],
		['Houston', 5],
		['Vienna', 4],
		['Seville', 4],
		['Palo Alto', 4],
		['Germany', 4],
		['Columbus', 4],
		['Berkeley', 4],
		['Winnipeg', 3],
		['São Filipe', 3],
		['San Jose', 3],
		['Rochester', 3],
		['Rapid City', 3],
		['Raleigh', 3],
		['Perth', 3],
		['Ottawa', 3],
		['Mountain View', 3],
		['Kansas City', 3],
		['Edinburgh', 3],
		['Denver', 3],
		['Dallas', 3],
		['Buffalo', 3],
		['Boston', 3],
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
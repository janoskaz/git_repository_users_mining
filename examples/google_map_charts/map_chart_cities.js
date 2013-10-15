google.load('visualization', '1', {'packages': ['geomap']});
   google.setOnLoadCallback(drawMap);

function drawMap() {
var data = google.visualization.arrayToDataTable([
	['Country', 'Users'],
		['San Francisco', 811],
		['New York', 335],
		['Seattle', 251],
		['Tokyo', 222],
		['London', 218],
		['Portland', 210],
		['Chicago', 202],
		['City of London', 198],
		['Berlin', 184],
		['Los Angeles', 176],
		['Austin', 164],
		['Toronto', 156],
		['Melbourne', 129],
		['Sydney', 125],
		['United Kingdom', 119],
		['Germany', 113],
		['Paris', 112],
		['Boston', 110],
		['Denver', 106],
		['Brooklyn', 104],
		['Vancouver', 103],
		['Japan', 101],
		['Atlanta', 95],
		['Montreal', 91],
		['Brazil', 91],
		['Stockholm', 87],
		['Washington', 83],
		['Cambridge', 77],
		['San Diego', 76],
		['Beijing', 73],
		['Philadelphia', 66],
		['Oslo', 66],
		['Minneapolis', 60],
		['Boulder', 57],
		['Netherlands', 50],
		['Houston', 48],
		['Moscow', 47],
		['Hamburg', 45],
		['United States', 44],
		['Mountain View', 44],
		['Copenhagen', 43],
		['Salt Lake City', 40],
		['Dallas', 40],
		['Sweden', 38],
		['Palo Alto', 38],
		['São Paulo', 37],
		['Vienna', 36],
		['France', 35],
		['Barcelona', 35],
		['Sao Paolo', 34],
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
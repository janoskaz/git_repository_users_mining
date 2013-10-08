function init() {
// Instanciate sigma.js and customize rendering :
var sigInst = sigma.init(document.getElementById('sigma-example')).drawingProperties({
defaultLabelColor: '#fff',
defaultLabelSize: 14,
defaultLabelBGColor: '#fff',
defaultLabelHoverColor: '#000',
labelThreshold: 6,
defaultEdgeType: 'curve'
}).graphProperties({
minNodeSize: 2,
maxNodeSize: 10,
minEdgeSize: 1,
maxEdgeSize: 1,
sideMargin: 50
}).mouseProperties({
maxRatio: 32
});
 
// Parse a GEXF encoded file to fill the graph
// (requires "sigma.parseGexf.js" to be included)
sigInst.parseGexf('collaborators.gexf');

 // Bind events :
sigInst.bind('overnodes',function(event){
var nodes = event.content;
var neighbors = {};
sigInst.iterEdges(function(e){
if(nodes.indexOf(e.source)>=0 || nodes.indexOf(e.target)>=0){
neighbors[e.source] = 1;
neighbors[e.target] = 1;
}
}).iterNodes(function(n){
if(!neighbors[n.id]){
n.hidden = 1;
}else{
n.hidden = 0;
}
}).draw(2,2,2);
}).bind('outnodes',function(){
sigInst.iterEdges(function(e){
e.hidden = 0;
}).iterNodes(function(n){
n.hidden = 0;
}).draw(2,2,2);
});
 
// Draw the graph :
sigInst.draw();
}
 
if (document.addEventListener) {
document.addEventListener("DOMContentLoaded", init, false);
} else {
window.onload = init;
}
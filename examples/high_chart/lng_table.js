$(function () {
        $('#container').highcharts({
            chart: {
                type: 'column'
            },

            title:{text:'Languages used in repositories'},
    legend:{
        enabled:false
    },
            plotOptions: {
        column: {
            groupPadding: 0,
            pointPadding: 0,
            borderWidth: 0
        }
    },

            xAxis: {categories: [
'Ruby',
'JavaScript',
'Python',
'C',
'Perl',
'PHP',
'C++',
'Java',
'Objective-C',
'Emacs Lisp',
'Shell',
'VimL',
'Erlang',
'C#',
'Lua',
'Haskell',
'ActionScript',
'Common Lisp',
'Clojure',
'Scala',
'Scheme',
'Groovy',
'CSS',
'OCaml',
'Nu',
'Puppet',
'Io',
'Objective-J',
'R',
'Arc',
'D',
'Visual Basic',
'FORTRAN',
'Assembly',
'Go',
'Tcl',
'TypeScript',
'Matlab',
'VHDL',
'SuperCollider',
'ColdFusion',
'Verilog',
'Rust',
'Ragel in Ruby Host',
'Racket',
'Pure Data',
'Pascal',
'DOT',
'CoffeeScript',
'ASP',
]
, labels:{
            rotation:-90,
            y:40,
            style: {
                fontSize:'8px',
                fontWeight:'normal',
                color:'#333'
            },
        },
        lineWidth:0,
        lineColor:'#999',
        tickLength:90,
        tickColor:'#ccc',},
yAxis: {
                type: 'logarithmic',
                title: {
                    text: 'Number of Repositories '
                }
            },
series: [{ 
                data : [
{y: 14348, color: '#b50c01'}, {y: 3435, color: '#452e56'}, {y: 2000, color: '#031292'}, {y: 1287, color: '#28426b'}, {y: 1120, color: '#1087d0'}, {y: 1053, color: '#34354d'}, {y: 968, color: '#edf452'}, {y: 781, color: '#a32a36'}, {y: 438, color: '#fe9c49'}, {y: 395, color: '#b286a8'}, {y: 381, color: '#e975ea'}, {y: 347, color: '#f844ba'}, {y: 274, color: '#cf727b'}, {y: 200, color: '#d9ed75'}, {y: 196, color: '#511eee'}, {y: 176, color: '#e8c99f'}, {y: 137, color: '#a58710'}, {y: 90, color: '#d0bb06'}, {y: 75, color: '#2c4599'}, {y: 73, color: '#3b3784'}, {y: 63, color: '#c26d12'}, {y: 42, color: '#290c66'}, {y: 38, color: '#44da4b'}, {y: 35, color: '#b3819d'}, {y: 28, color: '#a41437'}, {y: 27, color: '#3be3f0'}, {y: 20, color: '#ad90f3'}, {y: 19, color: '#b0df5e'}, {y: 17, color: '#84ac27'}, {y: 16, color: '#22a998'}, {y: 14, color: '#0cd3e1'}, {y: 13, color: '#0f64a6'}, {y: 10, color: '#94eee7'}, {y: 9, color: '#0877cc'}, {y: 7, color: '#4a7765'}, {y: 6, color: '#dee011'}, {y: 5, color: '#8fec62'}, {y: 5, color: '#0013f4'}, {y: 4, color: '#32c4a6'}, {y: 3, color: '#ed5303'}, {y: 3, color: '#3c8625'}, {y: 2, color: '#27fabf'}, {y: 2, color: '#5b61a8'}, {y: 2, color: '#c29950'}, {y: 2, color: '#9f3884'}, {y: 2, color: '#2c7452'}, {y: 2, color: '#4c5ba7'}, {y: 2, color: '#186b79'}, {y: 2, color: '#0c4a43'}, {y: 2, color: '#19849c'}, ] }],});
    });
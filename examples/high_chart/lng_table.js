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
'Shell',
'Emacs Lisp',
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
'OCaml',
'CSS',
'Nu',
'Puppet',
'Objective-J',
'R',
'Io',
'Arc',
'D',
'Visual Basic',
'Assembly',
'Tcl',
'Go',
'FORTRAN',
'Matlab',
'TypeScript',
'VHDL',
'Pure Data',
'SuperCollider',
'ColdFusion',
'CoffeeScript',
'ASP',
'Verilog',
'Rust',
'Racket',
'Prolog',
'Eiffel',
'Delphi',
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
16063, 3965, 2364, 1503, 1305, 1263, 1109, 925, 552, 445, 434, 388, 315, 242, 226, 215, 164, 113, 97, 86, 75, 56, 41, 30, 29, 27, 24, 21, 20, 18, 16, 14, 10, 9, 7, 7, 6, 5, 4, 4, 3, 3, 3, 3, 2, 2, 2, 2, 2, 2, ] }],});
    });
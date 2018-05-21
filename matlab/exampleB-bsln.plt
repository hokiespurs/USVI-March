#!/gnuplot
set term wxt size 1400,800
set size 1,1
set title 'RTK Baseline' font ',18'
set xlabel 'GPS TOW [s]' font ',13'
set ylabel 'Baseline [m]' font ',13'
set grid
set mxtics 5
set mytics 5
set label 'Cyan - DGPS' at graph 0.03, graph 0.10
set label 'Blue - RTK Float' at graph 0.03, graph 0.07
set label 'Green - RTK Fixed' at graph 0.03, graph 0.04
plot '-' u 1:2:3 title 'Baseline Mode' with lines lc rgb var
e

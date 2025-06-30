reset
set terminal cairolatex size 11.5cm,4.5cm color
 
set output 'DvsDBS.tex'

set multiplot layout 1,2 margins 0.08,1,0.18,1 spacing 0.02,0

# First plot
set xlabel 'Dipole Strength (Debye)'
set ylabel 'DBS Binding Energy (meV)'
set pointsize 0.8
set xrange [1.5:3.7]
set mxtics 5
set mytics 2
set yrange [0:15]
set key at graph 0.8, graph 0.85 center
set label "Q0" at graph 0.1, graph 0.92 center

p 0 w l lc rgb 'black' notitle, \
    'Q0_xy.dat' u 5:(-$7*1000) w p t 'Region A' pt 13, \
    'Q0_z.dat' u 5:(-$7*1000) w p t 'Region B' pt 9 \

# Second plot

set ytics format ''
set xlabel 'Dipole Strength (Debye)'
unset ylabel
unset label
set label "Q1" at graph 0.1, graph 0.92 center

p 0 w l lc rgb 'black' notitle, \
    'Q1_xy.dat' u 5:(-$7*1000) w p t 'Region A' pt 13, \
    'Q1_zT.dat' u 5:(-$7*1000) w p t 'Region B' pt 9, \
    'Q1_zN.dat' u 5:(-$7*1000) w p t 'Region C' pt 11\

unset multiplot
set output
set terminal pop
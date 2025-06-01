reset
set terminal cairolatex size 6.5cm,6.5cm color 
set output 'DvsDBS.tex'

# First plot
set xlabel 'Dipole Strength (Debye)'
set ylabel 'DBS Binding Energy (meV)'
set pointsize 0.8
set xrange [1.5:3.7]
set yrange [0:15]
set key at graph 0.8, graph 0.85 center
set label "Q0" at graph 0.1, graph 0.92 center

p 0 w l lc rgb 'black' notitle, \
    'Q0_xy.dat' u 5:(-$7*1000) w p t 'Region A' pt 13, \
    'Q0_z.dat' u 5:(-$7*1000) w p t 'Region B' pt 9 \

set output
set terminal pop
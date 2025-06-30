reset
set terminal cairolatex size 13cm,4.5cm color
set output 'scan_DBS.tex'

set multiplot layout 1,2 margins 0.12,1,0.18,1 spacing 0.02,0
# First plot
set xlabel 'Distance (\AA)'
set ylabel 'Energy (meV)'
set yrange [-80:5]
set xrange [3:30]
set ytics 20
set mytics 4
set mxtics 5
set xtics
linew=3
set pointsize 0.5
unset key
set label "DBS Antiparallel" at graph 0.5, graph 0.1 center

p 'CH4.dat' u 1:($4*1000) w lp lw linew lc rgb "grey50" notitle, \
    'NH3_Hfirst.dat' u 1:($4*1000) w lp lw linew lc rgb "medium-blue" notitle, \
    'H2O_Hfirst.dat' u 1:($4*1000) w lp lw linew lc rgb "red" notitle, \
    'HF_Hfirst.dat' u 1:($4*1000) w lp lw linew lc rgb "web-green" notitle, \
    0 w l lw 1 lc rgb "black" notitle

#2nd plot
unset ylabel
set yrange [-80:5]
set xrange [3:30]
set ytics format ''
set key right center
unset label
set label "DBS Parallel" at graph 0.5, graph 0.1 center

p 'CH4.dat' u 1:($4*1000) w lp lw linew lc rgb "grey50" title '$\mathrm{CH}_4$', \
    'NH3_Nfirst.dat' u 1:($4*1000) w lp lw linew lc rgb "medium-blue" title '$\mathrm{NH}_3$', \
    'H2O_Ofirst.dat' u 1:($4*1000) w lp lw linew lc rgb "red" title '$\mathrm{H}_2\mathrm{O}$', \
    'HF_Ffirst.dat' u 1:($4*1000) w lp lw linew lc rgb "web-green" title '$\mathrm{HF}$', \
    0 w l lw 1 lc rgb "black" notitle

unset multiplot
set output
set terminal pop
reset
set terminal cairolatex size 12cm,5cm color 
set output 'scan_X.tex'

# First plot
set xlabel 'Distance (\AA)'
set ylabel 'Energy (meV)' offset -1,0
set yrange [-80:5]
set xrange [3:30]
set ytics 20
set xtics
linew=3
set pointsize 0.5
set key right bottom

p 'CH4.dat' u 1:($4*1000) w lp lw linew lc rgb "grey50" title '$\mathrm{CH}_2$', \
    'NH3_Hfirst.dat' u 1:($4*1000) w lp lw linew lc rgb "medium-blue" title '$\mathrm{NH}_3$', \
    'H2O_Hfirst.dat' u 1:($4*1000) w lp lw linew lc rgb "red" title '$\mathrm{H}_2\mathrm{O}$', \
    'HF_Hfirst.dat' u 1:($4*1000) w lp lw linew lc rgb "web-green" title '$\mathrm{HF}$', \
    0 w l lw 1 lc rgb "black" notitle

set output
set terminal pop
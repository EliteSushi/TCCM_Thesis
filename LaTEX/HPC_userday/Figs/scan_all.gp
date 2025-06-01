reset
set terminal cairolatex size 16cm,16cm 
set output 'scan_all.tex'

# Multiplot layout setup
set multiplot layout 4,1 margins 0.08,1,0.05,1 spacing 0,0.02

# First plot
#set xlabel 'Distance (\AA)'
set ylabel 'Energy (meV)' offset -1,0
set yrange [-65:5]
set xrange [3:30]
set xtics format ''
set ytics 15 format '%.0f'
linew=3
set pointsize 0.5
set key bottom right spacing 1.5
set label "DBS Opposing" at graph 0.5, graph 0.1 center

p 'CH4.dat' u 1:($4*1000) w lp lw linew lc rgb "grey50" title '$\mathrm{CH}_2$', \
    'NH3_Hfirst.dat' u 1:($4*1000) w lp lw linew lc rgb "medium-blue" title '$\mathrm{NH}_3$', \
    'H2O_Hfirst.dat' u 1:($4*1000) w lp lw linew lc rgb "red" title '$\mathrm{H}_2\mathrm{O}$', \
    'HF_Hfirst.dat' u 1:($4*1000) w lp lw linew lc rgb "web-green" title '$\mathrm{HF}$', \
    0 w l lw 1 lc rgb "black" notitle

# Second plot
set ylabel 'Energy (eV)' offset 0,0
set yrange [-2.6:-1.6]
set xrange [3:30]
set ytics 0.2 format "%.1f"
#set xtics format
#set xlabel 'Distance (\AA)'
unset label
unset key
set label "VBS Opposing" at graph 0.5, graph 0.1 center

p 'CH4.dat' u 1:($3) w lp lw linew lc rgb "grey50" notitle, \
    'H2O_Hfirst.dat' u 1:($3) w lp lw linew lc rgb "red" notitle, \
    'NH3_Hfirst.dat' u 1:($3) w lp lw linew lc rgb "medium-blue" notitle, \
    'HF_Hfirst.dat' u 1:($3) w lp lw linew lc rgb "web-green" notitle

# THIRD plot
#set xlabel 'Distance (\AA)'
set ylabel 'Energy (meV)' offset -1,0
set yrange [-80:5]
set xrange [3:30]
set ytics 20 format '%.0f'
set xtics format ''
linew=3
set pointsize 0.5
unset key
unset label
set label "DBS Parallel" at graph 0.5, graph 0.1 center

p 'CH4.dat' u 1:($4*1000) w lp lw linew lc rgb "grey50" notitle, \
    'H2O_Ofirst.dat' u 1:($4*1000) w lp lw linew lc rgb "red" notitle, \
    'NH3_Nfirst.dat' u 1:($4*1000) w lp lw linew lc rgb "medium-blue" notitle, \
    'HF_Ffirst.dat' u 1:($4*1000) w lp lw linew lc rgb "web-green" notitle, \
    0 w l lw 1 lc rgb "black" notitle

# Fourth plot
set ylabel 'Energy (eV)' offset 0,0
set yrange [-2:-1.4]
set xrange [3:30]
set ytics 0.2 format '%.1f'
unset label
set xtics format
set xlabel 'Distance (\AA)'
set label "VBS Parallel" at graph 0.5, graph 0.1 center

p 'CH4.dat' u 1:($3) w lp lw linew lc rgb "grey50" notitle, \
    'H2O_Ofirst.dat' u 1:($3) w lp lw linew lc rgb "red" notitle, \
    'NH3_Nfirst.dat' u 1:($3) w lp lw linew lc rgb "medium-blue" notitle, \
    'HF_Ffirst.dat' u 1:($3) w lp lw linew lc rgb "web-green" notitle


unset multiplot
set output
set terminal pop
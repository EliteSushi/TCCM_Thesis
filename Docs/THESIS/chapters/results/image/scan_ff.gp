reset
set terminal cairolatex size 16cm,14cm 
set output 'scan_all.tex'

#set terminal pngcairo size 1600,1600 enhanced font 'Arial,10'
#set output 'scan_all.png'

# Multiplot layout setup
set multiplot layout 3,2 margins 0.08,1,0.06,1 spacing 0.01,0.01

# First plot
#set xlabel 'Distance (\AA)'
set ylabel 'Energy (meV)' offset -1,0
set yrange [-80:5]
set xrange [3:30]
set xtics format ''
set mxtics 4
set mytics 3
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

# 2nd plot
#set xlabel 'Distance (\AA)'
set yrange [-80:5]
set xrange [3:30]
set ytics 20 format ''
unset ylabel
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

# 3rd plot

set ylabel 'Energy (eV)' offset 0,0
set yrange [-2.6:-1.4]
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

# Fourth plot
set yrange [-2.6:-1.4]
set xrange [3:30]
set ytics 0.2 format ''
unset ylabel
unset label
set xtics format ''
unset xlabel
set label "VBS Parallel" at graph 0.5, graph 0.1 center

p 'CH4.dat' u 1:($3) w lp lw linew lc rgb "grey50" notitle, \
    'H2O_Ofirst.dat' u 1:($3) w lp lw linew lc rgb "red" notitle, \
    'NH3_Nfirst.dat' u 1:($3) w lp lw linew lc rgb "medium-blue" notitle, \
    'HF_Ffirst.dat' u 1:($3) w lp lw linew lc rgb "web-green" notitle

#5h plot
set xtics format
set ytics 2 format "%.1f"
set xlabel 'Distance (\AA)'
set ylabel 'Energy (meV)'
set xrange [3:30]
set yrange [-8:0.5]
set key bottom right
unset label
set label "Interaction Energy Opposing" at graph 0.5, graph 0.1 center

# Plot differences from converged values
p 'CH4.dat' u 1:(($2+688.52387389)*1000) w lp lw linew lc rgb "grey50" notitle, \
    'H2O_Hfirst.dat' u 1:(($2+724.41877228)*1000) w lp lw linew lc rgb "red" notitle, \
    'NH3_Hfirst.dat' u 1:(($2+704.56189668)*1000) w lp lw linew lc rgb "medium-blue" notitle, \
    'HF_Hfirst.dat' u 1:(($2+748.41555763)*1000) w lp lw linew lc rgb "web-green" notitle, \
    0 w l lw 1 lc rgb "black" notitle

#6th plot
set xtics format
unset ylabel
set xlabel 'Distance (\AA)'
set xrange [3:30]
set yrange [-8:0.5]
set ytics 2 format ''
set key bottom right
unset label
set label "Interaction Energy Parallel" at graph 0.5, graph 0.1 center

# Plot differences from converged values
p 'CH4.dat' u 1:(($2+688.52387389)*1000) w lp lw linew lc rgb "grey50" notitle, \
    'H2O_Ofirst.dat' u 1:(($2+724.41877228)*1000) w lp lw linew lc rgb "red" notitle, \
    'NH3_Nfirst.dat' u 1:(($2+704.56189668)*1000) w lp lw linew lc rgb "medium-blue" notitle, \
    'HF_Ffirst.dat' u 1:(($2+748.41555763)*1000) w lp lw linew lc rgb "web-green" notitle, \
    0 w l lw 1 lc rgb "black" notitle

unset multiplot
set output
set terminal pop
reset
set terminal cairolatex size 4.85,2.43 
set output 'scan_X.tex'

# Multiplot layout setup
set multiplot layout 2,1 margins 0.1,0.98,0.15,0.98 spacing 0,0.03

# First plot
#set xlabel 'Distance (\AA)'
set ylabel 'Energy (meV)' offset -1,0
set yrange [-80:5]
set xrange [3:30]
set ytics 20 format '%.0f'
set xtics format ''
linew=3
set pointsize 0.5
unset key
set label "DBS Parallel" at graph 0.5, graph 0.1 center

p 'CH4.dat' u 1:($4*1000) w lp lw linew lc rgb "grey50" notitle, \
    'H2O_Ofirst.dat' u 1:($4*1000) w lp lw linew lc rgb "red" notitle, \
    'NH3_Nfirst.dat' u 1:($4*1000) w lp lw linew lc rgb "medium-blue" notitle, \
    'HF_Ffirst.dat' u 1:($4*1000) w lp lw linew lc rgb "web-green" notitle, \
    0 w l lw 1 lc rgb "black" notitle

# Second plot
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

# Third plot

#set xtics format
#set xlabel 'Distance (\AA)'
#set ylabel 'Energy (meV)'
#set xrange [3:30]
#set yrange [-6:0.5]
#set ytics 2
#set key bottom right
#unset label
#set label "Interaction Energy" at graph 0.5, graph 0.1 center

# Plot differences from converged values
#p 'CH4.dat' u 1:(($2+688.52387389)*1000) w lp lw linew lc rgb "grey50" title '$\mathrm{CH}_4$', \
#    'H2O_Ofirst.dat' u 1:(($2+724.41877228)*1000) w lp lw linew lc rgb "red" title '$\mathrm{H}_2\mathrm{O}$', \
#    'NH3_Nfirst.dat' u 1:(($2+704.56189668)*1000) w lp lw linew lc rgb "medium-blue" title '$\mathrm{NH}_3$', \
#    'HF_Ffirst.dat' u 1:(($2+748.41555763)*1000) w lp lw linew lc rgb "web-green" title 'HF', \
 #   0 w l lw 1 lc rgb "black" notitle
    
# End multiplot
unset multiplot
set output
set terminal pop
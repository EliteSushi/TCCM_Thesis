reset
set terminal cairolatex size 16cm,8cm color
set output 'ezDyson.tex'

# Multiplot layout setup
set multiplot layout 1,2 margins 0.06,1,0.1,1 spacing 0.02,0

# First plot
set xlabel '$\mathrm{E_I+E_k}$ (eV)'
set ylabel 'X sec  (a.u.)'
set xrange [0:10]
set pointsize 0.8
linew=3
set key at graph 0.8, graph 0.85 center
#set label "azulene" at graph 0.1, graph 0.92 center

p 'azulene_cc2_ccsd_hf.dat' u 6:7 w lp lw linew t'CC2', \
   '' u 13:14 w lp lw linew t 'CCSD', \
   '' u 20:21 w lp lw linew t 'HF'

# Second plot

set xlabel '$\mathrm{E_I+E_k}$ (eV)'
set xrange [0:2]
unset ylabel
set ytics format ''
#set label "nitromethane" at graph 0.1, graph 0.92 center

p 'nitromethane_cc2_ccsd_hf.dat' u 6:($7/1200*20) w lp lw linew t 'CC2', \
   '' u 13:($14/1200*20) w lp lw linew t 'CCSD', \
   '' u 20:($21/1200*20) w lp lw linew t 'HF'
    
# End multiplot
unset multiplot
set output
set terminal pop
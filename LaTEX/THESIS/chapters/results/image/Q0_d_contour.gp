reset

#variables for the plot
filename = 'Q0.dat' 
ncontour = 6
space_width = 18
offset = 75
set terminal cairolatex size 2.6, 2.475
set output 'Q0_d.tex'
gawk_script = 'cont.awk'

# Write the z(x,y) grid to a table
set table 'test.dat'
splot filename using 1:2:8
unset table

# Compute min and max from column 8
stats filename using 8 name 'Z'

# Define step size
zmin = Z_min
zmax = Z_max
zstep = (zmax - zmin) / ncontour

# Generate contours from the same grid
set dgrid3d 200,200 splines # denser grid and some smoothing
set contour base
#set cntrparam level incremental zmin, zstep, zmax
set cntrparam levels discrete 0.5, 1.0, 1.5, 2, 2.5, 3, 3.15
unset surface
set table 'cont_D.dat'
splot filename using 1:2:8
unset table
unset dgrid3d  # avoid affecting later plots


# plot — color map with contours
reset

set xrange [-180:180]
set yrange [-180:180]
unset ytics
unset xtics
unset key

# line styles
set palette defined ( 0 '#F7FCF5', 1 '#E5F5E0', 2 '#C7E9C0', 3 '#A1D99B', 4 '#74C476', 5 '#90ee90', 6 '#7cfc00', 7 '#008000' ) 

set size ratio -1

#set xlabel '{\normalsize $\Phi$}'
set title '{Dipole Strength (D)}'
unset colorbox
set rmargin 0
set lmargin 0.8
set tmargin 2.5
set bmargin 0 

# Plot
l '<'.sprintf('gawk -f %s cont_D.dat 0 %d %d 1 1', gawk_script, space_width, offset)
p 'test.dat' w ima, '<'.sprintf('gawk -f %s cont_D.dat 1 %d %d 1 1', gawk_script, space_width, offset) w l lt -1 lw 3.5 linecolor rgb "black"

unset output


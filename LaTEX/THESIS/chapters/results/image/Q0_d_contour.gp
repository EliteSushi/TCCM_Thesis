reset

#variables for the plot
filename = 'Q0.dat' 
ncontour = 6
space_width = 30
offset = 75
set terminal cairolatex size 4.3,3.1
set output 'Q0_d.tex'

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
set cntrparam level incremental zmin, zstep, zmax
unset surface
set table 'cont.dat'
splot filename using 1:2:8
unset table
unset dgrid3d  # avoid affecting later plots

# plot — color map with contours
reset

set xrange [-180:180]
set yrange [-180:180]
unset key

# line styles
set palette defined ( 0 '#F7FCF5', 1 '#E5F5E0', 2 '#C7E9C0', 3 '#A1D99B', 4 '#74C476', 5 '#90ee90', 6 '#7cfc00', 7 '#008000' ) 

set size ratio -1

set xlabel '$\Phi$'
set title 'Dipole field (Debye)'

l '<'.'./cont.sh cont.dat 0 '.space_width.' '.offset.' 1'
p 'test.dat' w ima, '<'.'./cont.sh cont.dat 1 '.space_width.' '.offset.' 1'  w l lt -1 lw 1.5

unset output


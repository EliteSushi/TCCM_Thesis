reset

#variables for the plot
filename = 'Q1.dat' 
ncontour = 6
space_width = 30
offset = 75
set terminal cairolatex size 2.8 ,2.9
set output 'Q1_d.tex'

# Write gawk script to file
gawk_script = 'cont_temp.awk'
set print gawk_script
    print "#!/usr/bin/gawk -f"
    print "BEGIN { d = ARGV[2]; w = ARGV[3]; os = ARGV[4]; ro = ARGV[5]; ARGV[2]=\"\"; ARGV[3]=\"\"; ARGV[4]=\"\"; ARGV[5]=\"\" }"
    print "function abs(x) { return (x>=0?x:-x) }"
    print "{"
    print "  if($0~/# Contour/ || $0 ~ /^$/) nr=0;"
    print "  if(nr==int(os+w/2) && d==0) {i++; a[i]=$1; b[i]=$2; c[i]=$3; r[i]==0}"
    print "  if(nr==int(os+w/2)-1 && d==0) {x = $1; y = $2;}"
    print "  if(nr==int(os+w/2)+1 && d==0 && ro==1) r[i]= 180.0*atan2(y-$2, x-$1)/3.14"
    print "  if(nr==int(os+w/2) && d==1) print \"\""
    print "  if(abs(nr-os-w/2)>w/2 && d==1) print $0"
    print "  nr++"
    print "}"
    print "END {"
    print "  if(d==0) {"
    print "    for(j=1;j<=i;j++)"
    print "      printf \"set label %d \\\"\\\\\\\\textcolor{black}{\\\\\\\\footnotesize %.1f}\\\" at %g, %g centre front rotate by %d\\n\", j, c[j], a[j], b[j], r[j]"
    print "  }"
    print "}"
unset print

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
set cntrparam levels discrete 0.5, 1.0, 1.5, 2, 2.5, 3, 3.3
unset surface
set table 'cont_D_Q1.dat'
splot filename using 1:2:8
unset table
unset dgrid3d  # avoid affecting later plots

# plot — color map with contours
reset

set xrange [-180:180]
set yrange [-180:180]
unset ytics
unset key

# line styles
set palette defined ( 0 '#F7FCF5', 1 '#E5F5E0', 2 '#C7E9C0', 3 '#A1D99B', 4 '#74C476', 5 '#90ee90', 6 '#7cfc00', 7 '#008000' ) 

set size ratio -1

set xlabel '{\normalsize $\Phi$}'
set title '{Dipole Strength (D)}'
unset colorbox
set rmargin 0
set lmargin 0.1

# Plot
l '<'.sprintf('gawk -f %s cont_D_Q1.dat 0 %d %d 1', gawk_script, space_width, offset)
p 'test.dat' w ima, '<'.sprintf('gawk -f %s cont_D_Q1.dat 1 %d %d 1', gawk_script, space_width, offset) w l lt -1 lw 3.5 linecolor rgb "black"

unset output


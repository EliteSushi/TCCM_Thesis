reset

#variables for the plot
filename = 'Q1_EOM_grid.dat' 
ncontour = 6
space_width = 10
offset = 30
set terminal cairolatex size 2.6 ,2.8
set output 'Q1_VBA.tex'

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

stats filename using (-$6) name 'Z'

# Generate contours from the same grid
set dgrid3d 100,100 splines 
set contour base
set cntrparam levels discrete 1.7, 1.6, 1.5, 1.4, 1.3, 1.2
unset surface
set table 'cont_VB.dat'
splot filename using 2:3:( ($6 != 0 ? -$6 : 1.6) )
unset table
unset dgrid3d 
reset

set palette defined (0 '#D3D3D3', 1.3 '#FF7F00', 1.4 '#FFFF00', 1.5 '#7FFF7F', 1.6 '#00FFFF', 1.7 '#3399FF', 1.8 '#6666FF', 1.9 '#0000FF')

set xrange [-180:180]
set yrange [-180:180]
unset key

set size ratio 1

set xlabel '{\normalsize $\Phi$}'
set ylabel '{\normalsize $\Psi$}' offset 2, 0
set title '{VBA EA (eV)}'
unset colorbox
set lmargin 3.5
set rmargin 0
set tmargin 2.5
set bmargin 2.5
set tics in
set tic scale 0.5

# Plot
l '<'.sprintf('gawk -f %s cont_VB.dat 0 %d %d 1', gawk_script, space_width, offset)
p filename u 2:3:(-$6) w ima, '<'.sprintf('gawk -f %s cont_VB.dat 1 %d %d 1', gawk_script, space_width, offset) w l lt -1 lw 3.5 linecolor rgb "black"

unset output


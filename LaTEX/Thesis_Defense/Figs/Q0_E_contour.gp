reset

# Variables
filename = 'Q0.dat'
ncontour = 8
space_width = 20
offset = 50
set terminal cairolatex size 6.5cm,6.5cm color
set output 'Q0_E.tex'

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
    print "      printf \"set label %d \\\"\\\\\\\\textcolor{black}{\\\\\\\\footnotesize %.0f}\\\" at %g, %g centre front rotate by %d\\n\", j, c[j], a[j], b[j], r[j]"
    print "  }"
    print "}"
unset print

# Compute min and max from column
stats filename using 4 name 'Z'
Eh2meV = 27211.4
zmin = 0
zmax = (Z_max - Z_min)*Eh2meV
zstep = (zmax - zmin) / ncontour

# Write grid for contour
set table 'test.dat'
splot filename using 1:2:(($4 - Z_min)*Eh2meV)
unset table

set dgrid3d 120,120 splines
set contour base
#set cntrparam level incremental zmin, zstep, zmax
set cntrparam levels discrete 50, 100, 200, 300,400, 500, 565
unset surface
set table 'cont.dat'
splot 'test.dat'
unset table
unset dgrid3d

# Final plot
reset
set xrange [-180:180]
set yrange [-180:180]
set xtics 60
unset colorbox
unset key


#set palette defined (0 '#00007F', 1 '#0000FF', 2 '#007FFF', 3 '#00FFFF', 4 '#7FFF7F', 5 '#FFFF00', 6 '#FF7F00', 7 '#FF0000')
set palette defined (0 '#0000FF', 1 '#6666FF', 2 '#3399FF', 3 '#00FFFF', 4 '#7FFF7F', 5 '#FFFF00', 6 '#FF7F00', 7 '#FF0000')
set size ratio 1
set xlabel '{\normalsize $\Phi$}'
set ylabel '{\normalsize $\Psi$}' offset 2, 0


# Plot
l '<'.sprintf('gawk -f %s cont.dat 0 %d %d 1', gawk_script, space_width, offset)
p 'test.dat' w ima, '<'.sprintf('gawk -f %s cont.dat 1 %d %d 1', gawk_script, space_width, offset) w l lt -1 lw 3.5 linecolor rgb "black"

unset output
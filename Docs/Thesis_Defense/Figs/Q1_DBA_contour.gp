reset

#variables for the plot
filename = 'Q1_EOM_grid.dat' 
ncontour = 6
space_width = 4
offset = 8
set terminal cairolatex size 2.6 ,2.8
set output 'Q1_DBA.tex'

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

set dgrid3d 100,100 splines
set contour base
set cntrparam levels discrete 1, 3, 6, 9, 12, 15.3
unset surface
set table 'cont_D_Q1.dat'
splot filename using 2:3:(-$7*1000)
unset table
unset dgrid3d

reset
set border front
set tics front
# Set custom palette
#-5 '#E0E0E0', 0 '#F0F0F0',
set palette defined (-10 '#D3D3D3', -5 '#D3D3D3', 0 '#D3D3D3', 2 '#FF7F00', 4 '#FFFF00', 6 '#7FFF7F', 8 '#00FFFF', 10 '#3399FF', 12 '#6666FF', 14 '#0000FF')

# Ensure color range includes both negative and positive sides
set cbrange [-10:14]

set xrange [-180:180]
set yrange [-180:180]
unset key

set size ratio 1

set xlabel '{\normalsize $\Phi$}'
set title '{DBA EA (meV)}'
unset colorbox
set xtics 60
set mxtics 3         
set ytics 40 format "" 
set mytics 2           
set rmargin 0
set lmargin 0.1
set tmargin 2.5
set bmargin 2.5

# Plot
l '<'.sprintf('gawk -f %s cont_D_Q1.dat 0 %d %d 1', gawk_script, space_width, offset)
p filename u 2:3:(-$7*1000) w ima, '<'.sprintf('gawk -f %s cont_D_Q1.dat 1 %d %d 1', gawk_script, space_width, offset) w l lt -1 lw 3.5 linecolor rgb "black"

unset output


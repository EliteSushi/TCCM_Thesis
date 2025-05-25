system 'gnuplot Q0_d_conotour.gp'
system 'gnuplot Q0_VBA_contour.gp'
reset
set terminal cairolatex size 4.85,4.85 
set output 'Q0_maps.tex'

gawk_script = 'cont.awk'

# Multiplot layout setup
set multiplot layout 2,2 margins 0.07,0.98,0.065,0.98 spacing 0.04,0.06

#  Energy PES plot
    filename = 'Q0.dat'
    space_width = 10
    offset = 50
    Eh2meV = 27211.4
    stats filename using 4 name 'Z'

    set dgrid3d 120,120 splines
    set contour base
    set cntrparam levels discrete 50, 100, 200, 300, 400, 500, 565
    unset surface
    set table 'cont_E.dat'
    splot filename using 1:2:(($4 - Z_min)*Eh2meV)
    unset table
    unset dgrid3d

    reset
    set size ratio 1
    set border front
    set tics front
    set xrange [-180:180]
    set yrange [-180:180]
    unset colorbox
    unset key
    set xtics 60 format ""
    set mxtics 3
    set ytics 40
    set mytics 2
    set palette defined (0 '#0000FF', 1 '#6666FF', 2 '#3399FF', 3 '#00FFFF', 4 '#7FFF7F', 5 '#FFFF00', 6 '#FF7F00', 7 '#FF0000')
    set ylabel '{\normalsize $\Psi$}' offset 2,0
    set title 'Conformational Energy (meV)'

    l '<'.sprintf('gawk -f %s cont_E.dat 0 %d %d 1 0', gawk_script, space_width, offset)
    p filename using 1:2:(($4 - Z_min)*Eh2meV) w image, \
    '<'.sprintf('gawk -f %s cont_E.dat 1 %d %d 1 0', gawk_script, space_width, offset) w l lt -1 lw 3.5 lc rgb "black"

#  Dipole Moment Plot
    filename = 'Q0.dat'
    space_width = 30
    offset = 75

    #set dgrid3d 100,100 splines
    #set contour base
    #set cntrparam levels discrete 0.5, 1.0, 1.5, 2, 2.5, 3, 3.15
    #unset surface
    #set table 'cont_D.dat'
    #splot filename using 1:2:8
    #unset table
    #unset dgrid3d

    reset
    set size ratio 1
    set border front
    set tics front
    set xrange [-180:180]
    set yrange [-180:180]
    unset colorbox
    unset key
    set xtics 60 format ""
    set mxtics 3
    set ytics 40 format ""
    set mytics 2
    set palette defined (0 '#F7FCF5', 1 '#E5F5E0', 2 '#C7E9C0', 3 '#A1D99B', 4 '#74C476', 5 '#90ee90', 6 '#7cfc00', 7 '#008000')
    set title '{Dipole Strength (D)}'

    l '<'.sprintf('gawk -f %s cont_D.dat 0 %d %d 1 1', gawk_script, space_width, offset)
    p filename using 1:2:8 w image, \
    '<'.sprintf('gawk -f %s cont_D.dat 1 %d %d 1 1', gawk_script, space_width, offset) w l lt -1 lw 3.5 lc rgb "black"

#  VBS Plot
    filename = 'Q0_CC2_comp.dat'
    space_width = 10
    offset = 30

    #set dgrid3d 100,100 splines
    #set contour base
    #set cntrparam levels discrete 1.7, 1.6, 1.5, 1.4, 1.3, 1.2
    #unset surface
    #set table 'cont_VB.dat'
    #splot filename using 2:3:(-$6)
    #unset table
    #unset dgrid3d

    reset
    set size ratio 1
    set border front
    set tics front
    set xrange [-180:180]
    set yrange [-180:180]
    unset colorbox
    unset key
    set xtics 60
    set mxtics 3
    set ytics 40
    set mytics 2
    set xlabel '{\normalsize $\Phi$}'
    set ylabel '{\normalsize $\Psi$}' offset 2,0
    set title '{VBA EA (eV)}'
    set palette defined (1.2 '#FF7F00', 1.3 '#FFFF00', 1.4 '#7FFF7F', 1.5 '#00FFFF', 1.6 '#3399FF', 1.7 '#6666FF', 1.8 '#0000FF')

    l '<'.sprintf('gawk -f %s cont_VB.dat 0 %d %d 1 1', gawk_script, space_width, offset)
    p filename using 2:3:(-$6) w image, \
    '<'.sprintf('gawk -f %s cont_VB.dat 1 %d %d 1 1', gawk_script, space_width, offset) w l lt -1 lw 3.5 lc rgb "black"

# 4 DBS Plot
    filename = 'Q0_CC2_comp.dat'
    space_width = 4
    offset = 8

    set dgrid3d 100,100 splines
    set contour base
    set cntrparam levels discrete 0, 3, 6, 9, 12, 15.3
    unset surface
    set table 'cont_DB.dat'
    splot filename using 2:3:(-$7*1000)
    unset table
    unset dgrid3d

    reset
    set size ratio 1
    set border front
    set tics front
    set xrange [-180:180]
    set yrange [-180:180]
    unset colorbox
    unset key
    set xtics 60
    set mxtics 3
    set ytics 40 format ""
    set mytics 2
    set xlabel '{\normalsize $\Phi$}'
    set title '{DBA EA (meV)}'
    set cbrange [-10:14]
    set palette defined (-10 '#D3D3D3', -5 '#D3D3D3', 0 '#D3D3D3', 2 '#FF7F00', 4 '#FFFF00', 6 '#7FFF7F', 8 '#00FFFF', 10 '#3399FF', 12 '#6666FF', 14 '#0000FF')

    l '<'.sprintf('gawk -f %s cont_DB.dat 0 %d %d 1 0', gawk_script, space_width, offset)
    p filename using 2:3:(-$7*1000) w image, \
    '<'.sprintf('gawk -f %s cont_DB.dat 1 %d %d 1 0', gawk_script, space_width, offset) w l lt -1 lw 3.5 lc rgb "black"

unset multiplot
unset output

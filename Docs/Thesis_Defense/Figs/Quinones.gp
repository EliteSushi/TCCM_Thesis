$data << EOD
  1    1.64  1.54  2.02  2.02  1.81 
  2    1.57   --   1.95  1.95  1.74 
  3    1.49  1.39  1.89  1.89  1.68 
  4    1.50  1.40  1.89  1.89  1.68 
  5    1.43  1.34  1.84  1.84  1.63 
  6    1.42  1.32  1.83  1.83  1.62 
  7    1.32  1.17  1.65  1.65  1.43 
  8    1.50  1.39  1.88  1.88  1.66 
  9    1.55   --   1.97  1.97  1.76 
  10   1.51  1.45  1.92  1.91  1.71 
EOD

set terminal cairolatex size 16cm,6cm color
set output 'Quinones.tex'
set xrange [1.3:1.65]
set yrange [1.1:2.1]

set xlabel 'Reference Energy (eV)'
set ylabel 'Method Energy (eV)'
set key bottom right

plot $data using 2:2:(sprintf("{\\\\color{gray}\\\\textbf{%d}}", $1)) with labels offset 0,0 notitle, \
     '' using 2:4:(sprintf("{\\\\color{blue}\\\\textbf{%d}}", $1)) with labels offset 0,0 notitle, \
     '' using 2:3:(sprintf("{\\\\color{red}\\\\textbf{%d}}", $1))  with labels offset 0,0 notitle, \
     '' using 2:6:(sprintf("{\\\\color{olive}\\\\textbf{%d}}", $1))  with labels offset 0,0 notitle, \
     x with p pt 0 linecolor rgb 'gray' linewidth 5 notitle, \
     NaN with lines linecolor rgb 'gray' linewidth 5 title 'Ref.', \
     NaN with lines linecolor rgb 'red'  linewidth 5 title 'SCS', \
     NaN with lines linecolor rgb 'blue' linewidth 5 title 'No SCS, VTZ', \
     NaN with lines linecolor rgb 'olive'  linewidth 5 title 'No SCS, VDZ'

unset output
